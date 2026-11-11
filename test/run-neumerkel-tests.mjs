#!/usr/bin/env node
import { NEUMERKEL_SOURCES, formatNeumerkelMarkdown, loadNeumerkelSources, materializeSyntaxCases, parseCleanupCases, parseDifCases } from './neumerkel.mjs';
import { executeWg17Item, matchesUpstreamExpectation } from './run-wg17.mjs';
import fs from 'node:fs';
import path from 'node:path';
import os from 'node:os';
import assert from 'node:assert/strict';
import { fileURLToPath } from 'node:url';
import { TestReporter, isMainModule, runStandalone } from './test-style.mjs';

const packageRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');

function syntaxHtml(count = 101) {
  const rows = [];
  for (let id = 1; id <= count; id++) {
    const query = id === 2 ? '/**/ writeq(a).' : id === 1 ? 'op(9,fy,x).' : 'true.';
    const expected = id === 2 ? 'a' : 'succeeds';
    rows.push(`<tr><td>${id}<td>${query}<td>${expected}`);
  }
  return `<table>${rows.join('')}</table>`;
}

function syntaxHtmlWithBareAnchors() {
  const rows = [];
  for (let id = 1; id <= 366; id++) rows.push(`<tr><td><a name=${id}>${id}</a><td>true.<td>succeeds`);
  for (let id = 367; id <= 376; id++) rows.push(`<td><a name=${id}>${id}</a><td>true.<td>succeeds`);
  return `<table><tr><td>number of conforming queries<td>376/376${rows.join('')}</table>`;
}

function sourceResponse(url, revision = 1) {
  const source = NEUMERKEL_SOURCES.find((item) => item.url === url);
  return new Response(Buffer.from(`${source.key} caf\u00e9 ${revision}`, 'latin1'), {
    headers: { 'content-type': 'text/plain; charset=ISO-8859-1' },
  });
}

async function withCache(run) {
  const temporary = fs.mkdtempSync(path.join(os.tmpdir(), 'eyeprolog-neumerkel-cache-'));
  try { await run(path.join(temporary, 'cache')); }
  finally { fs.rmSync(temporary, { recursive: true, force: true }); }
}

export async function runNeumerkelHarnessTests(reporter = new TestReporter()) {
  reporter.section('Neumerkel harness');

  await reporter.testAsync('missing upstream cache is downloaded once and warm runs preserve bytes and encoding without fetching', () => withCache(async (cacheDir) => {
    const requests = [];
    const first = await loadNeumerkelSources({ cacheDir, fetchSource: async (url) => { requests.push(url); return sourceResponse(url); } });
    assert.equal(requests.length, 8);
    const manifest = fs.readFileSync(path.join(cacheDir, 'manifest.json'), 'utf8');
    const warm = await loadNeumerkelSources({ cacheDir, fetchSource: async () => assert.fail('warm cache fetched upstream') });
    assert.equal(warm.get('syntax').text, 'syntax caf\u00e9 1');
    for (const source of NEUMERKEL_SOURCES) {
      assert.deepEqual(warm.get(source.key).bytes, first.get(source.key).bytes);
      assert.equal(warm.get(source.key).metadata.cached, true);
    }
    assert.equal(fs.readFileSync(path.join(cacheDir, 'manifest.json'), 'utf8'), manifest);
  }));

  await reporter.testAsync('missing or altered cached inputs rebuild the whole upstream snapshot', () => withCache(async (cacheDir) => {
    await loadNeumerkelSources({ cacheDir, fetchSource: async (url) => sourceResponse(url) });
    for (const damage of ['missing', 'altered']) {
      const filename = path.join(cacheDir, NEUMERKEL_SOURCES[0].filename);
      if (damage === 'missing') fs.rmSync(filename);
      else fs.writeFileSync(filename, 'changed input');
      let requests = 0;
      const restored = await loadNeumerkelSources({ cacheDir, fetchSource: async (url) => { requests++; return sourceResponse(url, 2); } });
      assert.equal(requests, 8);
      for (const source of NEUMERKEL_SOURCES) assert.equal(restored.get(source.key).text, `${source.key} caf\u00e9 2`);
    }
  }));

  await reporter.testAsync('explicit live refresh replaces a complete cache and cached mode reuses the new snapshot', () => withCache(async (cacheDir) => {
    await loadNeumerkelSources({ cacheDir, fetchSource: async (url) => sourceResponse(url) });
    let requests = 0;
    await loadNeumerkelSources({ mode: 'live', cacheDir, fetchSource: async (url) => { requests++; return sourceResponse(url, 2); } });
    assert.equal(requests, 8);
    const warm = await loadNeumerkelSources({ mode: 'cached', cacheDir, fetchSource: async () => assert.fail('cached mode fetched upstream') });
    assert.equal(warm.get('syntax').text, 'syntax caf\u00e9 2');
  }));

  await reporter.testAsync('cached mode rejects missing and damaged manifests without fetching', () => withCache(async (cacheDir) => {
    const options = { mode: 'cached', cacheDir, fetchSource: async () => assert.fail('cached mode fetched upstream') };
    await assert.rejects(loadNeumerkelSources(options), /cache manifest is missing/);
    await loadNeumerkelSources({ cacheDir, fetchSource: async (url) => sourceResponse(url) });
    fs.writeFileSync(path.join(cacheDir, 'manifest.json'), '{');
    await assert.rejects(loadNeumerkelSources(options), /cache manifest is missing or unreadable/);
    const restored = await loadNeumerkelSources({ cacheDir, fetchSource: async (url) => sourceResponse(url) });
    assert.equal(restored.size, 8);
  }));

  await reporter.testAsync('a late download failure keeps the complete previous cache unchanged', () => withCache(async (cacheDir) => {
    await loadNeumerkelSources({ cacheDir, fetchSource: async (url) => sourceResponse(url) });
    const before = fs.readFileSync(path.join(cacheDir, 'manifest.json'), 'utf8');
    const last = NEUMERKEL_SOURCES.at(-1).url;
    await assert.rejects(loadNeumerkelSources({ mode: 'live', cacheDir, fetchSource: async (url) => {
      if (url === last) throw new Error('upstream unavailable');
      return sourceResponse(url, 2);
    } }), /live fetch failed/);
    assert.equal(fs.readFileSync(path.join(cacheDir, 'manifest.json'), 'utf8'), before);
    const warm = await loadNeumerkelSources({ mode: 'cached', cacheDir });
    for (const source of NEUMERKEL_SOURCES) assert.equal(warm.get(source.key).text, `${source.key} caf\u00e9 1`);
    assert.deepEqual(fs.readdirSync(path.dirname(cacheDir)), ['cache']);
  }));

  await reporter.testAsync('source fixtures override cache loading without fetching or replacing the cache', () => withCache(async (cacheDir) => {
    const sourceDir = path.join(path.dirname(cacheDir), 'fixtures');
    fs.mkdirSync(sourceDir);
    for (const source of NEUMERKEL_SOURCES) fs.writeFileSync(path.join(sourceDir, source.filename), source.key);
    const loaded = await loadNeumerkelSources({ sourceDir, cacheDir, fetchSource: async () => assert.fail('source fixture fetched upstream') });
    assert.equal(loaded.get('syntax').metadata.sourceDir, true);
    assert.equal(fs.existsSync(cacheDir), false);
  }));

  reporter.test('live manifest tracks exactly eight upstream suite sources', () => {
    if (NEUMERKEL_SOURCES.length !== 8) throw new Error(`expected 8 sources, got ${NEUMERKEL_SOURCES.length}`);
    const keys = new Set(NEUMERKEL_SOURCES.map(({ key }) => key));
    if (keys.size !== 8) throw new Error('Neumerkel source keys are not unique');
  });

  reporter.test('syntax inventory is discovered dynamically and reconstructs /**/ setup', () => {
    const cases = materializeSyntaxCases(syntaxHtml());
    if (cases.length !== 101) throw new Error(`expected 101 cases, got ${cases.length}`);
    if (!cases[1].input.includes('op(9,fy,x)')) throw new Error('/**/ setup was not reconstructed');
  });

  reporter.test('syntax discovery includes bare anchored rows appended without tr', () => {
    const cases = materializeSyntaxCases(syntaxHtmlWithBareAnchors());
    if (cases.length !== 376) throw new Error(`expected 376 cases, got ${cases.length}`);
    if (cases.at(-1)?.id !== 376) throw new Error('last bare anchored syntax row was not discovered');
  });

  reporter.test('syntax discovery uses the Codex-labelled expected cell on malformed appended rows', () => {
    const rows = [];
    for (let id = 1; id <= 100; id++) rows.push(`<tr><td>${id}<td>true.<td class=codx>succeeds`);
    // A hand-edited row can acquire an extra cell before the semantic Codex
    // column. Positional extraction would incorrectly read "syntax err.".
    rows.push('<td><a name=101>101</a><td>writeq(a).<td>syntax err.<td class=codx>a<td>OK');
    const cases = materializeSyntaxCases(`<table>${rows.join('')}</table>`);
    const item = cases.find(({ id }) => id === 101);
    if (item?.expected !== 'a') {
      throw new Error(`expected Codex-labelled result, got ${JSON.stringify(item)}`);
    }
  });

  reporter.test('latest strict syntax allows Neumerkel #379 parenthesized --> atom', () => {
    // Upstream Codex expectation for #379: writeq((-->)/2). -> (-->)/2
    // (-->)/2 is valid: parentheses make --> an ordinary atom; only bare
    // --> followed by / in a predicate indicator is processor-defined syntax.
    const item = {
      id: 379,
      query: 'writeq((-->)/2).',
      input: 'writeq((-->)/2).',
      readCount: 1,
      expected: '(-->)/2',
    };
    const actual = executeWg17Item(item);
    if (!matchesUpstreamExpectation(item.expected, actual, item)) {
      throw new Error(`Neumerkel #379 did not match: ${JSON.stringify(actual)}`);
    }
  });

  reporter.test('syntax discovery fails loudly when a labelled live row loses its Codex cell', () => {
    const rows = [];
    for (let id = 1; id <= 100; id++) rows.push(`<tr><td>${id}<td>true.<td class=codx>succeeds`);
    rows.push('<td><a name=101>101</a><td>true.<td>succeeds');
    let caught = null;
    try {
      materializeSyntaxCases(`<table>${rows.join('')}</table>`);
    } catch (error) {
      caught = error;
    }
    if (!caught || !String(caught.message).includes('no labelled Codex cell')) {
      throw new Error(`missing Codex column was not rejected: ${caught?.message ?? 'no error'}`);
    }
  });

  reporter.test('dif table discovery uses upstream row ids and answer descriptions', () => {
    const cases = parseDifCases('<table><tr><td>1<td>?- dif(1,2).<td>true<tr><td>2<td>?- dif(X,X).<td>false</table>');
    if (cases.length !== 2 || cases[0].expected !== 'succeeds' || cases[1].expected !== 'fails') {
      throw new Error(`unexpected dif parse ${JSON.stringify(cases)}`);
    }
  });

  reporter.test('tracked Markdown report records dynamic counts without volatile metadata', () => {
    const summary = {
      syntax: { passed: 376, total: 376 },
      number_chars: { passed: 78, total: 78 },
      variable_names: { passed: 75, total: 75 },
      dif: { passed: 26, total: 26 },
      length: { passed: 37, total: 37 },
      phrase: { passed: 58, total: 58 },
      prologue: { passed: 33, total: 33 },
      cleanup: { passed: 25, total: 25 },
    };
    const text = formatNeumerkelMarkdown({
      summary,
      manifest: { fetchedAt: '2026-09-03T12:00:00.000Z', sources: [{ etag: '"volatile-tag"' }] },
    });
    if (!text.includes('**708/708**')) throw new Error('Markdown total is not derived from suite counts');
    if (!text.includes('| Prologue draft | 33 | 33 |')) throw new Error('prologue row missing');
    if (!text.includes('| setup_call_cleanup/3 | 25 | 25 |')) throw new Error('cleanup row missing');
    if (!text.includes('https://www.complang.tuwien.ac.at/ulrich/iso-prolog/conformity_testing')) throw new Error('upstream source link missing');
    if (text.includes('2026-09-03T12:00:00.000Z') || text.includes('volatile-tag')) {
      throw new Error('tracked Markdown must exclude volatile fetch metadata');
    }
  });

  reporter.test('release workflow refreshes upstream once and tests the same successful snapshot', () => {
    const pkg = JSON.parse(fs.readFileSync(path.join(packageRoot, 'package.json'), 'utf8'));
    const scripts = pkg.scripts ?? {};
    const releaseSteps = String(scripts.preversion ?? '').split(' && ');
    if (releaseSteps[0] !== 'node tools/generate-library-autoload-index.mjs' ||
        releaseSteps[1] !== 'node tools/generate-predicate-reference.mjs' ||
        releaseSteps[2] !== 'node tools/extract-book-examples.mjs') {
      throw new Error('preversion must regenerate the library index, predicate reference, and book examples first');
    }
    if (scripts.sync !== 'node test/run-neumerkel.mjs --live --update-report' ||
        scripts.neumerkel !== 'node test/run-neumerkel.mjs --live --verify-report' ||
        releaseSteps[3] !== 'npm run sync' || releaseSteps[4] !== 'npm test') {
      throw new Error('preversion must refresh upstream once and run npm test against the same cached snapshot');
    }
    if (releaseSteps[5] !== 'node test/run-conformance-report.mjs conformance-report.md' ||
        releaseSteps[6] !== 'git add src/library-autoload-index.js the-art-of-eyeprolog.md examples/book ' +
          'test/conformance/NEUMERKEL-LATEST.md conformance-report.md' || releaseSteps.length !== 7) {
      throw new Error('preversion must generate and stage the library index, book files, and both reports without another fetch');
    }
  });

  reporter.test('cleanup discovery follows the reference one-line example protocol', () => {
    const html = `<pre>
setup_call_cleanup(fail,_,_).
   Fails.
setup_call_cleanup(open(f,read,S),true,close(S)).
   Succeeds.
catch(setup_call_cleanup(true,throw(x),true),E,true).
   Succeeds.
catch(
  setup_call_cleanup(true,throw(x),true),
  E,true).
   Succeeds.
</pre>`;
    const cases = parseCleanupCases(html);
    if (cases.length !== 2) throw new Error(`expected 2 executable one-line non-file cases, got ${cases.length}`);
    if (cases[0].expected !== 'fails' || cases[1].expected !== 'succeeds') throw new Error('cleanup classification mismatch');
  });

  reporter.sectionTotal('Neumerkel harness');
}

if (isMainModule(import.meta.url)) await runStandalone(runNeumerkelHarnessTests);
