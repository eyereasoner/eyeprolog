// EyeProlog proof output helpers.
// The explanation printer replays a successful goal against the program and emits
// ordinary EyeProlog facts with nested proof terms.  Explanations are therefore both
// human-readable and machine-readable.
import { ATOM, COMPOUND, Env, Term, VAR, atom, compareTerms, compound, deref, flattenConjunction, freshTerm, numberTerm, properListItems, termIsGround, termToString, unify, variantTerms } from './term.js';
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

// The solver a replay evaluates through.
//
// A constraint library keeps state on the solver instance that running a
// program's directives again does not rebuild -- CLP(B) answers its goals
// only through the solver that posted the constraints. So when the engine is
// explaining its own run, it explains through that solver; a caller with none
// gets a fresh one, which is enough for everything that is pure resolution.
let liveSolver = null;

// Whether a replay past its depth budget continues as a chain. A caller that
// sets an explicit `maxDepth` gets that depth as a hard limit instead.
let chainBeyondDepth = true;

function hostSolver(program, registry) {
  return liveSolver && liveSolver.program === program ? liveSolver : new Solver(program, { registry });
}

function* proveGoalAll(program, goal, env, depth, maxDepth, registry, active, detail) {
  // Past the depth budget, nested replay would cost a host call frame per
  // level; a deep derivation continues as an iterative chain instead.
  if (depth > maxDepth) {
    if (chainBeyondDepth) yield* chainProof(program, goal, env, maxDepth, registry, active, detail);
    return;
  }

  if (goal.type === COMPOUND && goal.name === ',' && goal.arity === 2) {
    for (const proved of proveGoalsAll(program, flattenConjunction(goal), env, depth + 1, maxDepth, registry, active, detail)) {
      yield {
        env: proved.env,
        node: {
          raw: goal,
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

  // `Module:Goal` runs Goal in Module, as the solver does. A goal in a
  // bundled library is one library step under abstract detail, recomputed by a
  // checker as the qualified goal it is; any other is a control step resting
  // on the goal it qualifies.
  if (goal.type === COMPOUND && goal.name === ':' && goal.arity === 2) {
    const module = deref(goal.args[0], env);
    const inner = deref(goal.args[1], env);
    if (module.type !== ATOM || (inner.type !== ATOM && inner.type !== COMPOUND)) return;
    const qualified = withModule(inner, module.name);
    if (detail !== 'expanded' && module.name !== 'user' && program.modules.get(module.name)?.filename?.startsWith('src/lib/')) {
      const solver = hostSolver(program, registry);
      for (const next of solver.solve([goal], env.clone(), 0)) {
        const proofEnv = next.clone ? next.clone() : next;
        yield {
          env: proofEnv,
          node: {
            raw: goal,
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
    for (const proved of proveGoalAll(program, qualified, env, depth + 1, maxDepth, registry, active, detail)) {
      yield {
        env: proved.env,
        node: {
          raw: goal,
          goal: resolveForProof(goal, proved.env),
          method: goalMethod('builtin', goal),
          sourceHead: null,
          sourceBody: [],
          bindings: [],
          children: [proved.node],
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
          raw: goal,
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
    const solver = hostSolver(program, registry);
    for (const next of solver.solve([goal], env.clone(), 0)) {
      const proofEnv = next.clone ? next.clone() : next;
      yield {
        env: proofEnv,
        node: {
          raw: goal,
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
      const next = env.clone();
      if (!unify(goal, freshHead, next)) continue;

      // Rename the body only once the head has matched. The shared variable
      // map carries the head's renamings, so a body renamed now is the same
      // body renaming as before -- a clause rejected on its head simply no
      // longer pays for one.
      const freshBody = clause.body.map((term) => freshTerm(term, id, freshVariables));
      const substitutions = collectClauseSubstitutions(clause, freshHead, freshBody);

      if (freshBody.length === 0) {
        yield {
          env: next,
          node: {
          raw: goal,
            goal: resolveForProof(goal, next),
            method: sourceMethod(clause, 'fact'),
            sourceHead: clause.head,
            sourceBody: [],
            // A fact binds everything it is going to bind at head unification.
            // A rule's substitutions are only final once its body is proved,
            // so that branch resolves them against the proving environment.
            bindings: resolvedSubstitutions(substitutions, next),
            rawSubstitutions: substitutions,
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
          raw: goal,
              goal: resolveForProof(goal, proved.env),
              method: sourceMethod(clause, 'rule'),
              sourceHead: clause.head,
              sourceBody: clause.body,
              bindings: resolvedSubstitutions(substitutions, proved.env),
              rawSubstitutions: substitutions,
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

// The number of levels a chain may run before the replay gives up on it, so
// a program that recurses without end still ends its explanation.
const CHAIN_LIMIT = 10_000_000;

// A deep derivation, replayed one level at a time. At each level the goal is
// resolved with the first clause whose head matches and whose body, up to a
// final call of a program predicate, is proved; that final call is the next
// level. Every level commits to its clause, so the chain finds the leftmost
// derivation -- the one Prolog's depth-first search finds first -- whenever
// that derivation needs no backtracking into an earlier level, and finds
// nothing otherwise. A level's other goals are replayed as usual, from a fresh
// depth budget.
//
// The chain yields at most one solution: a caller that needs another one has
// to do without, and records its answer as unproven.
function* chainProof(program, goal, env, maxDepth, registry, active, detail) {
  const levels = [];
  const seen = new Set();
  let current = goal;
  let currentEnv = env;
  for (let level = 0; level < CHAIN_LIMIT; level++) {
    const resolved = deref(current, currentEnv);
    if (!isChainableCall(program, resolved, currentEnv, registry, detail)) {
      // The last call of the chain is not a program predicate: replay it as
      // usual and end the chain there.
      let last = null;
      for (const proved of proveGoalAll(program, current, currentEnv, 0, maxDepth, registry, active, detail)) {
        last = proved;
        break;
      }
      if (!last) return;
      levels.push(last.node);
      currentEnv = last.env;
      break;
    }
    if (termIsGround(resolved, currentEnv)) {
      const key = termToString(resolveForProof(resolved, currentEnv), new Env(), true);
      if (seen.has(key)) return;
      seen.add(key);
    }

    const group = program.findGroup(resolved.name, resolved.arity, resolved.module ?? 'user');
    const candidates = selectClauseCandidates(group, resolved, currentEnv);
    let matched = null;
    search: for (const pass of [candidates.primary, candidates.fallback]) {
      for (let index = 0; index < clauseCandidateLength(pass); index++) {
        const clause = clauseCandidateAt(pass, index);
        const id = nextFreshId();
        const freshVariables = new Map();
        const freshHead = freshTerm(clause.head, id, freshVariables);
        const next = currentEnv.clone();
        if (!unify(resolved, freshHead, next)) continue;
        const freshBody = clause.body.map((term) => freshTerm(term, id, freshVariables));
        const last = freshBody[freshBody.length - 1];
        const continues = last != null && isChainableCall(program, deref(last, next), next, registry, detail);
        const prefix = continues ? freshBody.slice(0, -1) : freshBody;
        let proved = null;
        for (const solution of proveGoalsAll(program, prefix, next, 0, maxDepth, registry, active, detail)) {
          proved = solution;
          break;
        }
        if (!proved) {
          // A cut in a clause that failed may have pruned the clauses after
          // it, which a chain cannot tell apart from not having reached it.
          if (prefix.some((term) => term.type === ATOM && term.name === '!')) return;
          continue;
        }
        matched = {
          clause,
          env: proved.env,
          children: proved.children,
          substitutions: collectClauseSubstitutions(clause, freshHead, freshBody),
          continuation: continues ? last : null,
        };
        break search;
      }
    }
    if (!matched) return;
    // The goal and bindings are resolved once the whole derivation is found,
    // when the replay settles its nodes; resolving them here as well would
    // walk a binding history that grows with every level.
    levels.push({
      raw: current,
      goal: current,
      method: sourceMethod(matched.clause, matched.clause.body.length ? 'rule' : 'fact'),
      sourceHead: matched.clause.head,
      sourceBody: matched.clause.body,
      bindings: [],
      rawSubstitutions: matched.substitutions,
      children: matched.children,
    });
    currentEnv = matched.env;
    // Each level adds bindings, and a lookup walks the layers they are kept
    // in; flattening the layers from time to time keeps a deep chain linear.
    currentEnv.compactForDeepContinuation?.();
    if (!matched.continuation) break;
    current = matched.continuation;
    if (level === CHAIN_LIMIT - 1) return;
  }
  // Each level rests on the next, as the last of its uses.
  for (let index = levels.length - 2; index >= 0; index--) levels[index].children.push(levels[index + 1]);
  yield { env: currentEnv, node: levels[0] };
}

// A call the chain can take a level through: a predicate the program defines,
// rather than a built-in, a control construct or a bundled library predicate
// the replay records as one step.
function isChainableCall(program, goal, env, registry, detail) {
  if (goal.type !== ATOM && goal.type !== COMPOUND) return false;
  if (builtinDefinition(program, goal, env, registry).handled) return false;
  const group = program.findGroup(goal.name, goal.arity, goal.module ?? 'user');
  if (!group) return false;
  if (detail !== 'expanded' && group.module !== 'user' && program.modules.get(group.module)?.filename?.startsWith('src/lib/')) return false;
  return true;
}

// A copy of a goal that runs in `module`, as the solver qualifies one.
function withModule(term, module) {
  if (term.type !== ATOM && term.type !== COMPOUND) return term;
  const copy = new Term(term.type, term.name, term.args.map((arg) => withModule(arg, module)));
  copy.module = module;
  return copy;
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

  const solver = hostSolver(program, registry);
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
    // The wrapped goal is proved in an environment of its own, so it is
    // settled against that one rather than the outer derivation's.
    for (const proved of proveGoalAll(program, goal.args[0], env.clone(), depth, maxDepth, registry, active, detail)) {
      return [settleProofNode(proved.node, proved.env)];
    }
  }
  return [];
}

function activeVariant(goal, env, active) {
  // Only a goal for the same predicate can be a variant of this one, so reject
  // the rest on their functor instead of on a structural comparison. Scan from
  // the innermost entry outwards: a replay that is about to cycle repeats its
  // nearest ancestor, not the goal the whole replay started from.
  for (let index = active.length - 1; index >= 0; index--) {
    const entry = active[index];
    const candidate = entry.goal;
    if (candidate.type !== goal.type || candidate.name !== goal.name || candidate.arity !== goal.arity) continue;
    if (variantTerms(goal, env, candidate, entry.env)) return true;
  }
  return false;
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

// The justification, as one term. `rule`/`fact` name the clause they used,
// and also the file it came from, because a program here is assembled from
// several sources and the abstract/expanded distinction turns on whether a
// clause is library source.

// One step: the conclusion, the single term saying why it holds, the
// bindings that justification used, and what it used. In this nested
// rendering `uses` holds the nested steps themselves, because a resolution
// proof is a tree and the same goal may be proved more than once within it;
// the flat proof document below names each use by its own conclusion
// instead.
function renderAbstractProofTerm(node, level) {
  const goal = termToString(node.goal, new Env(), true);
  // A step that used nothing is one line.
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
// option uses.
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
  // Runtime terms are immutable. A ground subtree already is a proof snapshot,
  // so copy only the ancestors of arguments changed by variable resolution.
  // Allocate the argument array on the first changed child, keeping ground
  // lists allocation-free even when many proof steps share their suffixes.
  let args = null;
  for (let index = 0; index < resolved.args.length; index++) {
    const child = resolveForProof(resolved.args[index], env);
    if (args == null && child !== resolved.args[index]) args = resolved.args.slice();
    if (args != null) args[index] = child;
  }
  if (args == null && resolved.module == null) return resolved;
  return new Term(resolved.type, resolved.name, args ?? resolved.args.slice());
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
// conclusion rather than by nesting it. That is what makes a proof
// checkable: a reader
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
// A module-loading declaration describes the compilation unit rather than an
// executable clause, so the parser deliberately does not advance the proof
// clause number for it -- which leaves it carrying the number of the clause
// before it. It must therefore not be entered under that number here, or it
// would displace the real clause and every step citing it would stop
// resolving. Such a declaration is never what a rule(N) or fact(N) cites.
function isUnnumberedDeclaration(clause) {
  const head = clause?.head;
  if (head?.type !== COMPOUND || head.name !== ':-' || head.arity !== 1) return false;
  const directive = head.args[0];
  if (directive?.type !== COMPOUND && directive?.type !== ATOM) return false;
  return ['module', 'use_module', 'meta_predicate', 'attribute'].includes(directive.name);
}

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
    if (!isProgramClause(clause) || isUnnumberedDeclaration(clause)) continue;
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
  // A control construct solved by the goals it wraps rests on them, not on
  // a computation: it is `control`, and a checker composes it from its uses.
  if (node.children?.length && isControlComposition(node.goal)) return atom('control');
  if (node.goal?.type === COMPOUND && node.goal.name === '\\+' && node.goal.arity === 1) return atom('absent');
  if (node.goal?.type === COMPOUND && node.goal.name === 'findall' && node.goal.arity === 3) return atom('collected');
  return atom('builtin');
}

const CONTROL_COMPOSITIONS = new Set(['call/1', 'once/1', 'ignore/1', 'catch/3', ';/2', '->/2', '*->/2', ':/2']);

function isControlComposition(goal) {
  return goal?.type === COMPOUND && CONTROL_COMPOSITIONS.has(`${goal.name}/${goal.arity}`);
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

// Ground, deterministic source chains can be replayed without keeping a host
// call frame or an accumulating substitution environment for every edge.
// Ambiguous clauses, open bodies, builtins and library boundaries continue
// through the general replay, which owns their search and execution semantics.
function groundChainProof(program, goal, env, maxDepth, registry) {
  if (goal.module != null && goal.module !== 'user') return null;
  if (!termIsGround(goal, env)) return null;
  let current = resolveForProof(goal, env);
  const seen = new Set();
  const nodes = [];
  while (nodes.length <= maxDepth) {
    if (current.type !== ATOM && current.type !== COMPOUND) return null;
    if (registry.get(current.name, current.arity)) return null;
    const group = program.findGroup(current.name, current.arity, current.module ?? 'user');
    if (!group || group.module !== 'user') return null;
    const key = termToString(current, new Env(), true);
    if (seen.has(key)) return null;
    seen.add(key);
    const candidates = selectClauseCandidates(group, current, new Env());
    let matched = null;
    for (const pass of [candidates.primary, candidates.fallback]) {
      for (let index = 0; index < clauseCandidateLength(pass); index++) {
        const clause = clauseCandidateAt(pass, index);
        const variables = new Map();
        const id = nextFreshId();
        const head = freshTerm(clause.head, id, variables);
        const next = new Env();
        if (!unify(current, head, next)) continue;
        if (matched || clause.body.length > 1) return null;
        const body = clause.body.map((term) => freshTerm(term, id, variables));
        if (body.some((term) => (term.module != null && term.module !== 'user') || !termIsGround(term, next))) return null;
        matched = {
          node: {
            goal: current,
            method: sourceMethod(clause, body.length ? 'rule' : 'fact'),
            sourceHead: clause.head,
            sourceBody: clause.body,
            bindings: resolvedSubstitutions(collectClauseSubstitutions(clause, head, body), next),
            children: [],
          },
          next: body.length ? resolveForProof(body[0], next) : null,
        };
      }
    }
    if (!matched) return null;
    nodes.push(matched.node);
    if (matched.next == null) {
      for (let index = nodes.length - 2; index >= 0; index--) nodes[index].children.push(nodes[index + 1]);
      return nodes[0];
    }
    current = matched.next;
  }
  return null;
}

// A node is resolved when its own goal is proved, but a later goal of the
// same derivation can still bind its variables: `goal_state(G)` is proved by
// a fact before the plan that fixes `G` is found. A step must record the goal
// as the whole solution leaves it, or its uses would not be the instances of
// the clause body a checker re-derives, so once the derivation is complete
// every node is resolved again against its final environment.
function settleProofNode(root, env) {
  const resolve = settlingResolver(env);
  const stack = [root];
  while (stack.length) {
    const node = stack.pop();
    if (node.raw) {
      node.goal = resolve(node.raw);
      if (node.method?.type === 'builtin' || node.method?.type === 'library') node.sourceHead = node.goal;
      node.raw = null;
    }
    if (node.rawSubstitutions) {
      const bindings = [];
      for (const substitution of node.rawSubstitutions) {
        const value = resolve(substitution.fresh);
        if (value.type === VAR) continue;
        bindings.push({ name: substitution.name, value });
      }
      node.bindings = bindings;
      node.rawSubstitutions = null;
    }
    for (const child of node.children ?? []) stack.push(child);
  }
  return root;
}

// resolveForProof against one final environment, remembering what each
// variable resolved to. A deep derivation threads an output argument through
// every level as a chain of variables bound to variables, and resolving each
// level's goal by walking that chain again would make settling quadratic;
// every variable on a chain walked once is remembered with the chain's end.
function settlingResolver(env) {
  const memo = new Map();
  const locals = env._localVariables;
  const resolveVariable = (name) => {
    const path = [];
    let current = name;
    let result;
    for (;;) {
      const known = memo.get(current);
      if (known !== undefined) {
        result = known;
        break;
      }
      path.push(current);
      const next = locals != null && locals.has(current) ? undefined : env.get(current);
      if (next === undefined) {
        result = new Term(VAR, originalVariableName(current), []);
        break;
      }
      if (next.type === VAR) {
        // A binding cycle cannot arise from unification with an occurs
        // check; the bound only keeps a malformed environment from hanging.
        if (path.length > CHAIN_LIMIT) {
          result = new Term(VAR, originalVariableName(current), []);
          break;
        }
        current = next.name;
        continue;
      }
      result = resolve(next);
      break;
    }
    for (const visited of path) memo.set(visited, result);
    return result;
  };
  const resolve = (term) => {
    if (term.type === VAR) return resolveVariable(term.name);
    let args = null;
    for (let index = 0; index < term.args.length; index++) {
      const child = resolve(term.args[index]);
      if (args == null && child !== term.args[index]) args = term.args.slice();
      if (args != null) args[index] = child;
    }
    if (args == null && term.module == null) return term;
    return new Term(term.type, term.name, args ?? term.args.slice());
  };
  return resolve;
}

// The root of an answer's proof tree, for `flattenProof`.
//
// The answer is replayed as the ground goal it is. A program whose
// predicates insist on an unbound output argument -- a counter, a generated
// name, a stream handle -- cannot be asked that way, so when `questions` (the
// goals the run asked) are given and the ground replay finds nothing, the
// question the answer is an instance of is replayed instead, and the first
// derivation that yields exactly this answer is the one recorded.
export function proofNodeFor(program, goal, options = {}) {
  liveSolver = options.solver ?? null;
  chainBeyondDepth = options.maxDepth == null;
  const maxDepth = options.maxDepth ?? 256;
  const registry = options.registry ?? getEyePrologRegistry();
  const env = options.env ?? new Env();
  const detail = normalizeProofDetail(options.proofDetail ?? 'abstract');
  try {
    const chain = groundChainProof(program, goal, env, options.maxDepth ?? Infinity, registry);
    if (chain) return chain;
    for (const proof of proveGoalAll(program, goal, env, 0, maxDepth, registry, [], detail)) {
      return settleProofNode(proof.node, proof.env);
    }
  } catch {
    // A replay that raises has not explained anything; the question may.
  }
  for (const question of options.questions ?? []) {
    const node = proofNodeThroughQuestion(program, question, goal, maxDepth, registry, detail);
    if (node) return node;
  }
  // An answer the engine found should not be lost because explaining it
  // failed. The caller records it as `unproven`, which says exactly that.
  return null;
}

function proofNodeThroughQuestion(program, question, answer, maxDepth, registry, detail) {
  const asked = freshTerm(question, `question${nextFreshId()}`);
  if (!unify(asked, answer, new Env())) return null;
  try {
    for (const proof of proveGoalAll(program, asked, new Env(), 0, maxDepth, registry, [], detail)) {
      if (compareTerms(resolveForProof(asked, proof.env), answer) !== 0) continue;
      const node = settleProofNode(proof.node, proof.env);
      node.goal = answer;
      return node;
    }
  } catch {
    // This question cannot be replayed either.
  }
  return null;
}
