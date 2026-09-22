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
/// gap in proof *generation*, not in the checker: these answers come from
/// CLP(B) propagation, which the explanation replay cannot reproduce by
/// resolution, so the writer records them as `unproven` and says so rather
/// than leaving them out.
const KNOWN_GAPS = new Map([
  ['clpb-boolean-circuit.pl', 'a CLP(B) answer decided by propagation, not by resolution'],
  ['clpb-cardinality.pl', 'a CLP(B) answer decided by propagation, not by resolution'],
  ['clpb-feature-model.pl', 'a CLP(B) answer decided by propagation, not by resolution'],
]);

export function runProofChecking(reporter = new TestReporter()) {
  reporter.section('Proof checking');
  for (const name of [...proofExamples].sort()) {
    reporter.test(name, () => checkPackagedProof(name));
  }
  reporter.sectionTotal('proof checking');
}

function checkPackagedProof(name) {
  const source = fs.readFileSync(path.join(examplesDir, name), 'utf8');
  const proof = fs.readFileSync(path.join(examplesDir, 'proof', name), 'utf8');
  const program = Program.parseSources([{ text: source, filename: name }], { sourceMetadata: true });
  const report = checkProofDocument(program, proof);
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
