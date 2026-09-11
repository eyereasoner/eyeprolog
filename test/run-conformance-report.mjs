#!/usr/bin/env node
// Executable conformance status plus static corpus inventory.
// The WG17 row is run when this report is generated, so a syntax-conformance
// regression changes the public report even when the fixture inventory itself
// has not changed.
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { runWg17 } from './run-wg17.mjs';
import { listPrologFiles } from './test-support.mjs';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)));
const packageRoot = path.resolve(root, '..');
const conformanceRoot = path.join(root, 'conformance');

const KINDS = [
  { kind: 'cases', expectedKind: 'expected', expectedExt: '.pl', column: 'positive' },
  { kind: 'errors', expectedKind: 'expected-errors', expectedExt: '.txt', column: 'errors' },
  { kind: 'warnings', expectedKind: 'expected-warnings', expectedExt: '.pl', column: 'warnings' },
  { kind: 'proofs', expectedKind: 'expected-proofs', expectedExt: '.pl', column: 'proofs' },
];

export function buildConformanceReport({ wg17Suite = runWg17 } = {}) {
  const categories = new Map();
  const corpusIssues = [];

  for (const { kind, expectedKind, expectedExt, column } of KINDS) {
    const base = path.join(conformanceRoot, kind);
    if (!fs.existsSync(base)) continue;
    for (const file of listPrologFiles(base)) {
      const category = categoryOf(file);
      const counts = ensureCategory(categories, category);
      counts[column]++;
      counts.total++;

      const stem = file.slice(0, -3);
      const expected = path.join(conformanceRoot, expectedKind, `${stem}${expectedExt}`);
      if (!fs.existsSync(expected)) corpusIssues.push(`missing ${expectedKind}/${stem}${expectedExt}`);
      if (kind === 'warnings') {
        const expectedStderr = path.join(conformanceRoot, expectedKind, `${stem}.txt`);
        if (!fs.existsSync(expectedStderr)) corpusIssues.push(`missing ${expectedKind}/${stem}.txt`);
      }
    }
  }

  const rows = [...categories.entries()]
    .sort(([a], [b]) => a.localeCompare(b))
    .map(([category, counts]) => ({ category, ...counts }));
  const total = rows.reduce((acc, row) => ({
    positive: acc.positive + row.positive,
    errors: acc.errors + row.errors,
    warnings: acc.warnings + row.warnings,
    proofs: acc.proofs + row.proofs,
    total: acc.total + row.total,
  }), { positive: 0, errors: 0, warnings: 0, proofs: 0, total: 0 });

  const executable = [executeGate('WG17 syntax', wg17Suite)];
  const executionIssues = executable.flatMap((gate) => gate.failures.map((failure) =>
    `${gate.name}: ${failure.name}: ${failure.message}`));

  return {
    rows,
    total,
    executable,
    corpusIssues: corpusIssues.sort(),
    executionIssues,
    issues: [...corpusIssues.sort(), ...executionIssues],
  };
}

export function formatConformanceReport(report = buildConformanceReport()) {
  const wg17 = report.executable.find((gate) => gate.name === 'WG17 syntax');
  const wg17Total = wg17?.total ?? 0;
  const lines = [
    '# EyeProlog conformance report',
    '',
    'This report combines an executable external conformance gate with the file-based',
    'conformance corpus under `test/conformance/`. The executable result is measured',
    'when this report is generated; it is not inferred from fixture counts.',
    '',
  ];

  lines.push(
    '## Latest Neumerkel evidence',
    '',
    'See the tracked [latest Neumerkel conformity report](test/conformance/NEUMERKEL-LATEST.md).',
    '`npm test` fetches all eight TU Wien sources once and executes the discovered inventory.',
    'The release workflow then synchronizes this tracked report from those exact successful',
    'cached source bytes, avoiding a second live fetch and its race window.',
    '',
  );

  lines.push(
    '## Executable conformance status',
    '',
    '| Gate | Passed | Total | Status |',
    '|---|---:|---:|---|',
  );

  for (const gate of report.executable) {
    const status = gate.passed === gate.total ? 'pass' : 'fail';
    lines.push(`| ${gate.name} | ${gate.passed} | ${gate.total} | ${status} |`);
  }

  lines.push(
    '',
    `The WG17 syntax row executes the vendored ${wg17Total}-case conformity-testing matrix`,
    'against EyeProlog\'s strict ISO reader/writer. A behavior fix such as operator-token',
    'spelling therefore changes this report even when no corpus file is added or removed.',
    '',
    '## File-based corpus inventory',
    '',
    '| Category | Positive | Errors | Warnings | Proofs | Total |',
    '|---|---:|---:|---:|---:|---:|',
  );

  for (const row of report.rows) {
    lines.push(`| ${row.category} | ${row.positive} | ${row.errors} | ${row.warnings} | ${row.proofs} | ${row.total} |`);
  }
  lines.push(`| **Total** | **${report.total.positive}** | **${report.total.errors}** | **${report.total.warnings}** | **${report.total.proofs}** | **${report.total.total}** |`);

  lines.push(...dcgConformanceSection());
  lines.push(...integerFlagChoiceSection());

  if (report.corpusIssues.length > 0) {
    lines.push('', '## Corpus issues', '');
    for (const issue of report.corpusIssues) lines.push(`- ${issue}`);
  }
  if (report.executionIssues.length > 0) {
    lines.push('', '## Executable conformance failures', '');
    for (const issue of report.executionIssues) lines.push(`- ${issue}`);
  }

  return `${lines.join('\n')}\n`;
}

// Keep the standards clarification in the generated report.
function dcgConformanceSection() {
  return [
    '',
    '## DCG conformance clarification',
    '',
    'EyeProlog checks the input and remainder of `phrase/2-3` and reports',
    '`type_error(list, S)` when an argument is neither a list nor a partial list.',
    'These implementation-defined checks follow ISO/IEC TS 13211-3:2025,',
    '8.18.1.3 g and h; this behavior is not a known deviation.',
    'The checks are optional. EyeProlog elects to perform both consistently.',
    'Dedicated regressions require the exact error for atomic non-lists and',
    'improper lists across both arities and both sequence positions, while',
    'accepting variables, proper lists, and partial lists. The upstream quads',
    'allow checking and non-checking outcomes and do not prove this policy.',
    '',
    'The Part 3 implementation target is',
    '[ISO/IEC TS 13211-3:2025](https://www.iso.org/standard/83635.html).',
    'The public [error subclause](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/draft-8.18.1.3)',
    'also specifies `list` for these checks.',
    '',
    'The [phrase comparison](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/phrase)',
    'links the machine-readable `phrase_quad.pl` corpus. `npm test` fetches and',
    'runs that corpus live through the Neumerkel gate; the offline regression',
    'suite runs all 58 vendored quads. Neither expectations nor error matching',
    'are relaxed for quads 41-44.',
    '',
  ];
}

// Record the unbounded-integer flag choice as an explicit implementation
// decision rather than leaving it implicit in the source comments.
function integerFlagChoiceSection() {
  return [
    '',
    '## Integer flag choice under `bounded=false`',
    '',
    'EyeProlog reports `bounded=false` and uses arbitrary-precision integers.',
    'It therefore associates no current value with `max_integer` or',
    '`min_integer`, so `current_prolog_flag/2` does not enumerate them and',
    'fails when either is named. Both flags stay registered, so',
    '`set_prolog_flag/2` still reaches the normal non-changeable-flag errors.',
    '',
    'This is an implementation choice, not a requirement of Part 1. Clause',
    '7.11.1.1 defines the `bounded` flag and does not govern',
    '`current_prolog_flag/2` outcomes, while 7.11.1.2 and 7.11.1.3 give both',
    'flags an implementation-defined default value unconditionally; the',
    '`bounded` condition constrains what that value *means*, not whether the',
    'flag exists. Two alternative readings are equally defensible: expose',
    'implementation-defined values so the flags enumerate, or treat them as',
    'unsupported and raise `domain_error(prolog_flag, Flag)` per 8.17.2.3 b.',
    'EyeProlog prefers silence over inventing a largest integer that its',
    'arithmetic does not have. The vendored Prologue corpus records the',
    'resulting single divergence rather than patching the upstream fixture.',
    '',
  ];
}

function executeGate(name, runSuite) {
  const failures = [];
  const reporter = {
    passed: 0,
    total: 0,
    section() {},
    sectionTotal() {},
    test(testName, run) {
      this.total++;
      try {
        run();
        this.passed++;
      } catch (error) {
        failures.push({
          name: testName,
          message: String(error?.message ?? error).split('\n', 1)[0],
        });
      }
    },
  };

  try {
    runSuite(reporter);
  } catch (error) {
    failures.push({ name: 'suite setup', message: String(error?.message ?? error).split('\n', 1)[0] });
  }
  return { name, passed: reporter.passed, total: reporter.total, failures };
}

function categoryOf(file) {
  const parts = file.split('/');
  return parts.length > 1 ? parts[0] : 'legacy-numbered';
}

function ensureCategory(categories, category) {
  let counts = categories.get(category);
  if (!counts) {
    counts = { positive: 0, errors: 0, warnings: 0, proofs: 0, total: 0 };
    categories.set(category, counts);
  }
  return counts;
}

if (process.argv[1] != null && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  const report = buildConformanceReport();
  const text = formatConformanceReport(report);
  const outputPath = process.argv[2] ?? null;
  if (outputPath == null) {
    process.stdout.write(text);
  } else {
    const resolved = path.resolve(packageRoot, outputPath);
    fs.mkdirSync(path.dirname(resolved), { recursive: true });
    fs.writeFileSync(resolved, text);
    process.stdout.write(`wrote ${path.relative(packageRoot, resolved)}\n`);
  }
  if (report.issues.length > 0) process.exit(1);
}
