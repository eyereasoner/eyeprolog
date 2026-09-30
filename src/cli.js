// Command-line interface for EyeProlog.
// It loads programs from files, URLs, or stdin, then runs requested goals.
import fs from 'node:fs/promises';
import path from 'node:path';
import process from 'node:process';
import { goalsFromSource } from './goal-metadata.js';
import { memoryStatistics } from './platform.js';

let engineModule = null;
let explanationModule = null;

// The usage text documents the input file as optional, and `--goal` is
// meaningful on its own.  Only fall back to stdin when it is actually
// redirected: on an interactive terminal there is nothing to read, and
// blocking on it makes `eyeprolog --goal G` look like it does nothing.
// An explicit `-` argument still selects stdin in either case.
export function defaultsToStdin(fileCount, stdinIsTty) {
  return fileCount === 0 && !stdinIsTty;
}

// Flags that only set a field. Each short alias is listed with its long
// spelling so the combined short form (-pqs) below stays derived from this one
// table rather than from a second hand-maintained list of letters.
const BOOLEAN_OPTIONS = new Map([
  ['--help', 'help'], ['-h', 'help'],
  ['--proof', 'proof'], ['-p', 'proof'],
  ['--quads', 'quads'], ['-q', 'quads'],
  ['--quiet', 'quiet'],
  ['--stats', 'stats'], ['-s', 'stats'],
  ['--iso-strict', 'isoStrict'],
  ['--portable', 'portable'],
  ['--version', 'version'], ['-v', 'version'],
  ['--warnings', 'warnings'], ['-w', 'warnings'],
]);

const SHORT_BOOLEAN_FLAGS = new Map(
  [...BOOLEAN_OPTIONS]
    .filter(([spelling]) => !spelling.startsWith('--'))
    .map(([spelling, field]) => [spelling.slice(1), field]),
);

// Options that consume the following argument. Each reads one argv element and
// reports its own missing-value error.
const VALUE_OPTIONS = new Map([
  ['--proof-detail', (options, value) => {
    if (value !== 'abstract' && value !== 'expanded') throw new Error('--proof-detail requires abstract or expanded');
    options.proof = true;
    options.proofDetail = value;
  }],
  ['--check-proof', (options, value) => {
    if (value == null) throw new Error('--check-proof requires a file');
    options.checkProof = value;
  }],
  ['--goal', (options, value, arg) => {
    if (value == null) throw new Error(`option ${arg} requires a goal`);
    options.goals.push(value);
  }],
]);
VALUE_OPTIONS.set('-g', VALUE_OPTIONS.get('--goal'));

export function parseOptions(argv) {
  const options = {
    files: [],
    help: false,
    proof: false,
    proofDetail: 'abstract',
    checkProof: null,
    quads: false,
    quiet: false,
    stats: false,
    isoStrict: false,
    portable: false,
    autoload: true,
    version: false,
    warnings: false,
    goals: [],
  };

  let endOptions = false;

  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];

    // A bare '-' names stdin rather than an option, and everything after '--'
    // is a file even when it looks like one.
    if (endOptions || arg === '-' || !arg.startsWith('-')) {
      options.files.push(arg);
      continue;
    }
    if (arg === '--') {
      endOptions = true;
      continue;
    }

    const field = BOOLEAN_OPTIONS.get(arg);
    if (field != null) {
      options[field] = true;
      // Usage is answered before any later argument is examined, so
      // `--help --goal` prints usage instead of reporting a missing goal.
      if (field === 'help') return options;
      continue;
    }

    const takeValue = VALUE_OPTIONS.get(arg);
    if (takeValue != null) {
      takeValue(options, argv[++i], arg);
      continue;
    }

    if (arg === '--no-autoload') {
      options.autoload = false;
      continue;
    }

    // A single-dash run of short boolean flags, such as -pqs.  Every letter is
    // validated before any of them is applied.
    if (!arg.startsWith('--') && arg.length > 2) {
      const flags = arg.slice(1);
      for (const flag of flags) {
        if (!SHORT_BOOLEAN_FLAGS.has(flag)) throw new Error(`unknown option: ${arg}`);
      }
      for (const flag of flags) options[SHORT_BOOLEAN_FLAGS.get(flag)] = true;
      if (options.help) return options;
      continue;
    }

    throw new Error(`unknown option: ${arg}`);
  }

  return options;
}

async function startRepl(options = {}) {
  const engine = await loadEngine();
  const { runRepl } = await import('./repl.js');
  const exitCode = await runRepl(engine, {
    input: process.stdin,
    output: process.stdout,
    errorOutput: process.stderr,
    ...options,
  });
  if (exitCode !== 0) process.exitCode = exitCode;
}

export async function main(argv) {
  if (argv.length === 0) {
    await startRepl();
    return;
  }

  const options = parseOptions(argv);
  if (options.help) {
    await usage(process.stdout);
    return;
  }

  if (options.version) {
    process.stdout.write(`eyeprolog ${await packageVersion()}\n`);
    return;
  }

  if (options.isoStrict && options.quads) {
    throw new Error('--iso-strict cannot be combined with --quads');
  }
  if (options.checkProof != null && options.quads) {
    throw new Error('--check-proof cannot be combined with --quads');
  }
  if (options.checkProof != null && options.proof) {
    throw new Error('--check-proof cannot be combined with --proof or --proof-detail');
  }
  if (options.checkProof != null && options.goals.length > 0) {
    throw new Error('--check-proof cannot be combined with --goal');
  }

  if (options.isoStrict && options.files.length === 0 && options.goals.length === 0 &&
      options.checkProof == null && !options.proof && !options.quiet && !options.stats && !options.warnings) {
    await startRepl({ isoStrict: true });
    return;
  }

  // `--check-proof -` reads the proof document from standard input, which is
  // what makes `eyeprolog --proof p.pl | eyeprolog --check-proof - p.pl` work:
  // the proof arrives on the pipe and the program is named on the command
  // line. Stdin is then already spoken for, so it can neither be defaulted
  // into the file list nor named again as `-`.
  const proofOnStdin = options.checkProof === '-';
  let proofText = null;
  if (proofOnStdin) {
    if (options.files.length === 0) {
      throw new Error("--check-proof - reads the proof from stdin, so the program must be named as a file");
    }
    proofText = await readStdin();
  }

  if (!proofOnStdin && defaultsToStdin(options.files.length, process.stdin.isTTY)) {
    options.files.push('-');
  }

  const sourceParts = [];
  let usedStdin = proofOnStdin;

  for (const file of options.files) {
    if (file === '-') {
      if (usedStdin) {
        throw new Error(proofOnStdin
          ? "stdin is already read as the proof document by --check-proof -"
          : "stdin input '-' can only be used once");
      }
      usedStdin = true;
      sourceParts.push({ text: await readStdin(), filename: '<stdin>' });
    } else if (/^https?:\/\//.test(file)) {
      const response = await fetch(file);
      if (!response.ok) throw new Error(`could not fetch URL: ${file}`);
      sourceParts.push({ text: await response.text(), filename: file });
    } else {
      sourceParts.push({
        text: await fs.readFile(file, 'utf8'),
        filename: path.basename(file) || file,
        baseDir: path.dirname(path.resolve(file)),
      });
    }
  }

  if (sourceParts.length === 0) {
    // No file and no redirected stdin: run the requested goals against an
    // empty database rather than against nothing at all.
    sourceParts.push({ text: '', filename: '<empty>' });
  }

  if (options.goals.length === 0 && !options.quads && options.checkProof == null) {
    for (const source of sourceParts) options.goals.push(...goalsFromSource(source.text));
  }

  // The ISO Prolog working-example quad files assume the Prologue predicates
  // are available as system predicates and therefore contain no use_module/1
  // directive. Import their portable EyeProlog counterparts in quad mode.
  if (options.quads) {
    sourceParts.unshift({
      text: ':- use_module(library(prologue)).\n',
      filename: '<quad-prelude>',
    });
  }

  const engine = await loadEngine();
  let program = engine.Program.parseSources(sourceParts, {
    sourceMetadata: options.proof || options.checkProof != null || options.isoStrict,
    isoStrict: options.isoStrict,
    autoload: options.autoload,
    autoloadGoals: options.goals,
    onWarning: printSourceWarning,
  });

  // A bare `?- Goal.` asks its question the same way a `%% ?-` comment
  // does, but only the parser can find it, so it is picked up here rather
  // than from the source text.
  if (options.goals.length === 0 && !options.quads && options.checkProof == null && program.queries.length > 0) {
    options.goals.push(...program.queries.map((query) => query.goal));
    program = engine.autoloadProgramGoals(program, options.goals, { autoload: options.autoload });
  }

  const portabilityFailures = program.interopPortabilityWarnings ?? [];
  // Shadowing is reported unconditionally: silently replacing a library
  // predicate for the whole program is the failure mode this diagnostic exists
  // to surface, so it must not depend on opting in to --warnings.
  printLibraryShadowingWarnings(program);
  if (options.warnings || (options.portable && portabilityFailures.length > 0)) printWarnings(program);
  if (options.portable && portabilityFailures.length > 0) {
    process.exitCode = 1;
    return;
  }

  if (options.checkProof != null) {
    const { checkProofDocument, checkReportTerms, verdictTermText } = await import('./check-proof.js');
    const text = proofText ?? await fs.readFile(options.checkProof, 'utf8');
    const report = checkProofDocument(program, text);
    if (report.steps === 0) throw new Error(`no step/4 proof step found in ${options.checkProof}`);
    // The check document goes to stdout whether or not the proof holds: a
    // failing check is a result to be read and reasoned over, not the absence
    // of one. The exit status and the stderr line carry the verdict to a shell.
    if (!options.quiet) process.stdout.write(checkReportTerms(report));
    if (!report.valid) {
      const source = proofOnStdin ? 'the proof read from stdin' : options.checkProof;
      throw new Error(`${source} is not a valid proof for this program: ${report.failures.length} failure(s)`);
    }
    if (options.quiet) process.stdout.write(verdictTermText(report));
    return;
  }

  if (!options.quads || options.goals.length > 0) {
    if (options.goals.length === 0 && !options.isoStrict && engine.hasForwardRules(program)) {
      await runForwardDefault(engine, program, options);
    } else {
      await runDefault(engine, program, options);
    }
  }
  if (options.quads) {
    const result = engine.runQuads(program, { initialize: options.goals.length === 0 });
    process.stdout.write(result.stdout);
    if (result.failed > 0) process.exitCode = 1;
    else if (result.undecided > 0) process.exitCode = 2;
  }
}

async function loadEngine() {
  if (engineModule == null) {
    const [term, parser, program, solver, iso, library, write, quads, execute, resultFormat, cleanup] = await Promise.all([
      import('./term.js'),
      import('./parser.js'),
      import('./program.js'),
      import('./solver.js'),
      import('./iso.js'),
      import('./standard-library.js'),
      import('./write.js'),
      import('./quads.js'),
      import('./execute.js'),
      import('./result-format.js'),
      import('./cleanup.js'),
    ]);
    // CLI loading is an entry-point layer above solver.js and the standard
    // registry, so lifecycle installation stays acyclic.
    cleanup.installCleanupLifecycle(solver.Solver);
    engineModule = { ...term, ...parser, ...program, ...solver, ...iso, ...library, ...write, ...quads, ...execute, ...resultFormat };
  }
  return engineModule;
}

async function loadExplanation() {
  if (explanationModule == null) explanationModule = await import('./explain.js');
  return explanationModule;
}

async function runForwardDefault(engine, program, options) {
  const registry = engine.getEyePrologRegistry();
  const solver = new engine.Solver(program, {
    registry,
    ioOptions: {
      write: (text) => process.stdout.write(String(text)),
      errorWrite: (text) => process.stderr.write(String(text)),
    },
  });
  try {
    const result = engine.executeForwardRules(program, solver, {
      onAnswer: (line) => { if (!options.quiet) process.stdout.write(line); },
      onFuse: (line) => { if (!options.quiet) process.stdout.write(line); },
      onDiagnostic: (line) => process.stderr.write(line),
    });
    if (result.haltCode != null) process.exitCode = result.haltCode;
  } finally {
    if (options.stats) printStats(solver.stats);
  }
}

async function runDefault(engine, program, options) {
  const registry = options.isoStrict ? engine.getStrictIsoRegistry() : engine.getEyePrologRegistry();
  const solver = new engine.Solver(program, {
    registry,
    isoStrict: options.isoStrict,
    ioOptions: {
      write: (text) => process.stdout.write(String(text)),
      errorWrite: (text) => process.stderr.write(String(text)),
    },
  });
  program = solver.program;
  const goals = engine.normalizeGoals(options.goals, solver);
  try {
    // A run states what it concluded and then why: the claims stream as
    // they are found, and the blocks explaining them follow at the end.
    const claimed = [];
    const { haltCode } = engine.executeGoals(program, solver, goals, {
      onAnswer: (line, resolved) => {
        if (!options.quiet) process.stdout.write(line);
        claimed.push(resolved);
      },
    });
    if (options.proof && !options.quiet) {
      const explanation = await loadExplanation();
      const detail = options?.proofDetail ?? 'abstract';
      const roots = [];
      const unexplained = [];
      for (const fact of claimed) {
        const node = explanation.proofNodeFor(program, fact, { registry, proofDetail: detail, solver });
        if (node) roots.push(node);
        else unexplained.push(fact);
      }
      const { clauses, steps } = explanation.flattenProof(roots, program);
      // An answer the explanation replay cannot reproduce is recorded as
      // `unproven` rather than left without a step: a document containing
      // one is not a valid proof, and saying so is the point.
      const concluded = new Set(steps.map((step) => engine.termToString(step.conclusion, new engine.Env(), true)));
      for (const fact of unexplained) {
        if (concluded.has(engine.termToString(fact, new engine.Env(), true))) continue;
        steps.push({ conclusion: fact, by: engine.atom('unproven'), bindings: [], uses: [] });
      }
      process.stdout.write(engine.proofBlocks(program, clauses, steps));
    }
    if (haltCode != null) process.exitCode = haltCode;
  } finally {
    if (options.stats) printStats(solver.stats);
  }
}

async function usage(stream) {
  stream.write(`eyeprolog ${await packageVersion()}

Usage:
  eyeprolog
  eyeprolog [options] [file-or-url.pl|- ...]

Interactive:
  With no arguments, start a Prolog REPL. Use eyeprolog -h for help.

Input:
  file-or-url.pl        Read an EyeProlog program from a local file or http(s) URL.
  -                     Read an EyeProlog program from standard input.

Options:
  -h, --help            Show this help text and exit.
  -p, --proof           Enable proof explanations.
  --proof-detail mode   abstract stops at a bundled library predicate and records
                        it as one builtin step; expanded explains through it,
                        as ordinary source steps. Only differs for a program
                        that calls a library. (implies --proof)
  --check-proof file    Check a saved proof document against the input program
                        and write the result as Prolog facts: condition/4 per
                        condition, failure/3, obligation/3, and verdict/1.
                        Use - to read the proof from stdin, for example
                        eyeprolog --proof p.pl | eyeprolog --check-proof - p.pl
  -q, --quads           Run embedded quad tests and fail if any do not hold.
                        Note: -q is quads, not quiet; --quiet has no short form.
  --quiet               Suppress answer terms while preserving Prolog output.
  -s, --stats           Print solver and memory statistics to stderr after execution.
  --iso-strict          Use ISO/IEC 13211-1 core + Corrigenda 1-3 only;
                        reject EyeProlog language extensions.
  --portable            Enforce the EyeProlog/Trealla/Scryer interop profile.
  --no-autoload         Disable bundled library predicate autoloading.
  -v, --version         Show the package version and exit.
  -w, --warnings        Print non-fatal portability warnings to stderr.
  -g, --goal goal       Solve goal and print its ground answers; may be repeated.
                        If omitted, use ?- queries and %% ?- comments.
  --                    Stop option parsing; following arguments are treated as files.
`);
}

function readStdin() {
  return new Promise((resolve, reject) => {
    let data = '';
    process.stdin.setEncoding('utf8');
    process.stdin.on('data', (chunk) => {
      data += chunk;
    });
    process.stdin.on('end', () => resolve(data));
    process.stdin.on('error', reject);
  });
}


function printSourceWarning(warning) {
  if (warning.kind !== 'singleton') return;
  process.stderr.write(`Warning: singleton: ${warning.name}, near ${warning.filename}:${warning.line}
`);
}

function printLibraryShadowingWarnings(program) {
  for (const warning of program.libraryShadowingWarnings ?? []) {
    process.stderr.write('eyeprolog warning: user definition shadows a bundled library predicate\n');
    process.stderr.write(`  ${warning.indicator} replaces library(${warning.library}) ${warning.indicator} for all user code in this program\n`);
    process.stderr.write(`  import it explicitly with :- use_module(library(${warning.library}), [${warning.indicator}]). to make this an error\n`);
  }
}

function printWarnings(program) {
  for (const warning of program.interopPortabilityWarnings ?? []) {
    if (warning.kind === 'library') {
      process.stderr.write('eyeprolog warning: non-portable library dependency\n');
      process.stderr.write(`  library(${warning.library}) is outside the EyeProlog/Trealla/Scryer interop profile\n`);
    } else if (warning.kind === 'predicate') {
      process.stderr.write('eyeprolog warning: non-portable library predicate\n');
      process.stderr.write(`  ${warning.indicator} from library(${warning.library}) is outside the interop profile\n`);
    }
  }

  const errors = program.negationStratificationErrors;
  if (errors.length === 0) return;

  process.stderr.write('eyeprolog warning: unstratified negation\n');
  for (const edge of errors) {
    process.stderr.write(`  ${edge.from} depends negatively on ${edge.to}\n`);
  }
}

function printStats(stats) {
  process.stderr.write('eyeprolog stats:\n');
  for (const [key, value] of Object.entries({ ...stats, ...memoryStatistics() })) {
    process.stderr.write(`  ${key}: ${value}\n`);
  }
}

async function packageVersion() {
  try {
    const text = await fs.readFile(new URL('../package.json', import.meta.url), 'utf8');
    const pkg = JSON.parse(text);
    if (pkg && typeof pkg.version === 'string' && pkg.version) return pkg.version;
  } catch (_) {
    // Fall through to a stable marker if package metadata is unavailable.
  }

  return 'unknown';
}
