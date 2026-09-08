// Interactive top level for the eyeprolog command.
import fs from 'node:fs/promises';
import { readSync } from 'node:fs';
import path from 'node:path';
import { createInterface } from 'node:readline';
import { formalErrorTerm } from './iso.js';
import { autoloadProgramGoals } from './program.js';
import {
  characterCodeConstantEnd, continuesGraphicToken, isTerminatingFullStop, quotedEscapeEnd,
} from './syntax-scan.js';

const ANSWER_HELP = `
SPACE, "n" or ";": next solution, if any
RETURN or ".": stop enumeration
"a": enumerate all solutions
"f": enumerate through the next group of 5 solutions
"h": display this help message
"w": write terms without depth limit
"p": print terms with depth limit
`;

const SCRIPTED_NEXT_QUERY = Symbol('scripted-next-query');

export async function runRepl(engine, options = {}) {
  const input = options.input ?? process.stdin;
  const output = options.output ?? process.stdout;
  const errorOutput = options.errorOutput ?? process.stderr;
  const reader = new LineReader(input, output);
  const sources = [];
  let state = makeState(engine, sources, output, options, null, reader);
  let exitCode = 0;

  try {
    runWithTerminalSignals(reader, () => state.solver.runInitializations());
    while (true) {
      const text = await readQuery(reader);
      if (text == null) break;
      if (!text.trim()) continue;

      let resultIndent = '   ';
      try {
        const goal = parseGoal(engine, state, text);
        // A complete, successfully parsed query has left the top-level reader
        // and is about to execute. Show two spaces immediately so a terminal
        // user can distinguish that state from a reader waiting for more text;
        // the final result adds the third indentation space below. A direct
        // halt has no result and exits immediately, so it needs no marker.
        if (!isHaltGoal(goal)) {
          output.write('  ');
          resultIndent = ' ';
        }
        if (!options.isoStrict && isUseModuleGoal(goal)) {
          sources.push({ text: `:- ${text}.\n`, filename: '<repl>' });
          state = makeState(engine, sources, output, options, state, reader);
          runWithTerminalSignals(reader, () => state.solver.runInitializations());
          output.write(' true.\n');
          continue;
        }
        const consultFiles = options.isoStrict ? null : consultDesignations(engine, goal);
        if (consultFiles != null) {
          for (const filename of consultFiles) {
            const source = filename === 'user'
              ? await readUserSource(reader, state.solver)
              : await readSource(filename);
            replaceConsultedSource(sources, source);
          }
          state = makeState(engine, sources, output, options, state, reader);
          runWithTerminalSignals(reader, () => state.solver.runInitializations());
          output.write(' true.\n');
          continue;
        }

        // Queries entered after the initial Program was prepared need the same
        // bundled-library autoload resolution as file and -g execution.  This
        // is intentionally after parsing: predicate autoloading cannot provide
        // syntax operators retroactively (libraries such as clpz must still be
        // imported explicitly before their operators are used).
        if (!state.strictIso && options.autoload !== false) {
          autoloadProgramGoals(state.program, [goal], {
            autoload: true,
            doubleQuotes: state.solver.prologFlags.get('double_quotes')?.value?.name ?? 'chars',
          });
          runWithTerminalSignals(reader, () => state.solver.runInitializations());
        }

        const flagsBefore = snapshotFlagValues(state.solver);
        try {
          await prepareInteractiveTermInput(state, goal, reader);
          const result = await solveQuery(engine, state, goal, reader, output);
          if (result?.halted) {
            exitCode = result.code;
            break;
          }
        } finally {
          rememberFlagOverrides(state, flagsBefore);
        }
      } catch (error) {
        if (error?.name === 'HaltSignal') {
          exitCode = error.code;
          break;
        }
        output.write(`${resultIndent}${formatError(engine, state, error)}\n`);
      }
    }
  } catch (error) {
    errorOutput.write(`eyeprolog: ${error?.message ?? String(error)}\n`);
    exitCode = 1;
  } finally {
    reader.close();
  }

  return exitCode;
}

class LineReader {
  static syncWait = new Int32Array(new SharedArrayBuffer(4));

  constructor(input, output) {
    this.input = input;
    this.output = output;
    this.terminal = Boolean(input.isTTY && output.isTTY && typeof input.setRawMode === 'function');
    this.history = [];
    this.pendingLines = [];
    this.currentPrompt = '?- ';
    this.open();
  }

  open() {
    this.readline = createInterface({
      input: this.input,
      output: this.output,
      terminal: Boolean(this.input.isTTY && this.output.isTTY),
      prompt: this.currentPrompt,
    });
    if (this.terminal && this.history.length > 0) {
      this.readline.history.push(...this.history);
    }
    this.lines = this.readline[Symbol.asyncIterator]();
  }

  async nextLine() {
    if (this.pendingLines.length > 0) return { done: false, value: this.pendingLines.shift() };
    return this.lines.next();
  }

  async read(prompt) {
    this.currentPrompt = prompt;
    this.readline.setPrompt(prompt);
    this.output.write(prompt);
    const result = await this.nextLine();
    return result.done ? null : result.value;
  }

  async readControl(prompt) {
    if (!this.terminal) {
      const result = await this.nextLine();
      if (result.done) return null;
      if (!isScriptedAnswerControl(result.value)) {
        this.pendingLines.unshift(result.value);
        return SCRIPTED_NEXT_QUERY;
      }
      this.output.write(prompt);
      return result.value;
    }
    this.output.write(prompt);
    this.history = [...this.readline.history];
    this.currentPrompt = '?- ';
    this.readline.close();
    this.readline = null;
    this.lines = null;
    this.input.setRawMode(true);
    this.input.resume();

    const control = await new Promise((resolve, reject) => {
      const cleanup = () => {
        this.input.off('data', onData);
        this.input.off('error', onError);
      };
      const onData = (data) => {
        cleanup();
        const text = String(data);
        resolve(text === '\x04' ? null : text[0] ?? null);
      };
      const onError = (error) => {
        cleanup();
        reject(error);
      };
      this.input.once('data', onData);
      this.input.once('error', onError);
    });

    this.input.setRawMode(false);
    this.open();
    return control;
  }

  canReadTermSynchronously() {
    return this.terminal && Number.isInteger(this.input.fd);
  }

  readInteractiveTermSync(solver = null) {
    if (!this.canReadTermSynchronously()) return null;
    let source = '';
    let prompt = '|: ';
    while (true) {
      this.output.write(prompt);
      const line = this.readTerminalLineSync();
      if (line == null) return source.trim() ? source : null;
      source += `${line}\n`;
      const end = terminalFullStop(source, solver);
      if (end >= 0) {
        return source.slice(0, end + 1) + '\n';
      }
      prompt = '|    ';
    }
  }

  readInteractiveUnitSync() {
    if (!this.canReadTermSynchronously()) return null;
    this.output.write('|: ');
    const line = this.readTerminalLineSync();
    if (line == null) return null;
    // The interactive line editor uses Enter to submit character input.  Do
    // not leave that submission newline buffered for the next get_/peek_
    // call (matching SWI/Scryer top-level behaviour).  An empty submitted
    // line still represents an actual newline character.
    return line.length === 0 ? '\n' : line;
  }

  readTerminalLineSync() {
    const byte = Buffer.allocUnsafe(1);
    const bytes = [];
    while (true) {
      let count;
      try {
        count = readSync(this.input.fd, byte, 0, 1, null);
      } catch (error) {
        // Node keeps terminal fds non-blocking.  Once readline is suspended,
        // a synchronous read can therefore report EAGAIN while waiting for
        // the user. Sleep briefly and retry; terminal signals still retain
        // their native action because no readline signal handler is installed.
        if (error?.code === 'EAGAIN' || error?.code === 'EWOULDBLOCK') {
          Atomics.wait(LineReader.syncWait, 0, 0, 10);
          continue;
        }
        throw error;
      }
      // In canonical terminal mode Ctrl-D on an empty line makes read(2)
      // return zero bytes.  Scope that EOF to the current Prolog read rather
      // than closing the outer readline iterator / top-level loop.
      if (count === 0) {
        return bytes.length === 0 ? null : Buffer.from(bytes).toString('utf8');
      }
      if (byte[0] === 10) {
        if (bytes.at(-1) === 13) bytes.pop();
        return Buffer.from(bytes).toString('utf8');
      }
      bytes.push(byte[0]);
    }
  }

  suspendForComputation() {
    if (!this.terminal || !this.readline) return false;
    // Node readline installs terminal signal handling while the interface is
    // open. During a synchronous Prolog search that prevents the terminal's
    // normal SIGINT/SIGTSTP actions from taking effect until JavaScript yields.
    // Close readline while the solver is running so Ctrl-C can terminate and
    // Ctrl-Z can suspend an otherwise non-terminating computation immediately.
    this.history = [...this.readline.history];
    this.readline.close();
    this.readline = null;
    this.lines = null;
    return true;
  }

  resumeAfterComputation(suspended) {
    if (suspended && !this.readline) this.open();
  }

  close() {
    if (this.input.isRaw) this.input.setRawMode(false);
    this.readline?.close();
  }
}

function isScriptedAnswerControl(line) {
  if (line == null || line === '' || line === '\r' || line === '\n' || line === ' ') return true;
  const control = line.trim();
  return control.startsWith('.') || [';', 'n', 'a', 'f', 'w', 'p', 'h'].includes(control);
}

function runWithTerminalSignals(reader, operation) {
  const suspended = reader.suspendForComputation();
  try {
    return operation();
  } finally {
    reader.resumeAfterComputation(suspended);
  }
}

function makeState(engine, sources, output, options = {}, previousState = null, reader = null) {
  const strictIso = options.isoStrict === true;
  const program = engine.Program.parseSources(sources, {
    isoStrict: strictIso,
    sourceMetadata: strictIso,
    autoload: !strictIso && options.autoload !== false,
  });
  const solver = new engine.Solver(program, {
    registry: strictIso ? engine.getStrictIsoRegistry() : engine.getEyePrologRegistry(),
    isoStrict: strictIso,
    ioOptions: { write: (text) => output.write(String(text)) },
  });
  const userInput = solver.io.resolve('user_input');
  if (userInput && reader?.canReadTermSynchronously()) {
    // The solver is synchronous. While pullSolution() has readline suspended,
    // let ISO input request terminal data exactly when read/1-2, read_term/2-3,
    // or a character/code input predicate actually executes. This also works
    // inside conjunctions and user predicates instead of only when an input
    // predicate is the whole REPL goal.
    userInput.interactiveReadTerm = () => reader.readInteractiveTermSync(solver);
    userInput.interactiveReadUnit = () => reader.readInteractiveUnitSync();
  }
  const flagOverrides = new Map(previousState?.flagOverrides ?? []);
  for (const [name, value] of flagOverrides) {
    const definition = solver.prologFlags.get(name);
    if (definition?.changeable && definition.allowed.includes(value)) {
      definition.value = engine.atom(value);
    }
  }
  return { program: solver.program, solver, strictIso, flagOverrides };
}

function snapshotFlagValues(solver) {
  return new Map([...solver.prologFlags].map(([name, definition]) => [name, definition.value?.name]));
}

function rememberFlagOverrides(state, before) {
  for (const [name, definition] of state.solver.prologFlags) {
    const value = definition.value?.name;
    if (before.get(name) !== value) state.flagOverrides.set(name, value);
  }
}

async function readQuery(reader) {
  let source = '';
  let prompt = '?- ';
  while (true) {
    const line = await reader.read(prompt);
    if (line == null) return source.trim() ? source : null;
    source += `${line}\n`;
    const end = terminalFullStop(source);
    if (end >= 0) return source.slice(0, end);
    prompt = '|    ';
  }
}

async function prepareInteractiveTermInput(state, goal, reader) {
  // Real terminals are serviced on demand from readTermFromStream() while the
  // synchronous solver is running.  Keep the older async preloader only as a
  // fallback for piped/non-TTY REPL tests and scripted input.
  if (reader.canReadTermSynchronously()) return;
  const stream = interactiveTermInputStream(state, goal);
  if (stream == null || terminalFullStop(String(stream.content).slice(stream.position), state.solver) >= 0) return;

  const text = await readInteractiveTerm(reader, state.solver);
  if (text == null) return;
  stream.content += text;
  stream.pastEnd = false;
}

function interactiveTermInputStream(state, goal) {
  if (goal.type !== 'compound') return null;
  let reference = null;
  if (goal.name === 'read' && goal.arity === 1) {
    reference = state.solver.io.currentInput;
  } else if (goal.name === 'read' && goal.arity === 2) {
    reference = explicitInputReference(goal.args[0]);
  } else if (goal.name === 'read_term' && goal.arity === 2) {
    reference = state.solver.io.currentInput;
  } else if (goal.name === 'read_term' && goal.arity === 3) {
    reference = explicitInputReference(goal.args[0]);
  } else {
    return null;
  }

  const stream = reference == null ? null : state.solver.io.resolve(reference);
  return stream?.standard && stream.alias === 'user_input' && stream.mode === 'read' ? stream : null;
}

function explicitInputReference(term) {
  if (term.type === 'atom') return term.name;
  if (term.type === 'compound' && term.name === '$stream' && term.arity === 1 &&
      term.args[0].type === 'number' && /^\d+$/.test(term.args[0].name)) {
    return Number(term.args[0].name);
  }
  return null;
}

async function readInteractiveTerm(reader, solver = null) {
  let source = '';
  let prompt = '|: ';
  while (true) {
    const line = await reader.read(prompt);
    if (line == null) return source.trim() ? source : null;
    source += `${line}\n`;
    const end = terminalFullStop(source, solver);
    if (end >= 0) {
      return source.slice(0, end + 1) + '\n';
    }
    prompt = '|    ';
  }
}

function activeCharConverter(solver) {
  if (solver?.prologFlags.get('char_conversion')?.value?.name !== 'on' || solver.charConversions.size === 0) {
    return null;
  }
  return (character) => solver.charConversions.get(character) ?? character;
}

function terminalFullStop(source, solver = null) {
  const convert = activeCharConverter(solver);
  let quote = null;
  let lineComment = false;
  let blockComment = false;

  for (let i = 0; i < source.length; i++) {
    const ch = source[i];
    const next = source[i + 1];
    if (lineComment) {
      if (ch === '\n') lineComment = false;
      continue;
    }
    if (blockComment) {
      if (ch === '*' && next === '/') {
        blockComment = false;
        i++;
      }
      continue;
    }
    if (quote != null) {
      if (ch === '\\') {
        i = quotedEscapeEnd(source, i);
      } else if (ch === '\n' || ch === '\r') {
        // A literal newline can never be repaired by a later line: ISO
        // 6.4.2.1 excludes it from quoted characters. Return this boundary
        // immediately so the parser reports a syntax error instead of the
        // top level prompting forever for a closing quote.
        return i;
      } else if (ch === quote) {
        if (next === quote) i++;
        else quote = null;
      }
      continue;
    }
    const characterCodeEnd = characterCodeConstantEnd(source, i);
    if (characterCodeEnd != null) {
      i = characterCodeEnd;
      continue;
    }
    if (ch === '%') {
      lineComment = true;
      continue;
    }
    if (ch === '/' && next === '*' && !continuesGraphicToken(source, i)) {
      blockComment = true;
      i++;
      continue;
    }
    if (ch === "'" || ch === '"' || ch === '`') {
      quote = ch;
      continue;
    }
    // ISO 8.14.1.1 locates the end token lexically before read-term parsing.
    // An unmatched opening bracket therefore must not make the top level wait
    // for more input after a terminating full stop; parsing the collected text
    // is what reports the syntax error (for example `[l.` or `{.`).
    if (isTerminatingFullStop(source, i, convert) &&
        onlyLayoutAndComments(source.slice(i + 1))) return i;
  }
  return -1;
}

function onlyLayoutAndComments(source) {
  return source.replace(/\s|%[^\n]*(?:\n|$)|\/\*[\s\S]*?\*\//g, '').length === 0;
}

function parseGoal(engine, state, text) {
  const goal = engine.parseGoalText(text, {
    doubleQuotes: state.solver.prologFlags.get('double_quotes')?.value?.name ?? 'chars',
    operatorDefinitions: [...state.program.operators.values()],
    isoStrict: state.strictIso,
  });
  if (goal.type === 'var') throw new engine.PrologError('instantiation_error');
  if (goal.type !== 'atom' && goal.type !== 'compound') {
    throw new engine.PrologError('type_error(callable)', goal);
  }
  return goal;
}

function isUseModuleGoal(goal) {
  return goal.type === 'compound' && goal.name === 'use_module' && [1, 2].includes(goal.arity);
}

function isHaltGoal(goal) {
  return (goal.type === 'atom' && goal.name === 'halt') ||
    (goal.type === 'compound' && goal.name === 'halt' && goal.arity === 1);
}

function consultDesignations(engine, goal) {
  // The traditional [file]. top-level shorthand and explicit consult/1 use
  // the same resolver and modern reconsult semantics.  Accept reconsult/1 as
  // a compatibility alias as well; contemporary consult/1 already replaces
  // clauses previously loaded from the same source.
  if (goal.type === 'atom' && goal.name === '[]') return [];
  if (goal.type === 'compound' && goal.name === '.' && goal.arity === 2) {
    return consultListDesignations(engine, goal);
  }
  if (goal.type === 'compound' && ['consult', 'reconsult'].includes(goal.name) && goal.arity === 1) {
    return consultArgumentDesignations(engine, goal.args[0]);
  }
  return null;
}

function consultArgumentDesignations(engine, term) {
  if (term.type === 'var') throw new engine.PrologError('instantiation_error');
  if (term.type === 'atom') return term.name === '[]' ? [] : [term.name];
  if (term.type === 'compound' && term.name === '.' && term.arity === 2) {
    return consultListDesignations(engine, term);
  }
  throw new engine.PrologError('type_error(atom)', term);
}

function consultListDesignations(engine, list) {
  const items = engine.properListItems(list, new engine.Env());
  if (items == null) throw new engine.PrologError('type_error(list)', list);
  return items.map((item) => {
    if (item.type === 'var') throw new engine.PrologError('instantiation_error');
    if (item.type !== 'atom') throw new engine.PrologError('type_error(atom)', item);
    return item.name;
  });
}

function replaceConsultedSource(sources, source) {
  const index = sources.findIndex((existing) =>
    source.consultPath != null && existing.consultPath === source.consultPath);
  if (index >= 0) sources[index] = source;
  else sources.push(source);
}

function missingSource(error) {
  return error?.code === 'ENOENT' || error?.code === 'ENOTDIR';
}

async function resolvedConsultFilename(designation) {
  const requested = path.resolve(designation);
  // Long-standing Prolog consult convention: for an extensionless name, try
  // the .pl source first and use the unsuffixed path only as a fallback.
  if (!path.extname(requested)) {
    const prologFile = `${requested}.pl`;
    try {
      await fs.access(prologFile);
      return await fs.realpath(prologFile);
    } catch (error) {
      if (!missingSource(error)) throw error;
    }
  }
  await fs.access(requested);
  return fs.realpath(requested);
}

async function readSource(designation) {
  const filename = await resolvedConsultFilename(designation);
  return {
    text: await fs.readFile(filename, 'utf8'),
    filename: path.basename(filename),
    baseDir: path.dirname(filename),
    // Keep host-only provenance so consulting the same resolved file again
    // replaces its previous source instead of accumulating stale clauses.
    consultPath: filename,
  };
}

async function readUserSource(reader, solver) {
  let text = '';
  while (true) {
    const term = await readInteractiveTerm(reader, solver);
    if (term == null) break;
    const end = terminalFullStop(term, solver);
    const body = end < 0 ? term : term.slice(0, end);
    // `user` is the traditional interactive consult pseudo-file. Stop at an
    // unquoted end_of_file term, just as a physical input stream would. The
    // source accumulated before it is then prepared as one ordinary Prolog
    // text so directives and operator declarations retain normal file order.
    if (body.replace(/\s|%[^\n]*(?:\n|$)|\/\*[\s\S]*?\*\//g, '') === 'end_of_file') break;
    text += term;
  }
  return {
    text,
    filename: '<user>',
    baseDir: process.cwd(),
    consultPath: '<user>',
  };
}

async function solveQuery(engine, state, goal, reader, output) {
  const variables = queryVariables(goal);
  const solver = state.solver;
  solver.solutionsSeen = 0;
  const solutions = solver.solve([goal], new engine.Env(), 0);
  let current = pullSolution(solver, solutions, reader);
  if (current.error) {
    if (current.error?.name === 'HaltSignal') return { halted: true, code: current.error.code };
    throw current.error;
  }

  if (current.result.done) {
    output.write(' false.\n');
    return null;
  }

  let automatic = 0;
  let answersShown = 0;
  let firstAnswer = true;
  let formattingAfterAdvance = false;
  while (!current.result.done) {
    // Enumeration is demand-driven: never execute search for a future answer
    // merely to decide how to punctuate the current one. That search may have
    // side effects, and it belongs only to an explicit request for another
    // answer. A scripted non-TTY session may start its next query directly;
    // LineReader treats that as an implicit stop without consuming the query.
    if (formattingAfterAdvance) output.write(' ');
    formattingAfterAdvance = false;
    output.write(current.output);
    const answer = formatAnswer(engine, state, variables, current.result.value);
    output.write(`${firstAnswer ? ' ' : ''}${answer}`);
    answersShown++;
    firstAnswer = false;

    if (!solver.hasPendingAlternatives()) {
      // The solver is suspended at the yielded answer even though no work is
      // left. Close the generator to run its cleanup/finally blocks without
      // advancing search or executing future side effects.
      if (typeof solutions.return === 'function') solutions.return();
      output.write(`${continuesGraphicToken(answer, answer.length) ? ' ' : ''}.\n`);
      return null;
    }

    if (automatic > 0 || automatic === Infinity) {
      if (automatic !== Infinity) automatic--;
      output.write('\n; ');
      formattingAfterAdvance = true;
    } else {
      while (true) {
        const controlLine = await reader.readControl('\n;');
        if (controlLine === SCRIPTED_NEXT_QUERY) {
          if (typeof solutions.return === 'function') solutions.return();
          output.write(`${continuesGraphicToken(answer, answer.length) ? ' ' : ''}.\n`);
          return null;
        }
        if (controlLine == null || controlLine === '' || controlLine === '\r' || controlLine === '\n' ||
            controlLine.trimStart().startsWith('.')) {
          if (typeof solutions.return === 'function') solutions.return();
          output.write('  ... .\n');
          return null;
        }
        const control = controlLine === ' ' ? ' ' : controlLine.trimStart()[0];
        if (control === ';' || control === 'n' || control === ' ') break;
        if (control === 'a') {
          automatic = Infinity;
          break;
        }
        if (control === 'f') {
          const remainder = answersShown % 5;
          const answersToBoundary = remainder === 0 ? 5 : 5 - remainder;
          automatic = answersToBoundary - 1;
          break;
        }
        if (control === 'w' || control === 'p') {
          output.write(`  ${formatAnswer(engine, state, variables, current.result.value)}`);
          continue;
        }
        if (control === 'h') {
          output.write(ANSWER_HELP);
          continue;
        }
        output.write(' Action? ');
      }
      output.write(' ');
      formattingAfterAdvance = true;
    }

    // Drop the displayed substitution before resuming search. The next search
    // step, including any side effects, happens only after the user asked for
    // another answer (or selected automatic enumeration).
    current = null;
    const requested = pullSolution(solver, solutions, reader);
    if (requested.error) {
      if (formattingAfterAdvance) output.write(' ');
      formattingAfterAdvance = false;
      output.write(requested.output);
      if (requested.error?.name === 'HaltSignal') return { halted: true, code: requested.error.code };
      throw requested.error;
    }
    if (requested.result.done) {
      if (formattingAfterAdvance) output.write(' ');
      formattingAfterAdvance = false;
      output.write(`${requested.output}false.\n`);
      return null;
    }
    current = requested;
  }
  return null;
}

function pullSolution(solver, solutions, reader) {
  // Prolog output is an observable side effect of execution, so never hold it
  // until the search reaches its next leaf. In particular an infinite search
  // that periodically writes progress must remain observable at the terminal.
  // Completed queries keep the same byte order because user_output writes are
  // synchronous and occur before solutions.next() returns its answer.
  const suspended = reader.suspendForComputation();
  try {
    return { result: solutions.next(), output: '' };
  } catch (error) {
    return { error, output: '' };
  } finally {
    reader.resumeAfterComputation(suspended);
  }
}

function queryVariables(goal) {
  const variables = [];
  const seen = new Set();
  const stack = [goal];
  while (stack.length) {
    const term = stack.pop();
    if (term.type === 'var') {
      if (!term.name.startsWith('__anon') && !seen.has(term.name)) {
        seen.add(term.name);
        variables.push(term);
      }
    } else {
      for (let i = term.args.length - 1; i >= 0; i--) stack.push(term.args[i]);
    }
  }
  return variables;
}

function formatAnswer(engine, state, variables, env) {
  const bindings = [];
  const queryVariableNames = new Set(variables.map((variable) => variable.name));
  const names = new Map(variables.map((variable) => [variable.name, variable.name]));
  const operators = [...state.program.operators.values()];
  // Answer substitutions are displayed as `Variable = Value`.  Format Value
  // in the right-operand context of the active infix `=/2` definition so an
  // operator term such as `a = b` is parenthesized rather than producing the
  // invalid `T = a = b`.  ISO does not standardize a top level, but the term
  // syntax used by the display must still respect the current operator table.
  const equality = operators.find((definition) =>
    definition.name === '=' && ['xfx', 'xfy', 'yfx'].includes(definition.specifier));
  const valueMaxPriority = equality == null
    ? 699
    : equality.specifier === 'xfy' ? equality.priority : equality.priority - 1;
  const answerWriteOptions = {
    quoted: true,
    minimalOperatorSpacing: true,
    operators,
    variableNames: names,
    operatorAtomsAsArgs: true,
    dottedGraphicAtoms: true,
    doubleQuotes: state.solver.prologFlags.get('double_quotes')?.value?.name ?? 'chars',
    doubleBar: !state.strictIso,
  };
  let generated = 0;

  // Meta-predicate wrappers can make a query variable alias an internal fresh
  // variable. Keep residual constraints tied to the query's visible name.
  for (const variable of variables) {
    const root = engine.deref(variable, env);
    if (root.type === 'var' && !names.has(root.name)) names.set(root.name, variable.name);
  }
  for (const variable of variables) collectUnboundVariables(engine, variable, env, names, () => `_${letterName(generated++)}`);
  for (const variable of variables) {
    const value = engine.deref(variable, env);
    if (value.type === 'var' &&
        (value.name === variable.name || !queryVariableNames.has(value.name))) continue;
    bindings.push(`${variable.name} = ${engine.formatTermForWrite(value, env, {
      ...answerWriteOptions,
      maxPriority: valueMaxPriority,
      // A binding value is the right-hand `arg` of =/2.  ISO 6.3.3.1 permits
      // current operator atoms in argument and list-element positions without
      // quotes, just as writeq/1 already prints them.
    })}`);
  }
  for (const constraint of env.variableConstraints?.() ?? []) {
    const residual = constraint.residualGoal?.(env);
    if (residual == null) continue;
    collectUnboundVariables(engine, residual, env, names, () => `_${letterName(generated++)}`);
    bindings.push(engine.formatTermForWrite(residual, env, answerWriteOptions));
  }
  // Residual attributes are part of the answer even when the attributed
  // variable was created inside a called predicate and is not itself a query
  // variable (issue #87).  First retain visible query names for attributed
  // roots, then project every remaining live attributed root with a generated
  // top-level variable name.  This also makes call_residue_vars/2 useful at the
  // top level: variables returned through its list share the same name with the
  // projected constraint instead of appearing unconstrained.
  const projectedAttributeRoots = new Set();
  const attributeRoots = [];
  for (const variable of variables) {
    const root = engine.deref(variable, env);
    if (root.type !== 'var' || !env.hasPrologAttributes?.(root.name)) continue;
    names.set(root.name, variable.name);
    attributeRoots.push(root);
  }
  for (const name of env.attributedVariableNames?.() ?? []) {
    const root = engine.deref(engine.variable(name), env);
    if (root.type === 'var') attributeRoots.push(root);
  }
  for (const root of attributeRoots) {
    if (projectedAttributeRoots.has(root.name) || !env.hasPrologAttributes?.(root.name)) continue;
    projectedAttributeRoots.add(root.name);
    if (!names.has(root.name)) names.set(root.name, `_${letterName(generated++)}`);
    for (const residual of state.solver.attributeResidualGoals(root, env)) {
      collectUnboundVariables(engine, residual, env, names, () => `_${letterName(generated++)}`);
      bindings.push(engine.formatTermForWrite(residual, env, answerWriteOptions));
    }
  }
  return bindings.length === 0 ? 'true' : bindings.join(', ');
}

function collectUnboundVariables(engine, term, env, names, nextName) {
  const stack = [term];
  const seen = new Set();
  while (stack.length) {
    const current = engine.deref(stack.pop(), env);
    if (current.type === 'var') {
      if (!seen.has(current.name)) {
        seen.add(current.name);
        if (!names.has(current.name)) names.set(current.name, nextName());
      }
    } else {
      for (let i = current.args.length - 1; i >= 0; i--) stack.push(current.args[i]);
    }
  }
}

function letterName(index) {
  const letter = String.fromCharCode(65 + (index % 26));
  const suffix = Math.floor(index / 26);
  return suffix === 0 ? letter : `${letter}${suffix}`;
}

function formatError(engine, state, error) {
  if (error?.name === 'PrologError' || (error?.name === 'ThrownTerm' && error.term != null)) {
    const env = new engine.Env();
    const variableNames = new Map();
    let generated = 0;
    // ISO 7.12.1 represents processor errors as error(ErrorTerm, ImpDef).
    // Reuse the same conversion as catch/3 so uncaught errors at the top
    // level cannot lose the implementation-defined context or misplace a
    // culprit as the second argument of error/2.
    const term = error.name === 'ThrownTerm'
      ? engine.compound('throw', [error.term])
      : formalErrorTerm(error);
    collectUnboundVariables(engine, term, env, variableNames, () => `_${letterName(generated++)}`);
    return `${engine.formatTermForWrite(term, env, {
      quoted: true,
      // Match the spacing successful answers use: operator layout only where
      // ISO 6.3.4/6.4 needs it to keep the text readable back as the same
      // term, so contexts print as [outer-1, atom_length/2].
      minimalOperatorSpacing: true,
      operators: [...state.program.operators.values()],
      variableNames,
      doubleBar: !state.strictIso,
    })}.`;
  }
  const message = error?.message ?? String(error);
  return message.endsWith('.') ? message : `${message}.`;
}
