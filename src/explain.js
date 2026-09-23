// EyeProlog proof output helpers.
// The explanation printer replays a successful goal against the program and emits
// ordinary EyeProlog facts with nested proof terms.  Explanations are therefore both
// human-readable and machine-readable.
import { ATOM, COMPOUND, Env, Term, VAR, atom, compound, deref, flattenConjunction, freshTerm, numberTerm, properListItems, termToString, unify, variantTerms } from './term.js';
import { selectClauseCandidates } from './program.js';
import { parseGoalText, parseProgramText } from './parser.js';
import { getEyePrologRegistry } from './standard-library.js';
import { Solver, nextFreshId } from './solver.js';

let verifyFreshCounter = 0;

export function proofCertificate(program, goal, options = {}) {
  const maxDepth = options.maxDepth ?? 256;
  const registry = options.registry ?? getEyePrologRegistry();
  const env = options.env ?? new Env();
  const detail = normalizeProofDetail(options.proofDetail ?? 'abstract');
  for (const proof of proveGoalAll(program, goal, env, 0, maxDepth, registry, [], detail)) {
    const answer = resolveForProof(goal, proof.env);
    const certificate = {
      version: 1,
      detail,
      answer: termToString(answer, new Env(), true),
      proof: certificateNode(proof.node),
    };
    return { ok: true, certificate, text: renderWhyFacts(goal, proof.node, proof.env) };
  }
  return { ok: false, certificate: null, text: '' };
}

export function whyProof(program, goal, options = {}) {
  return proofCertificate(program, goal, options);
}

export function whyNoProof(goal) {
  return renderWhyNoProof(goal);
}

// Kept for embedders that already import explainProof.  The CLI exposes machine-readable output through whyProof.
export function explainProof(program, goal, options = {}) {
  return whyProof(program, goal, options);
}

function* proveGoalAll(program, goal, env, depth, maxDepth, registry, active, detail) {
  if (depth > maxDepth) return;

  if (goal.type === COMPOUND && goal.name === ',' && goal.arity === 2) {
    for (const proved of proveGoalsAll(program, flattenConjunction(goal), env, depth + 1, maxDepth, registry, active, detail)) {
      yield {
        env: proved.env,
        node: {
          goal: resolveForProof(goal, proved.env),
          method: 'conjunction',
          sourceHead: null,
          sourceBody: flattenConjunction(goal),
          bindings: [],
          children: proved.children,
        },
      };
    }
    return;
  }

  const builtin = builtinDefinition(program, goal, env, registry);
  if (builtin.handled) {
    for (const next of builtinEnvs(builtin.def, builtin.solver, goal, env)) {
      const proofEnv = next.clone ? next.clone() : next;
      yield {
        env: proofEnv,
        node: {
          goal: resolveForProof(goal, proofEnv),
          method: goalMethod('builtin', goal),
          sourceHead: resolveForProof(goal, proofEnv),
          sourceBody: [],
          bindings: [],
          children: builtinChildren(program, goal, proofEnv, depth + 1, maxDepth, registry, active, detail),
        },
      };
    }
    return;
  }

  if (goal.type !== ATOM && goal.type !== COMPOUND) return;

  const group = program.findGroup(goal.name, goal.arity, goal.module ?? 'user');
  if (!group) return;

  // Keep proof output useful when a public library predicate is implemented by
  // a standard Prolog module. The implementation remains
  // ordinary clauses, but explanations collapse its private helper expansion
  // behind an explicit library(Name, Arity) boundary.
  if (detail !== 'expanded' && group.module !== 'user' && program.modules.get(group.module)?.filename?.startsWith('src/lib/')) {
    const solver = new Solver(program, { registry });
    for (const next of solver.solve([goal], env.clone(), 0)) {
      const proofEnv = next.clone ? next.clone() : next;
      yield {
        env: proofEnv,
        node: {
          goal: resolveForProof(goal, proofEnv),
          method: goalMethod('library', goal),
          sourceHead: resolveForProof(goal, proofEnv),
          sourceBody: [],
          bindings: [],
          children: [],
        },
      };
    }
    return;
  }
  // Explanation replay does not use the solver's answer tables, so its cycle
  // guard applies even when normal execution tables this predicate.
  if (activeVariant(goal, env, active)) return;

  const candidates = selectClauseCandidates(group, goal, env);
  for (const pass of [candidates.primary, candidates.fallback]) {
    for (let candidateIndex = 0; candidateIndex < clauseCandidateLength(pass); candidateIndex++) {
      const clause = clauseCandidateAt(pass, candidateIndex);
      const id = nextFreshId();
      const freshVariables = new Map();
      const freshHead = freshTerm(clause.head, id, freshVariables);
      const freshBody = clause.body.map((term) => freshTerm(term, id, freshVariables));
      const next = env.clone();
      if (!unify(goal, freshHead, next)) continue;

      const substitutions = collectClauseSubstitutions(clause, freshHead, freshBody);
      const bindings = resolvedSubstitutions(substitutions, next);

      if (freshBody.length === 0) {
        yield {
          env: next,
          node: {
            goal: resolveForProof(goal, next),
            method: sourceMethod(clause, 'fact'),
            sourceHead: clause.head,
            sourceBody: [],
            bindings,
            children: [],
          },
        };
        continue;
      }

      let activePushed = true;
      active.push({ goal, env });
      try {
        for (const proved of proveGoalsAll(program, freshBody, next, depth + 1, maxDepth, registry, active, detail)) {
          active.pop();
          activePushed = false;
          yield {
            env: proved.env,
            node: {
              goal: resolveForProof(goal, proved.env),
              method: sourceMethod(clause, 'rule'),
              sourceHead: clause.head,
              sourceBody: clause.body,
              bindings: resolvedSubstitutions(substitutions, proved.env),
              children: proved.children,
            },
          };
          active.push({ goal, env });
          activePushed = true;
        }
      } finally {
        if (activePushed) active.pop();
      }
    }
  }
}

function clauseCandidateLength(candidate) {
  return candidate == null ? 0 : Array.isArray(candidate) ? candidate.length : 1;
}

function clauseCandidateAt(candidate, index) {
  return Array.isArray(candidate) ? candidate[index] : index === 0 ? candidate : undefined;
}

function* proveGoalsAll(program, goals, env, depth, maxDepth, registry, active, detail) {
  if (goals.length === 0) {
    yield { env: env.clone(), children: [] };
    return;
  }

  const selectedIndex = selectReadyDeterministicBuiltin(goals, env, registry);
  const goal = goals[selectedIndex];
  const rest = selectedIndex === 0 ? goals.slice(1) : [...goals.slice(0, selectedIndex), ...goals.slice(selectedIndex + 1)];

  for (const proved of proveGoalAll(program, goal, env, depth, maxDepth, registry, active, detail)) {
    for (const tail of proveGoalsAll(program, rest, proved.env, depth, maxDepth, registry, active, detail)) {
      const children = tail.children.slice();
      children.splice(selectedIndex, 0, proved.node);
      yield { env: tail.env, children };
    }
  }
}

function builtinDefinition(program, goal, env, registry) {
  if (goal.type !== ATOM && goal.type !== COMPOUND) return { handled: false, def: null, solver: null };
  const def = registry.get(goal.name, goal.arity);
  if (!def) return { handled: false, def: null, solver: null };

  const solver = new Solver(program, { registry });
  if (!builtinIsUsedForGoal(def, solver, goal, env)) return { handled: false, def: null, solver: null };
  return { handled: true, def, solver };
}

function* builtinEnvs(def, solver, goal, env) {
  for (const next of def.handler({ solver, goal, env })) yield next;
}

function builtinIsUsedForGoal(def, solver, goal, env) {
  if (typeof def.shouldUse === 'function' && !def.shouldUse({ solver, goal, env })) return false;
  if (typeof def.ready !== 'function') return true;
  if (def.ready(goal, env)) return true;
  return !def.fallbackWhenNotReady;
}

function selectReadyDeterministicBuiltin(goals, env, registry) {
  for (let i = 0; i < goals.length; i++) {
    const goal = goals[i];
    // Match solver.js's goal-type check: a 0-arity builtin (ATOM) is just as
    // eligible for this fast path as a COMPOUND one. No bundled builtin
    // currently pairs arity 0 with a custom ready() gate, so this has no
    // observable effect today, but it keeps the proof-explanation path from
    // silently diverging from actual execution if one is added later.
    if (goal.type !== COMPOUND && goal.type !== ATOM) continue;
    const def = registry.get(goal.name, goal.arity);
    if (!def?.deterministic || typeof def.ready !== 'function') continue;
    if (typeof def.shouldUse === 'function') continue;
    if (def.ready(goal, env)) return i;
  }
  return 0;
}

function builtinChildren(program, goal, env, depth, maxDepth, registry, active, detail) {
  if (goal.type !== COMPOUND) return [];
  if (goal.name === 'once' && goal.arity === 1) {
    for (const proved of proveGoalAll(program, goal.args[0], env.clone(), depth, maxDepth, registry, active, detail)) return [proved.node];
  }
  return [];
}

function activeVariant(goal, env, active) {
  return active.some((entry) => variantTerms(goal, env, entry.goal, entry.env));
}

function sourceMethod(clause, kind) {
  const source = clause.source ?? {};
  return {
    type: 'source',
    kind,
    filename: source.filename ?? '<input>',
    clause: source.clause ?? ((clause.index ?? 0) + 1),
  };
}

function goalMethod(type, goal) {
  return {
    type,
    name: goal.type === COMPOUND ? goal.name : 'goal',
    arity: goal.type === COMPOUND ? goal.arity : 0,
  };
}

function normalizeProofDetail(value) {
  if (value === 'abstract' || value === 'expanded') return value;
  throw new Error(`unknown proof detail: ${value}`);
}

function certificateNode(node) {
  return {
    goal: termToString(node.goal, new Env(), true),
    method: certificateMethod(node.method),
    bindings: node.bindings.map((binding) => ({
      name: String(binding.name),
      value: termToString(binding.value, new Env(), true),
    })),
    children: node.children.map(certificateNode),
  };
}

function certificateMethod(method) {
  if (typeof method === 'string') return { type: method };
  if (!method || typeof method !== 'object') return { type: String(method) };
  return { ...method };
}

export function proofCertificatesFromText(text, program) {
  const clauses = parseProgramText(String(text), {
    doubleQuotes: program.doubleQuotes ?? 'chars',
    sourceMetadata: false,
  });
  const certificates = [];
  for (const clause of clauses) {
    if (!clause?.head || clause.body?.length !== 0 || clause.head.type !== COMPOUND ||
        clause.head.name !== 'why' || clause.head.arity !== 2) continue;
    const proof = certificateNodeFromTerm(clause.head.args[1]);
    if (!proof) continue;
    certificates.push({
      version: 1,
      detail: containsExpandedLibrarySource(proof) ? 'expanded' : 'abstract',
      answer: termToString(clause.head.args[0], new Env(), true),
      proof,
    });
  }
  return certificates;
}

function certificateNodeFromTerm(term) {
  if (term.type !== COMPOUND || term.name !== 'step' || term.arity !== 4) return null;
  const [goal, by, bindings, uses] = term.args;
  const method = certificateMethodFromTerm(by);
  if (!method) return null;

  const bindingItems = properListItems(bindings, new Env());
  if (bindingItems == null) return null;

  const useItems = properListItems(uses, new Env());
  if (useItems == null) return null;
  const children = useItems.map(certificateNodeFromTerm);
  if (children.some((child) => child == null)) return null;

  return {
    goal: termToString(goal, new Env(), true),
    method,
    bindings: bindingItems.map((item) => {
      if (item.type !== COMPOUND || item.name !== '=' || item.arity !== 2) throw new Error('malformed certificate binding');
      return { name: certificateText(item.args[0]), value: termToString(item.args[1], new Env(), true) };
    }),
    children,
  };
}

function certificateMethodFromTerm(term) {
  if (term.type === ATOM && term.name === 'conjunction') return { type: 'conjunction' };
  if (term.type !== COMPOUND) return null;
  if ((term.name === 'fact' || term.name === 'rule') && term.arity === 2) {
    const clause = term.args[1];
    if (clause.type !== COMPOUND || clause.name !== 'clause' || clause.arity !== 1) return null;
    return { type: 'source', kind: term.name, filename: certificateText(term.args[0]), clause: Number(clause.args[0].name) };
  }
  if ((term.name === 'builtin' || term.name === 'library') && term.arity === 2) {
    return { type: term.name, name: String(term.args[0].name), arity: Number(term.args[1].name) };
  }
  return null;
}

function certificateText(term) {
  if (term.type === ATOM || term.type === 'string') return String(term.name);
  const items = properListItems(term, new Env());
  if (items != null && items.every((item) => item.type === ATOM && String(item.name).length === 1)) {
    return items.map((item) => String(item.name)).join('');
  }
  if (items != null && items.every((item) => item.type === 'number' && /^\d+$/.test(String(item.name)))) {
    const codes = items.map((item) => Number(item.name));
    if (codes.every((code) => Number.isInteger(code) && code >= 0 && code <= 0x10ffff && !(code >= 0xd800 && code <= 0xdfff))) {
      return String.fromCodePoint(...codes);
    }
  }
  throw new Error('expected certificate text');
}

function proofTreeContains(node, predicate) {
  return predicate(node) || node.children.some((child) => proofTreeContains(child, predicate));
}

const containsLibraryBoundary = (node) => proofTreeContains(node, (n) => n.method?.type === 'library');

const containsExpandedLibrarySource = (node) => proofTreeContains(
  node, (n) => n.method?.type === 'source' && String(n.method.filename ?? '').startsWith('src/lib/'),
);

export function verifyProof(program, input, options = {}) {
  const certificate = input?.certificate ?? input;
  try {
    if (!certificate || certificate.version !== 1 || typeof certificate.answer !== 'string' || !certificate.proof ||
        (certificate.detail !== 'abstract' && certificate.detail !== 'expanded')) {
      throw new Error('invalid proof certificate');
    }
    if (certificate.detail === 'abstract' && containsExpandedLibrarySource(certificate.proof)) {
      throw new Error('abstract proof certificate contains expanded library source');
    }
    if (certificate.detail === 'expanded' && containsLibraryBoundary(certificate.proof)) {
      throw new Error('expanded proof certificate contains an abstract library boundary');
    }
    const registry = options.registry ?? getEyePrologRegistry();
    const answer = parseCertificateTerm(certificate.answer, program);
    const rootGoal = parseCertificateTerm(certificate.proof.goal, program);
    const answerEnv = new Env();
    if (!unify(answer, rootGoal, answerEnv)) throw new Error('certificate answer does not match root goal');
    verifyCertificateNode(program, certificate.proof, rootGoal, registry, options, new Env());
    return { ok: true, error: null, trusted: collectTrustedBoundaries(certificate.proof) };
  } catch (error) {
    return { ok: false, error: error instanceof Error ? error.message : String(error), trusted: [] };
  }
}

function collectTrustedBoundaries(node, out = []) {
  if (node.method?.type === 'builtin' || node.method?.type === 'library') {
    out.push({
      type: node.method.type,
      name: String(node.method.name),
      arity: Number(node.method.arity),
      goal: String(node.goal),
    });
  }
  for (const child of node.children) collectTrustedBoundaries(child, out);
  return out;
}

function parseCertificateTerm(text, program) {
  return parseGoalText(String(text), { doubleQuotes: program.doubleQuotes ?? 'chars' });
}

function verifyCertificateNode(program, node, expectedGoal, registry, options, inheritedEnv) {
  if (!node || typeof node.goal !== 'string' || !node.method || !Array.isArray(node.children) || !Array.isArray(node.bindings)) {
    throw new Error('malformed proof node');
  }
  const nodeGoal = parseCertificateTerm(node.goal, program);
  if (!unify(expectedGoal, nodeGoal, inheritedEnv)) throw new Error(`proof goal mismatch: ${node.goal}`);
  const method = node.method;

  if (method.type === 'conjunction') {
    if (nodeGoal.type !== COMPOUND || nodeGoal.name !== ',' || nodeGoal.arity !== 2) throw new Error('invalid conjunction proof');
    const goals = flattenConjunction(nodeGoal);
    if (goals.length !== node.children.length) throw new Error('conjunction child count mismatch');
    for (let i = 0; i < goals.length; i++) {
      const childGoal = parseCertificateTerm(node.children[i].goal, program);
      if (!unify(goals[i], childGoal, inheritedEnv)) throw new Error(`conjunction child ${i + 1} does not match`);
      verifyCertificateNode(program, node.children[i], childGoal, registry, options, new Env());
    }
    if (node.bindings.length !== 0) throw new Error('conjunction proof must not carry clause bindings');
    return;
  }

  if (method.type === 'builtin') {
    const name = nodeGoal.type === COMPOUND || nodeGoal.type === ATOM ? nodeGoal.name : null;
    const arity = nodeGoal.type === COMPOUND ? nodeGoal.arity : 0;
    if (method.name !== name || method.arity !== arity || registry.get(name, arity) == null) {
      throw new Error(`untrusted builtin boundary: ${method.name}/${method.arity}`);
    }
    if (node.bindings.length !== 0) throw new Error('builtin proof must not carry clause bindings');
    if (name === 'once' && arity === 1) {
      if (node.children.length !== 1) throw new Error('once/1 proof requires exactly one child');
      const childGoal = parseCertificateTerm(node.children[0].goal, program);
      const innerEnv = new Env();
      if (!unify(nodeGoal.args[0], childGoal, innerEnv)) throw new Error('once/1 child does not match called goal');
      verifyCertificateNode(program, node.children[0], childGoal, registry, options, new Env());
    } else if (node.children.length !== 0) {
      throw new Error(`unexpected children for builtin ${name}/${arity}`);
    }
    return;
  }

  if (method.type === 'library') {
    const name = nodeGoal.type === COMPOUND || nodeGoal.type === ATOM ? nodeGoal.name : null;
    const arity = nodeGoal.type === COMPOUND ? nodeGoal.arity : 0;
    if (method.name !== name || method.arity !== arity) throw new Error('library boundary does not match goal');
    const group = findLibraryGroup(program, name, arity);
    if (!group) throw new Error(`untrusted library boundary: ${name}/${arity}`);
    if (node.children.length !== 0 || node.bindings.length !== 0) throw new Error('abstract library proof must be a leaf');
    return;
  }

  if (method.type === 'source') {
    verifySourceNode(program, node, nodeGoal, registry, options);
    return;
  }

  throw new Error(`unknown proof method: ${method.type}`);
}

function findLibraryGroup(program, name, arity) {
  for (const group of program.groups.values()) {
    if (group.name !== name || group.arity !== arity || group.module === 'user') continue;
    if (program.modules.get(group.module)?.filename?.startsWith('src/lib/')) return group;
  }
  return null;
}

function verifySourceNode(program, node, nodeGoal, registry, options) {
  const method = node.method;
  const candidates = program.clauses.filter((clause) => {
    const source = clause.source ?? {};
    const filename = source.filename ?? '<input>';
    const clauseNumber = source.clause ?? ((clause.index ?? 0) + 1);
    return filename === method.filename && clauseNumber === method.clause;
  });
  if (candidates.length === 0) throw new Error(`source clause not found: ${method.filename}:${method.clause}`);

  for (const clause of candidates) {
    const kind = clause.body.length === 0 ? 'fact' : 'rule';
    if (method.kind !== kind) continue;
    const id = `verify${++verifyFreshCounter}`;
    const variables = new Map();
    const head = freshTerm(clause.head, id, variables);
    const body = clause.body.map((term) => freshTerm(term, id, variables));
    const env = new Env();
    if (!unify(head, nodeGoal, env)) continue;
    if (body.length !== node.children.length) continue;

    let valid = true;
    for (let i = 0; i < body.length; i++) {
      try {
        const childGoal = parseCertificateTerm(node.children[i].goal, program);
        if (!unify(body[i], childGoal, env)) { valid = false; break; }
        verifyCertificateNode(program, node.children[i], childGoal, registry, options, new Env());
      } catch {
        valid = false;
        break;
      }
    }
    if (!valid) continue;
    if (!verifyBindings(node.bindings, variables, env, program)) continue;
    return;
  }
  throw new Error(`source proof does not validate: ${node.goal}`);
}

function verifyBindings(bindings, variables, env, program) {
  const expected = new Map();
  for (const [name, fresh] of variables.entries()) {
    const resolved = deref(fresh, env);
    if (resolved.type !== VAR) expected.set(name, resolved);
  }
  if (bindings.length !== expected.size) return false;
  for (const binding of bindings) {
    if (!binding || typeof binding.name !== 'string' || typeof binding.value !== 'string') return false;
    const resolved = expected.get(binding.name);
    if (!resolved) return false;
    const value = parseCertificateTerm(binding.value, program);
    const check = new Env();
    if (!unify(resolveForProof(resolved, env), value, check)) return false;
  }
  return true;
}

function renderMethodTerm(method) {
  if (method && method.type === 'source') return `${method.kind}(${quoteString(method.filename)}, clause(${method.clause}))`;
  if (method && (method.type === 'builtin' || method.type === 'library')) {
    return `${method.type}(${quoteAtomText(method.name)}, ${method.arity})`;
  }
  return String(method);
}

function renderWhyFacts(answerGoal, rootNode, env) {
  const answer = termToString(resolveForProof(answerGoal, env), new Env(), true);
  return renderWhyTerm(answer, renderAbstractProofTerm(rootNode, 1));
}

function renderWhyNoProof(goal) {
  const answer = termToString(resolveForProof(goal, new Env()), new Env(), true);
  return renderWhyTerm(answer, `${indent(1)}no_proof`);
}

function renderWhyTerm(answer, proofTerm) {
  return ['why(', `${indent(1)}${answer},`, proofTerm, ').', '', ''].join('\n');
}

// The justification, as one term. `rule`/`fact` name the clause they used;
// unlike eyeron's bare `rule(N)` they also name the file it came from,
// because a program here is assembled from several sources and the
// abstract/expanded distinction turns on whether a clause is library
// source.

// One step: the conclusion, the single term saying why it holds, the
// bindings that justification used, and what it used. Those four parts, in
// that order, are what eyeron, eyeling and eyeleng also write -- `pe:rule`,
// `pe:binding` and `pe:uses` in the two RDF syntaxes. The one difference is
// what `uses` holds: there a premise is named by its own conclusion and
// looked up among sibling steps, while here it is the nested step itself,
// because a resolution proof is a tree and the same goal may be proved more
// than once within it.
function renderAbstractProofTerm(node, level) {
  const goal = termToString(node.goal, new Env(), true);
  // A step that used nothing is one line, the way eyeron writes a leaf.
  if (!node.children.length) {
    return `${indent(level)}step(${goal}, ${renderMethodTerm(node.method)}, ${renderBindingsTerm(node.bindings)}, [])`;
  }
  const lines = [
    `${indent(level)}step(`,
    `${indent(level + 1)}${goal},`,
    `${indent(level + 1)}${renderMethodTerm(node.method)},`,
    `${indent(level + 1)}${renderBindingsTerm(node.bindings)},`,
  ];

  lines.push(renderUsesTerm(node.children, level + 1));
  lines.push(`${indent(level)})`);
  return lines.join('\n');
}

function renderUsesTerm(children, level) {
  const lines = [`${indent(level)}[`];
  for (let i = 0; i < children.length; i++) {
    const item = renderAbstractProofTerm(children[i], level + 1);
    lines.push(i === children.length - 1 ? item : withTrailingComma(item));
  }
  lines.push(`${indent(level)}]`);
  return lines.join('\n');
}

// `'Name' = Value` pairs, the form the standard's `variable_names` read
// option uses and the one eyeron writes in its own result documents.
function renderBindingsTerm(bindings) {
  return renderProofListInline(bindings, binding => `${quoteAtomText(binding.name)} = ${termToString(binding.value, new Env(), true)}`);
}

function renderProofListInline(items, renderItem) {
  return `[${items.map(item => renderItem(item)).join(', ')}]`;
}

function withTrailingComma(text) {
  const lines = String(text).split('\n');
  lines[lines.length - 1] += ',';
  return lines.join('\n');
}

function indent(level) {
  return '  '.repeat(level);
}

function quoteAtomText(text) {
  return termToString({ type: 'atom', name: String(text), args: [] }, new Env(), true);
}

function quoteString(value) {
  return JSON.stringify(String(value));
}

function originalVariableName(name) {
  return String(name).replace(/#\d+$/, '');
}

function resolveForProof(term, env) {
  const resolved = deref(term, env);
  if (resolved.type === VAR) return new Term(VAR, originalVariableName(resolved.name), []);
  return new Term(resolved.type, resolved.name, resolved.args.map((arg) => resolveForProof(arg, env)));
}

function collectClauseSubstitutions(clause, freshHead, freshBody) {
  const substitutions = [];
  const seen = new Set();
  collectSubstitutions(clause.head, freshHead, substitutions, seen);
  for (let i = 0; i < clause.body.length && i < freshBody.length; i++) {
    collectSubstitutions(clause.body[i], freshBody[i], substitutions, seen);
  }
  return substitutions;
}

function collectSubstitutions(original, fresh, substitutions, seen) {
  if (!original || !fresh) return;
  if (original.type === VAR) {
    if (!seen.has(original.name)) {
      seen.add(original.name);
      substitutions.push({ name: original.name, fresh });
    }
    return;
  }
  if (original.type !== COMPOUND || fresh.type !== COMPOUND) return;
  const arity = Math.min(original.arity, fresh.arity);
  for (let i = 0; i < arity; i++) collectSubstitutions(original.args[i], fresh.args[i], substitutions, seen);
}

function resolvedSubstitutions(substitutions, env) {
  const out = [];
  for (const substitution of substitutions) {
    const resolved = deref(substitution.fresh, env);
    if (resolved.type === VAR) continue;
    out.push({ name: substitution.name, value: resolveForProof(substitution.fresh, env) });
  }
  return out;
}

// ===========================================================================
// The flat proof
// ===========================================================================
//
// A resolution proof is a tree, but a proof *document* is a flat set of
// steps, one per conclusion, each naming what it used by that use's own
// conclusion rather than by nesting it. That is the shape eyeron, eyeling
// and eyeleng all write, and it is what makes a proof checkable: a reader
// resolves a use by looking for the step that concludes it, so a conclusion
// reached twice is explained once instead of being copied out again under
// every derivation that needs it.

// The program's clauses, numbered from 1, which is what `rule(N)` and
// `fact(N)` cite and what the `clause/3` records reproduce.
//
// The number comes from a clause's position in its own source file, not
// from its position in the running database: `assert/1` and `retract/1`
// move clauses around while a program runs, and a citation has to mean the
// same thing to a reader holding only the source. A program assembled from
// several files lays their spans end to end, in the order the files first
// contribute a clause.
export function clauseNumbering(program) {
  const spans = new Map();
  for (const clause of program.clauses ?? []) {
    if (!isProgramClause(clause)) continue;
    const previous = spans.get(clause.source.filename) ?? 0;
    if (clause.source.clause > previous) spans.set(clause.source.filename, clause.source.clause);
  }
  const offsets = new Map();
  let offset = 0;
  for (const [filename, span] of spans) {
    offsets.set(filename, offset);
    offset += span;
  }

  const bySource = new Map();
  const byNumber = new Map();
  for (const clause of program.clauses ?? []) {
    if (!isProgramClause(clause)) continue;
    const number = (offsets.get(clause.source.filename) ?? 0) + clause.source.clause;
    bySource.set(`${clause.source.filename}\u0000${clause.source.clause}`, number);
    byNumber.set(number, { head: clause.head, body: clause.body ?? [] });
  }
  return { bySource, byNumber };
}

// The clauses the program itself is made of, and so the clauses a citation
// can name. A bundled library's are not among them: an autoloaded module is
// the implementation of a predicate the program only calls, and which
// modules a run happens to reach must not move the numbers of the clauses
// the program does contain.
export function isProgramClause(clause) {
  return Boolean(clause?.source) && !isLibraryClause(clause);
}

export function isLibraryClause(clause) {
  return String(clause?.source?.filename ?? '').startsWith('src/lib/');
}

function clauseNumberFor(numbering, method) {
  return numbering.bySource.get(`${method.filename}\u0000${method.clause}`) ?? null;
}

// The conclusion a node contributes, which is how a step names what it used.
// A conjunction is not a conclusion of its own: it stands for its conjuncts,
// so it contributes theirs.
function nodeConclusions(node) {
  if (node?.method === 'conjunction') return (node.children ?? []).flatMap(nodeConclusions);
  return node ? [node.goal] : [];
}

// The single term saying why a step holds. `rule`/`fact` cite a `clause/3`
// record; a built-in, a completed `\+` and a completed `findall/3` are
// recorded rather than re-derived, the way the specification's `builtin`,
// `absent` and `collected` are.
function justificationTerm(node, numbering) {
  const method = node.method;
  if (method && method.type === 'source') {
    const number = clauseNumberFor(numbering, method);
    if (number != null) return compound(method.kind, [numberTerm(BigInt(number))]);
    // Two clauses a citation cannot name, both recorded rather than checked.
    // A clause inside a bundled library implements a predicate the program
    // only calls, which is what `builtin` already says; a clause `assert/1`
    // put into the database at run time is in no source file at all, so
    // there is nothing a reader could look up or a checker re-derive.
    if (String(method.filename ?? '').startsWith('src/lib/')) return atom('builtin');
    return atom('asserted');
  }
  if (node.goal?.type === COMPOUND && node.goal.name === '\\+' && node.goal.arity === 1) return atom('absent');
  if (node.goal?.type === COMPOUND && node.goal.name === 'findall' && node.goal.arity === 3) return atom('collected');
  return atom('builtin');
}

export function flattenProof(roots, program) {
  const numbering = clauseNumbering(program);
  const steps = [];
  const clauses = new Map();
  const seen = new Set();

  const stack = [];
  for (let i = roots.length - 1; i >= 0; i--) stack.push(roots[i]);

  while (stack.length) {
    const node = stack.pop();
    if (!node) continue;
    if (node.method === 'conjunction') {
      const children = node.children ?? [];
      for (let i = children.length - 1; i >= 0; i--) stack.push(children[i]);
      continue;
    }

    const key = termToString(node.goal, new Env(), true);
    if (seen.has(key)) continue;
    seen.add(key);

    const uses = (node.children ?? []).flatMap(nodeConclusions);
    steps.push({
      conclusion: node.goal,
      by: justificationTerm(node, numbering),
      // An anonymous variable is not named by the clause a reader can look
      // up, so recording what it was bound to explains nothing.
      bindings: (node.bindings ?? []).filter((binding) => !String(binding.name).startsWith('_')),
      uses,
    });

    if (node.method && node.method.type === 'source') {
      const number = clauseNumberFor(numbering, node.method);
      if (number != null && !clauses.has(number)) {
        clauses.set(number, numbering.byNumber.get(number) ?? { head: node.sourceHead, body: node.sourceBody ?? [] });
      }
    }

    const children = node.children ?? [];
    for (let i = children.length - 1; i >= 0; i--) stack.push(children[i]);
  }

  return { clauses: [...clauses.entries()].sort((a, b) => a[0] - b[0]), steps };
}

// The root of an answer's proof tree, for `flattenProof`.
export function proofNodeFor(program, goal, options = {}) {
  const maxDepth = options.maxDepth ?? 256;
  const registry = options.registry ?? getEyePrologRegistry();
  const env = options.env ?? new Env();
  const detail = normalizeProofDetail(options.proofDetail ?? 'abstract');
  for (const proof of proveGoalAll(program, goal, env, 0, maxDepth, registry, [], detail)) return proof.node;
  return null;
}
