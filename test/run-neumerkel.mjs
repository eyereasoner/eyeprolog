#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';
import process from 'node:process';
import { executeNeumerkel } from './neumerkel.mjs';
import { isMainModule, runStandalone } from './test-style.mjs';

function parseArgs(argv) {
  const options = {
    mode: 'live',
    sourceDir: process.env.EYEPROLOG_NEUMERKEL_SOURCE_DIR ?? null,
    updateReport: false,
    verifyReport: false,
  };
  for (let index = 0; index < argv.length; index++) {
    const arg = argv[index];
    if (arg === '--cached') options.mode = 'cached';
    else if (arg === '--update-report') options.updateReport = true;
    else if (arg === '--verify-report') options.verifyReport = true;
    else if (arg === '--no-verify-report') options.verifyReport = false;
    else if (arg === '--source-dir') {
      if (argv[index + 1] == null) throw new Error('--source-dir requires a directory');
      options.sourceDir = path.resolve(argv[++index]);
    } else if (arg === '--help' || arg === '-h') options.help = true;
    else throw new Error(`unknown option ${arg}`);
  }
  return options;
}

function printHelp() {
  process.stdout.write(
    'Usage: node test/run-neumerkel.mjs [--cached] [--source-dir DIR] [--verify-report] [--update-report]\n\n' +
    'Default: fetch all eight current Neumerkel conformity sources live and run\n' +
    'every discovered case. A stale tracked report is reported as a warning, not\n' +
    'an engine-test failure. --verify-report makes report freshness mandatory;\n' +
    '--update-report refreshes the tracked Markdown. --cached is reproduction only.\n',
  );
}

export async function runNeumerkel(reporter, options = {}) {
  const effective = { verifyReport: false, updateReport: false, ...options };
  if (effective.sourceDir == null && process.env.EYEPROLOG_NEUMERKEL_SOURCE_DIR) {
    effective.sourceDir = path.resolve(process.env.EYEPROLOG_NEUMERKEL_SOURCE_DIR);
  }
  const result = await executeNeumerkel({ reporter, ...effective });
  const relativeReportPath = path.relative(process.cwd(), result.reportPath);

  if (effective.updateReport) {
    fs.mkdirSync(path.dirname(result.reportPath), { recursive: true });
    fs.writeFileSync(result.reportPath, result.reportText);
    reporter.stdout.write(`Updated Neumerkel report: ${relativeReportPath}\n`);
  } else {
    const committed = fs.existsSync(result.reportPath) ? fs.readFileSync(result.reportPath, 'utf8') : null;
    if (committed !== result.reportText) {
      const message =
        `tracked Neumerkel report is stale: ${relativeReportPath}\n` +
        'Run node test/run-neumerkel.mjs --update-report and commit the updated report.';
      if (effective.verifyReport) throw new Error(message);
      reporter.stdout.write(`WARN ${message}\n`);
    } else {
      reporter.stdout.write(`Neumerkel report: ${relativeReportPath}\n`);
    }
  }
  return result;
}

if (isMainModule(import.meta.url)) {
  const options = parseArgs(process.argv.slice(2));
  if (options.help) printHelp();
  else await runStandalone((reporter) => runNeumerkel(reporter, options));
}
