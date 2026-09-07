#!/usr/bin/env node
// Render the traceability status for the public WG17 syntax corpus. This is a
// coverage ledger, not a claim that untraced cases fail or that traced cases
// are the only local tests exercising the same language rules.
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const packageRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const manifestPath = path.join(packageRoot, 'test', 'conformance', 'wg17-syntax-coverage.json');
const statusPath = path.join(packageRoot, 'test', 'conformance', 'WG17-SYNTAX-STATUS.md');
const fixturePath = path.join(packageRoot, 'test', 'conformance', 'wg17-syntax-cases.json');

export function readWg17SyntaxCoverage() {
  const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
  const { firstId, lastId, deletedIds, activeCases } = manifest.upstream;
  const deleted = new Set(deletedIds);
  const activeIds = [];
  for (let id = firstId; id <= lastId; id++) if (!deleted.has(id)) activeIds.push(id);
  if (activeIds.length !== activeCases) {
    throw new Error(`WG17 active-case count is ${activeIds.length}, manifest says ${activeCases}`);
  }

  const active = new Set(activeIds);
  const covered = new Set();
  const evidenceEntries = [];
  for (const evidence of manifest.evidence) {
    if (!evidence.name || !evidence.path || !evidence.link ||
        (!Array.isArray(evidence.ids) && !['all-active', 'all-reviewed', 'all-executable'].includes(evidence.ids))) {
      throw new Error('invalid WG17 evidence entry');
    }
    const evidenceIds = evidence.ids === 'all-active' ? activeIds :
      ['all-reviewed', 'all-executable'].includes(evidence.ids)
        ? executableWg17Ids(evidence.path, active) : evidence.ids;
    const evidenceFilename = path.join(packageRoot, evidence.path);
    if (!fs.existsSync(evidenceFilename)) throw new Error(`missing WG17 evidence file ${evidence.path}`);
    const referenced = referencedWg17Ids(fs.readFileSync(evidenceFilename, 'utf8'));
    const withinEntry = new Set();
    for (const id of evidenceIds) {
      if (!Number.isInteger(id) || !active.has(id)) throw new Error(`invalid active WG17 id #${id}`);
      if (withinEntry.has(id)) throw new Error(`duplicate WG17 id #${id} in ${evidence.name}`);
      if (!referenced.has(id)) throw new Error(`WG17 id #${id} is not referenced by ${evidence.path}`);
      withinEntry.add(id);
      covered.add(id);
    }
    evidenceEntries.push({ ...evidence, ids: evidenceIds });
  }

  return {
    manifest,
    evidenceEntries,
    activeIds,
    coveredIds: activeIds.filter((id) => covered.has(id)),
    untracedIds: activeIds.filter((id) => !covered.has(id)),
  };
}


function executableWg17Ids(relativePath, active) {
  const filename = path.join(packageRoot, relativePath);
  if (path.resolve(filename) !== path.resolve(fixturePath)) return [];
  const fixture = JSON.parse(fs.readFileSync(filename, 'utf8'));
  return fixture.cases
    .filter((item) => typeof item.expected === 'string' && item.expected.length > 0 && active.has(item.id))
    .map(({ id }) => id);
}

function referencedWg17Ids(source) {
  const ids = new Set();
  for (const match of source.matchAll(/#(\d+)(?:-(\d+))?/g)) {
    const first = Number(match[1]);
    const last = match[2] == null ? first : Number(match[2]);
    for (let id = first; id <= last; id++) ids.add(id);
  }
  for (const match of source.matchAll(/"id"\s*:\s*(\d+)/g)) ids.add(Number(match[1]));
  return ids;
}

export function renderWg17SyntaxStatus() {
  const { manifest, evidenceEntries, activeIds, coveredIds, untracedIds } = readWg17SyntaxCoverage();
  const fixture = JSON.parse(fs.readFileSync(fixturePath, 'utf8'));
  const waits = fixture.cases.filter((item) =>
    item.outcome?.type === 'waits' || (item.outcome == null && /^waits$/i.test(item.expected ?? ''))).length;
  const direct = fixture.cases.filter((item) => item.outcome == null).length;
  const percentage = (100 * coveredIds.length / activeIds.length).toFixed(1);
  const evidenceRows = evidenceEntries.map((evidence) =>
    `| [${evidence.name}](${evidence.link}) | ${evidence.ids.length} | ${formatRanges(evidence.ids)} |`);

  return `# WG17 syntax traceability status

Source: [Conformity Testing I: Syntax](${manifest.source})  
Upstream inventory checked: ${manifest.checkedOn}

This ledger counts an upstream case when its WG17 identifier, query, and
expected ISO disposition are stored in the offline executable matrix. Every
case is executed against the upstream Codex expectation. Reviewed exact
EyeProlog outcomes are additional regression locks and can never override the
upstream assertion. Concrete writer expectations are matched lexically: layout,
parentheses, and quoting are significant. Only Codex expectations explicitly
marked e.g. use controlled flexibility for representation choices such as
generated variable names or equivalent numeric spellings.

## Current standing

The percentage below is **traceability coverage**, not a conformance pass rate.
A represented case still has to pass the executable upstream assertion in
\`test/run-wg17.mjs\`.

| Measure | Count |
| --- | ---: |
| Active upstream cases | ${activeIds.length} |
| Upstream cases represented in the executable matrix | ${coveredIds.length} (${percentage}%) |
| Not yet traced one-by-one | ${untracedIds.length} |
| Deleted upstream identifiers | ${formatRanges(manifest.upstream.deletedIds)} |

The matrix runs in strict ISO stream-reader mode as part of \`npm test\`. The
${waits} upstream \`waits\` case${waits === 1 ? '' : 's'} ${waits === 1 ? 'is' : 'are'} checked through EyeProlog's interactive input
hook. All ${coveredIds.length} executable cases are independently checked against the
upstream Codex expectation. ${coveredIds.length - direct} case${coveredIds.length - direct === 1 ? '' : 's'} additionally retain exact reviewed
outcomes for stronger regression checking; ${direct} case${direct === 1 ? '' : 's'} currently ${direct === 1 ? 'relies' : 'rely'} on the upstream assertion alone.

## Traceable evidence

| Executable evidence | Referenced IDs | WG17 cases |
| --- | ---: | --- |
${evidenceRows.join('\n')}

The evidence groups overlap. Their union is **${coveredIds.length}** active cases:
${formatRanges(coveredIds)}.

## Untraced upstream identifiers

${untracedIds.length === 0 ? 'None.' : `${formatRanges(untracedIds)}.`}

## Maintenance

1. Run \`npm run conformance:update\` to reconcile the dated fixture with upstream.
2. Review every new or changed ISO expectation before adding its expected outcome.
3. Run \`npm run test:wg17\` and keep this generated status page synchronized.
`;
}

function formatRanges(ids) {
  const sorted = [...new Set(ids)].sort((left, right) => left - right);
  const ranges = [];
  for (let index = 0; index < sorted.length;) {
    const start = sorted[index];
    let end = start;
    while (index + 1 < sorted.length && sorted[index + 1] === end + 1) end = sorted[++index];
    ranges.push(start === end ? `#${start}` : `#${start}–#${end}`);
    index++;
  }
  return ranges.join(', ');
}

if (process.argv[1] != null && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  const rendered = renderWg17SyntaxStatus();
  if (process.argv.includes('--check')) {
    const current = fs.readFileSync(statusPath, 'utf8');
    if (current !== rendered) {
      process.stderr.write('WG17 syntax status is stale; run npm run conformance:update and update the file.\n');
      process.exitCode = 1;
    }
  } else {
    process.stdout.write(rendered);
  }
}
