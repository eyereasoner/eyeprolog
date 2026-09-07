#!/usr/bin/env node
import process from 'node:process';
import { runStandalone } from './test-style.mjs';
import { runNeumerkel } from './run-neumerkel.mjs';
import { runConformance } from './run-conformance.mjs';
import { runIsoStrict } from './run-iso-strict.mjs';
import { runIsoPart2Amendment } from './run-iso-part2-amendment.mjs';
import { runWg17 } from './run-wg17.mjs';

const offline = process.argv.includes('--offline');

await runStandalone(async (reporter) => {
  if (!offline) await runNeumerkel(reporter);
  runConformance(reporter);
  runIsoStrict(reporter);
  runIsoPart2Amendment(reporter);
  runWg17(reporter);
});
