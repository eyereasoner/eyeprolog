// Shared fixtures and filesystem helpers used across test suites.
import fs from 'node:fs';
import path from 'node:path';
import { COMPOUND, Env, VAR, compound } from '../src/term.js';
import { parseProgramText } from '../src/parser.js';
import { formatTermForWrite } from '../src/write.js';
import { RESULT_FORMAT_HEADER, resultWriteOptions } from '../src/result-format.js';
import { makeProgram } from '../src/program.js';

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

// A run's answers, in the bare `fact.` form assertions written before the
// result-document format used.
//
// `run` returns a Prolog result document: `query/3` records the question and
// `answer/2` the bindings of its variables. Many assertions here only care
// that a goal produced a particular ground answer, which reads better as the
// answer term itself than as its bindings, so this puts the bindings back
// into the goal they came from. Anything the program itself wrote is kept in
// front, as it was.
export function answerFacts(stdout) {
  const text = String(stdout);
  const document = text.indexOf(RESULT_FORMAT_HEADER);
  if (document < 0) return text;
  const written = text.slice(0, document);
  // A program that declares its own operators writes answers using them,
  // and they are not declared in the document. Where the standard table is
  // not enough to read it back, the caller sees the document as it is.
  let clauses;
  try {
    clauses = parseProgramText(text.slice(document), { sourceMetadata: false });
  } catch {
    return text;
  }

  const queries = new Map();
  const lines = [];
  for (const clause of clauses) {
    const head = clause?.head;
    if (head?.type !== COMPOUND || clause.body?.length !== 0) continue;
    const id = String(head.args[0]?.name);
    if (head.name === 'query' && head.arity === 3) {
      queries.set(id, { goal: head.args[1], variables: bindingPairs(head.args[2]) });
      continue;
    }
    if (head.name !== 'answer' || head.arity !== 2) continue;
    const query = queries.get(id);
    if (!query) continue;
    const values = new Map(bindingPairs(head.args[1]).map(({ name, value }) => [name, value]));
    const substitution = new Map(query.variables.map(({ name, value }) => [value.name, values.get(name)]));
    lines.push(`${formatTermForWrite(substituteVariables(query.goal, substitution), new Env(), standardWriteOptions())}.`);
  }
  return lines.length ? `${written}${lines.join('\n')}\n` : written;
}

// The standard operator table, so an answer prints the way the run printed
// it rather than in canonical functional notation.
let cachedWriteOptions = null;
function standardWriteOptions() {
  if (cachedWriteOptions == null) cachedWriteOptions = resultWriteOptions(makeProgram('', { filename: '<answers>' }));
  return cachedWriteOptions;
}

function bindingPairs(list) {
  const pairs = [];
  let tail = list;
  while (tail?.type === COMPOUND && tail.name === '.' && tail.arity === 2) {
    const item = tail.args[0];
    if (item?.type === COMPOUND && item.name === '=' && item.arity === 2) {
      pairs.push({ name: String(item.args[0].name), value: item.args[1] });
    }
    tail = tail.args[1];
  }
  return pairs;
}

function substituteVariables(term, substitution) {
  if (term?.type === VAR) return substitution.get(term.name) ?? term;
  if (term?.type === COMPOUND) return compound(term.name, term.args.map((arg) => substituteVariables(arg, substitution)));
  return term;
}
