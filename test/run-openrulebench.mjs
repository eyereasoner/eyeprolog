#!/usr/bin/env node
// Fast structural checks for the generated multi-engine OpenRuleBench corpus.
// Full benchmark execution remains separate because it requires external
// Prolog implementations and is intentionally performance-oriented.
import { validateOpenRuleBench } from '../openrulebench/tools/check.mjs';
import { TestReporter, isMainModule, runStandalone } from './test-style.mjs';

export function runOpenRuleBenchChecks(reporter = new TestReporter()) {
  let report = null;
  reporter.section('OpenRuleBench source integrity');
  reporter.test('generated sources pass lexical checks', () => {
    report = validateOpenRuleBench();
    assertNoErrors(report.lexicalErrors);
  });
  reporter.test('engine variants preserve table and WFS adaptations', () => {
    report ??= validateOpenRuleBench();
    assertNoErrors(report.adaptationErrors);
  });
  reporter.sectionTotal('OpenRuleBench source-integrity');
}

function assertNoErrors(errors) {
  if (errors.length > 0) throw new Error(errors.join('\n'));
}

if (isMainModule(import.meta.url)) {
  await runStandalone(runOpenRuleBenchChecks);
}
