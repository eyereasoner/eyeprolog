// Public JavaScript API surface for embedders and the browser playground.
// The CLI imports the same parser, program, solver, and term primitives from here.
export { Program, makeProgram } from './program.js';
export { parseClauses, parseGoalText, parseProgramText } from './parser.js';
export { Solver } from './solver.js';
export * from './term.js';
export {
  BuiltinRegistry,
  createDefaultRegistry,
  createStrictIsoRegistry,
  getDefaultRegistry,
  getStrictIsoRegistry,
  HaltSignal,
  PrologError,
} from './iso.js';
export {
  createEyePrologRegistry,
  getEyePrologRegistry,
  standardLibrarySources,
  eyePrologLibraryIndicators,
  eyePrologNativeLibraryIndicators,
  eyePrologPortableLibraryIndicators,
  eyePrologInteropAutoload,
  eyePrologLibraryAutoload,
  eyePrologAmbiguousLibraryAutoload,
  eyePrologLibraryAutoloadModules,
  eyePrologInteropLibraryIndicators,
  eyePrologInteropLibraryModules,
} from './standard-library.js';
export { StreamManager } from './io.js';
export { formatQuadTerm, runQuads } from './quads.js';
export { executeForwardRules, hasForwardRules } from './execute.js';
export { formatFact, proofBlocks, resultWriteOptions } from './result-format.js';

import { installCleanupLifecycle } from './cleanup.js';
import { Program, autoloadProgramGoals } from './program.js';
import { Solver } from './solver.js';
import { flattenProof, proofNodeFor } from './explain.js';
import { getStrictIsoRegistry } from './iso.js';
import { getEyePrologRegistry } from './standard-library.js';
import { executeForwardRules, executeGoals, hasForwardRules, normalizeGoals } from './execute.js';
import { proofBlocks } from './result-format.js';

// The public API is an entry point above the solver/registry layers, so it can
// install pruning-aware iterator disposal without introducing an import cycle.
installCleanupLifecycle(Solver);

export function run(source, options = {}) {
  const includeWhy = options.proof === true || options.why === true || options.explain === true;
  const requestedStrictIso = options.isoStrict === true;
  if (source instanceof Program && requestedStrictIso && source.strictIso !== true) {
    throw new Error('strict ISO mode requires a Program parsed with isoStrict: true');
  }
  const requestedGoals = options.goals ?? (options.goal == null ? [] : [options.goal]);
  const parseOptions = {
    ...options,
    sourceMetadata: includeWhy || requestedStrictIso,
    autoloadGoals: requestedGoals,
  };
  let program = source instanceof Program ? source : Program.parse(source, parseOptions);
  if (source instanceof Program) autoloadProgramGoals(program, requestedGoals, options);
  const strictIso = requestedStrictIso || program.strictIso === true;
  const runOptions = strictIso
    ? { ...options, isoStrict: true, registry: getStrictIsoRegistry() }
    : options.registry ? options : { ...options, registry: getEyePrologRegistry() };
  const output = [];
  const solver = new Solver(program, {
    ...runOptions,
    ioOptions: {
      ...(options.ioOptions ?? {}),
      write: (text) => {
        const rendered = String(text);
        output.push(rendered);
        options.ioOptions?.write?.(rendered);
      },
    },
  });
  program = solver.program;
  let haltCode = null;
  if (requestedGoals.length === 0 && !strictIso && hasForwardRules(program)) {
    const derived = [];
    ({ haltCode } = executeForwardRules(program, solver, {
      onAnswer: (line, resolved) => {
        output.push(line);
        derived.push(resolved);
      },
      onFuse: (line) => output.push(line),
      onDiagnostic: (line) => {
        options.ioOptions?.errorWrite?.(line);
      },
    }));
    if (includeWhy) output.push(proofBlocksFor(program, derived, runOptions.registry, options.proofDetail));
  } else {
    // A bare `?- Goal.` asks its question the same way a `%% ?-` comment
    // does; only the parser can find it, so it is picked up here.
    const declared = requestedGoals.length === 0 ? program.queries.map((query) => query.goal) : requestedGoals;
    const goals = normalizeGoals(declared, solver);
    const claimed = [];
    ({ haltCode } = executeGoals(program, solver, goals, {
      onAnswer: (line, resolved) => {
        output.push(line);
        claimed.push(resolved);
      },
    }));
    if (includeWhy) output.push(proofBlocksFor(program, claimed, runOptions.registry, options.proofDetail));
  }
  return { stdout: output.join(''), stats: solver.stats, haltCode };
}

// The `clause/3` and `step/4` blocks explaining the facts a run claimed.
// One walk across every claim, so a conclusion several of them rest on is
// explained once.
function proofBlocksFor(program, claimed, registry, proofDetail = 'abstract') {
  const roots = claimed.map((fact) => proofNodeFor(program, fact, { registry, proofDetail })).filter(Boolean);
  const { clauses, steps } = flattenProof(roots, program);
  return proofBlocks(program, clauses, steps);
}

export * from './explain.js';
