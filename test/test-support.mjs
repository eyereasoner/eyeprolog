// Shared fixtures and filesystem helpers used across test suites.
import fs from 'node:fs';
import path from 'node:path';

const libraryCall = /\b(?:uuid|difference|maplist|foldl|call_nth|lt|gt|le|ge|between|smallest_divisor_from|random|matches|split|replace|lowercase|uppercase|trim|number_string|atom_string|term_string|append|string_concat|contains|join|substring|member|select|last|nth0|nth1|set_nth0|take|drop|slice|reverse|length|sum_list|min_list|max_list|list_to_set|countall|sumall|aggregate_min|aggregate_max)\s*\(/;

const standardModulePrelude = `:- use_module(library(aggregate)).
:- use_module(library(comparison)).
:- use_module(library(dates)).
:- use_module(library(iso_ext)).
:- use_module(library(lists)).
:- use_module(library(primes)).
:- use_module(library(between), [between/3]).
:- use_module(library(random)).
:- use_module(library(strings)).
:- use_module(library(uuid)).
`;

export function withStandardModules(source) {
  const text = String(source);
  if (!libraryCall.test(text) || text.includes('use_module(library(') || text.includes(':- module(')) return text;
  return `${standardModulePrelude}${text}`;
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
