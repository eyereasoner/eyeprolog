#!/usr/bin/env node
// Refresh the vendored WG17 conformity fixtures from their public upstream
// tables. The vendored snapshot remains an offline deterministic regression layer; the release gate also runs live upstream suites.
import crypto from 'node:crypto';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';

const packageRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const syntaxSource = 'https://www.complang.tuwien.ac.at/ulrich/iso-prolog/conformity_testing';
const syntaxFixturePath = path.join(packageRoot, 'test', 'conformance', 'wg17-syntax-cases.json');
const syntaxCoveragePath = path.join(packageRoot, 'test', 'conformance', 'wg17-syntax-coverage.json');
const syntaxStatusPath = path.join(packageRoot, 'test', 'conformance', 'WG17-SYNTAX-STATUS.md');
const conformanceReportPath = path.join(packageRoot, 'conformance-report.md');
const countDocumentationPaths = [
  path.join(packageRoot, 'test', 'conformance', 'README.md'),
  path.join(packageRoot, 'test', 'conformance', 'ISO-COMPLIANCE.md'),
];

const namedEntities = new Map([
  ['amp', '&'], ['lt', '<'], ['gt', '>'], ['quot', '"'], ['apos', "'"],
  ['nbsp', '\u00a0'], ['ndash', '–'], ['mdash', '—'], ['minus', '−'],
  ['hellip', '…'], ['middot', '·'], ['times', '×'], ['laquo', '«'], ['raquo', '»'],
  ['sup2', '²'], ['sup3', '³'], ['deg', '°'],
]);

export function decodeHtmlEntities(text) {
  return text.replace(/&(#(?:x[0-9a-f]+|\d+)|[a-z][a-z0-9]+);/gi, (whole, entity) => {
    if (entity[0] === '#') {
      const hex = entity[1]?.toLowerCase() === 'x';
      const value = Number.parseInt(entity.slice(hex ? 2 : 1), hex ? 16 : 10);
      if (Number.isInteger(value) && value >= 0 && value <= 0x10ffff) return String.fromCodePoint(value);
      return whole;
    }
    return namedEntities.get(entity.toLowerCase()) ?? whole;
  });
}

function withoutPresentationMarkup(html) {
  return html
    .replace(/<!--[\s\S]*?-->/g, '')
    .replace(/<sup\b[^>]*>[\s\S]*?<\/sup>/gi, '')
    .replace(/<br\s*\/?>/gi, '\n')
    .replace(/<\/(?:p|div|pre|li|blockquote)>/gi, '\n')
    .replace(/<(?:p|div|pre|li|blockquote)\b[^>]*>/gi, '')
    .replace(/<[^>]+>/g, '');
}

export function htmlCellText(html) {
  return decodeHtmlEntities(withoutPresentationMarkup(html))
    .replace(/\r\n?/g, '\n')
    .replace(/\n{3,}/g, '\n\n')
    .trim();
}

function deletedRow(rowHtml, idCellHtml) {
  return /<(?:del|s|strike)\b/i.test(idCellHtml) ||
    /class\s*=\s*["'][^"']*\b(?:deleted|obsolete|removed)\b/i.test(rowHtml);
}

function cellsFromChunk(body) {
  const cellStarts = [...body.matchAll(/<t[dh]\b[^>]*>/gi)];
  const cells = [];
  for (let cellIndex = 0; cellIndex < cellStarts.length; cellIndex++) {
    const cellStart = cellStarts[cellIndex];
    const cellBodyStart = cellStart.index + cellStart[0].length;
    const cellEnd = cellStarts[cellIndex + 1]?.index ?? body.length;
    cells.push({
      openTag: cellStart[0],
      body: body.slice(cellBodyStart, cellEnd),
    });
  }
  return cells;
}

function cellHasClass(cell, className) {
  const escaped = className.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const quoted = new RegExp(`\\bclass\\s*=\\s*[\"']([^\"']*)[\"']`, 'i').exec(cell.openTag)?.[1] ?? '';
  if (quoted.split(/\s+/).some((part) => part.toLowerCase() === className.toLowerCase())) return true;
  return new RegExp(`\\bclass\\s*=\\s*${escaped}(?:\\s|>|$)`, 'i').test(cell.openTag);
}

function htmlTableRows(html) {
  // TU Wien intentionally serves very small, old-style HTML. In valid HTML,
  // </td> and </tr> are optional, and the conformity page currently relies
  // on that. Do not require explicit closing tags here: split on start tags
  // and let the next cell/row start imply the end of the previous one.
  const rowStarts = [...html.matchAll(/<tr\b[^>]*>/gi)];
  const rows = [];
  for (let rowIndex = 0; rowIndex < rowStarts.length; rowIndex++) {
    const rowStart = rowStarts[rowIndex];
    const bodyStart = rowStart.index + rowStart[0].length;
    const nextRow = rowStarts[rowIndex + 1]?.index ?? html.length;
    const explicitEnd = html.slice(bodyStart, nextRow).search(/<\/tr\s*>/i);
    const rowEnd = explicitEnd < 0 ? nextRow : bodyStart + explicitEnd;
    const rowHtml = html.slice(rowStart.index, rowEnd);
    const body = html.slice(bodyStart, rowEnd);
    rows.push({ start: rowStart.index, rowHtml, cells: cellsFromChunk(body) });
  }
  return rows;
}

function htmlAnchoredSyntaxRows(html) {
  // The conformity page is hand-edited old-style HTML. New rows are sometimes
  // appended as bare `<td><a name=N>` anchors without a surrounding `<tr>`.
  // Treat every numbered first-cell anchor as a row boundary so new upstream
  // cases cannot be silently glued to the previous row.
  const anchors = [...html.matchAll(/<td\b[^>]*>\s*<a\b[^>]*\bname\s*=\s*["']?\d+["']?[^>]*>/gi)];
  const rows = [];
  for (let index = 0; index < anchors.length; index++) {
    const start = anchors[index].index;
    const end = anchors[index + 1]?.index ?? html.length;
    const rowHtml = html.slice(start, end);
    rows.push({ start, rowHtml, cells: cellsFromChunk(rowHtml) });
  }
  return rows;
}

function declaredSyntaxTotal(html) {
  const marker = html.search(/number of conforming queries/i);
  if (marker < 0) return null;
  const text = decodeHtmlEntities(html.slice(marker, marker + 2000).replace(/<[^>]+>/g, ' '));
  const match = text.match(/(\d+)\s*\/\s*(\d+)/);
  return match == null ? null : Number(match[2]);
}

export function parseWg17SyntaxTable(html) {
  const cases = [];
  const seen = new Set();
  // Real TU Wien conformity rows label the standards/Codex expectation. If
  // the page uses that label anywhere, require it for every numbered test
  // row instead of silently falling back to a physical column position.
  const labelledCodexPage = /<t[dh]\b[^>]*\bclass\s*=\s*(?:["'][^"']*\bcodx\b[^"']*["']|codx(?:\s|>|$))/i.test(html);
  // Merge ordinary `<tr>` rows with numbered first-cell anchors in document
  // order. The anchor view supplies hand-appended rows that omit `<tr>`; the
  // normal view still handles fixtures/pages without named anchors.
  const rows = [...htmlTableRows(html), ...htmlAnchoredSyntaxRows(html)]
    .sort((a, b) => a.start - b.start);
  const byId = new Map();
  for (const { rowHtml, cells } of rows) {
    if (cells.length < 3 || deletedRow(rowHtml, cells[0].body)) continue;

    const idText = htmlCellText(cells[0].body).replace(/^#\s*/, '');
    const idMatch = idText.match(/^(\d+)$/);
    if (idMatch == null) continue;
    const id = Number(idMatch[1]);

    // TU Wien uses non-breaking spaces for table presentation/indentation.
    // They are not part of the Prolog source being specified, so normalize
    // them to ordinary spaces before snapshotting/comparing rows.
    const query = htmlCellText(cells[1].body).replace(/\u00a0/g, ' ');
    // Do not assume the Codex/expected result is physically the third cell.
    // The live TU Wien page is hand-edited old-style HTML and newly appended
    // rows can have malformed/extra cells.  The semantic column is explicitly
    // marked class=codx upstream, so prefer that marker and only fall back to
    // position 3 for small synthetic fixtures/older snapshots without classes.
    const codexCell = cells.find((cell) => cellHasClass(cell, 'codx'));
    if (labelledCodexPage && codexCell == null) {
      throw new Error(`WG17 syntax row #${id} has no labelled Codex cell; upstream HTML format may have changed`);
    }
    const expectedCell = codexCell ?? cells[2];
    const expected = htmlCellText(expectedCell.body).replace(/\u00a0/g, ' ').replace(/[²³°]/g, '').replace(/[ \t\n]+/g, ' ').trim();
    if (query.length === 0 || expected.length === 0) continue;
    if (seen.has(id)) {
      const previous = byId.get(id);
      if (previous.query !== query || previous.expected !== expected) {
        throw new Error(`duplicate active WG17 syntax id #${id} in upstream table`);
      }
      continue;
    }
    const item = { id, query, expected };
    cases.push(item);
    byId.set(id, item);
    seen.add(id);
  }
  if (cases.length < 100) {
    const trCount = [...html.matchAll(/<tr\b/gi)].length;
    const tdCount = [...html.matchAll(/<t[dh]\b/gi)].length;
    throw new Error(
      `only ${cases.length} WG17 syntax rows were found ` +
      `(saw ${trCount} row starts and ${tdCount} cell starts); upstream HTML format may have changed`,
    );
  }
  const declared = declaredSyntaxTotal(html);
  if (declared != null && cases.length !== declared) {
    throw new Error(
      `WG17 syntax inventory mismatch: upstream declares ${declared} active queries but parser discovered ${cases.length}; ` +
      'upstream HTML format may have changed',
    );
  }
  return cases;
}

function canonicalQuery(query) {
  return String(query).replace(/\r\n?/g, '\n').replace(/\u00a0/g, ' ').trim();
}


function canonicalExpected(expected) {
  return String(expected).replace(/\s+/g, ' ').trim();
}

function isLayoutStart(source, index) {
  if (index >= source.length) return true;
  const ch = source[index];
  return /\s/.test(ch) || ch === '%' || (ch === '/' && source[index + 1] === '*');
}

function firstTermEnd(source) {
  let quote = null;
  let lineComment = false;
  let blockComment = false;
  let depth = 0;

  for (let index = 0; index < source.length; index++) {
    const ch = source[index];
    const next = source[index + 1];

    if (lineComment) {
      if (ch === '\n') lineComment = false;
      continue;
    }
    if (blockComment) {
      if (ch === '*' && next === '/') {
        blockComment = false;
        index++;
      }
      continue;
    }
    if (quote != null) {
      if (ch === '\\') {
        index++;
        continue;
      }
      if (ch === quote && next === quote) {
        index++;
        continue;
      }
      if (ch === quote) quote = null;
      continue;
    }

    if (ch === '%') {
      lineComment = true;
      continue;
    }
    if (ch === '/' && next === '*') {
      blockComment = true;
      index++;
      continue;
    }
    if (ch === "'" && /\d/.test(source[index - 1] ?? '')) {
      // Character-code constant such as 0'. or 0'\\n: apostrophe is not a
      // quoted-atom delimiter. Skip the character (or escaped character).
      if (next === '\\') index += 2;
      else index++;
      continue;
    }
    if (ch === "'" || ch === '"' || ch === '`') {
      quote = ch;
      continue;
    }
    if (ch === '(' || ch === '[' || ch === '{') {
      depth++;
      continue;
    }
    if (ch === ')' || ch === ']' || ch === '}') {
      if (depth > 0) depth--;
      continue;
    }
    if (ch === '.' && depth === 0 && isLayoutStart(source, index + 1)) return index + 1;
  }
  return -1;
}

function skipLayoutAndComments(source, start = 0) {
  let index = start;
  while (index < source.length) {
    if (/\s/.test(source[index])) {
      index++;
      continue;
    }
    if (source[index] === '%') {
      const newline = source.indexOf('\n', index + 1);
      if (newline < 0) return source.length;
      index = newline + 1;
      continue;
    }
    if (source[index] === '/' && source[index + 1] === '*') {
      const end = source.indexOf('*/', index + 2);
      if (end < 0) return index;
      index = end + 2;
      continue;
    }
    break;
  }
  return index;
}

// Return the first complete Prolog term, without its terminating full stop.
// This is used only to reconstruct the setup denoted by upstream /**/ rows.
export function firstPrologTerm(source) {
  const start = skipLayoutAndComments(source, 0);
  const end = firstTermEnd(source.slice(start));
  if (end < 0) return source.slice(start).trim().replace(/\.$/, '').trim();
  return source.slice(start, start + end - 1).trim();
}

export function countTopLevelTerms(source) {
  let index = 0;
  let count = 0;
  while (true) {
    index = skipLayoutAndComments(source, index);
    if (index >= source.length) break;
    const end = firstTermEnd(source.slice(index));
    count++;
    if (end < 0) break;
    index += end;
  }
  return Math.max(1, count);
}

export function setupInput(query, precedingBaseQuery) {
  if (!query.includes('/**/')) return query;
  if (precedingBaseQuery == null) throw new Error(`WG17 query uses /**/ without a preceding setup: ${query}`);
  const setup = firstPrologTerm(precedingBaseQuery);
  if (setup.length === 0) throw new Error(`cannot derive WG17 setup from: ${precedingBaseQuery}`);
  const tail = query.replace('/**/', '');
  return `(catch((${setup}), _, true) -> true ; true).\n${tail}`;
}

function reconcileSyntaxCases(upstream, previous) {
  const previousById = new Map(previous.cases.map((item) => [item.id, item]));
  const nextCases = [];
  const added = [];
  const changed = [];
  let precedingBaseQuery = null;

  for (const row of upstream) {
    const old = previousById.get(row.id);
    const same = old != null &&
      canonicalQuery(old.query) === canonicalQuery(row.query) &&
      canonicalExpected(old.expected) === canonicalExpected(row.expected);

    if (same) {
      nextCases.push(old);
    } else {
      const input = setupInput(row.query, precedingBaseQuery);
      const item = {
        id: row.id,
        query: row.query,
        input,
        readCount: countTopLevelTerms(input),
        expected: row.expected,
        assertion: 'upstream',
      };
      nextCases.push(item);
      if (old == null) added.push(row.id);
      else changed.push(row.id);
    }

    if (!row.query.includes('/**/')) precedingBaseQuery = row.query;
    previousById.delete(row.id);
  }

  return {
    cases: nextCases,
    added,
    changed,
    removed: [...previousById.keys()].sort((a, b) => a - b),
  };
}

function inventoryFromCases(cases) {
  const ids = cases.map(({ id }) => id);
  if (ids.length === 0) throw new Error('WG17 syntax inventory is empty');
  const firstId = Math.min(...ids);
  const lastId = Math.max(...ids);
  const active = new Set(ids);
  const deletedIds = [];
  for (let id = firstId; id <= lastId; id++) if (!active.has(id)) deletedIds.push(id);
  return { firstId, lastId, deletedIds, activeCases: cases.length };
}

function sourceRevision(html) {
  const text = htmlCellText(html);
  const revisions = [...text.matchAll(/\brevision\s+([0-9]+(?:\.[0-9]+)*)/gi)];
  return revisions.at(-1)?.[1] ?? null;
}

function dateStamp() {
  return new Date().toISOString().slice(0, 10);
}

function formatIdList(ids) {
  return ids.length === 0 ? 'none' : ids.map((id) => `#${id}`).join(', ');
}

export function updateWg17InventoryReferences(text, nextCount) {
  // Some documents deliberately omit a count. Update only explicit WG17
  // inventory references, independently of the previous fixture count: a
  // retry may follow a partial update that already wrote the new fixture.
  return text
    .replace(/\b\d+-case(?=\s+(?:vendored\s+)?WG17\b)/g, `${nextCount}-case`)
    .replace(/\bWG17 matrix has \d+ executable/g, `WG17 matrix has ${nextCount} executable`);
}

function updateDocumentedInventoryCount(nextCount) {
  for (const filename of countDocumentationPaths) {
    const original = fs.readFileSync(filename, 'utf8');
    const updated = updateWg17InventoryReferences(original, nextCount);
    if (updated !== original) fs.writeFileSync(filename, updated);
  }
}

async function readSource(source) {
  if (/^https?:\/\//i.test(source)) {
    const response = await fetch(source, {
      headers: { 'user-agent': 'EyeProlog-WG17-upgrader/1' },
      redirect: 'follow',
    });
    if (!response.ok) throw new Error(`WG17 fetch failed: ${response.status} ${response.statusText}`);
    const bytes = new Uint8Array(await response.arrayBuffer());
    const header = response.headers.get('content-type') ?? '';
    return { bytes, html: decodeDocument(bytes, header) };
  }
  const filename = path.resolve(source);
  const bytes = new Uint8Array(fs.readFileSync(filename));
  return { bytes, html: decodeDocument(bytes, '') };
}

export function decodeDocument(bytes, contentType = '') {
  const prefix = Buffer.from(bytes.subarray(0, Math.min(bytes.length, 8192))).toString('latin1');
  const headerCharset = contentType.match(/charset\s*=\s*["']?([^;"'\s]+)/i)?.[1];
  const metaCharset = prefix.match(/<meta[^>]+charset\s*=\s*["']?([^"'\s/>;]+)/i)?.[1] ??
    prefix.match(/<meta[^>]+content\s*=\s*["'][^"']*charset\s*=\s*([^;"'\s>]+)/i)?.[1];
  const label = headerCharset ?? metaCharset ?? 'utf-8';
  try {
    return new TextDecoder(label).decode(bytes);
  } catch (_) {
    return new TextDecoder('windows-1252').decode(bytes);
  }
}

function parseArgs(argv) {
  const options = { check: false, source: syntaxSource };
  for (let index = 0; index < argv.length; index++) {
    const arg = argv[index];
    if (arg === '--check') options.check = true;
    else if (arg === '--source') {
      if (argv[index + 1] == null) throw new Error('--source requires a URL or filename');
      options.source = argv[++index];
    } else if (arg === '--help' || arg === '-h') options.help = true;
    else throw new Error(`unknown option ${arg}`);
  }
  return options;
}

function printHelp() {
  process.stdout.write(`Usage: npm run conformance:update:wg17 -- [--check] [--source URL_OR_FILE]\n\n` +
    `Refreshes the vendored WG17 conformity tests from the TU Wien table.\n` +
    `New or changed rows are executable immediately against the upstream\n` +
    `Codex expectation; existing reviewed exact outcomes remain pinned only as additional regression checks.\n`);
}

export async function upgradeWg17({ check = false, source = syntaxSource } = {}) {
  const previous = JSON.parse(fs.readFileSync(syntaxFixturePath, 'utf8'));
  const { bytes, html } = await readSource(source);
  const upstream = parseWg17SyntaxTable(html);
  const reconciliation = reconcileSyntaxCases(upstream, previous);
  const semanticChanges = reconciliation.added.length + reconciliation.changed.length + reconciliation.removed.length;

  process.stdout.write(`WG17 syntax: ${upstream.length} active upstream cases\n`);
  process.stdout.write(`  added:   ${formatIdList(reconciliation.added)}\n`);
  process.stdout.write(`  changed: ${formatIdList(reconciliation.changed)}\n`);
  process.stdout.write(`  removed: ${formatIdList(reconciliation.removed)}\n`);

  if (check) {
    if (semanticChanges > 0) {
      process.stderr.write('WG17 snapshot is stale; run npm run conformance:update:wg17.\n');
      process.exitCode = 1;
      return { changed: true, ...reconciliation };
    }
    process.stdout.write('WG17 snapshot matches the upstream test inventory.\n');
    return { changed: false, ...reconciliation };
  }

  const checkedOn = dateStamp();
  const fixture = {
    ...previous,
    source: syntaxSource,
    checkedOn,
    sourceRevision: sourceRevision(html),
    sourceSha256: crypto.createHash('sha256').update(bytes).digest('hex'),
    protocol: 'Each query is read and executed in strict ISO mode; /**/ rows reuse the preceding setup.',
    cases: reconciliation.cases,
  };
  fs.writeFileSync(syntaxFixturePath, `${JSON.stringify(fixture, null, 2)}\n`);

  const coverage = JSON.parse(fs.readFileSync(syntaxCoveragePath, 'utf8'));
  coverage.source = syntaxSource;
  coverage.checkedOn = checkedOn;
  coverage.upstream = inventoryFromCases(fixture.cases);
  for (const evidence of coverage.evidence ?? []) {
    if (['all-active', 'all-reviewed'].includes(evidence.ids)) evidence.ids = 'all-executable';
    if (evidence.path === 'test/conformance/wg17-syntax-cases.json') evidence.link = '../run-wg17.mjs';
  }
  fs.writeFileSync(syntaxCoveragePath, `${JSON.stringify(coverage, null, 2)}\n`);

  // Generate status after the fixture/manifest are synchronized.
  const { renderWg17SyntaxStatus } = await import('./report-wg17-syntax-coverage.mjs');
  fs.writeFileSync(syntaxStatusPath, renderWg17SyntaxStatus());
  updateDocumentedInventoryCount(fixture.cases.length);

  // The public report executes the refreshed fixture, so keep its measured row
  // synchronized as part of the same explicit upgrade operation.
  const { buildConformanceReport, formatConformanceReport } = await import('../test/run-conformance-report.mjs');
  const conformanceReport = buildConformanceReport();
  fs.writeFileSync(conformanceReportPath, formatConformanceReport(conformanceReport));

  const upstreamAssertions = fixture.cases
    .filter((item) => item.outcome == null)
    .map(({ id }) => id);
  process.stdout.write(`Updated WG17 snapshot (${fixture.cases.length} cases).\n`);
  if (upstreamAssertions.length > 0) {
    process.stdout.write(
      `Direct upstream assertions used by the WG17 runner: ${formatIdList(upstreamAssertions)}\n`,
    );
  }
  return { changed: semanticChanges > 0, upstreamAssertions, ...reconciliation };
}

const isMain = process.argv[1] != null && pathToFileURL(path.resolve(process.argv[1])).href === import.meta.url;
if (isMain) {
  try {
    const options = parseArgs(process.argv.slice(2));
    if (options.help) printHelp();
    else await upgradeWg17(options);
  } catch (error) {
    process.stderr.write(`${error?.stack ?? error}\n`);
    process.exitCode = 1;
  }
}
