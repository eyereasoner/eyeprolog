// call_cleanup/2 and setup_call_cleanup/3 plus solver lifecycle support.
//
// EyeProlog's solver is demand-driven: a yielded builtin remains represented by
// a resumeBuiltin frame until its next answer is requested. Cleanup predicates
// therefore need two pieces of host support:
//   * discarded resumeBuiltin iterators must be closed when search is pruned;
//   * a cleanup iterator can report that its protected goal has no alternatives,
//     so the solver does not retain an exhausted resume frame.
import { PrologError } from './errors.js';
import { deref } from './term.js';

const cleanupLifecycleInstalled = Symbol('eyeprolog.cleanupLifecycleInstalled');
const cleanupLifecycleState = Symbol('eyeprolog.cleanupLifecycleState');
const searchStackPatched = Symbol('eyeprolog.cleanupSearchStackPatched');

export function installCleanupLifecycle(Solver) {
  const prototype = Solver.prototype;
  if (prototype[cleanupLifecycleInstalled]) return;
  Object.defineProperty(prototype, cleanupLifecycleInstalled, { value: true });

  const originalSolve = prototype.solve;
  prototype.solve = function* cleanupAwareSolve(...args) {
    const state = ensureLifecycleState(this);
    const owner = {};
    const iterator = originalSolve.apply(this, args);
    let completed = false;
    let thrown = null;

    try {
      while (true) {
        const result = withOwner(state, owner, () => iterator.next());
        if (result.done) {
          completed = true;
          return result.value;
        }
        yield result.value;
      }
    } catch (error) {
      thrown = error;
      throw error;
    } finally {
      // If the consumer prunes this solve() while it is suspended at an answer,
      // close pending builtin iterators before the original solver removes its
      // explicit search stack. Cleanup exceptions are observable on an ordinary
      // cut/return, but never replace an exception already propagating outward.
      if (!completed) {
        let closeError = null;
        try {
          if (state.active) closeOwnedSearchStacks(this, state, owner, thrown != null);
        } catch (error) {
          closeError = error;
        }
        try {
          withOwner(state, owner, () => iterator.return?.());
        } catch (error) {
          if (closeError == null) closeError = error;
        }
        if (thrown == null && closeError != null) throw closeError;
      }
    }
  };
}

export function registerCleanupBuiltins(registry) {
  registry.add('call_cleanup', 2, callCleanupBuiltin);
  registry.add('setup_call_cleanup', 3, setupCallCleanupBuiltin);
}

function ensureLifecycleState(solver) {
  if (solver[cleanupLifecycleState] != null) return solver[cleanupLifecycleState];
  const state = {
    owner: null,
    stackOwners: new WeakMap(),
    active: false,
  };
  Object.defineProperty(solver, cleanupLifecycleState, { value: state });

  const solveStacks = solver.solveStacks;
  const originalPush = solveStacks.push;
  const originalSplice = solveStacks.splice;

  solveStacks.push = function cleanupAwarePush(...stacks) {
    for (const stack of stacks) {
      state.stackOwners.set(stack, state.owner);
      if (state.active) patchSearchStack(stack);
    }
    return originalPush.apply(this, stacks);
  };

  solveStacks.splice = function cleanupAwareSplice(start, deleteCount, ...items) {
    const removed = originalSplice.call(this, start, deleteCount, ...items);
    // This path is used by Solver.solve()'s finally block. If the solve is
    // unwinding an exception, a cleanup exception must not replace it. Normal
    // consumer pruning closes frames earlier in cleanupAwareSolve(), where
    // cleanup errors are allowed to propagate.
    if (state.active) {
      for (let index = removed.length - 1; index >= 0; index--) {
        closeSearchStack(removed[index], true);
      }
    }
    return removed;
  };

  return state;
}

function withOwner(state, owner, operation) {
  const previous = state.owner;
  state.owner = owner;
  try {
    return operation();
  } finally {
    state.owner = previous;
  }
}

function activateCleanupLifecycle(solver) {
  const state = ensureLifecycleState(solver);
  if (state.active) return state;
  state.active = true;
  for (const stack of solver.solveStacks) {
    if (!state.stackOwners.has(stack)) state.stackOwners.set(stack, state.owner);
    patchSearchStack(stack);
  }
  return state;
}

function patchSearchStack(stack) {
  if (stack[searchStackPatched]) return;
  Object.defineProperty(stack, searchStackPatched, { value: true });
  const originalSplice = stack.splice;
  stack.splice = function cleanupAwareSearchSplice(start, deleteCount, ...items) {
    const removed = originalSplice.call(this, start, deleteCount, ...items);
    // A cut prunes explicit search frames synchronously. Closing a discarded
    // builtin iterator here gives call_cleanup/2 its required cut semantics and
    // also lets existing builtin finally blocks release their child solvers.
    closeFrames(removed, false);
    return removed;
  };
}

function closeOwnedSearchStacks(solver, state, owner, suppressErrors) {
  const stacks = solver.solveStacks
    .filter((stack) => state.stackOwners.get(stack) === owner)
    .slice()
    .reverse();
  let firstError = null;
  for (const stack of stacks) {
    try {
      closeSearchStack(stack, suppressErrors);
    } catch (error) {
      if (firstError == null) firstError = error;
    }
  }
  if (!suppressErrors && firstError != null) throw firstError;
}

function closeSearchStack(stack, suppressErrors) {
  if (stack == null || stack.length === 0) return;
  // Use Array.prototype directly: calling the patched splice would always use
  // cut semantics (propagating errors) even while an exception is unwinding.
  const removed = Array.prototype.splice.call(stack, 0, stack.length);
  closeFrames(removed, suppressErrors);
}

// A caught exception discards only the protected goal's alternatives. Cleanup
// must run before recovery, without replacing the exception being unwound.
export function unwindSearchStack(stack, start) {
  const removed = Array.prototype.splice.call(stack, start, stack.length - start);
  closeFrames(removed, true);
}

function closeFrames(frames, suppressErrors) {
  let firstError = null;
  for (let index = frames.length - 1; index >= 0; index--) {
    const frame = frames[index];
    if (frame?.kind !== 'resumeBuiltin' || typeof frame.iterator?.return !== 'function') continue;
    try {
      frame.iterator.prepareClose?.({ unwinding: suppressErrors });
      frame.iterator.return();
    } catch (error) {
      if (firstError == null) firstError = error;
    }
  }
  if (!suppressErrors && firstError != null) throw firstError;
}

function callableTerm(term, env) {
  const value = deref(term, env);
  if (value.type === 'var') throw new PrologError('instantiation_error');
  if (value.type !== 'atom' && value.type !== 'compound') {
    throw new PrologError('type_error(callable)', value);
  }
  return value;
}

function firstSetupSolution(solver, setup, env) {
  const child = solver.cloneForInnerGoal(1);
  const iterator = child.solve([callableTerm(setup, env)], env.clone(), 0);
  try {
    const result = iterator.next();
    return result.done ? null : result.value;
  } finally {
    try {
      iterator.return?.();
    } finally {
      solver.absorbStatsFrom(child);
    }
  }
}

function callCleanupBuiltin({ solver, goal, env }) {
  activateCleanupLifecycle(solver);
  const cleanup = callableTerm(goal.args[1], env);
  return cleanupProtectedIterator(solver, goal.args[0], cleanup, env);
}

function setupCallCleanupBuiltin({ solver, goal, env }) {
  activateCleanupLifecycle(solver);
  let protectedIterator = null;
  let pending = true;
  const iterator = (function* setupThenProtected() {
    const setupEnv = firstSetupSolution(solver, goal.args[0], env);
    if (setupEnv == null) {
      pending = false;
      return;
    }
    // The cleanup is validated after Setup succeeds and before Goal starts, as
    // in the WG17 cleanup proposal. A variable bound by Setup may therefore be
    // used as Cleanup.
    const cleanup = callableTerm(goal.args[2], setupEnv);
    protectedIterator = cleanupProtectedIterator(solver, goal.args[1], cleanup, setupEnv);
    try {
      while (true) {
        const result = protectedIterator.next();
        pending = protectedIterator.hasPendingAlternatives();
        if (result.done) {
          pending = false;
          return;
        }
        yield result.value;
        if (!pending) return;
      }
    } finally {
      protectedIterator.return?.();
    }
  })();
  iterator.hasPendingAlternatives = () => pending;
  iterator.prepareClose = (reason) => protectedIterator?.prepareClose?.(reason);
  return iterator;
}

function cleanupProtectedIterator(solver, protectedGoal, cleanup, initialEnv) {
  const child = solver.cloneForInnerGoal();
  let childIterator = null;
  let cleanupEnv = initialEnv;
  let pending = true;
  let cleaned = false;
  let bodyError = null;
  let unwindToSetupBindings = false;

  const performCleanup = () => {
    if (cleaned) return cleanupEnv;
    // Mark first so a throwing Cleanup is still considered executed exactly once.
    cleaned = true;
    cleanupEnv = runCleanupOnce(solver, cleanup, cleanupEnv);
    return cleanupEnv;
  };

  const iterator = (function* protectedWithCleanup() {
    try {
      childIterator = child.solve([callableTerm(protectedGoal, initialEnv)], initialEnv.clone(), 0);
      while (true) {
        const result = childIterator.next();
        if (result.done) {
          pending = false;
          // At the latest cleanup moment, Goal bindings have been undone.
          cleanupEnv = initialEnv;
          return;
        }

        cleanupEnv = result.value;
        pending = child.hasPendingAlternatives();
        if (!pending) {
          // A deterministic final answer is known from the solver's explicit
          // pending-frame state. Finalize the protected iterator and cleanup now,
          // before yielding the answer, without computing a speculative answer.
          childIterator.return?.();
          childIterator = null;
          performCleanup();
        }

        yield pending ? result.value : cleanupEnv;
        if (!pending) return;
      }
    } catch (error) {
      bodyError = error;
      // Exceptions from Goal unwind its bindings before Cleanup is called.
      cleanupEnv = initialEnv;
      throw error;
    } finally {
      let childCloseError = null;
      if (childIterator != null) {
        try {
          childIterator.return?.();
        } catch (error) {
          childCloseError = error;
        }
        childIterator = null;
      }
      solver.absorbStatsFrom(child);

      if (unwindToSetupBindings) cleanupEnv = initialEnv;
      if (!cleaned) {
        try {
          performCleanup();
        } catch (cleanupError) {
          // When the protected goal (or an inner cleanup) already raised, it has
          // priority over this cleanup exception. An exception from an outer
          // continuation is preserved by cleanup-aware stack teardown too.
          if (bodyError == null && childCloseError == null) throw cleanupError;
        }
      }
      if (bodyError == null && childCloseError != null) throw childCloseError;
    }
  })();

  iterator.hasPendingAlternatives = () => pending;
  iterator.prepareClose = ({ unwinding } = {}) => {
    unwindToSetupBindings = unwinding === true;
  };
  return iterator;
}

function runCleanupOnce(solver, cleanup, env) {
  const child = solver.cloneForInnerGoal(1);
  const iterator = child.solve([cleanup], env.clone(), 0);
  let result;
  try {
    result = iterator.next();
  } finally {
    try {
      iterator.return?.();
    } finally {
      solver.absorbStatsFrom(child);
    }
  }
  // Cleanup failure is ignored. When Cleanup runs before a deterministic
  // protected answer is yielded, however, its substitutions are part of that
  // answer; callers that prune a pending answer have already observed it and
  // therefore cannot receive later Cleanup substitutions.
  return result.done ? env : result.value;
}
