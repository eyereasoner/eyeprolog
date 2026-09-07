// Runtime control and ISO processor error types shared across subsystems.
// Keep these independent of the ISO builtin registry so syntax, DCG, program,
// and solver layers can report Prolog errors without importing the whole ISO
// implementation (and without creating semantic-layer import cycles).
import { atom, compound, numberTerm, termToString } from './term.js';

export class PrologError extends Error {
  constructor(formal, culprit = null) {
    const detail = culprit == null ? formal : `${formal}, ${termToString(culprit)}`;
    super(`error(${detail})`);
    this.name = 'PrologError';
    this.formal = formal;
    this.culprit = culprit;
  }
}

export class HaltSignal extends Error {
  constructor(code = 0) {
    super(`halt(${code})`);
    this.name = 'HaltSignal';
    this.code = code;
  }
}

// ISO 7.12.2 leaves the second argument of error/2 implementation defined.
// Reporting which built-in raised the error is far more useful than a constant,
// so built-in call sites attach the predicate indicator when the raising code
// did not supply a context of its own. The indicator term is built once per
// registry entry and reused, so the error path allocates nothing extra.
function builtinErrorContext(def, goal) {
  let context = def._errorContextTerm;
  if (context === undefined) {
    context = compound('/', [atom(goal.name), numberTerm(goal.arity)]);
    def._errorContextTerm = context;
  }
  return context;
}

// Shared, pre-built error instances are thrown many times from different
// built-ins, so tagging one with a context would leak the first thrower's
// indicator into every later report. They keep the default context, which also
// preserves the ground-error-term cache in formalErrorTerm.
export function attachBuiltinErrorContext(error, def, goal) {
  if (!(error instanceof PrologError)) return error;
  if (error.contextTerm != null || error._sharedInstance === true) return error;
  error.contextTerm = builtinErrorContext(def, goal);
  return error;
}
