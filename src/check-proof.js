// Proof checking.
//
// A proof document says what was concluded and why. Checking it means
// re-performing every inference it records against the program it claims to
// come from. SPEC.md, Section 11, is the specification; it follows peye's
// proof checker, read in Prolog syntax.
//
// A checker does not reason. It never searches for a derivation the document
// failed to record, and it never runs the program; it only verifies what is
// written. Seven conditions decide validity:
//
//   C1 Resolution     -- every `rule(N)` or `fact(N)` step is an instance of
//                        the source clause it cites, and every `clause/3`
//                        record restates that clause exactly.
//   C2 Well-founded   -- no step depends on itself through its uses.
//   C3 Justification  -- every step carries exactly one known justification,
//                        in the shape that justification requires.
//   C4 Coverage       -- every conjunct of every claim has a step, and every
//                        use has a step or is an instance of a program fact.
//   C5 Re-decision    -- a `builtin` step is computed again here and must
//                        agree; a `control` step must be composed of its uses.
//   C6 Boundary       -- a trusted `absent` or `collected` step is confronted
//      consistency       with the evidence at hand, which can refute it.
//   C7 Relevance      -- every claim answers a goal that was asked, and every
//                        step serves a claim.
//
// C5 is what keeps this a check rather than a reading. A `builtin` step --
// the largest class in a typical proof -- is not taken on the document's
// word: its goal is run again against a program holding the bundled
// libraries and nothing else. No clause of the theory under proof is
// present, so the re-decision cannot be talked into agreeing by the very
// rules it is meant to audit.
//
// `absent`, `collected` and `asserted` stay trusted, and deliberately:
// negation as failure and collection range over the theory, which C5's
// program excludes, and an asserted clause is in no source file. C6 cannot
// prove such a boundary, but it can refute one with what the program and the
// document already show. What survives is reported as an obligation, so a
// reader knows what the check still rests on.
import { ATOM, COMPOUND, NUMBER, VAR, Env, compareTerms, compound, copyResolved, flattenConjunction, freshTerm, numberTerm, properListItems, termIsGround, termToString, unify, variable, variantTerms } from './term.js';
import { parseGoalText, parseProgramText } from './parser.js';
import { clauseNumbering } from './explain.js';
import { formatTermForWrite } from './write.js';
import { clauseRecordTerm, normalizedClauseRecord } from './result-format.js';
import { goalsFromSource } from './goal-metadata.js';
import { Program, autoloadProgramGoals } from './program.js';
import { Solver } from './solver.js';

// Goals that state a fact about the run rather than compute a value, and so
// cannot be recomputed by a program that deliberately holds neither the
// theory nor the run's accumulated state. Re-running one of these against
// C5's library-only program would decide it on the wrong evidence, which is
// weaker than admitting it was trusted -- so they are named here, by the two
// reasons they are outside C5's reach, and reported as obligations.
//
// Reflective: the goal reads the theory's own database or syntax, which is
// exactly what C5 excludes in order to stay independent of it.
// Stateful: the goal's answer depends on constraint, attribute or stream
// state that the original run built up and a fresh solver cannot rebuild.
// Stream operations are never re-run: a checker must not perform I/O.
const NOT_REDECIDABLE = new Map([
  ['clause/2', 'reflective'],
  ['current_predicate/1', 'reflective'],
  ['current_op/3', 'reflective'],
  ['get_atts/2', 'stateful'],
  ['put_atts/2', 'stateful'],
  ['open/3', 'stateful'],
  ['open/4', 'stateful'],
  ['close/1', 'stateful'],
  ['close/2', 'stateful'],
  ['read/2', 'stateful'],
  ['read_term/3', 'stateful'],
  ['write/2', 'stateful'],
  ['write_term/3', 'stateful'],
  ['nl/1', 'stateful'],
  ['set_output/1', 'stateful'],
  ['set_input/1', 'stateful'],
  ['current_output/1', 'stateful'],
  ['current_input/1', 'stateful'],
  ['at_end_of_stream/1', 'stateful'],
  ['stream_property/2', 'stateful'],
  ['sat/1', 'stateful'],
  ['taut/2', 'stateful'],
  ['sat_count/2', 'stateful'],
]);

// Control constructs, which C6 never takes as evidence and C5 composes from
// their uses rather than recomputes.
const CONTROL_KEYS = new Set([
  ',/2', ';/2', '->/2', '*->/2', '\\+/1', 'call/1', 'once/1', 'ignore/1', 'catch/3',
  'findall/3', 'findall/4', 'forall/2', 'bagof/3', 'setof/3', 'aggregate_all/3', 'aggregate_all/4',
]);

// The built-ins a predicate may call and still be pure positive Horn logic,
// so that what the document shows about it is evidence about every call of
// it (C6). Anything else -- a cut, if-then-else, a type test, negation, a
// database update -- can make a call with fewer bindings answer differently
// from one with more, and then evidence refutes nothing.
const PURE_BUILTINS = new Set([
  'true/0', 'fail/0', 'false/0', ',/2', ';/2', '=/2', 'is/2',
  '</2', '>/2', '=</2', '>=/2', '=:=/2', '=\\=/2',
  'member/2', 'append/3', 'select/3', 'between/3', 'succ/2', 'plus/3',
]);

// Database updates, whose target predicates are not static and so offer no
// evidence (C6).
const UPDATES = new Set(['assert/1', 'asserta/1', 'assertz/1', 'retract/1', 'retractall/1', 'abolish/1']);

function predicateKey(term) {
  if (term?.type === ATOM) return `${term.name}/0`;
  if (term?.type === COMPOUND) return `${term.name}/${term.args.length}`;
  return null;
}

function isCallable(term) {
  return term?.type === ATOM || term?.type === COMPOUND;
}

function isCompound(term, name, arity) {
  return term?.type === COMPOUND && term.name === name && term.args.length === arity;
}

function isAtom(term, name) {
  return term?.type === ATOM && term.name === name;
}

function key(term) {
  return termToString(term, new Env(), true);
}

// A term is identical to another when it needs no further instantiation to
// become it: unifying a fresh copy must leave it spelled exactly as the
// target. Variables are identical only to themselves.
function identical(left, right) {
  return compareTerms(left, right) === 0;
}

function resolvesTo(term, env, target) {
  return identical(copyResolved(term, env), target);
}

let freshCounter = 0;
function fresh(term, variables) {
  return freshTerm(term, `check${++freshCounter}`, variables);
}

// The alternatives a control construct is composed of, each as the list of
// goals that solve it in order. A `control` step must name one of them, goal
// for goal, as its uses.
function controlAlternatives(goal) {
  const conjuncts = (term) => flattenConjunction(term);
  if (isCompound(goal, 'call', 1) || isCompound(goal, 'once', 1) || isCompound(goal, 'ignore', 1)) {
    return [conjuncts(goal.args[0])];
  }
  if (isCompound(goal, 'catch', 3)) return [conjuncts(goal.args[0])];
  if (isCompound(goal, '->', 2) || isCompound(goal, '*->', 2)) {
    return [[...conjuncts(goal.args[0]), ...conjuncts(goal.args[1])]];
  }
  if (isCompound(goal, ';', 2)) {
    const [left, right] = goal.args;
    const first = isCompound(left, '->', 2) || isCompound(left, '*->', 2)
      ? [...conjuncts(left.args[0]), ...conjuncts(left.args[1])]
      : conjuncts(left);
    return [first, conjuncts(right)];
  }
  return null;
}

// The document, read as the abstract model: the claims its plain facts make,
// the `clause/3` records restating the clauses it cites, and the steps its
// `step/4` facts record. Reading never throws: what does not read is a C3
// failure, and a document that does not parse at all has no claims and no
// steps.
export function readProofDocument(text, program, fail = () => {}) {
  const claims = [];
  const records = [];
  const steps = [];
  let clauses;
  try {
    // The document is read with the program's own operators: a rule set that
    // declares `op/3` writes its terms that way, and its proof quotes them.
    clauses = parseProgramText(String(text), {
      doubleQuotes: program?.doubleQuotes ?? 'chars',
      operatorDefinitions: [...(program?.operators?.values() ?? [])],
      sourceMetadata: false,
    });
  } catch (error) {
    fail('C3', `the document does not read: ${error?.message ?? String(error)}`, null);
    return { claims, records, steps };
  }
  for (const clause of clauses) {
    const head = clause?.head;
    if (!head) continue;
    if ((clause.body?.length ?? 0) !== 0 || isCompound(head, ':-', 1)) {
      fail('C3', 'a proof document holds facts only', head);
      continue;
    }
    if (isCompound(head, 'clause', 3)) {
      records.push(head);
      continue;
    }
    if (!isCompound(head, 'step', 4)) {
      claims.push(head);
      continue;
    }
    const [conclusion, by, bindingList, useList] = head.args;
    const bindings = properListItems(bindingList, new Env());
    const uses = properListItems(useList, new Env());
    if (bindings == null || uses == null ||
        !bindings.every((item) => isCompound(item, '=', 2) && item.args[0]?.type === ATOM)) {
      fail('C3', "step bindings must be a list of 'Name' = Value pairs and uses a list", conclusion);
      continue;
    }
    steps.push({
      conclusion,
      by,
      bindings: bindings.map((item) => ({ name: item.args[0].name, value: item.args[1] })),
      uses,
    });
  }
  return { claims, records, steps };
}

// C1 for a `rule(N)` or `fact(N)` step. The clause is taken from the program,
// not from the document -- a proof cannot be made valid by restating the rule
// it used. Its variables are renamed apart, bound to the values the step
// recorded, and the result must be this conclusion from exactly these uses,
// with no further instantiation of the step's own terms.
function checkResolution(step, number, clause) {
  const variables = new Map();
  const head = fresh(clause.head, variables);
  const body = (clause.body ?? []).map((goal) => freshTerm(goal, `check${freshCounter}`, variables));
  const env = new Env();
  const seen = new Set();
  for (const binding of step.bindings) {
    const variable = variables.get(binding.name);
    // A binding for a variable the clause does not have says the step was
    // recorded against a different clause than the one it cites.
    if (!variable || seen.has(binding.name)) return false;
    seen.add(binding.name);
    if (!unify(variable, binding.value, env)) return false;
  }
  if (!unify(head, step.conclusion, env)) return false;
  if (body.length !== step.uses.length) return false;
  for (let i = 0; i < body.length; i++) {
    if (!unify(body[i], step.uses[i], env)) return false;
  }
  if (!resolvesTo(head, env, step.conclusion)) return false;
  return body.every((goal, i) => resolvesTo(goal, env, step.uses[i]));
}

// C5's independent route. One program is built per document and reused: it
// holds the bundled libraries the recorded goals need and no clause of the
// theory under proof, so a goal only the theory could satisfy raises an
// existence error here rather than quietly succeeding.
//
// A goal is only re-decided when this program can actually run it. When it
// cannot -- the predicate is not one the libraries define -- the answer is
// `unavailable`: the checker has learned nothing about it, and saying so is
// honest where failing it would not be.
function makeRedecider(program, goals) {
  if (goals.length === 0) return () => ({ status: 'unavailable' });
  let primitives = null;
  try {
    primitives = Program.parseSources([{ text: '', filename: '<check>' }], {
      sourceMetadata: false,
      isoStrict: program?.strictIso === true,
    });
    primitives = autoloadProgramGoals(primitives, goals, { autoload: true });
  } catch (_) {
    return () => ({ status: 'unavailable' });
  }
  return (goal) => {
    let solver;
    try {
      solver = new Solver(primitives, { solutionLimit: 1 });
    } catch (_) {
      return { status: 'unavailable' };
    }
    try {
      const env = new Env();
      const result = solver.runOneAnswer(goal, env);
      if (result.done) return { status: 'disagrees' };
      // The recorded goal is the goal as the whole solution left it, so
      // solving it again must succeed without binding anything -- beyond
      // renaming a variable it leaves free, as copy_term/2 does.
      return variantTerms(goal, result.value ?? env, goal, new Env()) ? { status: 'agrees' } : { status: 'disagrees' };
    } catch (error) {
      const formal = error?.formal ?? '';
      if (typeof formal === 'string' && formal.startsWith('existence_error(procedure')) {
        return { status: 'unavailable' };
      }
      return { status: 'disagrees', detail: error?.message ?? String(error) };
    }
  };
}

// The questions a proof's claims must answer (C7): the goals given, read with
// the program's operators.
function readQuestions(program, goals) {
  return (goals ?? []).map((goal) => (typeof goal === 'string'
    ? parseGoalText(goal, {
        doubleQuotes: program?.doubleQuotes ?? 'chars',
        operatorDefinitions: [...(program?.operators?.values() ?? [])],
      })
    : goal));
}

// The goals a run of these sources asks when none are given on the command
// line: the `%% ?-` goals, or failing those the `?- Goal.` queries. These are
// the questions a proof of that run answers.
export function sourceGoals(program, sourceTexts = []) {
  const declared = sourceTexts.flatMap((text) => goalsFromSource(text));
  if (declared.length > 0) return declared;
  return (program?.queries ?? []).map((query) => query.goal);
}

// What C6 may take as evidence. A predicate qualifies when it is static and
// pure positive Horn logic all the way down, so that every solution the
// document or the program shows for one call of it is a solution of any less
// instantiated call: a completed `\+ G` or `findall/3` cannot have missed it.
function evidenceAnalysis(program, steps) {
  const mutable = new Set();
  let everythingMutable = false;
  const noteUpdates = (goal) => {
    if (goal == null) return;
    if (goal.type === VAR) return;
    if (UPDATES.has(predicateKey(goal))) {
      let target = goal.args[0];
      if (isCompound(target, ':-', 2)) target = target.args[0];
      if (isCompound(target, '/', 2) && target.args[0]?.type === ATOM && target.args[1]?.type === NUMBER) {
        mutable.add(`${target.args[0].name}/${target.args[1].name}`);
      } else if (isCallable(target)) {
        mutable.add(predicateKey(target));
      } else {
        everythingMutable = true;
      }
    }
    if (goal.type === COMPOUND) for (const arg of goal.args) if (isCallable(arg)) noteUpdates(arg);
  };
  for (const clause of program?.clauses ?? []) {
    noteUpdates(clause.head);
    for (const goal of clause.body ?? []) noteUpdates(goal);
  }
  for (const step of steps) {
    if (isAtom(step.by, 'asserted')) mutable.add(predicateKey(step.conclusion));
  }

  const userGroup = (term) => {
    const group = program?.findGroup?.(term.name, term.args.length);
    return group && (group.module ?? 'user') === 'user' ? group : null;
  };
  const pure = new Map();
  const isPure = (term) => {
    const goalKey = predicateKey(term);
    if (everythingMutable || mutable.has(goalKey)) return false;
    const group = userGroup(term);
    if (!group || group.dynamic) return false;
    if (pure.has(goalKey)) return pure.get(goalKey);
    pure.set(goalKey, true); // a recursive call is as pure as the rest
    const pureGoal = (goal) => {
      if (!isCallable(goal)) return false;
      if (isCompound(goal, ',', 2)) return pureGoal(goal.args[0]) && pureGoal(goal.args[1]);
      if (isCompound(goal, ';', 2)) {
        if (isCompound(goal.args[0], '->', 2) || isCompound(goal.args[0], '*->', 2)) return false;
        return pureGoal(goal.args[0]) && pureGoal(goal.args[1]);
      }
      if (userGroup(goal)) return isPure(goal);
      return PURE_BUILTINS.has(predicateKey(goal));
    };
    const result = group.clauses.every((clause) => (clause.body ?? []).every(pureGoal));
    pure.set(goalKey, result);
    return result;
  };
  return { userGroup, isPure };
}

// Check a proof document against the program it claims to come from.
//
//   goals   the goals the proof answers (strings or terms); C7 holds each
//           claim to them. Default: the program's own `?- Goal.` queries.
//   strict  forbid trusted boundaries: each fails C5.
export function checkProofDocument(program, text, options = {}) {
  const writeOptions = {
    doubleQuotes: program?.doubleQuotes ?? 'chars', doubleBar: true, quoted: true,
    operators: [...(program?.operators?.values() ?? [])],
  };
  const show = (term) => formatTermForWrite(term, new Env(), writeOptions);
  const failures = [];
  const fail = (condition, detail, term) => {
    failures.push({ condition, detail, conclusion: term == null ? null : key(term), term: term ?? null });
  };

  const { claims, records, steps: allSteps } = readProofDocument(text, program, fail);
  const numbering = clauseNumbering(program).byNumber;

  // clause/3 records are not authority: the source program is. Each must
  // restate the clause it numbers exactly.
  for (const record of records) {
    const number = record.args[0]?.type === NUMBER ? Number(record.args[0].name) : NaN;
    const clause = Number.isInteger(number) ? numbering.get(number) : null;
    if (!clause || !identical(normalizedClauseRecord(record), normalizedClauseRecord(clauseRecordTerm(number, clause)))) {
      fail('C1', 'clause record differs from source', record);
    }
  }

  // One step per goal. A second justification for the same goal is a C3
  // failure, not a choice the checker makes.
  const steps = new Map();
  for (const step of allSteps) {
    const id = key(step.conclusion);
    if (steps.has(id)) {
      fail('C3', `duplicate justification for ${show(step.conclusion)}`, step.conclusion);
      continue;
    }
    steps.set(id, step);
  }

  // A use the program simply gives, which needs no step of its own: an
  // instance of one of its facts.
  const givenByFact = (goal) => {
    if (!isCallable(goal)) return false;
    const group = program?.findGroup?.(goal.name, goal.args.length);
    for (const clause of group?.clauses ?? []) {
      if ((clause.body ?? []).length !== 0) continue;
      const env = new Env();
      const head = fresh(clause.head);
      if (unify(head, goal, env) && resolvesTo(head, env, goal)) return true;
    }
    return false;
  };
  const covered = (goal) => flattenConjunction(goal).every((part) => steps.has(key(part)) || givenByFact(part));

  // C4: claims.
  for (const claim of claims) {
    if (!flattenConjunction(claim).every((part) => steps.has(key(part)))) {
      fail('C4', `unjustified claim ${show(claim)}`, claim);
    }
  }

  const redecideGoals = [];
  for (const step of steps.values()) {
    if (isAtom(step.by, 'builtin')) redecideGoals.push(step.conclusion);
    if (isAtom(step.by, 'absent') || isAtom(step.by, 'collected')) {
      const inner = isCompound(step.conclusion, '\\+', 1) ? step.conclusion.args[0] : step.conclusion.args?.[1];
      for (const part of inner ? flattenConjunction(inner) : []) {
        if (isCallable(part) && termIsGround(part)) redecideGoals.push(part);
      }
    }
  }
  const redecide = makeRedecider(program, redecideGoals);
  const trusted = [];
  const boundaries = [];
  let verified = 0;
  let redecided = 0;
  let composed = 0;
  let uses = 0;

  const trust = (kind, step, reason = 'theory_scoped') => {
    trusted.push({ kind, reason, conclusion: key(step.conclusion), term: step.conclusion });
    if (options.strict) fail('C5', `trusted boundary forbidden: ${kind}`, step.conclusion);
  };

  const compose = (step) => {
    const alternatives = controlAlternatives(step.conclusion);
    const composes = (alternative) => alternative.length === step.uses.length &&
      alternative.every((part, i) => identical(part, step.uses[i]));
    if (step.bindings.length > 0 || !alternatives || !alternatives.some(composes)) {
      fail('C5', `control step does not follow from its uses: ${show(step.conclusion)}`, step.conclusion);
    } else {
      composed++;
    }
  };

  // C4 for each step's uses, then the C1, C3 or C5 check of its justification.
  for (const step of steps.values()) {
    const goal = step.conclusion;
    for (const use of step.uses) {
      uses++;
      if (!covered(use)) fail('C4', `unjustified use ${show(use)}`, goal);
    }
    const by = step.by;
    if ((isCompound(by, 'rule', 1) || isCompound(by, 'fact', 1)) && by.args[0]?.type === NUMBER) {
      const number = Number(by.args[0].name);
      const clause = Number.isInteger(number) ? numbering.get(number) : null;
      if (!clause) {
        fail('C1', `unknown clause ${show(by)}`, goal);
      } else if (by.name === 'fact' && (clause.body ?? []).length !== 0) {
        fail('C1', `clause ${number} has a body, so it is not a fact`, goal);
      } else if (!checkResolution(step, number, clause)) {
        fail('C1', `not an instance of source clause ${number}: ${show(goal)}`, goal);
      } else {
        verified++;
      }
    } else if (isAtom(by, 'control')) {
      compose(step);
    } else if (isAtom(by, 'builtin')) {
      if (!isCallable(goal)) {
        fail('C3', 'invalid builtin justification', goal);
        continue;
      }
      const reason = NOT_REDECIDABLE.get(predicateKey(goal));
      if (reason) {
        trust('builtin', step, reason);
        continue;
      }
      const outcome = redecide(goal);
      if (outcome.status === 'agrees') {
        redecided++;
      } else if (outcome.status === 'disagrees') {
        fail('C5', outcome.detail
          ? `primitive went wrong: ${show(goal)}: ${outcome.detail}`
          : `primitive disagrees: ${show(goal)}`, goal);
      } else if (step.uses.length > 0 && controlAlternatives(goal)) {
        // An older document records a control construct as `builtin`; it is
        // held to what a `control` step is held to.
        compose(step);
      } else {
        // Nothing was learned about this step, so it is still an obligation.
        trust('builtin', step);
      }
    } else if ((isAtom(by, 'absent') && isCompound(goal, '\\+', 1)) ||
               (isAtom(by, 'collected') && isCompound(goal, 'findall', 3))) {
      if (step.bindings.length > 0 || step.uses.length > 0) {
        fail('C3', 'trusted boundaries cannot have bindings or uses', goal);
      }
      boundaries.push(goal);
      trust(by.name, step);
    } else if (isAtom(by, 'asserted')) {
      // A clause `assert/1` created at run time is in no source file, so
      // there is nothing to check it against.
      trust('asserted', step);
    } else if (isAtom(by, 'unproven')) {
      // Not an unknown justification but an admission: the writer could not
      // explain this conclusion, and says so.
      fail('C3', 'recorded as unproven', goal);
    } else {
      fail('C3', `unknown justification ${show(by)}`, goal);
    }
  }

  const confronted = checkBoundaries(program, steps, boundaries, redecide, fail, show);
  checkRelevance(claims, steps, readQuestions(program, options.goals ?? sourceGoals(program)), fail, show);
  checkWellFounded(steps, fail, show);

  const failed = (condition) => failures.filter((failure) => failure.condition === condition).length;
  // What each condition covered, so a reader can see the shape of the check
  // rather than only its verdict. A condition that examined nothing says so:
  // "0 steps" is information, not a pass.
  const conditions = [
    { id: 'C1', name: 'resolution', covered: verified, failed: failed('C1') },
    { id: 'C2', name: 'well_founded', covered: steps.size, failed: failed('C2') },
    { id: 'C3', name: 'justification', covered: steps.size, failed: failed('C3') },
    { id: 'C4', name: 'coverage', covered: claims.length + uses, failed: failed('C4') },
    { id: 'C5', name: 're_decision', covered: redecided + composed, failed: failed('C5') },
    { id: 'C6', name: 'boundary_consistency', covered: confronted, failed: failed('C6') },
    { id: 'C7', name: 'relevance', covered: claims.length + steps.size, failed: failed('C7') },
  ];

  return {
    writeOptions,
    valid: failures.length === 0,
    steps: steps.size,
    claims: claims.length,
    verified,
    redecided,
    composed,
    uses,
    trusted,
    failures,
    conditions,
  };
}

// C6: a trusted boundary cannot be proved, but the evidence at hand can refute
// it. An absence fails when the evidence shows a solution of what it says has
// none; a collection fails when its list misses a solution the evidence
// shows. Returns how many boundaries the evidence could speak for.
function checkBoundaries(program, steps, boundaries, redecide, fail, show) {
  if (boundaries.length === 0) return 0;
  const { userGroup, isPure } = evidenceAnalysis(program, [...steps.values()]);
  const stepGoals = new Map();
  for (const step of steps.values()) {
    const goalKey = predicateKey(step.conclusion);
    if (!goalKey) continue;
    if (!stepGoals.has(goalKey)) stepGoals.set(goalKey, []);
    stepGoals.get(goalKey).push(step.conclusion);
  }

  // Each solution of a simple goal the evidence shows, or null when the
  // evidence cannot speak for the goal.
  const evidence = (goal) => {
    if (!isCallable(goal)) return null;
    const goalKey = predicateKey(goal);
    if (CONTROL_KEYS.has(goalKey)) return null;
    const group = userGroup(goal);
    if (group) {
      if (!isPure(goal)) return null;
      const facts = group.clauses.filter((clause) => (clause.body ?? []).length === 0).map((clause) => fresh(clause.head));
      return [...facts, ...(stepGoals.get(goalKey) ?? []).map((item) => fresh(item))];
    }
    if (!termIsGround(goal) || NOT_REDECIDABLE.has(goalKey)) return null;
    const outcome = redecide(goal);
    if (outcome.status === 'agrees') return [goal];
    if (outcome.status === 'disagrees' && !outcome.detail) return [];
    return null;
  };

  let confronted = 0;
  for (const boundary of boundaries) {
    if (isCompound(boundary, '\\+', 1)) {
      const parts = flattenConjunction(boundary.args[0]);
      // Without a join, only a single goal or a ground conjunction is decided.
      if (parts.length > 1 && !termIsGround(boundary.args[0])) continue;
      const shown = parts.map(evidence);
      if (shown.some((items) => items == null)) continue;
      confronted++;
      const solved = parts.every((part, i) => shown[i].some((item) => unify(fresh(part), item, new Env())));
      if (solved) fail('C6', `absence contradicted by evidence: ${show(boundary)}`, boundary);
      continue;
    }
    const [template, inner, list] = boundary.args;
    const items = properListItems(list, new Env());
    if (items == null) {
      fail('C6', `collected result is not a proper list: ${show(boundary)}`, boundary);
      continue;
    }
    const parts = flattenConjunction(inner);
    const shown = parts.length === 1 ? evidence(parts[0]) : null;
    if (shown == null) continue;
    confronted++;
    for (const item of shown) {
      const variables = new Map();
      const pattern = fresh(template, variables);
      const goal = freshTerm(parts[0], `check${freshCounter}`, variables);
      const env = new Env();
      if (!unify(goal, item, env)) continue;
      const answer = copyResolved(pattern, env);
      if (!items.some((element) => unify(answer, fresh(element), new Env()))) {
        fail('C6', `collection misses ${show(answer)}: ${show(boundary)}`, boundary);
        break;
      }
    }
  }
  return confronted;
}

// C7: the document answers the question that was asked and carries nothing
// beside it. Each claim is an instance of a goal; each step is reachable from
// a claim through the uses of steps.
function checkRelevance(claims, steps, questions, fail, show) {
  const instanceOf = (claim, question) => {
    const env = new Env();
    const pattern = fresh(question);
    return unify(pattern, claim, env) && resolvesTo(pattern, env, claim);
  };
  for (const claim of claims) {
    if (!questions.some((question) => instanceOf(claim, question))) {
      fail('C7', `claim answers no goal: ${show(claim)}`, claim);
    }
  }
  const reached = new Set();
  const reach = claims.flatMap((claim) => flattenConjunction(claim).map(key));
  while (reach.length) {
    const id = reach.pop();
    if (reached.has(id) || !steps.has(id)) continue;
    reached.add(id);
    for (const use of steps.get(id).uses) {
      for (const part of flattenConjunction(use)) reach.push(key(part));
    }
  }
  for (const [id, step] of steps) {
    if (!reached.has(id)) fail('C7', `step serves no claim: ${show(step.conclusion)}`, step.conclusion);
  }
}

// C2: following what a step used never leads back to it. A proof that rested
// on itself would prove anything.
function checkWellFounded(steps, fail, show) {
  const visiting = new Set();
  const visited = new Set();
  const supports = (id) => {
    const used = [];
    for (const use of steps.get(id)?.uses ?? []) {
      for (const part of flattenConjunction(use)) {
        const partId = key(part);
        if (steps.has(partId)) used.push(partId);
      }
    }
    return used;
  };
  for (const start of steps.keys()) {
    if (visited.has(start)) continue;
    visiting.add(start);
    const stack = [{ at: start, next: supports(start), index: 0 }];
    while (stack.length) {
      const top = stack[stack.length - 1];
      if (top.index >= top.next.length) {
        visiting.delete(top.at);
        visited.add(top.at);
        stack.pop();
        continue;
      }
      const following = top.next[top.index++];
      if (visiting.has(following)) {
        const goal = steps.get(following).conclusion;
        fail('C2', `cyclic derivation at ${show(goal)}`, goal);
        continue;
      }
      if (visited.has(following)) continue;
      visiting.add(following);
      stack.push({ at: following, next: supports(following), index: 0 });
    }
  }
}

// A report fact with its variables renamed A, B, ..., Z, A1, ... in order of
// first occurrence, so a report does not depend on the names a document used.
function lettered(term) {
  const names = new Map();
  const visit = (t) => {
    if (t.type === VAR) {
      if (!names.has(t.name)) {
        const index = names.size;
        const letter = String.fromCharCode(65 + (index % 26));
        names.set(t.name, variable(index < 26 ? letter : `${letter}${Math.floor(index / 26)}`));
      }
      return names.get(t.name);
    }
    if (t.type === COMPOUND) return compound(t.name, t.args.map(visit));
    return t;
  };
  return visit(term);
}

// The whole check as ordinary Prolog facts, so a check result is the same kind
// of thing as the proof it checked and the program that produced it: something
// a later program can load and reason over rather than a report a person has
// to read. One formatter backs the command line, the packaged
// examples/check documents, and anything embedding the checker.
//
//   condition(Id, Name, Outcome, Covered)   one per condition, C1 to C7
//   failure(Id, Subject, Detail)            Subject is the term concerned
//   obligation(Kind, Reason, Conclusion)    what the check rests on
//   steps/1 verified/1 recomputed/1 composed/1 trusted/1 claims/1
//   verdict(checked | checked_with_obligations | failed(N))
export function checkReportTerms(report) {
  // Write terms the way the proof under check writes them, so `\\+ G` is not
  // spelled `'\\\\+'(G)` here and the two documents stay comparable by eye.
  const options = report.writeOptions ?? { quoted: true };
  const out = [];
  const say = (term) => out.push(`${formatTermForWrite(lettered(term), new Env(), options)}.`);
  const atomTerm = (text) => compound(String(text));
  const integer = (value) => numberTerm(BigInt(value));

  for (const condition of report.conditions ?? []) {
    const outcome = condition.failed > 0 ? compound('failed', [integer(condition.failed)]) : atomTerm('ok');
    say(compound('condition', [atomTerm(condition.id), atomTerm(condition.name), outcome, integer(condition.covered)]));
  }
  for (const failure of report.failures ?? []) {
    const subject = failure.term ?? atomTerm(failure.conclusion ?? 'proof_document');
    say(compound('failure', [atomTerm(failure.condition), subject, atomTerm(failure.detail)]));
  }
  for (const item of report.trusted ?? []) {
    say(compound('obligation', [atomTerm(item.kind), atomTerm(item.reason ?? 'theory_scoped'), item.term ?? atomTerm(item.conclusion)]));
  }
  const counts = [
    ['steps', report.steps], ['verified', report.verified], ['recomputed', report.redecided],
    ['composed', report.composed ?? 0], ['trusted', (report.trusted ?? []).length], ['claims', report.claims],
  ];
  for (const [label, count] of counts) say(compound(label, [integer(count)]));
  out.push(verdictTermText(report).trimEnd());
  return `${out.join('\n')}\n`;
}

function verdictTerm(report) {
  if (!report.valid) return `failed(${report.failures.length})`;
  return (report.trusted ?? []).length > 0 ? 'checked_with_obligations' : 'checked';
}

// The verdict alone, as the one fact a script usually wants.
export function verdictTermText(report) {
  return `verdict(${verdictTerm(report)}).\n`;
}

// The report without its term-valued internals, ready for JSON.
export function publicReport(report) {
  return {
    valid: report.valid,
    steps: report.steps,
    claims: report.claims,
    verified: report.verified,
    redecided: report.redecided,
    composed: report.composed,
    uses: report.uses,
    trusted: report.trusted.map(({ kind, reason, conclusion }) => ({ kind, reason, conclusion })),
    failures: report.failures.map(({ condition, detail, conclusion }) => (
      conclusion == null ? { condition, detail } : { condition, detail, conclusion })),
    conditions: report.conditions.map((condition) => ({ ...condition })),
  };
}

export function verdict(report) {
  if (!report.valid) return `${report.failures.length} failure(s)`;
  const recomputed = report.redecided ? `, ${report.redecided} recomputed` : '';
  if (report.trusted.length) {
    return `checked with obligations: ${report.steps} steps${recomputed}, ${report.trusted.length} trusted`;
  }
  return `checked: ${report.steps} steps${recomputed}`;
}
