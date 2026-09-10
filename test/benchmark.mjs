import fs from 'node:fs/promises';
import path from 'node:path';
import process from 'node:process';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const manifestPath = path.join(root, 'test', 'bench', 'benchmarks.json');
const defaultBaselinePath = path.join(root, '.benchmarks', 'baseline.json');

function usage() {
  process.stdout.write(`EyeProlog benchmark runner\n\nUsage:\n  node test/benchmark.mjs [options]\n\nOptions:\n  --runs N             Measured batches per benchmark (default: 5)\n  --warmup N           Warm-up batches per benchmark (default: 1)\n  --target-ms N        Minimum target for short measured batches (default: 400)\n  --filter TEXT        Run benchmarks whose name or group contains TEXT\n  --baseline FILE      Compare against a saved timing baseline\n  --save FILE          Save current medians as a timing baseline\n  --json               Print machine-readable JSON\n  --list               List benchmark names and exit\n  -h, --help           Show this help\n\nAfter one untimed priming execution, short workloads are automatically repeated\nin independent run() executions until a measured batch lasts about --target-ms. The report divides batch time by the\niteration count, so all results remain milliseconds per workload execution.\nOutput digests are always checked against the committed semantic checksums in\ntest/bench/benchmarks.json.\n`);
}

function parseInteger(value, name, minimum) {
  const number = Number(value);
  if (!Number.isInteger(number) || number < minimum) {
    throw new Error(`${name} must be an integer >= ${minimum}`);
  }
  return number;
}

function parseNumber(value, name, minimum) {
  const number = Number(value);
  if (!Number.isFinite(number) || number < minimum) {
    throw new Error(`${name} must be a number >= ${minimum}`);
  }
  return number;
}

const options = {
  runs: 5,
  warmup: 1,
  targetMs: 400,
  filter: null,
  baseline: null,
  save: null,
  json: false,
  list: false,
};

for (let i = 2; i < process.argv.length; i++) {
  const arg = process.argv[i];
  if (arg === '--runs') options.runs = parseInteger(process.argv[++i], '--runs', 1);
  else if (arg === '--warmup') options.warmup = parseInteger(process.argv[++i], '--warmup', 0);
  else if (arg === '--target-ms') options.targetMs = parseNumber(process.argv[++i], '--target-ms', 0);
  else if (arg === '--filter') options.filter = process.argv[++i] ?? '';
  else if (arg === '--baseline') options.baseline = path.resolve(process.argv[++i] ?? '');
  else if (arg === '--save') options.save = path.resolve(process.argv[++i] ?? '');
  else if (arg === '--json') options.json = true;
  else if (arg === '--list') options.list = true;
  else if (arg === '--help' || arg === '-h') { usage(); process.exit(0); }
  else throw new Error(`unknown option: ${arg}`);
}

const manifest = JSON.parse(await fs.readFile(manifestPath, 'utf8'));
if (!Array.isArray(manifest) || manifest.length === 0) throw new Error('benchmark manifest is empty');

const names = new Set();
for (const item of manifest) {
  if (!item || typeof item.name !== 'string' || typeof item.group !== 'string' || typeof item.file !== 'string') {
    throw new Error('invalid benchmark manifest entry');
  }
  if (names.has(item.name)) throw new Error(`duplicate benchmark name: ${item.name}`);
  names.add(item.name);
  if (!Array.isArray(item.goals) || !item.goals.every((goal) => typeof goal === 'string')) {
    throw new Error(`invalid goals for benchmark ${item.name}`);
  }
  if (!/^[0-9a-f]{64}$/.test(item.expectedSha256)) {
    throw new Error(`invalid expectedSha256 for benchmark ${item.name}`);
  }
}

const selected = manifest.filter((item) => {
  if (options.filter == null) return true;
  const needle = options.filter.toLowerCase();
  return item.name.toLowerCase().includes(needle) || item.group.toLowerCase().includes(needle);
}).sort((a, b) => a.name.localeCompare(b.name));
if (selected.length === 0) throw new Error(`no benchmarks match filter: ${options.filter}`);

if (options.list) {
  for (const item of selected) process.stdout.write(`${item.name}\t${item.group}\t${item.file}\n`);
  process.exit(0);
}

let baselinePath = options.baseline;
if (baselinePath == null) {
  try {
    await fs.access(defaultBaselinePath);
    baselinePath = defaultBaselinePath;
  } catch (_) {
    baselinePath = null;
  }
}

let baseline = null;
let baselineWarning = null;
if (baselinePath != null) {
  const loaded = JSON.parse(await fs.readFile(baselinePath, 'utf8'));
  if (loaded.format === 2) baseline = loaded;
  else {
    baselineWarning = `Ignoring legacy timing baseline format ${loaded.format ?? 'unknown'}; regenerate it with npm run benchmark -- --save .benchmarks/baseline.json.`;
    baselinePath = null;
  }
}

function median(values) {
  const sorted = [...values].sort((a, b) => a - b);
  const middle = Math.floor(sorted.length / 2);
  return sorted.length % 2 === 0 ? (sorted[middle - 1] + sorted[middle]) / 2 : sorted[middle];
}

function formatMs(value) {
  if (value == null) return '—';
  return `${value.toFixed(1)} ms`;
}

function changePercent(medianMs, baselineMs) {
  if (baselineMs == null || baselineMs === 0) return null;
  return ((medianMs - baselineMs) / baselineMs) * 100;
}

function changeText(item) {
  if (item.changePercent == null) return '—';
  const change = item.changePercent;
  const value = `${change >= 0 ? '+' : ''}${change.toFixed(1)}%`;
  if (Math.abs(change) < 5) return `≈ ${value}`;
  return `${change < 0 ? '↓' : '↑'} ${value}`;
}

// A regression (slower) reads red, an improvement (faster) reads green, and a
// change too small to trust (< 5%) reads dim rather than either color, so the
// palette itself does not editorialize about noise-level swings.
function changeColor(item) {
  if (item.changePercent == null) return null;
  if (Math.abs(item.changePercent) < 5) return 'dim';
  return item.changePercent < 0 ? 'green' : 'red';
}

const supportsColor = !options.json && process.stdout.isTTY &&
  process.env.NO_COLOR == null && process.env.TERM !== 'dumb';
const ANSI = { bold: '1', dim: '2', green: '32', red: '31' };
function paint(name, text) {
  return name && supportsColor ? `\x1b[${ANSI[name]}m${text}\x1b[0m` : text;
}
function visibleLength(text) {
  return text.replace(/\x1b\[[0-9;]*m/g, '').length;
}
function padVisible(text, width) {
  return text + ' '.repeat(Math.max(0, width - visibleLength(text)));
}

function summarizeResults(results) {
  const comparable = results.filter((item) =>
    Number.isFinite(item.medianMs) &&
    item.medianMs > 0 &&
    Number.isFinite(item.baselineMs) &&
    item.baselineMs > 0);

  if (comparable.length === 0) {
    return {
      comparable: 0,
      total: results.length,
      ratio: null,
      changePercent: null,
      currentTotalMs: null,
      baselineTotalMs: null,
      totalRatio: null,
      totalChangePercent: null,
    };
  }

  const ratio = Math.exp(
    comparable.reduce(
      (sum, item) => sum + Math.log(item.medianMs / item.baselineMs),
      0,
    ) / comparable.length,
  );
  const currentTotalMs = comparable.reduce((sum, item) => sum + item.medianMs, 0);
  const baselineTotalMs = comparable.reduce((sum, item) => sum + item.baselineMs, 0);
  const totalRatio = currentTotalMs / baselineTotalMs;

  return {
    comparable: comparable.length,
    total: results.length,
    ratio,
    changePercent: (ratio - 1) * 100,
    currentTotalMs,
    baselineTotalMs,
    totalRatio,
    totalChangePercent: (totalRatio - 1) * 100,
  };
}

function runWorker(item) {
  const child = spawnSync(process.execPath, [
    path.join(root, 'test', 'benchmark-worker.mjs'),
    path.join(root, item.file),
    JSON.stringify(item.goals),
    String(options.runs),
    String(options.warmup),
    String(options.targetMs),
  ], { cwd: root, encoding: 'utf8', maxBuffer: 10 * 1024 * 1024, timeout: 120_000 });
  if (child.error) throw new Error(`${item.name} failed: ${child.error.message}`);
  if (child.status !== 0) {
    throw new Error(`${item.name} failed${child.stderr ? `: ${child.stderr.trim()}` : ''}`);
  }
  try { return JSON.parse(child.stdout); }
  catch (error) { throw new Error(`${item.name} returned invalid worker output: ${error.message}`); }
}

const results = [];
for (const item of selected) {
  if (!options.json) process.stderr.write(`benchmark ${item.name}...\n`);
  const worker = runWorker(item);
  if (worker.digest !== item.expectedSha256) {
    throw new Error(`${item.name} semantic checksum changed: expected ${item.expectedSha256}, got ${worker.digest}`);
  }
  const medianMs = median(worker.samplesMs);
  const minMs = Math.min(...worker.samplesMs);
  const maxMs = Math.max(...worker.samplesMs);
  const baselineItem = baseline?.benchmarks?.[item.name] ?? null;
  results.push({
    name: item.name,
    group: item.group,
    file: item.file,
    goals: item.goals,
    medianMs,
    minMs,
    maxMs,
    batchSize: worker.batchSize,
    calibrationMs: worker.calibrationMs,
    batchSamplesMs: worker.batchSamplesMs,
    samplesMs: worker.samplesMs,
    answerLines: worker.answerLines,
    outputBytes: worker.outputBytes,
    sha256: worker.digest,
    baselineMs: baselineItem?.medianMs ?? null,
    changePercent: changePercent(medianMs, baselineItem?.medianMs ?? null),
  });
}

const summary = summarizeResults(results);

if (options.save != null) {
  await fs.mkdir(path.dirname(options.save), { recursive: true });
  const saved = {
    format: 2,
    generatedAt: new Date().toISOString(),
    node: process.version,
    platform: `${process.platform}-${process.arch}`,
    runs: options.runs,
    warmup: options.warmup,
    targetMs: options.targetMs,
    benchmarks: Object.fromEntries(results.map((item) => [item.name, {
      medianMs: item.medianMs,
      batchSize: item.batchSize,
      sha256: item.sha256,
    }])),
  };
  await fs.writeFile(options.save, `${JSON.stringify(saved, null, 2)}\n`);
}

if (options.json) {
  process.stdout.write(`${JSON.stringify({
    runs: options.runs,
    warmup: options.warmup,
    targetMs: options.targetMs,
    baseline: baselinePath,
    baselineWarning,
    summary,
    results,
  }, null, 2)}\n`);
} else {
  const headers = ['Benchmark', 'Median/op', 'Range/op', 'Batch', 'Baseline', 'Change', 'Answers'];
  const rows = results.map((item) => [
    item.name,
    formatMs(item.medianMs),
    `${formatMs(item.minMs)}–${formatMs(item.maxMs)}`,
    String(item.batchSize),
    formatMs(item.baselineMs),
    paint(changeColor(item), changeText(item)),
    String(item.answerLines),
  ]);
  const widths = headers.map((header, index) => Math.max(header.length, ...rows.map((row) => visibleLength(row[index]))));
  const printRow = (row, style) => process.stdout.write(
    `${row.map((cell, index) => paint(style, padVisible(cell, widths[index]))).join('  ')}\n`,
  );
  printRow(headers, 'bold');
  printRow(widths.map((width) => '-'.repeat(width)), 'dim');
  for (const row of rows) printRow(row);

  if (summary.comparable > 0) {
    process.stdout.write(
      `\nSuite score: ${summary.ratio.toFixed(3)}x baseline ` +
      `(${paint(changeColor({ changePercent: summary.changePercent }), changeText({ changePercent: summary.changePercent }))}), ` +
      `${summary.comparable}/${summary.total} comparable. ` +
      `Time-weighted: ${formatMs(summary.currentTotalMs)} vs ${formatMs(summary.baselineTotalMs)} ` +
      `(${paint(changeColor({ changePercent: summary.totalChangePercent }), changeText({ changePercent: summary.totalChangePercent }))}).\n`,
    );
  }

  process.stdout.write(`\n${results.length} benchmarks, ${options.runs}× after ${options.warmup}× warm-up, ~${options.targetMs} ms/batch.\n`);
  if (baselineWarning) process.stdout.write(paint('dim', `${baselineWarning}\n`));
  else if (baselinePath == null) process.stdout.write(paint('dim', 'No baseline: npm run benchmark -- --save .benchmarks/baseline.json\n'));
  if (options.save != null) process.stdout.write(`Saved baseline: ${path.relative(root, options.save)}\n`);
}
