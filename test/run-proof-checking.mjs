#!/usr/bin/env node
// Checks every packaged proof against the program it was produced from.
//
// This is the suite that says what a proof is worth. It is not a golden
// comparison: a proof that matched its golden byte for byte could still be
// nonsense, so each document is re-checked here -- every recorded inference
// re-performed against the source clause, every use resolved, the derivation
// graph tested for cycles, every claim accounted for, every trusted boundary
// confronted with the evidence, and every claim held to the goal it answers.
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { isMainThread, parentPort, workerData } from 'node:worker_threads';

import { Program } from '../src/index.js';
import { checkProofDocument, checkReportTerms, sourceGoals, verdict } from '../src/check-proof.js';
import { TestReporter, assertEqual, isMainModule, runStandalone } from './test-style.mjs';
import { proofExamples } from './run-examples.mjs';
import { runTasksInParallel, serveTasks } from './parallel-tasks.mjs';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const examplesDir = path.join(root, 'examples');

// Every example under examples/ has a packaged proof, and every one of them is
// checked here. The list is read from the directory
// rather than written out, so a proof cannot be added without being checked.

export async function runProofChecking(reporter = new TestReporter()) {
  reporter.section('Proof checking');
  // Each document is checked on its own against its own program, so the corpus
  // is checked in parallel and the counts it establishes are summed as the
  // results come back, in task order, rather than accumulated in a shared
  // tally a worker could not reach.
  const totals = { steps: 0, verified: 0, redecided: 0, trusted: 0 };
  await runTasksInParallel({
    names: [...proofExamples].sort(),
    workerUrl: new URL(import.meta.url),
    workerData: { proofCheckingWorker: true },
    maxWorkers: 3,
    runLocally: (name) => checkPackagedProof(name),
    onResult: (name, result) => {
      for (const field of Object.keys(totals)) totals[field] += result.value?.[field] ?? 0;
      reporter.testResult(name, result);
    },
  });
  reporter.sectionTotal('proof checking');
  const examples = fs.readdirSync(examplesDir).filter((name) => name.endsWith('.pl'));
  const unproved = examples.filter((name) => !proofExamples.includes(name));
  assertEqual(unproved.join(', '), '', 'every example has a packaged proof');
  // What the corpus establishes, in the terms the conditions use: a verified
  // step was re-performed against its source clause, a recomputed one was run
  // again independently and agreed, and a trusted one is what the check still
  // rests on rather than establishes.
  reporter.section(
    `${totals.steps} steps, ${totals.verified} verified, ${totals.redecided} recomputed, ${totals.trusted} trusted`,
  );
}

function checkPackagedProof(name) {
  const source = fs.readFileSync(path.join(examplesDir, name), 'utf8');
  const proof = fs.readFileSync(path.join(examplesDir, 'proof', name), 'utf8');
  const program = Program.parseSources([{ text: source, filename: name }], { sourceMetadata: true });
  // The proof answers the goals the example asks, and C7 holds it to them.
  const report = checkProofDocument(program, proof, { goals: sourceGoals(program, [source]) });

  // The packaged report says, as ordinary Prolog facts, what checking this
  // document established and what it left as an obligation -- the same kind of
  // artifact as the proof it checked, so a later program can reason over it.
  // Comparing it here keeps those numbers honest: a change that quietly moved
  // a step from recomputed to trusted would alter the corpus and show up as a
  // diff rather than passing unnoticed.
  const reportFile = path.join(examplesDir, 'check', name);
  if (!fs.existsSync(reportFile)) throw new Error(`missing packaged check report: ${path.relative(root, reportFile)}`);
  const expected = fs.readFileSync(reportFile, 'utf8');
  const actual = checkReportTerms(report);
  if (expected !== actual) {
    throw new Error(`check report mismatch for ${name}\nexpected:\n${expected}\nactual:\n${actual}`);
  }
  // What this document contributes to the corpus totals, returned rather than
  // added to a module-level tally so the same function is correct whether it
  // runs here or in a worker.
  const contribution = {
    steps: report.steps,
    verified: report.verified,
    redecided: report.redecided,
    trusted: report.trusted.length,
  };
  const detail = report.failures.slice(0, 3).map((failure) => `[${failure.condition}] ${failure.conclusion} -- ${failure.detail}`).join('; ');
  assertEqual(report.valid, true, `${name}: ${verdict(report)}${detail ? ` -- ${detail}` : ''}`);
  return contribution;
}

if (!isMainThread && workerData?.proofCheckingWorker) {
  serveTasks(parentPort, ({ name }) => checkPackagedProof(name));
} else if (isMainModule(import.meta.url)) {
  await runStandalone(runProofChecking);
}
