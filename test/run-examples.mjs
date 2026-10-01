#!/usr/bin/env node
// Example-output test runner.
// It compares examples byte-for-byte against golden output so answer and proof changes cannot silently alter results.
import fs from 'node:fs';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { isMainThread, parentPort, workerData } from 'node:worker_threads';
import { Program, run } from '../src/index.js';
import { fileURLToPath } from 'node:url';
import { TestReporter, isMainModule, runStandalone } from './test-style.mjs';
import { runTasksInParallel, serveTasks } from './parallel-tasks.mjs';
import { goalsInProgramOrder } from './goal-metadata.mjs';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)));
const packageRoot = path.resolve(root, '..');
const examplesDir = path.join(packageRoot, 'examples');
const expectedDir = path.join(examplesDir, 'output');
const expectedProofDir = path.join(examplesDir, 'proof');

// Every proof packaged under examples/proof/ is checked. This is read from
// the directory rather than listed here so that adding a proof cannot quietly
// add an unchecked one: a document nobody verifies is worse than no document,
// because it still looks like evidence.
export const proofExamples = fs.readdirSync(expectedProofDir)
  .filter((name) => name.endsWith('.pl'))
  .sort();

export async function runExamples(reporter = new TestReporter()) {
  const files = fs.readdirSync(examplesDir)
    .filter((name) => exampleIsRunnable(name))
    .sort();

  reporter.section('Examples');
  await runExampleTasks(files, 'output', reporter);
  reporter.sectionTotal('examples');

  // Proving an example costs several times what running it does, so this is
  // the longer of the two passes over the same corpus. It is the same work per
  // program and the same isolation, so it goes through the same worker pool.
  reporter.section('Proof examples');
  await runExampleTasks(proofExamples, 'proof', reporter);
  reporter.sectionTotal('proof examples');
}

// What a worker is asked to do with one example. Results are compared inside
// the worker, so only a name, an elapsed time, and a failure cross the thread.
const exampleTaskKinds = {
  output: runExample,
  proof: runProofExample,
};


function runExampleTasks(names, kind, reporter) {
  return runTasksInParallel({
    names,
    workerUrl: new URL(import.meta.url),
    workerData: { exampleWorker: true },
    message: { kind },
    maxWorkers: 3,
    runLocally: (name) => exampleTaskKinds[kind](name),
    onResult: (name, result) => reporter.testResult(name, result),
  });
}

function runExampleWorker() {
  serveTasks(parentPort, ({ kind, name }) => exampleTaskKinds[kind](name));
}


function exampleIsRunnable(name) {
  return name.endsWith('.pl');
}

function runExample(name) {
  const programFile = path.join(examplesDir, name);
  const expected = path.join(expectedDir, name);
  const actual = runProgramExample(programFile, name, { proof: false });
  compareOutput(name, expected, actual, 'output');
}

function runProofExample(name) {
  const programFile = path.join(examplesDir, name);
  const expected = path.join(expectedProofDir, name);
  const actual = runProgramExample(programFile, name, { proof: true });
  compareOutput(name, expected, actual, 'proof output');
}

function runProgramExample(programFile, filename, options) {
  const text = fs.readFileSync(programFile, 'utf8');
  const expectedExit = text.match(/^%\s*expect-exit:\s*(\d+)\s*$/m);
  const program = Program.parseSources([{ text, filename }], {
    sourceMetadata: options.proof,
    onWarning: (warning) => {
      if (warning.kind === 'singleton') {
        process.stderr.write(`Warning: singleton: ${warning.name}, near ${warning.filename}:${warning.line}\n`);
      }
    },
  });
  try {
    const result = run(program, { ...options, goals: goalsInProgramOrder(program, text) });
    if (expectedExit) throw new Error(`${filename} expected exit ${expectedExit[1]}, but reasoning succeeded`);
    return result.stdout;
  } catch (error) {
    if (expectedExit && error?.code === Number(expectedExit[1])) return error.stdout ?? '';
    throw error;
  }
}

function compareOutput(name, expected, actual, label) {
  if (!fs.existsSync(expected)) {
    throw new Error(`missing expected ${label} file: ${path.relative(root, expected)}`);
  }

  const expectedText = fs.readFileSync(expected, 'utf8');
  if (expectedText !== actual) {
    throw new Error(`${label} mismatch for ${name}\n${diffText(expected, actual)}`.trimEnd());
  }
}

function diffText(expected, actualText) {
  const diff = spawnSync('diff', ['-u', expected, '-'], { input: actualText, encoding: 'utf8' });
  if (diff.stdout) return diff.stdout;

  const expectedText = fs.readFileSync(expected, 'utf8').split('\n');
  const actualLines = actualText.split('\n');
  const limit = Math.max(expectedText.length, actualLines.length);
  for (let i = 0; i < limit; i++) {
    if (expectedText[i] !== actualLines[i]) {
      return `first difference at line ${i + 1}\nexpected: ${expectedText[i] ?? '<missing>'}\nactual:   ${actualLines[i] ?? '<missing>'}`;
    }
  }

  return 'outputs differ';
}

if (!isMainThread && workerData?.exampleWorker) {
  runExampleWorker();
} else if (isMainModule(import.meta.url)) {
  await runStandalone(runExamples);
}
