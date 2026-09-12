#!/usr/bin/env node
// Unified test runner used by `npm test`.
// Running all suites in one process keeps the numbering continuous and avoids
// npm's intermediate script banners between conformance, regression, and examples.
import { runStandalone } from './test-style.mjs';
import { runConformance } from './run-conformance.mjs';
import { runRegression } from './run-regression.mjs';
import { runIsoStrict } from './run-iso-strict.mjs';
import { runIsoPart2Amendment } from './run-iso-part2-amendment.mjs';
import { runPlayground } from './run-playground.mjs';
import { runExamples } from './run-examples.mjs';
import { runBookExamples } from './run-book-examples.mjs';
import { runOpenRuleBenchChecks } from './run-openrulebench.mjs';
import { runArchitecture } from './run-architecture.mjs';
import { runProperties } from './run-properties.mjs';
import { runCleanup } from './run-cleanup.mjs';
import { runHttpJson } from './run-http-json.mjs';
import { runNeumerkel } from './run-neumerkel.mjs';
import { runNeumerkelHarnessTests } from './run-neumerkel-tests.mjs';

const offline = process.argv.includes('--offline');

await runStandalone(async (reporter) => {
  runNeumerkelHarnessTests(reporter);
  if (!offline) await runNeumerkel(reporter);
  runConformance(reporter);
  runIsoStrict(reporter);
  runIsoPart2Amendment(reporter);
  runOpenRuleBenchChecks(reporter);
  runArchitecture(reporter);
  runProperties(reporter);
  runCleanup(reporter);
  await runHttpJson(reporter);
  await runRegression(reporter);
  await runPlayground(reporter);
  await runExamples(reporter);
  runBookExamples(reporter);
});
