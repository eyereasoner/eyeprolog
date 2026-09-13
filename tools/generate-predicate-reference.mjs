#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { createDefaultRegistry } from '../src/iso.js';
import { eyePrologLibraryAutoload } from '../src/library-autoload-index.js';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const metadataFile = path.join(root, 'tools', 'predicate-reference.json');
const bookFile = path.join(root, 'the-art-of-eyeprolog.md');
const START = '<!-- eyeprolog-predicate-reference:start -->';
const END = '<!-- eyeprolog-predicate-reference:end -->';
const CHAPTER_END = '\n## 40. Running EyeProlog: command line and corpus';
const EXPECTED_COUNT = 533;
const allowedSolutions = new Set([
  'det', 'semidet', 'multi', 'nondet', 'delayed', 'meta', 'mode-dependent',
  'declaration', 'terminal',
]);

function fail(message) {
  console.error(message);
  process.exit(1);
}

function liveSurface() {
  const core = new Set(createDefaultRegistry().defs.keys());
  const library = new Map(Object.entries(eyePrologLibraryAutoload));
  const indicators = [...new Set([...core, ...library.keys()])].sort((a, b) => a.localeCompare(b));
  return { core, library, indicators };
}

function loadMetadata() {
  let data;
  try {
    data = JSON.parse(fs.readFileSync(metadataFile, 'utf8'));
  } catch (error) {
    fail(`cannot read ${path.relative(root, metadataFile)}: ${error.message}`);
  }
  if (data?.schema !== 1 || !Array.isArray(data.entries)) {
    fail(`${path.relative(root, metadataFile)} must use schema 1 with an entries array`);
  }
  return data;
}

function validateMetadata(data, surface) {
  const issues = [];
  const byIndicator = new Map();
  for (const entry of data.entries) {
    if (entry == null || typeof entry !== 'object') {
      issues.push('metadata entry is not an object');
      continue;
    }
    const indicator = entry.indicator;
    if (typeof indicator !== 'string' || indicator.length === 0) {
      issues.push('metadata entry has no predicate indicator');
      continue;
    }
    if (byIndicator.has(indicator)) issues.push(`duplicate metadata entry: ${indicator}`);
    byIndicator.set(indicator, entry);
    for (const field of ['origin', 'call', 'solutions', 'contract', 'source', 'profile']) {
      if (typeof entry[field] !== 'string' || entry[field].trim() === '') {
        issues.push(`${indicator}: missing ${field}`);
      }
    }
    if (!allowedSolutions.has(entry.solutions)) {
      issues.push(`${indicator}: unsupported solutions value ${JSON.stringify(entry.solutions)}`);
    }
    if (typeof entry.contract === 'string' && !/[.!?]$/.test(entry.contract.trim())) {
      issues.push(`${indicator}: contract must end with punctuation`);
    }
    if (typeof entry.source === 'string') {
      for (const source of entry.source.split(';').map((part) => part.trim()).filter(Boolean)) {
        if (!fs.existsSync(path.join(root, source))) issues.push(`${indicator}: missing source ${source}`);
      }
    }
  }

  const live = new Set(surface.indicators);
  for (const indicator of surface.indicators) {
    if (!byIndicator.has(indicator)) issues.push(`missing predicate contract: ${indicator}`);
  }
  for (const indicator of byIndicator.keys()) {
    if (!live.has(indicator)) issues.push(`stale predicate contract: ${indicator}`);
  }
  if (surface.indicators.length !== EXPECTED_COUNT) {
    issues.push(`live predicate surface is ${surface.indicators.length}, expected ${EXPECTED_COUNT}`);
  }
  if (data.surface_count !== EXPECTED_COUNT) {
    issues.push(`metadata surface_count is ${data.surface_count}, expected ${EXPECTED_COUNT}`);
  }
  if (byIndicator.size !== EXPECTED_COUNT) {
    issues.push(`metadata contains ${byIndicator.size} distinct entries, expected ${EXPECTED_COUNT}`);
  }

  // Origin/profile checks are structural: semantic contracts stay human-maintained.
  for (const indicator of surface.indicators) {
    const entry = byIndicator.get(indicator);
    if (entry == null) continue;
    const inCore = surface.core.has(indicator);
    const provider = surface.library.get(indicator);
    if (inCore && provider != null) {
      if (entry.profile !== 'core+library') issues.push(`${indicator}: expected core+library profile`);
      if (!entry.origin.includes('ISO core') || !entry.origin.includes(`library(${provider})`)) {
        issues.push(`${indicator}: origin does not identify ISO core and library(${provider})`);
      }
    } else if (inCore) {
      if (entry.profile !== 'core') issues.push(`${indicator}: expected core profile`);
      if (entry.origin !== 'ISO core') issues.push(`${indicator}: core origin must be ISO core`);
    } else {
      if (entry.profile !== 'library') issues.push(`${indicator}: expected library profile`);
      if (entry.origin !== `library(${provider})`) {
        issues.push(`${indicator}: library origin must be library(${provider})`);
      }
    }
  }

  return { issues, byIndicator };
}

function code(value) {
  const text = String(value);
  const fence = text.includes('`') ? '``' : '`';
  return `${fence}${text}${fence}`;
}

function groupKey(indicator) {
  const first = Array.from(indicator)[0] ?? '';
  if (/[A-Za-z]/.test(first)) return first.toUpperCase();
  return 'Symbols';
}

function renderSection(byIndicator, surface) {
  const groups = new Map();
  for (const indicator of surface.indicators) {
    const key = groupKey(indicator);
    const list = groups.get(key) ?? [];
    list.push(byIndicator.get(indicator));
    groups.set(key, list);
  }
  const keys = [...groups.keys()].sort((a, b) => {
    if (a === 'Symbols') return -1;
    if (b === 'Symbols') return 1;
    return a.localeCompare(b);
  });

  const lines = [
    START,
    '### Complete predicate indicator reference',
    '',
    `The normal EyeProlog surface contains **${EXPECTED_COUNT} distinct predicate indicators**: ` +
      `${surface.core.size} core registry indicators plus ${surface.library.size} bundled-library indicators, with ` +
      '`phrase/2` and `phrase/3` present in both layers and therefore counted once.',
    '',
    'Each entry is a compact contract. `+` marks a principal input, `-` a principal output, and `?` an argument that may be supplied or produced. ' +
      'These are documented operating modes rather than parser-enforced mode declarations. **Solutions** uses `det`, `semidet`, `multi`, `nondet`, `delayed`, `meta`, `mode-dependent`, `declaration`, or `terminal`; `meta` means the solution behavior depends materially on a called goal.',
    '',
    '#### Predicate index',
    '',
    'Each indicator links directly to its contract.',
    '',
  ];

  const anchorByIndicator = new Map(
    surface.indicators.map((indicator, index) => [indicator, `predicate-reference-${String(index + 1).padStart(4, '0')}`]),
  );

  for (const key of keys) {
    const entries = groups.get(key);
    lines.push(`**${key}:** ${entries.map((entry) => `[${code(entry.indicator)}](#${anchorByIndicator.get(entry.indicator)})`).join(' · ')}`);
    lines.push('');
  }

  for (const key of keys) {
    lines.push(`#### Predicate reference — ${key}`);
    lines.push('');
    for (const entry of groups.get(key)) {
      lines.push(`<a id="${anchorByIndicator.get(entry.indicator)}"></a>`);
      lines.push(`- **${code(entry.indicator)}** — ${code(entry.origin)} · **${code(entry.solutions)}**  `);
      lines.push(`  **Call:** ${code(entry.call)}  `);
      lines.push(`  **Contract:** ${entry.contract}`);
    }
    lines.push('');
  }
  lines.push(END);
  return `${lines.join('\n')}\n`;
}

function expectedBook(book, generated) {
  const start = book.indexOf(START);
  const end = book.indexOf(END);
  if (start >= 0 || end >= 0) {
    if (start < 0 || end < 0 || end < start) fail('predicate-reference markers are malformed in the book');
    const after = end + END.length;
    return `${book.slice(0, start)}${generated}${book.slice(after).replace(/^\n*/, '\n')}`;
  }
  const chapterEnd = book.indexOf(CHAPTER_END);
  if (chapterEnd < 0) fail(`cannot insert predicate reference: Chapter 40 heading not found`);
  return `${book.slice(0, chapterEnd).replace(/\n*$/, '\n\n')}${generated}\n${book.slice(chapterEnd + 1)}`;
}

const surface = liveSurface();
const data = loadMetadata();
const { issues, byIndicator } = validateMetadata(data, surface);
if (issues.length > 0) fail(issues.map((issue) => `- ${issue}`).join('\n'));

const book = fs.readFileSync(bookFile, 'utf8');
const generated = renderSection(byIndicator, surface);
const wanted = expectedBook(book, generated);

if (process.argv.includes('--check')) {
  if (wanted !== book) {
    console.error(`${path.relative(root, bookFile)} predicate reference is stale; run node tools/generate-predicate-reference.mjs (npm version regenerates it automatically)`);
    process.exit(1);
  }
  console.log(`${path.relative(root, bookFile)} predicate reference is up to date (${surface.indicators.length} predicates)`);
} else {
  fs.writeFileSync(bookFile, wanted);
  console.log(`updated ${path.relative(root, bookFile)} predicate reference (${surface.indicators.length} predicates)`);
}
