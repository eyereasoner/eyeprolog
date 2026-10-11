// Shared fixtures and filesystem helpers used across test suites.
import fs from 'node:fs';
import path from 'node:path';

// Import the libraries each fixture actually calls. Loading all ten libraries
// for a single member/2 or length/2 call repeats unrelated parsing, indexing,
// and dependency analysis hundreds of times across the test corpus.
const standardModules = [
  ['aggregate', /\b(?:sumall|aggregate_min|aggregate_max)\s*\(/],
  ['comparison', /\b(?:lt|gt|le|ge)\s*\(/],
  ['dates', /\bdifference\s*\(/],
  ['iso_ext', /\b(?:call_nth|countall)\s*\(/],
  ['lists', /\b(?:maplist|foldl|append|member|select|last|nth0|nth1|set_nth0|take|drop|slice|reverse|length|sum_list|min_list|max_list|list_to_set)\s*\(/],
  ['primes', /\bsmallest_divisor_from\s*\(/],
  ['between', /\bbetween\s*\(/],
  ['random', /\brandom\s*\(/],
  ['strings', /\b(?:matches|split|replace|lowercase|uppercase|trim|number_string|atom_string|term_string|string_concat|contains|join|substring)\s*\(/],
  ['uuid', /\buuid\s*\(/],
];

export function withStandardModules(source) {
  const text = String(source);
  if (text.includes('use_module(library(') || text.includes(':- module(')) return text;
  let prelude = '';
  for (const [module, calls] of standardModules) {
    if (!calls.test(text)) continue;
    const imports = module === 'between' ? ', [between/3]' : '';
    prelude += `:- use_module(library(${module})${imports}).\n`;
  }
  return `${prelude}${text}`;
}

export function listPrologFiles(base, dir = base) {
  const files = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      files.push(...listPrologFiles(base, full));
    } else if (entry.isFile() && entry.name.endsWith('.pl')) {
      files.push(path.relative(base, full).split(path.sep).join('/'));
    }
  }
  return files.sort();
}
