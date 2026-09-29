// Proof checking.
//
// A proof document says what was concluded and why. Checking it means
// re-performing every inference it records against the program it claims to
// come from: the specification is eyeron's `docs/proof-checking.md`, and
// this is the Prolog-syntax reading of it.
//
// A checker does not reason. It never searches for a derivation the document
// failed to record, and it never runs the program; it only verifies what is
// written. Four conditions decide validity:
//
//   C1 Resolution     -- every checked step really is an instance of the
//                        clause it cites.
//   C2 Well-founded   -- the derivation graph has no cycles.
//   C3 Justification  -- every step carries exactly one known justification.
//   C4 Coverage       -- every claim has a step, and every use resolves to
//                        a step or to a statement the program gives.
//   C5 Re-decision    -- a step the document only asserts, rather than
//                        deriving, is computed again here and must agree.
//
// C5 is what keeps this a check rather than a reading. A condition that
// cannot fail is not much of a check, so a step whose justification is
// `builtin` -- the largest class in a typical proof -- is not taken on the
// document's word. Its goal is run again against a program holding the
// bundled libraries and nothing else: no clause of the theory under proof is
// present, so the re-decision cannot be talked into agreeing by the very
// rules it is meant to audit. Disagreement is a C5 failure.
//
// This does not make the checker reason. It still never searches for a
// derivation the document failed to record; it only recomputes primitives
// the document asserts without one.
//
// `absent`, `collected` and `asserted` stay trusted, and deliberately.
// `absent` is negation as failure over the theory, so re-deciding it would
// mean searching exactly the clauses C5 excludes -- and doing it in the
// library-only program would make every such step pass for the wrong reason,
// which is weaker than admitting it was trusted. They are reported so a
// reader knows what the check still rests on.
import { ATOM, COMPOUND, Env, compareTerms, copyResolved, freshTerm, properListItems, termToString, unify } from './term.js';
import { parseProgramText } from './parser.js';
import { clauseNumbering } from './explain.js';
import { Program, autoloadProgramGoals } from './program.js';
import { Solver } from './solver.js';

const CHECKED = new Set(['rule', 'fact']);
// Recomputed independently by C5 rather than taken on the document's word.
const REDECIDED = new Set(['builtin']);

// Goals that state a fact about the run rather than compute a value, and so
// cannot be recomputed by a program that deliberately holds neither the
// theory nor the run's accumulated state. Re-running one of these against
// C5's library-only program would decide it on the wrong evidence, which is
// weaker than admitting it was trusted -- so they are named here, by the two
// reasons they are outside C5's reach, and reported as obligations.
//
// Reflective: the goal reads the theory's own database or syntax, which is
// exactly what C5 excludes in order to stay independent of it.
// Stateful: the goal's answer depends on constraint or attribute state that
// the original run built up and a fresh solver has no way to reconstruct.
const NOT_REDECIDABLE = new Map([
  ['clause/2', 'reflective'],
  ['current_predicate/1', 'reflective'],
  ['current_op/3', 'reflective'],
  ['get_atts/2', 'stateful'],
  ['put_atts/2', 'stateful'],
  // Stream operations name a handle the original run opened, and re-running
  // one would not merely fail -- it would perform I/O of its own. A checker
  // must not have side effects, so these are never recomputed.
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

function notRedecidableReason(goal) {
  if (goal?.type !== COMPOUND && goal?.type !== ATOM) return null;
  return NOT_REDECIDABLE.get(`${goal.name}/${goal.arity ?? 0}`) ?? null;
}
// Recorded rather than re-derived. `absent` and `collected` range over the
// theory under proof, which C5's program deliberately excludes. `asserted`
// is eyeprolog's own: a clause `assert/1` created at run time is in no
// source file, so there is nothing to check it against.
const TRUSTED = new Set(['absent', 'collected', 'asserted']);

function key(term) {
  return termToString(term, new Env(), true);
}

function isCompound(term, name, arity) {
  return term?.type === COMPOUND && term.name === name && term.arity === arity;
}

// The document, read as the abstract model: the claims its plain facts
// make, and the steps its `step/4` facts record.
export function readProofDocument(text, program) {
  // The document is read with the program's own operators: a rule set that
  // declares `op/3` writes its terms that way, and its proof quotes them.
  const clauses = parseProgramText(String(text), {
    doubleQuotes: program?.doubleQuotes ?? 'chars',
    operatorDefinitions: [...(program?.operators?.values() ?? [])],
    sourceMetadata: false,
  });
  // A proof document states what it concluded and then why: the claims are
  // its plain facts, and `clause/3` and `step/4` are the proof vocabulary
  // explaining them. That is the same division the N3 and SPARQL-RL
  // documents make.
  const claims = [];
  const steps = [];
  for (const clause of clauses) {
    if (!clause?.head || clause.body?.length !== 0) continue;
    const head = clause.head;
    if (isCompound(head, 'clause', 3)) continue;
    if (!isCompound(head, 'step', 4)) {
      claims.push(head);
      continue;
    }
    const bindings = properListItems(head.args[2], new Env());
    const uses = properListItems(head.args[3], new Env());
    if (bindings == null || uses == null) continue;
    steps.push({
      conclusion: head.args[0],
      by: head.args[1],
      bindings: bindings.map((item) => ({ name: item.args?.[0]?.name, value: item.args?.[1] })),
      uses,
    });
  }
  return { claims, steps };
}

// The justification a step carries, as a kind and, for a checked one, the
// clause it cites. A step that carries none, or more than one, fails C3.
function justificationOf(step) {
  const by = step.by;
  if (by?.type === ATOM && REDECIDED.has(by.name)) return { kind: by.name, clause: null };
  if (by?.type === ATOM && TRUSTED.has(by.name)) return { kind: by.name, clause: null };
  if (by?.type === COMPOUND && CHECKED.has(by.name) && by.arity === 1) {
    const number = Number(by.args[0]?.name);
    if (Number.isInteger(number) && number > 0) return { kind: by.name, clause: number };
  }
  return null;
}

// C1: the step really is an instance of the clause it cites. The clause is
// taken from the program, not from the document -- a proof cannot be made
// valid by restating the rule it used. Its variables are renamed apart,
// bound to the values the step recorded, and the result must produce this
// conclusion from exactly these uses.
function checkResolution(step, clause, id) {
  const variables = new Map();
  const head = freshTerm(clause.head, id, variables);
  const body = (clause.body ?? []).map((goal) => freshTerm(goal, id, variables));
  const env = new Env();

  for (const binding of step.bindings) {
    const fresh = variables.get(binding.name);
    // A binding for a variable the clause does not have says the step was
    // recorded against a different rule than the one it cites.
    if (!fresh) return `no variable ${binding.name} in clause ${step.clause}`;
    if (!unify(fresh, binding.value, env)) return `binding ${binding.name} does not hold`;
  }

  if (!unify(head, step.conclusion, env)) return 'conclusion is not the head of that clause';
  if (body.length !== step.uses.length) return `clause has ${body.length} premise(s), the step uses ${step.uses.length}`;
  for (let i = 0; i < body.length; i++) {
    if (!unify(body[i], step.uses[i], env)) return `use ${i + 1} is not that premise`;
  }
  // Every use must be an instance of the premise it answers, so resolving
  // the clause really does yield this conclusion.
  if (compareTerms(copyResolved(head, env), step.conclusion) !== 0) return 'conclusion is not an instance of that clause';
  return null;
}

// C2: following what a step used never leads back to it. A proof that
// rested on itself would prove anything.
function checkWellFounded(byConclusion, failures) {
  const OPEN = 1;
  const DONE = 2;
  const state = new Map();
  for (const start of byConclusion.keys()) {
    if (state.get(start)) continue;
    const stack = [{ at: start, uses: null, index: 0 }];
    state.set(start, OPEN);
    while (stack.length) {
      const frame = stack[stack.length - 1];
      if (frame.uses == null) frame.uses = (byConclusion.get(frame.at)?.uses ?? []).map(key);
      if (frame.index >= frame.uses.length) {
        state.set(frame.at, DONE);
        stack.pop();
        continue;
      }
      const next = frame.uses[frame.index++];
      if (!byConclusion.has(next)) continue;
      if (state.get(next) === OPEN) {
        failures.push({ condition: 'C2', conclusion: next, detail: 'this conclusion is used, directly or not, by its own derivation' });
        state.set(next, DONE);
        continue;
      }
      if (state.get(next) === DONE) continue;
      state.set(next, OPEN);
      stack.push({ at: next, uses: null, index: 0 });
    }
  }
}

// C5's independent route. One program is built per document and reused: it
// holds the bundled libraries the recorded goals need and no clause of the
// theory under proof, so a goal that only the theory could satisfy raises an
// existence error here rather than quietly succeeding.
//
// A step is only re-decided when this program can actually run its goal.
// When it cannot -- the predicate is not one the libraries define -- the step
// is reported as not re-decidable instead of being failed: the checker has
// learned nothing about it, and saying so is honest where failing it would
// not be.
function makeRedecider(program, steps) {
  const goals = [];
  for (const step of steps) {
    const justification = justificationOf(step);
    if (justification && REDECIDED.has(justification.kind)) goals.push(step.conclusion);
  }
  if (goals.length === 0) return () => ({ status: 'unavailable' });

  let primitives = null;
  try {
    primitives = Program.parseSources([{ text: '', filename: '<check>' }], {
      sourceMetadata: false,
      isoStrict: program?.strictIso === true,
    });
    primitives = autoloadProgramGoals(primitives, goals, { autoload: true });
  } catch (_) {
    // No library program could be prepared, so nothing can be re-decided.
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
      const result = solver.runOneAnswer(goal, new Env());
      return result.done ? { status: 'disagrees' } : { status: 'agrees' };
    } catch (error) {
      // An existence error means the libraries do not define this predicate,
      // so the step names something outside what C5 can recompute. Any other
      // error is the goal genuinely going wrong, which is a disagreement.
      const formal = error?.formal ?? '';
      if (typeof formal === 'string' && formal.startsWith('existence_error(procedure')) {
        return { status: 'unavailable' };
      }
      return { status: 'disagrees', detail: error?.message ?? String(error) };
    }
  };
}

let checkFreshCounter = 0;

export function checkProofDocument(program, text) {
  const { claims, steps } = readProofDocument(text, program);
  const numbering = programClauses(program);
  const failures = [];
  const trusted = [];
  let verified = 0;
  let redecided = 0;
  const redecide = makeRedecider(program, steps);

  const byConclusion = new Map();
  for (const step of steps) {
    if (!byConclusion.has(key(step.conclusion))) byConclusion.set(key(step.conclusion), step);
  }

  // A statement the program simply gives, which a use may resolve to
  // without a step of its own.
  const given = new Set();
  for (const clause of program.clauses ?? []) {
    if ((clause.body ?? []).length === 0) given.add(key(clause.head));
  }

  for (const step of steps) {
    const justification = justificationOf(step);
    if (step.by?.type === ATOM && step.by.name === 'unproven') {
      // Not an unknown justification but an admission: the writer could not
      // explain this conclusion, and says so.
      failures.push({ condition: 'C3', conclusion: key(step.conclusion), detail: 'recorded as unproven' });
      continue;
    }
    if (!justification) {
      failures.push({ condition: 'C3', conclusion: key(step.conclusion), detail: `unknown justification ${key(step.by)}` });
      continue;
    }
    if (REDECIDED.has(justification.kind)) {
      const reason = notRedecidableReason(step.conclusion);
      if (reason) {
        trusted.push({ kind: justification.kind, conclusion: key(step.conclusion), reason });
        continue;
      }
      const outcome = redecide(step.conclusion);
      if (outcome.status === 'agrees') {
        redecided++;
      } else if (outcome.status === 'disagrees') {
        failures.push({
          condition: 'C5',
          conclusion: key(step.conclusion),
          detail: outcome.detail
            ? `recomputing this ${justification.kind} step went wrong: ${outcome.detail}`
            : `recomputing this ${justification.kind} step does not give it`,
        });
      } else {
        // Nothing was learned about this step, so it is still an obligation.
        trusted.push({ kind: justification.kind, conclusion: key(step.conclusion) });
      }
      continue;
    }
    if (TRUSTED.has(justification.kind)) {
      trusted.push({ kind: justification.kind, conclusion: key(step.conclusion) });
      continue;
    }

    const clause = numbering.get(justification.clause);
    if (!clause) {
      failures.push({ condition: 'C1', conclusion: key(step.conclusion), detail: `the program has no clause ${justification.clause}` });
      continue;
    }
    if (justification.kind === 'fact' && (clause.body ?? []).length !== 0) {
      failures.push({ condition: 'C1', conclusion: key(step.conclusion), detail: `clause ${justification.clause} has a body, so it is not a fact` });
      continue;
    }
    const detail = checkResolution({ ...step, clause: justification.clause }, clause, `check${++checkFreshCounter}`);
    if (detail) failures.push({ condition: 'C1', conclusion: key(step.conclusion), detail });
    else verified++;
  }

  for (const claim of claims) {
    if (!byConclusion.has(key(claim))) {
      failures.push({ condition: 'C4', conclusion: key(claim), detail: 'claimed, but no step concludes it' });
    }
  }
  for (const step of steps) {
    for (const use of step.uses) {
      if (byConclusion.has(key(use)) || given.has(key(use))) continue;
      failures.push({ condition: 'C4', conclusion: key(step.conclusion), detail: `uses ${key(use)}, which nothing concludes and the program does not give` });
    }
  }

  checkWellFounded(byConclusion, failures);

  return { valid: failures.length === 0, steps: steps.length, verified, redecided, trusted, failures, claims: claims.length };
}

// The program's clauses, numbered from 1 in load order -- the numbering
// `rule(N)` and `fact(N)` cite.
// `clauseNumbering` already holds each clause's head and body under the
// number a proof cites, so the checker reads the program exactly as the
// writer numbered it.
function programClauses(program) {
  return clauseNumbering(program).byNumber;
}

export function verdict(report) {
  if (!report.valid) return `${report.failures.length} failure(s)`;
  const recomputed = report.redecided ? `, ${report.redecided} recomputed` : '';
  if (report.trusted.length) {
    return `checked with obligations: ${report.steps} steps${recomputed}, ${report.trusted.length} trusted`;
  }
  return `checked: ${report.steps} steps${recomputed}`;
}
