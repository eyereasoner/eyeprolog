import fs from 'node:fs/promises';
import path from 'node:path';
import process from 'node:process';
import { spawn } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const manifest = JSON.parse(await fs.readFile(path.join(root, 'test', 'bench', 'benchmarks.json'), 'utf8'));

let passed = 0;
function ok(condition, message) {
  if (!condition) throw new Error(message);
  passed++;
}

function spawnJson(args) {
  return new Promise((resolve, reject) => {
    const child = spawn(process.execPath, args, { cwd: root, stdio: ['ignore', 'pipe', 'pipe'] });
    let stdout = '';
    let stderr = '';
    child.stdout.setEncoding('utf8');
    child.stderr.setEncoding('utf8');
    child.stdout.on('data', (chunk) => { stdout += chunk; });
    child.stderr.on('data', (chunk) => { stderr += chunk; });
    child.on('error', reject);
    child.on('close', (code) => {
      if (code !== 0) return reject(new Error(stderr || `child exited ${code}`));
      try { resolve(JSON.parse(stdout)); }
      catch (error) { reject(new Error(`invalid child JSON: ${error.message}`)); }
    });
  });
}

function runWorker(item) {
  return spawnJson([
    path.join(root, 'test', 'benchmark-worker.mjs'),
    path.join(root, item.file),
    JSON.stringify(item.goals),
    '1',
    '0',
    '0',
  ]);
}

ok(Array.isArray(manifest) && manifest.length === 21, 'benchmark manifest should contain exactly 21 representative workloads');
ok(new Set(manifest.map((item) => item.name)).size === manifest.length, 'benchmark names should be unique');

for (const item of manifest) {
  ok(/^[0-9a-f]{64}$/.test(item.expectedSha256), `${item.name} should have a committed semantic checksum`);
  await fs.access(path.join(root, item.file));
  passed++;

  const worker = await runWorker(item);
  ok(worker.digest === item.expectedSha256, `${item.name} should preserve its committed semantic checksum`);
  ok(worker.batchSize === 1, `${item.name} digest test should use one execution per batch`);
  ok(Array.isArray(worker.samplesMs) && worker.samplesMs.length === 1, `${item.name} should return one requested sample`);
  ok(worker.samplesMs[0] >= 0, `${item.name} should return a non-negative wall time`);
}

const adaptive = await spawnJson([
  path.join(root, 'test', 'benchmark.mjs'),
  '--filter', 'dcg-expression',
  '--runs', '1',
  '--warmup', '0',
  '--target-ms', '50',
  '--json',
]);
ok(adaptive.results.length === 1, 'adaptive benchmark smoke test should select one workload');
ok(adaptive.results[0].batchSize > 1, 'adaptive benchmark smoke test should batch a short workload');
ok(adaptive.results[0].sha256 === manifest.find((item) => item.name === 'dcg-expression').expectedSha256,
  'adaptive batching should preserve the semantic checksum');

process.stdout.write(`Benchmark harness tests: ${passed}/${passed} passed.\n`);
