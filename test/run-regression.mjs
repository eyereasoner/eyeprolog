#!/usr/bin/env node
// Supplemental regression runner.
// The cases themselves live in test/regression/: CLI regressions, documentation
// sync checks, public API checks, and small white-box tests for
// maintenance-sensitive internals. They do not belong to the public conformance
// corpus or the example-output corpus.
//
// This file owns only the scheduling: section registration, the temp directory
// lifecycle, and the worker pool. Results are keyed by (sectionKey, index), and
// workers re-derive the case arrays in their own process, so the order a section
// returns its cases in must stay stable across changes.
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { Worker, parentPort, workerData } from 'node:worker_threads';
import { TestReporter, isMainModule, runStandalone } from './test-style.mjs';
import { temp } from './regression/support.mjs';
import { regressionCases } from './regression/cases-regression.mjs';
import { documentationSyncCases } from './regression/cases-documentation-sync.mjs';
import { apiCases } from './regression/cases-api.mjs';
import { whiteBoxCases } from './regression/cases-white-box.mjs';

const regressionSections = [
    { key: 'regression', name: 'Regression', cases: regressionCases },
    { key: 'docs', name: 'Documentation sync', cases: documentationSyncCases },
    { key: 'api', name: 'API', cases: apiCases },
    { key: 'white-box', name: 'White-box', cases: whiteBoxCases },
];

export async function runRegression(reporter = new TestReporter(), requestedSection = null) {
  const sections = regressionSections;
  const selected = requestedSection == null
    ? sections
    : sections.filter((section) => section.key === requestedSection);
  if (selected.length === 0) {
    throw new Error(`unknown regression section: ${requestedSection}; expected ${sections.map(({ key }) => key).join(', ')}`);
  }

  const prepared = selected.map((section) => ({ ...section, tests: section.cases() }));
  const testCount = prepared.reduce((sum, section) => sum + section.tests.length, 0);
  const parallelism = os.availableParallelism?.() ?? os.cpus().length;
  // Several cases start bounded-heap child processes, so leave CPU and memory
  // headroom instead of matching the host's full logical-core count.
  const workerCount = Math.min(testCount, Math.max(1, Math.min(4, parallelism - 1)));
  if (workerCount === 1) {
    withRegressionTemp(() => {
      for (const section of prepared) runSection(reporter, section.name, section.tests);
    });
    return;
  }

  const results = new Map();
  let reportSection = 0;
  let reportTest = 0;
  reporter.section(prepared[0].name);
  const reportReady = () => {
    while (reportSection < prepared.length) {
      const section = prepared[reportSection];
      const result = results.get(testKey(section.key, reportTest));
      if (result == null) return;
      reporter.testResult(section.tests[reportTest].name, result);
      reportTest++;
      if (reportTest !== section.tests.length) continue;
      reporter.sectionTotal(sectionLabel(section.name), sectionElapsedMs(section, results));
      reportSection++;
      reportTest = 0;
      if (reportSection < prepared.length) reporter.section(prepared[reportSection].name);
    }
  };
  await runRegressionWorkers(prepared, workerCount, results, reportReady);
}

function withRegressionTemp(runTests) {
  temp.dir = fs.mkdtempSync(path.join(os.tmpdir(), 'eyeprolog-regression.'));
  temp.counter = 0;
  try {
    return runTests();
  } finally {
    fs.rmSync(temp.dir, { recursive: true, force: true });
    temp.dir = null;
  }
}

async function runRegressionWorkers(sections, workerCount, results, onResult) {
  const tasks = sections.flatMap((section) => section.tests.map((_, index) => ({
    sectionKey: section.key,
    index,
  })));
  let nextTask = 0;
  let completed = 0;
  let settled = false;

  return new Promise((resolve, reject) => {
    const workers = Array.from({ length: workerCount }, () => new Worker(new URL(import.meta.url), {
      workerData: { regressionWorker: true },
    }));

    const closeWorkers = () => {
      for (const worker of workers) worker.postMessage({ close: true });
    };
    const fail = (error) => {
      if (settled) return;
      settled = true;
      Promise.all(workers.map((worker) => worker.terminate())).finally(() => reject(error));
    };
    const assign = (worker) => {
      if (settled) return;
      const task = tasks[nextTask++];
      if (task != null) worker.postMessage(task);
    };

    for (const worker of workers) {
      worker.on('message', (message) => {
        if (settled) return;
        if (message.ready) {
          assign(worker);
          return;
        }
        results.set(testKey(message.sectionKey, message.index), {
          ms: message.ms,
          error: deserializeWorkerError(message.error),
          startedAt: message.startedAt,
          finishedAt: message.finishedAt,
        });
        try {
          onResult();
        } catch (error) {
          fail(error);
          return;
        }
        completed++;
        if (completed === tasks.length) {
          settled = true;
          const exits = Promise.all(workers.map((candidate) => new Promise((done, failed) => {
            candidate.once('exit', done);
            candidate.once('error', failed);
          })));
          closeWorkers();
          exits.then(() => resolve(results), reject);
        } else {
          assign(worker);
        }
      });
      worker.on('error', fail);
      worker.on('exit', (code) => {
        if (!settled) fail(new Error(`regression worker exited unexpectedly with status ${code}`));
      });
    }
  });
}

function testKey(sectionKey, index) {
  return `${sectionKey}:${index}`;
}

function sectionElapsedMs(section, results) {
  const timings = section.tests.map((_, index) => results.get(testKey(section.key, index)));
  return Math.max(...timings.map(({ finishedAt }) => finishedAt)) -
    Math.min(...timings.map(({ startedAt }) => startedAt));
}

function deserializeWorkerError(error) {
  if (error == null) return null;
  return Object.assign(new Error(error.message), { stack: error.stack });
}

function startRegressionWorker() {
  temp.dir = fs.mkdtempSync(path.join(os.tmpdir(), 'eyeprolog-regression-worker.'));
  temp.counter = 0;
  const casesBySection = new Map(regressionSections.map((section) => [section.key, section.cases()]));
  parentPort.on('message', ({ sectionKey, index, close }) => {
    if (close) {
      fs.rmSync(temp.dir, { recursive: true, force: true });
      temp.dir = null;
      parentPort.close();
      return;
    }
    const testCase = casesBySection.get(sectionKey)?.[index];
    const startedAt = Date.now();
    const started = performance.now();
    let error = null;
    try {
      if (testCase == null) throw new Error(`unknown regression test ${sectionKey}:${index}`);
      testCase.run();
    } catch (caught) {
      error = { message: caught?.message ?? String(caught), stack: caught?.stack ?? String(caught) };
    }
    parentPort.postMessage({
      sectionKey,
      index,
      ms: Math.round(performance.now() - started),
      startedAt,
      finishedAt: Date.now(),
      error,
    });
  });
  parentPort.postMessage({ ready: true });
}

function runSection(reporter, name, cases) {
  reporter.section(name);
  for (const testCase of cases) reporter.test(testCase.name, testCase.run);
  reporter.sectionTotal(sectionLabel(name));
}

function sectionLabel(name) {
  if (name === 'Documentation sync') return 'documentation sync';
  if (name === 'API') return 'API';
  if (name === 'White-box') return 'white-box';
  return name.toLowerCase();
}

if (workerData?.regressionWorker) {
  startRegressionWorker();
} else if (isMainModule(import.meta.url)) {
  await runStandalone((reporter) => runRegression(reporter, process.argv[2] ?? null));
}
