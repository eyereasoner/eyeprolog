#!/usr/bin/env node
// Browser-playground contract tests.
// These checks use only Node built-ins, but exercise the exact worker module
// and HTTP module graph used by playground.html.
import fs from 'node:fs';
import http from 'node:http';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import {
  executePlaygroundRequest,
  installPlaygroundWorker,
} from '../src/playground-worker.js';
import {
  TestReporter,
  assertEqual,
  assertIncludes,
  assertNotIncludes,
  isMainModule,
  runStandalone,
} from './test-style.mjs';

const testRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)));
const packageRoot = path.resolve(testRoot, '..');

export async function runPlayground(reporter = new TestReporter()) {
  reporter.section('Playground');

  await reporter.testAsync('page starts a dedicated module worker', async () => {
    const html = fs.readFileSync(path.join(packageRoot, 'playground.html'), 'utf8');
    assertIncludes(html, "new URL('./src/playground-worker.js?playground=", 'playground worker URL');
    assertIncludes(html, "new Worker(workerUrl, { type: 'module' })", 'module worker construction');
    assertIncludes(html, "event.data?.type === 'ready'", 'worker readiness handshake');
    assertIncludes(html, 'did not finish loading', 'worker startup timeout');
    assertNotIncludes(html, 'URL.createObjectURL(new Blob([workerCode]', 'inline blob worker');
  });

  await reporter.testAsync('example picker includes every runnable top-level example', async () => {
    const html = fs.readFileSync(path.join(packageRoot, 'playground.html'), 'utf8');
    const match = html.match(/const EXAMPLES = \[(.*?)\n\s*\];/s);
    if (!match) throw new Error('playground EXAMPLES array not found');
    const listed = [...match[1].matchAll(/"([^"]+)"/g)].map((entry) => entry[1]).sort();
    const expected = fs.readdirSync(path.join(packageRoot, 'examples'))
      .filter((name) => name.endsWith('.pl'))
      .map((name) => name.slice(0, -3))
      .sort();
    assertEqual(JSON.stringify(listed), JSON.stringify(expected), 'playground example picker');
  });

  await reporter.testAsync('worker loads append/3 from the EyeProlog library', async () => {
    const result = executePlaygroundRequest({
      source: ':- use_module(library(lists)).\nanswer(X) :- append([a], [b], X).\n',
      options: { goal: 'answer(X)' },
    }, deterministicClock());
    assertEqual(result.ok, true, 'worker result status');
    assertEqual(result.stdout, 'answer("ab").\n', 'append/3 output');
    assertEqual(result.elapsedMs, 1, 'elapsed time');
  });

  await reporter.testAsync('worker keeps the EyeProlog library across runs', async () => {
    const first = executePlaygroundRequest({
      source: ':- use_module(library(lists)).\nanswer(X) :- reverse([a, b, c], X).\n',
      options: { goal: 'answer(X)' },
    });
    const second = executePlaygroundRequest({
      source: ':- use_module(library(lists)).\nanswer(X) :- member(X, [red, green]).\n',
      options: { goal: 'answer(X)' },
    });
    assertEqual(first.stdout, 'answer("cba").\n', 'first worker output');
    assertEqual(second.stdout, 'answer(red).\nanswer(green).\n', 'second worker output');
  });

  await reporter.testAsync('worker runs finite-domain CLP(Z) programs', async () => {
    const result = executePlaygroundRequest({
      source: [
        ':- use_module(library(clpz)).',
        'answer(X, Y) :- [X, Y] ins 1..3, X #< Y, X + Y #= 4, labeling([ff], [X, Y]).',
        '',
      ].join('\n'),
      options: { goal: 'answer(X, Y)' },
    });
    assertEqual(result.ok, true, 'CLP(Z) worker result status');
    assertEqual(result.stdout, 'answer(1, 3).\n', 'CLP(Z) worker output');
  });

  await reporter.testAsync('worker message protocol returns serializable results', async () => {
    const messages = [];
    const scope = { postMessage: (message) => messages.push(message) };
    installPlaygroundWorker(scope);
    scope.onmessage({
      data: {
        source: ':- use_module(library(lists)).\nanswer(X) :- append([], [ok], X).\n',
        options: { goal: 'answer(X)', stats: true },
      },
    });
    assertEqual(messages.length, 1, 'posted message count');
    assertEqual(messages[0].ok, true, 'posted result status');
    assertEqual(messages[0].stdout, 'answer([ok]).\n', 'posted result output');
    JSON.stringify(messages[0]);
  });

  await reporter.testAsync('worker serializes parse failures for the UI', async () => {
    const result = executePlaygroundRequest({
      source: 'broken(.\n',
      options: { goal: 'answer' },
    });
    assertEqual(result.ok, false, 'parse result status');
    assertIncludes(result.error, 'parse line 1', 'parse error');
    JSON.stringify(result);
  });

  await reporter.testAsync('served playground assets have browser-safe MIME types', async () => {
    await withStaticServer(async (baseUrl) => {
      const expected = [
        ['playground.html', 'text/html'],
        ['src/playground-worker.js', 'text/javascript'],
        ['src/index.js', 'text/javascript'],
        ['src/lib/aggregate.pl', 'text/plain'],
        ['src/lib/comparison.pl', 'text/plain'],
        ['src/lib/dates.pl', 'text/plain'],
        ['src/lib/iso_ext.pl', 'text/plain'],
        ['src/lib/lists.pl', 'text/plain'],
        ['src/lib/primes.pl', 'text/plain'],
        ['src/lib/prologue.pl', 'text/plain'],
        ['src/lib/random.pl', 'text/plain'],
        ['src/lib/strings.pl', 'text/plain'],
        ['src/lib/uuid.pl', 'text/plain'],
        ['examples/socrates.pl', 'text/plain'],
      ];
      for (const [relative, contentType] of expected) {
        const response = await fetch(new URL(relative, baseUrl));
        assertEqual(response.status, 200, `${relative} status`);
        assertIncludes(response.headers.get('content-type') ?? '', contentType, `${relative} content type`);
      }
    });
  });

  await reporter.testAsync('HTTP worker module graph resolves without Node built-ins', async () => {
    await withStaticServer(async (baseUrl) => {
      const modules = await crawlModuleGraph(new URL('src/playground-worker.js?playground=test', baseUrl));
      assert(modules.size >= 10, `expected a substantial worker module graph, got ${modules.size}`);
      assert([...modules].some((url) => url.includes('/src/standard-library.js')), 'standard module registry missing from worker graph');
      assert([...modules].some((url) => url.includes('/src/solver.js')), 'solver missing from worker graph');
    });
  });

  reporter.sectionTotal('playground');
}

async function crawlModuleGraph(entryUrl) {
  const pending = [entryUrl];
  const visited = new Set();
  while (pending.length) {
    const url = pending.pop();
    const key = url.href;
    if (visited.has(key)) continue;
    visited.add(key);

    const response = await fetch(url);
    assertEqual(response.status, 200, `${url.pathname} status`);
    assertIncludes(response.headers.get('content-type') ?? '', 'text/javascript', `${url.pathname} content type`);
    const source = await response.text();
    for (const specifier of staticModuleSpecifiers(source)) {
      assert(!specifier.startsWith('node:'), `${url.pathname} statically imports ${specifier}`);
      if (!specifier.startsWith('.') && !specifier.startsWith('/')) continue;
      const child = new URL(specifier, url);
      assertEqual(child.origin, entryUrl.origin, `${url.pathname} import origin`);
      pending.push(child);
    }
  }
  return visited;
}

function staticModuleSpecifiers(source) {
  const specifiers = [];
  const sideEffectImports = /(?:^|\n)\s*import\s*['"]([^'"]+)['"]/g;
  const fromImports = /(?:^|\n)\s*(?:import|export)\s+[^;]*?\s+from\s+['"]([^'"]+)['"]/g;
  for (const match of source.matchAll(sideEffectImports)) specifiers.push(match[1]);
  for (const match of source.matchAll(fromImports)) specifiers.push(match[1]);
  return specifiers;
}

async function withStaticServer(run) {
  const server = http.createServer((request, response) => {
    try {
      const url = new URL(request.url ?? '/', 'http://127.0.0.1');
      const relative = decodeURIComponent(url.pathname).replace(/^\/+/, '') || 'playground.html';
      const filename = path.resolve(packageRoot, relative);
      if (filename !== packageRoot && !filename.startsWith(`${packageRoot}${path.sep}`)) {
        response.writeHead(403).end('forbidden');
        return;
      }
      if (!fs.statSync(filename, { throwIfNoEntry: false })?.isFile()) {
        response.writeHead(404).end('not found');
        return;
      }
      response.writeHead(200, {
        'Content-Type': contentType(filename),
        'Cache-Control': 'no-store',
        'Connection': 'close',
      });
      fs.createReadStream(filename).pipe(response);
    } catch (error) {
      response.writeHead(500).end(String(error));
    }
  });

  await new Promise((resolve, reject) => {
    server.once('error', reject);
    server.listen(0, '127.0.0.1', resolve);
  });
  try {
    const address = server.address();
    await run(new URL(`http://127.0.0.1:${address.port}/`));
  } finally {
    await new Promise((resolve, reject) => {
      server.close((error) => error ? reject(error) : resolve());
      server.closeAllConnections?.();
    });
  }
}

function contentType(filename) {
  switch (path.extname(filename)) {
    case '.html': return 'text/html; charset=utf-8';
    case '.js':
    case '.mjs': return 'text/javascript; charset=utf-8';
    case '.json': return 'application/json; charset=utf-8';
    case '.png': return 'image/png';
    default: return 'text/plain; charset=utf-8';
  }
}

function deterministicClock() {
  let value = 0;
  return () => value++;
}

function assert(condition, message) {
  if (!condition) throw new Error(message);
}

if (isMainModule(import.meta.url)) {
  await runStandalone(runPlayground);
}
