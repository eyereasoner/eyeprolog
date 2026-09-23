// Shared goal preparation and execution for the CLI and embedding API.
import { ATOM, COMPOUND, NUMBER, VAR, Env, compound, copyResolved, termIsGround, variable } from './term.js';
import { parseGoalText } from './parser.js';
import { HaltSignal, PrologError } from './iso.js';
import { formatTermForWrite } from './write.js';
import { loadBundledProgramLibrary } from './program.js';

export function normalizeGoals(requestedGoals, solver) {
  return requestedGoals.map((requestedGoal) => {
    const goal = typeof requestedGoal === 'string'
      ? parseGoalText(requestedGoal, {
          doubleQuotes: solver.prologFlags.get('double_quotes')?.value?.name ?? 'chars',
          operatorDefinitions: [...solver.program.operators.values()],
          isoStrict: solver.isoStrict,
        })
      : requestedGoal;
    if (goal.type === VAR) throw new PrologError('instantiation_error');
    if (goal.type !== ATOM && goal.type !== COMPOUND) throw new PrologError('type_error(callable)', goal);
    return goal;
  });
}

export function executeGoals(program, solver, goals, { onAnswer = () => {} } = {}) {
  const initialWriteOptions = currentWriteOptions(program, solver);
  const queriedKeys = new Set(goals.map((goal) => `${goal.name}/${goal.arity}`));
  const facts = program.sourceFactLines(queriedKeys, initialWriteOptions);
  const seen = new Set();
  let haltCode = null;

  try {
    solver.runInitializations();
    for (const goal of goals) {
      solver.solutionsSeen = 0;
      for (const env of solver.solve([goal], new Env(), 0)) {
        if (!termIsGround(goal, env)) continue;
        const resolved = copyResolved(goal, env);
        const line = `${formatTermForWrite(resolved, new Env(), currentWriteOptions(program, solver))}.\n`;
        if (facts.has(line) || seen.has(line)) continue;
        seen.add(line);
        onAnswer(line, resolved);
      }
    }
  } catch (error) {
    if (!(error instanceof HaltSignal)) throw error;
    haltCode = error.code;
  }

  return { haltCode };
}

function currentWriteOptions(program, solver) {
  return {
    doubleQuotes: solver.prologFlags.get('double_quotes')?.value?.name ?? 'chars',
    doubleBar: !solver.isoStrict,
    operators: [...program.operators.values()],
    quoted: true,
  };
}


// Eyelet forward-rule bootstrap.
//
// The :+/2 fixed-point semantics live in library(eyelet).  This JavaScript
// adapter only ensures that library is loaded, invokes its Prolog driver, and
// converts the driver's recorded answer/fuse events to the public callbacks.
export function hasForwardRules(program) {
  return program.findGroup(':+', 2) != null;
}

export function executeForwardRules(program, solver, {
  onAnswer = () => {},
  onFuse = () => {},
  onDiagnostic = () => {},
} = {}) {
  if (!hasForwardRules(program)) return { haltCode: null, rounds: 0, derived: 0 };

  // Load the Prolog driver without importing a bootstrap-only predicate into
  // user or widening library(eyelet)'s public API.
  loadBundledProgramLibrary(program, 'eyelet');
  solver.runInitializations();

  const roundsVar = variable('\u0000eyeletRounds');
  const derivedVar = variable('\u0000eyeletDerived');
  const statusVar = variable('\u0000eyeletStatus');
  const driver = compound('eyelet_run', [roundsVar, derivedVar, statusVar]);
  driver.module = 'eyelet';

  let resultEnv = null;
  const previousEventHandler = solver.eyeletEventHandler;
  solver.eyeletEventHandler = (kind, term) => {
    if (kind === 'answer') {
      onAnswer(forwardLine(term, program, solver), term);
    } else if (kind === 'fuse') {
      const fuse = compound('fuse', [term]);
      onFuse(forwardLine(fuse, program, solver), fuse);
    }
  };
  const iterator = solver.solve([driver], new Env(), 0);
  try {
    const result = iterator.next();
    if (!result.done) resultEnv = result.value;
  } finally {
    try { iterator.return?.(); } catch (_) { /* best effort */ }
    solver.eyeletEventHandler = previousEventHandler;
  }
  if (resultEnv == null) return { haltCode: null, rounds: 0, derived: 0 };

  const rounds = resolvedInteger(roundsVar, resultEnv, 0);
  const derived = resolvedInteger(derivedVar, resultEnv, 0);
  const status = copyResolved(statusVar, resultEnv);
  const haltCode = status?.type === ATOM && status.name === 'fuse' ? 2 : null;

  // Kept for source compatibility with the existing callback shape. The
  // Prolog driver currently has no diagnostic event kind.
  void onDiagnostic;
  return { haltCode, rounds, derived };
}

function resolvedInteger(term, env, fallback) {
  const value = copyResolved(term, env);
  return value?.type === NUMBER && /^-?\d+$/.test(value.name) ? Number(value.name) : fallback;
}

function forwardLine(term, program, solver) {
  return `${formatTermForWrite(term, new Env(), {
    // Eyelet historically used portray_clause/2. Keep character lists as list
    // syntax rather than collapsing them according to double_quotes.
    doubleQuotes: null,
    operators: [...program.operators.values()],
    quoted: true,
    compact: true,
    minimalOperatorSpacing: true,
    operatorAtomsAsArgs: true,
    generateVariableNames: true,
  })}.\n`;
}
