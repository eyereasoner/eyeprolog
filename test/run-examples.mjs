#!/usr/bin/env node
// Example-output test runner.
// It compares examples byte-for-byte against golden output so answer and proof changes cannot silently alter results.
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { Worker, isMainThread, parentPort, workerData } from 'node:worker_threads';
import { Program, run } from '../src/index.js';
import { fileURLToPath } from 'node:url';
import { TestReporter, isMainModule, runStandalone } from './test-style.mjs';
import { goalsInProgramOrder } from './goal-metadata.mjs';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)));
const packageRoot = path.resolve(root, '..');
const examplesDir = path.join(packageRoot, 'examples');
const expectedDir = path.join(examplesDir, 'output');
const expectedProofDir = path.join(examplesDir, 'proof');

export const proofExamples = [
  'access-control-policy.pl',
  'age.pl',
  'aliases-and-namespaces.pl',
  'ancestor.pl',
  'animal.pl',
  'annotation.pl',
  'backward.pl',
  'bayes-diagnosis.pl',
  'cat-koko.pl',
  'context-association.pl',
  'data-negotiation.pl',
  'deontic-logic.pl',
  'derived-backward-rule.pl',
  'derived-rule.pl',
  'dog.pl',
  'electrical-rc-filter.pl',
  'existential-rule.pl',
  'floating-point.pl',
  'good-cobbler.pl',
  'graph-reachability.pl',
  'greatest-lower-bound-uniqueness.pl',
  'group-inverse-uniqueness.pl',
  'herbrand-semantics.pl',
  'list-collection.pl',
  'proof-contrapositive.pl',
  'reusable-builtins.pl',
  'snaf.pl',
  'socrates.pl',
  'spacecraft-battery-diagnosis.pl',
  'term-tools.pl',
  'witch.pl',
  'beam-deflection.pl',
  'cache-performance.pl',
  'canary-release.pl',
  'chart-parser.pl',
  'clinical-trial-screening.pl',
  'composition-of-injective-functions-is-injective.pl',
  'diamond-property.pl',
  'epidemic-policy.pl',
  'equivalence-classes-overlap-implies-same-class.pl',
  'expression-eval.pl',
  'gdpr-compliance.pl',
  'hanoi.pl',
  'heat-loss.pl',
  'herbrand-witnesses.pl',
  'ideal-gas-law.pl',
  'intuitionistic-logic-kripke.pl',
  'linear-logic-resources.pl',
  'modal-logic-kripke.pl',
  'nixon-diamond.pl',
  'security-incident-correlation.pl',
  'symbolic-derivative.pl',
  'trust-flow-provenance-threshold.pl',
  'weighted-interval-scheduling.pl',
  'integrity-check.pl',
  'prime-range.pl',
  'd3-group.pl',
  'iso-operators.pl',
  'web-names.pl',
  'iso-dynamic-database.pl',
  'partial-evaluator.pl',
];

export async function runExamples(reporter = new TestReporter()) {
  const files = fs.readdirSync(examplesDir)
    .filter((name) => exampleIsRunnable(name))
    .sort();

  reporter.section('Examples');
  await runExampleTasks(files, (name, result) => reporter.testResult(name, result), 3);
  reporter.sectionTotal('examples');

  reporter.section('Proof examples');
  for (const name of proofExamples) reporter.test(name, () => runProofExample(name));
  reporter.sectionTotal('proof examples');
}


async function runExampleTasks(tasks, onResult, maxWorkers) {
  if (tasks.length === 0) return;
  const parallelism = os.availableParallelism?.() ?? os.cpus().length;
  const workerCount = Math.min(tasks.length, Math.max(1, Math.min(maxWorkers, parallelism - 1)));
  if (workerCount === 1) {
    for (const name of tasks) {
      const startedAt = performance.now();
      try {
        runExample(name);
        onResult(name, { ms: Math.round(performance.now() - startedAt) });
      } catch (error) {
        onResult(name, { ms: Math.round(performance.now() - startedAt), error });
      }
    }
    return;
  }

  const completedResults = new Map();
  let nextTask = 0;
  let nextReport = 0;
  let completed = 0;
  let settled = false;

  await new Promise((resolve, reject) => {
    const workers = Array.from({ length: workerCount }, () => new Worker(new URL(import.meta.url), {
      workerData: { exampleWorker: true },
    }));

    const stopWorkers = () => Promise.all(workers.map((worker) => worker.terminate()));

    const fail = (error) => {
      if (settled) return;
      settled = true;
      stopWorkers().finally(() => reject(error));
    };

    const finish = () => {
      if (settled || completed !== tasks.length || nextReport !== tasks.length) return;
      settled = true;
      stopWorkers().then(() => resolve(), reject);
    };

    const reportReady = () => {
      try {
        while (completedResults.has(nextReport)) {
          const result = completedResults.get(nextReport);
          completedResults.delete(nextReport);
          onResult(tasks[nextReport], result);
          nextReport++;
        }
      } catch (error) {
        fail(error);
      }
    };

    const assign = (worker) => {
      if (nextTask >= tasks.length || settled) return;
      worker.postMessage({ id: nextTask, name: tasks[nextTask++] });
    };

    for (const worker of workers) {
      worker.on('message', ({ id, ms, error }) => {
        if (settled) return;
        completedResults.set(id, {
          ms,
          error: error == null ? null : Object.assign(new Error(error.message), { stack: error.stack }),
        });
        completed++;
        reportReady();
        assign(worker);
        finish();
      });
      worker.on('error', fail);
      assign(worker);
    }
  });
}

function runExampleWorker() {
  parentPort.on('message', ({ id, name }) => {
    const startedAt = performance.now();
    try {
      runExample(name);
      parentPort.postMessage({ id, ms: Math.round(performance.now() - startedAt), error: null });
    } catch (error) {
      parentPort.postMessage({
        id,
        ms: Math.round(performance.now() - startedAt),
        error: { message: error?.message ?? String(error), stack: error?.stack ?? String(error) },
      });
    }
  });
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
