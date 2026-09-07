#!/usr/bin/env node
// Cross-implementation smoke tests for source-level Prolog interoperability.
//
// By default this runner requires Trealla (`tpl`) and Scryer (`scryer-prolog`)
// to be installed.  Pass --allow-missing for local development when only the
// EyeProlog leg is available.
import path from 'node:path';
import process from 'node:process';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const allowMissing = process.argv.includes('--allow-missing');
const hanoi = path.join(root, 'examples', 'hanoi.pl');
const goal = 'hanoi(3,left,right,center,Moves), write(Moves), nl, halt';
const expected = '[[left,right],[left,center],[right,center],[left,right],[center,left],[center,right],[left,right]]';

const engines = [
  {
    name: 'EyeProlog',
    command: process.execPath,
    args: [path.join(root, 'bin', 'eyeprolog.js'), '--portable', '-g', goal, hanoi],
  },
  {
    name: 'Trealla',
    command: process.env.TPL ?? 'tpl',
    args: ['-q', '-g', goal, hanoi],
  },
  {
    name: 'Scryer',
    command: process.env.SCRYER_PROLOG ?? 'scryer-prolog',
    args: ['-f', '-g', goal, hanoi],
  },
];

let failed = false;
let executed = 0;
for (const engine of engines) {
  const result = spawnSync(engine.command, engine.args, {
    cwd: root,
    encoding: 'utf8',
    timeout: 120000,
  });
  if (result.error?.code === 'ENOENT') {
    if (allowMissing && engine.name !== 'EyeProlog') {
      console.log(`SKIP ${engine.name}: ${engine.command} not installed`);
      continue;
    }
    console.error(`FAIL ${engine.name}: ${engine.command} not installed`);
    failed = true;
    continue;
  }
  executed++;
  if (result.error) {
    console.error(`FAIL ${engine.name}: ${result.error.message}`);
    failed = true;
    continue;
  }
  if (result.status !== 0) {
    console.error(`FAIL ${engine.name}: exit ${result.status}`);
    if (result.stderr) console.error(result.stderr.trim());
    failed = true;
    continue;
  }
  const lines = String(result.stdout ?? '').split(/\r?\n/).map((line) => line.trim()).filter(Boolean);
  if (!lines.includes(expected)) {
    console.error(`FAIL ${engine.name}: Hanoi output mismatch`);
    console.error(`stdout: ${JSON.stringify(result.stdout)}`);
    if (result.stderr) console.error(`stderr: ${result.stderr.trim()}`);
    failed = true;
    continue;
  }
  console.log(`OK ${engine.name}: portable Hanoi`);
}

if (failed) process.exitCode = 1;
else console.log(`OK ${executed}/${allowMissing ? engines.length : executed} available interop engines passed`);
