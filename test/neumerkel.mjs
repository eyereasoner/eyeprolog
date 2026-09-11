import crypto from 'node:crypto';
import fs from 'node:fs';
import path from 'node:path';
import os from 'node:os';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { Program, formatQuadTerm, run, runQuads } from '../src/index.js';
import {
  countTopLevelTerms,
  decodeDocument,
  htmlCellText,
  parseWg17SyntaxTable,
  setupInput,
} from '../tools/wg17-syntax.mjs';
import {
  executeWg17Item,
  matchesUpstreamExpectation,
  readWg17SyntaxOutcomes,
  wg17TestDescription,
} from './run-wg17.mjs';

const testRoot = path.dirname(fileURLToPath(import.meta.url));
const packageRoot = path.resolve(testRoot, '..');
const defaultCacheDir = path.join(packageRoot, '.cache', 'neumerkel');
export const NEUMERKEL_REPORT_PATH = path.join(packageRoot, 'test', 'conformance', 'NEUMERKEL-LATEST.md');
const baseUrl = 'https://www.complang.tuwien.ac.at/ulrich/iso-prolog/';

export const NEUMERKEL_SOURCES = Object.freeze([
  { key: 'syntax', filename: 'conformity_testing.html', url: `${baseUrl}conformity_testing`, kind: 'syntax' },
  { key: 'number_chars', filename: 'number_chars_cont_quad.pl', url: `${baseUrl}number_chars_cont_quad.pl`, kind: 'quad' },
  { key: 'variable_names', filename: 'variable_names_quad.pl', url: `${baseUrl}variable_names_quad.pl`, kind: 'quad' },
  { key: 'dif', filename: 'dif.html', url: `${baseUrl}dif`, kind: 'dif' },
  { key: 'length', filename: 'length_quad.pl', url: `${baseUrl}length_quad.pl`, kind: 'quad' },
  { key: 'phrase', filename: 'phrase_quad.pl', url: `${baseUrl}phrase_quad.pl`, kind: 'quad' },
  { key: 'prologue', filename: 'prologue_quad.pl', url: `${baseUrl}prologue_quad.pl`, kind: 'quad' },
  { key: 'cleanup', filename: 'cleanup.html', url: `${baseUrl}cleanup`, kind: 'cleanup' },
]);

function sha256(bytes) {
  return crypto.createHash('sha256').update(bytes).digest('hex');
}

function safeMkdir(dir) {
  fs.mkdirSync(dir, { recursive: true });
}

function sourceRevision(text) {
  const normalized = htmlCellText(text);
  const matches = [...normalized.matchAll(/\b(?:revision|version)\s+([0-9]+(?:\.[0-9]+)*)/gi)];
  return matches.at(-1)?.[1] ?? null;
}

async function fetchOne(source) {
  let response;
  try {
    response = await fetch(source.url, {
      headers: { 'user-agent': 'EyeProlog-Neumerkel-Conformance/1' },
      redirect: 'follow',
      cache: 'no-store',
    });
  } catch (error) {
    throw new Error(
      `Neumerkel live fetch failed for ${source.key} (${source.url}). ` +
      'The canonical conformance gate requires network access; use npm test -- --offline ' +
      'for a network-free local run or node test/run-neumerkel.mjs --cached to reproduce the last live fetch.',
      { cause: error },
    );
  }
  if (!response.ok) {
    throw new Error(`Neumerkel fetch failed for ${source.key} (${source.url}): ${response.status} ${response.statusText}`);
  }
  const bytes = new Uint8Array(await response.arrayBuffer());
  const contentType = response.headers.get('content-type') ?? '';
  return {
    bytes,
    text: decodeDocument(bytes, contentType),
    metadata: {
      key: source.key,
      url: source.url,
      filename: source.filename,
      sha256: sha256(bytes),
      bytes: bytes.byteLength,
      etag: response.headers.get('etag'),
      lastModified: response.headers.get('last-modified'),
      contentType,
    },
  };
}

function readCachedOne(source, cacheDir) {
  const filename = path.join(cacheDir, source.filename);
  if (!fs.existsSync(filename)) {
    throw new Error(`Neumerkel cache is incomplete: missing ${path.relative(packageRoot, filename)}; run node test/run-neumerkel.mjs online first`);
  }
  const bytes = new Uint8Array(fs.readFileSync(filename));
  return {
    bytes,
    text: decodeDocument(bytes, ''),
    metadata: {
      key: source.key,
      url: source.url,
      filename: source.filename,
      sha256: sha256(bytes),
      bytes: bytes.byteLength,
      cached: true,
    },
  };
}

function readSourceDirOne(source, sourceDir) {
  const filename = path.join(sourceDir, source.filename);
  if (!fs.existsSync(filename)) throw new Error(`missing Neumerkel source fixture: ${filename}`);
  const bytes = new Uint8Array(fs.readFileSync(filename));
  return {
    bytes,
    text: decodeDocument(bytes, ''),
    metadata: {
      key: source.key,
      url: source.url,
      filename: source.filename,
      sha256: sha256(bytes),
      bytes: bytes.byteLength,
      sourceDir: true,
    },
  };
}

export async function loadNeumerkelSources({ mode = 'live', cacheDir = defaultCacheDir, sourceDir = null } = {}) {
  const loaded = new Map();
  for (const source of NEUMERKEL_SOURCES) {
    const item = sourceDir != null
      ? readSourceDirOne(source, sourceDir)
      : mode === 'cached'
        ? readCachedOne(source, cacheDir)
        : await fetchOne(source);
    loaded.set(source.key, { ...source, ...item, localPath: sourceDir != null ? path.join(sourceDir, source.filename) : path.join(cacheDir, source.filename) });
  }

  if (mode === 'live' && sourceDir == null) {
    safeMkdir(cacheDir);
    for (const item of loaded.values()) fs.writeFileSync(path.join(cacheDir, item.filename), item.bytes);
    const fetchedAt = new Date().toISOString();
    const manifest = {
      schema: 1,
      policy: 'live Neumerkel sources fetched for this conformance run; cached copies are reproducibility aids only',
      fetchedAt,
      sources: [...loaded.values()].map((item) => ({
        ...item.metadata,
        revision: item.kind === 'syntax' || item.kind === 'cleanup' ? sourceRevision(item.text) : null,
      })),
    };
    fs.writeFileSync(path.join(cacheDir, 'manifest.json'), `${JSON.stringify(manifest, null, 2)}\n`);
  }

  return loaded;
}

export function materializeSyntaxCases(html) {
  const rows = parseWg17SyntaxTable(html);
  let precedingBaseQuery = null;
  return rows.map((row) => {
    const input = setupInput(row.query, precedingBaseQuery);
    const item = {
      id: row.id,
      query: row.query,
      input,
      readCount: countTopLevelTerms(input),
      expected: row.expected,
      assertion: 'upstream-live',
    };
    if (!row.query.includes('/**/')) precedingBaseQuery = row.query;
    return item;
  });
}

function htmlTableRows(html) {
  const rowStarts = [...html.matchAll(/<tr\b[^>]*>/gi)];
  const rows = [];
  for (let rowIndex = 0; rowIndex < rowStarts.length; rowIndex++) {
    const rowStart = rowStarts[rowIndex];
    const bodyStart = rowStart.index + rowStart[0].length;
    const nextRow = rowStarts[rowIndex + 1]?.index ?? html.length;
    const explicitEnd = html.slice(bodyStart, nextRow).search(/<\/tr\s*>/i);
    const rowEnd = explicitEnd < 0 ? nextRow : bodyStart + explicitEnd;
    const body = html.slice(bodyStart, rowEnd);
    const cellStarts = [...body.matchAll(/<t[dh]\b[^>]*>/gi)];
    const cells = [];
    for (let cellIndex = 0; cellIndex < cellStarts.length; cellIndex++) {
      const cellStart = cellStarts[cellIndex];
      const cellBodyStart = cellStart.index + cellStart[0].length;
      const cellEnd = cellStarts[cellIndex + 1]?.index ?? body.length;
      cells.push(body.slice(cellBodyStart, cellEnd));
    }
    rows.push(cells);
  }
  return rows;
}

function stripPromptAndDot(query) {
  return String(query)
    .replace(/^\s*\?-\s*/, '')
    .trim()
    .replace(/\.\s*$/, '')
    .trim();
}

function classifyDifExpected(text) {
  const expected = String(text).replace(/\s+/g, ' ').trim();
  if (expected.length === 0) return null;
  if (expected.includes('|')) return 'lenient';
  if (/^(?:false|fails?)\b/i.test(expected)) return 'fails';
  if (/^(?:true|succeeds?)\b/i.test(expected)) return 'succeeds';
  if (expected.includes('=')) return 'succeeds';
  return 'lenient';
}

export function parseDifCases(html) {
  const result = [];
  const seen = new Set();
  for (const cells of htmlTableRows(html)) {
    if (cells.length < 3) continue;
    const idText = htmlCellText(cells[0]).replace(/^#\s*/, '').trim();
    if (!/^\d+$/.test(idText)) continue;
    const id = Number(idText);
    if (seen.has(id)) continue;
    const query = stripPromptAndDot(htmlCellText(cells[1]));
    const expectedText = htmlCellText(cells[2]);
    const expected = classifyDifExpected(expectedText);
    if (!query || expected == null) continue;
    result.push({ id, query, expected, expectedText });
    seen.add(id);
  }
  if (result.length === 0) throw new Error('no Neumerkel dif/2 cases found; upstream HTML format may have changed');
  return result;
}

function htmlToText(html) {
  return html
    .replace(/<!--[^]*?-->/g, '')
    .replace(/<br\s*\/?>/gi, '\n')
    .replace(/<\/(?:p|div|pre|li|blockquote|h[1-6]|table|tr)>/gi, '\n')
    .replace(/<[^>]+>/g, '')
    .replace(/&nbsp;/gi, ' ')
    .replace(/&amp;/gi, '&')
    .replace(/&lt;/gi, '<')
    .replace(/&gt;/gi, '>')
    .replace(/&quot;/gi, '"')
    .replace(/&#39;|&apos;/gi, "'")
    .replace(/&#(\d+);/g, (_, n) => String.fromCodePoint(Number(n)))
    .replace(/&#x([0-9a-f]+);/gi, (_, n) => String.fromCodePoint(Number.parseInt(n, 16)))
    .replace(/\r\n?/g, '\n');
}

function classifyCleanupDescription(text) {
  const first = String(text).trim();
  if (/^Fails\b/i.test(first)) return 'fails';
  if (/^Instantiation error\b/i.test(first)) return 'instantiation_error';
  if (/^Type error\b/i.test(first)) return 'type_error';
  if (/^System error\b/i.test(first)) return 'error';
  if (/^Succeeds\b/i.test(first)) return 'succeeds';
  return 'lenient';
}

export function parseCleanupCases(html) {
  const lines = htmlToText(html).split('\n');
  const cases = [];
  for (let index = 0; index < lines.length; index++) {
    const line = lines[index].trimEnd();
    const trimmed = line.trim();
    if (!trimmed.includes('setup_call_cleanup') || !trimmed.endsWith('.')) continue;
    // Match the reference extraction protocol: only complete one-line example
    // goals are executable. Multi-line prose examples remain specification
    // evidence but are not silently reassembled by the harness.
    if (/^setup_call_cleanup\b/.test(trimmed) === false && /^catch\(.*setup_call_cleanup/.test(trimmed) === false) continue;
    const goal = trimmed.slice(0, -1).trim();
    if (/\bopen\s*\(/.test(goal)) continue;

    let description = '';
    for (let next = index + 1; next < lines.length; next++) {
      const candidate = lines[next];
      if (candidate.trim() === '') continue;
      description = candidate.trim();
      break;
    }
    if (!description) continue;
    cases.push({ id: cases.length + 1, goal, expected: classifyCleanupDescription(description), description });
  }
  if (cases.length === 0) throw new Error('no Neumerkel setup_call_cleanup/3 examples found; upstream HTML format may have changed');
  return cases;
}

function executeGoal(goal) {
  try {
    const result = run('', { goal: `once((${goal}))` });
    return result.stats.completed_goal_lists > 0 ? { type: 'succeeds' } : { type: 'fails' };
  } catch (error) {
    const formal = String(error?.formal ?? error?.message ?? error);
    if (/instantiation_error/.test(formal)) return { type: 'instantiation_error', formal };
    if (/type_error/.test(formal)) return { type: 'type_error', formal };
    return { type: 'error', formal };
  }
}

function expectedMatches(expected, actual) {
  if (expected === 'lenient') return true;
  if (expected === 'error') return ['error', 'instantiation_error', 'type_error'].includes(actual.type);
  return expected === actual.type;
}

// A permanent, deliberate divergence from an upstream quad: EyeProlog's own
// implementation choice, not a bug to chase. Keyed by corpus key, then by the
// answer description's source line. It is still reported and counted as an
// ordinary failing test (so the totals stay honest and it self-corrects the
// moment it stops reproducing, exactly as happened with the length corpus's
// occurs-check quad); it just does not abort the run the way an unexplained
// failure would.
const KNOWN_QUAD_DIVERGENCES = {
  prologue: new Map([
    [118, 'bounded=false: EyeProlog reports no max_integer value at all (ISO 7.11.1.1), ' +
      'so this quad\'s evaluation_error(int_overflow) | Max = unbounded pair never applies'],
  ]),
};

// Report each answer description as its own test, the same way the syntax and
// dif cases below do, instead of one aggregate pass/fail line for the whole
// corpus: a single upstream change then points straight at the one quad that
// moved instead of leaving a reader to dig through a raw quad-report string.
function runQuadCorpus(reporter, label, item, knownDivergences = new Map()) {
  const scratch = fs.mkdtempSync(path.join(os.tmpdir(), 'eyeprolog-neumerkel-'));
  const previousCwd = process.cwd();
  let result;
  let program;
  try {
    // These upstream quad files assume the Prologue predicates are available
    // as system predicates and carry no use_module/1 directive of their own,
    // the same reason the CLI's -q mode prepends this for a quad file (see
    // src/cli.js). Parse against the real package root so library/module
    // resolution keeps working, then only switch directories for execution:
    // some upstream option tests deliberately open a relative file named `f`,
    // and EyeProlog's file predicates resolve against process.cwd(). Isolate
    // that in a scratch cwd so conformance cannot dirty the checkout.
    // A separate source part (rather than a concatenated prelude line) keeps
    // the quad file's own line numbers unshifted for reporting.
    const source = fs.readFileSync(item.localPath, 'utf8');
    program = Program.parseSources([
      { text: ':- use_module(library(prologue)).\n', filename: '<quad-prelude>' },
      { text: source, filename: item.localPath, baseDir: packageRoot },
    ]);
    process.chdir(scratch);
    result = runQuads(program);
  } finally {
    process.chdir(previousCwd);
    fs.rmSync(scratch, { recursive: true, force: true });
  }

  const failures = [];
  let passed = 0;
  result.results.forEach((description, index) => {
    const locator = description.id != null ? formatQuadTerm(program, description.id) : `#${index + 1}`;
    const divergence = knownDivergences.get(description.line);
    const name = divergence == null
      ? `${label} ${locator} (line ${description.line ?? '?'}) ?- ${formatQuadTerm(program, description.query)}`
      : `${label} ${locator} (line ${description.line ?? '?'}, documented divergence: ${divergence}) ?- ${formatQuadTerm(program, description.query)}`;
    try {
      reporter.test(name, () => {
        if (!description.ok) {
          const reason = description.reason ? `: ${description.reason}` : '';
          throw new Error(`${description.kind ?? 'failed'}${reason}`);
        }
      });
      passed++;
    } catch (error) {
      // A documented divergence is expected to keep failing; note it without
      // aborting the run over it. Upstream changes otherwise often arrive in
      // small clusters -- keep running the corpus so one live test run
      // exposes every new mismatch instead of forcing a fix/rerun cycle for
      // each row.
      if (divergence == null) failures.push(error);
    }
  });
  return { total: result.results.length, passed, failures };
}

export async function executeNeumerkel({ reporter, mode = 'live', cacheDir = defaultCacheDir, sourceDir = null } = {}) {
  const sources = await loadNeumerkelSources({ mode, cacheDir, sourceDir });
  const summary = {};

  reporter.section(`Neumerkel conformity (${mode === 'live' && sourceDir == null ? 'live upstream' : sourceDir != null ? 'source fixtures' : 'cached'})`);

  const syntaxCases = materializeSyntaxCases(sources.get('syntax').text);
  const syntaxOutcomes = readWg17SyntaxOutcomes();
  const syntaxFailures = [];
  let syntaxPassed = 0;
  for (const item of syntaxCases) {
    try {
      reporter.test(`syntax ${wg17TestDescription(item)}`, () => {
        const actual = executeWg17Item(item);
        if (!matchesUpstreamExpectation(item.expected, actual, item)) {
          throw new Error(`syntax #${item.id} expected ${item.expected}; actual ${JSON.stringify(actual)}`);
        }
        // A case can also carry a reviewed exact-behavior lock (see
        // wg17-syntax-outcomes.json): a stronger regression check than the
        // upstream assertion alone, catching a change that still happens to
        // satisfy the loose Codex expectation.
        const reviewed = syntaxOutcomes.get(item.id);
        if (reviewed != null && JSON.stringify(actual) !== JSON.stringify(reviewed)) {
          throw new Error(
            `syntax #${item.id} reviewed outcome changed; expected ${JSON.stringify(reviewed)}; actual ${JSON.stringify(actual)}`,
          );
        }
      });
      syntaxPassed++;
    } catch (error) {
      // Upstream changes often arrive in small clusters. Keep running the
      // syntax inventory so one live test run exposes every new mismatch
      // instead of forcing a fix/rerun cycle for each row.
      syntaxFailures.push(error);
    }
  }
  summary.syntax = { passed: syntaxPassed, total: syntaxCases.length };
  if (syntaxFailures.length > 0) {
    throw new AggregateError(
      syntaxFailures,
      `${syntaxFailures.length} live Neumerkel syntax case${syntaxFailures.length === 1 ? '' : 's'} failed`,
    );
  }

  const quadFailures = [];
  for (const key of ['number_chars', 'variable_names', 'length', 'phrase', 'prologue']) {
    const { total, passed, failures } = runQuadCorpus(
      reporter, key.replace('_', ' '), sources.get(key), KNOWN_QUAD_DIVERGENCES[key],
    );
    summary[key] = { passed, total };
    quadFailures.push(...failures);
  }
  if (quadFailures.length > 0) {
    throw new AggregateError(
      quadFailures,
      `${quadFailures.length} live Neumerkel quad case${quadFailures.length === 1 ? '' : 's'} failed`,
    );
  }

  const difCases = parseDifCases(sources.get('dif').text);
  for (const item of difCases) {
    reporter.test(`dif #${item.id} ${item.query}`, () => {
      const actual = executeGoal(item.query);
      if (!expectedMatches(item.expected, actual)) {
        throw new Error(`dif #${item.id} expected ${item.expected} (${item.expectedText}); actual ${JSON.stringify(actual)}`);
      }
    });
  }
  summary.dif = { passed: difCases.length, total: difCases.length };

  const cleanupCases = parseCleanupCases(sources.get('cleanup').text);
  for (const item of cleanupCases) {
    reporter.test(`cleanup #${item.id} ${item.goal}`, () => {
      const actual = executeGoal(item.goal);
      if (!expectedMatches(item.expected, actual)) {
        throw new Error(`cleanup #${item.id} expected ${item.expected} (${item.description}); actual ${JSON.stringify(actual)}`);
      }
    });
  }
  summary.cleanup = { passed: cleanupCases.length, total: cleanupCases.length };

  reporter.sectionTotal('live Neumerkel conformity');

  const cacheManifest = path.join(cacheDir, 'manifest.json');
  const cachedManifest = fs.existsSync(cacheManifest) ? JSON.parse(fs.readFileSync(cacheManifest, 'utf8')) : null;
  const manifest = sourceDir != null
    ? {
        schema: 1,
        policy: 'local source fixtures used for this conformance run',
        fetchedAt: null,
        sources: [...sources.values()].map((item) => ({
          ...item.metadata,
          revision: item.kind === 'syntax' || item.kind === 'cleanup' ? sourceRevision(item.text) : null,
        })),
      }
    : cachedManifest;
  if (mode === 'live' && sourceDir == null && manifest != null) {
    fs.writeFileSync(path.join(cacheDir, 'results.json'), `${JSON.stringify({
      schema: 1,
      fetchedAt: manifest.fetchedAt,
      summary,
      sourceSha256: Object.fromEntries(manifest.sources.map((source) => [source.key, source.sha256])),
    }, null, 2)}\n`);
  }

  const reportText = formatNeumerkelMarkdown({ summary, manifest });
  return { summary, manifest, cacheDir, reportPath: NEUMERKEL_REPORT_PATH, reportText };
}

export function formatNeumerkelSummary(summary) {
  const labels = [
    ['syntax', 'syntax'],
    ['number_chars', 'number_chars/2'],
    ['variable_names', 'variable_names/1'],
    ['dif', 'dif/2'],
    ['length', 'length/2'],
    ['phrase', 'phrase/2,3'],
    ['prologue', 'Prologue draft'],
    ['cleanup', 'setup_call_cleanup/3'],
  ];
  return labels.map(([key, label]) => {
    const row = summary[key];
    return `${label.padEnd(22)} ${row.passed}/${row.total}`;
  }).join('\n');
}

export function formatNeumerkelMarkdown({ summary }) {
  const labels = [
    ['syntax', 'syntax'],
    ['number_chars', 'number_chars/2'],
    ['variable_names', 'variable_names/1'],
    ['dif', 'dif/2'],
    ['length', 'length/2'],
    ['phrase', 'phrase/2,3'],
    ['prologue', 'Prologue draft'],
    ['cleanup', 'setup_call_cleanup/3'],
  ];
  const rows = labels.map(([key, label]) => ({ key, label, ...summary[key] }));
  const passed = rows.reduce((sum, row) => sum + row.passed, 0);
  const total = rows.reduce((sum, row) => sum + row.total, 0);
  const divergenceCount = Object.values(KNOWN_QUAD_DIVERGENCES)
    .reduce((sum, byLine) => sum + byLine.size, 0);
  const shortfall = total - passed;
  // A shortfall fully accounted for by known, documented divergences (see
  // KNOWN_QUAD_DIVERGENCES and the list below) is not a build failure; any
  // other shortfall is.
  const status = shortfall === 0
    ? 'PASS'
    : shortfall === divergenceCount
      ? `PASS — ${shortfall} divergence${shortfall === 1 ? '' : 's'} to be addressed`
      : 'FAIL';
  const lines = [
    '# EyeProlog — latest Neumerkel conformity',
    '',
    `Status: **${status}** — **${passed}/${total}** discovered upstream cases passed.`,
    '',
    'This tracked report records the latest upstream inventory successfully checked by EyeProlog.',
    '`npm test` fetches the eight TU Wien sources again and executes the discovered cases.',
    'Release/report checks can additionally require these tracked counts to match the live suites.',
    'Counts are output from upstream, not hard-coded test constants.',
    '',
    '| Suite | Passed | Total |',
    '|---|---:|---:|',
  ];
  for (const row of rows) lines.push(`| ${row.label} | ${row.passed} | ${row.total} |`);
  lines.push(`| **Total** | **${passed}** | **${total}** |`);

  if (divergenceCount > 0) {
    lines.push('', '## Known divergences', '');
    for (const [key, byLine] of Object.entries(KNOWN_QUAD_DIVERGENCES)) {
      const label = labels.find(([labelKey]) => labelKey === key)?.[1] ?? key;
      for (const [line, reason] of byLine) lines.push(`- **${label}** (line ${line}): ${reason}`);
    }
  }

  lines.push(
    '',
    '## Upstream sources',
    '',
  );
  for (const source of NEUMERKEL_SOURCES) lines.push(`- [${source.key}](${source.url})`);

  lines.push(
    '',
    'Exact fetched bytes, SHA-256 hashes, fetch timestamps, and HTTP validators remain under',
    'Git-ignored `.cache/neumerkel/` for local inspection/reproduction and are intentionally not committed.',
    'A normal test run warns when this tracked report is stale. Refresh directly from live',
    'upstream with `node test/run-neumerkel.mjs --update-report`, or sync the exact successful',
    'snapshot already fetched by `npm test` with `node test/run-neumerkel.mjs --cached --update-report`.',
    '`node test/run-neumerkel.mjs --cached --verify-report` verifies the tracked report against that last',
    'successful live snapshot without fetching upstream a second time.',
    '',
  );
  return `${lines.join('\n')}\n`;
}


