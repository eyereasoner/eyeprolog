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
/// Proofs that do not check, and what each one exposes. An entry here is a
/// gap in proof *generation*, not in the checker: the explanation replay
/// cannot reach the answer, so the writer records it as `unproven` and says
/// so rather than leaving it out.
///
/// Both of these answers come from a search the replay would have to run
/// again to reproduce -- a labeling and an optimisation -- rather than from
/// a derivation it can follow.
const KNOWN_GAPS = new Map([
  ['clpb-weighted-planning.pl', 'an answer reached by optimising, which the replay would have to run again'],
  ['clpz-resource-allocation.pl', 'an answer reached by labeling, which the replay would have to run again'],
  ['bulk-stream-write.pl', 'an answer produced by writing a stream, which the replay does not re-perform'],
  ['pi.pl', 'an answer reached by numeric iteration the replay would have to run again'],
  ['portable-library-overlap.pl', 'an answer about which library supplied a predicate, which the replay cannot restate'],
]);

// Programs with no packaged proof, and why. Coverage is otherwise complete:
// every other example under examples/ has a checked explanation.
//
//   iso-reflective-terms.pl  copy_term/2 mints fresh variable names from a
//   iso-term-io.pl           counter that is global to the process, so two
//                            runs in one process already disagree. A golden
//                            that cannot be reproduced is not evidence.
//   sbom-vulnerability-response.pl
//                            its proof records a directive as clause/3, and
//                            reading `(:- use_module(...))` back as an
//                            argument hits a parser limit: a parenthesised
//                            1200-priority prefix term is rejected where
//                            SWI, Scryer and GNU Prolog accept it.
//   takeuchi.pl              proof generation does not finish in a minute.

const totals = { steps: 0, verified: 0, redecided: 0, trusted: 0 };

export function runProofChecking(reporter = new TestReporter()) {
  reporter.section('Proof checking');
  totals.steps = 0;
  totals.verified = 0;
  totals.redecided = 0;
  totals.trusted = 0;
  for (const name of [...proofExamples].sort()) {
    reporter.test(name, () => checkPackagedProof(name));
  }
  reporter.sectionTotal('proof checking');
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
  const report = checkProofDocument(program, proof);
  totals.steps += report.steps;
  totals.verified += report.verified;
  totals.redecided += report.redecided;
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
