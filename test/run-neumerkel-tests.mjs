#!/usr/bin/env node
import { NEUMERKEL_SOURCES, formatNeumerkelMarkdown, materializeSyntaxCases, parseCleanupCases, parseDifCases } from './neumerkel.mjs';
import { executeWg17Item, matchesUpstreamExpectation } from './run-wg17.mjs';
import fs from 'node:fs';
import path from 'node:path';
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

export function runNeumerkelHarnessTests(reporter = new TestReporter()) {
  reporter.section('Neumerkel harness');

  reporter.test('live manifest tracks exactly seven upstream suite sources', () => {
    if (NEUMERKEL_SOURCES.length !== 7) throw new Error(`expected 7 sources, got ${NEUMERKEL_SOURCES.length}`);
    const keys = new Set(NEUMERKEL_SOURCES.map(({ key }) => key));
    if (keys.size !== 7) throw new Error('Neumerkel source keys are not unique');
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
      cleanup: { passed: 25, total: 25 },
    };
    const text = formatNeumerkelMarkdown({
      summary,
      manifest: { fetchedAt: '2026-09-03T12:00:00.000Z', sources: [{ etag: '"volatile-tag"' }] },
    });
    if (!text.includes('**675/675**')) throw new Error('Markdown total is not derived from suite counts');
    if (!text.includes('| setup_call_cleanup/3 | 25 | 25 |')) throw new Error('cleanup row missing');
    if (!text.includes('https://www.complang.tuwien.ac.at/ulrich/iso-prolog/conformity_testing')) throw new Error('upstream source link missing');
    if (text.includes('2026-09-03T12:00:00.000Z') || text.includes('volatile-tag')) {
      throw new Error('tracked Markdown must exclude volatile fetch metadata');
    }
  });

  reporter.test('release workflow reuses the successful live snapshot instead of refetching', () => {
    const pkg = JSON.parse(fs.readFileSync(path.join(packageRoot, 'package.json'), 'utf8'));
    const scripts = pkg.scripts ?? {};
    if (scripts['conformance:sync:neumerkel'] !== 'node test/run-neumerkel.mjs --cached --update-report') {
      throw new Error('Neumerkel sync must update from the cached successful live snapshot');
    }
    if (scripts['conformance:check:neumerkel'] !== 'node test/run-neumerkel.mjs --cached --verify-report') {
      throw new Error('Neumerkel report check must not refetch live upstream');
    }
    if (!String(scripts.preversion ?? '').includes('conformance:sync:neumerkel')) {
      throw new Error('preversion must synchronize the tracked report from the successful npm test snapshot');
    }
    if (String(scripts.preversion ?? '').includes('conformance:check:neumerkel')) {
      throw new Error('preversion must not perform a second report check/fetch cycle after synchronization');
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
