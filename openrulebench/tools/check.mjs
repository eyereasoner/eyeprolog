#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';

const ROOT = path.dirname(path.dirname(fileURLToPath(import.meta.url)));
const ENGINES = ['eyeprolog', 'trealla', 'scryer', 'swipl'];
const EXPECTED_BENCHMARKS = 14;
const TABLED = new Map([['tc.pl', 1], ['sg.pl', 1], ['modsg.pl', 2], ['wordnet.pl', 3], ['wine.pl', 225]]);
const WFS = new Set(['win_cycle.pl', 'magicset.pl']);
const SWI_WFS_TABLES = new Map([['win_cycle.pl', 1], ['magicset.pl', 3]]);

export function validateOpenRuleBench(root = ROOT) {
  const lexicalErrors = [];
  const adaptationErrors = [];
  const filesByEngine = new Map();

  for (const engine of ENGINES) {
    const dir = path.join(root, engine);
    const names = fs.readdirSync(dir).filter((name) => name.endsWith('.pl')).sort();
    filesByEngine.set(engine, names);
    if (names.length !== EXPECTED_BENCHMARKS) {
      lexicalErrors.push(`${engine}: expected ${EXPECTED_BENCHMARKS} .pl files, found ${names.length}`);
    }
    for (const name of names) {
      const text = fs.readFileSync(path.join(dir, name), 'utf8');
      validateSource(engine, name, text, lexicalErrors);
      validateAdaptation(engine, name, text, adaptationErrors);
    }
  }

  const base = filesByEngine.get('eyeprolog') ?? [];
  const baseKey = JSON.stringify(base);
  for (const engine of ENGINES) {
    if (JSON.stringify(filesByEngine.get(engine) ?? []) !== baseKey) {
      adaptationErrors.push(`${engine}: file set differs from eyeprolog`);
    }
  }

  return {
    lexicalErrors,
    adaptationErrors,
    engines: [...ENGINES],
    benchmarkCount: base.length,
  };
}

function validateSource(engine, name, text, errors) {
  if (!/^%%\s*\?-\s*.+$/m.test(text)) errors.push(`${engine}/${name}: missing %% ?- goal`);
  if ((text.match(/\(/g) ?? []).length !== (text.match(/\)/g) ?? []).length) {
    errors.push(`${engine}/${name}: unbalanced parentheses`);
  }

  let statement = [];
  for (const raw of text.split(/\r?\n/)) {
    const line = raw.split('%', 1)[0].trim();
    if (!line) continue;
    statement.push(line);
    if (line.endsWith('.')) statement = [];
  }
  if (statement.length) {
    errors.push(`${engine}/${name}: unterminated statement near ${statement[0].slice(0, 60)}`);
  }
}

function validateAdaptation(engine, name, text, errors) {
  const tableCount = (text.match(/^:- table /gm) ?? []).length;
  let expectedTables;
  if (engine === 'eyeprolog' || engine === 'trealla' || engine === 'scryer') expectedTables = TABLED.get(name) ?? 0;
  else if (engine === 'swipl') expectedTables = TABLED.get(name) ?? SWI_WFS_TABLES.get(name) ?? 0;
  else expectedTables = 0;
  if (tableCount !== expectedTables) {
    errors.push(`${engine}/${name}: table directives=${tableCount}, expected=${expectedTables}`);
  }

  if (!WFS.has(name)) return;
  if (engine === 'eyeprolog' || engine === 'swipl') {
    if (!text.includes('tnot(')) errors.push(`${engine}/${name}: missing tnot/1 WFS adaptation`);
    const code = text.split(/\r?\n/).filter((line) => !line.trimStart().startsWith('%')).join('\n');
    if (code.includes('\\+')) errors.push(`${engine}/${name}: still contains negation-as-failure`);
  } else if (tableCount) {
    errors.push(`${engine}/${name}: WFS file should not be fake-tabled`);
  }
}

function printValidation(report) {
  for (const engine of report.engines) {
    process.stdout.write(`${engine}: ${report.benchmarkCount} sources; lexical checks ok\n`);
  }
  process.stdout.write(
    `OK: ${report.benchmarkCount} benchmarks x ${report.engines.length} engines; table/WFS adaptations verified.\n`,
  );
}

const mainPath = process.argv[1] ? path.resolve(process.argv[1]) : null;
if (mainPath === fileURLToPath(import.meta.url)) {
  const report = validateOpenRuleBench();
  const errors = [...report.lexicalErrors, ...report.adaptationErrors];
  if (errors.length > 0) {
    process.stderr.write(`${errors.join('\n')}\n`);
    process.exitCode = 1;
  } else {
    printValidation(report);
  }
}
