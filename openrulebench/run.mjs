#!/usr/bin/env node
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const ROOT = path.dirname(fileURLToPath(import.meta.url));
const TABLED = new Set(['tc', 'sg', 'modsg', 'wordnet', 'wine']);
const WFS = new Set(['win_cycle', 'magicset']);
const ORDER = ['join1', 'join2', 'joindup', 'lubm', 'mondial', 'dblp', 'tc', 'sg', 'wordnet', 'wine', 'modsg', 'win_tree', 'win_cycle', 'magicset'];
const ENGINES = ['eyeprolog', 'trealla', 'scryer', 'swipl'];
const ENV_NAMES = { eyeprolog: 'EYEPROLOG', trealla: 'TREALLA', scryer: 'SCRYER', swipl: 'SWIPL' };
const DEFAULT_EXES = { eyeprolog: 'eyeprolog', trealla: 'tpl', scryer: 'scryer-prolog', swipl: 'swipl' };

function usage(message = null) {
  if (message) process.stderr.write(`${message}\n`);
  process.stderr.write('usage: node run.mjs {eyeprolog,trealla,scryer,swipl,all} [--only NAMES] [--timeout SECONDS] [--unsafe-wfs]\n');
  process.exit(message ? 2 : 0);
}

function parseArgs(argv) {
  const result = { engine: null, only: null, timeout: 300, unsafeWfs: false };
  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];
    if (arg === '-h' || arg === '--help') usage();
    if (arg === '--unsafe-wfs') { result.unsafeWfs = true; continue; }
    if (arg === '--only' || arg.startsWith('--only=')) {
      result.only = arg.includes('=') ? arg.slice(arg.indexOf('=') + 1) : argv[++i];
      if (result.only == null) usage('--only requires a value');
      continue;
    }
    if (arg === '--timeout' || arg.startsWith('--timeout=')) {
      const value = arg.includes('=') ? arg.slice(arg.indexOf('=') + 1) : argv[++i];
      result.timeout = Number(value);
      if (!Number.isFinite(result.timeout) || result.timeout < 0) usage('--timeout must be a non-negative number');
      continue;
    }
    if (arg.startsWith('-')) usage(`unknown option: ${arg}`);
    if (result.engine != null) usage(`unexpected argument: ${arg}`);
    result.engine = arg;
  }
  if (!ENGINES.includes(result.engine) && result.engine !== 'all') usage('missing or invalid engine');
  return result;
}

function isExecutable(file) {
  try {
    fs.accessSync(file, fs.constants.X_OK);
    return true;
  } catch {
    return false;
  }
}

function findOnPath(name) {
  if (name.includes(path.sep) || (path.sep === '\\' && name.includes('/'))) return isExecutable(name) ? name : null;
  const pathEntries = String(process.env.PATH ?? '').split(path.delimiter).filter(Boolean);
  const extensions = process.platform === 'win32'
    ? String(process.env.PATHEXT ?? '.EXE;.CMD;.BAT;.COM').split(';')
    : [''];
  for (const dir of pathEntries) {
    for (const extension of extensions) {
      const candidate = path.join(dir, process.platform === 'win32' ? `${name}${extension}` : name);
      if (isExecutable(candidate)) return candidate;
    }
  }
  return null;
}

function findExe(engine) {
  const configured = process.env[ENV_NAMES[engine]];
  if (configured) return [configured];
  const found = findOnPath(DEFAULT_EXES[engine]);
  return found ? [found] : null;
}

function goalFor(file) {
  const text = fs.readFileSync(file, 'utf8');
  const match = text.match(/^%%\s*\?-\s*(.+?)\.?\s*$/m);
  if (!match) throw new Error(`no %% ?- goal in ${file}`);
  return match[1].trim();
}

function runProcess(args, timeoutSeconds) {
  const [command, ...rest] = args;
  const options = { encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] };
  if (timeoutSeconds > 0) options.timeout = Math.max(1, Math.ceil(timeoutSeconds * 1000));
  const result = spawnSync(command, rest, options);
  if (result.error?.code === 'ETIMEDOUT') return { timedOut: true, result };
  if (result.error) throw result.error;
  return { timedOut: false, result };
}

function probeTabling(cmd, engine, timeout) {
  if (engine === 'eyeprolog') return [true, 'explicit positive tabling + finite-Datalog WFS/tnot'];
  if (engine === 'swipl') return [true, 'built-in SLG tabling + WFS/tnot'];
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'eyeprolog-orb-'));
  const name = path.join(dir, 'probe.pl');
  fs.writeFileSync(name, ":- use_module(library(tabling)).\nprobe :- write('__ORB_TABLING_OK__'), nl.\n", 'utf8');
  try {
    const args = engine === 'trealla'
      ? [...cmd, '-q', '-f', '-g', 'probe,halt', name]
      : [...cmd, '-f', '-g', 'probe,halt', name];
    try {
      const { timedOut, result } = runProcess(args, timeout ? Math.min(timeout, 30) : 30);
      if (timedOut) return [false, 'tabling probe timed out'];
      const stdout = result.stdout ?? '';
      const stderr = result.stderr ?? '';
      const ok = result.status === 0 && stdout.includes('__ORB_TABLING_OK__');
      const detail = (stderr || stdout).trim().replace(/\n/g, ' ').slice(0, 180);
      return [ok, detail || (ok ? 'available' : 'not detected')];
    } catch (error) {
      return [false, String(error?.message ?? error)];
    }
  } finally {
    fs.rmSync(dir, { recursive: true, force: true });
  }
}

function runOne(engine, cmd, name, timeout) {
  const file = path.join(ROOT, engine, `${name}.pl`);
  const goal = goalFor(file);
  let args;
  if (engine === 'eyeprolog') {
    args = [...cmd, '--goal', goal, file];
  } else if (engine === 'trealla') {
    args = [...cmd, '-q', '-f', '-g', `${goal},write(Count),nl,halt`, file];
  } else if (engine === 'scryer') {
    args = [...cmd, '-f', '-g', `${goal},write(Count),nl,halt`, file];
  } else {
    args = [...cmd, '-q', '-f', 'none', '-s', file, '-g', `${goal},write(Count),nl`, '-t', 'halt'];
  }
  const start = process.hrtime.bigint();
  try {
    const { timedOut, result } = runProcess(args, timeout);
    const seconds = Number(process.hrtime.bigint() - start) / 1e9;
    if (timedOut) return [seconds, 'timeout', `timed out after ${timeout}s`];
    const exitCode = result.status ?? (result.signal ? -(os.constants.signals[result.signal] ?? 0) : null);
    const status = exitCode === 0 ? 'ok' : `failed(${exitCode})`;
    const raw = ((result.stdout ?? '').trim().replace(/\t/g, ' ') || (result.stderr ?? '').trim().replace(/\t/g, ' '));
    return [seconds, status, raw.split(/\r?\n/).join(' ').slice(0, 500)];
  } catch (error) {
    const seconds = Number(process.hrtime.bigint() - start) / 1e9;
    return [seconds, 'error', String(error?.message ?? error)];
  }
}

export function main(argv = process.argv.slice(2)) {
  const args = parseArgs(argv);
  const engines = args.engine === 'all' ? ENGINES : [args.engine];
  const wanted = args.only == null
    ? ORDER
    : args.only.split(',').map((value) => value.trim().replace(/\.pl$/, '')).filter(Boolean);
  process.stdout.write('engine\tbenchmark\tseconds\tstatus\toutput\n');
  for (const engine of engines) {
    const cmd = findExe(engine);
    if (!cmd) {
      process.stdout.write(`${engine}\t-\t0\tengine-not-found\tset ${ENV_NAMES[engine]}\n`);
      continue;
    }
    const [tabOk, tabNote] = probeTabling(cmd, engine, args.timeout);
    for (const name of wanted) {
      if (!ORDER.includes(name)) {
        process.stdout.write(`${engine}\t${name}\t0\tunknown-benchmark\t\n`);
        continue;
      }
      if (WFS.has(name) && !['eyeprolog', 'swipl'].includes(engine) && !args.unsafeWfs) {
        process.stdout.write(`${engine}\t${name}\t0\tskipped-wfs\trequires well-founded negation; EyeProlog(WFS build) and SWI run WFS variants\n`);
        continue;
      }
      if (['trealla', 'scryer', 'swipl'].includes(engine) && TABLED.has(name) && !tabOk) {
        process.stdout.write(`${engine}\t${name}\t0\tskipped-no-tabling\t${tabNote}\n`);
        continue;
      }
      const [seconds, status, output] = runOne(engine, cmd, name, args.timeout);
      process.stdout.write(`${engine}\t${name}\t${seconds.toFixed(6)}\t${status}\t${output}\n`);
    }
  }
}

const mainPath = process.argv[1] ? path.resolve(process.argv[1]) : null;
if (mainPath === fileURLToPath(import.meta.url)) main();
