// Shared fixtures and helpers for the regression case modules.
// Split out of run-regression.mjs so the runner, the four case sections, and
// their helpers can be read and edited independently. Case order within each
// section is load-bearing: the parallel worker protocol keys results by
// (sectionKey, index), so cases must keep their original relative order.
import fs from 'node:fs';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import publicDefaultApi from '../../index.js';
import * as publicApi from '../../src/index.js';
import { Program, createDefaultRegistry, eyePrologLibraryIndicators, eyePrologNativeLibraryIndicators, run as runEyeProlog, standardLibrarySources } from '../../src/index.js';
import { parseGoalText } from '../../src/parser.js';
import { assertEqual, assertIncludes, assertNotIncludes } from '../test-style.mjs';
import { buildConformanceReport } from '../run-conformance-report.mjs';
import { proofExamples } from '../run-examples.mjs';
import { goalsFromSource } from '../goal-metadata.mjs';
import { withStandardModules } from '../test-support.mjs';

// Temp-directory state shared with the runner. The runner creates and removes
// the directory; cases read `temp.dir` and take fresh ids from
// `temp.counter`. A mutable holder is used because ESM live bindings are
// read-only for importers.
export const temp = { dir: null, counter: 0 };

// Case modules resolve sibling paths against the test/ directory. They used to
// use import.meta.url while they lived in test/run-regression.mjs; anchoring on
// this constant keeps those URLs pointing at the same files from test/regression/.
export const testDirUrl = new URL('../', import.meta.url).href;

export const testRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');

export const packageRoot = path.resolve(testRoot, '..');

export const bin = path.join(packageRoot, 'bin', 'eyeprolog.js');

export const pkg = JSON.parse(fs.readFileSync(path.join(packageRoot, 'package.json'), 'utf8'));

export const DCG_HANDOFF_TEST_TIMEOUT_MS = 20_000;

export function run(source, options = {}) {
  const programSource = Array.isArray(source) ? source.join('\n') : source;
  const text = programSource instanceof Program ? programSource : withStandardModules(String(programSource));
  const goals = options.goals ?? (options.goal == null
    ? (programSource instanceof Program ? [] : goalsFromSource(text))
    : [options.goal]);
  return runEyeProlog(programSource instanceof Program ? programSource : text, { ...options, goals });
}

export function sourceAtom(value) {
  return `'${String(value).replaceAll('\\', '\\\\').replaceAll("'", "''")}'`;
}

export function bookReferenceDocumentationIssues() {
  const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyeprolog.md'), 'utf8');
  const guide = fs.readFileSync(path.join(testRoot, 'conformance', 'README.md'), 'utf8');
  const issues = [];

  if (!book.includes('This book is also the reference for the EyeProlog implementation.')) {
    issues.push('book introduction does not identify itself as the reference');
  }
  if (!book.includes('This book is the single reference for the EyeProlog implementation.')) {
    issues.push('book Chapter 42 does not state the single-reference policy');
  }
  for (const standard of [
    'ISO/IEC 13211-1:1995',
    'Technical Corrigendum 1:2007',
    'Technical Corrigendum 2:2012',
    'Technical Corrigendum 3:2017',
  ]) {
    if (!book.includes(standard)) issues.push(`book does not identify standards baseline: ${standard}`);
  }
  if (!book.includes('EyeProlog performs it consistently for ordinary\nunification as well as `unify_with_occurs_check/2`.')) {
    issues.push('book glossary does not match finite-tree unification');
  }
  if (book.includes('EyeProlog does not perform it.')) {
    issues.push('book contradicts implementation occurs-check behavior');
  }
  for (const heading of ['## 38. Language and ISO profile', '## 39. Predicate reference', '## 40. Running EyeProlog: command line and corpus']) {
    if (!book.includes(heading)) issues.push(`book is missing ${heading}`);
  }
  if (!guide.includes('[*The Art of EyeProlog*](../../the-art-of-eyeprolog.md) is the reference')) {
    issues.push('test guide does not identify the book as the reference');
  }
  if (!guide.includes('not a separate\nlanguage specification')) {
    issues.push('test guide presents the suite as a separate specification');
  }

  return issues;
}

export function runWhy({ program, goalText, expected }) {
  program = withStandardModules(program);
  const programFile = path.join(temp.dir, `${++temp.counter}.pl`);
  fs.writeFileSync(programFile, program);
  const goal = parseGoalText(goalText);
  const parsed = Program.parseSources([{ text: program, filename: path.basename(programFile) }], { sourceMetadata: true });
  const result = runEyeProlog(parsed, { proof: true, goal });
  const expectedText = expected.replaceAll('__FILE__', path.basename(programFile));
  assertEqual(result.stdout, expectedText, 'stdout');

  Program.parse(result.stdout);
  assertIncludes(result.stdout, '  proof(\n', 'stdout');
  assertIncludes(result.stdout, ' by(rule("', 'stdout');
  assertIncludes(result.stdout, ', clause(', 'stdout');
  assertNotIncludes(result.stdout, 'source(head(', 'stdout');
  assertIncludes(result.stdout, '\n).\n\n', 'stdout');
}

export function runWhyLoose({ program, goalText }) {
  program = withStandardModules(program);
  const programFile = path.join(temp.dir, `${++temp.counter}.pl`);
  fs.writeFileSync(programFile, program);
  const goal = parseGoalText(goalText);
  const parsed = Program.parseSources([{ text: program, filename: path.basename(programFile) }], { sourceMetadata: true });
  const result = runEyeProlog(parsed, { proof: true, goal });
  Program.parse(result.stdout);
  assertIncludes(result.stdout, '\n).\n\n', 'stdout');
  return result;
}

function listExampleNames() {
  return fs.readdirSync(path.join(packageRoot, 'examples'))
    .filter((name) => name.endsWith('.pl'))
    .map((name) => name.slice(0, -3))
    .sort();
}

function listGoldenExampleNames() {
  return fs.readdirSync(path.join(packageRoot, 'examples', 'output'))
    .filter((name) => name.endsWith('.pl'))
    .map((name) => name.slice(0, -3))
    .sort();
}

export function exampleCorpusSyncIssues() {
  const examples = listExampleNames();
  const issues = arrayDiffMessages(listGoldenExampleNames(), examples, 'examples/output');
  const checks = [
    {
      file: path.join(packageRoot, 'the-art-of-eyeprolog.md'),
      pattern: /top-level directory contains \*\*(\d+) self-contained runnable programs\*\*/,
    },
  ];
  for (const check of checks) {
    const relative = path.relative(packageRoot, check.file);
    const match = fs.readFileSync(check.file, 'utf8').match(check.pattern);
    if (match == null) {
      issues.push(`${relative}: runnable example count not found`);
    } else if (Number(match[1]) !== examples.length) {
      issues.push(`${relative}: runnable example count ${match[1]} != ${examples.length}`);
    }
  }
  return issues.sort();
}

export function proofCorpusSyncIssues() {
  const proofDir = path.join(packageRoot, 'examples', 'proof');
  const goldens = fs.readdirSync(proofDir)
    .filter((name) => name.endsWith('.pl'))
    .sort();
  const configured = [...proofExamples].sort();
  const issues = arrayDiffMessages(configured, goldens, 'proof example runner');
  for (const name of goldens) {
    if (!fs.existsSync(path.join(packageRoot, 'examples', name))) {
      issues.push(`examples/proof/${name}: source example is missing`);
    }
  }
  const checks = [
    {
      file: path.join(packageRoot, 'the-art-of-eyeprolog.md'),
      pattern: /\*\*(\d+) selected programs\*\* have a checked/,
    },
  ];
  for (const check of checks) {
    const relative = path.relative(packageRoot, check.file);
    const match = fs.readFileSync(check.file, 'utf8').match(check.pattern);
    if (match == null) {
      issues.push(`${relative}: proof example count not found`);
    } else if (Number(match[1]) !== goldens.length) {
      issues.push(`${relative}: proof example count ${match[1]} != ${goldens.length}`);
    }
  }
  return issues.sort();
}

export function bookExampleCatalogIssues() {
  const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyeprolog.md'), 'utf8');
  const section = between(book, '### Further examples', '## 42. Standards, limits, and implementation boundaries');
  const names = [...section.matchAll(/github\.com\/eyereasoner\/eyeprolog\/blob\/main\/examples\/([A-Za-z0-9_-]+)\.pl/g)]
    .map((match) => match[1]);
  const issues = [];
  if (names.length === 0) issues.push('no source example links found');
  for (const name of names) {
    if (!fs.existsSync(path.join(packageRoot, "examples", name + ".pl"))) issues.push("missing examples/" + name + ".pl");
    if (!fs.existsSync(path.join(packageRoot, "examples", "output", name + ".pl"))) issues.push("missing examples/output/" + name + ".pl");
  }
  return [...new Set(issues)].sort();
}

export function playgroundExampleIssues() {
  const issues = [];
  const expected = listExampleNames();
  const html = fs.readFileSync(path.join(packageRoot, 'playground.html'), 'utf8');
  const match = html.match(/const EXAMPLES = (\[[\s\S]*?\]);/);
  if (match == null) return ['playground EXAMPLES array not found'];
  const examples = JSON.parse(match[1]).sort();
  issues.push(...arrayDiffMessages(examples, expected, 'playground EXAMPLES'));
  if (!html.includes('new URL(`./examples/${name}.pl`, location.href)')) {
    issues.push('playground must load selected examples from relative ./examples/*.pl URLs');
  }
  if (!html.includes("fetch(exampleUrl, { cache: 'no-store' })")) {
    issues.push('playground must fetch selected example source from its relative URL');
  }
  return issues.sort();
}

export function playgroundStaticIssues() {
  const issues = [];
  const playgroundPath = path.join(packageRoot, 'playground.html');
  const html = fs.readFileSync(playgroundPath, 'utf8');
  const readme = fs.readFileSync(path.join(packageRoot, 'README.md'), 'utf8');
  if (!pkg.files?.includes('playground.html')) issues.push('package files must include playground.html');
  if (!readme.includes('[Playground](https://eyereasoner.github.io/eyeprolog/playground)')) issues.push('README must link to the GitHub Pages playground URL');
  if (!html.includes('<meta name="viewport" content="width=device-width, initial-scale=1">')) issues.push('missing mobile viewport meta');
  if (!html.includes('main {') || !html.includes('display: block;')) {
    issues.push('playground must use a simple vertical layout');
  }
  if (!html.includes('@media (max-width: 560px)') || !html.includes('button,') || !html.includes('width: 100%')) {
    issues.push('playground must make controls usable at phone widths');
  }
  if (!html.includes('<summary id="advanced-heading">⚙ Advanced configuration</summary>')) {
    issues.push('playground must keep URL/proof controls inside advanced configuration');
  }
  if (!html.includes('id="load-background"') || !html.includes('backgroundSource') || !html.includes('combinedSource()')) {
    issues.push('playground must support loading URL content as background knowledge');
  }
  if (!html.includes('HIGHLIGHT_LIMIT') || !html.includes('text.length > HIGHLIGHT_LIMIT')) {
    issues.push('playground must avoid full syntax coloring for very large examples');
  }
  if (!html.includes('<script type="module">')) issues.push('playground script must be an ES module');
  if (!html.includes("new URL('./src/playground-worker.js?playground=")) issues.push('playground must cache-bust its dedicated module worker');
  if (!html.includes("new Worker(workerUrl, { type: 'module' })")) issues.push('playground must launch the dedicated module worker');
  const workerText = fs.readFileSync(path.join(packageRoot, 'src', 'playground-worker.js'), 'utf8');
if (!workerText.includes("from './index.js?playground=") ||
      !workerText.includes('createEyePrologRegistry') ||
      !workerText.includes('executePlaygroundRequest')) {
    issues.push('playground worker must install the EyeProlog library registry');
  }
  if (fs.existsSync(path.join(packageRoot, 'src', 'portable-library.js'))) {
    issues.push('obsolete portable-library.js must be absent');
  }
  for (const filename of ['src/playground-worker.js', 'src/index.js', 'src/program.js', 'src/io.js']) {
    const sourceText = fs.readFileSync(path.join(packageRoot, filename), 'utf8');
    if (/^\s*import\s+[^('\"]*['\"]node:/m.test(sourceText)) {
      issues.push(`${filename} must not statically import Node built-ins in the browser graph`);
    }
  }
  const platformText = fs.readFileSync(path.join(packageRoot, 'src', 'platform.js'), 'utf8');
  if (!platformText.includes("await import('node:fs')") || !platformText.includes("await import('node:path')")) {
    issues.push('browser platform bridge must guard Node built-ins behind dynamic imports');
  }
  if (!html.includes('activeWorker.onmessageerror') || !html.includes('Serve the checkout over HTTP(S)')) {
    issues.push('playground must report actionable worker startup and message errors');
  }
  if (!html.includes('class="editor"') || !html.includes('id="highlight"') || !html.includes('id="source"')) {
    issues.push('playground must include layered syntax-colored editor');
  }
  if (!html.includes('--editor-bg: #ffffff') || !html.includes('background: var(--editor-bg)')) {
    issues.push('playground editor must use a light editor background');
  }
  if (!html.includes('id="error-line-marker"') || !html.includes('extractParseErrorLine') || !html.includes('markSyntaxErrorLine') || !html.includes('--editor-error-line')) {
    issues.push('playground must highlight syntax-error lines in the editor');
  }
  if (!html.includes('id="line-numbers"') || !html.includes('updateLineNumbers') || !html.includes('lineNumbersInner.style.transform') || !html.includes('--line-number-bg')) {
    issues.push('playground editor must include synced line numbers');
  }
  if (!html.includes('MAX_SHARE_URL_LENGTH') || !html.includes('buildReferenceShareLink') || !html.includes("params.set('example'") || !html.includes("params.set('url'")) {
    issues.push('playground share links must avoid embedding large example or URL-loaded sources');
  }
  if (!html.includes('id="create-gist"') || !html.includes('createGistShare') || !html.includes('GIST_STATE_FILENAME') || !html.includes("fetch('https://api.github.com/gists'")) {
    issues.push('playground must support Gist-backed sharing for large programs');
  }
  if (!html.includes('await createGistShare({') || html.includes('Use “Create Gist share” instead')) {
    issues.push('playground Copy share link must automatically fall back to Gist sharing for large programs');
  }
  if (!html.includes("params.has('state-url')") || !html.includes('#state-url=')) {
    issues.push('playground must restore state from raw Gist state URLs');
  }
  if (!html.includes('id="example-search"') || !html.includes('id="examples"')) issues.push('playground must include searchable examples');
  const scriptMatch = html.match(new RegExp('<script type="module">\\n([\\s\\S]*?)\\n  <\\/script>'));
  if (scriptMatch == null) {
    issues.push('module script not found');
  } else {
    const scriptFile = path.join(temp.dir, 'playground-script.mjs');
    fs.writeFileSync(scriptFile, scriptMatch[1]);
    const result = spawnSync(process.execPath, ['--check', scriptFile], { encoding: 'utf8' });
    if (result.status !== 0) issues.push(`playground module syntax check failed: ${result.stderr.trim()}`);
  }
  return issues.sort();
}

export function registeredBuiltinNames() {
  return [...createDefaultRegistry().defs.keys()].sort();
}

export function registeredEyePrologLibraryNames() {
  return [...eyePrologLibraryIndicators].sort();
}

export function registeredNativeEyePrologLibraryNames() {
  return [...eyePrologNativeLibraryIndicators].sort();
}

export function registeredBuiltinSummary() {
  const names = registeredBuiltinNames();
  return {
    entries: names.length,
    names: new Set(names.map((name) => name.split('/')[0])).size,
  };
}

export function bookBuiltinNames() {
  const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyeprolog.md'), 'utf8');
  return documentedBuiltinNames(
    between(book, '<!-- eyeprolog-core-catalog:start -->', '<!-- eyeprolog-core-catalog:end -->'),
  );
}

export function bookEyePrologLibraryNames() {
  const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyeprolog.md'), 'utf8');
  const iso = new Set(registeredBuiltinNames());
  const section = between(book, '<!-- eyeprolog-library-catalog:start -->', '<!-- eyeprolog-library-catalog:end -->');
  const exports = section.split('\n')
    .filter((line) => line.trimStart().startsWith('**Exports:**'))
    .join('\n');
  return documentedBuiltinNames(exports).filter((indicator) => !iso.has(indicator));
}

export function bookLibraryModuleIssues() {
  const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyeprolog.md'), 'utf8');
  const section = between(book, '<!-- eyeprolog-library-catalog:start -->', '<!-- eyeprolog-library-catalog:end -->');
  const documented = new Map();
  const lines = section.split('\n');
  for (let i = 0; i < lines.length; i++) {
    const match = lines[i].match(/^- \*\*`library\(([^)`]+)\)`\*\*/);
    if (match == null) continue;
    const exports = lines[i + 1] ?? '';
    documented.set(match[1], documentedBuiltinNames(exports));
  }

  const issues = [];
  for (const [moduleName, entry] of standardLibrarySources) {
    const parsed = Program.parse(entry.source);
    const definition = parsed.modules.get(moduleName);
    if (definition == null) {
      issues.push(`missing module declaration for ${moduleName}`);
      continue;
    }
    const actual = [...definition.exports.keys()].sort();
    const expected = documented.get(moduleName);
    if (expected == null) {
      issues.push(`book catalog omits library(${moduleName})`);
      continue;
    }
    if (JSON.stringify(expected) !== JSON.stringify(actual)) {
      issues.push(`library(${moduleName}) exports: expected ${actual.join(', ')}, documented ${expected.join(', ')}`);
    }
  }
  for (const moduleName of documented.keys()) {
    if (!standardLibrarySources.has(moduleName)) issues.push(`book catalogs unknown library(${moduleName})`);
  }
  return issues.sort();
}

export function bookBuiltinSummary() {
  const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyeprolog.md'), 'utf8');
  const match = book.match(/(?:registers|contains) (\d+) name\/arity entries across (\d+) names/);
  if (match == null) throw new Error('book builtin summary not found');
  return { entries: Number(match[1]), names: Number(match[2]) };
}

function documentedBuiltinNames(section) {
  const names = [];
  for (const match of section.matchAll(/`([^`]+)`/g)) {
    const indicator = match[1].match(/^(.+)\/(\d+)$/);
    if (indicator == null) continue;
    names.push(`${indicator[1]}/${indicator[2]}`);
  }
  return [...new Set(names)].sort();
}

export function runtimeExportNames() {
  return Object.keys(publicApi).sort();
}

export function runtimeDefaultExportNames() {
  return Object.keys(publicDefaultApi).sort();
}

export function declaredValueExportNames() {
  const dts = fs.readFileSync(path.join(packageRoot, 'index.d.ts'), 'utf8');
  return [...dts.matchAll(/^export\s+(?:declare\s+)?(?:class|function|const)\s+([A-Za-z_][A-Za-z0-9_]*)/gm)]
    .map((match) => match[1])
    .filter((name, index, names) => names.indexOf(name) === index)
    .sort();
}

export function declaredDefaultExportNames() {
  const dts = fs.readFileSync(path.join(packageRoot, 'index.d.ts'), 'utf8');
  const declaration = dts.match(/declare const eyeprolog: \{([\s\S]*?)\n\};/);
  if (declaration == null) throw new Error('default export declaration not found');
  return [...declaration[1].matchAll(/^\s+([A-Za-z_][A-Za-z0-9_]*): typeof /gm)]
    .map((match) => match[1])
    .sort();
}

export function missingDocumentedPackageScripts() {
  const docs = documentationFiles();
  const missing = [];
  // Native npm subcommands are not package scripts, so documenting them must
  // not require a matching entry in package.json.
  const nativeCommands = new Set(['exec', 'install', 'link', 'pack', 'publish', 'version', 'ci']);
  for (const file of docs) {
    const text = fs.readFileSync(file, 'utf8');
    for (const line of text.split('\n')) {
      const trimmed = line.trim();
      const commandTexts = [];
      if (trimmed.startsWith('npm ')) commandTexts.push(trimmed);
      for (const match of line.matchAll(/`([^`]*\bnpm\s+[^`]*)`/g)) commandTexts.push(match[1].trim());
      for (const commandText of commandTexts) {
        const match = commandText.match(/^npm\s+(?:run\s+)?([A-Za-z0-9:_-]+)/);
        if (match == null) continue;
        const command = match[1];
        if (nativeCommands.has(command)) continue;
        const script = command === 'test' ? 'test' : command;
        if (!pkg.scripts?.[script]) missing.push(`${path.relative(packageRoot, file)}: npm ${command === 'test' ? 'test' : `run ${script}`}`);
      }
    }
  }
  return [...new Set(missing)].sort();
}

export function misleadingDependencyInstallDocs() {
  const misleading = [];
  for (const file of documentationFiles()) {
    const text = fs.readFileSync(file, 'utf8');
    if (text.includes('Install dependencies')) misleading.push(`${path.relative(packageRoot, file)}: Install dependencies`);
    if (text.includes('npm install\n```') || text.includes('npm install\r\n```')) {
      misleading.push(`${path.relative(packageRoot, file)}: bare npm install setup block`);
    }
  }
  return [...new Set(misleading)].sort();
}

export function documentationSourceStyleIssues() {
  const issues = [];
  const file = path.join(packageRoot, 'the-art-of-eyeprolog.md');
  const text = fs.readFileSync(file, 'utf8');
  if (text.includes('```prolog')) {
    issues.push('the-art-of-eyeprolog.md: use eyeprolog code fences instead of prolog fences');
  }
  if (/\bv\d+\.\d+(?:\.\d+)?\b/i.test(text)) {
    issues.push('the-art-of-eyeprolog.md: describe the current system instead of release chronology');
  }
  for (const block of text.matchAll(/^```eyeprolog\s*\n([\s\S]*?)^```\s*$/gm)) {
    if (/^\s*(?:eyeprolog|node|npm)\b/m.test(block[1])) {
      issues.push('the-art-of-eyeprolog.md: keep host commands outside eyeprolog code fences');
    }
  }
  return issues;
}

export function findBrokenDocLinks() {
  const broken = [];
  const anchorsByFile = new Map();
  for (const file of documentationFiles()) {
    const text = fs.readFileSync(file, 'utf8');
    for (const target of markdownLinkTargets(text)) {
      if (/^(?:https?:|mailto:)/i.test(target)) continue;
      const [targetPathRaw, fragmentRaw] = target.split('#');
      const targetPath = targetPathRaw === '' ? file : path.resolve(path.dirname(file), decodeURI(targetPathRaw));
      const display = `${path.relative(packageRoot, file)} -> ${target}`;
      if (!fs.existsSync(targetPath)) {
        broken.push(`${display} (missing target)`);
        continue;
      }
      if (fragmentRaw != null && fragmentRaw !== '') {
        const anchors = anchorsByFile.get(targetPath) ?? markdownAnchors(targetPath);
        anchorsByFile.set(targetPath, anchors);
        if (!anchors.has(fragmentRaw)) broken.push(`${display} (missing heading #${fragmentRaw})`);
      }
    }
  }
  return broken.sort();
}

function documentationFiles() {
  return listMarkdownFiles(packageRoot);
}

export function listMarkdownFiles(directory) {
  return fs.readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
    if (entry.name === 'node_modules' || entry.name === '.git') return [];
    const target = path.join(directory, entry.name);
    if (entry.isDirectory()) return listMarkdownFiles(target);
    return entry.name.endsWith('.md') ? [target] : [];
  }).sort();
}

export function documentedConformanceMetricIssues() {
  const report = buildConformanceReport();
  const iso = report.rows.find((row) => row.category === 'iso')?.total;
  const total = report.total.total;
  const checks = [
    {
      file: path.join(packageRoot, 'the-art-of-eyeprolog.md'),
      pattern: /contains (\d+) cases, including (\d+) focused ISO\s+cases/,
      expected: [total, iso],
      labels: ['total', 'ISO'],
    },
    {
      file: path.join(packageRoot, 'test', 'conformance', 'README.md'),
      pattern: /corpus has (\d+) cases in `iso\/` and (\d+) file-based conformance cases/,
      expected: [iso, total],
      labels: ['ISO', 'total'],
    },
  ];
  const issues = [];
  for (const check of checks) {
    const relative = path.relative(packageRoot, check.file);
    const match = fs.readFileSync(check.file, 'utf8').match(check.pattern);
    if (match == null) {
      issues.push(`${relative}: conformance totals not found`);
      continue;
    }
    for (let i = 0; i < check.expected.length; i++) {
      const actual = Number(match[i + 1]);
      if (actual !== check.expected[i]) {
        issues.push(`${relative}: ${check.labels[i]} count ${actual} != ${check.expected[i]}`);
      }
    }
  }
  // WG17 syntax cases are discovered live (test/neumerkel.mjs), never
  // vendored, so no document should hard-code a specific count for them: it
  // would just go stale the next time upstream adds or removes a case.
  for (const file of [
    path.join(packageRoot, 'test', 'conformance', 'README.md'),
    path.join(packageRoot, 'test', 'conformance', 'ISO-COMPLIANCE.md'),
  ]) {
    const relative = path.relative(packageRoot, file);
    const text = fs.readFileSync(file, 'utf8');
    const claims = [
      ...[...text.matchAll(/\b(\d+)-case[^\n|]*WG17/g)].map((match) => Number(match[1])),
      ...[...text.matchAll(/WG17[^\n|]*?\b(\d+) executable/g)].map((match) => Number(match[1])),
    ];
    const dynamicPolicy = /live Neumerkel|current upstream inventory|discovered dynamically/i.test(text);
    if (!dynamicPolicy) issues.push(`${relative}: WG17 dynamic-upstream policy not found`);
    for (const claim of claims) issues.push(`${relative}: WG17 count ${claim} is hard-coded, not dynamic`);
  }
  return issues.sort();
}

function markdownLinkTargets(text) {
  const markdown = [...text.matchAll(/!?\[[^\]\n]*\]\(([^)\s]+)(?:\s+"[^"]*")?\)/g)]
    .map((match) => match[1]);
  const html = [...text.matchAll(/\b(?:src|href)="([^"]+)"/g)]
    .map((match) => match[1]);
  return [...markdown, ...html];
}

export function bookIntroOutputIssues() {
  const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyeprolog.md'), 'utf8');
  const match = book.match(/The (?:first|EyeProlog) command should print:\s*```text\n([\s\S]*?)```/);
  if (match == null) return ['the-art-of-eyeprolog.md: introductory output block not found'];
  const documented = `${match[1].trimEnd()}\n`;
  const expected = fs.readFileSync(path.join(packageRoot, 'examples', 'output', 'socrates.pl'), 'utf8');
  return documented === expected
    ? []
    : ['the-art-of-eyeprolog.md: introductory Socrates output differs from examples/output/socrates.pl'];
}

export function documentedPublicApiImportIssues() {
  const exported = new Set(runtimeExportNames());
  const issues = [];
  for (const file of documentationFiles()) {
    const text = fs.readFileSync(file, 'utf8');
    for (const block of text.matchAll(/^```js\s*\n([\s\S]*?)^```\s*$/gm)) {
      for (const imported of block[1].matchAll(/import\s*\{([\s\S]*?)\}\s*from\s*['"]eyeprolog['"]/g)) {
        for (const item of imported[1].split(',')) {
          const name = item.trim().split(/\s+as\s+/)[0];
          if (name && !exported.has(name)) {
            issues.push(`${path.relative(packageRoot, file)}: imports undocumented public name ${name}`);
          }
        }
      }
    }
  }
  return issues.sort();
}

function markdownAnchors(file) {
  if (!file.endsWith('.md')) return new Set();
  const text = fs.readFileSync(file, 'utf8');
  const anchors = new Set();
  const counts = new Map();
  for (const match of text.matchAll(/^#{1,6}\s+(.+)$/gm)) {
    const base = githubSlug(match[1]);
    const count = counts.get(base) ?? 0;
    counts.set(base, count + 1);
    anchors.add(count === 0 ? base : `${base}-${count}`);
  }
  for (const match of text.matchAll(/<(?:a|[A-Za-z][A-Za-z0-9:-]*)\b[^>]*\b(?:id|name)=["']([^"']+)["'][^>]*>/g)) {
    anchors.add(match[1]);
  }
  return anchors;
}

function githubSlug(heading) {
  return heading
    .replace(/`([^`]*)`/g, '$1')
    .replace(/<[^>]+>/g, '')
    .trim()
    .toLowerCase()
    .replace(/[^\p{Letter}\p{Number}\s-]/gu, '')
    .trim()
    .replace(/\s+/g, '-');
}

export function between(text, startMarker, endMarker) {
  const start = text.indexOf(startMarker);
  if (start === -1) throw new Error(`${startMarker} not found`);
  const contentStart = start + startMarker.length;
  const end = text.indexOf(endMarker, contentStart);
  if (end === -1) throw new Error(`${endMarker} not found`);
  return text.slice(contentStart, end);
}

function shellQuote(value) {
  return `'${String(value).replaceAll("'", "'\"'\"'")}'`;
}

let utilLinuxScriptAvailable = null;

export function hasUtilLinuxScript() {
  if (process.platform === 'win32') return false;
  if (utilLinuxScriptAvailable == null) {
    const available = spawnSync('sh', ['-c',
      'command -v script >/dev/null 2>&1 && script --version 2>/dev/null | grep -qi util-linux']);
    utilLinuxScriptAvailable = available.status === 0;
  }
  return utilLinuxScriptAvailable;
}

export function runScriptedRepl(steps, { timeout = 5000 } = {}) {
  const command = `${shellQuote(process.execPath)} ${shellQuote(bin)}`;
  const payload = Buffer.from(JSON.stringify({
    command,
    cwd: packageRoot,
    steps,
    timeout,
  })).toString('base64');
  const helper = String.raw`
const { spawn } = require('node:child_process');
const config = JSON.parse(Buffer.from(process.env.EYEPROLOG_REPL_SCRIPT, 'base64').toString('utf8'));
const child = spawn('script', ['-qefc', config.command, '/dev/null'], {
  cwd: config.cwd,
  stdio: ['pipe', 'pipe', 'pipe'],
});
let stdout = '';
let stderr = '';
let cursor = 0;
let step = 0;
let finished = false;

function advance() {
  while (step < config.steps.length) {
    const current = config.steps[step];
    const index = stdout.indexOf(current.waitFor, cursor);
    if (index === -1) return;
    cursor = index + current.waitFor.length;
    child.stdin.write(current.send);
    step++;
  }
}

child.stdout.on('data', (chunk) => {
  stdout += chunk;
  advance();
});
child.stderr.on('data', (chunk) => {
  stderr += chunk;
});

const timer = setTimeout(() => {
  if (finished) return;
  finished = true;
  child.kill('SIGKILL');
  process.stdout.write(JSON.stringify({ status: null, stdout, stderr, timedOut: true, step }));
}, config.timeout);

child.on('close', (status, signal) => {
  if (finished) return;
  finished = true;
  clearTimeout(timer);
  process.stdout.write(JSON.stringify({ status, signal, stdout, stderr, timedOut: false, step }));
});
`;
  const helperResult = spawnSync(process.execPath, ['-e', helper], {
    cwd: packageRoot,
    encoding: 'utf8',
    env: { ...process.env, EYEPROLOG_REPL_SCRIPT: payload },
    timeout: timeout + 1000,
  });
  if (helperResult.error) return helperResult;
  if (helperResult.status !== 0) return helperResult;
  let result;
  try {
    result = JSON.parse(helperResult.stdout);
  } catch (error) {
    return {
      ...helperResult,
      error: new Error(`interactive REPL helper returned invalid JSON: ${error.message}`),
    };
  }
  return {
    status: result.status,
    stdout: result.stdout,
    stderr: `${result.stderr ?? ''}${helperResult.stderr ?? ''}`,
    error: result.timedOut
      ? Object.assign(new Error(`interactive REPL timed out after step ${result.step}`), { code: 'ETIMEDOUT' })
      : undefined,
  };
}

export function runCli(args, options = {}) {
  return spawnSync(process.execPath, [bin, ...args], {
    cwd: options.cwd ?? packageRoot,
    encoding: 'utf8',
    env: options.env ? { ...process.env, ...options.env } : process.env,
    input: options.input ?? undefined,
    timeout: options.timeout ?? undefined,
  });
}

function arrayDiffMessages(actual, expected, label) {
  const messages = [];
  const actualSet = new Set(actual);
  const expectedSet = new Set(expected);
  for (const item of expected) if (!actualSet.has(item)) messages.push(`${label} missing ${item}`);
  for (const item of actual) if (!expectedSet.has(item)) messages.push(`${label} has unexpected ${item}`);
  if (new Set(actual).size !== actual.length) messages.push(`${label} has duplicate entries`);
  return messages;
}

export function assertArrayEqual(actual, expected, label) {
  const actualText = actual.join('\n');
  const expectedText = expected.join('\n');
  if (actualText !== expectedText) {
    const onlyActual = actual.filter((item) => !expected.includes(item));
    const onlyExpected = expected.filter((item) => !actual.includes(item));
    throw new Error(`${label} mismatch\nonly actual: ${format(onlyActual)}\nonly expected: ${format(onlyExpected)}`);
  }
}

function format(value) {
  return typeof value === 'string' ? JSON.stringify(value) : String(value);
}
