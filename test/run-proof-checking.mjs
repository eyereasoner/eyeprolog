#!/usr/bin/env node
// Checks every packaged proof against the program it was produced from.
//
// This is the suite that says what a proof is worth. It is not a golden
// comparison: a proof that matched its golden byte for byte could still be
// nonsense, so each document is re-checked here -- every recorded inference
// re-performed against the source clause, every use resolved, the derivation
// graph tested for cycles, and every claim accounted for.
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { Program } from '../src/index.js';
import { checkProofDocument, verdict } from '../src/check-proof.js';
import { TestReporter, assertEqual, isMainModule, runStandalone } from './test-style.mjs';
import { proofExamples } from './run-examples.mjs';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const examplesDir = path.join(root, 'examples');

/// Proofs that do not check, and what each one exposes. An entry here is a
/// gap in proof *generation*, not in the checker: the explanation replay
/// cannot reproduce the answer, so the writer records it as `unproven` and
/// says so rather than leaving it out.
///
/// Explaining through the solver that produced the answer closed the three
/// CLP(B) gaps that used to be here, so the list is empty: every packaged
/// proof checks, and this test fails if one stops doing so.
///
/// The CLP(Z) examples are not in this corpus, and not because they fail:
/// `clpz`'s goal expansion names the variables it introduces from a counter
/// that advances across a run, so a `clause/3` record of an expanded body
/// differs between runs and cannot be compared against a golden. Checked
/// directly rather than through a golden, `clpz-factorial`, `clpz-n-queens`,
/// `clpz-global-constraints` and `clpz-sudoku-9x9` all check.
const KNOWN_GAPS = new Map([]);

const totals = { steps: 0, verified: 0, trusted: 0 };

export function runProofChecking(reporter = new TestReporter()) {
  reporter.section('Proof checking');
  totals.steps = 0;
  totals.verified = 0;
  totals.trusted = 0;
  for (const name of [...proofExamples].sort()) {
    reporter.test(name, () => checkPackagedProof(name));
  }
  reporter.sectionTotal('proof checking');
  // What the corpus establishes, in the terms the specification uses: a
  // verified step was re-performed, a trusted one was recorded because
  // re-deciding it would mean running the program.
  reporter.section(`${totals.steps} steps, ${totals.verified} verified, ${totals.trusted} trusted`);
}

function checkPackagedProof(name) {
  const source = fs.readFileSync(path.join(examplesDir, name), 'utf8');
  const proof = fs.readFileSync(path.join(examplesDir, 'proof', name), 'utf8');
  const program = Program.parseSources([{ text: source, filename: name }], { sourceMetadata: true });
  const report = checkProofDocument(program, proof);
  totals.steps += report.steps;
  totals.verified += report.verified;
  totals.trusted += report.trusted.length;
  const gap = KNOWN_GAPS.get(name);
  if (gap) {
    assertEqual(report.valid, false, `${name} now checks; remove it from KNOWN_GAPS (${gap})`);
    return;
  }
  const detail = report.failures.slice(0, 3).map((failure) => `[${failure.condition}] ${failure.conclusion} -- ${failure.detail}`).join('; ');
  assertEqual(report.valid, true, `${name}: ${verdict(report)}${detail ? ` -- ${detail}` : ''}`);
}

if (isMainModule(import.meta.url)) {
  await runStandalone(runProofChecking);
}
