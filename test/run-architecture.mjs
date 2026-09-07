#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { TestReporter, isMainModule, runStandalone } from './test-style.mjs';
import { parseClauses } from '../src/parser.js';
import { ATOM, COMPOUND, NUMBER, Env, properListItems } from '../src/term.js';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..', 'src');

export function runArchitecture(reporter = new TestReporter()) {
  reporter.section('Source architecture');
  reporter.test('src JavaScript import graph is acyclic', () => {
    const graph = importGraph(ROOT);
    const cycle = findCycle(graph);
    if (cycle != null) throw new Error(`source import cycle: ${cycle.join(' -> ')}`);
  });

  reporter.test('library private adapters are owned by matching module host files', () => {
    const libRoot = path.join(ROOT, 'lib');
    const issues = [];
    for (const entry of fs.readdirSync(libRoot, { withFileTypes: true })) {
      if (!entry.isFile() || !entry.name.endsWith('.pl')) continue;
      const module = entry.name.slice(0, -3);
      const source = fs.readFileSync(path.join(libRoot, entry.name), 'utf8');
      const adapters = [...new Set([...source.matchAll(/\b(eyeprolog__[A-Za-z0-9_]+)\b/g)].map((match) => match[1]))];
      if (adapters.length === 0) continue;
      const hostPath = path.join(ROOT, `${module}-host.js`);
      if (!fs.existsSync(hostPath)) {
        issues.push(`${entry.name} uses ${adapters.join(', ')} without ${module}-host.js`);
        continue;
      }
      const host = fs.readFileSync(hostPath, 'utf8');
      for (const adapter of adapters) {
        if (!host.includes(`'${adapter}'`) && !host.includes(`"${adapter}"`)) {
          issues.push(`${entry.name}: ${adapter} is not registered by ${module}-host.js`);
        }
      }
    }
    if (issues.length > 0) throw new Error(issues.join('\n'));
  });

  reporter.test('overlapping bundled libraries cover the current Scryer export surface', () => {
    const snapshotPath = path.resolve(path.dirname(fileURLToPath(import.meta.url)), 'scryer-library-exports.json');
    const expected = JSON.parse(fs.readFileSync(snapshotPath, 'utf8'));
    const issues = [];
    for (const [module, indicators] of Object.entries(expected)) {
      const file = path.join(ROOT, 'lib', `${module}.pl`);
      if (!fs.existsSync(file)) {
        issues.push(`missing src/lib/${module}.pl`);
        continue;
      }
      const actual = new Set(moduleExportIndicators(fs.readFileSync(file, 'utf8'), `src/lib/${module}.pl`));
      for (const indicator of indicators) {
        if (!actual.has(indicator)) issues.push(`${module}: missing Scryer export ${indicator}`);
      }
    }
    if (issues.length > 0) throw new Error(issues.join('\n'));
  });
  reporter.test('overlapping bundled libraries cover the pinned Trealla export surface', () => {
    const snapshotPath = path.resolve(path.dirname(fileURLToPath(import.meta.url)), 'trealla-library-exports.json');
    const expected = JSON.parse(fs.readFileSync(snapshotPath, 'utf8'));
    const issues = [];
    for (const [module, indicators] of Object.entries(expected)) {
      const file = path.join(ROOT, 'lib', `${module}.pl`);
      if (!fs.existsSync(file)) {
        issues.push(`missing src/lib/${module}.pl`);
        continue;
      }
      const actual = new Set(moduleExportIndicators(fs.readFileSync(file, 'utf8'), `src/lib/${module}.pl`));
      for (const indicator of indicators) {
        if (!actual.has(indicator)) issues.push(`${module}: missing Trealla export ${indicator}`);
      }
    }
    if (issues.length > 0) throw new Error(issues.join('\n'));
  });
  reporter.test('legacy grab-bag library host files are absent', () => {
    for (const name of ['library-host.js', 'scryer-compat.js']) {
      if (fs.existsSync(path.join(ROOT, name))) throw new Error(`${name} must stay split into module-owned hosts`);
    }
  });
  reporter.test('DCG expansion does not depend on the ISO registry facade', () => {
    const source = fs.readFileSync(path.join(ROOT, 'dcg.js'), 'utf8');
    if (/from\s+['"]\.\/iso\.js['"]/.test(source)) {
      throw new Error('dcg.js must import shared error types from errors.js, not iso.js');
    }
  });
  reporter.sectionTotal('source architecture');
}


function moduleExportIndicators(source, filename) {
  const clauses = parseClauses(source, { filename, sourceMetadata: false });
  for (const clause of clauses) {
    const directive = clause?.head?.type === COMPOUND && clause.head.name === ':-' && clause.head.arity === 1
      ? clause.head.args[0]
      : null;
    if (directive?.type !== COMPOUND || directive.name !== 'module' || directive.arity !== 2) continue;
    const items = properListItems(directive.args[1], new Env());
    if (items == null) throw new Error(`${filename}: module export list is not a proper list`);
    const out = [];
    for (const item of items) {
      if (item?.type === COMPOUND && item.name === 'op' && item.arity === 3) continue;
      if (item?.type !== COMPOUND || !['/', '//'].includes(item.name) || item.arity !== 2 ||
          item.args[0]?.type !== ATOM || item.args[1]?.type !== NUMBER) continue;
      out.push(`${item.args[0].name}/${Number(item.args[1].name) + (item.name === '//' ? 2 : 0)}`);
    }
    return out;
  }
  throw new Error(`${filename}: missing module/2 declaration`);
}

function sourceFiles(root) {
  const files = [];
  const visit = (dir) => {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const full = path.join(dir, entry.name);
      if (entry.isDirectory()) visit(full);
      else if (entry.isFile() && entry.name.endsWith('.js')) files.push(full);
    }
  };
  visit(root);
  return files;
}

function importGraph(root) {
  const files = sourceFiles(root);
  const known = new Set(files.map((file) => path.resolve(file)));
  const graph = new Map(files.map((file) => [path.resolve(file), []]));
  const pattern = /(?:from\s+|import\s*\()(['"])(\.[^'"]+)\1/g;
  for (const file of files) {
    const source = fs.readFileSync(file, 'utf8');
    for (const match of source.matchAll(pattern)) {
      let target = path.resolve(path.dirname(file), match[2]);
      if (!path.extname(target)) target += '.js';
      if (known.has(target)) graph.get(path.resolve(file)).push(target);
    }
  }
  return graph;
}

function findCycle(graph) {
  const state = new Map();
  const stack = [];
  const visit = (node) => {
    state.set(node, 1);
    stack.push(node);
    for (const next of graph.get(node) ?? []) {
      if (state.get(next) === 1) {
        const start = stack.indexOf(next);
        return [...stack.slice(start), next].map((file) => path.relative(ROOT, file));
      }
      if (state.get(next) !== 2) {
        const cycle = visit(next);
        if (cycle != null) return cycle;
      }
    }
    stack.pop();
    state.set(node, 2);
    return null;
  };
  for (const node of graph.keys()) {
    if (state.has(node)) continue;
    const cycle = visit(node);
    if (cycle != null) return cycle;
  }
  return null;
}

if (isMainModule(import.meta.url)) await runStandalone(runArchitecture);
