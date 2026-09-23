// Proof serialization.
//
// A run states what it concluded and then why: each goal its queries proved
// is written as a fact, and with `--proof` the document gains the `clause/3`
// records its derivations cite and one `step/4` fact per justified
// conclusion.
//
// A step is a conclusion, the single term saying why it holds, the bindings
// that justification used, and the conclusions it used -- deliberately the
// shape eyeron, eyeling and eyeleng also write, where the three parts are
// `pe:rule`, `pe:binding` and `pe:uses`. Naming a use by its own conclusion,
// rather than by an id to be joined back, is what lets a proof be read
// downward from the claim, and what lets a checker resolve it.
//
// Because the document is ordinary Prolog, it can be saved, loaded and
// queried by another run, which records the answers as data rather than
// running the query again.
import { COMPOUND, Env, VAR, atom, compound, listFromItems, numberTerm, variable } from './term.js';
import { formatTermForWrite } from './write.js';


// How wide one fact may be before it is broken across lines.
const WIDTH = 96;

export function resultWriteOptions(program, { doubleQuotes = 'chars', doubleBar = true } = {}) {
  return { doubleQuotes, doubleBar, operators: [...(program?.operators?.values() ?? [])], quoted: true };
}

// One argument, rendered the way a writer renders an argument: at priority
// 999, so an operator term that binds looser than `,` is parenthesized.
// Rendering it inside a throwaway one-argument compound is the direct way
// to ask the writer for exactly that.
function argumentText(term, options) {
  const wrapped = formatTermForWrite(compound('a', [term]), new Env(), options);
  return wrapped.slice(2, -1);
}

// A fact, on one line when it fits and opened out one argument per line
// when it does not.
export function formatFact(term, options) {
  const flat = formatTermForWrite(term, new Env(), options);
  if (flat.length <= WIDTH) return `${flat}.`;
  if (term.type !== COMPOUND || term.args.length === 0) return `${flat}.`;
  const indent = ' '.repeat(term.name.length + 1);
  const parts = term.args.map((arg) => wrapArgument(arg, indent, options));
  return `${term.name}(${parts.join(`,\n${indent}`)}).`;
}

// One argument of a broken fact: kept on its line when it fits, otherwise
// opened out one element (of a list) or one goal (of a conjunction) per
// line. Anything else stays flat however long it is, because breaking it
// further would not follow the term's own structure.
function wrapArgument(term, indent, options) {
  const flat = argumentText(term, options);
  if (indent.length + flat.length <= WIDTH) return flat;
  const inner = `${indent} `;
  const separator = `,\n${inner}`;

  const items = listItems(term);
  if (items) {
    const rendered = items.elements.map((item) => argumentText(item, options));
    return items.tail
      ? `[${rendered.join(separator)}|${argumentText(items.tail, options)}]`
      : `[${rendered.join(separator)}]`;
  }

  if (term.type === COMPOUND && term.name === ',' && term.arity === 2) {
    return `(${conjuncts(term).map((goal) => argumentText(goal, options)).join(separator)})`;
  }
  return flat;
}

function listItems(term) {
  if (!(term.type === COMPOUND && term.name === '.' && term.arity === 2)) return null;
  const elements = [];
  let tail = term;
  while (tail.type === COMPOUND && tail.name === '.' && tail.arity === 2) {
    elements.push(tail.args[0]);
    tail = tail.args[1];
  }
  return { elements, tail: tail.type === 'atom' && tail.name === '[]' ? null : tail };
}

function conjuncts(term) {
  if (term.type === COMPOUND && term.name === ',' && term.arity === 2) {
    return [...conjuncts(term.args[0]), ...conjuncts(term.args[1])];
  }
  return [term];
}



// A variable binding, written the way the standard's `variable_names` read
// option writes one: `'Name' = Value`.
function bindingTerm(name, value) {
  return compound('=', [atom(String(name)), value]);
}

function bindingsTerm(bindings) {
  return listFromItems(bindings.map((binding) => bindingTerm(binding.name, binding.value)));
}

// A clause template: its variables become `var('Name')` and `anonymous(N)`
// terms so that their identity survives being split out into a separate
// `clause/3` fact, where ordinary variables would each be read back as a
// fresh one.
// A variable the engine minted rather than a programmer wrote carries the
// value of a counter that advances across the whole run, so the same clause
// records a different name each time it is explained -- `Var#821735` in one
// run and `Var#225415` in the next. Only the identity matters, not the
// number, so the number is reassigned here from the clause's own order. Two
// distinct variables stay distinct; the record stops depending on how much
// work preceded it.
function mintedName(name, minted) {
  const stem = name.slice(0, name.indexOf('#'));
  if (!minted.has(name)) minted.set(name, minted.size + 1);
  return `${stem}#${minted.get(name)}`;
}

// The same renaming for a term a step records, which is an ordinary term
// rather than a clause template. A step's uses can carry a minted variable
// the goal left unbound, and it has to be the same name the `clause/3`
// record gives it.
function renameMinted(value, minted) {
  if (value == null) return value;
  if (value.type === VAR) return value.name.includes('#') ? variable(mintedName(value.name, minted)) : value;
  if (value.type === COMPOUND) return compound(value.name, value.args.map((arg) => renameMinted(arg, minted)));
  return value;
}

function templateTerm(value, anonymous, minted) {
  if (value.type === VAR) {
    if (value.name !== '_' && !value.name.startsWith('_')) {
      const name = value.name.includes('#') ? mintedName(value.name, minted) : value.name;
      return compound('var', [atom(name)]);
    }
    if (!anonymous.has(value.name)) anonymous.set(value.name, anonymous.size + 1);
    return compound('anonymous', [numberTerm(BigInt(anonymous.get(value.name)))]);
  }
  if (value.type === COMPOUND) return compound(value.name, value.args.map((arg) => templateTerm(arg, anonymous, minted)));
  return value;
}

function bodyTerm(body) {
  if (!body || body.length === 0) return atom('true');
  return body.reduceRight((rest, goal, index) => (index === body.length - 1 ? goal : compound(',', [goal, rest])), body[body.length - 1]);
}

function clauseTerm(number, clause, minted) {
  const anonymous = new Map();
  return compound('clause', [
    numberTerm(BigInt(number)),
    templateTerm(clause.head, anonymous, minted),
    templateTerm(bodyTerm(clause.body), anonymous, minted),
  ]);
}

function stepTerm(step, minted) {
  return compound('step', [
    renameMinted(step.conclusion, minted),
    step.by,
    bindingsTerm(step.bindings.map((binding) => ({ name: binding.name, value: renameMinted(binding.value, minted) }))),
    listFromItems(step.uses.map((use) => renameMinted(use, minted))),
  ]);
}


function blockLines(clauses, steps, writeOptions) {
  const lines = [];
  // One numbering across the whole document, so a minted variable is the
  // same name wherever it appears -- in a clause record and in the step that
  // cites it.
  const minted = new Map();
  const clauseTerms = clauses.map(([number, clause]) => clauseTerm(number, clause, minted));
  for (const block of [clauseTerms, steps.map((step) => stepTerm(step, minted))]) {
    if (!block.length) continue;
    lines.push('');
    for (const term of block) lines.push(formatFact(term, writeOptions));
  }
  return lines;
}

// The `clause/3` and `step/4` blocks explaining what a run claimed. They
// follow the claims, separated from them by a blank line, the way an N3
// proof's steps follow the triples they explain.
export function proofBlocks(program, clauses, steps) {
  const lines = blockLines(clauses, steps, resultWriteOptions(program));
  return lines.length ? `${lines.join('\n')}\n` : '';
}

