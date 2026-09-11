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

import { installCleanupLifecycle } from './cleanup.js';
import { Program, autoloadProgramGoals } from './program.js';
import { Solver } from './solver.js';
import { whyNoProof, whyProof } from './explain.js';
import { getStrictIsoRegistry } from './iso.js';
import { getEyePrologRegistry } from './standard-library.js';
import { executeForwardRules, executeGoals, hasForwardRules, normalizeGoals } from './execute.js';

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
    ({ haltCode } = executeForwardRules(program, solver, {
      onAnswer: (line, resolved) => {
        output.push(line);
        if (includeWhy) appendExplanation(output, program, resolved, runOptions.registry, options.proofDetail);
      },
      onFuse: (line) => output.push(line),
      onDiagnostic: (line) => {
        options.ioOptions?.errorWrite?.(line);
      },
    }));
  } else {
    const goals = normalizeGoals(requestedGoals, solver);
    ({ haltCode } = executeGoals(program, solver, goals, {
      onAnswer: (line, resolved) => {
        output.push(line);
        if (includeWhy) appendExplanation(output, program, resolved, runOptions.registry, options.proofDetail);
      },
    }));
  }
  return { stdout: output.join(''), stats: solver.stats, haltCode };
}

function appendExplanation(output, program, resolved, registry, proofDetail = 'abstract') {
  const proof = whyProof(program, resolved, { registry, proofDetail });
  output.push(proof.text);
  if (!proof.ok) output.push(whyNoProof(resolved));
}

export * from './explain.js';
