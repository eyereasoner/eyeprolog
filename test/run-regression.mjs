#!/usr/bin/env node
// Supplemental regression runner.
// This file collects focused checks that do not belong to the public
// conformance corpus or the example-output corpus: CLI regressions, public API
// checks, and small white-box tests for maintenance-sensitive internals.
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { Worker, parentPort, workerData } from 'node:worker_threads';
import { fileURLToPath } from 'node:url';
import publicDefaultApi from '../index.js';
import * as publicApi from '../src/index.js';
import {
  run as runEyeProlog,
  Program,
  makeProgram,
  Solver,
  Env,
  BuiltinRegistry,
  createDefaultRegistry,
  getStrictIsoRegistry,
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
  atom,
  compactVariableList,
  compound,
  listFromItems,
  numberTerm,
  numberTextFromDouble,
  stringTerm,
  variable,
  copyResolved,
  flattenConjunction,
  properListItems,
  termIsGround,
  termToString,
  unify,
  variantTerms,
  parseProgramText,
  proofCertificate,
  proofCertificatesFromText,
  verifyProof,
} from '../src/index.js';
import { ISO_OPERATOR_DEFINITIONS, parseGoalText, parseNumberTokenText, tryParseClausesFastInto } from '../src/parser.js';
import { PrologError, formalErrorTerm } from '../src/iso.js';
import { compareTerms } from '../src/term.js';
import { defaultsToStdin } from '../src/cli.js';
import { formatTermForWrite } from '../src/write.js';
import { selectClauseCandidates } from '../src/program.js';
import {
  TestReporter,
  assertEqual,
  assertIncludes,
  assertNotIncludes,
  isMainModule,
  runStandalone,
} from './test-style.mjs';
import { buildConformanceReport, formatConformanceReport } from './run-conformance-report.mjs';
import { proofExamples } from './run-examples.mjs';
import { goalsFromSource } from './goal-metadata.mjs';
import { renderWg17SyntaxStatus } from '../tools/report-wg17-syntax-coverage.mjs';
import { parseWg17SyntaxTable } from '../tools/upgrade-wg17.mjs';
import { executeWg17Item, matchesUpstreamExpectation, readWg17SyntaxFixture } from './run-wg17.mjs';
import { withStandardModules } from './test-support.mjs';

const testRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)));
const packageRoot = path.resolve(testRoot, '..');
const bin = path.join(packageRoot, 'bin', 'eyeprolog.js');
const pkg = JSON.parse(fs.readFileSync(path.join(packageRoot, 'package.json'), 'utf8'));
// The issue #49 hand-off checks assert demand-driven completion and bounded memory,
// not a machine-speed threshold. Leave enough wall-clock headroom for slower or
// contended CI hosts while still terminating a genuinely stuck child process.
const DCG_HANDOFF_TEST_TIMEOUT_MS = 20_000;
let tmp = null;
let tmpCounter = 0;

function run(source, options = {}) {
  const programSource = Array.isArray(source) ? source.join('\n') : source;
  const text = programSource instanceof Program ? programSource : withStandardModules(String(programSource));
  const goals = options.goals ?? (options.goal == null
    ? (programSource instanceof Program ? [] : goalsFromSource(text))
    : [options.goal]);
  return runEyeProlog(programSource instanceof Program ? programSource : text, { ...options, goals });
}

function sourceAtom(value) {
  return `'${String(value).replaceAll('\\', '\\\\').replaceAll("'", "''")}'`;
}

const regressionSections = [
    { key: 'regression', name: 'Regression', cases: regressionCases },
    { key: 'docs', name: 'Documentation sync', cases: documentationSyncCases },
    { key: 'api', name: 'API', cases: apiCases },
    { key: 'white-box', name: 'White-box', cases: whiteBoxCases },
];

export async function runRegression(reporter = new TestReporter(), requestedSection = null) {
  const sections = regressionSections;
  const selected = requestedSection == null
    ? sections
    : sections.filter((section) => section.key === requestedSection);
  if (selected.length === 0) {
    throw new Error(`unknown regression section: ${requestedSection}; expected ${sections.map(({ key }) => key).join(', ')}`);
  }

  const prepared = selected.map((section) => ({ ...section, tests: section.cases() }));
  const testCount = prepared.reduce((sum, section) => sum + section.tests.length, 0);
  const parallelism = os.availableParallelism?.() ?? os.cpus().length;
  // Several cases start bounded-heap child processes, so leave CPU and memory
  // headroom instead of matching the host's full logical-core count.
  const workerCount = Math.min(testCount, Math.max(1, Math.min(4, parallelism - 1)));
  if (workerCount === 1) {
    withRegressionTemp(() => {
      for (const section of prepared) runSection(reporter, section.name, section.tests);
    });
    return;
  }

  const results = new Map();
  let reportSection = 0;
  let reportTest = 0;
  reporter.section(prepared[0].name);
  const reportReady = () => {
    while (reportSection < prepared.length) {
      const section = prepared[reportSection];
      const result = results.get(testKey(section.key, reportTest));
      if (result == null) return;
      reporter.testResult(section.tests[reportTest].name, result);
      reportTest++;
      if (reportTest !== section.tests.length) continue;
      reporter.sectionTotal(sectionLabel(section.name), sectionElapsedMs(section, results));
      reportSection++;
      reportTest = 0;
      if (reportSection < prepared.length) reporter.section(prepared[reportSection].name);
    }
  };
  await runRegressionWorkers(prepared, workerCount, results, reportReady);
}

function withRegressionTemp(runTests) {
  tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'eyeprolog-regression.'));
  tmpCounter = 0;
  try {
    return runTests();
  } finally {
    fs.rmSync(tmp, { recursive: true, force: true });
    tmp = null;
  }
}

async function runRegressionWorkers(sections, workerCount, results, onResult) {
  const tasks = sections.flatMap((section) => section.tests.map((_, index) => ({
    sectionKey: section.key,
    index,
  })));
  let nextTask = 0;
  let completed = 0;
  let settled = false;

  return new Promise((resolve, reject) => {
    const workers = Array.from({ length: workerCount }, () => new Worker(new URL(import.meta.url), {
      workerData: { regressionWorker: true },
    }));

    const closeWorkers = () => {
      for (const worker of workers) worker.postMessage({ close: true });
    };
    const fail = (error) => {
      if (settled) return;
      settled = true;
      Promise.all(workers.map((worker) => worker.terminate())).finally(() => reject(error));
    };
    const assign = (worker) => {
      if (settled) return;
      const task = tasks[nextTask++];
      if (task != null) worker.postMessage(task);
    };

    for (const worker of workers) {
      worker.on('message', (message) => {
        if (settled) return;
        if (message.ready) {
          assign(worker);
          return;
        }
        results.set(testKey(message.sectionKey, message.index), {
          ms: message.ms,
          error: deserializeWorkerError(message.error),
          startedAt: message.startedAt,
          finishedAt: message.finishedAt,
        });
        try {
          onResult();
        } catch (error) {
          fail(error);
          return;
        }
        completed++;
        if (completed === tasks.length) {
          settled = true;
          const exits = Promise.all(workers.map((candidate) => new Promise((done, failed) => {
            candidate.once('exit', done);
            candidate.once('error', failed);
          })));
          closeWorkers();
          exits.then(() => resolve(results), reject);
        } else {
          assign(worker);
        }
      });
      worker.on('error', fail);
      worker.on('exit', (code) => {
        if (!settled) fail(new Error(`regression worker exited unexpectedly with status ${code}`));
      });
    }
  });
}

function testKey(sectionKey, index) {
  return `${sectionKey}:${index}`;
}

function sectionElapsedMs(section, results) {
  const timings = section.tests.map((_, index) => results.get(testKey(section.key, index)));
  return Math.max(...timings.map(({ finishedAt }) => finishedAt)) -
    Math.min(...timings.map(({ startedAt }) => startedAt));
}

function deserializeWorkerError(error) {
  if (error == null) return null;
  return Object.assign(new Error(error.message), { stack: error.stack });
}

function startRegressionWorker() {
  tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'eyeprolog-regression-worker.'));
  tmpCounter = 0;
  const casesBySection = new Map(regressionSections.map((section) => [section.key, section.cases()]));
  parentPort.on('message', ({ sectionKey, index, close }) => {
    if (close) {
      fs.rmSync(tmp, { recursive: true, force: true });
      tmp = null;
      parentPort.close();
      return;
    }
    const testCase = casesBySection.get(sectionKey)?.[index];
    const startedAt = Date.now();
    const started = performance.now();
    let error = null;
    try {
      if (testCase == null) throw new Error(`unknown regression test ${sectionKey}:${index}`);
      testCase.run();
    } catch (caught) {
      error = { message: caught?.message ?? String(caught), stack: caught?.stack ?? String(caught) };
    }
    parentPort.postMessage({
      sectionKey,
      index,
      ms: Math.round(performance.now() - started),
      startedAt,
      finishedAt: Date.now(),
      error,
    });
  });
  parentPort.postMessage({ ready: true });
}

function regressionCases() {
  return [
    {
      name: 'dif/2 passes the WG17 finite-tree comparison cases (issue #68)',
      run: () => {
        // Comparison cases from
        // https://www.complang.tuwien.ac.at/ulrich/iso-prolog/dif
        const comparisonCases = [
          ['1', true, 'dif(1,2)'],
          ['2', false, 'dif(1,Y),Y=1'],
          ['3', true, 'dif(1,Y),Y=2'],
          ['4', false, 'dif(X,-Y),X= -Y'],
          ['5', false, 'dif(X,Y),X=Y'],
          ['6', false, 'dif(X,Y),X=Y,X=1'],
          ['7', false, 'dif(-X,-Y),X=Y'],
          ['8', false, 'dif(-X,-Y),X=Y,X=1'],
          ['9', true, 'dif(-X,X)'],
          ['10', true, 'dif(-X,Y),X=Y'],
          ['11', true, 'X=Y,dif(X-Y,1-2)'],
          ['12', true, 'dif(X-Y,1-2),X=Y'],
          ['13', true, 'X=Y,Y=1,dif(X-Y,1-2)'],
          ['14', true, 'dif(X-Y,1-2),X=Y,Y=1'],
          ['15', true, 'dif(X-Y,1-2),X=Y,X=2'],
          ['16', true, 'dif(A-C,B-D),C-D=z-z,A-B=1-2'],
          ['17', true, 'A-B=1-2,C-D=z-z,dif(A-C,B-D)'],
          ['18', true, 'dif(A,[C|B]),A=[[]|_],A=[B]'],
          ['19', true, 'dif([E],[/]),E=1'],
          ['20', true, 'dif([a],B),B=[_|_],B=[b]'],
          ['21', true, 'dif([],A),A=[_]'],
          ['22', true, 'A=[_],dif([],A)'],
          // Cases 23-26 are implementation-defined in the comparison. These
          // assertions record EyeProlog's term-copying and collector
          // choices so changes remain deliberate.
          ['23', true, 'dif(X,a),copy_term(X,a)'],
          ['24', true, 'findall(X,dif(X,a),[a])'],
          ['25', true, 'setof(t,dif(X,a),_),X=a'],
          ['26', true, 'setof(t,(dif(X,a);dif(X,b)),_),X=a'],
        ];
        for (const [id, succeeds, query] of comparisonCases) {
          const result = run(`check :- ${query}.`, { goal: 'check' });
          assertEqual(result.stdout, succeeds ? 'check.\n' : '', `WG17 dif/2 case ${id}`);
        }

        // EyeProlog is a finite-tree processor. The comparison's rational-tree
        // probes must terminate as failures instead of constructing cycles.
        const rationalTreeCases = [
          ['t1', '\\+ \\+ -X=X'],
          ['t2', '-X=X,-Y=Y,X\\=Y'],
          ['t3', '-X=X,dif(X,1)'],
          ['t4', '-X=X,-Y=Y,dif(X,Y)'],
          ['t5', 'dif(X,Y),-X=X,-Y=Y'],
          ['t6', 'A=[[]|A],dif(A,B),B=[[]|A]'],
          ['t7', 'dif(-X,X),-Y=Y,X=Y'],
          ['t8', '-X=X,dif(X,Y),X=Y'],
        ];
        for (const [id, query] of rationalTreeCases) {
          assertEqual(run(`check :- ${query}.`, { goal: 'check' }).stdout, '',
            `WG17 dif/2 ${id} terminates under finite-tree unification`);
        }

        for (const [id, query, succeeds] of [
          ['o1', '-X=X', false],
          ['o2', 'dif(-X,X)', true],
          ['o3', 'dif(-X,Y),X=Y', true],
        ]) {
          assertEqual(run(`check :- ${query}.`, { goal: 'check' }).stdout,
            succeeds ? 'check.\n' : '', `WG17 dif/2 occurs-check case ${id}`);
        }

        const residuals = runCli([], {
          input:
            'dif(A-C,B-D),C-D=z-z.\n' +
            'dif(A,[C|B]),A=[[]|_],A=[B].\n' +
            'dif(X-Y,1-2),X=Y.\n' +
            'halt.\n',
        });
        assertEqual(residuals.status, 0, 'dif/2 residual display status');
        assertEqual(residuals.stdout,
          '?-    C = z, D = z, dif(A, B).\n' +
          '?-    A = [[]], B = [], dif([], C).\n' +
          '?-    X = Y.\n' +
          '?- ',
          'dif/2 residual constraints are retained and discharged');
        assertEqual(residuals.stderr, '', 'dif/2 residual display stderr');

        assertEqual(run('p(a).', { goal: 'dif(X,a),p(X)' }).stats.completed_goal_lists, 0,
          'scalar-fact fast matching still validates annotated variables');
        assertEqual(run('p(b).', { goal: 'dif(X,a),p(X)' }).stats.completed_goal_lists, 1,
          'scalar-fact fast matching can discharge an annotated disequality');

        const freezeProgram = Program.parse(':- use_module(library(freeze), [freeze/2]).');
        const freezeSolver = new Solver(freezeProgram);
        const freezeDifGoal = parseGoalText('freeze(X,a),dif(X,c)');
        const freezeDifAnswer = freezeSolver.solve([freezeDifGoal], new Env(), 0).next();
        assertEqual(freezeDifAnswer.done, false, 'freeze/2 and dif/2 answer');
        const freezeResiduals = freezeSolver.attributeResidualGoals(
          freezeDifGoal.args[0].args[0], freezeDifAnswer.value,
        );
        assertEqual(freezeResiduals.length, 1,
          'freeze/2 residual projection terminates alongside dif/2 (issue #73)');
      },
    },
    {
      name: 'dif/2 removes symmetric and logically weaker residual constraints (issue #79)',
      run: () => {
        const residuals = runCli([], {
          input:
            'dif(X,Y),dif(Y,X).\n' +
            'dif(X,Y),dif(X-Y,Z-Z).\n' +
            'dif(X-Y,Z-Z),dif(X,Y).\n' +
            'dif(X,a),dif(X,b).\n' +
            'dif(X,a),dif(Y,a),X=Y.\n' +
            'dif(-X,-Y).\n' +
            'dif(X,Y),X+Y= -XA+ -YA.\n' +
            'dif(f(X,a),f(Y,a)).\n' +
            'dif(f(X,X),f(Y,Y)).\n' +
            'dif(f(X,Y),f(Y,X)).\n' +
            'dif(f(X,A),f(Y,B)).\n' +
            'halt.\n',
        });
        assertEqual(residuals.status, 0, 'dif/2 normalization display status');
        assertEqual(residuals.stdout,
          '?-    dif(X, Y).\n' +
          '?-    dif(X, Y).\n' +
          '?-    dif(X, Y).\n' +
          '?-    dif(X, a), dif(X, b).\n' +
          '?-    X = Y, dif(Y, a).\n' +
          '?-    dif(X, Y).\n' +
          '?-    X = -XA, Y = -YA, dif(XA, YA).\n' +
          '?-    dif(X, Y).\n' +
          '?-    dif(X, Y).\n' +
          '?-    dif(X, Y).\n' +
          '?-    dif(f(X, A), f(Y, B)).\n' +
          '?- ',
          'dif/2 residuals are minimal without auxiliary terms');
        assertEqual(residuals.stderr, '', 'dif/2 normalization display stderr');

        const perfection = runCli([], {
          input:
            'dif(f(X,A),f(Y,B)), ( true ; A = B ).\n' +
            ';\n' +
            'halt.\n',
        });
        assertEqual(perfection.status, 0, 'dif/2 branch-local projection status');
        assertEqual(perfection.stdout,
          '?-    dif(f(X, A), f(Y, B))\n' +
          ';  A = B, dif(X, Y).\n' +
          '?- ',
          'dif/2 residual projection is re-evaluated after branch-local bindings');
        assertEqual(perfection.stderr, '', 'dif/2 branch-local projection stderr');

        const pendingDifCount = (text) => {
          const solver = new Solver(Program.parse(''), { registry: getEyePrologRegistry() });
          const solutions = solver.solve([parseGoalText(text)], new Env(), 0);
          const answer = solutions.next();
          assertEqual(answer.done, false, `${text} succeeds`);
          const count = answer.value.variableConstraints('dif').length;
          solutions.return();
          return count;
        };
        assertEqual(pendingDifCount('dif(X,Y),dif(Y,X)'), 1,
          'symmetric disequalities share one descriptor');
        assertEqual(pendingDifCount('dif(X-Y,Z-Z),dif(X,Y)'), 1,
          'stronger later disequality replaces the weaker descriptor');
        assertEqual(pendingDifCount('dif(X,a),dif(X,b)'), 2,
          'independent disequalities are both retained');
        assertEqual(pendingDifCount('dif(X,a),dif(Y,a),X=Y'), 1,
          'later aliasing coalesces newly equivalent disequalities');
        for (const prefix of [
          'dif(X,Y),dif(X-Y,Z-Z)',
          'dif(X-Y,Z-Z),dif(X,Y)',
        ]) {
          assertEqual(run('', { goal: `${prefix},X=Y` }).stats.completed_goal_lists, 0,
            `${prefix} retains the stronger disequality semantics`);
        }
      },
    },
    {
      name: 'library(atts) provides Scryer-style attributed-variable hooks',
      run: () => {
        const source = `:- module(attr_probe, [check_get/0, check_alias/0, check_ok/0, check_bad/0, check_conflict/0, check_backtrack/0, check_term_vars/0, check_residue_new/0, check_residue_unchanged/0, check_residue_modified/0, check_residue_dif/0]).
:- use_module(library(atts)).
:- attribute mark/1.
attach(X, V) :- put_atts(X, mark(V)).
verify_attributes(Var, Other, Goals) :-
    ( get_atts(Var, mark(V)) ->
        ( var(Other) ->
            ( get_atts(Other, mark(W)) -> V = W ; put_atts(Other, mark(V)) ),
            Goals = []
        ; Goals = [same(Other, V)] )
    ; Goals = [] ).
same(X, Y) :- X = Y.
check_get :- attach(X, a), get_atts(X, mark(a)), X = a.
check_alias :- attach(X, a), X = Y, get_atts(Y, mark(a)), Y = a.
check_ok :- attach(X, 3), X = 3.
check_bad :- attach(X, 3), X = 4.
check_conflict :- attach(X, a), attach(Y, b), X = Y.
check_backtrack :- (attach(X, a), fail ; true), \\+ get_atts(X, mark(_)).
check_term_vars :- attach(X, a), term_attributed_variables(pair(X,Y), [X]), var(Y), X = a.
check_residue_new :- call_residue_vars(attach(X, a), Vs), Vs = [X].
check_residue_unchanged :- attach(X, a), call_residue_vars(true, Vs), Vs = [], X = a.
check_residue_modified :- attach(X, a), call_residue_vars(put_atts(X, mark(b)), Vs), Vs = [X], X = b.
check_residue_dif :- call_residue_vars(dif(X,Y), Vs), Vs = [X,Y].
`;
        assertIncludes(run(source, { goal: 'attr_probe:check_get' }).stdout, 'attr_probe:check_get.', 'get_atts/2');
        assertIncludes(run(source, { goal: 'attr_probe:check_alias' }).stdout, 'attr_probe:check_alias.', 'attribute transfer on aliasing');
        assertIncludes(run(source, { goal: 'attr_probe:check_ok' }).stdout, 'attr_probe:check_ok.', 'post-binding hook goals');
        assertEqual(run(source, { goal: 'attr_probe:check_bad' }).stdout, '', 'post-binding hook can reject a binding');
        assertEqual(run(source, { goal: 'attr_probe:check_conflict' }).stdout, '', 'same-module attributes are verified before aliasing');
        assertIncludes(run(source, { goal: 'attr_probe:check_backtrack' }).stdout, 'attr_probe:check_backtrack.', 'attributes backtrack with Env branches');
        assertIncludes(run(source, { goal: 'attr_probe:check_term_vars' }).stdout, 'attr_probe:check_term_vars.', 'term_attributed_variables/2');
        assertIncludes(run(source, { goal: 'attr_probe:check_residue_new' }).stdout, 'attr_probe:check_residue_new.', 'call_residue_vars/2 reports newly attributed variables');
        assertIncludes(run(source, { goal: 'attr_probe:check_residue_unchanged' }).stdout, 'attr_probe:check_residue_unchanged.', 'call_residue_vars/2 ignores unchanged pre-existing attributes');
        assertIncludes(run(source, { goal: 'attr_probe:check_residue_modified' }).stdout, 'attr_probe:check_residue_modified.', 'call_residue_vars/2 reports modified attributes');
        assertIncludes(run(source, { goal: 'attr_probe:check_residue_dif' }).stdout, 'attr_probe:check_residue_dif.', 'call_residue_vars/2 includes native dif/2 residual variables');
        const freezeResidue = `:- use_module(library(atts)).
:- use_module(library(prologue), [freeze/2]).
check :- call_residue_vars(freeze(X,true), Vs), Vs = [X].
`;
        assertIncludes(run(freezeResidue, { goal: 'check' }).stdout, 'check.', 'call_residue_vars/2 includes delayed freeze/2 variables');
        const clpzResidue = `:- use_module(library(atts)).
:- use_module(library(clpz)).
check :- call_residue_vars(X in 1..3, Vs), Vs = [X].
`;
        assertIncludes(run(clpzResidue, { goal: 'check' }).stdout, 'check.', 'call_residue_vars/2 includes CLP(Z) attributed variables');

        const deterministicProgram = Program.parse(':- use_module(library(atts)).');
        const deterministicSolver = new Solver(deterministicProgram);
        const deterministicGoal = parseGoalText('call_residue_vars(true, Xs)');
        const deterministicSolutions = deterministicSolver.solve([deterministicGoal], new Env(), 0);
        const deterministicAnswer = deterministicSolutions.next();
        assertEqual(deterministicAnswer.done, false, 'call_residue_vars/2 deterministic answer');
        assertEqual(deterministicSolver.hasPendingAlternatives(), false,
          'call_residue_vars/2 deterministic success has no leftover choicepoint');
        deterministicSolutions.return();

        const residualFile = path.join(tmp, `atts-residual-${++tmpCounter}.pl`);
        fs.writeFileSync(residualFile, `:- use_module(library(atts)).
:- use_module(library(freeze), [freeze/2]).
:- attribute required/1.
attach(X,V) :- put_atts(X, required(V)).
verify_attributes(Var, Other, Goals) :-
    ( get_atts(Var, required(V)) ->
        ( var(Other) -> put_atts(Other, required(V)), Goals=[] ; Goals=[same(Other,V)] )
    ; Goals=[] ).
same(X,X).
attribute_goals(X) --> { get_atts(X, required(V)) }, [required(X,V)].
`);
        const repl = runCli([], {
          input: `[${sourceAtom(residualFile)}].\nattach(X,a).\nfreeze(Y,a),dif(Y,c).\nhalt.\n`,
        });
        assertEqual(repl.status, 0, 'attribute residual REPL status');
        assertIncludes(repl.stdout, 'required(X, a).', 'attribute_goals//1 residual projection');
        assertIncludes(repl.stdout, 'dif(Y, c), freeze:freeze(Y, a).',
          'freeze/2 and dif/2 residuals share the query variable (issue #73)');

        const hiddenResidualFile = path.join(tmp, `atts-hidden-residual-${++tmpCounter}.pl`);
        fs.writeFileSync(hiddenResidualFile, 'ffalse :- freeze(_, false).\n');
        const hiddenResidual = runCli([], {
          input:
            `[${sourceAtom(hiddenResidualFile)}].\n` +
            'ffalse.\n' +
            'call_residue_vars(ffalse, Vs).\n' +
            'freeze(V,false).\n' +
            'halt.\n',
        });
        assertEqual(hiddenResidual.status, 0, 'hidden attribute residual REPL status');
        assertIncludes(hiddenResidual.stdout, 'freeze:freeze(_A, false).',
          'top level projects hidden attributed variables (issue #87)');
        assertIncludes(hiddenResidual.stdout, 'Vs = [_A], freeze:freeze(_A, false).',
          'call_residue_vars/2 shares its returned variable with the projected residue (issue #87)');
        assertIncludes(hiddenResidual.stdout, 'freeze:freeze(V, false).',
          'direct top-level freeze/2 keeps the visible query variable name');

        const scryerShape = Program.parse(`:- module(scryer_shape, [op(700, xfx, #=), probe/0]).
:- op(700, xfx, #=).
:- use_module(library(atts)).
:- attribute first/1, second/0.
probe.
`);
        assertEqual(scryerShape.findGroup('probe', 0, 'scryer_shape')?.module, 'scryer_shape',
          'Scryer-style operator exports and multi-attribute directives load');
      },
    },
    {
      name: 'user source expansion supports Scryer-style generated predicates and DCGs',
      run: () => {
        const termSource = `term_expansion(make_generated, [generated(one),generated(two)]).
make_generated.
`;
        const generated = Program.parse(termSource, { sourceMetadata: false });
        assertEqual(generated.findGroup('generated', 1, 'user')?.clauses.length, 2,
          'term_expansion/2 may emit a list of clauses');
        assertEqual(generated.findGroup('make_generated', 0, 'user'), null,
          'the source marker is replaced by its expansion');

        const dcgSource = `term_expansion(make_dcg, Clause) :-
    expand_term((generated_nt --> [a]), Clause).
make_dcg.
check :- phrase(generated_nt, [a]).
`;
        assertIncludes(run(dcgSource, { goal: 'check' }).stdout, 'check.',
          'expand_term/2 exposes system DCG expansion to a source hook');

        const duoSource = `:- op(1200, xfx, ++>).
term_expansion((Head ++> Body), (Head :- Body)).
generated_duo(ok) ++> true.
`;
        assertEqual(run(duoSource, { goal: 'generated_duo(ok)' }).stats.completed_goal_lists, 1,
          'custom Duo-DCG-style operators can be lowered by term_expansion/2');

        const goalSource = `:- module(expansion_probe, [check/0]).
helper(ok).
user:goal_expansion(old(X), new(X)) :- helper(ok).
new(ok).
check :- old(X), X = ok.
`;
        const goalProgram = Program.parse(goalSource, { sourceMetadata: false });
        const check = goalProgram.findGroup('check', 0, 'expansion_probe')?.clauses[0];
        assertEqual(check?.body[0]?.name, 'new', 'goal_expansion/2 rewrites a later source goal');
        assertEqual(check?.body[0]?.args[0]?.name, check?.body[1]?.args[0]?.name,
          'goal expansion preserves sharing with the surrounding clause');
        assertEqual(goalProgram.findGroup('goal_expansion', 2, 'user')?.clauses[0]?.body[0]?.module,
          'expansion_probe', 'qualified hook clauses retain their lexical body module');
        assertIncludes(run(goalSource, { goal: 'expansion_probe:check' }).stdout, 'expansion_probe:check.',
          'a user hook defined by a library module executes in its lexical module');
      },
    },
    {
      name: 'Scryer CLP(Z) support libraries provide the dependency surface',
      run: () => {
        const source = `:- module(scryer_support, [snapshot/6, blackboard_rollback/1, copy_drops_attrs/0]).
:- use_module(library(assoc)).
:- use_module(library(pairs)).
:- use_module(library(between)).
:- use_module(library(dcgs)).
:- use_module(library(terms)).
:- use_module(library(error)).
:- use_module(library(si)).
:- use_module(library(freeze)).
:- use_module(library(arithmetic)).
:- use_module(library(debug)).
:- use_module(library(format)).
:- use_module(library(atts)).
snapshot(Pairs, Keys, Values, Ns, Bits, Wake) :-
    empty_assoc(A0),
    put_assoc(2, A0, b, A1),
    put_assoc(1, A1, a, A2),
    assoc_to_list(A2, Pairs),
    pairs_keys_values(Pairs, Keys, Values),
    numlist(1, 3, Ns),
    list_si(Ns),
    arithmetic:popcount(13, Bits),
    freeze(X, Wake = awake),
    X = go.
blackboard_rollback(Value) :-
    bb_b_put(k, base),
    ( bb_b_put(k, temporary), fail ; bb_get(k, Value) ).
copy_drops_attrs :-
    put_attr(X, probe, value),
    copy_term_nat(X, Copy),
    term_attributed_variables(Copy, []).
`;
        const snapshot = run(source, { goal: 'scryer_support:snapshot(Pairs,Keys,Values,Ns,Bits,Wake)' });
        assertIncludes(snapshot.stdout,
          'scryer_support:snapshot([1 - a, 2 - b], [1, 2], "ab", [1, 2, 3], 3, awake).',
          'assoc, pairs, between, si, freeze, and arithmetic compatibility');
        assertIncludes(run(source, { goal: 'scryer_support:blackboard_rollback(V)' }).stdout,
          'scryer_support:blackboard_rollback(base).',
          'backtrackable blackboard writes roll back with Env branches');
        assertIncludes(run(source, { goal: 'scryer_support:copy_drops_attrs' }).stdout,
          'scryer_support:copy_drops_attrs.',
          'copy_term_nat/2 omits attributed-variable state');
        assertEqual(run(source, { goal: 'debug:bb_get(missing,_V)' }).stats.completed_goal_lists, 0,
          'bb_get/2 is semidet for an absent key');
        const prelude = `:- module(scryer_clpz_prelude, [probe/0]).
:- use_module(library(assoc)).
:- use_module(library(pairs)).
:- use_module(library(between)).
:- use_module(library(lists)).
:- use_module(library(atts)).
:- use_module(library(iso_ext)).
:- use_module(library(dcgs)).
:- use_module(library(terms)).
:- use_module(library(error), [domain_error/3, type_error/3, can_be/2]).
:- use_module(library(si)).
:- use_module(library(freeze)).
:- use_module(library(arithmetic)).
:- use_module(library(debug)).
:- use_module(library(format)).
:- attribute clpz/1, clpz_aux/1, clpz_relation/1, edges/1, flow/1,
             parent/1, free/1, queue/2, disabled/0.
probe :- empty_assoc(A), copy_term_nat(A, _), bb_b_put(current, ok), bb_get(current, ok).
`;
        assertIncludes(run(prelude, { goal: 'scryer_clpz_prelude:probe' }).stdout,
          'scryer_clpz_prelude:probe.',
          'the dependency and attribute prelude used by upstream clpz.pl loads unchanged');
      },
    },
    {
      name: 'write_term variable_names/1 errors preserve the instantiated option culprit (issue #69)',
      run: () => {
        const scalar = run('', {
          isoStrict: true,
          goal: "catch((VN=1,write_term(T,[variable_names(VN)])),error(E,_),writeq(E))",
        });
        assertEqual(scalar.stdout, 'domain_error(write_option,variable_names(1))', 'scalar culprit');

        const list = run('', {
          isoStrict: true,
          goal: "catch((VN=[[]],write_term(T,[variable_names(VN)])),error(E,_),writeq(E))",
        });
        assertEqual(list.stdout, 'domain_error(write_option,variable_names([[]]))', 'list culprit');

        assertEqual(run('', { isoStrict: true, goal: 'writeq(-(1^2))' }).stdout.split('writeq(')[0],
          '- (1^2)', 'writeq negative power layout');
        assertEqual(run('', { isoStrict: true, goal: 'writeq(-(a^2))' }).stdout.split('writeq(')[0],
          '- (a^2)', 'writeq symbolic negative power layout');
        assertEqual(run('', {
          isoStrict: true,
          goal: "write_term(-X^2,[variable_names(['X'=X])])",
        }).stdout, '- (X^2)', 'write_term variable_names negative power layout');
        assertEqual(run('', {
          isoStrict: true,
          goal: "X=1,write_term(-X^2,[variable_names(['X'=X])])",
        }).stdout.split('1 = 1')[0], '- (1^2)', 'write_term bound variable negative power layout');
      },
    },
    {
      name: 'large source scanning avoids quadratic full-stop lookback',
      run: () => {
        // Keep the guard well below quadratic behavior while allowing full-suite worker contention.
        const result = runCli(['examples/path-discovery.pl'], { timeout: 30000 });
        if (result.error) throw new Error(`path-discovery timed out or failed to launch: ${result.error.message}`);
        assertEqual(result.status, 0, `path-discovery status; stderr=${result.stderr}`);
        assertIncludes(result.stdout, "airroute('Ostend-Bruges International Airport', 'Václav Havel Airport Prague'",
          'path-discovery result');
      },
    },
    {
      name: '--proof rule fact explanation output',
      run: () => runWhy({
        program: 'type(socrates, man).\ntype(X, mortal) :- type(X, man).\n',
        goalText: 'type(socrates, mortal)',
        expected: `type(socrates, mortal).
why(
  type(socrates, mortal),
  proof(
    goal(type(socrates, mortal)),
    by(rule("__FILE__", clause(2))),
    bindings([binding("X", socrates)]),
    uses([
      proof(
        goal(type(socrates, man)),
        by(fact("__FILE__", clause(1)))
      )
    ])
  )
).

`,
      }),
    },
    {
      name: '--proof numeric builtin explanation output',
      run: () => runWhy({
        program: 'p(X) :- between(536, 536, X).\n',
        goalText: 'p(536)',
        expected: `p(536).
why(
  p(536),
  proof(
    goal(p(536)),
    by(rule("__FILE__", clause(1))),
    bindings([binding("X", 536)]),
    uses([
      proof(
        goal(between(536, 536, 536)),
        by(library(between, 3))
      )
    ])
  )
).

`,
      }),
    },
    {
      name: '--proof list builtin explanation output',
      run: () => runWhy({
        program: 'p(X) :- member(X, [a]).\n',
        goalText: 'p(a)',
        expected: `p(a).
why(
  p(a),
  proof(
    goal(p(a)),
    by(rule("__FILE__", clause(1))),
    bindings([binding("X", a)]),
    uses([
      proof(
        goal(member(a, "a")),
        by(library(member, 2))
      )
    ])
  )
).

`,
      }),
    },
    {
      name: 'explanation backtracks across earlier subgoal alternatives',
      run: () => {
        const result = runWhyLoose({
          program: 'p(ok) :- q(X), r(X).\nq(a).\nq(b).\nr(b).\n',
          goalText: 'p(ok)',
        });
        assertIncludes(result.stdout, 'goal(q(b)),\n        by(fact("', 'stdout');
        assertIncludes(result.stdout, 'goal(r(b)),\n        by(fact("', 'stdout');
        assertNotIncludes(result.stdout, 'no_proof', 'stdout');
      },
    },
    {
      name: 'explanation releases active call before caller rest goals',
      run: () => {
        const result = runWhyLoose({
          program: 'p(ok) :- q(1), q(1).\nq(0).\nq(1) :- q(0).\n',
          goalText: 'p(ok)',
        });
        assertIncludes(result.stdout, 'goal(p(ok)),\n    by(rule("', 'stdout');
        assertIncludes(result.stdout, 'goal(q(1)),\n        by(rule("', 'stdout');
        assertNotIncludes(result.stdout, 'no_proof', 'stdout');
      },
    },
    {
      name: 'parser records embedded quads without indexing them as clauses',
      run: () => {
        const source = `p(1).\n\nnamed ?- p(X).\n   X = 1.\n\nq(2).\n`;
        const program = Program.parseSources([{ text: source, filename: 'embedded-quads.pl' }]);
        assertEqual(program.clauses.length, 2, 'ordinary clause count');
        assertEqual(program.quads.length, 1, 'quad count');
        assertEqual(program.quads[0].id.name, 'named', 'quad label');
        assertEqual(program.quads[0].source.filename, 'embedded-quads.pl', 'quad filename');
        assertEqual(program.quads[0].source.line, 3, 'quad line');
        assertEqual(Boolean(program.findGroup('p', 1)), true, 'preceding clause indexed');
        assertEqual(Boolean(program.findGroup('q', 1)), true, 'following clause indexed');
        assertEqual(Boolean(program.findGroup('?-', 2)), false, 'quad is inert');
      },
    },
    {
      name: 'parser separates compact ISO solo tokens and atom dots',
      run: () => {
        const program = Program.parse(
          `compact ?- call((!;\\+1)).\n   true.\n\n` +
          `dot ?- functor([_],.,2).\n   true.\n`,
        );
        assertEqual(program.quads.length, 2, 'quad count');
        assertEqual(program.quads[0].query.args[0].name, ';', 'disjunction');
        assertEqual(program.quads[0].query.args[0].args[1].name, '\\+', 'negation');
        assertEqual(program.quads[1].query.args[1].name, '.', 'dot atom');
      },
    },
    {
      name: 'quad parser treats regular term spellings of ?- equivalently',
      run: () => {
        const labelled = Program.parse(
          `0,passes
  ?- X = 1.
     X = 1.
`,
        );
        assertEqual(labelled.quads.length, 1, 'labelled quad count');
        assertEqual(labelled.clauses.length, 0, 'labelled quad clause count');
        assertEqual(labelled.quads[0].id.name, ',', 'comma label functor');
        assertEqual(labelled.quads[0].query.name, '=', 'labelled quad query');
        const labelledReport = publicApi.runQuads(labelled);
        assertEqual(labelledReport.stdout, 'quads: 1 run, 1 passed, 0 failed.\n', 'labelled quad report');

        const functional = Program.parse(
          `?-(','(0,passes),=(X,1)).
   X = 1.
`,
        );
        assertEqual(functional.quads.length, 1, 'functional quad count');
        assertEqual(functional.clauses.length, 0, 'functional quad clause count');
        assertEqual(functional.quads[0].id.name, ',', 'functional comma label functor');
        assertEqual(functional.quads[0].query.name, '=', 'functional quad query');
        assertEqual(termToString(functional.quads[0].id), termToString(labelled.quads[0].id),
          'operator and functional labels are equivalent');
        assertEqual(termToString(functional.quads[0].query), termToString(labelled.quads[0].query),
          'operator and functional queries are equivalent');
        const functionalReport = publicApi.runQuads(functional);
        assertEqual(functionalReport.stdout, 'quads: 1 run, 1 passed, 0 failed.\n', 'functional quad report');

        // Issue #11 is about ordinary term syntax, not one privileged
        // canonical spelling. Parentheses, quoted functor syntax, and mixed
        // operator/functional notation must all denote the same ?-/2 term and
        // therefore the same quad in the normal EyeProlog profile.
        for (const [name, source] of [
          ['mixed', `?-((0,passes), X = 1).\n   X = 1.\n`],
          ['parenthesized', `(?-(','(0,passes),=(X,1))).\n   X = 1.\n`],
          ['parenthesized mixed', `(?-((0,passes), X = 1)).\n   X = 1.\n`],
          ['quoted functor', `'?-'(','(0,passes),=(X,1)).\n   X = 1.\n`],
          ['quoted parenthesized', `('?-'(','(0,passes),=(X,1))).\n   X = 1.\n`],
        ]) {
          const regular = Program.parse(source);
          assertEqual(regular.quads.length, 1, `${name} quad count`);
          assertEqual(regular.clauses.length, 0, `${name} quad clause count`);
          assertEqual(termToString(regular.quads[0].id), termToString(labelled.quads[0].id), `${name} label`);
          assertEqual(termToString(regular.quads[0].query), termToString(labelled.quads[0].query), `${name} query`);
          assertEqual(publicApi.runQuads(regular).stdout, 'quads: 1 run, 1 passed, 0 failed.\n', `${name} report`);
        }

        const strict = Program.parse(`(?-(','(0,passes),=(X,1))).\n`, { isoStrict: true });
        assertEqual(strict.quads.length, 0, 'strict mode has no quads');
        assertEqual(strict.clauses.length, 1, 'strict ?-/2 remains an ordinary term');
      },
    },
    {
      name: 'quad ids use ordinary term syntax and each answer description is independent',
      run: () => {
        // Issue #21: the first argument of ?-/2 is an ordinary Prolog term.
        // The commas here are the normal priority-1000 comma operator, not a
        // special metadata grammar owned by the quad parser.
        const source = `9, "✳54·43", passes
` +
          `?- X is 1+1.
` +
          `   X = 3, unexpected. % almost
` +
          `   X = 1, unexpected. % too low
` +
          `   X = 2.0, unexpected.
` +
          `% and after checking PM:
` +
          `   X = 2.
`;
        const program = Program.parseSources([{ text: source, filename: 'issue-21.pl' }]);
        assertEqual(program.quads.length, 1, 'query group count');
        assertEqual(program.quads[0].answers.length, 4, 'answer-description count');
        assertEqual(program.quads[0].id.name, ',', 'ordinary outer comma operator');
        assertEqual(program.quads[0].id.args[1].name, ',', 'ordinary right-associated comma operator');
        const result = publicApi.runQuads(program);
        assertEqual(result.total, 4, 'answer-description total');
        assertEqual(result.passed, 4, 'answer-description passed');
        assertEqual(result.failed, 0, 'answer-description failed');
        assertEqual(result.stdout, 'quads: 4 run, 4 passed, 0 failed.\n', 'issue #21 report');

        // No convention is imposed on the id term. Functional/list/curly and
        // non-comma operator forms all go through the same ordinary term parser.
        const ordinaryIds = Program.parse(
          `meta(9, passes) ?- true.
   true.
` +
          `[9, passes] ?- true.
   true.
` +
          `{passes} ?- true.
   true.
` +
          `(alpha ; beta) ?- true.
   true.
`,
        );
        assertEqual(ordinaryIds.quads.length, 4, 'ordinary id term count');
        assertEqual(publicApi.runQuads(ordinaryIds).stdout, 'quads: 4 run, 4 passed, 0 failed.\n',
          'ordinary id term report');

        // Groundness is a quad semantic check, not source syntax. A bad id is
        // reported as a test failure and processing continues to the next quad.
        const nonGround = publicApi.runQuads(
          `Id ?- true.
   true.
` +
          `ok ?- true.
   true.
`,
        );
        assertEqual(nonGround.total, 2, 'non-ground id does not abort parsing');
        assertEqual(nonGround.passed, 1, 'following quad still passes');
        assertEqual(nonGround.failed, 1, 'non-ground id is a quad failure');
        assertIncludes(nonGround.stdout, 'quads: BAD_ID Id, <input>:1', 'non-ground id diagnostic');
        assertIncludes(nonGround.stdout, 'quads: 2 run, 1 passed, 1 failed.', 'non-ground continuation summary');

        const continuing = publicApi.runQuads(
          `case ?- X is 1+1.
   X = 3.
   X = 2.
`,
        );
        assertEqual(continuing.total, 2, 'later descriptions still run after failure');
        assertEqual(continuing.passed, 1, 'later passing description counted');
        assertEqual(continuing.failed, 1, 'failed description counted');
        assertIncludes(continuing.stdout, 'quads: 2 run, 1 passed, 1 failed.', 'continuation summary');
      },
    },
    {
      name: 'runQuads checks portable answer descriptions',
      run: () => {
        const source = `p(1).\np(2).\np(3).\n\n` +
          `ordered ?- p(X).\n   X = 1 ; X = 2 ; X = 3.\n\n` +
          `?- p(4).\n   false.\n\n` +
          `?- X = 1.\n   X = 2, unexpected.\n\n` +
          `?- p(X).\n   X = 1, ... .\n\n` +
          `?- atom_length(1, L).\n   type_error(atom, 1).\n\n` +
          `?- atom_length(1, L).\n   error(type_error(atom, 1), _).\n\n` +
          `?- throw(ball).\n   throw(ball).\n\n` +
          `?- write(ok), nl.\n   outputs("ok\\n"), true.\n\n` +
          `?- get_char(C).\n   inputs("a"), C = a.\n\n` +
          `?- get_char(C).\n   inputs("ab"), C = a, unexpected.\n\n` +
          `?- X = 1.\n   X = 2, unexpected.\n   X = 1.\n\n` +
          `?- catch(throw(ball), E, true).\n   E = ball | error(system_error, ...).\n`;
        const result = publicApi.runQuads(Program.parseSources([{ text: source, filename: 'quads.pl' }]));
        assertEqual(result.total, 13, 'answer-description total');
        assertEqual(result.passed, 13, 'answer-description passed');
        assertEqual(result.failed, 0, 'answer-description failed');
        assertEqual(result.stdout, 'quads: 13 run, 13 passed, 0 failed.\n', 'quad report');
      },
    },
    {
      name: 'runQuads matches other_answer_sequence permutations exactly (issue #95)',
      run: () => {
        const cases = [
          ['setof groups', 'setof(1, (Y=2 ; Y=1), L)', 'Y=2,L=[1];Y=1,L=[1]', true],
          ['reverse', '(X=1;X=2;X=3)', 'X=3;X=2;X=1', true],
          ['duplicates', '(X=1;X=1;X=2)', 'X=2;X=1;X=1', true],
          ['wrong multiplicity', '(X=1;X=1;X=2)', 'X=2;X=2;X=1', false],
          ['missing', '(X=1;X=2)', 'X=3;X=2;X=1', false],
          ['extra', '(X=1;X=2;X=3)', 'X=2;X=1', false],
          ['wrong value', '(X=1;X=2)', 'X=3;X=1', false],
          ['overlapping patterns', '(X=f(a);X=f(b))', "X=f('...');X=f(a)", true],
          ['variable sharing', '(X=Y;true)', 'true;X=Y', true],
          ['wrong sharing', '(X=Y;true)', 'X=Y;X=Y', false],
          ['per-answer output', '(X=1,write(a);X=2,write(b))', 'X=2,outputs("b");X=1,outputs("a")', true],
          ['wrong output', '(X=1,write(a);X=2,write(b))', 'X=2,outputs("a");X=1,outputs("b")', false],
          ['unlisted exception', '(X=1;throw(ball))', 'X=1', false],
          ['terminal exception', '(X=1;X=2;throw(ball))', 'X=2;X=1;throw(ball)', true],
          ['terminal failure', '(X=1;X=2)', 'X=2;X=1;false', true],
          ['empty sequence', 'fail', 'false', true],
          ['ordinary order retained', '(X=1;X=2)', 'X=2;X=1', false, false],
        ];
        for (const [name, query, answers, passes, unordered = true] of cases) {
          const result = publicApi.runQuads(`?- ${query}.\n   ${answers}${unordered ? ' | other_answer_sequence' : ''}.\n`);
          assertEqual(result.passed, passes ? 1 : 0, name);
          assertEqual(result.undecided, 0, `${name} decided`);
        }
        for (const answers of ['other_answer_sequence', 'other_answer_sequence | X=1',
          'X=1 | other_answer_sequence | other_answer_sequence']) {
          const result = publicApi.runQuads(`?- X=1.\n   ${answers}.\n`);
          assertEqual(result.results[0].kind, 'malformed', 'orphan or repeated marker');
        }
        const bounded = publicApi.runQuads(
          'p(0). p(X) :- p(Y), X is Y+1.\n?- p(X).\n   X=1;X=0 | other_answer_sequence.\n',
          { quadMaxInferences: 1 },
        );
        assertEqual(bounded.undecided, 1, 'bounded execution is not proof of a permutation');
      },
    },
    {
      name: 'runQuads supports realistic decimal-precision float descriptions with ~~ (issue #90)',
      run: () => {
        const source = `?- V is 0+(3.2+11).
` +
          `   V ~~ '14.2000'.

` +
          `?- V is 0+(3.2+11).
` +
          `   V ~~ '1.42000e1'.

` +
          `?- V is -14.2.
` +
          `   V ~~ '-14.2000'.

` +
          `?- V is 1.0e-3.
` +
          `   V ~~ '1.000e-3'.

` +
          `?- V is 14.199950000000001.
` +
          `   V ~~ '14.2000'.

` +
          `?- V is 14.20005.
` +
          `   V ~~ '14.2000'.

` +
          `?- V is 14.2.
` +
          `   V ~~ '14.1999', unexpected.

` +
          `?- V is 14.
` +
          `   V ~~ '14.0', unexpected.

` +
          `?- V is float(14).
` +
          `   V ~~ '14.0'.
`;
        const result = publicApi.runQuads(Program.parseSources([{ text: source, filename: 'approx-quad.pl' }]));
        assertEqual(result.total, 9, 'approximate answer-description total');
        assertEqual(result.passed, 9, 'approximate answer-description passed');
        assertEqual(result.failed, 0, 'approximate answer-description failed');
        assertEqual(result.stdout, 'quads: 9 run, 9 passed, 0 failed.\n', 'approximate quad report');

        const malformed = publicApi.runQuads(`?- V is 14.2.
   V ~~ 14.2000.
`);
        assertEqual(malformed.total, 1, 'numeric approximation total');
        assertEqual(malformed.failed, 1, 'numeric RHS is rejected');
        assertIncludes(malformed.stdout, 'MALFORMED', 'numeric RHS diagnostic');

        const malformedAtom = publicApi.runQuads(`?- V is 14.2.
   V ~~ 'fourteen'.
`);
        assertEqual(malformedAtom.failed, 1, 'non-decimal atom is rejected');
        assertIncludes(malformedAtom.stdout, 'MALFORMED', 'non-decimal atom diagnostic');

        const duplicate = publicApi.runQuads(`?- V is 14.2.
   V = 14.2, V ~~ '14.2000'.
`);
        assertEqual(duplicate.failed, 1, 'duplicate exact/approximate binding is rejected');
        assertIncludes(duplicate.stdout, 'MALFORMED', 'duplicate binding diagnostic');

        const fakeFloat = publicApi.runQuads(`?- V is 1.0.
   V ~~ '1.0000000000000001'.
`);
        assertEqual(fakeFloat.failed, 1, 'fake-float midpoint spelling is malformed');
        assertIncludes(fakeFloat.stdout, 'MALFORMED', 'fake-float midpoint diagnostic');

        const overPrecise = publicApi.runQuads(`?- V is 1.0000000000000002.
   V ~~ '1.0000000000000002'.
`);
        assertEqual(overPrecise.failed, 1, 'interval without three distinct floats is malformed');
        assertIncludes(overPrecise.stdout, 'MALFORMED', 'over-precise interval diagnostic');

        const continuationRange = publicApi.runQuads(`?- V is 1.0e308.
   V ~~ '1.0e309'.
`);
        assertEqual(continuationRange.failed, 1, 'non-finite continuation-value interval is malformed');
        assertIncludes(continuationRange.stdout, 'MALFORMED', 'continuation-value diagnostic');

        assertEqual(
          run('', { goal: 'current_op(Pri,Fix,=), current_op(Pri,Fix,~~)' }).stdout,
          'current_op(700, xfx, =), current_op(700, xfx, ~~).\n',
          '~~ shares the ISO equality operator priority and specifier',
        );
        assertEqual(
          run('', { goal: 'current_op(700,xfx,~~)' }).stats.completed_goal_lists,
          1,
          '~~ is visible through current_op/3 in the normal profile',
        );
        assertEqual(
          run('', { goal: 'current_op(_,_,~)' }).stats.completed_goal_lists,
          0,
          '~ is not installed by the quad approximation feature',
        );
        assertEqual(
          run('', { isoStrict: true, goal: "current_op(700,xfx,'~~')" }).stats.completed_goal_lists,
          0,
          'strict ISO Part 1 does not predefine the ~~ extension',
        );

        const ordinaryApproximate = Program.parse(`approx(X,Y) :- X ~~ Y.\n`);
        assertEqual(ordinaryApproximate.groups.has('user:~~/2'), false, '~~ has no built-in or implicit predicate definition');
        assertEqual(
          run(`~~(my,definition).\n`, { goal: 'my ~~ definition' }).stats.completed_goal_lists,
          1,
          '~~ remains available as an ordinary user-defined predicate',
        );
      },
    },
    {
      name: 'runQuads treats unexpected as a negative assertion on the next leaf (issue #83)',
      run: () => {
        const source = `:- use_module(library(prologue)).
` +
          `40
` +
          `?- member(X,"abc").
` +
          `   X = a
` +
          `;  X = b
` +
          `;  X = c.
` +
          `   X = a
` +
          `;  X = c, unexpected.

` +
          `41
` +
          `?- member(X, Xs).
` +
          `   Xs = [X|_A]
` +
          `;  ... .
` +
          `   Xs = [X|_A]
` +
          `;  Xs = [_A,X|_B]
` +
          `;  Xs = [_A,_B,X|_C]
` +
          `;  ... .
` +
          `   Xs = [X|_A]
` +
          `;  Xs = [], unexpected.
`;
        const result = publicApi.runQuads(Program.parseSources([{ text: source, filename: 'unexpected-quad.pl' }]));
        assertEqual(result.total, 5, 'quad total');
        assertEqual(result.passed, 5, 'quad passed');
        assertEqual(result.failed, 0, 'quad failed');
        assertEqual(result.stdout, 'quads: 5 run, 5 passed, 0 failed.\n', 'quad report');

        const forbidden = publicApi.runQuads(`:- use_module(library(prologue)).
` +
          `?- member(X,[a,c]).
` +
          `   X = a
` +
          `;  X = c, unexpected.
`);
        assertEqual(forbidden.total, 1, 'forbidden next answer total');
        assertEqual(forbidden.failed, 1, 'matching unexpected next answer fails');
      },
    },
    {
      name: 'runQuads distinguishes query variables from renamed throw variables',
      run: () => {
        const source = `?- throw(g(X)).\n` +
          `   throw(g(_X)).\n` +
          `   throw(g(X)), unexpected.\n`;
        const result = publicApi.runQuads(Program.parseSources([{ text: source, filename: 'throw-copy-quad.pl' }]));
        assertEqual(result.total, 2, 'answer-description total');
        assertEqual(result.passed, 2, 'answer-description passed');
        assertEqual(result.failed, 0, 'answer-description failed');
        assertEqual(result.stdout, 'quads: 2 run, 2 passed, 0 failed.\n', 'quad report');

        const forbiddenFresh = publicApi.runQuads(
          `?- throw(g(X)).\n   throw(g(_X)), unexpected.\n`,
        );
        assertEqual(forbiddenFresh.failed, 1, 'fresh thrown variable is detected');
      },
    },
    {
      name: 'phrase terminal-sequence checks are consistent across arities and list shapes (issue #94)',
      run: () => {
        // The upstream quads allow both checking and non-checking processors.
        // Require EyeProlog's chosen diagnostic, not either portable outcome.
        const bodies = ['[]', '[a]', '{true}', '{fail}', '{write(reached)}', '!', 'p'];
        const invalid = ['non_list', '0', 'f(a)', '[a|non_list]', '[a,b|0]', '[a,b,c|f(t)]'];
        for (const body of bodies) {
          for (const bad of invalid) {
            for (const call of [`phrase(${body}, Bad)`, `phrase(${body}, Bad, [])`,
              `phrase(${body}, [], Bad)`]) {
              let output = '';
              runEyeProlog('p --> [a].', {
                ioOptions: { write: (text) => { output += text; } },
                goal: `Bad=${bad}, catch((${call}, write(missed)), error(type_error(list, Bad), _), write(ok))`,
              });
              assertEqual(output, 'ok', `${call} with ${bad}`);
            }
          }
        }
        for (const goal of [
          'phrase([], [])',
          'phrase([a], [a])',
          'phrase([a], L), L == [a]',
          'phrase([a], [a|T]), T == []',
          'phrase([], S, S), var(S)',
          'phrase([], [a|T], [a|T]), var(T)',
          'phrase([], L, [a|T]), L == [a|T], var(T)',
          'phrase([a], [a|T], T), var(T)',
          'phrase([f(a),1], [f(a),1])',
        ]) {
          let output = '';
          runEyeProlog('', { goal: `(${goal}), write(ok)`,
            ioOptions: { write: (text) => { output += text; } } });
          assertEqual(output, 'ok', goal);
        }
      },
    },
    {
      name: 'runQuads matches the corrected ISO phrase quad boundaries',
      run: () => {
        const source = String.raw`c2 ?- call((1,fail)).
   type_error(callable,(1,fail)).

c3 ?- call((fail,1)).
   type_error(callable,(fail,1)).

c4 ?- call((!;1)).
   type_error(callable,(!;1)).

24 ?- asserta((a-->b)).
   permission_error(modify,static_procedure,(-->)/2).

25 ?- clause((a-->b),B).
   permission_error(access,private_procedure,(-->)/2).

26 ?- (X-->Y).
   existence_error(procedure,(-->)/2).

5 ?- phrase([a|b],L).
   type_error(list,[a|b]).

10 ?- phrase(([a],{1}),[]).
   type_error(callable,(...,...)).

37 ?- phrase((!,[a],{1}),[]).
   type_error(callable,(...,...)).

12 ?- phrase('|'([],[a]),[a]).
   true.

14 ?- phrase(([a];[]),L).
   L=[a] ; L=[].

15 ?- phrase({fail,1},L).
   type_error(callable,((fail,1),...)).

29 ?- phrase(([a],\+1),[]).
   false.

30 ?- phrase(([a],\+1;[]),[]).
   true.

31 ?- phrase(phrase(phrase,[]),L).
   existence_error(procedure,phrase/4).

32 ?- phrase(call([]),[]).
   existence_error(procedure,[]/2).

41 ?- phrase([],non_list).
   type_error(list,non_list).

42 ?- phrase([],[a|non_list]).
   type_error(list,[a|non_list]).

43 ?- phrase([],L,non_list).
   type_error(list,non_list).

44 ?- phrase([],L,[a|non_list]).
   type_error(list,[a|non_list]).

46 ?- phrase((1,{2}),[]).
   type_error(callable,1).

47 ?- phrase(({2},1),[]).
   type_error(callable,1).
`;
        const result = publicApi.runQuads(source);
        assertEqual(result.total, 22, 'quad total');
        assertEqual(result.passed, 22, 'quad passed');
        assertEqual(result.stdout, 'quads: 22 run, 22 passed, 0 failed.\n', 'quad report');
      },
    },
    {
      name: 'call/1 converts variable goals before execution so later cuts stay opaque (issue #86)',
      run: () => {
        const quad = publicApi.runQuads(`?- call((Z = !,(X=1;X=2), Z)) ; T=end.\n` +
          `   Z = !, X = 1\n` +
          `;  Z = !, X = 2\n` +
          `;  T = end.\n`);
        assertEqual(quad.total, 1, 'issue #86 quad total');
        assertEqual(quad.passed, 1, 'issue #86 exact answer sequence');
        assertEqual(quad.failed, 0, 'issue #86 quad failures');

        const program = Program.parse('');
        const answerCount = (text) => {
          const solver = new Solver(program, { registry: getEyePrologRegistry() });
          return [...solver.solve([parseGoalText(text)], new Env(), 0)].length;
        };

        assertEqual(answerCount('call((Z=!, (X=1;X=2), Z)) ; T=end'), 3,
          'issue #86 outer answer count');
        assertEqual(answerCount('call((Z=!, (X=1;X=2), Z, X=2))'), 1,
          'later call(!) does not prune the X=2 alternative');
        assertEqual(answerCount('Z=!, (call(((X=1;X=2),Z)) ; T=end)'), 2,
          'pre-bound cut stays direct inside the meta-call');
      },
    },
    {
      name: 'negation observes disjunction through direct and call/1 execution',
      run: () => {
        const reported = publicApi.runQuads(String.raw`?- \+ (true ; true).
   false.

?- call(\+ (true ; true)).
   false.
`);
        assertEqual(reported.total, 2, 'reported query count');
        assertEqual(reported.passed, 2, 'reported queries pass');

        const program = Program.parse('');
        const answerCount = (text) => {
          const solver = new Solver(program, { registry: getEyePrologRegistry() });
          return [...solver.solve([parseGoalText(text)], new Env(), 0)].length;
        };

        assertEqual(answerCount(String.raw`\+ (true ; true)`), 0, 'direct successful disjunction is negated');
        assertEqual(answerCount(String.raw`call(\+ (true ; true))`), 0, 'called negation fails');
        assertEqual(answerCount(String.raw`\+ (true ; fail)`), 0, 'successful left branch is observed');
        assertEqual(answerCount(String.raw`\+ (fail ; true)`), 0, 'successful right branch is observed');
        assertEqual(answerCount(String.raw`\+ (fail ; fail)`), 1, 'failed disjunction is negated');
        assertEqual(answerCount('once((true ; true))'), 1, 'once keeps the first disjunction answer');
      },
    },
    {
      name: 'runQuads passes the complete vendored ISO phrase quad corpus',
      run: () => {
        const source = fs.readFileSync(path.join(testRoot, 'fixtures', 'phrase_quad.pl'), 'utf8');
        const result = publicApi.runQuads(Program.parseSources([{
          text: source,
          filename: 'test/fixtures/phrase_quad.pl',
        }]));
        assertEqual(result.total, 58, 'quad total');
        assertEqual(result.passed, 58, 'quad passed');
        assertEqual(result.stdout, 'quads: 58 run, 58 passed, 0 failed.\n', 'quad report');
      },
    },
    {
      name: 'runQuads passes the complete vendored number_chars continuation corpus',
      run: () => {
        const filename = path.join(testRoot, 'fixtures', 'number_chars_cont_quad.pl');
        const source = fs.readFileSync(filename, 'utf8');
        const numbered = new Set([...source.matchAll(/^(\d+)\s+\?-/gm)].map((match) => Number(match[1])));
        assertEqual(numbered.size, 74, 'numbered case total');
        for (let id = 1; id <= 74; id++) {
          if (!numbered.has(id)) throw new Error(`number_chars continuation case #${id} is missing`);
        }
        const result = publicApi.runQuads(Program.parseSources([{
          text: source,
          filename,
        }]));
        assertEqual(result.total, 78, 'answer-description total');
        assertEqual(result.passed, 78, 'answer-description passed');
        assertEqual(result.stdout, 'quads: 78 run, 78 passed, 0 failed.\n', 'quad report');
      },
    },
    {
      name: 'number conversion accepts line-comment layout after a minus token',
      run: () => {
        const source = String.raw`
?- number_chars(N,"-%\n0").
   N = 0.
?- number_chars(N,"-% comment\n1").
   N = -1.
?- number_codes(N,[45,37,10,48]).
   N = 0.
?- number_codes(N,[45,37,32,99,111,109,109,101,110,116,10,49]).
   N = -1.
`;
        const result = publicApi.runQuads(source);
        assertEqual(result.total, 4, 'quad total');
        assertEqual(result.passed, 4, 'quad passed');
        assertEqual(result.stdout, 'quads: 4 run, 4 passed, 0 failed.\n', 'quad report');

        // Keep the eager-consumer distinction from continuation case #24:
        // an adjacent bracketed comment can be consumed as part of a graphic
        // token after `-`, so it is not equivalent to the `%` line comment.
        for (const goal of ['number_chars(N,"-/**/1")', 'number_codes(N,[45,47,42,42,47,49])']) {
          let caught = null;
          try {
            publicApi.run('', { goal });
          } catch (error) {
            caught = error;
          }
          if (caught == null) throw new Error(`${goal} should throw`);
          assertIncludes(String(caught?.message ?? caught), 'syntax_error(number)', goal);
        }
      },
    },
    {
      name: 'apostrophe character-code constants parse in source and number conversion',
      run: () => {
        const source = String.raw`
?- N = 0'''.
   N = 39.
?- number_chars(N,"0'''").
   N = 39.
?- number_chars(N,"0'\\'").
   N = 39.
?- number_codes(N,[48,39,39,39]).
   N = 39.
`;
        const result = publicApi.runQuads(source);
        assertEqual(result.total, 4, 'quad total');
        assertEqual(result.passed, 4, 'quad passed');
        assertEqual(result.stdout, 'quads: 4 run, 4 passed, 0 failed.\n', 'quad report');

        for (const goal of ["N = 0''", 'number_chars(N,"0\'\'")']) {
          let caught = null;
          try {
            publicApi.run('', { goal });
          } catch (error) {
            caught = error;
          }
          if (caught == null) throw new Error(`${goal} should reject an undoubled apostrophe`);
        }
      },
    },
    {
      name: 'number conversion accepts ISO space and Unicode character-code constants exactly',
      run: () => {
        const source = String.raw`
?- N = 0' .
   N = 32.
?- number_chars(N,"0' ").
   N = 32.
?- number_codes(N,[48,39,32]).
   N = 32.
?- N = 0'😀.
   N = 128512.
?- number_chars(N,"0'😀").
   N = 128512.
?- number_codes(N,[48,39,128512]).
   N = 128512.
?- number_codes(N,[48,39,34]).
   N = 34.
?- number_codes(N,[48,39,96]).
   N = 96.
?- number_codes(N,[48,39,92,92]).
   N = 92.
?- number_chars(01,Chars).
   Chars = "1".
?- number_codes(01,Codes).
   Codes = [49].
?- 1.2 = 1.20.
   true.
?- 1.2 == 1.20.
   true.
?- 1 = 1.0.
   false.
?- number_chars(1.20,C), number_chars(Y,C), 1.20 == Y.
   C = "1.2", Y = 1.2.
`;
        const result = publicApi.runQuads(source);
        assertEqual(result.total, 15, 'quad total');
        assertEqual(result.passed, 15, 'quad passed');
        assertEqual(result.stdout, 'quads: 15 run, 15 passed, 0 failed.\n', 'quad report');

        for (const goal of [
          'number_chars(N,"3/**/")',
          'number_codes(N,[51,47,42,42,47])',
          'number_chars(N,"0\'  ")',
          'number_codes(N,[48,39,32,32])',
        ]) {
          let caught = null;
          try {
            publicApi.run('', { goal });
          } catch (error) {
            caught = error;
          }
          if (caught == null) throw new Error(`${goal} should reject trailing layout`);
          assertIncludes(String(caught?.message ?? caught), 'syntax_error(number)', goal);
        }
      },
    },
    {
      name: 'number conversion uses a bounded number-only scanner',
      run: () => {
        for (const [source, expected] of [
          ['123', '123'], ['-1.25e+3', '-1250.0'], ['0xff', '255'],
          ["0'.", '46'], ["0'😀", '128512'], ["0'\\x21\\", '33'],
        ]) {
          assertEqual(parseNumberTokenText(source).name, expected, source);
        }

        for (let i = 0; i < 500000; i++) {
          const text = String(i);
          assertEqual(parseNumberTokenText(text).name, text, `conversion ${i}`);
        }

        const numberChars = createDefaultRegistry().get('number_chars', 2).handler;
        const converted = variable('Converted');
        for (let i = 0; i < 10000; i++) {
          const text = String(i);
          const chars = listFromItems(Array.from(text, atom));
          const goal = compound('number_chars', [converted, chars]);
          const answer = numberChars({ goal, env: new Env() }).next();
          if (answer.done) throw new Error(`number_chars/2 failed at ${i}`);
          assertEqual(copyResolved(converted, answer.value).name, text, `number_chars/2 conversion ${i}`);
        }
      },
    },
    {
      name: 'read/2 and number_chars/2 agree on bounded numeric syntax (issue #29)',
      run: () => {
        const registry = createDefaultRegistry();
        const numberChars = registry.get('number_chars', 2).handler;
        const read = registry.get('read', 2).handler;
        const solver = new Solver(Program.parse(''), { registry, ioOptions: { input: '' } });
        const stream = solver.io.resolve(0);
        const streamTerm = compound('$stream', [numberTerm('0')]);
        const alphabet = ['0', '1', '2', '7', '8', '9', 'a', 'f', 'x', 'e', 'E', '+', '-', '.', "'", '\\', ' '];
        let checked = 0;
        let accepted = 0;

        const visit = (prefix, remaining) => {
          if (remaining === 0) {
            checked++;
            const converted = variable('Converted');
            const conversionGoal = compound('number_chars', [
              converted,
              listFromItems(Array.from(prefix, atom)),
            ]);
            let conversion;
            try {
              conversion = numberChars({ goal: conversionGoal, env: new Env() }).next();
            } catch (_) {
              return;
            }
            if (conversion.done) return;
            accepted++;
            const expected = copyResolved(converted, conversion.value);

            stream.content = `${prefix}. `;
            stream.position = 0;
            stream.pastEnd = false;
            const readValue = variable('ReadValue');
            const readGoal = compound('read', [streamTerm, readValue]);
            const answer = read({ solver, goal: readGoal, env: new Env() }).next();
            if (answer.done) throw new Error(`read/2 rejected number_chars/2 spelling ${JSON.stringify(prefix)}`);
            const actual = copyResolved(readValue, answer.value);
            assertEqual(actual.type, 'number', `read/2 type for ${JSON.stringify(prefix)}`);
            assertEqual(actual.name, expected.name, `read/2 value for ${JSON.stringify(prefix)}`);
            return;
          }
          for (const character of alphabet) visit(prefix + character, remaining - 1);
        };

        for (let length = 1; length <= 4; length++) visit('', length);
        assertEqual(checked, 88740, 'bounded numeric spellings checked');
        if (accepted < 1000) throw new Error(`unexpectedly small accepted numeric corpus: ${accepted}`);
      },
    },
    {
      name: 'number_chars/2 to read/2 cross-check stays bounded under a small heap (issue #29)',
      run: () => {
        const engineUrl = new URL('../src/index.js', import.meta.url).href;
        const script = `
          import {
            Program, Solver, Env, atom, compound, variable, listFromItems,
            numberTerm, copyResolved, createDefaultRegistry,
          } from ${JSON.stringify(engineUrl)};
          const registry = createDefaultRegistry();
          const numberChars = registry.get('number_chars', 2).handler;
          const read = registry.get('read', 2).handler;
          const solver = new Solver(Program.parse(''), { registry, ioOptions: { input: '' } });
          const stream = solver.io.resolve(0);
          const streamTerm = compound('$stream', [numberTerm('0')]);
          for (let i = 0; i < 250000; i++) {
            const text = String(i);
            const converted = variable('Converted');
            const conversionGoal = compound('number_chars', [
              converted,
              listFromItems(Array.from(text, atom)),
            ]);
            const conversion = numberChars({ goal: conversionGoal, env: new Env() }).next();
            if (conversion.done) throw new Error('number_chars/2 failed at ' + i);
            const expected = copyResolved(converted, conversion.value);

            stream.content = text + '. ';
            stream.position = 0;
            stream.pastEnd = false;
            const readValue = variable('ReadValue');
            const readGoal = compound('read', [streamTerm, readValue]);
            const answer = read({ solver, goal: readGoal, env: new Env() }).next();
            if (answer.done) throw new Error('read/2 failed at ' + i);
            const actual = copyResolved(readValue, answer.value);
            if (actual.type !== 'number' || actual.name !== expected.name) {
              throw new Error('number mismatch at ' + i + ': ' + actual.name + ' != ' + expected.name);
            }
          }
          process.stdout.write('250000');
        `;
        const result = spawnSync(process.execPath, [
          '--max-old-space-size=32',
          '--input-type=module',
          '--eval',
          script,
        ], { cwd: packageRoot, encoding: 'utf8', timeout: 30000 });
        if (result.error) throw result.error;
        assertEqual(result.status, 0, `bounded-heap child status; stderr=${result.stderr}`);
        assertEqual(result.stdout, '250000', 'number_chars/read cross-check count');
      },
    },
    {
      name: '--goal without an input file does not block on an interactive stdin',
      run: () => {
        // Usage documents the input file as optional.  The CLI used to append
        // '-' unconditionally, so `eyeprolog --goal G` on a terminal waited for
        // an EOF that never came and appeared to do nothing.  stdin is only a
        // default source when it is actually redirected.
        assertEqual(defaultsToStdin(0, true), false, 'tty stdin, no file');
        assertEqual(defaultsToStdin(0, false), true, 'redirected stdin, no file');
        assertEqual(defaultsToStdin(0, undefined), true, 'non-tty stdin reported as undefined');
        assertEqual(defaultsToStdin(1, true), false, 'tty stdin, one file');
        assertEqual(defaultsToStdin(1, false), false, 'redirected stdin, one file');

        // An empty database is still a usable program for --goal.
        const result = runCli(['--goal', 'X = 1, write(X), nl'], { input: '' });
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stdout, '1\n', 'goal output without an input file');
      },
    },
    {
      name: 'float literals canonicalize to their represented value and mix with generated floats (issue #92)',
      run: () => {
        const result = runCli([], {
          input:
            'N=1.0000000000000001, number_chars(N,Chs), number_chars(M,Chs).\n' +
            'N=1.0000000000000001, M is N*1.0, M == N.\n' +
            'X=3.2, Y is 3.2, X == Y.\n' +
            'halt.\n',
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout,
          '?-    N = 1.0, Chs = "1.0", M = 1.0.\n' +
          '?-    N = 1.0, M = 1.0.\n' +
          '?-    X = 3.2, Y = 3.2.\n' +
          '?- ',
          'canonical float answers');
        assertEqual(parseNumberTokenText('1.0000000000000001').name, '1.0', 'rounded literal spelling');
        assertEqual(numberTextFromDouble(3.2), '3.2', 'canonical generated spelling');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'call/1 reports the instantiated complete control-term culprit (issue #93)',
      run: () => {
        const result = runCli([], {
          input: 'X = 3, Y = (write(X), X), call(Y).\nhalt.\n',
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout,
          '?-    error(type_error(callable, (write(3), 3)), eyeprolog).\n' +
          '?- ',
          'fully instantiated call/1 culprit');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'number_chars and number_codes keep exponent floats syntactically readable (issue #50)',
      run: () => {
        const source = `
?- number_chars(1.0e-8,Cs).
   Cs = "1.0e-8".
?- number_chars(N,"1.0e-8"), number_chars(N,Cs).
   N = 1.0e-8, Cs = "1.0e-8".
?- number_codes(N,[49,46,48,101,45,56]), number_codes(N,Codes).
   N = 1.0e-8, Codes = [49,46,48,101,45,56].
`;
        const result = publicApi.runQuads(source);
        assertEqual(result.total, 3, 'quad total');
        assertEqual(result.passed, 3, 'quad passed');
        assertEqual(result.failed, 0, 'quad failed');

        const generated = numberTerm(numberTextFromDouble(1e-8));
        assertEqual(generated.name, '1.0e-8', 'generated float spelling');
        assertEqual(parseNumberTokenText(generated.name).name, '1.0e-8', 'generated spelling parses as a float');

        for (const value of [1e-8, -1e-8, 1e20, 1e21, Number.MIN_VALUE, Number.MAX_VALUE]) {
          const text = numberTextFromDouble(value);
          if (/[eE]/.test(text)) {
            assertEqual(/^-?\d+\.\d+[eE][+-]?\d+$/.test(text), true, `exponent float syntax ${text}`);
          }
          assertEqual(Number(parseNumberTokenText(text).name), value, `generated float round-trip ${text}`);
        }
      },
    },
    {
      name: 'number syntax and number_chars normalize floating-point negative zero',
      run: () => {
        const result = runCli([], {
          input: 'X = -0.0, number_chars(X,C), number_chars(Y,C), X == Y, number_chars(Y,D).\nhalt.\n',
        });
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stdout, 'X = 0.0, C = "0.0", Y = 0.0, D = "0.0".', 'answer');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'arithmetic and float-token underflow both round to zero (issue #56)',
      run: () => {
        assertEqual(run('', { goal: 'N is 0.1*10** -999' }).stdout, '0.0 is 0.1 * 10 ** -999.\n', 'operation underflow');
        assertEqual(run('', { goal: 'N is exp(-1000.0)' }).stdout, '0.0 is exp(-1000.0).\n', 'function underflow');
        assertEqual(run('', { goal: 'N = 0.1e-999' }).stdout, '0.0 = 0.0.\n', 'float-token input underflow');
      },
    },
    {
      name: 'float literals reject overflow and normalize underflow (issue #54)',
      run: () => {
        const result = runCli([], {
          input: [
            'T = 1.0e-99999, F is T.',
            'T = 1.0e99999, float(T).',
            'T = -1.0e99999, float(T).',
            'T = 1.0e99999, float(T), F is T.',
            'T = 1.0e99999, U = 2.0e99999, T > U.',
            'T = 1.0e99999, U = 2.0e99999, T < U.',
            'T = 1.0e99999, U = 2.0e99999, T = U.',
            'T = 1.0e99999, U = 2.0e99999, T =:= U.',
            'halt.',
            '',
          ].join('\n'),
        });
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stdout, 'T = 0.0, F = 0.0.', 'underflow rounds on input');
        assertEqual(
          (result.stdout.match(/error\(representation_error\(max_float\)\)\./g) ?? []).length,
          6,
          'positive overflowing literals fail while being read',
        );
        assertEqual(
          (result.stdout.match(/error\(representation_error\(min_float\)\)\./g) ?? []).length,
          1,
          'negative overflowing literal reports min_float',
        );
        assertEqual(result.stderr, '', 'stderr');

        let overflow = null;
        try {
          parseNumberTokenText('1.0e99999');
        } catch (error) {
          overflow = error;
        }
        assertEqual(overflow?.formal, 'representation_error(max_float)', 'positive number token overflow');
        let negativeOverflow = null;
        try {
          parseNumberTokenText('-1.0e99999');
        } catch (error) {
          negativeOverflow = error;
        }
        assertEqual(negativeOverflow?.formal, 'representation_error(min_float)', 'negative number token overflow');
        assertEqual(parseNumberTokenText('1.0e-99999').name, '0.0', 'number token underflow');

        const chars = Array.from('1.0e99999', atom);
        const numberChars = createDefaultRegistry().get('number_chars', 2).handler;
        let numberCharsError = null;
        try {
          numberChars({
            goal: compound('number_chars', [variable('N'), listFromItems(chars)]),
            env: new Env(),
          }).next();
        } catch (error) {
          numberCharsError = error;
        }
        assertEqual(numberCharsError?.formal, 'representation_error(max_float)', 'number_chars positive overflow');

        const negativeChars = Array.from('-1.0e99999', atom);
        let negativeNumberCharsError = null;
        try {
          numberChars({
            goal: compound('number_chars', [variable('N'), listFromItems(negativeChars)]),
            env: new Env(),
          }).next();
        } catch (error) {
          negativeNumberCharsError = error;
        }
        assertEqual(negativeNumberCharsError?.formal, 'representation_error(min_float)', 'number_chars negative overflow');

        let boundNegativeNumberCharsError = null;
        try {
          numberChars({
            goal: compound('number_chars', [numberTerm('-1.0e99999'), variable('Chars')]),
            env: new Env(),
          }).next();
        } catch (error) {
          boundNegativeNumberCharsError = error;
        }
        assertEqual(
          boundNegativeNumberCharsError?.formal,
          'representation_error(min_float)',
          'number_chars host-created negative overflow',
        );

        let readError = null;
        try {
          runEyeProlog('', {
            goal: 'read(X)',
            ioOptions: { input: '1.0e99999.\n' },
          });
        } catch (error) {
          readError = error;
        }
        assertEqual(readError?.formal, 'representation_error(max_float)', 'read/1 overflow');

        let readTermError = null;
        try {
          runEyeProlog('', {
            goal: 'read_term(X, [])',
            ioOptions: { input: '-1.0e99999.\n' },
          });
        } catch (error) {
          readTermError = error;
        }
        assertEqual(readTermError?.formal, 'representation_error(min_float)', 'read_term/2 overflow (STC #73)');

        const numberCodes = createDefaultRegistry().get('number_codes', 2).handler;
        let numberCodesError = null;
        try {
          numberCodes({
            goal: compound('number_codes', [variable('N'), listFromItems(Array.from('1.0e99999', (c) => numberTerm(String(c.codePointAt(0))))) ]),
            env: new Env(),
          }).next();
        } catch (error) {
          numberCodesError = error;
        }
        assertEqual(numberCodesError?.formal, 'representation_error(max_float)', 'number_codes positive overflow (STC #74)');

        const isHandler = createDefaultRegistry().get('is', 2).handler;
        let hostTermError = null;
        try {
          isHandler({
            goal: compound('is', [variable('F'), numberTerm('1.0e99999')]),
            env: new Env(),
          }).next();
        } catch (error) {
          hostTermError = error;
        }
        assertEqual(hostTermError?.formal, 'evaluation_error(float_overflow)', 'host-created non-finite term');
      },
    },
    {
      name: 'mixed integer/float arithmetic comparison preserves exact order (STC #50)',
      run: () => {
        const hugeInteger = `1${'0'.repeat(309)}`;
        const program = `
          check :-
            9007199254740993 > 9007199254740992.0,
            9007199254740992.0 < 9007199254740993,
            9007199254740993 =\\= 9007199254740992.0,
            -9007199254740993 < -9007199254740992.0,
            ${hugeInteger} > 1.0e308,
            -${hugeInteger} < -1.0e308,
            Max is max(9007199254740993, 9007199254740992.0),
            integer(Max),
            Max =:= 9007199254740993,
            Min is min(9007199254740993, 9007199254740992.0),
            float(Min),
            Min =:= 9007199254740992.0.
        `;
        const result = runEyeProlog(program, { goal: 'check' });
        assertEqual(result.stdout, 'check.\n', 'mixed integer/float ordering');
      },
    },
    {
      name: 'readers keep a full stop inside a character-code constant (WG17 #367)',
      run: () => {
        const streamResult = runEyeProlog('', {
          goal: 'read((46 = 46))',
          ioOptions: { input: "X = 0'. .\n" },
        });
        assertEqual(streamResult.stdout, 'read(46 = 46).\n', 'read/1 character-code full stop');

        // A complete term must be recognized from its full stop alone. Do not
        // consult the interactive refill hook (which would amount to waiting
        // for EOF or another line) once the terminator has been seen.
        const program = Program.parse('');
        const solver = new Solver(program, {
          registry: getEyePrologRegistry(),
          ioOptions: { input: "X = 0'. .\n" },
        });
        const inputStream = solver.io.resolve('user_input');
        let refillRequests = 0;
        inputStream.interactiveReadTerm = () => {
          refillRequests++;
          throw new Error('reader requested input after a complete term');
        };
        const readGoal = parseGoalText('read(T)', { operatorDefinitions: [...program.operators.values()] });
        const readAnswers = [...solver.solve([readGoal], new Env(), 0)];
        assertEqual(readAnswers.length, 1, 'read/1 answer without EOF');
        assertEqual(refillRequests, 0, 'read/1 terminates without EOF assistance');
        const readTerm = copyResolved(readGoal.args[0], readAnswers[0]);
        assertEqual(readTerm.name, '=', 'read/1 parsed assignment');
        assertEqual(readTerm.args[1].name, '46', 'read/1 parsed character code');

        const cliResult = runCli([], { input: "X = 0'. .\nhalt.\n" });
        assertEqual(cliResult.status, 0, 'top-level character-code full stop status');
        assertIncludes(cliResult.stdout, 'X = 46', 'top-level character-code answer');
        assertNotIncludes(cliResult.stdout, 'syntax_error', 'top-level character-code syntax');

        const upstreamResult = runCli([], { input: "writeq(0'. ).\nhalt.\n" });
        assertEqual(upstreamResult.status, 0, 'WG17 #367 exit status');
        assertIncludes(upstreamResult.stdout, '46 true.', 'WG17 #367 output');
      },
    },
    {
      name: 'top level separates terminal full stop from graphic answers (issue #44)',
      run: () => {
        const result = runCli([], { input: 'X = .* .\nhalt.\n' });
        assertEqual(result.status, 0, 'issue #44 exit status');
        assertIncludes(result.stdout, 'X = .* .\n', 'graphic binding is separated from terminal full stop');
        assertNotIncludes(result.stdout, 'X = .*.\n', 'terminal full stop is not absorbed into graphic atom');
        assertEqual(result.stderr, '', 'issue #44 stderr');
      },
    },
    {
      name: 'writeq leaves ISO dotted graphic atoms unquoted (WG17 #371-373)',
      run: () => {
        const result = runCli([], {
          input: 'writeq(./*).\nwriteq(.*).\nwriteq(...*).\nhalt.\n',
        });
        assertEqual(result.status, 0, 'dotted graphic writeq exit status');
        assertIncludes(result.stdout, '  ./* true.\n', 'writeq ./* is unquoted');
        assertIncludes(result.stdout, '  .* true.\n', 'writeq .* is unquoted');
        assertIncludes(result.stdout, '  ...* true.\n', 'writeq ...* is unquoted');
        assertNotIncludes(result.stdout, "'./*'", 'writeq ./* has no quotes');
        assertNotIncludes(result.stdout, "'.*'", 'writeq .* has no quotes');
        assertNotIncludes(result.stdout, "'...*'", 'writeq ...* has no quotes');
      },
    },
    {
      name: 'readers distinguish graphic tokens, comments, and full stops (issue #41)',
      run: () => {
        const parsed = parseProgramText('./* .');
        assertEqual(parsed.length, 1, 'graphic atom clause count');
        assertEqual(parsed[0].head.name, './*', 'comment opener stays inside graphic atom');

        // A dot immediately after a graphic token belongs to that maximal
        // token. A separate end char is therefore required even at a line
        // boundary; this is the waiting behavior called out in WG17 #370-373.
        const waitProgram = Program.parse('');
        const waitSolver = new Solver(waitProgram, {
          registry: getEyePrologRegistry(),
          ioOptions: { input: '*.\n' },
        });
        const waitStream = waitSolver.io.resolve('user_input');
        let refillRequests = 0;
        waitStream.interactiveReadTerm = () => {
          refillRequests++;
          return '.\n';
        };
        const waitGoal = parseGoalText('read(T)', {
          operatorDefinitions: [...waitProgram.operators.values()],
        });
        const waitAnswers = [...waitSolver.solve([waitGoal], new Env(), 0)];
        assertEqual(waitAnswers.length, 1, 'graphic token read answer after refill');
        assertEqual(refillRequests, 1, 'graphic token boundary waits for a separate end char');
        assertEqual(copyResolved(waitGoal.args[0], waitAnswers[0]).name, '*.', 'maximal graphic token after refill');

        const read = runEyeProlog('', {
          goal: 'read(T)',
          ioOptions: { input: './*. .' },
        });
        assertEqual(read.stdout, "read(./*.).\n", 'dotted graphic atom writeq readback');

        const ellipsisGraphic = runEyeProlog('', {
          goal: 'read(T)',
          ioOptions: { input: '...*\n.\n' },
        });
        assertEqual(ellipsisGraphic.stdout, "read(...*).\n", 'ellipsis prefix remains inside maximal graphic atom');

        const consecutive = runEyeProlog('answer(A, B) :- read(A), read(B).\n', {
          goal: 'answer(A, B)',
          ioOptions: { input: './*. .\nok.\n' },
        });
        assertEqual(consecutive.stdout, "answer(./*., ok).\n", 'following read starts after the complete term');

        // Issue #41 follow-up: read/1 consumes an ordinary term, not a program
        // clause head. A comma chain therefore has no program-level two-comma
        // limit, and source operators such as :- and ?- remain term data.
        const commaChain = runEyeProlog('', {
          goal: 'read(T)',
          ioOptions: { input: '!,!,! .\n' },
        });
        assertEqual(commaChain.stdout, 'read((!, !, !)).\n', 'three-element comma term');

        const ruleAsData = runEyeProlog('', {
          goal: 'read(T)',
          ioOptions: { input: 'a :- b.\n' },
        });
        assertEqual(ruleAsData.stdout, 'read((a :- b)).\n', 'rule operator remains term data');

        const queryAsData = runEyeProlog('', {
          goal: 'read(T)',
          ioOptions: { input: '?- foo.\n' },
        });
        assertEqual(queryAsData.stdout, 'read((?- foo)).\n', 'query operator remains term data');

        // A possible full stop can fail to complete the term while still
        // extending a current graphic operator into an ordinary atom.  The
        // later standalone full stop then completes the read term.  Exercise
        // every predefined graphic operator, including the tokenizer's
        // special :- and ?- cases, so they cannot diverge from * again.
        const graphicOperator = /^[#$&*+\-./<=>?@^~\\:]+$/;
        const graphicOperators = [...new Set(ISO_OPERATOR_DEFINITIONS.map(([, , name]) => name))]
          .filter((name) => graphicOperator.test(name));
        for (const name of graphicOperators) {
          const program = Program.parse('');
          const solver = new Solver(program, {
            registry: getEyePrologRegistry(),
            ioOptions: { input: `!,${name}.\n.\n` },
          });
          const readGoal = parseGoalText('read(T)', {
            operatorDefinitions: [...program.operators.values()],
          });
          const answers = [...solver.solve([readGoal], new Env(), 0)];
          assertEqual(answers.length, 1, `graphic operator read answer for ${name}`);
          const term = copyResolved(readGoal.args[0], answers[0]);
          assertEqual(term.name, ',', `graphic operator conjunction for ${name}`);
          assertEqual(term.args[0].name, '!', `graphic operator left operand for ${name}`);
          assertEqual(term.args[1].name, `${name}.`, `graphic operator atom for ${name}`);
        }

        // Unlike an interactive reader waiting at a line boundary, a buffered
        // stream can see later non-layout input.  Its first dot therefore
        // remains in the maximal graphic token, making the adjacent ! invalid
        // rather than prematurely returning the shorter atom.
        for (const name of [...graphicOperators, '?', '#', '@', './*', '//*']) {
          let bufferedError = null;
          try {
            runEyeProlog('', {
              goal: 'read_term(T, [])',
              ioOptions: { input: `${name}.\n!\n.` },
            });
          } catch (caught) {
            bufferedError = caught;
          }
          assertEqual(
            bufferedError?.message,
            'error(syntax_error(read_term))',
            `buffered graphic atom boundary for ${name}`,
          );
        }

        const bufferedPath = path.join(tmp, 'graphic-atom-boundary.pl');
        fs.writeFileSync(bufferedPath, '*.\n!\n.');
        const namedStream = runEyeProlog([
          `caught(ok) :- open(${sourceAtom(bufferedPath)}, read, S),`,
          '  catch(read_term(S, _, []), error(syntax_error(read_term), _), true),',
          '  close(S).',
          '',
        ].join('\n'), { goal: 'caught(ok)' });
        assertEqual(namedStream.stdout, 'caught(ok).\n', 'named buffered stream syntax error');

        let error = null;
        try {
          runEyeProlog('', { goal: 'read(T)', ioOptions: { input: '!.!.' } });
        } catch (caught) {
          error = caught;
        }
        assertEqual(error?.message, 'error(syntax_error(read_term))', 'solo-token sequence rejection');

        const repl = runCli([], {
          input: 'read(T).\n./*. .\nread(T).\nok.\nread(T).\n!.!.\nhalt.\n',
        });
        assertEqual(repl.status, 0, 'REPL exit status');
        assertIncludes(repl.stdout, 'T = ./*. .', 'REPL dotted graphic atom answer');
        assertNotIncludes(repl.stdout, "T = './*.'", 'REPL dotted graphic atom has no spurious quotes');
        assertIncludes(repl.stdout, 'T = ok.', 'REPL following read answer');
        assertIncludes(repl.stdout, 'error(syntax_error(read_term), eyeprolog)', 'REPL syntax error');
        assertEqual(repl.stderr, '', 'REPL stderr');

        const continuedGraphic = runCli([], {
          input: 'read(T).\n!,*.\n.\nread(T).\na\n.\nhalt.\n',
        });
        assertEqual(continuedGraphic.status, 0, 'continued graphic operator REPL status');
        assertIncludes(continuedGraphic.stdout, 'T = (!,*.).', 'continued graphic operator answer');
        assertIncludes(continuedGraphic.stdout, 'T = a.', 'read after continued graphic operator');
        assertNotIncludes(continuedGraphic.stdout, 'syntax_error', 'continued graphic operator syntax');
        assertEqual(continuedGraphic.stderr, '', 'continued graphic operator REPL stderr');
      },
    },
    {
      name: 'question mark is a graphic character and writeq keeps graphic atoms unquoted',
      run: () => {
        const result = runCli([], { input: 'writeq(?).\nwriteq(??).\nwriteq(?-).\nhalt.\n' });
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stdout, '? true.', 'writeq(?)');
        assertIncludes(result.stdout, '?? true.', 'writeq(??)');
        assertIncludes(result.stdout, '?- true.', 'writeq(?-)');
        assertNotIncludes(result.stdout, "'?-'", 'writeq(?-) has no quotes');
      },
    },
    {
      name: 'curly brackets accept ISO and custom operator atoms (issue #41)',
      run: () => {
        const operatorNames = [...new Set(ISO_OPERATOR_DEFINITIONS.map(([, , name]) => name))]
          .filter((name) => name !== ',');
        for (const name of operatorNames) {
          const holder = parseGoalText(`holder({${name}})`);
          const curly = holder.args[0];
          assertEqual(curly.name, '{}', `curly functor for ${name}`);
          assertEqual(curly.args[0].name, name, `curly operator atom ${name}`);
        }

        const customProgram = parseProgramText([
          ':- op(100, fx, pre).',
          ':- op(100, xf, post).',
          ':- op(100, xfx, infix).',
          'custom({pre}, {post}, {infix}).',
          '',
        ].join('\n'));
        const custom = customProgram.find((clause) => clause.head.name === 'custom').head;
        assertEqual(
          custom.args.map((curly) => curly.args[0].name).join(','),
          'pre,post,infix',
          'custom prefix, postfix, and infix operator atoms',
        );

        const repl = runCli([], { input: 'read(T).\n{*}.\nhalt.\n' });
        assertEqual(repl.status, 0, 'curly operator REPL status');
        assertIncludes(repl.stdout, 'T = {*}.', 'curly operator REPL answer');
        assertNotIncludes(repl.stdout, '{(*)}', 'curly operator has no unnecessary parentheses');
      },
    },
    {
      name: 'normal parser rejects non-conforming bare operator operands',
      run: () => {
        let caught = null;
        try {
          parseGoalText('write_canonical((- = - 1))');
        } catch (error) {
          caught = error;
        }
        if (!caught) throw new Error('non-conforming operator operand unexpectedly parsed');
        assertIncludes(caught.message, 'operator atom', 'syntax rejection');
      },
    },
    {
      name: 'ISO predicate indicators require parentheses around bare operator atoms',
      run: () => {
        // Bare --> /2 (without parens) is still rejected in all modes because
        // --> is an infix/prefix operator atom that cannot appear as a bare operand.
        let caught = null;
        try {
          parseGoalText('writeq(--> /2)');
        } catch (error) {
          caught = error;
        }
        if (!caught) throw new Error('bare operator predicate indicator unexpectedly parsed');
        assertIncludes(caught.message, 'operator atom', 'bare indicator syntax rejection');
        // (-->)/2 with parentheses is legal in both normal and strict ISO modes.
        // Neumerkel #379: upstream Codex expectation is (-->)/2 -> (-->)/2 (success).
        // Parentheses make --> an ordinary atom argument; ISO 7.10.3 does not
        // restrict which atoms may appear as the name in a Name/Arity indicator.
        parseGoalText('writeq((-->)/2)');
        assertEqual(
          run('', { goal: 'writeq((-->)/2)' }).stdout,
          '(-->)/2writeq((-->) / 2).\n',
          'parenthesized operator indicator stays legal outside strict ISO',
        );
        parseGoalText('writeq((-->)/2)', { isoStrict: true });
        assertEqual(
          run('', { isoStrict: true, goal: 'writeq((-->)/2)' }).stdout,
          '(-->)/2writeq((-->) / 2).\n',
          'Neumerkel #379: parenthesized --> is legal in strict ISO',
        );
      },
    },
    {
      name: 'CLP(Z) operator declarations avoid unnecessary quoted atoms',
      run: () => {
        const filename = path.join(packageRoot, 'src', 'lib', 'clpz.pl');
        const source = fs.readFileSync(filename, 'utf8');
        for (const name of ['#>', '#<', '#>=', '#=<', '#=', '#\\=', '#<==>', '#==>', '#<==', '#\\/', '#/\\']) {
          assertIncludes(source, `(${name})/2`, `${name}/2 export is parenthesized`);
          assertNotIncludes(source, `('${name}')/2`, `${name}/2 export is not quoted`);
          assertNotIncludes(source, `'${name}'(`, `${name} functional notation is not quoted`);
        }
        assertIncludes(source, '(#\\)/1', '#\\/1 export is parenthesized');
        assertIncludes(source, '(#\\)/2', '#\\/2 export is parenthesized');
        assertIncludes(source, '(in)/2', 'in/2 export is parenthesized');
        assertIncludes(source, '(ins)/2', 'ins/2 export is parenthesized');
        assertNotIncludes(source, "('in')/2", 'in/2 export is not quoted');
        assertNotIncludes(source, "('ins')/2", 'ins/2 export is not quoted');

        const canonicalOptions = { quoted: true, ignoreOps: true, compact: true, operators: [] };
        assertEqual(
          formatTermForWrite(compound('#>', [atom('a'), atom('b')]), new Env(), canonicalOptions),
          '#>(a,b)',
          'canonical #> functor has no quotes',
        );
        assertEqual(
          formatTermForWrite(compound('#\\=', [atom('a'), atom('b')]), new Env(), canonicalOptions),
          '#\\=(a,b)',
          'canonical #\\= functor has no quotes',
        );
      },
    },
    {
      name: 'layout distinguishes prefix notation from functional notation',
      run: () => {
        const functional = parseGoalText(String.raw`\+(true, false)`);
        assertEqual(functional.name, '\\+', 'functional name');
        assertEqual(functional.arity, 2, 'adjacent functional arity');

        const prefix = parseGoalText(String.raw`\+ (true, false)`);
        assertEqual(prefix.name, '\\+', 'prefix name');
        assertEqual(prefix.arity, 1, 'spaced prefix arity');
        assertEqual(prefix.args[0].name, ',', 'prefix parenthesized conjunction');
        assertEqual(prefix.args[0].arity, 2, 'prefix conjunction arity');

        const result = runEyeProlog('', { goal: String.raw`\+ (true, false)` });
        assertEqual(result.stdout, '\\+ (true, false).\n', 'spaced negation result');
      },
    },
    {
      name: 'number conversion rejects parenthesized numeric terms',
      run: () => {
        for (const goal of ['number_chars(N,"(0)")', 'number_codes(N,[40,48,41])']) {
          let caught = null;
          try {
            publicApi.run('', { goal });
          } catch (error) {
            caught = error;
          }
          if (caught == null) throw new Error(`${goal} should throw`);
          assertIncludes(String(caught?.message ?? caught), 'syntax_error(number)', goal);
        }
      },
    },
    {
      name: 'vendored Prolog Prologue corpus records the bounded=false max_integer divergence',
      run: () => {
        const filename = path.join(testRoot, 'fixtures', 'prologue_quad_runner.pl');
        const source = fs.readFileSync(filename, 'utf8');
        const program = Program.parseSources([{
          text: source,
          filename,
          baseDir: path.dirname(filename),
        }]);
        assertEqual(program.quads.length, 33, 'vendored quad total');
        const maxIntegerQuads = program.quads.filter(({ query }) =>
          termToString(query).includes('current_prolog_flag(max_integer, Max)'));
        assertEqual(maxIntegerQuads.length, 1, 'max_integer quad count');

        // This regression is about the one deliberate ISO divergence in the
        // upstream Prologue fixture. Running all 33 records also explores two
        // intentionally non-terminating STO examples and used to dominate the
        // regression suite by several seconds, without adding evidence for
        // max_integer. Keep the full vendored corpus intact, but execute only
        // the relevant record here.
        program.quads = maxIntegerQuads;
        const result = publicApi.runQuads(program);
        // The upstream working-draft quad accepts either integer overflow or
        // Max=unbounded. ISO/IEC 13211-1 7.11.1.1 instead says that when
        // bounded=false, current_prolog_flag(max_integer, N) fails. Preserve
        // the upstream fixture unchanged and make that one deliberate
        // standards-driven divergence explicit in the regression gate.
        assertEqual(result.total, 1, 'quad total');
        assertEqual(result.passed, 0, 'quad passed');
        assertEqual(result.failed, 1, 'quad failed');
        assertIncludes(result.stdout, 'current_prolog_flag(max_integer, Max)', 'max_integer divergence');
        assertIncludes(result.stdout, 'quads: 1 run, 0 passed, 1 failed.', 'quad report');
      },
    },
    {
      name: 'runQuads passes the authoritative Prologue call_nth quad corpus',
      run: () => {
        const filename = path.join(testRoot, 'fixtures', 'prologue_call_nth_quad_runner.pl');
        const source = fs.readFileSync(filename, 'utf8');
        const result = publicApi.runQuads(Program.parseSources([{
          text: source,
          filename,
          baseDir: path.dirname(filename),
        }]));
        assertEqual(result.total, 13, 'quad total');
        assertEqual(result.passed, 13, 'quad passed');
        assertEqual(result.stdout, 'quads: 13 run, 13 passed, 0 failed.\n', 'quad report');
      },
    },
    {
      name: 'CLI passes the complete authoritative length quad corpus',
      run: () => {
        const filename = path.join(testRoot, 'fixtures', 'length_quad.pl');
        const source = fs.readFileSync(filename, 'utf8');
        assertEqual(Program.parse(source).quads.length, 37, 'vendored quad total');
        const result = runCli(['-q', filename]);
        assertEqual(result.status, 0, 'quad exit status');
        assertEqual(result.stdout, 'quads: 37 run, 37 passed, 0 failed.\n', 'quad report');
        assertEqual(result.stderr, '', 'quad stderr');
      },
    },
    {
      name: 'CLI passes the complete authoritative variable_names quad corpus (issue #69)',
      run: () => {
        const filename = path.join(testRoot, 'fixtures', 'variable_names_quad.pl');
        const source = fs.readFileSync(filename, 'utf8');
        assertEqual(Program.parse(source).quads.length, 74, 'vendored query-record total');
        const result = runCli(['-q', filename], { cwd: tmp });
        assertEqual(result.status, 0, 'quad exit status');
        assertEqual(result.stdout, 'quads: 75 run, 75 passed, 0 failed.\n', 'quad report');
        assertEqual(result.stderr, '', 'quad stderr');
      },
    },
    {
      name: 'REPL advances anonymous Prologue length checks through I = 28',
      run: () => {
        const result = runCli([], {
          input:
            'use_module(library(prologue)).\n' +
            'length(_,I),I>9,N is 2^I,\\+ \\+ length(_,N).\n' +
            'f\nf\nf\n;\n;\n;\n;\n\nhalt.\n',
        });
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stdout, ';  I = 28, N = 268435456\n;  ... .\n?- ', 'large anonymous length answer');
        assertNotIncludes(result.stdout, 'resource_error(memory)', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'Prologue freeze wakes delayed goals with their bindings',
      run: () => {
        const result = runEyeProlog(
          ':- use_module(library(prologue)).\nwake(X, Y) :- freeze(X, Y = awake), X = ready.\n',
          { goal: 'wake(X, Y)' },
        );
        assertEqual(result.stdout, 'wake(ready, awake).\n', 'freeze answer');
      },
    },
    {
      name: 'Prologue freeze keeps awakened cuts inside the delayed call (issue #81)',
      run: () => {
        const result = publicApi.runQuads(`:- use_module(library(prologue)).
38
?- call( ( (Y=1;Y=2), freeze(X,!), X = c ) ); Y = 3.
   Y = 1, X = c
;  Y = 2, X = c
;  Y = 3.
`);
        assertEqual(result.total, 1, 'quad total');
        assertEqual(result.passed, 1, 'quad passed');
        assertEqual(result.failed, 0, 'quad failed');
        assertEqual(result.stdout, 'quads: 1 run, 1 passed, 0 failed.\n', 'quad report');
      },
    },
    {
      name: 'Prologue freeze keeps multiple delayed goals in separate cut scopes (issue #84)',
      run: () => {
        const result = publicApi.runQuads(`:- use_module(library(prologue)).
39
?- freeze(X,(Y=1;Y=2)), freeze(X,!), X = c ; X=end.
   X = c, Y = 1
;  X = end, unexpected.
   X = c, Y = 1
;  X = c, Y = 2
;  X = end.
`);
        assertEqual(result.total, 2, 'quad total');
        assertEqual(result.passed, 2, 'quad passed');
        assertEqual(result.failed, 0, 'quad failed');
        assertEqual(result.stdout, 'quads: 2 run, 2 passed, 0 failed.\n', 'quad report');

        const residuals = runCli([], {
          input:
            'use_module(library(freeze)).\n' +
            'freeze(X,(Y=1;Y=2)), freeze(X,!).\n' +
            'halt.\n',
        });
        assertEqual(residuals.status, 0, 'freeze residual display status');
        assertEqual(residuals.stdout,
          '?-    true.\n' +
          '?-    freeze:freeze(X, (Y=1;Y=2)), freeze:freeze(X, !).\n' +
          '?- ',
          'multiple freeze/2 residuals stay separate');
        assertEqual(residuals.stderr, '', 'freeze residual display stderr');
      },
    },
    {
      name: 'freeze suspension merging stays linear while preserving wake order',
      run: () => {
        const count = 64;
        const freezes = Array.from({ length: count }, () => 'freeze(X,true)').join(', ');
        const result = runEyeProlog(
          `:- use_module(library(freeze)).\nbench(X) :- ${freezes}, X = done.\n`,
          { goal: 'bench(X)', solutionLimit: 1 },
        );
        assertEqual(result.stdout, 'bench(done).\n', 'many frozen goals wake successfully');
        if (result.stats.unify_calls > 400) {
          throw new Error(
            `freeze/2 attribute merging used ${result.stats.unify_calls} unifications; expected linear growth`,
          );
        }
      },
    },
    {
      name: 'runQuads covers the remaining finite Prologue examples and arities',
      run: () => {
        const filename = path.join(testRoot, 'fixtures', 'prologue_extended_quad_runner.pl');
        const source = fs.readFileSync(filename, 'utf8');
        const result = publicApi.runQuads(Program.parseSources([{
          text: source,
          filename,
          baseDir: path.dirname(filename),
        }]));
        assertEqual(result.total, 37, 'quad total');
        assertEqual(result.passed, 37, 'quad passed');
        assertEqual(result.stdout, 'quads: 37 run, 37 passed, 0 failed.\n', 'quad report');
      },
    },
    {
      name: 'runQuads maybe requires pending constraints without weakening substitutions (issue #80)',
      run: () => {
        const result = publicApi.runQuads(`37
?- dif(X,Y), X = a.
   true, unexpected.
   X = a, unexpected.
   X = a, maybe.
   maybe, unexpected.

?- X = a.
   X = a, maybe, unexpected.
`);
        assertEqual(result.total, 5, 'quad total');
        assertEqual(result.passed, 5, 'quad passed');
        assertEqual(result.failed, 0, 'quad failed');
        assertEqual(result.stdout, 'quads: 5 run, 5 passed, 0 failed.\n', 'quad report');
      },
    },
    {
      name: 'runQuads rejects malformed answer substitutions',
      run: () => {
        const source = `?- X = f(Y), Y = 1.\n   X = f(Y), Y = 1.\n`;
        const result = publicApi.runQuads(Program.parseSources([{ text: source, filename: 'malformed-quad.pl' }]));
        assertEqual(result.total, 1, 'quad total');
        assertEqual(result.failed, 1, 'quad failed');
        assertIncludes(result.stdout, 'quads: MALFORMED malformed-quad.pl:1', 'malformed report');
      },
    },
    {
      name: 'runQuads recognizes bounded nontermination descriptions',
      run: () => {
        const result = publicApi.runQuads(`?- repeat, fail.\n   loops.\n`);
        assertEqual(result.passed, 1, 'quad passed');
        assertEqual(result.stdout, 'quads: 1 run, 1 passed, 0 failed.\n', 'quad report');
      },
    },
    {
      name: 'runQuads preserves output before a delayed call/1 instantiation error (issue #57)',
      run: () => {
        const result = publicApi.runQuads(`16, "7.8.3.4#9"\n?- call((write(3), X)).\n   outputs("3"), instantiation_error.\n`);
        assertEqual(result.passed, 1, 'quad passed');
        assertEqual(result.stdout, 'quads: 1 run, 1 passed, 0 failed.\n', 'quad report');
      },
    },
    {
      name: 'runQuads recognizes bounded recursive nontermination as loops (issue #58)',
      run: () => {
        const result = publicApi.runQuads(`inf :- inf, inf.\n\n23\n?- inf.\n   loops.\n`);
        assertEqual(result.passed, 1, 'quad passed');
        assertEqual(result.stdout, 'quads: 1 run, 1 passed, 0 failed.\n', 'quad report');
      },
    },
    {
      name: 'quad finite-failure claims stay undecided when recursive search exhausts its budget',
      run: () => {
        const result = publicApi.runQuads(`inf :- inf, inf.

23
?- inf.
   loops.
   false.
`);
        assertEqual(result.total, 2, 'quad total');
        assertEqual(result.passed, 1, 'loops passed');
        assertEqual(result.failed, 0, 'finite failure is not claimed');
        assertEqual(result.undecided, 1, 'bounded recursive search is undecided');
        assertIncludes(result.stdout, 'undecided: inference limit reached.', 'bounded-search diagnostic');
      },
    },
    {
      name: 'quad search-budget exhaustion is undecided rather than loops or failure (issue #58)',
      run: () => {
        const result = runCli(['--quads', '-'], {
          input:
            '24,passes/too_expensive\n' +
            '?- N is 10^9, between(1,N,I), I = 1.\n' +
            '   N = ..., I = 1\n' +
            ';  false.\n',
          timeout: 5000,
        });
        if (result.error) throw result.error;
        assertEqual(result.status, 2, 'undecided exit status');
        assertIncludes(result.stdout,
          'quads: UNDECIDED 24, passes / too_expensive, <stdin>:1',
          'undecided diagnostic');
        assertIncludes(result.stdout, 'undecided: inference limit reached.', 'undecided reason');
        assertIncludes(result.stdout,
          'quads: 1 run, 0 passed, 0 failed, 1 undecided.',
          'undecided summary');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'quad sto uses observed occurs-check evidence instead of unconditional acceptance (issue #60)',
      run: () => {
        const sto = publicApi.runQuads(String.raw`33
?- X = s(X).
   X = ..., unexpected.
   false, unexpected.
   sto, false
|  sto, true.
`);
        assertEqual(sto.total, 3, 'STO description total');
        assertEqual(sto.passed, 3, 'STO descriptions passed');
        assertEqual(sto.failed, 0, 'STO descriptions failed');
        assertEqual(sto.undecided, 0, 'STO descriptions undecided');
        assertEqual(sto.stdout, 'quads: 3 run, 3 passed, 0 failed.\n', 'STO report');

        const nsto = publicApi.runQuads(String.raw`34
?- true.
   sto.
`);
        assertEqual(nsto.total, 1, 'NSTO description total');
        assertEqual(nsto.passed, 0, 'NSTO description passed');
        assertEqual(nsto.failed, 1, 'NSTO description failed');
        assertEqual(nsto.undecided, 0, 'NSTO description undecided');
        assertIncludes(nsto.stdout, 'quads: FAILED 34, <input>:1', 'NSTO diagnostic');
      },
    },
    {
      name: 'quads peeks/1 supplies one unconsumed look-ahead character (issue #62)',
      run: () => {
        const result = publicApi.runQuads(`29
?- read(X).
   inputs("1."), X = 1, unexpected.
   inputs("1."), peeks(" "), X = 1.
   inputs("1. "), peeks(" "), X = 1, unexpected.
`);
        assertEqual(result.total, 3, 'quad total');
        assertEqual(result.passed, 3, 'quad passed');
        assertEqual(result.failed, 0, 'quad failed');
        assertEqual(result.stdout, 'quads: 3 run, 3 passed, 0 failed.\n', 'quad report');
      },
    },
    {
      name: 'outputs/1 accepts DCG bodies over captured characters (issue #59)',
      run: () => {
        const source = [
          'pair --> "_", "A".',
          '22',
          "?- write('_A').",
          '   outputs("_A").',
          '   outputs("_"), unexpected.',
          '   outputs(("_","A")).',
          '   outputs(("_",...,"A")).',
          '   outputs(("_",...,"B")), unexpected.',
          '   outputs(("_",[_],[_])), unexpected.',
          '   outputs(pair).',
          '',
        ].join('\n');
        const result = publicApi.runQuads(source);
        assertEqual(result.total, 7, 'quad total');
        assertEqual(result.passed, 7, 'quad passed');
        assertEqual(result.failed, 0, 'quad failed');
        assertEqual(result.undecided, 0, 'quad undecided');
        assertEqual(result.stdout, 'quads: 7 run, 7 passed, 0 failed.\n', 'quad report');
      },
    },
    {
      name: '--quads runs embedded tests and reports failures through exit status',
      run: () => {
        const passing = runCli(['--quads', '-'], {
          input: `p(ok).\n\nsmoke ?- p(X).\n   X = ok.\n`,
        });
        assertEqual(passing.status, 0, 'passing quad exit status');
        assertEqual(passing.stdout, 'quads: 1 run, 1 passed, 0 failed.\n', 'passing quad stdout');
        assertEqual(passing.stderr, '', 'passing quad stderr');

        const failing = runCli(['-q', '-'], {
          input: `p(actual).\n\nsmoke ?- p(X).\n   X = expected.\n`,
        });
        assertEqual(failing.status, 1, 'failing quad exit status');
        assertIncludes(failing.stdout, 'quads: FAILED smoke, <stdin>:3', 'failing quad report');
        assertIncludes(failing.stdout, 'quads: 1 run, 0 passed, 1 failed.', 'failing quad summary');
        assertEqual(failing.stderr, '', 'failing quad stderr');
      },
    },
    {
      name: 'seeded random/3 sequence is reproducible',
      run: () => {
        const result = run(
          'seeded(A, B, C, Seeds) :- random(1, A, S1), random(S1, B, S2), random(1, C, S3), Seeds = [S1, S2, S3].\n',
          { goal: 'seeded(A, B, C, Seeds)' },
        );
        assertEqual(result.stdout, 'seeded(0.00002247747035927835, 0.0850324487174232, 0.00002247747035927835, [48271, 182605794, 48271]).\n', 'stdout');
      },
    },
    {
      name: 'seeded uuid/3 sequence is reproducible',
      run: () => {
        const result = run(
          'seeded_uuid(U1, U2, true) :- uuid(1, U1, S1), uuid(1, U1, _), uuid(S1, U2, _), U1 \\= U2.\n',
          { goal: 'seeded_uuid(U1, U2, Same)' },
        );
        assertEqual(result.stdout, "seeded_uuid('f26d1319-3f3f-4bd9-b92f-f414794a43b5', '4be874d3-166b-4107-b0dc-9c53074b3de1', true).\n", 'stdout');
      },
    },
    {
      name: '-h shows CLI help',
      run: () => {
        const result = runCli(['-h']);
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stdout, 'Usage:\n  eyeprolog\n  eyeprolog [options] [file-or-url.pl|- ...]', 'stdout');
        assertIncludes(result.stdout, 'With no arguments, start a Prolog REPL.', 'stdout');
        assertIncludes(result.stdout, '-g, --goal goal', 'stdout');
        assertIncludes(result.stdout, '-p, --proof', 'stdout');
        assertIncludes(result.stdout, '-q, --quads', 'stdout');
        assertIncludes(result.stdout, '--quiet', 'stdout');
        assertIncludes(result.stdout, '-s, --stats', 'stdout');
        assertIncludes(result.stdout, '--portable', 'stdout');
        assertIncludes(result.stdout, '--no-autoload', 'stdout');
        assertIncludes(result.stdout, '-v, --version', 'stdout');
        assertIncludes(result.stdout, '-w, --warnings', 'stdout');
        assertIncludes(result.stdout, '-v, --version         Show the package version and exit.\n  -w, --warnings        Print non-fatal portability warnings to stderr.', 'stdout');
        assertIncludes(result.stdout, 'Read an EyeProlog program', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'bare CLI starts a REPL with truth, failure, and bindings',
      run: () => {
        const result = runCli([], { input: 'true.\nfalse.\nX = hello.\nhalt.\n' });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, '?-    true.\n?-    false.\n?-    X = hello.\n?- ', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'direct and meta-called predicates discard exhausted choicepoints (issue #74 comment 5427164365)',
      run: () => {
        const result = runCli([], {
          input:
            'X=1;X=2.\n;\n' +
            'call(X=1).\n' +
            'call(=(X),1).\n' +
            'setof(X,true,Xs).\n' +
            'findall(t,false,Xs).\n' +
            'use_module(library(lists)).\n' +
            'member(a,"ba").\n' +
            'append("a",Xs,Xs0).\n' +
            'halt.\n',
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout,
          '?-    X = 1\n' +
          ';  X = 2.\n' +
          '?-    X = 1.\n' +
          '?-    X = 1.\n' +
          '?-    Xs = [_A].\n' +
          '?-    Xs = [].\n' +
          '?-    true.\n' +
          '?-    true.\n' +
          '?-    Xs0 = "a"||Xs.\n' +
          '?- ',
          'stdout');
        assertEqual(result.stderr, '', 'stderr');

        const finalAnswerHasNoFrames = (source, text, answerCount, module = null) => {
          const solver = new Solver(Program.parse(source), { registry: getEyePrologRegistry() });
          const goal = parseGoalText(text);
          if (module != null) goal.module = module;
          const solutions = solver.solve([goal], new Env(), 0);
          for (let answer = 1; answer <= answerCount; answer++) {
            assertEqual(solutions.next().done, false, `${text} answer ${answer}`);
            if (answer < answerCount) {
              assertEqual(solver.solveStacks.some((stack) => stack.length !== 0), true,
                `${text} retains its genuine earlier choicepoint`);
            }
          }
          assertEqual(solver.solveStacks.every((stack) => stack.length === 0), true,
            `${text} removes its exhausted predicate frames`);
          assertEqual(solver.hasPendingAlternatives(), false,
            `${text} has no reported alternatives`);
          solutions.return();
        };

        finalAnswerHasNoFrames('', 'X=1;X=2', 2);
        finalAnswerHasNoFrames('', 'call(X=1)', 1);
        finalAnswerHasNoFrames('', 'call(=(X),1)', 1);
        finalAnswerHasNoFrames('', 'atom_concat(a,X,ab)', 1);
        finalAnswerHasNoFrames('', 'sub_atom(ab,0,2,0,S)', 1);
        finalAnswerHasNoFrames('', 'current_prolog_flag(double_quotes,_Value)', 1);
        finalAnswerHasNoFrames('', "current_op(700,xfx,'=')", 1);
        finalAnswerHasNoFrames(':- dynamic(p/1).\np(a).', 'clause(p(X),true)', 1);
        finalAnswerHasNoFrames(':- dynamic(p/1).\np(a).', 'retract(p(X))', 1);
        finalAnswerHasNoFrames('', 'catch(true,_,fail)', 1);
        finalAnswerHasNoFrames('', 'phrase([],[])', 1);
        finalAnswerHasNoFrames('', 'setof(X,true,Xs)', 1);
        finalAnswerHasNoFrames('', 'findall(t,false,Xs)', 1);
        finalAnswerHasNoFrames(':- use_module(library(lists)).', 'member(a,"ba")', 1, 'lists');
        finalAnswerHasNoFrames(':- use_module(library(lists)).', 'append("a",Xs,Xs0)', 1, 'lists');

        const grouped = new Solver(Program.parse(''));
        const groupedSolutions = grouped.solve([
          parseGoalText('setof(X,(Y=1,X=a;Y=2,X=b),Xs)'),
        ], new Env(), 0);
        assertEqual(groupedSolutions.next().done, false, 'first grouped setof/3 answer');
        assertEqual(grouped.hasPendingAlternatives(), true, 'genuine grouped setof/3 choicepoint');
        groupedSolutions.return();

        const called = new Solver(Program.parse(''), { registry: getEyePrologRegistry() });
        const calledSolutions = called.solve([parseGoalText('call((X=1;X=2))')], new Env(), 0);
        assertEqual(calledSolutions.next().done, false, 'called disjunction first answer');
        assertEqual(called.hasPendingAlternatives(), true, 'called disjunction retains its real alternative');
        assertEqual(calledSolutions.next().done, false, 'called disjunction second answer');
        assertEqual(called.hasPendingAlternatives(), false, 'called disjunction removes its exhausted alternative');
        calledSolutions.return();

        const customRegistry = new BuiltinRegistry();
        customRegistry.add('single', 1, function* ({ goal, env }) {
          const next = env.clone();
          if (unify(goal.args[0], atom('only'), next)) yield next;
        });
        const custom = new Solver(Program.parse(''), { registry: customRegistry });
        const customSolutions = custom.solve([parseGoalText('single(X)')], new Env(), 0);
        assertEqual(customSolutions.next().done, false, 'custom relational iterator answer');
        assertEqual(custom.hasPendingAlternatives(), true,
          'an unannotated suspended iterator remains an untried continuation');
        customSolutions.return();

        const annotatedRegistry = new BuiltinRegistry();
        annotatedRegistry.add('single', 1, ({ goal, env }) => {
          const iterator = (function* singleSolution() {
            const next = env.clone();
            if (unify(goal.args[0], atom('only'), next)) yield next;
          })();
          iterator.hasPendingAlternatives = () => false;
          return iterator;
        });
        const annotated = new Solver(Program.parse(''), { registry: annotatedRegistry });
        const annotatedSolutions = annotated.solve([parseGoalText('single(X)')], new Env(), 0);
        assertEqual(annotatedSolutions.next().done, false, 'annotated relational iterator answer');
        assertEqual(annotated.hasPendingAlternatives(), false,
          'an iterator may report exact exhaustion without being resumed');
        annotatedSolutions.return();

        const dynamicProgram = Program.parse(':- dynamic(p/1).\np(a).\np(b).\n');
        const dynamicSolver = new Solver(dynamicProgram, { registry: getEyePrologRegistry() });
        const dynamicSolutions = dynamicSolver.solve([parseGoalText('catch(retract(p(X)),_,fail)')], new Env(), 0);
        assertEqual(dynamicSolutions.next().done, false, 'stateful protected iterator first answer');
        assertEqual(dynamicProgram.findGroup('p', 1).clauses.length, 1,
          'pending-state inspection does not perform the next retraction');
        assertEqual(dynamicSolver.hasPendingAlternatives(), true,
          'stateful protected iterator retains its real second retraction');
        dynamicSolutions.return();
        assertEqual(dynamicProgram.findGroup('p', 1).clauses.length, 1,
          'closing stateful iterator leaves the unrequested clause intact');
      },
    },
    {
      name: 'member/2 retains untried positions without scanning them (issue #74 comment 5435449600)',
      run: () => {
        const result = runCli([], {
          input:
            'use_module(library(lists)).\n' +
            'L=[i],append(L,_,[i|L]),' +
              '(Det=preparing;setup_call_cleanup(true,member(a,[a|L]),Det=yes)).\n' +
            ';\n' +
            'setup_call_cleanup(true,member(a,[a]),Det=yes).\n' +
            'halt.\n',
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout,
          '?-    true.\n' +
          '?-    L = "i", Det = preparing\n' +
          ';  L = "i".\n' +
          '?-    Det = yes.\n' +
          '?- ',
          'cleanup observes the real list-position choicepoint');
        assertEqual(result.stderr, '', 'stderr');

        let speculativeTailRead = false;
        const unreadTail = {
          type: 'compound',
          name: '.',
          get arity() { return 2; },
          get args() {
            speculativeTailRead = true;
            throw new Error('member/2 inspected an untried tail position');
          },
        };
        const memberGoal = compound('member', [atom('a'), compound('.', [atom('a'), unreadTail])]);
        memberGoal.module = 'lists';
        const solver = new Solver(Program.parse(':- use_module(library(lists)).'), {
          registry: getEyePrologRegistry(),
        });
        const solutions = solver.solve([memberGoal], new Env(), 0);
        assertEqual(solutions.next().done, false, 'member/2 first answer');
        assertEqual(speculativeTailRead, false, 'first answer does not inspect the tail');
        assertEqual(solver.hasPendingAlternatives(), true, 'unread tail is a genuine alternative');
        solutions.return();
        assertEqual(speculativeTailRead, false, 'discarding the choicepoint does not inspect it');

        const compactAppendTail = compactVariableList(100000n, '__appendTail');
        const appendGoal = compound('append', [
          variable('Prefix'),
          compound('.', [atom('a'), variable('Suffix')]),
          compound('.', [atom('a'), compactAppendTail]),
        ]);
        appendGoal.module = 'lists';
        const appendSolver = new Solver(Program.parse(':- use_module(library(lists)).'), {
          registry: getEyePrologRegistry(),
        });
        const appendSolutions = appendSolver.solve([appendGoal], new Env(), 0);
        assertEqual(appendSolutions.next().done, false, 'append/3 first answer');
        assertEqual(compactAppendTail._args, null, 'append/3 first answer does not expand the tail');
        assertEqual(appendSolver.hasPendingAlternatives(), true, 'append/3 retains its recursive alternative');
        appendSolutions.return();
        assertEqual(compactAppendTail._args, null, 'discarding append/3 alternatives does not expand the tail');

        const compact = compactVariableList(100000n, '__scalarCompact');
        const firstCell = compact.args[0];
        const env = new Env();
        assertEqual(unify(firstCell, variable('ClauseHead'), env), true,
          'compact cell aliases a clause-head variable');
        assertEqual(unify(variable('ClauseHead'), atom('i'), env), true,
          'the clause-head variable receives its scalar value');

        // Recreate the unexpanded view over the same conservative provenance,
        // as a recursive compact-list tail would provide.
        compact._args = null;
        assertEqual(unify(variable('Unrelated'), compact, env), true,
          'an unrelated variable unifies with the compact list');
        assertEqual(compact._args, null,
          'the occurs check proves nonoccurrence without expanding scalar-bound cells');

        const nonGroundCompact = compactVariableList(2n, '__nonGroundCompact');
        const nonGroundCell = nonGroundCompact.args[0];
        const cyclicEnv = new Env();
        assertEqual(unify(nonGroundCell, variable('Intermediate'), cyclicEnv), true,
          'a second compact cell aliases a clause-head variable');
        assertEqual(unify(variable('Intermediate'), compound('f', [variable('Cycle')]), cyclicEnv), true,
          'the aliased cell receives a non-ground value');
        assertEqual(unify(variable('Cycle'), nonGroundCompact, cyclicEnv), false,
          'non-ground compact bindings still receive the complete finite-tree occurs check');
      },
    },
    {
      name: 'length/2 reports fixed and closed-list answers as deterministic (issue #78)',
      run: () => {
        const result = runCli([], {
          input:
            'use_module(library(lists)).\n' +
            'length(K,0).\n' +
            'length([],N).\n' +
            'halt.\n',
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout,
          '?-    true.\n' +
          '?-    K = [].\n' +
          '?-    N = 0.\n' +
          '?- ',
          'no exhausted native length iterator remains');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'REPL hides aliases to fresh throw variables while preserving query aliases',
      run: () => {
        const result = runCli([], {
          input: 'catch(throw(g(X)),g(V),true).\nX = Y.\nhalt.\n',
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, '?-    true.\n?-    X = Y.\n?- ', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'REPL displays uncaught user exceptions as throw terms (issue #75)',
      run: () => {
        const result = runCli([], { input: 'throw(stopped).\nhalt.\n' });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, '?-    throw(stopped).\n?- ', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'REPL freshens variables displayed in uncaught ISO errors',
      run: () => {
        const result = runCli([], {
          input: 'number_chars(V,[1,[],X|2]).\nnumber_chars(V,[1,[],Xx|2]).\nhalt.\n',
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout,
          '?-    error(type_error(list, [1, [], _A | 2]), eyeprolog).\n' +
          '?-    error(type_error(list, [1, [], _A | 2]), eyeprolog).\n' +
          '?- ',
          'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'REPL uncaught ISO errors retain the error/2 implementation context',
      run: () => {
        const result = runCli([], {
          input: '_ is _.\ncatch(_ is _, error(Error, Imp_def), true).\nhalt.\n',
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout,
          '?-    error(instantiation_error, eyeprolog).\n' +
          '?-    Error = instantiation_error, Imp_def = eyeprolog.\n' +
          '?- ',
          'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'occurs_check error mode reports representation_error(term) while ISO occurs-check unification still fails',
      run: () => {
        const filename = path.join(tmp, `occurs-check-${++tmpCounter}.pl`);
        fs.writeFileSync(filename, ':- set_prolog_flag(occurs_check, error).\nsame(X, X).\n');
        const result = runCli([], {
          input:
            'current_prolog_flag(occurs_check, Mode).\n' +
            'set_prolog_flag(occurs_check, error).\n' +
            'X = f(X).\n' +
            'catch((Y = g(Y)), E, true).\n' +
            'unify_with_occurs_check(Z, h(Z)).\n' +
            `[${sourceAtom(filename)}].\n` +
            'same(W, k(W)).\n' +
            'set_prolog_flag(occurs_check, true).\n' +
            'Q = q(Q).\n' +
            'halt.\n',
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout,
          '?-    Mode = true.\n' +
          '?-    true.\n' +
          '?-    error(representation_error(term), []).\n' +
          '?-    E = error(representation_error(term), []).\n' +
          '?-    false.\n' +
          '?-    true.\n' +
          '?-    error(representation_error(term), []).\n' +
          '?-    true.\n' +
          '?-    false.\n' +
          '?- ',
          'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'proven-nonoccurrence first-use shortcut preserves finite-tree occurs checking',
      run: () => {
        const program = Program.parse(`
          first_use_cycle :- X = f(Y), Y = g(X).
          repeated_cycle :- X = f(X).
          first_use_ok(T) :- X = f(Y), Y = a, T = X.
          pass(_).
          handed_off_cycle :- pass(X), Y = f(X), X = g(Y).
          handed_off_alias_cycle :- pass(X), Y = X, X = f(Y).
        `);
        const solver = new Solver(program);
        const solveCount = (text) => {
          const goal = parseGoalText(text, {
            doubleQuotes: 'chars',
            operatorDefinitions: [...program.operators.values()],
          });
          let count = 0;
          for (const _ of solver.solve([goal], new Env(), 0)) count++;
          return count;
        };
        assertEqual(solveCount('first_use_cycle'), 0, 'cycle across later first-use binding');
        assertEqual(solveCount('repeated_cycle'), 0, 'same-goal repeated variable still checks occurs');
        assertEqual(solveCount('first_use_ok(f(a))'), 1, 'acyclic first-use bindings still succeed');
        assertEqual(solveCount('handed_off_cycle'), 0, 'nested use globalizes a handed-off local before a cycle');
        assertEqual(solveCount('handed_off_alias_cycle'), 0, 'aliasing does not hide a later cycle');
      },
    },
    {
      name: 'phrase/2 fixes the final remainder before running the grammar',
      run: () => {
        const program = Program.parse('probe(_, Out) :- var(Out).\n');
        const solver = new Solver(program);
        const goal = parseGoalText('phrase(probe, [])', {
          doubleQuotes: 'chars',
          operatorDefinitions: [...program.operators.values()],
        });
        let count = 0;
        for (const _ of solver.solve([goal], new Env(), 0)) count++;
        assertEqual(count, 0, 'phrase/2 exposes [] rather than a temporary output variable');
      },
    },
    {
      name: 'deep tail-consuming DCG avoids quadratic occurs scans and recursive ground-goal copying',
      run: () => {
        const engineUrl = new URL('../src/index.js', import.meta.url).href;
        const script = `
          import { Program, Solver, Env, atom, compound, listFromItems } from ${JSON.stringify(engineUrl)};
          const program = Program.parse(${JSON.stringify('s --> [].\ns --> [x], s.\n')});
          const input = listFromItems(Array.from({ length: 2500 }, () => atom('x')));
          const solver = new Solver(program, { solutionLimit: 1, maxMemoryBytes: Infinity });
          const goal = compound('phrase', [atom('s'), input]);
          let count = 0;
          for (const _ of solver.solve([goal], new Env(), 0)) { count++; break; }
          if (count !== 1) throw new Error('deep DCG did not succeed');
          process.stdout.write('ok');
        `;
        const result = spawnSync(process.execPath, [
          '--input-type=module',
          '--eval',
          script,
        ], { cwd: packageRoot, encoding: 'utf8', timeout: 10000 });
        if (result.error) throw result.error;
        assertEqual(result.status, 0, `deep DCG child status; stderr=${result.stderr}`);
        assertEqual(result.stdout, 'ok', 'deep DCG result');
      },
    },
    {
      name: 'Trealla-style DCG hand-off autoloads time/1 and ... //0 without quadratic occurs checks (issue #49)',
      run: () => {
        const engineUrl = new URL('../src/index.js', import.meta.url).href;
        const script = `
          import { run } from ${JSON.stringify(engineUrl)};
          const source = ${JSON.stringify('a --> ..., epsilon.\nepsilon --> [].\n')};
          const result = run(source, {
            goal: ${JSON.stringify('length(_,E), E>12, N is 2^E, \\+ \\+ (length(L,N), time(phrase(a,L)))')},
            solutionLimit: 1,
          });
          if (!result.stdout.startsWith('% Time elapsed ') || !result.stdout.endsWith('s\\n')) {
            throw new Error('unexpected time/1 output: ' + JSON.stringify(result.stdout));
          }
          process.stdout.write('ok');
        `;
        const result = spawnSync(process.execPath, ['--input-type=module', '--eval', script], {
          cwd: packageRoot,
          encoding: 'utf8',
          timeout: 10000,
        });
        if (result.error) throw result.error;
        assertEqual(result.status, 0, `DCG hand-off child status; stderr=${result.stderr}`);
        assertEqual(result.stdout, 'ok', 'DCG hand-off benchmark result');
      },
    },
    {
      name: 'DCG state hand-off reaches the next non-terminal at 8192 cells (issue #49 comment 5347991607)',
      run: () => {
        const filename = path.join(tmp, `issue49-small-handoff-${tmpCounter++}.pl`);
        fs.writeFileSync(filename,
          ':- set_prolog_flag(occurs_check, true).\na --> ..., epsilon.\nepsilon --> [].\n');
        const result = runCli([], {
          input:
            `[${sourceAtom(filename)}].\n` +
            'use_module(library(lists)).\n' +
            '\\+ \\+ (length(L,8192), phrase(a,L)).\n' +
            'halt.\n',
          timeout: 3000,
        });
        if (result.error) throw result.error;
        assertEqual(result.status, 0, `small DCG hand-off status; stderr=${result.stderr}`);
        assertNotIncludes(result.stdout, 'resource_error', 'small DCG hand-off resource error');
        assertNotIncludes(result.stdout, 'depth_limit_exceeded', 'small DCG hand-off depth error');
        assertEqual(result.stderr, '', 'small DCG hand-off stderr');
      },
    },
    {
      name: 'Trealla-style DCG hand-off reaches 65536 cells without the solver depth ceiling',
      run: () => {
        const engineUrl = new URL('../src/index.js', import.meta.url).href;
        const script = `
          import { run } from ${JSON.stringify(engineUrl)};
          const source = ${JSON.stringify(':- set_prolog_flag(occurs_check, true).\na --> ..., epsilon.\nepsilon --> [].\n')};
          const result = run(source, {
            goal: ${JSON.stringify('\\+ \\+ (length(L,65536), time(phrase(a,L)))')},
            solutionLimit: 1,
          });
          if (!result.stdout.startsWith('% Time elapsed ')) {
            throw new Error('65536-cell hand-off did not succeed: ' + JSON.stringify(result.stdout));
          }
          process.stdout.write('ok');
        `;
        const result = spawnSync(process.execPath, ['--input-type=module', '--eval', script], {
          cwd: packageRoot,
          encoding: 'utf8',
          timeout: DCG_HANDOFF_TEST_TIMEOUT_MS,
        });
        if (result.error) throw result.error;
        assertEqual(result.status, 0, `65536-cell hand-off status; stderr=${result.stderr}`);
        assertEqual(result.stdout, 'ok', '65536-cell hand-off result');
      },
    },
    {
      name: 'REPL applies bundled-library autoloading to interactive time/1 and consulted ... //0',
      run: () => {
        const filename = path.join(tmp, `issue49-handoff-${tmpCounter++}.pl`);
        fs.writeFileSync(filename, 'a --> ..., epsilon.\nepsilon --> [].\n');
        const result = runCli([], {
          input:
            `[${sourceAtom(filename)}].\n` +
            'use_module(library(lists)).\n' +
            'length(_,E),E>12,N is 2^E,\\+ \\+ (length(L,N),time(phrase(a,L))).\n' +
            '\n' +
            'halt.\n',
          timeout: 10000,
        });
        if (result.error) throw result.error;
        assertEqual(result.status, 0, `REPL hand-off status; stderr=${result.stderr}`);
        assertIncludes(result.stdout, '% Time elapsed ', 'REPL time/1 output');
        assertEqual((result.stdout.match(/% Time elapsed /g) ?? []).length, 1,
          'REPL timed query does not prefetch an unrequested next answer');
        assertIncludes(result.stdout, 'E = 13, N = 8192', 'REPL first benchmark answer');
        assertNotIncludes(result.stdout, 'existence_error(procedure', 'REPL autoload errors');
        assertEqual(result.stderr, '', 'REPL hand-off stderr');
      },
    },
    {
      name: 'REPL Trealla hand-off benchmark reaches E=16 on demand without OOM fallthrough',
      run: () => {
        const filename = path.join(tmp, `issue49-handoff-deep-${tmpCounter++}.pl`);
        fs.writeFileSync(filename, ':- set_prolog_flag(occurs_check, true).\na --> ..., epsilon.\nepsilon --> [].\n');
        const result = runCli([], {
          input:
            `[${sourceAtom(filename)}].\n` +
            'use_module(library(lists)).\n' +
            'length(_,E),E>12,N is 2^E,\\+ \\+ (length(L,N),time(phrase(a,L))).\n' +
            ';\n;\n;\n\n' +
            'halt.\n',
          timeout: DCG_HANDOFF_TEST_TIMEOUT_MS,
        });
        if (result.error) throw result.error;
        assertEqual(result.status, 0, `deep REPL hand-off status; stderr=${result.stderr}`);
        for (const [e, n] of [[13, 8192], [14, 16384], [15, 32768], [16, 65536]]) {
          assertIncludes(result.stdout, `E = ${e}, N = ${n}`, `REPL hand-off E=${e}`);
        }
        assertEqual((result.stdout.match(/% Time elapsed /g) ?? []).length, 4,
          'exactly four requested timed answers');
        assertEqual(result.stderr, '', 'deep REPL hand-off stderr');
      },
    },
    {
      name: 'REPL enumerates and stops answers like the Scryer top level',
      run: () => {
        const result = runCli([], {
          input: '(X = a; X = b).\n;\n(X = one; X = two).\n\nhalt.\n',
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, '?-    X = a\n;  X = b.\n?-    X = one\n;  ... .\n?- ', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'REPL does not precompute an unrequested future alternative (issue #48)',
      run: () => {
        const result = runCli([], {
          input: '(X = first; (repeat, fail)).\nhalt.\n',
          timeout: 2000,
        });
        if (result.error) throw result.error;
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, '?-    X = first.\n?- ', 'first answer is immediate');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'REPL executes future side effects only after another answer is requested (issue #48)',
      run: () => {
        const stopped = runCli([], {
          input:
            '(X = first; (assertz(issue48_seen), X = second)).\n' +
            'current_predicate(issue48_seen/0).\n' +
            'halt.\n',
        });
        assertEqual(stopped.status, 0, 'stopped status');
        assertEqual(
          stopped.stdout,
          '?-    X = first.\n?-    false.\n?- ',
          'unrequested branch has no side effect',
        );

        const advanced = runCli([], {
          input:
            '(X = first; (assertz(issue48_seen), X = second)).\n' +
            ';\n' +
            'current_predicate(issue48_seen/0).\n' +
            'halt.\n',
        });
        assertEqual(advanced.status, 0, 'advanced status');
        assertEqual(
          advanced.stdout,
          '?-    X = first\n;  X = second.\n?-    true.\n?- ',
          'requested branch performs its side effect',
        );
        assertEqual(stopped.stderr, '', 'stopped stderr');
        assertEqual(advanced.stderr, '', 'advanced stderr');
      },
    },
    {
      name: 'REPL exposes output side effects while search is still running (issue #72)',
      run: () => {
        const helper = `
          import { spawn } from 'node:child_process';

          const child = spawn(${JSON.stringify(process.execPath)}, [${JSON.stringify(bin)}], {
            cwd: ${JSON.stringify(packageRoot)},
            stdio: ['pipe', 'pipe', 'pipe'],
          });
          child.stdout.setEncoding('utf8');
          child.stderr.setEncoding('utf8');
          let stdout = '';
          let stderr = '';
          child.stdout.on('data', (text) => { stdout += text; });
          child.stderr.on('data', (text) => { stderr += text; });

          async function waitFor(predicate, label) {
            const deadline = Date.now() + 5000;
            while (!predicate()) {
              if (Date.now() >= deadline) {
                child.kill('SIGKILL');
                throw new Error(label + ' timeout; stdout=' + JSON.stringify(stdout) + '; stderr=' + JSON.stringify(stderr));
              }
              await new Promise((resolve) => setTimeout(resolve, 10));
            }
          }

          child.stdin.write('use_module(library(iso_ext)).\\n');
          await waitFor(() => stdout.includes('   true.\\n?- '), 'module import');
          child.stdin.write('call_nth(repeat,Nth), (Nth mod 2=:=0->writeq(r(Nth)),nl;true),Nth<0.\\n');
          await waitFor(() => stdout.includes('r(2)\\nr(4)\\n'), 'progress output');
          if (stdout.includes('false.')) throw new Error('infinite search unexpectedly reached a leaf');
          child.kill('SIGKILL');
          await new Promise((resolve) => child.once('exit', resolve));
          process.stdout.write('progress-visible');
        `;
        const result = spawnSync(process.execPath, [
          '--input-type=module',
          '--eval',
          helper,
        ], { cwd: packageRoot, encoding: 'utf8', timeout: 10000 });
        if (result.error) throw result.error;
        assertEqual(result.status, 0, `progress helper status; stderr=${result.stderr}`);
        assertEqual(result.stdout, 'progress-visible', 'newline-terminated progress is visible before a leaf answer');
      },
    },
    {
      name: 'REPL bindings use argument syntax for operator atoms',
      run: () => {
        const result = runCli([], {
          input: 'L=[:-,-], writeq(L), nl.\nhalt.\n',
        });
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stdout, '[:-,-]', 'writeq output');
        assertIncludes(result.stdout, 'L = [:-, -].', 'binding output');
        assertNotIncludes(result.stdout, "L = [':-', '-']", 'spurious quotes');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'REPL query and answer prompts distinguish waiting from computation',
      run: () => {
        const helper = `
          import { spawn } from 'node:child_process';

          const child = spawn(${JSON.stringify(process.execPath)}, [${JSON.stringify(bin)}], {
            cwd: ${JSON.stringify(packageRoot)},
            stdio: ['pipe', 'pipe', 'pipe'],
          });
          child.stdout.setEncoding('utf8');
          child.stderr.setEncoding('utf8');
          let stdout = '';
          let stderr = '';
          let sawQueryComputingPrompt = false;
          let sawComputingPrompt = false;
          child.stdout.on('data', (text) => {
            stdout += text;
            if (stdout.endsWith('?-   ')) sawQueryComputingPrompt = true;
            if (stdout.includes('\\n; ')) sawComputingPrompt = true;
          });
          child.stderr.on('data', (text) => { stderr += text; });

          async function waitFor(predicate, label) {
            const deadline = Date.now() + 5000;
            while (!predicate()) {
              if (Date.now() >= deadline) {
                throw new Error(label + ' timeout; stdout=' + JSON.stringify(stdout) + '; stderr=' + JSON.stringify(stderr));
              }
              await new Promise((resolve) => setTimeout(resolve, 10));
            }
          }

          child.stdin.write('use_module(library(prologue)).\\n');
          await waitFor(() => stdout.includes('   true.\\n?- '), 'module import');
          sawQueryComputingPrompt = false;
          child.stdin.write('between(0,0xff,I),I<0.\\n');
          await waitFor(() => sawQueryComputingPrompt, 'query computing prompt');
          await waitFor(() => stdout.endsWith('   false.\\n?- '), 'query result');
          child.stdin.write('(N = 0; N = 1; (call_nth(repeat, 100000), N = 2)).\\n');
          await waitFor(() => stdout.endsWith('   N = 0'), 'first answer');
          child.stdin.write(';\\n');
          await waitFor(() => sawComputingPrompt, 'computing prompt');
          await waitFor(() => stdout.endsWith(';  N = 1'), 'formatted answer');
          child.stdin.write('\\n');
          await waitFor(() => stdout.endsWith('  ... .\\n?- '), 'stopped enumeration');
          child.stdin.write('halt.\\n');
          const status = await new Promise((resolve) => child.once('exit', resolve));
          if (status !== 0) throw new Error('child status ' + status + '; stderr=' + stderr);
          process.stdout.write('query-computing;waiting;computing;formatting');
        `;
        const result = spawnSync(process.execPath, [
          '--input-type=module',
          '--eval',
          helper,
        ], { cwd: packageRoot, encoding: 'utf8', timeout: 10000 });
        if (result.error) throw result.error;
        assertEqual(result.status, 0, `prompt helper status; stderr=${result.stderr}`);
        assertEqual(result.stdout, 'query-computing;waiting;computing;formatting', 'prompt state sequence');
      },
    },
    {
      name: 'REPL f stops at five-answer boundaries instead of adding five answers',
      run: () => {
        const result = runCli([], {
          input:
            'use_module(library(prologue), [between/3]).\n' +
            'between(0,11,I).\nf\n\n' +
            'between(0,11,J).\n;\n;\nf\n\n' +
            'between(0,11,K).\nf\nf\n\n' +
            'halt.\n',
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout,
          '?-    true.\n' +
          '?-    I = 0\n' +
          ';  I = 1\n' +
          ';  I = 2\n' +
          ';  I = 3\n' +
          ';  I = 4\n' +
          ';  ... .\n' +
          '?-    J = 0\n' +
          ';  J = 1\n' +
          ';  J = 2\n' +
          ';  J = 3\n' +
          ';  J = 4\n' +
          ';  ... .\n' +
          '?-    K = 0\n' +
          ';  K = 1\n' +
          ';  K = 2\n' +
          ';  K = 3\n' +
          ';  K = 4\n' +
          ';  K = 5\n' +
          ';  K = 6\n' +
          ';  K = 7\n' +
          ';  K = 8\n' +
          ';  K = 9\n' +
          ';  ... .\n' +
          '?- ',
          'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'REPL parenthesizes operator-valued answer substitutions',
      run: () => {
        const result = runCli([], {
          input: 'T = (a=b).\nU = (a,b).\nV = (a;b).\nW = (a+b).\nhalt.\n',
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout,
          '?-    T = (a=b).\n' +
          '?-    U = (a,b).\n' +
          '?-    V = (a;b).\n' +
          '?-    W = a+b.\n' +
          '?- ',
          'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'REPL recognizes ISO octal and hexadecimal escapes in quoted atoms',
      run: () => {
        const result = runCli([], {
          input: "writeq('\\7\\').\nwriteq('\\x7\\').\nwriteq('\\a').\nhalt.\n",
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout,
          "?-   '\\a' true.\n" +
          "?-   '\\a' true.\n" +
          "?-   '\\a' true.\n" +
          '?- ',
          'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'writeq preserves the NUL character with an ISO octal escape',
      run: () => {
        const result = runCli([], {
          input: "writeq('\\0\\').\nhalt.\n",
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, "?-   '\\0\\' true.\n?- ", 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'REPL rejects non-octal numeric escapes without waiting for continuation',
      run: () => {
        const result = runCli([], {
          input: "'\\8\\'.\nhalt.\n",
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout,
          '?-    parse line 1: bad octal escape.\n' +
          '?- ',
          'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'REPL rejects an unterminated quote at the line boundary instead of waiting',
      run: () => {
        const result = runCli([], {
          input: "'\nhalt.\n",
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout,
          '?-    parse line 1: unterminated quoted term.\n' +
          '?- ',
          'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'REPL rejects a literal newline in a quoted token immediately',
      run: () => {
        const result = runCli([], {
          // The first input line ends while a quote is open. ISO 6.4.2.1
          // makes that newline a lexical error unless it is escaped by the
          // immediately preceding backslash. The following true/0 proves
          // that the top level did not consume another line as continuation.
          input: "writeq('\ntrue.\nhalt.\n",
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout,
          '?-    parse line 1: unterminated quoted term.\n' +
          '?-    true.\n' +
          '?- ',
          'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'parser matches WG17 quoted-character and escape syntax cluster',
      run: () => {
        const invalid = [
          ['#2 lone quote', "'\n"],
          ['#5 literal horizontal tab', "writeq('\t')"],
          ['#6 literal newline', "writeq('\n')"],
          ['#11 backslash-space', String.raw`writeq('\ ')`],
          ['#12 backslash-horizontal-tab', "writeq('\\\t')"],
          ['#16 non-ISO c escape', String.raw`writeq('\ca')`],
          ['#241 non-ISO d escape', String.raw`writeq('\d')`],
          ['#17 non-ISO e escape', String.raw`writeq('\e')`],
          ['#19 non-ISO e in char_code/2', String.raw`char_code('\e', C)`],
          ['#21 non-ISO d in char_code/2', String.raw`char_code('\d', C)`],
          ['#22 non-ISO u escape', String.raw`writeq('\u1')`],
          ['#312 non-ISO Unicode escape', String.raw`writeq('\u0021')`],
          ['#314 non-ISO Unicode double-quote escape', String.raw`writeq("\u0021")`],
          ['#23 non-ISO character-code escape', String.raw`X = 0'\u1`],
          ['#24 unterminated quoted argument', "writeq('\n"],
          ['#26 continuation followed by unterminated quote', "'\\\n''"],
          ['#210 escaped dot character code', String.raw`X = 0'\.`],
          ['#211 escaped dot character code before layout', String.raw`X = 0'\. `],
        ];
        for (const [label, source] of invalid) {
          let error = null;
          try {
            parseGoalText(source);
          } catch (caught) {
            error = caught;
          }
          if (error == null) throw new Error(`${label} unexpectedly parsed`);
        }

        const valid = [
          ['#7 empty continuation', "writeq('\\\n')"],
          ['#8 leading continuation', "writeq('\\\na')"],
          ['#9 embedded continuation', "writeq('a\\\nb')"],
          ['#10 continuation before space', "writeq('a\\\n b')"],
          ['#13 symbolic tab', String.raw`writeq('\t')`],
          ['#14 symbolic alert', String.raw`writeq('\a')`],
          ['#15 octal alert', String.raw`writeq('\7\')`],
          ['#18 octal escape', String.raw`writeq('\033\')`],
          ['#301 NUL escape', String.raw`writeq('\0\')`],
          ['#315 hexadecimal escape', String.raw`writeq('\x21\')`],
          ['#316 padded hexadecimal escape', String.raw`writeq('\x0021\')`],
          ['#38 double-quoted meta escapes', "\"\\'\\`\\\"\" = \"'`\"\"\""],
          ['#39 single-quoted meta escapes', "'\\'\\`\\\"' = '''`\"'"],
          ['#40 writeq meta escapes', "writeq('\\'\\`\\\"\\\"')"],
          ['#41 meta backslash escape', String.raw`('\\') = (\)`],
        ];
        for (const [label, source] of valid) {
          try {
            parseGoalText(source);
          } catch (error) {
            throw new Error(`${label} should parse: ${error?.message ?? error}`);
          }
        }
      },
    },
    {
      name: 'stream term input reports malformed quoted layout as syntax_error',
      run: () => {
        for (const [label, input] of [
          ['lone quote', "'\n"],
          ['literal newline', "writeq('\n').\n"],
          ['literal tab', "writeq('\t').\n"],
        ]) {
          let error = null;
          try {
            runEyeProlog('', { goal: 'read(X)', ioOptions: { input } });
          } catch (caught) {
            error = caught;
          }
          assertEqual(error?.message, 'error(syntax_error(read_term))', `${label} read error`);
        }
      },
    },
    {
      name: 'writeq uses ISO numeric escapes for non-symbolic control characters',
      run: () => {
        const result = runCli([], {
          input: "writeq('\\033\\').\nhalt.\n",
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, "?-   '\\33\\' true.\n?- ", 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'REPL read predicates consume following interactive term input',
      run: () => {
        const result = runCli([], {
          input:
            'read(X).\n' +
            'foo.\n' +
            'read_term(Y, []).\n' +
            "'\\7\\'.\n" +
            'read(user_input, Z).\n' +
            'bar.\n' +
            'halt.\n',
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout,
          '?-   |:  X = foo.\n' +
          "?-   |:  Y = '\\a'.\n" +
          '?-   |:  Z = bar.\n' +
          '?- ',
          'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'read terms have a variable scope distinct from the calling query',
      run: () => {
        const result = runCli([], {
          input:
            'read(X).\n' +
            'X=a.\n' +
            'read(X).\n' +
            'Y=a.\n' +
            'read_term(X, [variables(Vs), variable_names(Names), singletons(Singletons)]).\n' +
            'X = pair(X, Y).\n' +
            'halt.\n',
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout,
          '?-   |:  X = (_A=a).\n' +
          '?-   |:  X = (_A=a).\n' +
          "?-   |:  X = (_A=pair(_A, _B)), Vs = [_A, _B], Names = ['X'=_A, 'Y'=_B], Singletons = ['Y'=_B].\n" +
          '?- ',
          'stdout');
        assertEqual(result.stderr, '', 'stderr');

        const distinctReads = run(
          'check :- read(A), read(B), A \\== B, write_canonical(pair(A, B)), nl.\n',
          { goal: 'check', ioOptions: { input: 'V.\nV.\n' } },
        );
        assertEqual(distinctReads.stdout, 'pair(_A,_B)\ncheck.\n', 'separate read variable sets');
      },
    },
    {
      name: 'REPL term input is on demand in conjunctions and Ctrl-D does not exit the top level',
      run: () => {
        if (!hasUtilLinuxScript()) return;
        const result = runScriptedRepl([
          { waitFor: '?- ', send: 'read(X), read(Y).\n' },
          { waitFor: '  |: ', send: 'foo.\n' },
          { waitFor: '|: ', send: 'bar.\n' },
          { waitFor: 'X = foo, Y = bar.', send: 'read(Z).\n' },
          { waitFor: '  |: ', send: '\u0004' },
          { waitFor: 'Z = end_of_file.', send: 'true.\n' },
          { waitFor: '   true.', send: 'halt.\n' },
        ]);
        assertEqual(result.error?.code, undefined, 'interactive read timeout');
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stdout, 'X = foo, Y = bar.', 'conjunction reads');
        assertIncludes(result.stdout, 'Z = end_of_file.', 'Ctrl-D read result');
        assertIncludes(result.stdout, '?- true.', 'top level resumes after Ctrl-D');
        assertIncludes(result.stdout, '   true.', 'post-EOF query executes');
      },
    },
    {
      name: 'REPL character input is on demand and Ctrl-D stays local (issue #55)',
      run: () => {
        if (!hasUtilLinuxScript()) return;
        const result = runScriptedRepl([
          { waitFor: '?- ', send: 'peek_char(P), get_char(C), get_code(K).\n' },
          { waitFor: '  |: ', send: 'ab\n' },
          { waitFor: 'P = a, C = a, K = 98.', send: 'get_char(N).\n' },
          { waitFor: '  |: ', send: 'z\n' },
          { waitFor: 'N = z.', send: 'get_char(E).\n' },
          { waitFor: '  |: ', send: '\u0004' },
          { waitFor: 'E = end_of_file.', send: 'get_char(D).\n' },
          { waitFor: '  |: ', send: 'q\n' },
          { waitFor: 'D = q.', send: 'halt.\n' },
        ]);
        assertEqual(result.error?.code, undefined, 'interactive character input timeout');
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stdout, 'P = a, C = a, K = 98.', 'peek/get char and code input');
        assertIncludes(result.stdout, 'N = z.', 'Enter submits but is not buffered as the next character');
        assertIncludes(result.stdout, 'E = end_of_file.', 'Ctrl-D character result');
        assertIncludes(result.stdout, 'D = q.', 'character input resumes after Ctrl-D');
      },
    },
    {
      name: 'interactive user_input hook serves reads reached through user predicates',
      run: () => {
        const program = Program.parse('pair(A, B) :- read(A), read(B).\n');
        const solver = new Solver(program, { registry: getEyePrologRegistry() });
        const stream = solver.io.resolve('user_input');
        const pending = ['left.\n', 'right.\n'];
        let requests = 0;
        stream.interactiveReadTerm = () => {
          requests++;
          return pending.shift() ?? null;
        };
        const goal = parseGoalText('pair(X, Y)');
        const answers = [...solver.solve([goal], new Env(), 0)];
        assertEqual(answers.length, 1, 'answer count');
        assertEqual(termToString(copyResolved(goal.args[0], answers[0])), 'left', 'first read');
        assertEqual(termToString(copyResolved(goal.args[1], answers[0])), 'right', 'second read');
        assertEqual(requests, 2, 'on-demand read count');
      },
    },
    {
      name: 'REPL releases terminal signals while a query computes',
      run: () => {
        if (!hasUtilLinuxScript()) return;
        // Synchronize on output produced from inside the solver instead of a
        // fixed sleep: on a loaded host Ctrl-C could otherwise arrive before
        // the query starts, leaving repeat/fail to run until the test timeout.
        const result = runScriptedRepl([
          { waitFor: '?- ', send: 'put_code(82), put_code(69), put_code(65), put_code(68), put_code(89), repeat, fail.\n' },
          { waitFor: 'READY', send: '\u0003' },
        ]);
        assertEqual(result.error?.code, undefined, 'terminal interrupt timeout');
        assertEqual(result.status, 130, 'SIGINT exit status');
        assertIncludes(result.stdout, '?- put_code(82), put_code(69), put_code(65), put_code(68), put_code(89), repeat, fail.', 'terminal query echo');
        assertIncludes(result.stdout, 'READY', 'query entered computation');
      },
    },
    {
      name: 'REPL stops at the end token before parsing unmatched brackets (issue #51)',
      run: () => {
        const result = runCli([], { input: '[l.\ntrue.\n{.\ntrue.\nhalt.\n' });
        assertEqual(result.status, 0, 'exit status');
        assertNotIncludes(result.stdout, '|    ', 'no continuation prompt after malformed end token');
        assertEqual((result.stdout.match(/\?-    true\./g) ?? []).length, 2,
          'following lines remain separate top-level queries');
        assertEqual((result.stdout.match(/parse line 1:/g) ?? []).length, 2,
          'both malformed bracketed queries report syntax errors');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'REPL accepts multiline period-terminated queries',
      run: () => {
        const result = runCli([], { input: '(X =\n  one).\nhalt.\n' });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, '?- |       X = one.\n?- ', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'REPL [user] consults interactive source until end_of_file (issue #91)',
      run: () => {
        const result = runCli([], {
          input:
            '[user].\n' +
            'color(red).\n' +
            'color(blue).\n' +
            'end_of_file.\n' +
            'color(X).\n' +
            ';\n' +
            'halt.\n',
        });
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stdout, '|: |: |:  true.\n?-    X = red\n;  X = blue.', 'interactive consult and answers');
        assertNotIncludes(result.stdout, 'ENOENT', 'user is not treated as a filesystem path');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'REPL consult shorthand loads local Prolog files',
      run: () => {
        const filename = path.join(tmp, `repl-consult-${++tmpCounter}.pl`);
        fs.writeFileSync(filename, 'color(red).\ncolor(blue).\n');
        const result = runCli([], {
          input: `[${sourceAtom(filename)}].\ncolor(X).\n;\nhalt.\n`,
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, '?-    true.\n?-    X = red\n;  X = blue.\n?- ', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'REPL consult prefers .pl over an unsuffixed file (issue #47)',
      run: () => {
        const stem = path.join(tmp, `repl-consult-order-${++tmpCounter}`);
        fs.writeFileSync(stem, 'chosen(bare).\n');
        fs.writeFileSync(`${stem}.pl`, 'chosen(pl).\n');
        const result = runCli([], {
          input: `[${sourceAtom(stem)}].\nchosen(X).\nhalt.\n`,
        });
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stdout, 'X = pl.', 'consulted .pl source');
        assertNotIncludes(result.stdout, 'X = bare', 'unsuffixed source is fallback only');
        assertEqual(result.stderr, '', 'stderr');

        const explicit = runCli([], {
          input: `consult(${sourceAtom(stem)}).\nchosen(X).\nhalt.\n`,
        });
        assertEqual(explicit.status, 0, 'consult/1 exit status');
        assertIncludes(explicit.stdout, 'X = pl.', 'consult/1 prefers .pl source');
        assertNotIncludes(explicit.stdout, 'X = bare', 'consult/1 does not prefer unsuffixed source');
        assertEqual(explicit.stderr, '', 'consult/1 stderr');

        fs.rmSync(`${stem}.pl`);
        const fallback = runCli([], {
          input: `[${sourceAtom(stem)}].\nchosen(X).\nhalt.\n`,
        });
        assertEqual(fallback.status, 0, 'fallback exit status');
        assertIncludes(fallback.stdout, 'X = bare.', 'unsuffixed fallback source');
        assertEqual(fallback.stderr, '', 'fallback stderr');
      },
    },
    {
      name: 'REPL consultation replaces earlier clauses from the same file (issue #46)',
      run: () => {
        const filename = path.join(tmp, `repl-reconsult-${++tmpCounter}.pl`);
        fs.writeFileSync(filename, 'factum(f).\n');
        const harness = path.join(tmp, `repl-reconsult-harness-${++tmpCounter}.mjs`);
        const consultedAtom = sourceAtom(filename);
        fs.writeFileSync(harness, `
import fs from 'node:fs';
import process from 'node:process';
import { spawn } from 'node:child_process';

const child = spawn(process.execPath, [${JSON.stringify(bin)}], { stdio: ['pipe', 'pipe', 'pipe'] });
let stdout = '';
let stderr = '';
let advanced = false;
let failed = false;
const timer = setTimeout(() => {
  failed = true;
  child.kill();
}, 5000);

child.stdout.setEncoding('utf8');
child.stderr.setEncoding('utf8');
child.stdout.on('data', (chunk) => {
  stdout += chunk;
  if (!advanced && stdout.includes('?-    true.\\n?- ')) {
    advanced = true;
    fs.writeFileSync(${JSON.stringify(filename)}, 'factum(g).\\n');
    child.stdin.write(\`[${consultedAtom}].\\nfindall(F,factum(F),Fs).\\nhalt.\\n\`);
  }
});
child.stderr.on('data', (chunk) => { stderr += chunk; });
child.on('close', (code) => {
  clearTimeout(timer);
  process.stdout.write(stdout);
  process.stderr.write(stderr);
  process.exitCode = failed ? 99 : (code ?? 98);
});
child.stdin.write(\`[${consultedAtom}].\\n\`);
`);
        const result = spawnSync(process.execPath, [harness], {
          cwd: packageRoot,
          encoding: 'utf8',
          timeout: 7000,
        });
        assertEqual(result.error?.code, undefined, 'reconsult harness timeout');
        assertEqual(result.status, 0, `exit status; stderr=${result.stderr}`);
        assertIncludes(result.stdout, 'Fs = \"g\".', 'reconsulted clauses');
        assertNotIncludes(result.stdout, 'f', 'stale clause removed');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'REPL consult/1 has reconsult semantics',
      run: () => {
        const filename = path.join(tmp, `repl-consult-predicate-${++tmpCounter}.pl`);
        fs.writeFileSync(filename, 'factum(f).\n');
        const harness = path.join(tmp, `repl-consult-predicate-harness-${++tmpCounter}.mjs`);
        const consultedAtom = sourceAtom(filename);
        fs.writeFileSync(harness, `
import fs from 'node:fs';
import process from 'node:process';
import { spawn } from 'node:child_process';

const child = spawn(process.execPath, [${JSON.stringify(bin)}], { stdio: ['pipe', 'pipe', 'pipe'] });
let stdout = '';
let stderr = '';
let advanced = false;
let failed = false;
const timer = setTimeout(() => {
  failed = true;
  child.kill();
}, 5000);

child.stdout.setEncoding('utf8');
child.stderr.setEncoding('utf8');
child.stdout.on('data', (chunk) => {
  stdout += chunk;
  if (!advanced && stdout.includes('?-    true.\\n?- ')) {
    advanced = true;
    fs.writeFileSync(${JSON.stringify(filename)}, 'factum(g).\\n');
    child.stdin.write(\`consult(${consultedAtom}).\\nfindall(F,factum(F),Fs).\\nhalt.\\n\`);
  }
});
child.stderr.on('data', (chunk) => { stderr += chunk; });
child.on('close', (code) => {
  clearTimeout(timer);
  process.stdout.write(stdout);
  process.stderr.write(stderr);
  process.exitCode = failed ? 99 : (code ?? 98);
});
child.stdin.write(\`consult(${consultedAtom}).\\n\`);
`);
        const result = spawnSync(process.execPath, [harness], {
          cwd: packageRoot,
          encoding: 'utf8',
          timeout: 7000,
        });
        assertEqual(result.error?.code, undefined, 'consult/1 reconsult harness timeout');
        assertEqual(result.status, 0, `exit status; stderr=${result.stderr}`);
        assertIncludes(result.stdout, 'Fs = "g".', 'consult/1 replaced earlier clauses');
        assertNotIncludes(result.stdout, 'f', 'consult/1 removed stale clause');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'REPL preserves runtime unknown flag across consultation',
      run: () => {
        const filename = path.join(tmp, `repl-empty-${++tmpCounter}.pl`);
        fs.writeFileSync(filename, '');
        const result = runCli([], {
          input:
            'current_prolog_flag(unknown, V).\n' +
            'set_prolog_flag(unknown, fail).\n' +
            `[${sourceAtom(filename)}].\n` +
            'current_prolog_flag(unknown, V).\n' +
            'set_prolog_flag(unknown, error).\n' +
            `[${sourceAtom(filename)}].\n` +
            'missing_after_consult.\n' +
            'halt.\n',
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout,
          '?-    V = error.\n' +
          '?-    true.\n' +
          '?-    true.\n' +
          '?-    V = fail.\n' +
          '?-    true.\n' +
          '?-    true.\n' +
          '?-    error(existence_error(procedure, missing_after_consult / 0), eyeprolog).\n' +
          '?- ',
          'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'REPL autoload and explicit use_module coexist for Part 2 library predicates',
      run: () => {
        const result = runCli([], {
          input: 'append(X, Y, [1, 2, 3, 4]).\nuse_module(library(lists)).\nappend(X, Y, [1, 2, 3, 4]).\n\nhalt.\n',
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout,
          '?-    X = [], Y = [1, 2, 3, 4].\n' +
          '?-    true.\n' +
          '?-    X = [], Y = [1, 2, 3, 4]\n;  ... .\n?- ',
          'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'REPL combines canonical libraries with the Prologue facade',
      run: () => {
        const result = runCli([], {
          input:
            'use_module(library(freeze)).\n' +
            'use_module(library(lists)).\n' +
            'use_module(library(iso_ext)).\n' +
            'use_module(library(prologue)).\n' +
            'halt.\n',
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, '?-    true.\n?-    true.\n?-    true.\n?-    true.\n?- ', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'REPL halt status is returned by the CLI',
      run: () => {
        const result = runCli([], { input: 'halt(7).\n' });
        assertEqual(result.status, 7, 'exit status');
        assertEqual(result.stdout, '?- ', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'CLI loads an explicitly imported standard library module',
      run: () => {
        const result = runCli(['-'], {
          input: ':- use_module(library(lists), [member/2]).\n%% goal: answer(X)\nanswer(X) :- member(X, [library]).\n',
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'answer(library).\n', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'version comes from package.json',
      run: () => {
        const result = runCli(['--version']);
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, `eyeprolog ${pkg.version}\n`, 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: '-v shows package version',
      run: () => {
        const result = runCli(['-v']);
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, `eyeprolog ${pkg.version}\n`, 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'npm exec can run package CLI bin from checkout',
      run: () => {
        const result = spawnSync('npm', ['exec', '--offline', '--loglevel=silent', '--yes', '--package=.', '--', 'eyeprolog', '--version'], {
          cwd: packageRoot,
          encoding: 'utf8',
          env: { ...process.env, npm_config_update_notifier: 'false' },
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, `eyeprolog ${pkg.version}\n`, 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'npm can install the CLI under a user-owned prefix',
      run: () => {
        const prefix = path.join(tmp, `npm-prefix-${++tmpCounter}`);
        const installed = spawnSync('npm', [
          'install', '--global', '--prefix', prefix, '--loglevel=silent', '--no-audit', '--no-fund', '.',
        ], {
          cwd: packageRoot,
          encoding: 'utf8',
          env: { ...process.env, npm_config_update_notifier: 'false' },
        });
        assertEqual(installed.status, 0, 'install exit status');
        const executable = process.platform === 'win32'
          ? path.join(prefix, 'eyeprolog.cmd')
          : path.join(prefix, 'bin', 'eyeprolog');
        const result = spawnSync(executable, ['--version'], { encoding: 'utf8' });
        assertEqual(result.status, 0, 'installed CLI exit status');
        assertEqual(result.stdout, `eyeprolog ${pkg.version}\n`, 'installed CLI stdout');
        assertEqual(result.stderr, '', 'installed CLI stderr');
      },
    },
    {
      name: 'stdin input is accepted',
      run: () => {
        const result = runCli(['-'], { input: '%% goal: q(X, Y)\np(a, b).\nq(X, Y) :- p(X, Y).\n' });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'q(a, b).\n', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },

    {
      name: 'CLI reads repeated goal comments when --goal is omitted',
      run: () => {
        const input = [
          '%% goal: answer(first, X)',
          '%% goal: answer(second, X)',
          'value(first, one).',
          'value(second, two).',
          'answer(Kind, Value) :- value(Kind, Value).',
          '',
        ].join('\n');
        const result = runCli(['-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'answer(first, one).\nanswer(second, two).\n', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'explicit CLI goals override goal comments',
      run: () => {
        const input = [
          '%% goal: answer(metadata, X)',
          'value(metadata, ignored).',
          'value(explicit, selected).',
          'answer(Kind, Value) :- value(Kind, Value).',
          '',
        ].join('\n');
        const result = runCli(['--goal', 'answer(explicit, X)', '-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'answer(explicit, selected).\n', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: '-g supplies an explicit CLI goal',
      run: () => {
        const input = [
          '%% goal: answer(metadata, X)',
          'value(metadata, ignored).',
          'value(explicit, selected).',
          'answer(Kind, Value) :- value(Kind, Value).',
          '',
        ].join('\n');
        const result = runCli(['-g', 'answer(explicit, X)', '-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'answer(explicit, selected).\n', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: '--quiet preserves goal side effects without printing answer terms',
      run: () => {
        const input = 'emit :- write(side_effect), nl.\n';
        const quiet = runCli(['--quiet', '--goal', 'emit', '-'], { input });
        assertEqual(quiet.status, 0, 'quiet exit status');
        assertEqual(quiet.stdout, 'side_effect\n', 'quiet stdout');
        assertEqual(quiet.stderr, '', 'quiet stderr');

        const ordinary = runCli(['--goal', 'emit', '-'], { input });
        assertEqual(ordinary.stdout, 'side_effect\nemit.\n', 'ordinary answer output remains unchanged');
      },
    },
    {
      name: '-g requires a goal argument',
      run: () => {
        const result = runCli(['-g']);
        assertEqual(result.status, 1, 'exit status');
        assertEqual(result.stdout, '', 'stdout');
        assertEqual(result.stderr, 'eyeprolog: option -g requires a goal\n', 'stderr');
      },
    },

    {
      name: '--proof enables query explanations',
      run: () => {
        const result = runCli(['--proof', '-'], { input: '%% goal: q(X, Y)\np(a, b).\nq(X, Y) :- p(X, Y).\n' });
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stdout, 'q(a, b).\nwhy(', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: '-p enables query explanations',
      run: () => {
        const result = runCli(['-p', '-'], { input: '%% goal: q(X, Y)\np(a, b).\nq(X, Y) :- p(X, Y).\n' });
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stdout, 'q(a, b).\nwhy(', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },

    {
      name: '--proof-detail expanded exposes bundled Prolog library clauses',
      run: () => {
        const input = '%% goal: q(a)\n:- use_module(library(lists)).\nq(X) :- member(X, [a,b]).\n';
        const result = runCli(['--proof-detail', 'expanded', '-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stdout, 'by(fact("src/lib/lists.pl"', 'expanded library source');
        assertNotIncludes(result.stdout, 'by(library(member, 2))', 'abstract library boundary');
      },
    },
    {
      name: '--verify-proof accepts saved why/2 proof output and rejects tampering',
      run: () => {
        const programFile = path.join(tmp, `proof-program-${++tmpCounter}.pl`);
        const proofFile = path.join(tmp, `proof-certificate-${++tmpCounter}.pl`);
        fs.writeFileSync(programFile, '%% goal: q(a)\np(a).\nq(X) :- p(X).\n');
        const generated = runCli(['--proof', programFile]);
        assertEqual(generated.status, 0, 'proof generation status');
        fs.writeFileSync(proofFile, generated.stdout);
        const verified = runCli(['--verify-proof', proofFile, programFile]);
        assertEqual(verified.status, 0, 'verification status');
        assertEqual(verified.stdout, 'verified 1 proof certificate.\n', 'verification stdout');
        const strictVerified = runCli(['--iso-strict', '--verify-proof', proofFile, programFile]);
        assertEqual(strictVerified.status, 0, 'strict verification status');
        assertEqual(strictVerified.stdout, 'verified 1 proof certificate.\n', 'strict verification stdout');
        const tamperedFile = path.join(tmp, `proof-certificate-bad-${++tmpCounter}.pl`);
        fs.writeFileSync(tamperedFile, generated.stdout.replace('goal(p(a))', 'goal(p(b))'));
        const rejected = runCli(['--verify-proof', tamperedFile, programFile]);
        assertEqual(rejected.status, 1, 'tampered verification status');
        assertIncludes(rejected.stderr, 'proof certificate 1 failed verification', 'tampered verification stderr');
      },
    },
    {
      name: '-pw combines proof and warning flags',
      run: () => {
        const input = [
          '%% goal: answer(ok)',
          'p :- \\+ q.',
          'q :- \\+ p.',
          'seed.',
          'answer(ok) :- seed.',
          '',
        ].join('\n');
        const result = runCli(['-pw', '-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stdout, 'answer(ok).\nwhy(', 'stdout');
        assertIncludes(result.stderr, 'eyeprolog warning: unstratified negation\n', 'stderr');
      },
    },
    {
      name: 'unknown option in a short cluster is rejected',
      run: () => {
        const result = runCli(['-px']);
        assertEqual(result.status, 1, 'exit status');
        assertEqual(result.stdout, '', 'stdout');
        assertIncludes(result.stderr, 'eyeprolog: unknown option: -px\n', 'stderr');
      },
    },


    {
      name: '--stats prints solver and memory statistics to stderr',
      run: () => {
        const result = runCli(['--stats', '-'], { input: '%% goal: q(X, Y)\np(a, b).\nq(X, Y) :- p(X, Y).\n' });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'q(a, b).\n', 'stdout');
        assertIncludes(result.stderr, 'eyeprolog stats:\n', 'stderr');
        assertIncludes(result.stderr, '  solve_goals_calls:', 'stderr');
        assertIncludes(result.stderr, '  memory_heap_used_bytes:', 'stderr');
        assertIncludes(result.stderr, '  memory_old_generation_used_bytes:', 'stderr');
        assertIncludes(result.stderr, '  memory_guard_used_bytes:', 'stderr');
        assertIncludes(result.stderr, '  memory_rss_bytes:', 'stderr');
        assertIncludes(result.stderr, '  memory_soft_limit_bytes:', 'stderr');
        assertIncludes(result.stderr, '  memory_hard_limit_bytes:', 'stderr');
      },
    },
    {
      name: '--stats is still printed when a query raises an error',
      run: () => {
        const result = runCli(['--stats', '-'], { input: "%% goal: number_chars(N, ['x'])\n" });
        assertEqual(result.status, 1, 'exit status');
        assertIncludes(result.stderr, 'eyeprolog stats:\n', 'stderr');
        assertIncludes(result.stderr, '  memory_heap_used_bytes:', 'stderr');
        assertIncludes(result.stderr, 'eyeprolog: error(syntax_error(number))', 'stderr');
      },
    },
    {
      name: '-s prints solver statistics to stderr',
      run: () => {
        const result = runCli(['-s', '-'], { input: '%% goal: q(X, Y)\np(a, b).\nq(X, Y) :- p(X, Y).\n' });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'q(a, b).\n', 'stdout');
        assertIncludes(result.stderr, 'eyeprolog stats:\n', 'stderr');
        assertIncludes(result.stderr, '  solve_goals_calls:', 'stderr');
      },
    },
    {
      name: 'statistics/0 prints snapshots during execution',
      run: () => {
        const input = '%% goal: live\nlive :- statistics, statistics.\n';
        const result = runCli(['-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertEqual((result.stdout.match(/eyeprolog stats:/g) ?? []).length, 2, 'in-run snapshot count');
        assertIncludes(result.stdout, '  memory_guard_used_bytes:', 'stdout');
        assertIncludes(result.stdout, 'live.\n', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'statistics/2 exposes current counters and memory values',
      run: () => {
        const input = '%% goal: live(Used)\nlive(Used) :- statistics(memory_guard_used_bytes, Used).\n';
        const result = runCli(['-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(/^live\(\d+\)\.\n$/.test(result.stdout), true, 'numeric memory statistic');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'statistics/2 rejects unknown keys instead of silently failing (issue #45)',
      run: () => {
        const result = runCli([], { input: 'statistics(nonsense, Value).\nhalt.\n' });
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stdout,
          'error(domain_error(statistics_key, nonsense), eyeprolog).',
          'statistics key error');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'statistics predicates are excluded from strict ISO mode',
      run: () => {
        const result = runCli(['--iso-strict', '-'], { input: '%% goal: statistics\n' });
        assertEqual(result.status, 1, 'exit status');
        assertIncludes(result.stderr, 'existence_error(procedure)', 'stderr');
      },
    },
    {
      name: 'portable library predicates autoload without use_module directives',
      run: () => {
        const input = '%% goal: answer(X)\nanswer(X) :- member(X, [a,b]).\n';
        const result = runCli(['-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'answer(a).\nanswer(b).\n', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'between/3 autoload removes the EyeProlog-specific prologue dependency',
      run: () => {
        const input = '%% goal: answer(X)\nanswer(X) :- between(1, 3, X).\n';
        const result = runCli(['-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'answer(1).\nanswer(2).\nanswer(3).\n', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'interactive top level autoloads unresolved bundled predicates',
      run: () => {
        const result = runCli([], {
          input: 'append(X,Y,[1,2]).\n;\nhalt.\n',
        });
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stdout, 'X = [], Y = [1, 2]', 'first append/3 answer');
        assertIncludes(result.stdout, 'X = [1], Y = [2].', 'second append/3 answer');
        assertNotIncludes(result.stdout, 'existence_error(procedure, append / 3)', 'autoload failure');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'all bundled library exports participate in generic autoloading',
      run: () => {
        const input = [
          '%% goal: pair_answer(K,V)',
          '%% goal: string_answer(X)',
          '%% goal: prime_answer(X)',
          'pair_answer(K,V) :- pairs_keys_values([a-1,b-2], K, V).',
          'string_answer(X) :- uppercase("hello", X).',
          'prime_answer(X) :- smallest_divisor_from(91, 2, X).',
          '',
        ].join('\n');
        const result = runCli(['-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout,
          'pair_answer("ab", [1, 2]).\nstring_answer(\'HELLO\').\nprime_answer(7).\n', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'generic autoload index is generated from every bundled library module',
      run: () => {
        assertEqual(eyePrologLibraryAutoload['member/2'], 'lists', 'facade duplicate resolves to defining lists module');
        assertEqual(eyePrologLibraryAutoload['pairs_keys_values/3'], 'pairs', 'pairs export is autoloadable');
        assertEqual(eyePrologLibraryAutoload['uppercase/2'], 'strings', 'strings export is autoloadable');
        assertEqual(eyePrologLibraryAutoload['smallest_divisor_from/3'], 'primes', 'primes export is autoloadable');
        assertEqual(Object.keys(eyePrologAmbiguousLibraryAutoload).length, 0, 'current bundled surface has no unresolved export ambiguities');
        assertEqual(eyePrologLibraryAutoloadModules.length, standardLibrarySources.size, 'every registered bundled module is indexed');
        assertEqual([...standardLibrarySources.keys()].sort().join(','), [...eyePrologLibraryAutoloadModules].sort().join(','), 'autoload module index matches bundled sources');
      },
    },
    {
      name: 'between/3 generated values avoid recursive environment chains (issue #52)',
      run: () => {
        const goalText = 'between(1, 1024, X), X < 0';
        const program = Program.parse('', { autoloadGoals: [goalText] });
        const solver = new Solver(program, { registry: getEyePrologRegistry() });
        const goal = parseGoalText(goalText, {
          operatorDefinitions: [...solver.program.operators.values()],
        });
        let answers = 0;
        for (const _env of solver.solve([goal], new Env(), 0)) answers++;
        assertEqual(answers, 0, 'positive generated values fail X < 0');
        assertEqual(solver.stats.unify_calls, 1024, 'one output unification per generated integer');
        assertEqual(solver.stats.max_depth <= 4, true, 'generation stays at bounded solver depth');
      },
    },
    {
      name: 'library(lists) length/2 stays relational and call_nth/2 autoloads (issue #28)',
      run: () => {
        const input = [
          ':- use_module(library(lists)).',
          '%% goal: fourth_length(N)',
          'fourth_length(N) :- call_nth(length(_Xs, N), 4).',
          '',
        ].join('\n');
        const result = runCli(['-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'fourth_length(3).\n', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'library(lists) and library(iso_ext) co-import without collisions',
      run: () => {
        const input = [
          ':- use_module(library(lists)).',
          ':- use_module(library(iso_ext)).',
          '%% goal: answer(N)',
          'answer(N) :- call_nth(member(_, [a,b,c]), N), N = 2.',
          '',
        ].join('\n');
        const result = runCli(['--portable', '--no-autoload', '-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'answer(2).\n', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'strict ISO mode disables bundled-library autoloading',
      run: () => {
        const input = '%% goal: answer(X)\nanswer(X) :- member(X, [a,b]).\n';
        const result = runCli(['--iso-strict', '-'], { input });
        assertEqual(result.status, 1, 'exit status');
        assertIncludes(result.stderr, 'existence_error(procedure)', 'stderr');
        assertIncludes(result.stderr, '/(member, 2)', 'stderr');
      },
    },
    {
      name: 'CLI top-level goals participate in bundled-library autoloading',
      run: () => {
        const result = runCli(['-g', 'member(X,[a,b])', '-'], { input: '' });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'member(a, "ab").\nmember(b, "ab").\n', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: '--no-auto-table has been removed from the CLI',
      run: () => {
        const result = runCli(['--no-auto-table', '-'], { input: '' });
        assertEqual(result.status, 1, 'exit status');
        assertIncludes(result.stderr, 'unknown option: --no-auto-table', 'stderr');
      },
    },
    {
      name: '--no-autoload also applies to CLI top-level goals',
      run: () => {
        const result = runCli(['--no-autoload', '-g', 'member(X,[a])', '-'], { input: '' });
        assertEqual(result.status, 1, 'exit status');
        assertIncludes(result.stderr, 'existence_error(procedure)', 'stderr');
        assertIncludes(result.stderr, '/(member, 2)', 'stderr');
      },
    },
    {
      name: '--portable checks non-portable predicates used only by top-level goals',
      run: () => {
        const input = ':- use_module(library(lists)).\n';
        const result = runCli(['--portable', '-g', 'set_nth0(0,[a],b,X)', '-'], { input });
        assertEqual(result.status, 1, 'exit status');
        assertEqual(result.stdout, '', 'stdout');
        assertIncludes(result.stderr, 'non-portable library predicate', 'stderr');
        assertIncludes(result.stderr, 'set_nth0/4', 'stderr');
      },
    },
    {
      name: '--portable accepts the common interop profile',
      run: () => {
        const input = ':- use_module(library(lists)).\n%% goal: answer(X)\nanswer(X) :- member(X, [a]).\n';
        const result = runCli(['--portable', '-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'answer(a).\n', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'traditional depth-first mode keeps deep non-tail continuations bounded',
      run: () => {
        const source = `
countdown(0, 0) :- !.
countdown(N, Result) :-
    Next is N-1,
    countdown(Next, Partial),
    Result is Partial+1.
answer(Result) :- countdown(2048, Result), Result = 2048.
`;
        const result = run(source, { goal: 'answer(Result)' });
        assertEqual(result.stdout, 'answer(2048).\n', 'deep non-tail answer');
        assertEqual(result.stats.max_goal_count <= 70, true,
          'caller continuations stay opaque instead of growing one goal per recursive layer');
      },
    },
    {
      name: '--portable rejects implementation-specific library dependencies',
      run: () => {
        const input = ':- use_module(library(prologue), [between/3]).\n%% goal: answer\nanswer :- between(1, 1, _).\n';
        const result = runCli(['--portable', '-'], { input });
        assertEqual(result.status, 1, 'exit status');
        assertEqual(result.stdout, '', 'stdout');
        assertIncludes(result.stderr, 'non-portable library dependency', 'stderr');
      },
    },
    {
      name: '--no-autoload exposes unresolved portable dependencies',
      run: () => {
        const input = '%% goal: answer(X)\nanswer(X) :- member(X, [a]).\n';
        const result = runCli(['--no-autoload', '-'], { input });
        assertEqual(result.status, 1, 'exit status');
        assertIncludes(result.stderr, 'existence_error(procedure)', 'stderr');
        assertIncludes(result.stderr, '/(member, 2)', 'stderr');
      },
    },
    {
      name: 'CLI reports singleton source variables without a corpus-wide warning scan',
      run: () => {
        const input = 'p(X, Once, _Ignored, _) :- q(X).\nq(a).\n';
        const result = runCli(['-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, '', 'stdout');
        assertEqual(result.stderr, 'Warning: singleton: Once, near <stdin>:1\n', 'stderr');
      },
    },
    {
      name: 'singleton warnings preserve the compact binary parser path',
      run: () => {
        const clauses = [];
        const binary = [];
        const warnings = [];
        const parsed = tryParseClausesFastInto(
          'p(X,Y) :- q(X,a).\n',
          (clause) => clauses.push(clause),
          (...args) => binary.push(args),
          { filename: 'fast.pl', onWarning: (warning) => warnings.push(warning) },
        );
        assertEqual(parsed, true, 'fast parse result');
        assertEqual(clauses.length, 0, 'materialized clause count');
        assertEqual(binary.length, 1, 'direct binary clause count');
        assertEqual(warnings.length, 1, 'warning count');
        assertEqual(warnings[0].kind, 'singleton', 'warning kind');
        assertEqual(warnings[0].name, 'Y', 'warning variable');
        assertEqual(warnings[0].filename, 'fast.pl', 'warning filename');
        assertEqual(warnings[0].line, 1, 'warning line');
      },
    },
    {
      name: '--warnings flags explicit library(prologue) dependencies',
      run: () => {
        const input = ':- use_module(library(prologue), [between/3]).\n%% goal: answer\nanswer :- between(1, 1, _).\n';
        const result = runCli(['--warnings', '-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stderr, 'eyeprolog warning: non-portable library dependency\n', 'stderr');
        assertIncludes(result.stderr, 'library(prologue) is outside the EyeProlog/Trealla/Scryer interop profile', 'stderr');
      },
    },
    {
      name: '--warnings flags EyeProlog-only predicates from library(lists)',
      run: () => {
        const input = ':- use_module(library(lists)).\n%% goal: answer(X)\nanswer(X) :- set_nth0(0, [a], b, X).\n';
        const result = runCli(['--warnings', '-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stderr, 'eyeprolog warning: non-portable library predicate\n', 'stderr');
        assertIncludes(result.stderr, 'set_nth0/4 from library(lists) is outside the interop profile', 'stderr');
      },
    },
    {
      name: '--warnings stays quiet for the common library(lists) profile',
      run: () => {
        const input = ':- use_module(library(lists)).\n%% goal: answer(X)\nanswer(X) :- member(X, [a]).\n';
        const result = runCli(['--warnings', '-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'answer(a).\n', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: '--warnings prints unstratified negation diagnostics without failing',
      run: () => {
        const input = [
          '%% goal: answer(X)',
          'p(a) :- \\+ q(a).',
          'q(a) :- \\+ p(a).',
          'answer(ok).',
          '',
        ].join('\n');
        const result = runCli(['--warnings', '-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, '', 'stdout');
        assertIncludes(result.stderr, 'eyeprolog warning: unstratified negation\n', 'stderr');
        assertIncludes(result.stderr, 'p/1 depends negatively on q/1', 'stderr');
        assertIncludes(result.stderr, 'q/1 depends negatively on p/1', 'stderr');
      },
    },
    {
      name: '-w prints unstratified negation diagnostics without failing',
      run: () => {
        const input = [
          '%% goal: answer(X)',
          'p(a) :- \\+ q(a).',
          'q(a) :- \\+ p(a).',
          'answer(ok).',
          '',
        ].join('\n');
        const result = runCli(['-w', '-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, '', 'stdout');
        assertIncludes(result.stderr, 'eyeprolog warning: unstratified negation\n', 'stderr');
      },
    },
    {
      name: '--warnings stays quiet for stratified negation',
      run: () => {
        const input = '%% goal: answer(X)\np(a).\nq(_) :- fail.\nanswer(ok) :- \\+ q(a).\n';
        const result = runCli(['--warnings', '-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'answer(ok).\n', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'double dash permits option-shaped file names',
      run: () => {
        const file = path.join(tmp, '-h');
        fs.writeFileSync(file, '%% goal: q(X, Y)\np(a, b).\nq(X, Y) :- p(X, Y).\n');
        const result = runCli(['--', file]);
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'q(a, b).\n', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'explicit CLI conjunction goals execute every conjunct',
      run: () => {
        const failing = runCli(['--goal', 'a(X), b', '-'], {
          input: 'a(ok) :- true.\nb :- fail.\n',
        });
        assertEqual(failing.status, 0, 'failing conjunction status');
        assertEqual(failing.stdout, '', 'failing conjunction stdout');

        const succeeding = runCli(['--goal', 'a(X), b', '-'], {
          input: 'a(ok) :- true.\nb.\n',
        });
        assertEqual(succeeding.status, 0, 'succeeding conjunction status');
        assertEqual(succeeding.stdout, 'a(ok), b.\n', 'succeeding conjunction stdout');
      },
    },
    {
      name: 'CLI answers render nested active operators with precedence',
      run: () => {
        const result = runCli(['--goal', 'answer(Domain)', '-'], {
          input: ':- use_module(library(clpz)).\nanswer(Domain) :- X in 2..4 \\/ 7, fd_dom(X, Domain).\n',
        });
        assertEqual(result.status, 0, 'operator answer status');
        assertEqual(result.stdout, 'answer(2..4 \\/ 7).\n', 'operator answer stdout');
        assertEqual(result.stderr, '', 'operator answer stderr');
      },
    },
    {
      name: 'include shares operator declarations in both directions',
      run: () => {
        const directory = path.join(tmp, `include-operators-${++tmpCounter}`);
        fs.mkdirSync(directory);
        fs.writeFileSync(path.join(directory, 'child.pl'), [
          'child_rule :- carol likes dave.',
          ':- op(500, xfx, trusts).',
          '',
        ].join('\n'));
        const parent = [
          ':- op(500, xfx, likes).',
          ":- include('child.pl').",
          'parent_rule :- alice trusts bob.',
          '',
        ].join('\n');
        const program = Program.parseSources([{
          text: parent,
          filename: 'parent.pl',
          baseDir: directory,
        }], { sourceMetadata: false });
        assertEqual(
          termToString(program.findGroup('child_rule', 0).clauses[0].body[0], new Env(), true),
          'likes(carol, dave)',
          'operator declared by parent',
        );
        assertEqual(
          termToString(program.findGroup('parent_rule', 0).clauses[0].body[0], new Env(), true),
          'trusts(alice, bob)',
          'operator declared by child',
        );
      },
    },
    {
      name: 'ensure_loaded treats the top-level source as already loaded',
      run: () => {
        const directory = path.join(tmp, `ensure-self-${++tmpCounter}`);
        fs.mkdirSync(directory);
        const filename = path.join(directory, 'self.pl');
        const text = "a.\n:- ensure_loaded('self.pl').\nb.\n";
        fs.writeFileSync(filename, text);
        const program = Program.parseSources([{
          text,
          filename: 'self.pl',
          baseDir: directory,
        }], { sourceMetadata: false });
        assertEqual(program.clauses.length, 2, 'clause count');
        assertEqual(program.findGroup('a', 0).clauses.length, 1, 'a/0 count');
        assertEqual(program.findGroup('b', 0).clauses.length, 1, 'b/0 count');
      },
    },
    {
      name: 'ISO operator atoms are valid functional and list arguments',
      run: () => {
        const source = [
          'operator_argument(ok) :- current_op(1200, xfx, :-), [:-,-] = [:-,-].',
          '',
        ].join('\n');
        assertEqual(run(source, { goal: 'operator_argument(ok)' }).stdout, 'operator_argument(ok).\n', 'operator argument syntax');
      },
    },
    {
      name: 'ISO writeq preserves operator atoms in argument syntax',
      run: () => {
        const source = [
          'emit_operator_arguments :-',
          "  writeq([:-,-]), put_char('|'),",
          "  writeq(f(*)), put_char('|'),",
          "  writeq(f(;,'|',';;')).",
          '',
        ].join('\n');
        assertEqual(
          run(source, { goal: 'emit_operator_arguments' }).stdout,
          "[:-,-]|f(*)|f(;,'|',';;')emit_operator_arguments.\n",
          'operator argument output',
        );
      },
    },
    {
      name: 'ISO query operator and quad infix extension are visible through current_op/3',
      run: () => {
        assertEqual(
          run('', { goal: 'current_op(Priority, Specifier, ?-)' }).stdout,
          "current_op(1200, fx, ?-).\ncurrent_op(1200, xfx, ?-).\n",
          'query operator definitions',
        );
        assertEqual(
          run('', { goal: 'current_op(1200, fx, ?-)' }).stdout,
          "current_op(1200, fx, ?-).\n",
          'ISO query prefix operator',
        );
        assertEqual(
          run('', { goal: 'current_op(1200, xfx, ?-)' }).stdout,
          "current_op(1200, xfx, ?-).\n",
          'quad query infix operator',
        );
        const prefix = parseGoalText('(?- true)');
        assertEqual(prefix.name, '?-', 'prefix query functor');
        assertEqual(prefix.arity, 1, 'prefix query arity');
        const infix = parseGoalText('(label ?- true)');
        assertEqual(infix.name, '?-', 'quad query functor');
        assertEqual(infix.arity, 2, 'quad query arity');
      },
    },
    {
      name: 'normal EyeProlog uses the ISO unknown=error default',
      run: () => {
        const program = Program.parse('');
        const solver = new Solver(program, { registry: getEyePrologRegistry() });
        assertEqual(solver.prologFlags.get('unknown')?.value?.name, 'error', 'normal unknown default');
        assertEqual(
          run('', { goal: 'current_prolog_flag(unknown, V)' }).stdout,
          'current_prolog_flag(unknown, error).\n',
          'public runner unknown default',
        );
      },
    },
    {
      name: 'strict ISO core mode exposes only the Part 1 registry and flag surface',
      run: () => {
        const program = Program.parse('', { isoStrict: true });
        const solver = new Solver(program, { isoStrict: true });
        const registry = getStrictIsoRegistry();
        assertEqual(Boolean(registry.get('subsumes_term', 2)), true, 'Corrigendum 2 predicate');
        assertEqual(Boolean(registry.get('phrase', 2)), false, 'Part 3 phrase excluded');
        assertEqual(Boolean(registry.get('phrase', 3)), false, 'Part 3 phrase/3 excluded');
        assertEqual(Boolean(registry.get('true', 0)), true, 'Part 1 true/0');
        assertEqual(solver.prologFlags.has('occurs_check'), false, 'implementation-specific flag excluded');
        assertEqual(solver.prologFlags.get('unknown')?.value?.name, 'error', 'ISO unknown default');
      },
    },
    {
      name: 'strict ISO core mode keeps prefix ?- but removes the predefined quad infix form',
      run: () => {
        const program = Program.parse('', { isoStrict: true });
        assertEqual(program.operators.has('fx\u0000?-'), true, 'ISO ?-/1');
        assertEqual(program.operators.has('xfx\u0000?-'), false, 'quad ?-/2');
        const added = Program.parse(':- op(1200,xfx,?-).\nleft ?- right.\n', { isoStrict: true });
        assertEqual(Boolean(added.findGroup('?-', 2)), true, 'explicit conforming op/3 may add ?-/2');
        assertEqual(added.quads.length, 0, 'strict source never records quads');
      },
    },
    {
      name: 'strict ISO core mode rejects EyeProlog module directives',
      run: () => {
        let caught = null;
        try {
          Program.parse(':- use_module(library(lists)).\n', { isoStrict: true });
        } catch (error) {
          caught = error;
        }
        if (!caught) throw new Error('strict ISO source unexpectedly accepted use_module/1');
        assertIncludes(caught.message, 'implementation-specific directive use_module/1', 'strict directive error');
      },
    },
    {
      name: 'strict ISO core mode does not expand Part 3 grammar rules',
      run: () => {
        const strict = Program.parse('sentence --> [a].\n', { isoStrict: true });
        const normal = Program.parse('sentence --> [a].\n');
        assertEqual(Boolean(strict.findGroup('-->', 2)), true, 'strict -->/2 ordinary predicate');
        assertEqual(Boolean(strict.findGroup('sentence', 2)), false, 'strict no DCG expansion');
        assertEqual(Boolean(normal.findGroup('sentence', 2)), true, 'normal DCG expansion');
      },
    },
    {
      name: 'strict ISO core mode rejects clauses for standardized built-ins',
      run: () => {
        let caught = null;
        try {
          Program.parse('true.\n', { isoStrict: true });
        } catch (error) {
          caught = error;
        }
        if (!caught) throw new Error('strict ISO source unexpectedly redefined true/0');
        assertEqual(caught.formal, 'permission_error(modify, static_procedure)', 'strict static-procedure error');
      },
    },
    {
      name: 'strict ISO clause/2 keeps static procedures private and dynamic procedures public',
      run: () => {
        const staticProgram = Program.parse('p.\n', { isoStrict: true });
        const staticSolver = new Solver(staticProgram, { isoStrict: true });
        let caught = null;
        try {
          [...staticSolver.solve([parseGoalText('clause(p,B)', { isoStrict: true })], new Env(), 0)];
        } catch (error) {
          caught = error;
        }
        if (!caught) throw new Error('strict clause/2 unexpectedly inspected a static procedure');
        assertEqual(caught.formal, 'permission_error(access, private_procedure)', 'static clause privacy');

        const dynamicProgram = Program.parse(':- dynamic(p/0).\np.\n', { isoStrict: true });
        const dynamicSolver = new Solver(dynamicProgram, { isoStrict: true });
        const answers = [...dynamicSolver.solve([parseGoalText('clause(p,B)', { isoStrict: true })], new Env(), 0)];
        assertEqual(answers.length, 1, 'dynamic clause answer count');
      },
    },
    {
      // ISO 7.6.2 a/b, checked against the 8.8.1.4 worked example for legs/2.
      name: 'preparing a Prolog text converts variable body goals to call/1',
      run: () => {
        const program = Program.parse(':- dynamic(legs/2).\nlegs(A, 7) :- A, call(A).\n');
        const solver = new Solver(program, {});
        const goal = parseGoalText('clause(legs(c, 7), Body)');
        const answers = [...solver.solve([goal], new Env(), 0)];
        assertEqual(answers.length, 1, 'clause answer count');
        assertEqual(termToString(copyResolved(goal.args[1], answers[0])), '(call(c), call(c))', 'converted body');
      },
    },
    {
      name: 'preparation and assertz/1 agree on clause body conversion',
      run: () => {
        const fromText = Program.parse(':- dynamic(p/1).\np(G) :- G.\n');
        const textGoal = parseGoalText('clause(p(true), B)');
        const textAnswers = [...new Solver(fromText, {}).solve([textGoal], new Env(), 0)];
        const asserted = Program.parse('run(B) :- assertz((q(G) :- G)), clause(q(true), B).\n');
        const assertGoal = parseGoalText('run(B)');
        const assertAnswers = [...new Solver(asserted, {}).solve([assertGoal], new Env(), 0)];
        assertEqual(textAnswers.length, 1, 'text clause answer count');
        assertEqual(assertAnswers.length, 1, 'asserted clause answer count');
        assertEqual(
          termToString(copyResolved(textGoal.args[1], textAnswers[0])),
          termToString(copyResolved(assertGoal.args[0], assertAnswers[0])),
          'converted bodies agree',
        );
      },
    },
    {
      // 7.6.2 b converts the arguments of ;/2 and ->/2 recursively.
      name: 'body conversion recurses through disjunction and if-then',
      run: () => {
        const program = Program.parse(':- dynamic(r/3).\nr(A, B, C) :- (A ; B), (C -> true ; true).\n');
        const solver = new Solver(program, {});
        const goal = parseGoalText('clause(r(a, b, c), Body)');
        const answers = [...solver.solve([goal], new Env(), 0)];
        assertEqual(answers.length, 1, 'clause answer count');
        assertEqual(
          termToString(copyResolved(goal.args[1], answers[0])),
          "(';'(call(a), call(b)), ';'(->(call(c), true), true))",
          'recursively converted body',
        );
      },
    },
    {
      // 7.8.3: a cut inside call/1 is local, so the remaining clauses survive.
      name: 'a variable body goal from a Prolog text keeps cut local',
      run: () => {
        const program = Program.parse('s(G) :- G.\ns(_) :- true.\n');
        const solver = new Solver(program, {});
        const answers = [...solver.solve([parseGoalText('s(!)')], new Env(), 0)];
        assertEqual(answers.length, 2, 'cut did not prune the second clause');
      },
    },
    {
      // https://github.com/eyereasoner/eyeprolog/issues/97
      name: 'a Prolog text cannot supply clauses for a built-in predicate',
      run: () => {
        let caught = null;
        try {
          Program.parse('clause(elk(1), 2).\n');
        } catch (error) {
          caught = error;
        }
        if (!caught) throw new Error('a clause for clause/2 was accepted from a Prolog text');
        assertEqual(caught.formal, 'permission_error(modify, static_procedure)', 'formal error');
        assertEqual(termToString(caught.culprit), '/(clause, 2)', 'culprit predicate indicator');
      },
    },
    {
      name: 'consult and asserta/1 agree on redefining a built-in',
      run: () => {
        let textFormal = null;
        try {
          Program.parse('clause(elk(1), 2).\n');
        } catch (error) {
          textFormal = error.formal;
        }
        const solver = new Solver(Program.parse('run :- asserta(clause(elk(1), 2)).\n'), {});
        let assertFormal = null;
        try {
          [...solver.solve([parseGoalText('run')], new Env(), 0)];
        } catch (error) {
          assertFormal = error.formal;
        }
        assertEqual(textFormal, 'permission_error(modify, static_procedure)', 'consult path');
        assertEqual(assertFormal, textFormal, 'assert path agrees with consult');
      },
    },
    {
      // Control constructs are covered as well as built-in predicates.
      name: 'a Prolog text cannot supply clauses for a control construct',
      run: () => {
        for (const [source, indicator] of [
          ["';'(a, b).\n", "/(';', 2)"],
          ["','(a, b).\n", "/(',', 2)"],
          ['!.\n', '/(!, 0)'],
        ]) {
          let caught = null;
          try {
            Program.parse(source);
          } catch (error) {
            caught = error;
          }
          assertEqual(caught?.formal, 'permission_error(modify, static_procedure)', `formal error for ${indicator}`);
          assertEqual(termToString(caught.culprit), indicator, `culprit for ${indicator}`);
        }
      },
    },
    {
      // EyeProlog's library and extension predicates are not standard
      // built-ins, so user programs may still define their own versions.
      name: 'a Prolog text may still redefine library predicates',
      run: () => {
        const program = Program.parse('member(X, [X]).\nappend([], L, L).\n');
        assertEqual(program.findGroup('member', 2) != null, true, 'member/2 defined by the text');
        assertEqual(program.findGroup('append', 3) != null, true, 'append/3 defined by the text');
      },
    },
    {
      // A dynamic/1 directive names a procedure the text is about to define,
      // so it is subject to the same restriction.
      name: 'a dynamic/1 directive cannot name a built-in predicate',
      run: () => {
        let caught = null;
        try {
          Program.parse(':- dynamic(atom_length/2).\n');
        } catch (error) {
          caught = error;
        }
        assertEqual(caught?.formal, 'permission_error(modify, static_procedure)', 'formal error');
        assertEqual(termToString(caught.culprit), '/(atom_length, 2)', 'culprit predicate indicator');
      },
    },
    {
      // ISO 7.5.3 NOTE: public/1 as an extension.
      name: 'a public/1 directive grants clause/2 access to a static procedure',
      run: () => {
        const program = Program.parse(':- public(elk/1).\nelk(X) :- moose(X).\nmoose(bertha).\n');
        const solver = new Solver(program, {});
        const answers = [...solver.solve([parseGoalText('clause(elk(_), _)')], new Env(), 0)];
        assertEqual(answers.length, 1, 'declared public procedure is readable');
        assertEqual(program.findGroup('elk', 1).dynamic, false, 'public does not imply dynamic');
      },
    },
    {
      name: 'a public/1 declaration still refuses database modification',
      run: () => {
        const solver = new Solver(Program.parse(':- public(elk/1).\nelk(bertha).\n'), {});
        for (const goal of ['assertz(elk(clara))', 'retract(elk(bertha))']) {
          let caught = null;
          try {
            [...solver.solve([parseGoalText(goal)], new Env(), 0)];
          } catch (error) {
            caught = error;
          }
          assertEqual(caught?.formal, 'permission_error(modify, static_procedure)', `${goal} is refused`);
        }
      },
    },
    {
      name: 'public/1 applies to clauses that precede the directive',
      run: () => {
        const program = Program.parse('elk(bertha).\n:- public(elk/1).\n');
        const solver = new Solver(program, {});
        const answers = [...solver.solve([parseGoalText('clause(elk(_), _)')], new Env(), 0)];
        assertEqual(answers.length, 1, 'earlier clauses become readable');
      },
    },
    {
      name: 'public/1 leaves undeclared procedures private',
      run: () => {
        const solver = new Solver(Program.parse(':- public(elk/1).\nelk(X) :- moose(X).\nmoose(bertha).\n'), {});
        let caught = null;
        try {
          [...solver.solve([parseGoalText('clause(moose(_), _)')], new Env(), 0)];
        } catch (error) {
          caught = error;
        }
        assertEqual(caught?.formal, 'permission_error(access, private_procedure)', 'sibling stays private');
      },
    },
    {
      // The meta-interpreter case: no annotation on the interpreted program.
      name: 'default_procedure_access public opens every user-defined procedure',
      run: () => {
        const source = ':- set_prolog_flag(default_procedure_access, public).\n' +
          'solve(true) :- !.\n' +
          'solve((A, B)) :- !, solve(A), solve(B).\n' +
          'solve(H) :- clause(H, Body), solve(Body).\n' +
          'elk(X) :- moose(X).\nmoose(bertha).\ngrazes(X) :- elk(X).\n';
        const solver = new Solver(Program.parse(source), {});
        const goal = parseGoalText('solve(grazes(W))');
        const answers = [...solver.solve([goal], new Env(), 0)];
        assertEqual(answers.length, 1, 'meta-interpreter answer count');
        assertEqual(termToString(copyResolved(goal.args[0], answers[0])), 'grazes(bertha)', 'meta-interpreter answer');
      },
    },
    {
      name: 'default_procedure_access public keeps procedures static and built-ins private',
      run: () => {
        const source = ':- set_prolog_flag(default_procedure_access, public).\nmoose(bertha).\n';
        const solver = new Solver(Program.parse(source), {});
        for (const [goal, formal] of [
          ['retract(moose(bertha))', 'permission_error(modify, static_procedure)'],
          ['clause(atom(_), _)', 'permission_error(access, private_procedure)'],
        ]) {
          let caught = null;
          try {
            [...solver.solve([parseGoalText(goal)], new Env(), 0)];
          } catch (error) {
            caught = error;
          }
          assertEqual(caught?.formal, formal, `${goal} is refused`);
        }
      },
    },
    {
      // public/1 and the flag are extensions, so the strict profile omits both.
      name: 'strict ISO core mode offers neither public/1 nor the access flag',
      run: () => {
        let caught = null;
        try {
          Program.parse(':- public(elk/1).\nelk(bertha).\n', { isoStrict: true });
        } catch (error) {
          caught = error;
        }
        if (!caught) throw new Error('public/1 was accepted in strict ISO core mode');
        // 8.17.4.3: an unknown flag name is a domain error, so the flag being
        // absent from the strict profile is observable that way.
        const solver = new Solver(Program.parse('elk(bertha).\n', { isoStrict: true }), { isoStrict: true });
        let flagError = null;
        try {
          [...solver.solve([parseGoalText('current_prolog_flag(default_procedure_access, _)', { isoStrict: true })], new Env(), 0)];
        } catch (error) {
          flagError = error;
        }
        assertEqual(flagError?.formal, 'domain_error(prolog_flag)', 'flag is absent in strict ISO core mode');
      },
    },
    {
      // https://github.com/eyereasoner/eyeprolog/issues/96
      name: 'clause/2 keeps static procedures private in the default mode',
      run: () => {
        const program = Program.parse('elk(X) :- moose(X).\nmoose(bertha).\n');
        const solver = new Solver(program, {});
        let caught = null;
        try {
          [...solver.solve([parseGoalText('clause(elk(N), Body)')], new Env(), 0)];
        } catch (error) {
          caught = error;
        }
        if (!caught) throw new Error('clause/2 unexpectedly inspected a static procedure');
        assertEqual(caught.formal, 'permission_error(access, private_procedure)', 'formal error');
        assertEqual(termToString(caught.culprit), '/(elk, 1)', 'culprit predicate indicator');
      },
    },
    {
      name: 'clause/2 inspects a procedure declared dynamic in the default mode',
      run: () => {
        const program = Program.parse(':- dynamic(elk/1).\nelk(X) :- moose(X).\nmoose(bertha).\n');
        const solver = new Solver(program, {});
        const answers = [...solver.solve([parseGoalText('clause(elk(N), Body)')], new Env(), 0)];
        assertEqual(answers.length, 1, 'dynamic clause answer count');
      },
    },
    {
      name: 'clause/2 inspects procedures created by assertz/1 in the default mode',
      run: () => {
        const program = Program.parse('run(Body) :- assertz(elk(bertha)), clause(elk(_), Body).\n');
        const solver = new Solver(program, {});
        const answers = [...solver.solve([parseGoalText('run(Body)')], new Env(), 0)];
        assertEqual(answers.length, 1, 'asserted clause answer count');
      },
    },
    {
      name: 'clause/2 and assertz/1 agree on which procedures are static',
      run: () => {
        const program = Program.parse('elk(bertha).\n');
        const solver = new Solver(program, {});
        const formals = [];
        for (const goal of ['clause(elk(_), Body)', 'assertz(elk(clara))', 'retract(elk(bertha))']) {
          try {
            [...solver.solve([parseGoalText(goal)], new Env(), 0)];
            formals.push(null);
          } catch (error) {
            formals.push(error.formal);
          }
        }
        assertEqual(formals[0], 'permission_error(access, private_procedure)', 'clause/2 access');
        assertEqual(formals[1], 'permission_error(modify, static_procedure)', 'assertz/1 modification');
        assertEqual(formals[2], 'permission_error(modify, static_procedure)', 'retract/1 modification');
      },
    },
    {
      // A static procedure stays private even when clause/2 is also given a
      // non-callable body, matching the existing strict-mode error ordering.
      name: 'clause/2 reports private access before body callability',
      run: () => {
        const program = Program.parse('elk(bertha).\n');
        const solver = new Solver(program, {});
        let caught = null;
        try {
          [...solver.solve([parseGoalText('clause(elk(_), 4)')], new Env(), 0)];
        } catch (error) {
          caught = error;
        }
        assertEqual(caught?.formal, 'permission_error(access, private_procedure)', 'formal error');
      },
    },
    {
      name: 'strict ISO core mode disables normal-profile recursion planning',
      run: () => {
        const strict = Program.parse('p :- p.\n', { isoStrict: true });
        const normal = Program.parse('p :- p.\n');
        const strictGroup = strict.findGroup('p', 0);
        const normalGroup = normal.findGroup('p', 0);
        assertEqual(strictGroup?.recursive, false, 'strict recursive planner disabled');
        assertEqual(strictGroup?.tabled, false, 'strict tabling disabled');
        assertEqual(normalGroup?.recursive, true, 'normal recursion detected');
      },
    },
    {
      name: '--iso-strict rejects quad execution mode',
      run: () => {
        const result = runCli(['--iso-strict', '--quads', '-'], { input: '' });
        assertEqual(result.status, 1, 'exit status');
        assertIncludes(result.stderr, '--iso-strict cannot be combined with --quads', 'stderr');
      },
    },
    {
      name: '--iso-strict rejects extension directives from source input',
      run: () => {
        const result = runCli(['--iso-strict', '-'], { input: ':- use_module(library(lists)).\n' });
        assertEqual(result.status, 1, 'exit status');
        assertIncludes(result.stderr, 'implementation-specific directive use_module/1', 'stderr');
      },
    },
    {
      name: 'term input accepts ISO numeric escapes through read predicates',
      run: () => {
        const escapePath = path.join(tmp, `read-escapes-${++tmpCounter}.term`);
        // Two raw read-terms: '\7\'. and '\x7\'.  Build the file from
        // character codes so this regression tests stream parsing rather than
        // the parser which reads this JavaScript fixture.
        fs.writeFileSync(escapePath, String.fromCharCode(
          39, 92, 55, 92, 39, 46, 10,
          39, 92, 120, 55, 92, 39, 46, 10,
        ));
        const source = [
          `read_escapes(A, B) :-`,
          `  current_input(Old),`,
          `  open(${sourceAtom(escapePath)}, read, Input, []),`,
          `  set_input(Input),`,
          `  read(A),`,
          `  read_term(B, []),`,
          `  set_input(Old),`,
          `  close(Input).`,
          '',
        ].join('\n');
        assertEqual(
          run(source, { goal: 'read_escapes(A, B)' }).stdout,
          "read_escapes('\\a', '\\a').\n",
          'read/1 and read_term/2 numeric escapes',
        );

        assertEqual(
          run('answer(T) :- read(T).\n', {
            goal: 'answer(T)',
            ioOptions: { input: "'\\7\\'." },
          }).stdout,
          "answer('\\a').\n",
          'read/1 user_input numeric escape',
        );

        const invalidOctal = String.fromCharCode(39, 92, 56, 92, 39, 46);
        assertEqual(
          run('answer(T) :- catch(read(T), E, T=E).\n', {
            goal: 'answer(T)',
            ioOptions: { input: invalidOctal },
          }).stdout,
          'answer(error(syntax_error(read_term), eyeprolog)).\n',
          'read/1 rejects non-octal numeric escape',
        );
      },
    },
    {
      name: 'term input keeps dotted operators intact and uses program operators',
      run: () => {
        const univPath = path.join(tmp, `read-univ-${++tmpCounter}.term`);
        const customPath = path.join(tmp, `read-custom-${++tmpCounter}.term`);
        const invalidPath = path.join(tmp, `read-invalid-${++tmpCounter}.term`);
        const quotesPath = path.join(tmp, `read-quotes-${++tmpCounter}.term`);
        fs.writeFileSync(univPath, 'foo =.. [bar]/* term end */.\n');
        fs.writeFileSync(customPath, 'alice likes bob.\n');
        fs.writeFileSync(invalidPath, 'a..b.\n');
        fs.writeFileSync(quotesPath, '"ab".\n');
        const source = [
          `read_univ(T) :- open(${sourceAtom(univPath)}, read, S, []), read(S, T), close(S).`,
          `read_custom(T) :- op(500, xfx, likes), open(${sourceAtom(customPath)}, read, S, []), read(S, T), close(S).`,
          `read_invalid(ok) :- open(${sourceAtom(invalidPath)}, read, S, []), catch(read(S, _), error(syntax_error(read_term), _), true), close(S).`,
          `read_codes(ok) :- set_prolog_flag(double_quotes, codes), open(${sourceAtom(quotesPath)}, read, S, []), read(S, [97, 98]), close(S).`,
          '',
        ].join('\n');
        assertEqual(run(source, { goal: 'read_univ(T)' }).stdout, 'read_univ(foo =.. [bar]).\n', 'univ term');
        assertEqual(run(source, { goal: 'read_custom(T)' }).stdout, 'read_custom(alice likes bob).\n', 'custom operator term');
        assertEqual(run(source, { goal: 'read_invalid(ok)' }).stdout, 'read_invalid(ok).\n', 'invalid dotted term');
        assertEqual(run(source, { goal: 'read_codes(ok)' }).stdout, 'read_codes(ok).\n', 'double_quotes read flag');
      },
    },
    {
      name: 'get_char and peek_char report invalid UTF-8 as representation_error(character)',
      run: () => {
        const invalidPath = path.join(tmp, `invalid-utf8-${++tmpCounter}.bin`);
        fs.writeFileSync(invalidPath, Buffer.from([0xff]));
        const quotedPath = sourceAtom(invalidPath);
        for (const predicate of ['peek_char', 'get_char']) {
          let caught = null;
          try {
            run('', { goal: `open(${quotedPath}, read, S, []), ${predicate}(S, C)` });
          } catch (error) {
            caught = error;
          }
          assertEqual(caught?.formal, 'representation_error(character)', `${predicate}/2 invalid UTF-8`);
        }
      },
    },
    {
      name: 'read and read_term report invalid UTF-8 as representation_error(character) (issue #64, STC #76)',
      run: () => {
        const invalidPath = path.join(tmp, `read-invalid-utf8-${++tmpCounter}.bin`);
        fs.writeFileSync(invalidPath, Buffer.from([0xff]));
        const quotedPath = sourceAtom(invalidPath);
        for (const goal of [
          `open(${quotedPath}, read, S, []), read(S, C)`,
          `open(${quotedPath}, read, S, []), read_term(S, C, [])`,
          `open(${quotedPath}, read, S, []), set_input(S), read(C)`,
          `open(${quotedPath}, read, S, []), set_input(S), read_term(C, [])`,
        ]) {
          let caught = null;
          try {
            run('', { goal });
          } catch (error) {
            caught = error;
          }
          assertEqual(caught?.formal, 'representation_error(character)', `${goal} invalid UTF-8`);
        }
      },
    },
    {
      name: 'writeq gives unnamed variables underscore-prefixed names (issue #53)',
      run: () => {
        const result = runCli([], {
          input: "writeq(E).\nwriteq(pair(X,X,Y)).\nwrite_term(pair(X,Y), [variable_names(['Left'=X])]).\nhalt.\n",
        });
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stdout, '  _A true.\n', 'single unnamed variable');
        assertIncludes(result.stdout, '  pair(_A,_A,_B) true.\n', 'stable repeated variable names');
        assertIncludes(result.stdout, '  pair(Left,_A) true.\n', 'explicit variable name plus generated fallback');
        const fresh = run('emit :- writeq(E), nl.\n', { goal: 'emit' });
        assertEqual(fresh.stdout, '_A\nemit.\n', 'fresh clause variable hides its internal suffix');
      },
    },
    {
      name: 'write predicates keep generated variable names stable across calls (issue #53 comment 5356861151)',
      run: () => {
        const result = run([
          "emit :- write_term(pair(A,B), []), write(' / '), write_term(user_output,B,[]), write(' / '), writeq(A), write(' / '), write_canonical(B), nl.",
          "again :- write_canonical(B+B), nl.",
        ].join('\n'), { goals: ['emit', 'again'] });
        assertEqual(
          result.stdout,
          'pair(_A,_B) / _B / _A / _B\nemit.\n+(_A,_A)\nagain.\n',
          'stable names across calls and reset at the next top-level query',
        );
      },
    },
    {
      name: 'writeq separates operators only where lexical ambiguity requires it (issue #63)',
      run: () => {
        const source = "emit :- writeq(1+2), put_char('|'), writeq(a+ -b), put_char('|'), writeq(a+b*c), nl.\n";
        assertEqual(run(source, { goal: 'emit' }).stdout, '1+2|a+ -b|a+b*c\nemit.\n', 'minimal operator spacing');
      },
    },
    {
      name: 'REPL answers use only lexically required operator spacing (issue #76)',
      run: () => {
        const source = [
          'emit :-',
          '  write_term(1+1, [spacing(false)]), put_char(\'|\'),',
          '  write_term(1+1, [spacing(true)]).',
          '',
        ].join('\n');
        assertEqual(run(source, { goal: 'emit' }).stdout, '1+1|1 + 1emit.\n',
          'documented spacing values select write_term layout');

        const result = runCli([], {
          input: 'X=1*1.\nX=a + -b.\nhalt.\n',
        });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout,
          '?-    X = 1*1.\n' +
          '?-    X = a+ -b.\n' +
          '?- ',
          'minimal operator layout preserves required token separation');
        assertEqual(result.stderr, '', 'stderr');

        let variableError = null;
        try {
          run('', { goal: 'write_term(1+1,[spacing(X)])' });
        } catch (error) {
          variableError = error;
        }
        assertEqual(variableError?.formal, 'instantiation_error', 'variable spacing value');

        for (const value of ['minimal', 'standard', '1', '0']) {
          let domainError = null;
          try {
            run('', { goal: `write_term(1+1,[spacing(${value})])` });
          } catch (error) {
            domainError = error;
          }
          assertEqual(domainError?.formal, 'domain_error(write_option)', `spacing(${value}) domain`);
        }
      },
    },
    {
      name: 'write predicates and write_term options select distinct formats',
      run: () => {
        const source = [
          'emit :-',
          "  write('hello world'), put_char('|'),",
          "  writeq('hello world'), put_char('|'),",
          "  write(a+b*c), put_char('|'),",
          "  write_canonical(a+b*c), put_char('|'),",
          "  write_term('hello world', [quoted(false)]), put_char('|'),",
          "  write_term('hello world', [quoted(true)]), put_char('|'),",
          "  write_term(a+b, [ignore_ops(true)]), put_char('|'),",
          "  write_term(a+b, [ignore_ops(false)]), put_char('|'),",
          "  write_term('$VAR'(0), [numbervars(true)]), put_char('|'),",
          "  write_term('$VAR'(0), [numbervars(false)]), put_char('|'),",
          "  write_term(pair(X, Y), [variable_names(['Left'=X, 'Right'=Y])]), put_char('|'),",
          `  write_term("ab", [double_quotes(true)]), put_char('|'),`,
          '  write_term("ab", [double_quotes(false)]).',
          '',
        ].join('\n');
        assertEqual(
          run(source, { goal: 'emit' }).stdout,
          "hello world|'hello world'|a+b*c|+(a,*(b,c))|hello world|'hello world'|+(a,b)|a+b|A|$VAR(0)|pair(Left,Right)|\"ab\"|[a,b]emit.\n",
          'stdout',
        );
      },
    },
    {
      name: 'REPL renders character lists with double quotes',
      run: () => {
        const result = runCli([], { input: 'L="UN-READABLE, ...".\nhalt.\n' });
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stdout, 'L = "UN-READABLE, ...".', 'top-level character-list rendering');
      },
    },
    {
      name: 'CLI false/0 fails as an ordinary goal',
      run: () => {
        const input = '%% goal: answer(X)\nanswer(ok) :- false.\n';
        const result = runCli(['-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, '', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'CLI rejects clauses headed by false/0',
      run: () => {
        const input = 'false :- true.\n';
        const result = runCli(['-'], { input });
        assertEqual(result.status, 1, 'exit status');
        assertEqual(result.stdout, '', 'stdout');
        assertIncludes(result.stderr, 'error(permission_error(modify, static_procedure), /(false, 0))', 'stderr');
      },
    },
  ];
}



function documentationSyncCases() {
  return [
    {
      name: 'generated bundled-library autoload index matches src/lib module exports',
      run: () => {
        const result = spawnSync(process.execPath, [path.join(packageRoot, 'tools', 'generate-library-autoload-index.mjs'), '--check'], {
          cwd: packageRoot,
          encoding: 'utf8',
        });
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stdout, 'library-autoload-index.js is up to date', 'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'generated complete predicate reference matches core and library surfaces',
      run: () => {
        const result = spawnSync(process.execPath, [path.join(packageRoot, 'tools', 'generate-predicate-reference.mjs'), '--check'], {
          cwd: packageRoot,
          encoding: 'utf8',
        });
        assertEqual(result.status, 0, 'exit status');
        assertIncludes(result.stdout, 'predicate reference is up to date (532 predicates)', 'stdout');
        assertEqual(result.stderr, '', 'stderr');

        const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyeprolog.md'), 'utf8');
        const section = between(book, '<!-- eyeprolog-predicate-reference:start -->', '<!-- eyeprolog-predicate-reference:end -->');
        assertEqual(section.split('\n').some((line) => line.trimStart().startsWith('|')), false, 'predicate reference avoids wide table markup');
        assertEqual((section.match(/^- \*\*`/gm) ?? []).length, 532, 'one reference entry per predicate');
        assertEqual((section.match(/<a id="predicate-reference-\d{4}"><\/a>/g) ?? []).length, 532, 'one explicit anchor per predicate');
        assertEqual((section.match(/\]\(#predicate-reference-\d{4}\)/g) ?? []).length, 532, 'one direct index link per predicate');
        assertNotIncludes(section, '[Symbols](#predicate-reference-symbols)', 'predicate index does not rely on renderer-generated group anchors');

        const chapter = between(book, '## 39. Predicate reference', '## 40. Running EyeProlog: command line and corpus');
        assertEqual(chapter.split('\n').some((line) => line.trimStart().startsWith('|')), false, 'Chapter 39 avoids wide table markup');
        for (const backstage of [
          'stacked layout',
          'Markdown tables',
          'horizontal scrollbars',
          'horizontal scrolling',
          'documentation test',
          'documentation regression',
          'stable numeric IDs',
          'generated reference',
          'Read the chapter in that order',
          'final generated section',
        ]) assertNotIncludes(chapter, backstage, `Chapter 39 avoids editorial/process prose: ${backstage}`);
        const orderedHeadings = [
          '### Notation and conventions',
          '### Core registry',
          '### Normal-mode extensions',
          '### Bundled libraries',
          '### Library relations by programming role',
          '### Interoperability, autoloading, and portability',
          '### Specialized library implementation notes',
          '### Complete predicate indicator reference',
        ];
        let previous = -1;
        for (const heading of orderedHeadings) {
          const position = chapter.indexOf(heading);
          assertEqual(position > previous, true, `Chapter 39 section order: ${heading}`);
          previous = position;
        }
      },
    },
    {
      name: 'book keeps editorial and build mechanics out of reader-facing prose',
      run: () => {
        const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyeprolog.md'), 'utf8');
        for (const backstage of [
          'stacked layout',
          'Markdown tables',
          'horizontal scrollbars',
          'horizontal scrolling',
          'documentation test',
          'documentation regression',
          'stable numeric IDs',
          'generated reference',
          'final generated section',
          'Read the chapter in that order',
          'after editing the book',
          'should be rebuilt with `npm run generate`',
          'Keeping these details here',
          '# Part XII — Development note',
          '## 46. AI-assisted editing',
          'release gate',
          'release-facing',
          '# Refresh the vendored TU Wien WG17 inventory',
          'the tables in this chapter',
          'The generated [`examples/book/`',
        ]) assertNotIncludes(book, backstage, `book avoids backstage prose: ${backstage}`);
        assertIncludes(book, 'Chapters are numbered continuously across eleven parts, from Chapter 1 to Chapter 45.', 'reader-facing chapter count');
      },
    },
    {
      name: 'reference docs match explicit tabling and current runtime extensions',
      run: () => {
        const readme = fs.readFileSync(path.join(packageRoot, 'README.md'), 'utf8');
        const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyeprolog.md'), 'utf8');
        const profile = fs.readFileSync(path.join(packageRoot, 'why-eyeprolog.md'), 'utf8');
        const combined = `${readme}
${book}
${profile}`;
        for (const stale of [
          'Automatic tabling',
          'Automatic hybrid reasoning',
          'eligible positive recursive groups are tabled automatically',
          '--no-auto-table',
          'conservative interop autoloading',
        ]) assertNotIncludes(combined, stale, `stale documentation phrase ${stale}`);
        assertIncludes(book, 'including recursive calls, use depth-first resolution unless the source', 'ordinary recursion is depth-first');
        assertIncludes(book, 'explicitly declares `:- table p/n.`', 'tabling is explicit');
        assertIncludes(book, 'The autoload index covers every', 'generic bundled-library autoload');
        assertIncludes(book, 'interactive top-level query autoloads its canonical bundled provider', 'REPL autoload');
        assertIncludes(book, 'Autoloading therefore supplies', 'autoload syntax boundary');
        assertIncludes(book, 'Residual constraints are part of the displayed answer even when', 'top-level hidden residuals');
        assertIncludes(book, 'EyeProlog normal mode also accepts `:+`', 'Eyelet forward-rule extension');
        assertIncludes(book, '`library(eyelet)`', 'Eyelet library surface');
        assertNotIncludes(readme, '## Eyelet forward rules', 'README delegates Eyelet details to the book');
        assertNotIncludes(readme, '## HTTP and JSON', 'README delegates HTTP/JSON details to the book');
        assertIncludes(profile, 'an unresolved unqualified predicate may autoload its unique provider', 'Why EyeProlog autoload policy');
      },
    },
    {
      name: 'WG17 syntax status matches its executable-coverage manifest',
      run: () => {
        const filename = path.join(testRoot, 'conformance', 'WG17-SYNTAX-STATUS.md');
        assertEqual(fs.readFileSync(filename, 'utf8'), renderWg17SyntaxStatus(), 'WG17 syntax status');
      },
    },
    {
      name: 'WG17 upgrader accepts omitted HTML table end tags',
      run: () => {
        // HTML permits </td> and </tr> to be omitted. TU Wien uses this
        // compact form, so the upgrader must not depend on explicit closes.
        const rows = Array.from({ length: 120 }, (_, index) =>
          `<tr><td>${index + 1}<td><code>write(${index + 1}).</code><td>ok`).join('\n');
        const html = `<table><tr><th>#<th>Query<th>Codex${rows}</table>`;
        const parsed = parseWg17SyntaxTable(html);
        assertEqual(parsed.length, 120, 'parsed row count');
        assertEqual(parsed[0].id, 1, 'first id');
        assertEqual(parsed[0].query, 'write(1).', 'first query');
        assertEqual(parsed.at(-1).id, 120, 'last id');
      },
    },
    {
      name: 'WG17 upgrader normalizes presentation non-breaking spaces',
      run: () => {
        const rows = Array.from({ length: 120 }, (_, index) =>
          `<tr><td>${index + 1}<td>set_prolog_flag(&nbsp;double_quotes,chars).<td>succeeds`).join('\n');
        const html = `<table><tr><th>#<th>Query<th>Codex${rows}</table>`;
        const parsed = parseWg17SyntaxTable(html);
        assertEqual(parsed[0].query, 'set_prolog_flag( double_quotes,chars).', 'normalized query');
      },
    },
    {
      name: 'WG17 upgrader removes presentation footnote markers from Codex text',
      run: () => {
        const rows = Array.from({ length: 120 }, (_, index) =>
          `<tr><td>${index + 1}<td>writeq(-(1^2)).<td>- (1^2)&sup3;`).join('\n');
        const html = `<table><tr><th>#<th>Query<th>Codex${rows}</table>`;
        const parsed = parseWg17SyntaxTable(html);
        assertEqual(parsed[0].expected, '- (1^2)', 'normalized Codex expectation');
      },
    },
    {
      name: 'WG17 upstream expectations independently validate reviewed outcomes',
      run: () => {
        assertEqual(matchesUpstreamExpectation('succeeds', { type: 'success', stages: [] }), true, 'succeeds');
        assertEqual(matchesUpstreamExpectation('fails', { type: 'failure' }), true, 'fails');
        assertEqual(matchesUpstreamExpectation('waits', { type: 'waits' }), true, 'waits');
        assertEqual(
          matchesUpstreamExpectation('syntax err.', { type: 'error', formal: 'syntax_error(read_term)' }),
          true,
          'syntax error',
        );
        assertEqual(
          matchesUpstreamExpectation("'a b'", { type: 'success', stages: [{ output: "'a b'", variables: '[]' }] }),
          true,
          'observable output',
        );
        const negativePower = { id: 183, input: 'writeq(-(1^2)).' };
        assertEqual(
          matchesUpstreamExpectation('- (1^2)', { type: 'success', stages: [{ output: '-(1^2)', variables: '[]' }] }, negativePower),
          false,
          'mandatory operator/parenthesis layout is not erased',
        );
        assertEqual(
          matchesUpstreamExpectation('- (a^2)', { type: 'success', stages: [{ output: '-a^2', variables: '[]' }] }, negativePower),
          false,
          'mandatory negative-power parentheses are not erased',
        );
        assertEqual(
          matchesUpstreamExpectation('- (1^2)', { type: 'success', stages: [{ output: '- (1 ^ 2)', variables: '[]' }] }, negativePower),
          true,
          'non-semantic internal operator spacing remains flexible',
        );
        const barWriter = {
          id: 181,
          query: "writeq((a-->b,c|d)).",
          input: "op(1105,xfy,'|').\nwriteq((a-->b,c|d)).",
        };
        assertEqual(
          matchesUpstreamExpectation(
            'a-->b,c|d',
            { type: 'success', stages: [{ output: "a-->b,c'|'d", variables: '[]' }] },
            barWriter,
          ),
          false,
          'quoted bar is not accepted in operator-form writer output',
        );
        const semicolonWriter = {
          id: 331,
          query: 'write_canonical(;(a,b)).',
          input: 'write_canonical(;(a,b)).',
        };
        assertEqual(
          matchesUpstreamExpectation(
            ';(a,b)',
            { type: 'success', stages: [{ output: "';'(a,b)", variables: '[]' }] },
            semicolonWriter,
          ),
          false,
          'quoted semicolon is not accepted when the ISO name token is bare',
        );
        const quotedPostfixWriter = {
          id: 208,
          query: "op(100,xf,'f ').\nwriteq(0 'f ').",
          input: "op(100,xf,'f ').\nwriteq(0 'f ').",
        };
        assertEqual(
          matchesUpstreamExpectation(
            "0 'f '",
            { type: 'success', stages: [{ output: "0'f '", variables: '[]' }] },
            quotedPostfixWriter,
          ),
          false,
          'mandatory layout before quoted postfix operator is not erased',
        );
        const dottedPostfixWriter = {
          id: 169,
          query: 'writeq(.(.)).',
          input: "op(0,xfy,.),op(9,yf,.).\nwriteq(.(.)).",
        };
        assertEqual(
          matchesUpstreamExpectation(
            "('.')'.'",
            { type: 'success', stages: [{ output: "'.' '.'", variables: '[]' }] },
            dottedPostfixWriter,
          ),
          false,
          'mandatory writer parentheses are not replaced by layout',
        );
        const wordPostfixWriter = { id: 150, query: 'writeq(yf(fy(1))).', input: 'writeq(yf(fy(1))).' };
        assertEqual(
          matchesUpstreamExpectation(
            '(fy 1)yf',
            { type: 'success', stages: [{ output: '(fy 1) yf', variables: '[]' }] },
            wordPostfixWriter,
          ),
          false,
          'concrete writer layout is matched exactly',
        );
        const canonicalWriter = { id: 163, query: 'write_canonical(1 p p p 2).', input: 'write_canonical(1 p p p 2).' };
        assertEqual(
          matchesUpstreamExpectation(
            'p(1,p(p(2)))',
            { type: 'success', stages: [{ output: 'p(1, p(p(2)))', variables: '[]' }] },
            canonicalWriter,
          ),
          false,
          'concrete canonical writer layout is matched exactly',
        );
        const repeated = {
          id: 227, input: 'write_canonical(B+B).',
          outcome: { type: 'success', stages: [{ output: '+(_A,_A)', variables: "['B' = B]" }] },
        };
        assertEqual(
          matchesUpstreamExpectation('e.g. +(_1,_1)', repeated.outcome, repeated),
          true,
          'anonymous spelling accepted',
        );
        assertEqual(
          matchesUpstreamExpectation(
            'e.g. +(_1,_1)',
            { type: 'success', stages: [{ output: '+(B,B)', variables: "['B' = B]" }] },
            repeated,
          ),
          false,
          'named-variable spelling rejected',
        );
      },
    },
    {
      name: 'normal syntax extensions preserve successful WG17 Part 1 outcomes',
      run: () => {
        const fixture = readWg17SyntaxFixture();
        let checked = 0;
        for (const item of fixture.cases) {
          const strict = executeWg17Item(item);
          if (strict.type !== 'success') continue;
          const normal = executeWg17Item(item, { isoStrict: false });
          assertEqual(JSON.stringify(normal), JSON.stringify(strict), `WG17 #${item.id} cross-profile outcome`);
          checked++;
        }
        if (checked === 0) throw new Error('WG17 fixture has no successful Part 1 syntax cases');
      },
    },
    {
      name: 'WG17 stream-sensitive cases #270 and #271 follow the upstream input protocol',
      run: () => {
        const fixture = readWg17SyntaxFixture();
        const byId = new Map(fixture.cases.map((item) => [item.id, item]));
        for (const [id, expected] of [[270, "C = ' '"], [271, "C = '%'"]]) {
          const item = byId.get(id);
          if (item == null) throw new Error(`missing WG17 #${id}`);
          assertEqual(item.expected, expected, `WG17 #${id} upstream expectation`);
          const actual = executeWg17Item(item);
          assertEqual(matchesUpstreamExpectation(item.expected, actual, item), true, `WG17 #${id} result`);
          assertEqual(JSON.stringify(actual), JSON.stringify(item.outcome), `WG17 #${id} reviewed outcome`);
        }
      },
    },
    {
      name: 'book builtins match runtime registry',
      run: () => assertArrayEqual(bookBuiltinNames(), registeredBuiltinNames(), 'builtins'),
    },
    {
      name: 'book builtin catalog matches runtime registry',
      run: () => {
        assertArrayEqual(bookBuiltinNames(), registeredBuiltinNames(), 'builtins');
        const summary = bookBuiltinSummary();
        const actual = registeredBuiltinSummary();
        assertEqual(summary.entries, actual.entries, 'builtin entry count');
        assertEqual(summary.names, actual.names, 'builtin predicate name count');
      },
    },
    {
      name: 'book EyeProlog library matches runtime registry',
      run: () => {
        assertArrayEqual(bookEyePrologLibraryNames(), registeredEyePrologLibraryNames(), 'EyeProlog library predicates');
        assertArrayEqual(bookLibraryModuleIssues(), [], 'library module export catalog');
        const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyeprolog.md'), 'utf8');
        assertIncludes(book, `**${eyePrologLibraryIndicators.length} distinct non-ISO library and normal-extension predicate`, 'library predicate count');
        assertIncludes(book, `**${eyePrologPortableLibraryIndicators.length} are defined entirely as ordinary Prolog clauses**`, 'portable library count');
        assertIncludes(book, `**${eyePrologNativeLibraryIndicators.length} use host support**`, 'host-supported library count');
        assertIncludes(book, `**${createDefaultRegistry().defs.size + eyePrologLibraryIndicators.length} distinct predicate indicators**`, 'combined catalog count');
      },
    },
    {
      name: 'README cover links to the book and the book documents runtime boundaries',
      run: () => {
        const readme = fs.readFileSync(path.join(packageRoot, 'README.md'), 'utf8');
        const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyeprolog.md'), 'utf8');
        assertIncludes(
          readme,
          '<a href="https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog">\n    <img src="book-assets/title-page.svg" alt="Read The Art of EyeProlog"',
          'README cover links to the book',
        );
        const documentedSources = ['src/iso.js', 'src/dcg.js', 'src/atts-host.js', 'src/standard-library.js',
          ...[...standardLibrarySources.values()].map((entry) => entry.filename),
          'src/playground-worker.js'];
        for (const filename of documentedSources) {
          assertEqual(fs.existsSync(path.join(packageRoot, filename)), true, `${filename} exists`);
          assertIncludes(book, filename, `book documents ${filename}`);
        }
        assertEqual(fs.existsSync(path.join(packageRoot, 'src', 'portable-library.js')), false, 'obsolete duplicate library module is absent');
        assertEqual('portableLibrarySource' in publicApi, false, 'obsolete portable source API is absent');
        assertEqual(readme.includes('portable-library.js') || readme.includes('portableLibrarySource'), false, 'README has no obsolete portable layer');
        assertEqual(book.includes('portable-library.js') || book.includes('portableLibrarySource'), false, 'book has no obsolete portable layer');
        assertEqual(fs.existsSync(path.join(packageRoot, 'src', 'builtins')), false, 'obsolete builtins directory is absent');
      },
    },
    {
      name: 'book example catalog names resolve in examples directory',
      run: () => assertArrayEqual(bookExampleCatalogIssues(), [], 'guide example catalog'),
    },
    {
      name: 'documented runnable example count and goldens match corpus',
      run: () => assertArrayEqual(exampleCorpusSyncIssues(), [], 'example corpus sync'),
    },
    {
      name: 'documented proof example count and runner match proof goldens',
      run: () => assertArrayEqual(proofCorpusSyncIssues(), [], 'proof corpus sync'),
    },
    {
      name: 'playground example catalog and relative loaders match examples directory',
      run: () => assertArrayEqual(playgroundExampleIssues(), [], 'playground examples'),
    },
    {
      name: 'playground static page is browser-ready and packaged',
      run: () => assertArrayEqual(playgroundStaticIssues(), [], 'playground static page'),
    },
    {
      name: 'documentation local links and anchors resolve',
      run: () => assertArrayEqual(findBrokenDocLinks(), [], 'broken documentation links'),
    },
    {
      name: 'book example extraction matches the Markdown source',
      run: () => {
        const result = spawnSync(process.execPath, ['tools/extract-book-examples.mjs', '--check'], {
          cwd: packageRoot,
          encoding: 'utf8',
        });
        assertEqual(result.status, 0, `exit status${result.stderr ? `\nstderr: ${result.stderr}` : ''}`);
        assertIncludes(result.stdout, 'extracted book examples are up to date.', 'stdout');
      },
    },
    {
      name: 'book introductory output matches the checked Socrates example',
      run: () => assertArrayEqual(bookIntroOutputIssues(), [], 'book introductory output'),
    },
    {
      name: 'documentation imports only public JavaScript API names',
      run: () => assertArrayEqual(documentedPublicApiImportIssues(), [], 'documentation API imports'),
    },
    {
      name: 'documentation uses EyeProlog source style',
      run: () => assertArrayEqual(documentationSourceStyleIssues(), [], 'documentation source style'),
    },
    {
      name: 'DCG nonterminal indicator prose uses valid ... //0 spacing',
      run: () => {
        for (const filename of ['README.md', 'the-art-of-eyeprolog.md', 'src/standard-library.js', 'src/solver.js']) {
          const text = fs.readFileSync(path.join(packageRoot, filename), 'utf8');
          assertNotIncludes(text, '...' + '//0', `${filename} invalid compact nonterminal indicator`);
        }
      },
    },
    {
      name: 'ISO 5.4 decision index inventories implementation-defined choices',
      run: () => {
        const filename = path.join(testRoot, 'conformance', 'ISO-IMPLEMENTATION-DEFINED.md');
        const text = fs.readFileSync(filename, 'utf8');
        for (const clause of [
          '5.5.11', '6.5', '6.6', '7.1.2.2', '7.1.4.1', '7.4.2.4', '7.4.2.5',
          '7.4.2.6', '7.4.2.7', '7.4.2.8', '7.4.2.9', '7.5.1', '7.7.1', '7.7.3',
          '7.10.1', '7.10.2.6', '7.10.2.7', '7.10.2.8', '7.10.2.9', '7.10.2.11',
          '7.10.2.13', '7.11.1.1', '7.11.1.2', '7.11.1.3', '7.11.1.4', '7.11.2.1',
          '7.11.2.2', '7.11.2.3', '7.11.2.5', '7.12.1', '7.12.2(f)', '8.17.1',
          '8.17.3', '8.17.4', '9.1.3.1', '9.1.4.1', '9.1.4.2', '9.1.4.3', '9.4',
          '9.4.1', '9.4.2', '9.4.3', '9.4.4', '9.4.5', 'Cor.2 9.4.6',
        ]) assertIncludes(text, `| ${clause} |`, `ISO 5.4 clause ${clause}`);
        assertIncludes(text, 'Floating underflow policy', 'floating underflow policy explanation');
        assertIncludes(text, 'Implementation-specific features required to be documented by 5.4', '5.5 extension inventory');
      },
    },
    {
      name: 'ISO term and arithmetic row matrices are closed and linked',
      run: () => {
        const compliance = fs.readFileSync(path.join(testRoot, 'conformance', 'ISO-COMPLIANCE.md'), 'utf8');
        const terms = fs.readFileSync(path.join(testRoot, 'conformance', 'ISO-TERM-SEMANTICS-MATRIX.md'), 'utf8');
        const arithmetic = fs.readFileSync(path.join(testRoot, 'conformance', 'ISO-EVALUABLE-FUNCTOR-MATRIX.md'), 'utf8');
        assertIncludes(compliance, '| 7.1-7.3 — term types, term order, unification | covered |', '7.1-7.3 covered');
        assertIncludes(compliance, '| 7.9 — expression evaluation | covered |', '7.9 covered');
        assertIncludes(compliance, '| Clause 9 — evaluable functors | covered |', 'Clause 9 covered');
        assertIncludes(terms, '## 7.3 - unification', 'term unification row matrix');
        assertIncludes(arithmetic, '## 9.4 - bitwise functors', 'Clause 9.4 row matrix');
        assertIncludes(arithmetic, '`float_integer_part/1`, `float_fractional_part/1`', 'float-only conversion row');
      },
    },
    {
      name: 'published ISO Corrigenda have a complete stable review inventory',
      run: () => {
        const compliance = fs.readFileSync(path.join(testRoot, 'conformance', 'ISO-COMPLIANCE.md'), 'utf8');
        const matrix = fs.readFileSync(path.join(testRoot, 'conformance', 'ISO-CORRIGENDA-MATRIX.md'), 'utf8');
        const expected = [
          ...Array.from({ length: 18 }, (_, index) => `C1-${String(index + 1).padStart(2, '0')}`),
          ...Array.from({ length: 23 }, (_, index) => `C2-${String(index + 1).padStart(2, '0')}`),
          ...Array.from({ length: 19 }, (_, index) => `C3-${String(index + 1).padStart(2, '0')}`),
        ];
        const rows = matrix.split('\n')
          .filter((line) => /^\| C[123]-\d\d \|/.test(line))
          .map((line) => line.split('|').slice(1, -1).map((cell) => cell.trim()));
        assertEqual(rows.map(([id]) => id).join(','), expected.join(','), 'Corrigenda stable review IDs');
        for (const [id, clauses, disposition, evidence] of rows) {
          assertEqual(Boolean(clauses), true, `${id} clause/amendment cluster`);
          assertEqual(['covered', 'editorial', 'superseded'].includes(disposition), true, `${id} disposition`);
          assertEqual(Boolean(evidence), true, `${id} evidence`);
          if (disposition === 'covered') {
            assertEqual(/test|WG17|strict|case/i.test(evidence), true, `${id} executable evidence`);
          }
        }
        assertIncludes(compliance, '[ISO-CORRIGENDA-MATRIX.md](ISO-CORRIGENDA-MATRIX.md)', 'Corrigenda matrix link');
        for (const corrigendum of ['Corrigendum 1', 'Corrigendum 2', 'Corrigendum 3']) {
          assertIncludes(compliance, `| ${corrigendum} | covered |`, `${corrigendum} covered row`);
        }
      },
    },
    {
      name: 'ISO 7.4-7.8 execution matrix is closed',
      run: () => {
        const compliance = fs.readFileSync(path.join(testRoot, 'conformance', 'ISO-COMPLIANCE.md'), 'utf8');
        const matrix = fs.readFileSync(path.join(testRoot, 'conformance', 'ISO-PROLOG-TEXT-EXECUTION-MATRIX.md'), 'utf8');
        for (const row of [
          '| 7.4 — Prolog text and directives | covered |',
          '| 7.5-7.6 — database and term/clause conversion | covered |',
          '| 7.7 — execution and backtracking | covered |',
          '| 7.8 — control constructs and exceptions | covered |',
        ]) assertIncludes(compliance, row, row);
        for (const section of ['## 7.4 - Prolog text and preparation', '## 7.5 - database model', '## 7.6 - conversion between terms and clauses/goals', '## 7.7 - execution and backtracking', '## 7.8 - control constructs and exceptions']) {
          assertIncludes(matrix, section, section);
        }
      },
    },
    {
      name: 'ISO Clause 6, 7.10, and 7.12 closure is documented',
      run: () => {
        const compliance = fs.readFileSync(path.join(testRoot, 'conformance', 'ISO-COMPLIANCE.md'), 'utf8');
        const processor = fs.readFileSync(path.join(testRoot, 'conformance', 'ISO-PROCESSOR-REQUIREMENTS.md'), 'utf8');
        for (const row of [
          '| Clause 6 — tokens, terms, lists, operators, quoted text | covered |',
          '| 7.10 — input/output concepts | covered |',
          '| 7.12 — errors | covered |',
        ]) assertIncludes(compliance, row, row);
        assertIncludes(processor, '## Clause 6 syntax-preservation closure', 'Clause 6 closure map');
        assertIncludes(processor, '| 5.5.1 syntax extensions preserve standard token/text meaning | covered |', '5.5.1 covered');

        const boundary = compliance.slice(
          compliance.indexOf('## Strict-core boundary'),
          compliance.indexOf('## Release gate'),
        );
        assertIncludes(boundary, '`wfs_truth/2`', 'strict boundary includes wfs_truth/2');
        assertIncludes(boundary, 'integer digit separators', 'strict boundary includes digit separators');
        assertIncludes(boundary, '`"text"||Tail`', 'strict boundary includes double-bar list splicing');
        assertEqual((boundary.match(/`tnot\/1`/g) ?? []).length, 1, 'strict boundary lists tnot/1 once');
        assertEqual(compliance.includes('`stringTerm/1` term type'), false, 'JavaScript stringTerm uses call notation');
      },
    },
    {
      name: 'ISO release-facing exit criteria are explicitly closed',
      run: () => {
        const exit = fs.readFileSync(path.join(testRoot, 'conformance', 'ISO-COMPLIANCE.md'), 'utf8');
        for (const item of [
          '| Clause 5 processor obligations have explicit dispositions | covered |',
          '| Clause 6 lexical/syntactic requirements have explicit dispositions | covered |',
          '| Clause 7 semantic requirements have explicit dispositions | covered |',
          '| Clause 8 built-in modes/errors have explicit dispositions | covered |',
          '| Clause 9 evaluable-functor requirements have explicit dispositions | covered |',
          '| Latest Neumerkel conformity is a live release gate | covered |',
          '| No unexplained deviation remains in the release-facing ledger | covered |',
        ]) assertIncludes(exit, item, item);
        assertNotIncludes(exit, '| gap |', 'no release-facing gap rows remain');
      },
    },
    {
      name: 'public ISO documentation keeps the book authoritative',
      run: () => {
        const readme = fs.readFileSync(path.join(packageRoot, 'README.md'), 'utf8');
        const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyeprolog.md'), 'utf8');
        const profile = fs.readFileSync(path.join(packageRoot, 'why-eyeprolog.md'), 'utf8');
        for (const name of [
          'ISO-TERM-SEMANTICS-MATRIX.md',
          'ISO-PROLOG-TEXT-EXECUTION-MATRIX.md',
          'ISO-EVALUABLE-FUNCTOR-MATRIX.md',
        ]) assertIncludes(book, name, `book ${name}`);
        assertIncludes(readme, 'implementation reference is [*The Art of EyeProlog*]', 'README book hand-off');
        assertIncludes(readme, 'test/conformance/ISO-COMPLIANCE.md', 'README concise review link');
        for (const heading of ['## Tabling', '## Cleanup-aware control', '## Strict ISO',
          '## Module and definite clause grammar', '## Trealla and Scryer interoperability']) {
          assertNotIncludes(readme, heading, `README delegates ${heading} to the book`);
        }
        assertEqual(readme.includes('2026-08-23 draft items #73-#76'), false, 'README omits review-history detail');
        assertIncludes(profile, 'Part 1 processor, syntax, semantic, built-in, and arithmetic', 'Why EyeProlog review state');
      },
    },
    {
      name: 'documentation avoids repository issue references',
      run: () => {
        for (const file of listMarkdownFiles(packageRoot)) {
          const text = fs.readFileSync(file, 'utf8');
          assertEqual(/github\.com\/eyereasoner\/eyeprolog\/issues\//.test(text), false, `${path.relative(packageRoot, file)} repository issue URL`);
          assertEqual(/\bissue\s+#\d+\b/i.test(text), false, `${path.relative(packageRoot, file)} repository issue number`);
        }
      },
    },
    {
      name: 'book is the single implementation reference',
      run: () => assertArrayEqual(bookReferenceDocumentationIssues(), [], 'book reference documentation'),
    },
    {
      name: 'documented npm scripts exist in package.json',
      run: () => assertArrayEqual(missingDocumentedPackageScripts(), [], 'missing documented npm scripts'),
    },
    {
      name: 'CI verifies the supported Node floor and gates npm publishing',
      run: () => {
        const testWorkflow = fs.readFileSync(path.join(packageRoot, '.github', 'workflows', 'test.yml'), 'utf8');
        assertIncludes(testWorkflow, "node-version: ['18', '24']", 'test workflow Node matrix');
        assertIncludes(testWorkflow, 'run: npm test', 'test workflow suite');
        assertIncludes(testWorkflow, 'run: npm pack --dry-run', 'test workflow package check');

        const publishWorkflow = fs.readFileSync(path.join(packageRoot, '.github', 'workflows', 'publish-npm.yml'), 'utf8');
        const testIndex = publishWorkflow.indexOf('run: npm test');
        const packIndex = publishWorkflow.indexOf('run: npm pack --dry-run');
        const publishIndex = publishWorkflow.indexOf('run: npm publish');
        assertEqual(testIndex >= 0 && testIndex < publishIndex, true, 'publish workflow test gate');
        assertEqual(packIndex >= 0 && packIndex < publishIndex, true, 'publish workflow package gate');
        assertEqual(pkg.scripts?.['test:openrulebench'], 'node test/run-openrulebench.mjs', 'OpenRuleBench test script');
      },
    },
    {
      name: 'documented conformance totals match the generated report',
      run: () => assertArrayEqual(documentedConformanceMetricIssues(), [], 'documented conformance totals'),
    },
    {
      name: 'conformance report summarizes public corpus',
      run: () => {
        const report = buildConformanceReport();
        assertArrayEqual(report.issues, [], 'conformance report issues');
        assertEqual(report.total.total >= 475, true, 'conformance case count');
        assertEqual(report.total.positive + report.total.errors + report.total.warnings + report.total.proofs, report.total.total, 'conformance total');
        assertEqual(report.rows.some((row) => row.category === 'legacy-numbered'), false, 'legacy-numbered category');
        const wg17 = report.executable.find((gate) => gate.name === 'WG17 syntax');
        const wg17FixtureTotal = readWg17SyntaxFixture().cases.length;
        assertEqual(wg17?.total, wg17FixtureTotal, 'WG17 executable total');
        assertEqual(wg17?.passed, wg17FixtureTotal, 'WG17 executable passed');
        assertArrayEqual(wg17?.failures ?? [], [], 'WG17 executable failures');
        const text = formatConformanceReport(report);
        assertIncludes(text, `| WG17 syntax | ${wg17FixtureTotal} | ${wg17FixtureTotal} | pass |`, 'report');
        assertIncludes(text, '| variables |', 'report');
        assertIncludes(text, '| Proofs |', 'report');
        assertIncludes(text, '| **Total** |', 'report');

        const failing = buildConformanceReport({
          wg17Suite: (reporter) => {
            reporter.section('WG17 syntax');
            reporter.test('synthetic syntax failure', () => { throw new Error('synthetic mismatch'); });
            reporter.sectionTotal('WG17 syntax');
          },
        });
        assertEqual(failing.executable[0].passed, 0, 'failing WG17 executable passed');
        assertEqual(failing.executable[0].total, 1, 'failing WG17 executable total');
        assertEqual(failing.executionIssues.length, 1, 'failing WG17 report issue count');
        assertIncludes(formatConformanceReport(failing), '| WG17 syntax | 0 | 1 | fail |', 'failing report');
      },
    },

    {
      name: 'committed conformance report is current',
      run: () => {
        const reportFile = path.join(packageRoot, 'conformance-report.md');
        assertEqual(fs.existsSync(reportFile), true, 'conformance-report.md exists');
        const actual = fs.readFileSync(reportFile, 'utf8');
        const expected = formatConformanceReport(buildConformanceReport());
        assertEqual(actual, expected, 'conformance-report.md');
      },
    },
    {
      name: 'source-checkout setup docs match package bin',
      run: () => {
        assertEqual(pkg.bin?.eyeprolog, './bin/eyeprolog.js', 'package eyeprolog bin');
        const binPath = path.join(packageRoot, pkg.bin.eyeprolog);
        const binText = fs.readFileSync(binPath, 'utf8');
        assertEqual(binText.startsWith('#!/usr/bin/env node\n'), true, 'bin shebang');
        assertArrayEqual(misleadingDependencyInstallDocs(), [], 'misleading dependency install docs');
      },
    },
    {
      name: 'installation docs avoid unsupported Node and global npm permission traps',
      run: () => {
        assertEqual(pkg.engines?.node, '>=18', 'supported Node range');
        for (const filename of ['README.md', 'the-art-of-eyeprolog.md']) {
          const text = fs.readFileSync(path.join(packageRoot, filename), 'utf8');
          assertIncludes(text, 'node --version', `${filename} checks Node version`);
          assertIncludes(text, 'npx --yes eyeprolog', `${filename} offers a non-global launch`);
          assertIncludes(text, 'npm install --global --prefix "$HOME/.local" eyeprolog', `${filename} uses a user prefix`);
          assertIncludes(text, 'https://nodejs.org/en/download', `${filename} links Node upgrades`);
          assertIncludes(text, 'https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally/', `${filename} links npm EACCES guidance`);
          assertEqual(text.includes('sudo npm install'), true, `${filename} explicitly warns against sudo npm`);
          assertEqual(/^\s*sudo npm install/m.test(text), false, `${filename} never recommends sudo npm`);
        }
      },
    },
  ];
}

function apiCases() {
  return [
    {
      name: 'public type declarations match runtime exports',
      run: () => assertArrayEqual(declaredValueExportNames(), runtimeExportNames(), 'public value exports'),
    },
    {
      name: 'default export type declarations match runtime exports',
      run: () => assertArrayEqual(declaredDefaultExportNames(), runtimeDefaultExportNames(), 'default export values'),
    },
    {
      name: 'run queries through public API without proof by default',
      run: () => {
        const result = run('%% goal: q(X, Y)\np(a, b).\nq(X, Y) :- p(X, Y).\n');
        assertEqual(result.stdout, 'q(a, b).\n', 'stdout');
      },
    },
    {
      name: 'ISO standard streams use API input and ordered output',
      run: () => {
        const writes = [];
        const result = run(
          'answer(T) :- read(T), write(read_back(T)), nl.\n',
          { goal: 'answer(T)', ioOptions: { input: 'sample(42).', write: (text) => writes.push(text) } },
        );
        assertEqual(result.stdout, 'read_back(sample(42))\nanswer(sample(42)).\n', 'stdout');
        assertEqual(writes.join(''), 'read_back(sample(42))\n', 'write callback');
      },
    },
    {
      name: 'ISO directives initialize state before queries',
      run: () => {
        const result = run([
          ':- dynamic(saved/1).',
          ':- initialization(assertz(saved(ready))).',
          ':- op(500, xfy, joins).',
          '%% goal: answer(X)',
          'answer(X) :- saved(ready), X = (a joins b joins c).',
        ].join('\n'));
        assertEqual(result.stdout, 'answer(a joins b joins c).\n', 'stdout');
      },
    },
    {
      name: 'empty dynamic predicates fail as defined procedures',
      run: () => {
        const result = run([
          ':- dynamic(cache/1).',
          '%% goal: answer(X)',
          'answer(X) :- cache(X), !.',
          'answer(computed) :- assertz(cache(computed)).',
        ].join('\n'));
        assertEqual(result.stdout, 'answer(computed).\n', 'stdout');
      },
    },
    {
      name: 'scalar fact acceleration preserves Prolog term types',
      run: () => {
        const result = run([
          '%% goal: number_fact(X)',
          '%% goal: atom_fact(X)',
          '%% goal: string_fact(X)',
          '%% goal: repeated(X)',
          'number_fact(X) :- scalar(7, X).',
          "atom_fact(X) :- scalar('7', X).",
          'string_fact(X) :- scalar("7", X).',
          'repeated(X) :- pair(X, X).',
          'scalar(7, number).',
          "scalar('7', atom).",
          'scalar("7", string).',
          "pair(7, '7').",
        ].join('\n'));
        assertEqual(result.stdout, [
          'number_fact(number).',
          'atom_fact(atom).',
          'string_fact(string).',
          '',
        ].join('\n'), 'stdout');
      },
    },
    {
      name: 'dynamic updates invalidate tabled answers',
      run: () => {
        const result = run([
          ':- dynamic(edge/2).',
          'path(X, Y) :- edge(X, Y).',
          'path(X, Y) :- edge(X, Z), path(Z, Y).',
          '%% goal: test(Before, After)',
          'test(Before, After) :-',
          '  assertz(edge(a, b)),',
          '  findall(X, path(a, X), Before),',
          '  assertz(edge(b, c)),',
          '  findall(Y, path(a, Y), After).',
        ].join('\n'));
        assertEqual(result.stdout, 'test("b", "bc").\n', 'stdout');
      },
    },
    {
      name: 'default EyeProlog registry keeps dynamic program state consistent',
      run: () => {
        const program = Program.parse([
          ':- dynamic(item/1).',
          '%% goal: done',
          'done :- assertz(item(a)), retract(item(a)), assertz(item(b)), abolish(item/1).',
        ].join('\n'));
        const result = run(program, { goal: 'done', registry: getEyePrologRegistry() });
        assertEqual(result.stdout, 'done.\n', 'stdout');
        assertEqual(program.findGroup('item', 1), null, 'abolished group');
        assertEqual(
          program.clauses.some((clause) => clause.head?.name === 'item'),
          false,
          'abolished clauses removed from original program',
        );
      },
    },
    {
      name: 'halt returns processor status through the API',
      run: () => {
        const result = run('stop :- write(stopping), halt(7).\n', { goal: 'stop' });
        assertEqual(result.stdout, 'stopping', 'stdout before halt');
        assertEqual(result.haltCode, 7, 'halt code');
      },
    },
    {
      name: 'query constants restrict answers',
      run: () => {
        const result = run('%% goal: answer(a, X)\nseed(a, one).\nseed(b, two).\nanswer(K, V) :- seed(K, V).\n');
        assertEqual(result.stdout, 'answer(a, one).\n', 'stdout');
      },
    },
    {
      name: 'programs without queries produce no answer output',
      run: () => {
        const result = run('seed(a, one).\nanswer(K, V) :- seed(K, V).\n');
        assertEqual(result.stdout, '', 'stdout');
      },
    },
    {
      name: 'run executes Prolog Eyelet forward rules when no explicit goal is supplied',
      run: () => {
        const result = run('seed(a).\nseen(X) :+ seed(X).\ntrue :+ seen(X).\n');
        assertEqual(result.stdout, 'seen(a).\n', 'forward stdout');
        assertEqual(result.haltCode, null, 'forward halt code');
      },
    },
    {
      name: 'Eyelet forward rules autoload library helpers and dynify source state',
      run: () => {
        const result = run(`
state(a).
changed :+ becomes(state(a), state(b)).
seed :+ state(b).
ready :+ seed, stable(1).
true :+ ready.
`);
        assertEqual(result.stdout, 'ready.\n', 'forward helper stdout');
      },
    },
    {
      name: 'Eyelet false conclusions emit a fuse and halt status 2',
      run: () => {
        const result = run('bad(a).\nfalse :+ bad(X).\n');
        assertEqual(result.stdout, 'fuse(bad(a)).\n', 'fuse stdout');
        assertEqual(result.haltCode, 2, 'fuse halt code');
      },
    },
    {
      name: 'Eyelet ordinary conclusions skolemize conclusion-only variables',
      run: () => {
        const result = run('seed(a).\npair(X, Y) :+ seed(X).\ntrue :+ pair(X, Y).\n');
        assertEqual(result.stdout, 'pair(a,sk_0).\n', 'skolemized forward answer');
      },
    },
    {
      name: 'run exposes false/0 as an always-failing built-in',
      run: () => {
        const result = run('answer(ok) :- false.\n', { goal: 'answer(X)' });
        assertEqual(result.stdout, '', 'stdout');
        assertEqual(Boolean(createDefaultRegistry().get('false', 0)), true, 'false/0 is registered');
      },
    },
    {
      name: 'source clauses cannot redefine false/0',
      run: () => {
        for (const source of ['false.\n', 'false :- true.\n', ':- dynamic(false/0).\n']) {
          let error = null;
          try {
            Program.parse(source);
          } catch (caught) {
            error = caught;
          }
          assertEqual(error?.name, 'PrologError', 'error name');
          assertEqual(error?.message, 'error(permission_error(modify, static_procedure), /(false, 0))', 'error');
        }
      },
    },

    {
      name: 'compound factory canonicalizes zero arity to atoms',
      run: () => {
        const nil = compound('nil', []);
        assertEqual(nil.type, 'atom', 'type');
        assertEqual(nil.name, 'nil', 'name');
        assertEqual(nil.arity, 0, 'arity');
        assertEqual(termToString(nil, new Env(), true), 'nil', 'readback');
        assertEqual(unify(nil, atom('nil'), new Env()), true, 'unifies with atom');
      },
    },


    {
      name: 'run query can enable proof explanations',
      run: () => {
        const result = run('%% goal: q(X, Y)\np(a, b).\nq(X, Y) :- p(X, Y).\n', { proof: true });
        assertIncludes(result.stdout, 'q(a, b).\nwhy(', 'stdout');
      },
    },

    {
      name: 'proof certificates verify source derivations without proof search',
      run: () => {
        const program = Program.parse('p(a, b).\nq(X, Y) :- p(X, Y).\n', { sourceMetadata: true });
        const result = proofCertificate(program, parseGoalText('q(a, b)'));
        assertEqual(result.ok, true, 'certificate generated');
        assertEqual(result.certificate.version, 1, 'certificate version');
        assertEqual(result.certificate.answer, 'q(a, b)', 'certificate answer');
        const checked = verifyProof(program, result);
        assertEqual(checked.ok, true, 'certificate verifies');
        assertEqual(checked.trusted.length, 0, 'source-only certificate has no trusted boundaries');
      },
    },
    {
      name: 'proof verification rejects a tampered child goal',
      run: () => {
        const program = Program.parse('p(a, b).\nq(X, Y) :- p(X, Y).\n', { sourceMetadata: true });
        const result = proofCertificate(program, parseGoalText('q(a, b)'));
        const tampered = structuredClone(result.certificate);
        tampered.proof.children[0].goal = 'p(a, c)';
        assertEqual(verifyProof(program, tampered).ok, false, 'tampered child is rejected');
        const bindingTamper = structuredClone(result.certificate);
        bindingTamper.proof.bindings[1].value = 'c';
        assertEqual(verifyProof(program, bindingTamper).ok, false, 'tampered binding is rejected');
        const changedProgram = Program.parse('p(a, c).\nq(X, Y) :- p(X, Y).\n', { sourceMetadata: true });
        assertEqual(verifyProof(changedProgram, result).ok, false, 'changed source program is rejected');
      },
    },
    {
      name: 'why/2 text round-trips into a verifiable proof certificate',
      run: () => {
        const program = Program.parse('p(a).\nq(X) :- p(X).\n', { sourceMetadata: true });
        const result = proofCertificate(program, parseGoalText('q(a)'));
        const parsed = proofCertificatesFromText(result.text, program);
        assertEqual(parsed.length, 1, 'certificate count');
        assertEqual(verifyProof(program, parsed[0]).ok, true, 'round-tripped certificate verifies');
      },
    },
    {
      name: 'proof certificate text round-trips under every double_quotes mode',
      run: () => {
        for (const doubleQuotes of ['chars', 'codes', 'atom']) {
          const program = Program.parse('p(a).\nq(X) :- p(X).\n', { sourceMetadata: true, doubleQuotes });
          const result = proofCertificate(program, parseGoalText('q(a)', { doubleQuotes }));
          const parsed = proofCertificatesFromText(result.text, program);
          assertEqual(parsed.length, 1, `${doubleQuotes} certificate count`);
          assertEqual(verifyProof(program, parsed[0]).ok, true, `${doubleQuotes} certificate verifies`);
        }
      },
    },
    {
      name: 'expanded proof detail opens bundled Prolog library clauses',
      run: () => {
        const program = Program.parse(':- use_module(library(lists)).\nq(X) :- member(X, [a,b]).\n', { sourceMetadata: true });
        const abstract = proofCertificate(program, parseGoalText('q(a)'));
        const expanded = proofCertificate(program, parseGoalText('q(a)'), { proofDetail: 'expanded' });
        assertEqual(abstract.certificate.proof.children[0].method.type, 'library', 'abstract library boundary');
        assertEqual(expanded.certificate.proof.children[0].method.type, 'source', 'expanded library source');
        const abstractChecked = verifyProof(program, abstract);
        const expandedChecked = verifyProof(program, expanded);
        assertEqual(abstractChecked.ok, true, 'abstract certificate verifies');
        assertEqual(abstractChecked.trusted.length, 1, 'abstract certificate reports library trust');
        assertEqual(abstractChecked.trusted[0].type, 'library', 'reported trust boundary type');
        assertEqual(expandedChecked.ok, true, 'expanded certificate verifies');
        assertEqual(expandedChecked.trusted.length, 0, 'pure-Prolog expanded certificate removes library trust');
      },
    },

    {
      name: 'run accepts Program instances',
      run: () => {
        const program = Program.parse('p(a, b).\nq(X, Y) :- p(X, Y).\n');
        const result = run(program, { goal: 'q(X, Y)' });
        assertEqual(result.stdout, 'q(a, b).\n', 'stdout');
      },
    },
    {
      name: 'run keeps recursive queries independent in one solver',
      run: () => {
        const text = fs.readFileSync(path.join(packageRoot, 'examples', 'alignment-demo.pl'), 'utf8');
        const program = Program.parseSources([{ text, filename: 'alignment-demo.pl' }]);
        const result = run(program, { goals: goalsFromSource(text) });
        assertIncludes(result.stdout, 'broaderTransitive(anpr_passenger_car, ref_car).\n', 'stdout');
        assertIncludes(result.stdout, 'narrowerOrEqualOf(anpr_passenger_car, ref_car).\n', 'stdout');
      },
    },
    {
      name: 'makeProgram creates indexed programs',
      run: () => {
        const program = makeProgram('edge(a, b).\npath(X, Y) :- edge(X, Y).\n');
        const group = program.findGroup('path', 2);
        assertEqual(Boolean(group), true, 'path/2 group exists');
        assertEqual(group.groupName ?? group.name, 'path', 'group name');
        assertEqual(group.arity, 2, 'group arity');
      },
    },
    {
      name: 'program keeps negation diagnostics lazy by default',
      run: () => {
        const program = Program.parse('p(a).\nq(X) :- \\+ p(X).\n');
        assertEqual(program._negationAnalysis, null, 'analysis starts lazy');
        assertEqual(program.negationDependencies.length, 1, 'dependency count');
        assertEqual(program._negationAnalysis !== null, true, 'analysis computed on demand');
      },
    },
    {
      name: 'analyzeNegation option computes diagnostics eagerly',
      run: () => {
        const program = Program.parse('p(a).\nq(X) :- \\+ p(X).\n', { analyzeNegation: true });
        assertEqual(program._negationAnalysis !== null, true, 'analysis computed eagerly');
        assertEqual(program.stratifiedNegation, true, 'stratified negation');
      },
    },
    {
      name: 'program reports stratified negation metadata',
      run: () => {
        const program = Program.parse(`
%% goal: open(X0)
candidate(a).
blocked(b).
closed(X) :- blocked(X).
open(X) :- candidate(X), \\+ closed(X).
`);
        assertEqual(program.isStratifiedNegation(), true, 'stratified negation');
        assertEqual(program.negationStratificationErrors.length, 0, 'stratification errors');
        assertEqual(program.findGroup('closed', 1).negationStratum, 0, 'closed stratum');
        assertEqual(program.findGroup('open', 1).negationStratum, 1, 'open stratum');
      },
    },
    {
      name: 'program detects unstratified negation cycles',
      run: () => {
        const program = Program.parse('p(X) :- q(X).\nq(X) :- \\+ p(X).\n');
        assertEqual(program.isStratifiedNegation(), false, 'unstratified negation');
        assertEqual(program.negationStratificationErrors.length, 1, 'stratification error count');
        assertEqual(program.negationStratificationErrors[0].from, 'q/1', 'error source');
        assertEqual(program.negationStratificationErrors[0].to, 'p/1', 'error target');
        let threw = false;
        try { program.assertStratifiedNegation(); } catch (err) {
          threw = true;
          assertIncludes(err.message, 'unstratified negation', 'error message');
        }
        assertEqual(threw, true, 'assertion throws');
      },
    },
    {
      name: 'strictNegation option rejects unstratified programs',
      run: () => {
        let threw = false;
        try { Program.parse('p(X) :- \\+ p(X).\n', { strictNegation: true }); } catch (err) {
          threw = true;
          assertIncludes(err.message, 'p/1 depends negatively on p/1', 'error message');
        }
        assertEqual(threw, true, 'strict negation throws');
      },
    },
    {
      name: 'run executes an explicitly imported list module',
      run: () => {
        const result = run(':- use_module(library(lists), [append/3]).\nanswer(X) :- append([a], [b], X).', { goal: 'answer(X)' });
        assertEqual(result.stdout, 'answer("ab").\n', 'stdout');
      },
    },
    {
      name: 'Solver executes an explicitly imported list module',
      run: () => {
        const program = Program.parse(':- use_module(library(lists)).\nanswer(X) :- append([a], [b], X).');
        const solver = new Solver(program);
        const goal = parseGoalText('answer(X)');
        const answers = [...solver.solve([goal], new Env(), 0)].map((env) => termToString(goal, env, true));
        assertEqual(answers.join('\n'), 'answer("ab")', 'answers');
      },
    },
    {
      name: 'library(lists) exposes the Trealla/Scryer common surface',
      run: () => {
        const program = Program.parse(`:- use_module(library(lists)).
identity(X, X).
pair(A, B, A-B).
step(X, A0, A) :- A is A0 + X.
check(A, B, C, D, E, F) :-
  append([[a],[b]], A),
  memberchk(a, A),
  same_length(A, [_,_]),
  nth0(1, A, b, B),
  maplist(identity, A, C),
  maplist(pair, A, [1,2], D),
  foldl(step, [1,2,3], 0, E),
  nth1(2, A, b, F).
`);
        assertEqual(program.findGroup('append', 2)?.module, 'lists', 'append/2 import');
        assertEqual(program.findGroup('memberchk', 2)?.module, 'lists', 'memberchk/2 import');
        assertEqual(program.findGroup('same_length', 2)?.module, 'lists', 'same_length/2 import');
        assertEqual(program.findGroup('nth0', 4)?.module, 'lists', 'nth0/4 import');
        assertEqual(program.findGroup('maplist', 2)?.module, 'lists', 'maplist/2 import');
        assertEqual(program.findGroup('maplist', 3)?.module, 'lists', 'maplist/3 import');
        assertEqual(program.findGroup('foldl', 4)?.module, 'lists', 'foldl/4 import');
        const result = run(program, { goal: 'check(A,B,C,D,E,F)' });
        assertIncludes(result.stdout, 'check("ab", "a", "ab", [a - 1, b - 2], 6, "a").\n', 'stdout');
      },
    },
    {
      name: 'shared Scryer/Trealla libraries compose through their common source interfaces',
      run: () => {
        const source = `:- use_module(library(charsio), [char_type/2]).
:- use_module(library(clpb), [sat/1, labeling/1]).
:- use_module(library(gensym), [gensym/2, reset_gensym/1]).
:- use_module(library(lists), [transpose/2]).
:- use_module(library(ordsets), [ord_union/3]).
:- use_module(library(reif), [tfilter/3, (=)/3]).
:- use_module(library(ugraphs), [vertices_edges_to_ugraph/3, reachable/3]).
:- use_module(library(when), [when/2]).
answer(X,Y,U,R,F,W,G,C,T) :-
  sat(X * ~Y), labeling([X,Y]),
  ord_union([a,c], [b,c], U),
  vertices_edges_to_ugraph([a,b,c], [a-b,b-c], Graph), reachable(a, Graph, R),
  tfilter(=(a), [a,b,a], F),
  when(nonvar(Ready), W=yes), Ready=now,
  reset_gensym(shared), gensym(shared, G),
  char_type(a, upper(C)),
  transpose([[1,2],[3,4]], T).
`;
        const result = run(source, { goal: 'answer(X,Y,U,R,F,W,G,C,T)' });
        assertEqual(result.stdout,
          'answer(1, 0, "abc", "abc", "aa", yes, shared1, "A", [[1, 3], [2, 4]]).\n',
          'composed common-library answer');
      },
    },
    {
      name: 'new Trealla/Scryer arithmetic and charsio intersection predicates compose',
      run: () => {
        const source = `:- use_module(library(arithmetic)).
:- use_module(library(charsio)).
answer(R,N,D,V,S,C,B,Decoded) :-
  number_to_rational(0.5,R), rational_numerator_denominator(R,N,D),
  read_term_from_chars("f(X,X,Y).",T,[variable_names(V),singletons(S)]),
  T=f(a,a,b),
  write_term_to_chars(T,[quoted(true)],C),
  chars_base64("hello",B,[]), chars_base64(Decoded,B,[]).
`;
        const result = run(source, { goal: 'answer(R,N,D,V,S,C,B,Decoded)' });
        assertEqual(result.stdout,
          'answer(rdiv(1, 2), 1, 2, [\'X\' = a, \'Y\' = b], [\'Y\' = b], "f(a,a,b)", "aGVsbG8=", "hello").\n',
          'arithmetic/charsio common surface');
      },
    },
    {
      name: 'library(files) and library(os) expose the Trealla/Scryer Node host intersection',
      run: () => {
        const root = path.join(tmp, 'common-system-libs');
        fs.mkdirSync(root, { recursive: true });
        const oldFile = path.join(root, 'old.txt');
        const newFile = path.join(root, 'new.txt');
        const nested = path.join(root, 'a', 'b');
        fs.writeFileSync(oldFile, 'ok');
        const source = `:- use_module(library(files)).
:- use_module(library(lists), [member/2]).
:- use_module(library(os)).
answer(Status,Pid) :-
  make_directory_path(${JSON.stringify(nested)}),
  rename_file(${JSON.stringify(oldFile)},${JSON.stringify(newFile)}),
  directory_files(${JSON.stringify(root)},Entries), member(".",Entries), member("..",Entries), member("new.txt",Entries), member("a",Entries),
  setenv("EYEPROLOG_LIBRARY_TEST","ok"), getenv("EYEPROLOG_LIBRARY_TEST","ok"),
  shell("exit 7",Status), pid(Pid), unsetenv("EYEPROLOG_LIBRARY_TEST").
`;
        const result = run(source, { goal: 'answer(Status,Pid)' });
        assertIncludes(result.stdout, 'answer(7, ', 'files/os result');
        assertEqual(fs.existsSync(newFile), true, 'rename_file/2 changed the filesystem');
        assertEqual(fs.existsSync(nested), true, 'make_directory_path/1 created nested directories');
      },
    },
    {
      name: 'library(sockets) provides Scryer-compatible bidirectional TCP text streams',
      run: () => {
        const source = `:- use_module(library(sockets)).
answer(Port,Client,Term,Mode,Alias,Host) :-
  current_hostname(Host), atom(Host),
  socket_server_open('127.0.0.1':Port,Server), Port > 0,
  socket_client_open('127.0.0.1':Port,Out,[type(text),alias(client_socket),eof_action(eof_code)]),
  socket_server_accept(Server,Client,In,[type(text)]),
  stream_property(Out,input), stream_property(Out,output),
  stream_property(Out,mode(Mode)), stream_property(Out,alias(Alias)),
  stream_property(Out,position(0)), stream_property(Out,file_name(FileName)), atom(FileName),
  socket_server_close(Server),
  write(Out,ping), put_char(Out,'.'), nl(Out), flush_output(client_socket),
  read(In,Term),
  close(Out), close(In).
`;
        const result = run(source, { goal: 'answer(Port,Client,Term,Mode,Alias,Host)' });
        assertIncludes(result.stdout, ', ping, read_append, client_socket, ', 'socket text stream result');
        assertIncludes(result.stdout, "'127.0.0.1:", 'accepted peer address');
      },
    },
    {
      name: 'library(sockets) supports binary streams and rejects repositioning',
      run: () => {
        const source = `:- use_module(library(sockets)).
answer(A,B) :-
  socket_server_open(Port,Server),
  socket_client_open('127.0.0.1':Port,Out,[type(binary)]),
  socket_server_accept(Server,_,In,[type(binary)]),
  put_byte(Out,65), put_byte(Out,255), flush_output(Out),
  get_byte(In,A), get_byte(In,B),
  close(Out), close(In), socket_server_close(Server).
reject_reposition :-
  socket_server_open(Port,Server),
  catch(socket_client_open('127.0.0.1':Port,_,[reposition(true)]),
        error(permission_error(reposition,stream,_),_),
        true),
  socket_server_close(Server).
`;
        assertEqual(run(source, { goal: 'answer(A,B)' }).stdout, 'answer(65, 255).\n', 'binary socket stream');
        assertEqual(run(source, { goal: 'reject_reposition' }).stdout, 'reject_reposition.\n', 'socket reposition error');
      },
    },
    {
      name: 'completed Scryer arithmetic charsio dcgs and lists predicates compose',
      run: () => {
        const source = String.raw`:- use_module(library(arithmetic)).
:- use_module(library(charsio)).
:- use_module(library(dcgs)).
:- use_module(library(lists)).
oct(a,b,c,d,e,f,g,h).
pair(A,B) --> [A,B].
answer(R,Cs,Bs) :-
  expmod(2,10,1000,24), lcm(12,18,36),
  number_to_rational(0.001,0.3333333333333333,R),
  chars_utf8bytes("∑",Bs), chars_utf8bytes(Cs,Bs),
  maplist(oct,[a],[b],[c],[d],[e],[f],[g],[h]),
  phrase(phrase(pair,a,b), [a,b]),
  phrase((..., [z]), [x,y,z]).
`;
        assertEqual(run(source, { goal: 'answer(R,Cs,Bs)' }).stdout,
          'answer(rdiv(1, 3), "∑", [226, 136, 145]).\n',
          'completed portable Scryer surface');
      },
    },
    {
      name: 'library(iso_ext) supports Scryer blackboard bounded inference partial strings and copy_term/3 residues',
      run: () => {
        const source = `:- use_module(library(iso_ext)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
p(1). p(2).
answer(R1,R2,Old,Partial,Tail,DifGoals,ClpGoals) :-
  call_with_inference_limit(p(_),100,R1), R1=true,
  call_with_inference_limit((repeat,fail),10,R2),
  bb_put(k,old), (bb_b_put(k,new), fail ; bb_get(k,Old)),
  partial_string("ab",Partial,Tail), Tail=[z],
  dif(X,a), copy_term(X,C,DifGoals), C=b,
  Y #> 3, copy_term(Y,D,ClpGoals), D=5.
`;
        const result = run(source, { goal: 'answer(R1,R2,Old,Partial,Tail,DifGoals,ClpGoals)' });
        assertEqual(result.stdout,
          'answer(true, inference_limit_exceeded, old, "abz", "z", [dif(b, a)], [clpz:(5 in 4..sup)]).\n',
          'iso_ext Scryer semantics');
        const negative = run(`:- use_module(library(iso_ext)).\nnegative :- catch(call_with_inference_limit(true,-1,_),error(domain_error(not_less_than_zero,-1),_),true).\n`, {
          goal: 'negative',
        });
        assertEqual(negative.stdout, 'negative.\n', 'negative inference limit domain error');
      },
    },
    {
      name: 'library(files) covers the full current Scryer filesystem surface',
      run: () => {
        const root = path.join(tmp, 'scryer-files-full');
        const file = path.join(root, 'a.txt');
        const copy = path.join(root, 'b.txt');
        fs.mkdirSync(root, { recursive: true });
        fs.writeFileSync(file, 'abc');
        const source = `:- use_module(library(files)).
:- use_module(library(time)).
answer(Size,Canonical,Segments,Back,Year) :-
  file_exists(${JSON.stringify(file)}), directory_exists(${JSON.stringify(root)}),
  file_size(${JSON.stringify(file)},Size), file_copy(${JSON.stringify(file)},${JSON.stringify(copy)}),
  path_canonical(${JSON.stringify(copy)},Canonical), path_segments(${JSON.stringify(copy)},Segments),
  path_segments(Back,Segments), file_modification_time(${JSON.stringify(copy)},T),
  file_access_time(${JSON.stringify(copy)},_), file_creation_time(${JSON.stringify(copy)},_),
  phrase(format_time("%Y",T),Year), delete_file(${JSON.stringify(copy)}).
`;
        const result = run(source, { goal: 'answer(Size,Canonical,Segments,Back,Year)' });
        assertIncludes(result.stdout, 'answer(3, "', 'file size and canonical path');
        assertIncludes(result.stdout, '"tmp"', 'path_segments/2 components');
        assertEqual(fs.existsSync(copy), false, 'delete_file/1 removed the copy');
      },
    },
    {
      name: 'library(pio) accepts Scryer character-list paths and phrase_from_stream/2',
      run: () => {
        const file = path.join(tmp, 'pio-scryer-chars.txt');
        fs.writeFileSync(file, 'abc');
        const source = `:- use_module(library(pio)).
all([C|Cs]) --> [C], !, all(Cs).
all([]) --> [].
from_file(Cs) :- phrase_from_file(all(Cs),${JSON.stringify(file)}).
from_stream(Cs) :- open(${sourceAtom(file)},read,S), phrase_from_stream(all(Cs),S), close(S).
`;
        assertEqual(run(source, { goal: 'from_file(Cs)' }).stdout, 'from_file("abc").\n', 'character-list file path');
        assertEqual(run(source, { goal: 'from_stream(Cs)' }).stdout, 'from_stream("abc").\n', 'stream DCG input');
      },
    },
    {
      name: 'library(crypto) matches deterministic hash, HMAC, and HKDF vectors',
      run: () => {
        const source = `:- use_module(library(crypto)).
answer(Bytes) :-
  hex_bytes("501ACE",[80,26,206]),
  crypto_data_hash("abc","ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad",[algorithm(sha256)]),
  crypto_data_hash("abc","9c196e32dc0175f86f4b1cb89289d6619de6bee699e4c378e68309ed97a1a6ab",[algorithm(sha256),hmac([107,101,121])]),
  crypto_data_hkdf("ikm",16,Bytes,[algorithm(sha256),salt([1,2,3]),info("ctx")]).
`;
        const result = run(source, { goal: 'answer(Bytes)' });
        assertEqual(result.stdout,
          'answer([88, 155, 48, 74, 204, 30, 221, 100, 71, 23, 177, 120, 135, 159, 145, 52]).\n',
          'crypto vectors');
      },
    },
    {
      name: 'library(crypto) supports password verification and authenticated ChaCha20-Poly1305 round trips',
      run: () => {
        const source = `:- use_module(library(crypto)).
check :-
  crypto_password_hash("secret",Hash,[cost(4),salt([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15])]),
  crypto_password_hash("secret",Hash),
  Key=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31],
  IV=[0,1,2,3,4,5,6,7,8,9,10,11],
  crypto_data_encrypt("hello",'chacha20-poly1305',Key,IV,Cipher,[tag(Tag),aad("meta")]),
  crypto_data_decrypt(Cipher,'chacha20-poly1305',Key,IV,"hello",[tag(Tag),aad("meta")]).
`;
        assertEqual(run(source, { goal: 'check' }).stdout, 'check.\n', 'crypto round trip');
      },
    },
    {
      name: 'library(crypto) supports Ed25519, X25519, and secp256k1 compatibility operations',
      run: () => {
        const source = `:- use_module(library(crypto)).
:- use_module(library(lists), [maplist/3]).
check :-
  hex_bytes("9d61b19deffd5a60ba844af492ec2cc44449c5697b326919703bac031cae7f60",Seed),
  ed25519_seed_keypair(Seed,Pair), ed25519_keypair_public_key(Pair,Public),
  maplist(char_code,Public,PublicBytes),
  hex_bytes("d75a980182b10ab7d54bfed3c964073a0ee172f3daa62325af021a68f707511a",PublicBytes),
  ed25519_sign(Pair,[],"e5564300c360ac729086e2cc806e828a84877f1eb8e5d974d873e065224901555fb8821590a33bacc61e39701cf9b46bd25bf5f0595bbe24655141438e7a100b",[]),
  curve25519_generator(G),
  A=[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  B=[2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  curve25519_scalar_mult(A,G,AP), curve25519_scalar_mult(B,G,BP),
  curve25519_scalar_mult(A,BP,Shared), curve25519_scalar_mult(B,AP,Shared),
  crypto_name_curve(secp256k1,Curve), crypto_curve_generator(Curve,Generator),
  crypto_curve_scalar_mult(Curve,2,Generator,point(89565891926547004231252920425935692360644145829622209833684329913297188986597,12158399299693830322967808612713398636155367887041628176798871954788371653930)).
`;
        assertEqual(run(source, { goal: 'check' }).stdout, 'check.\n', 'elliptic-curve compatibility');
      },
    },
    {
      name: 'library(time) and library(iso_ext) expose their shared compatibility re-exports',
      run: () => {
        const source = `:- use_module(library(iso_ext)).
:- use_module(library(time)).
answer(D) :-
  copy_term_nat(f(a),f(a)), call_residue_vars(true,[]),
  call_cleanup(true,true), setup_call_cleanup(true,true,true),
  sleep(0), statistics(max_depth,D).
`;
        const result = run(source, { goal: 'answer(D)' });
        assertIncludes(result.stdout, 'answer(', 'time/iso_ext re-exports');
      },
    },
    {
      name: 'library(format), library(time), random, and UUID compatibility adapters retain reusable Prolog APIs',
      run: () => {
        const source = `:- use_module(library(format)).
:- use_module(library(random)).
:- use_module(library(time)).
:- use_module(library(uuid)).
answer(A,B,Text,Bytes,Date) :-
  set_random(seed(7)),
  random_integer(10,20,A), random_integer(10,20,B),
  phrase(format_('~w ~q ~d', [f(a),'two words',3]), Text),
  uuid_string(Bytes, "61ae692e-eaf6-4199-8dd3-9f01db70a20b"),
  current_time(T), phrase(format_time("%Y-%m-%d", T), Date).
`;
        const result = run(source, { goal: 'answer(A,B,Text,Bytes,Date)' });
        assertIncludes(result.stdout, 'answer(17, 18, "f(a) \'two words\' 3", [97, 174, 105, 46, 234, 246, 65, 153, 141, 211, 159, 1, 219, 112, 162, 11], "', 'state and conversion output');
      },
    },
    {
      name: 'normal profile accepts the explicit table directive without a library import',
      run: () => {
        const source = `:- table path/2.
edge(a,b). edge(b,c).
path(X,Y) :- path(X,Z), edge(Z,Y).
path(X,Y) :- edge(X,Y).
`;
        const result = run(source, { goal: 'path(a,Y)' });
        assertEqual(result.stdout, 'path(a, b).\npath(a, c).\n', 'tabled closure');
      },
    },
    {
      name: 'library(pio) reads and writes DCG character streams',
      run: () => {
        const file = path.join(tmp, 'pio-common.txt');
        const source = `:- use_module(library(pio)).
letters --> [a,b,c].
all([C|Cs]) --> [C], !, all(Cs).
all([]) --> [].
write_file :- phrase_to_file(letters, ${sourceAtom(file)}).
read_file(Cs) :- phrase_from_file(all(Cs), ${sourceAtom(file)}).
`;
        assertEqual(run(source, { goal: 'write_file' }).stdout, 'write_file.\n', 'DCG write');
        assertEqual(run(source, { goal: 'read_file(Cs)' }).stdout, 'read_file("abc").\n', 'DCG read');
      },
    },
    {
      name: 'library(lambda) supports Scryer-style maplist lambdas',
      run: () => {
        const source = String.raw`:- use_module(library(lambda)).
:- use_module(library(lists)).
answer :- maplist(\X^(X>3), [4,5,9]).
`;
        const result = run(source, { goal: 'answer' });
        assertEqual(result.stdout, 'answer.\n', 'stdout');
      },
    },
    {
      name: 'library(lambda) refreshes local variables on each invocation',
      run: () => {
        const source = String.raw`:- use_module(library(lambda)).
:- use_module(library(lists)).
answer :- maplist(\X^(Y=X), [a,b]).
`;
        const result = run(source, { goal: 'answer' });
        assertEqual(result.stdout, 'answer.\n', 'fresh local variables');
      },
    },
    {
      name: 'library(lambda) preserves explicitly free variables with +\\',
      run: () => {
        const source = String.raw`:- use_module(library(lambda)).
:- use_module(library(lists)).
answer(Y) :- maplist(Y+\X^(Y=X), [a,a]).
`;
        const program = Program.parse(source);
        const imported = [...program.operators.values()].find((operator) => operator.name === '+\\');
        assertEqual(`${imported?.priority}/${imported?.specifier}`, '201/xfx', '+\\ operator import');
        const result = run(program, { goal: 'answer(Y)' });
        assertEqual(result.stdout, 'answer(a).\n', 'free variable sharing');
      },
    },
    {
      name: 'library(lambda) supports continuations and seven call arguments',
      run: () => {
        const source = String.raw`:- use_module(library(lambda)).
f(x,y).
tuple(a,b,c,d,e,f,g).
answer(A,B) :-
  call(\X^f(X), A, B),
  call(\X^Y^f(X,Y), A, B),
  call(\P^Q^R^S^T^U^V^tuple(P,Q,R,S,T,U,V), a,b,c,d,e,f,g).
`;
        const result = run(source, { goal: 'answer(A,B)' });
        assertEqual(result.stdout, 'answer(x, y).\n', 'continuations');
      },
    },
    {
      name: 'library(lambda) diagnoses a missing lambda parameter',
      run: () => {
        const source = String.raw`:- use_module(library(lambda)).
answer(ok) :-
  catch(call(\X^true), error(existence_error(lambda_parameter,_),_), true).
`;
        const result = run(source, { goal: 'answer(X)' });
        assertEqual(result.stdout, 'answer(ok).\n', 'lambda parameter error');
      },
    },
    {
      name: 'autoload metadata records canonical bundled-library imports',
      run: () => {
        const program = Program.parse('answer(X) :- member(X, [a]), between(1, 1, _).\n');
        assertEqual(program.autoloadedPredicates.length, 2, 'autoloaded predicate count');
        assertEqual(program.autoloadedPredicates.map((entry) => `${entry.indicator}:${entry.library}`).sort().join(','),
          'between/3:between,member/2:lists', 'autoload mapping');
        assertEqual(program.interopPortabilityWarnings.length, 0, 'autoloaded portable calls are warning-free');
      },
    },
    {
      name: 'JavaScript run top-level goals participate in bundled-library autoloading',
      run: () => {
        const result = runEyeProlog('', { goal: 'member(X,[a,b])' });
        assertEqual(result.stdout, 'member(a, "ab").\nmember(b, "ab").\n', 'stdout');
      },
    },
    {
      name: 'JavaScript run autoloads top-level goals for parsed Program instances',
      run: () => {
        const program = Program.parse('');
        const revision = program.revision;
        program.stratifiedNegation;
        const result = runEyeProlog(program, { goal: 'member(X,[a,b])' });
        assertEqual(result.stdout, 'member(a, "ab").\nmember(b, "ab").\n', 'stdout');
        assertEqual(program.findGroup('member', 2)?.module, 'lists', 'autoloaded Program predicate');
        assertEqual(program.autoloadedPredicates.map((entry) => `${entry.indicator}:${entry.library}`).join(','),
          'member/2:lists', 'autoload metadata');
        assertEqual(program.revision, revision + 1, 'Program revision after autoload');
        assertEqual(program.stratifiedNegation, true, 'negation metadata recomputed after autoload');
      },
    },
    {
      name: 'JavaScript run can disable top-level goal autoloading',
      run: () => {
        let error = null;
        try {
          runEyeProlog('', { goal: 'member(X,[a])', autoload: false });
        } catch (caught) {
          error = caught;
        }
        assertIncludes(error?.message ?? '', 'existence_error(procedure)', 'error');
      },
    },
    {
      name: 'autoload can be disabled explicitly in the JavaScript API',
      run: () => {
        const program = Program.parse('answer(X) :- member(X, [a]).\n', { autoload: false });
        assertEqual(program.findGroup('member', 2), null, 'member/2 remains unresolved');
        assertEqual(program.autoloadedPredicates.length, 0, 'no autoloads');
      },
    },
    {
      name: 'program and solver public classes',
      run: () => {
        const program = Program.parse('p(a).\np(b).\n');
        const solver = new Solver(program);
        const goal = parseGoalText('p(X)');
        const answers = [...solver.solve([goal], new Env(), 0)].map((env) => termToString(goal, env, true));
        assertEqual(answers.join('\n'), 'p(a)\np(b)', 'answers');
      },
    },
    {
      name: 'solver has no implicit solution limit',
      run: () => {
        const program = Program.parse('p(a).\n');
        const solver = new Solver(program);
        assertEqual(String(solver.solutionLimit), 'Infinity', 'default solution limit');
        // Crossing the former 10,000,000-answer ceiling must not make an
        // otherwise available answer disappear. This exercises the boundary
        // without making the regression suite enumerate ten million answers.
        solver.solutionsSeen = 10_000_000;
        const goal = parseGoalText('p(X)');
        const answers = [...solver.solve([goal], new Env(), 0)].map((env) => termToString(goal, env, true));
        assertEqual(answers.join('\n'), 'p(a)', 'answer beyond former default ceiling');
      },
    },
    {
      name: 'fresh-variable generation stays bounded under a small host heap',
      run: () => {
        const engineUrl = new URL('../src/index.js', import.meta.url).href;
        const programText = 'p(X) :- repeat, q(X).\nq(_).\n';
        const script = `
          import { Program, Solver, Env, parseGoalText, getEyePrologRegistry } from ${JSON.stringify(engineUrl)};
          const program = Program.parse(${JSON.stringify(programText)});
          const solver = new Solver(program, { registry: getEyePrologRegistry() });
          const goal = parseGoalText('p(X)');
          let count = 0;
          for (const _ of solver.solve([goal], new Env(), 0)) {
            if (++count === 300000) break;
          }
          if (count !== 300000) throw new Error('unexpected answer count: ' + count);
          process.stdout.write(String(count));
        `;
        const result = spawnSync(process.execPath, [
          '--max-old-space-size=32',
          '--input-type=module',
          '--eval',
          script,
        ], { cwd: packageRoot, encoding: 'utf8', timeout: 30000 });
        if (result.error) throw result.error;
        assertEqual(result.status, 0, `bounded-heap child status; stderr=${result.stderr}`);
        assertEqual(result.stdout, '300000', 'fresh-variable answer count');
      },
    },
    {
      name: 'ground Prolog error terms are reused across catches',
      run: () => {
        const error = new PrologError('syntax_error(number)');
        const first = formalErrorTerm(error);
        const second = formalErrorTerm(error);
        assertEqual(first === second, true, 'reused ground error term');
      },
    },
    {
      name: 'caught number syntax errors do not exhaust memory on distinct inputs',
      run: () => {
        const engineUrl = new URL('../src/index.js', import.meta.url).href;
        const programText = `
          :- use_module(library(lists)).
          alphabet(['0','1','2','3','4','5','6','7','8','9','.']).
          trial([A,B,C,D,E,F]) :-
            alphabet(Chars),
            member(A, Chars), member(B, Chars), member(C, Chars),
            member(D, Chars), member(E, Chars), member(F, Chars),
            catch(number_chars(_, [A,B,C,D,E,F]), error(syntax_error(number), _), true).
        `;
        const script = `
          import { Program, Solver, Env, parseGoalText, getEyePrologRegistry } from ${JSON.stringify(engineUrl)};
          const program = Program.parse(${JSON.stringify(programText)});
          const solver = new Solver(program, { registry: getEyePrologRegistry() });
          const goal = parseGoalText('trial(Chars)');
          let count = 0;
          for (const _ of solver.solve([goal], new Env(), 0)) {
            if (++count === 250000) break;
          }
          if (count !== 250000) throw new Error('unexpected answer count: ' + count);
          process.stdout.write(String(count));
        `;
        const result = spawnSync(process.execPath, [
          // Run well past the roughly 126,000-answer failure reported in #28
          // while keeping the host heap deliberately constrained.
          '--max-old-space-size=32',
          '--input-type=module',
          '--eval',
          script,
        ], { cwd: packageRoot, encoding: 'utf8', timeout: 30000 });
        if (result.error) throw result.error;
        assertEqual(result.status, 0, `bounded-heap child status; stderr=${result.stderr}`);
        assertEqual(result.stdout, '250000', 'distinct number syntax attempts');
      },
    },
    {
      name: 'recursive phrase tables stay bounded across distinct inputs (issues #28/#48)',
      run: () => {
        const engineUrl = new URL('../src/index.js', import.meta.url).href;
        const programText = `
          :- use_module(library(prologue)).
          ... --> [].
          ... --> [_], ... .

          vchars("0123456789.").

          ti(Nth:E:Chs, Pot, Start) :-
            length(Chs, _),
            call_nth(chs(Chs), Nth), Nth >= Start,
            Nth mod 10^Pot =:= 0,
            E = cnt.

          chs(Chs) :-
            vchars(VChs),
            maplistch(Chs, VChs),
            catch(number_chars(_, Chs), error(syntax_error(_), _), false),
            \\+ phrase((..., ("//"|"++")), Chs).

          maplistch([], _).
          maplistch([Ch|Chs], VChs) :-
            member(Ch, VChs),
            maplistch(Chs, VChs).
        `;
        const script = `
          import { Program, Solver, Env, parseGoalText, getEyePrologRegistry } from ${JSON.stringify(engineUrl)};
          const program = Program.parse(${JSON.stringify(programText)}, { autoloadGoals: ['ti(R,1,0)'] });
          const listTailGroup = program.findGroup('...', 2, 'user');
          if (listTailGroup?.listTailRecursive !== true) {
            throw new Error('recursive DCG tail-consumption was not recognized');
          }
          const solver = new Solver(program, { registry: getEyePrologRegistry(), maxMemoryBytes: Infinity });
          const goal = parseGoalText('ti(R,1,0)', {
            doubleQuotes: 'chars',
            operatorDefinitions: [...program.operators.values()],
          });
          let count = 0;
          for (const _ of solver.solve([goal], new Env(), 0)) {
            if (++count === 10) break;
          }
          if (count !== 10) throw new Error('unexpected checkpoint count: ' + count);
          const scope = solver.innerTableScopes.get('phrase');
          if (scope == null) throw new Error('missing phrase table scope');
          if (scope.memo.size !== 0) throw new Error('distinct tail-DCG inputs should not retain phrase tables: ' + scope.memo.size);
          process.stdout.write(count + ':' + scope.memo.size);
        `;
        const result = spawnSync(process.execPath, [
          // This covers 100 accepted number candidates, enough to exercise
          // many distinct recursive DCG inputs while keeping this a focused
          // bounded-cache regression rather than a memory stress benchmark.
          '--max-old-space-size=32',
          '--input-type=module',
          '--eval',
          script,
        ], { cwd: packageRoot, encoding: 'utf8', timeout: 30000 });
        if (result.error) throw result.error;
        assertEqual(result.status, 0, `bounded phrase-table child status; stderr=${result.stderr}`);
        const [countText, cacheText] = result.stdout.trim().split(':');
        assertEqual(countText, '10', 'recursive phrase checkpoints');
        assertEqual(cacheText, '0', 'distinct tail-DCG phrase cache');
      },
    },
    {
      name: 'explicitly tabled phrase invocation reuses a compact table (issue #48)',
      run: () => {
        const program = Program.parse(`
          :- use_module(library(prologue)).
          :- table tail/2.
          tail --> [].
          tail --> [_], tail .
        `, { autoloadGoals: ['phrase((tail,("ba"|"gh")),"abcdef")'] });
        const solver = new Solver(program, { registry: getEyePrologRegistry(), maxMemoryBytes: Infinity });
        const goal = parseGoalText('phrase((tail,("ba"|"gh")),"abcdef")', {
          doubleQuotes: 'chars',
          operatorDefinitions: [...program.operators.values()],
        });
        const runFailure = () => {
          let answers = 0;
          for (const _ of solver.solve([goal], new Env(), 0)) answers++;
          assertEqual(answers, 0, 'failing phrase answer count');
        };
        runFailure();
        const roundsAfterFirst = solver.stats.table_fixpoint_rounds;
        if (roundsAfterFirst <= 0) throw new Error('explicit table declaration did not build a table');
        const scope = solver.innerTableScopes.get('phrase');
        if (scope == null || scope.memo.size <= 0 || scope.memo.size > 1024) {
          throw new Error('unexpected explicit phrase table size: ' + (scope?.memo.size ?? 'missing'));
        }
        runFailure();
        assertEqual(solver.stats.table_fixpoint_rounds, roundsAfterFirst, 'second identical phrase call reuses completed table');
      },
    },
    {
      name: 'host Map/Set capacity errors become resource_error(memory)',
      run: () => {
        for (const [predicate, message] of [
          ['exhaust_map', 'Map maximum size exceeded'],
          ['exhaust_set', 'Set maximum size exceeded'],
        ]) {
          const registry = new BuiltinRegistry();
          registry.add(predicate, 0, function* () {
            throw new RangeError(message);
          });
          const solver = new Solver(Program.parse(''), { registry });
          const goal = parseGoalText(predicate);
          let caught = null;
          try {
            [...solver.solve([goal], new Env(), 0)];
          } catch (error) {
            caught = error;
          }
          assertEqual(caught?.name, 'PrologError', `${predicate} normalized error type`);
          assertEqual(caught?.formal, 'resource_error(memory)', `${predicate} normalized resource error`);
        }
      },
    },
    {
      name: 'unbounded length/2 reaches a catchable memory resource error (issue #49)',
      run: () => {
        const engineUrl = new URL('../src/index.js', import.meta.url).href;
        const script = `
          import { Program, Solver, Env, deref, variable, parseGoalText, getEyePrologRegistry } from ${JSON.stringify(engineUrl)};
          const program = Program.parse(${JSON.stringify(':- use_module(library(lists)).\n')}, { sourceMetadata: false });
          const solver = new Solver(program, { registry: getEyePrologRegistry() });
          const goal = parseGoalText('catch(length(L,N),error(E,_),true),L=N', {
            operatorDefinitions: [...program.operators.values()],
          });
          let answer = null;
          for (const env of solver.solve([goal], new Env(), 0)) {
            answer = env;
            break;
          }
          if (answer == null) throw new Error('issue #49 query produced no caught answer');
          const formal = deref(variable('E'), answer);
          if (formal?.name !== 'resource_error' || deref(formal.args?.[0], answer)?.name !== 'memory') {
            throw new Error('unexpected caught error: ' + JSON.stringify(formal));
          }
          const left = deref(variable('L'), answer);
          const right = deref(variable('N'), answer);
          if (left.type !== 'var' || right.type !== 'var' || left.name !== right.name) {
            throw new Error('recovery did not leave L=N');
          }
          process.stdout.write('caught');
        `;
        const result = spawnSync(process.execPath, [
          '--max-old-space-size=64',
          '--input-type=module',
          '--eval',
          script,
        ], { cwd: packageRoot, encoding: 'utf8', timeout: 5000 });
        if (result.error) throw result.error;
        assertEqual(result.status, 0, `issue #49 bounded-heap child status; stderr=${result.stderr}`);
        assertEqual(result.stdout, 'caught', 'issue #49 resource error is caught by catch/3');
      },
    },
    {
      name: 'discarded fixed-length lists stay compact under a bounded heap',
      run: () => {
        const engineUrl = new URL('../src/index.js', import.meta.url).href;
        const script = `
          import { Program, Solver, Env, parseGoalText, getEyePrologRegistry } from ${JSON.stringify(engineUrl)};
          const program = Program.parse(${JSON.stringify(':- use_module(library(prologue)).\n')}, { sourceMetadata: false });
          const solver = new Solver(program, { registry: getEyePrologRegistry() });
          const execute = (text) => {
            const goal = parseGoalText(text, { operatorDefinitions: [...program.operators.values()] });
            return [...solver.solve([goal], new Env(), 0)];
          };
          execute('length(L,10000000),fail');
          if (execute('length(L,1),L=[X],X=L').length !== 0) {
            throw new Error('compact list admitted a cyclic binding');
          }
          execute('length(L,1000),fail');
          process.stdout.write('compact');
        `;
        const result = spawnSync(process.execPath, [
          '--max-old-space-size=64',
          '--input-type=module',
          '--eval',
          script,
        ], { cwd: packageRoot, encoding: 'utf8', timeout: 30000 });
        if (result.error) throw result.error;
        assertEqual(result.status, 0, `bounded-heap child status; stderr=${result.stderr}`);
        assertEqual(result.stdout, 'compact', 'discarded list skeleton does not exhaust the heap');
      },
    },
    {
      name: 'deep recursive list guards do not consume the host call stack',
      run: () => {
        const program = Program.parse('l([]).\nl([_|L]) :- l(L).\n', { sourceMetadata: false });
        const left = listFromItems(Array.from({ length: 20000 }, (_, index) => variable(`L${index}`)));
        const right = listFromItems(Array.from({ length: 20000 }, (_, index) => variable(`R${index}`)));
        const solver = new Solver(program, {
          registry: getEyePrologRegistry(),
          maxDepth: 0,
          maxMemoryBytes: Infinity,
        });
        let error = null;
        try {
          [...solver.solve([compound('l', [left])], new Env(), 0)];
        } catch (caught) {
          error = caught;
        }
        assertEqual(error instanceof PrologError, true, 'explicit depth bound raises a Prolog resource error');
        assertEqual(error?.formal, 'resource_error(depth_limit)', 'depth resource error');
        assertEqual(variantTerms(left, new Env(), right, new Env()), true, 'deep lists are variants');
      },
    },
    {
      name: 'discarded recursive allocations recover after resource_error(memory)',
      run: () => {
        const engineUrl = new URL('../src/index.js', import.meta.url).href;
        const platformUrl = new URL('../src/platform.js', import.meta.url).href;
        const programText = `
          :- use_module(library(prologue)).
          l([]).
          l([E|L]) :- length(E,1000), l(L).
        `;
        const reportedGoal = 'length(_,I),N is 2^I,\\+ \\+ (length(L,N),l(L)),L=[_|_]';
        const script = `
          import { Program, Solver, Env, deref, variable, parseGoalText, getEyePrologRegistry } from ${JSON.stringify(engineUrl)};
          import { usedHeapSize } from ${JSON.stringify(platformUrl)};
          const program = Program.parse(${JSON.stringify(programText)}, { sourceMetadata: false });
          const registry = getEyePrologRegistry();
          const reported = parseGoalText(${JSON.stringify(reportedGoal)}, {
            operatorDefinitions: [...program.operators.values()],
          });
          const reportedSolver = new Solver(program, { registry, maxMemoryBytes: Infinity });
          let reportedAnswers = 0;
          for (const answer of reportedSolver.solve([reported], new Env(), 0)) {
            reportedAnswers++;
            if (reportedAnswers !== 14) continue;
            if (deref(variable('I'), answer).name !== '13' || deref(variable('N'), answer).name !== '8192') {
              throw new Error('reported query did not reach I=13, N=8192');
            }
            break;
          }
          if (reportedAnswers !== 14) throw new Error('reported query produced too few answers');

          // Exercise EyeProlog's recovery window at a stable threshold relative
          // to the heap after the preliminary reproduction. Force a full GC first
          // so V8 versions that retain/promote young objects differently do not
          // make this resource-error trigger depend on collector timing.
          globalThis.gc?.();
          const solver = new Solver(program, {
            registry,
            maxMemoryBytes: usedHeapSize() + 2 * 1024 * 1024,
          });
          const execute = (text) => {
            const goal = parseGoalText(text, { operatorDefinitions: [...program.operators.values()] });
            return [...solver.solve([goal], new Env(), 0)];
          };
          let caught = null;
          try { execute('length(L,32768),l(L)'); } catch (error) { caught = error; }
          if (caught?.formal !== 'resource_error(memory)') throw caught ?? new Error('no resource error');
          if (execute('length(L,10),l(L)').length !== 1) throw new Error('recovery query failed');
          process.stdout.write('recovered');
        `;
        const result = spawnSync(process.execPath, [
          '--max-old-space-size=64',
          '--expose-gc',
          '--input-type=module',
          '--eval',
          script,
        ], { cwd: packageRoot, encoding: 'utf8', timeout: 30000 });
        if (result.error) throw result.error;
        assertEqual(result.status, 0, `bounded-heap child status; stderr=${result.stderr}`);
        assertEqual(result.stdout, 'recovered', 'discarded recursive terms are collectible after unwinding');
      },
    },
    {
      name: 'anonymous Prologue length checks avoid materializing discarded lists',
      run: () => {
        const engineUrl = new URL('../src/index.js', import.meta.url).href;
        const programText = ':- use_module(library(prologue)).\n';
        const goalText = 'length(_, I), I > 9, N is 2^I, \\+ \\+ length(_, N)';
        const script = `
          import { Program, Solver, Env, parseGoalText, getEyePrologRegistry } from ${JSON.stringify(engineUrl)};
          const program = Program.parse(${JSON.stringify(programText)}, { sourceMetadata: false });
          const solver = new Solver(program, {
            registry: getEyePrologRegistry(),
            solutionLimit: 19,
          });
          const goal = parseGoalText(${JSON.stringify(goalText)}, {
            operatorDefinitions: [...program.operators.values()],
          });
          let answers = 0;
          for (const _ of solver.solve([goal], new Env(), 0)) answers++;
          process.stdout.write(String(answers));
        `;
        const result = spawnSync(process.execPath, [
          '--max-old-space-size=64',
          '--input-type=module',
          '--eval',
          script,
        ], { cwd: packageRoot, encoding: 'utf8', timeout: 30000 });
        if (result.error) throw result.error;
        assertEqual(result.status, 0, `bounded-heap child status; stderr=${result.stderr}`);
        assertEqual(result.stdout, '19', 'answers through I = 28');
      },
    },
    {
      name: 'solver honors solution limits',
      run: () => {
        const program = Program.parse('p(a).\np(b).\np(c).\n');
        const solver = new Solver(program, { solutionLimit: 2 });
        const goal = parseGoalText('p(X)');
        const answers = [...solver.solve([goal], new Env(), 0)].map((env) => termToString(goal, env, true));
        assertEqual(answers.join('\n'), 'p(a)\np(b)', 'answers');
      },
    },
    {
      name: 'custom builtin registry can be embedded',
      run: () => {
        const registry = new BuiltinRegistry();
        registry.add('hello', 1, function* ({ goal, env }) {
          const next = env.clone();
          if (unify(goal.args[0], atom('world'), next)) yield next;
        });
        const program = Program.parse('answer(X) :- hello(X).\n');
        const solver = new Solver(program, { registry });
        const goal = parseGoalText('answer(X)');
        const answers = [...solver.solve([goal], new Env(), 0)].map((env) => termToString(goal, env, true));
        assertEqual(answers.join('\n'), 'answer(world)', 'answers');
      },
    },
    {
      name: 'ISO-only and EyeProlog registries expose separate metadata',
      run: () => {
        const registry = createDefaultRegistry();
        const library = getEyePrologRegistry();
        assertEqual(Boolean(registry.get('is', 2)), true, 'ISO is/2 exists');
        assertEqual(Boolean(registry.get('append', 3)), false, 'append/3 is not ISO core');
        assertEqual(library.eyePrologLibrary, true, 'complete registry marker');
        assertEqual(library.defs.size, 223, 'EyeProlog registry contains ISO definitions, cleanup controls, observability extensions, WFS predicates, and generic library adapters');
        assertEqual(registry.get('eyeprolog__dynify', 1), null, 'Eyelet dynify adapter is absent from the ISO registry');
        assertEqual(Boolean(library.get('eyeprolog__dynify', 1)), true, 'Eyelet dynify adapter is an internal EyeProlog library primitive');
        assertEqual(registry.get('eyeprolog__eyelet_emit', 2), null, 'Eyelet event adapter is absent from the ISO registry');
        assertEqual(Boolean(library.get('eyeprolog__eyelet_emit', 2)), true, 'Eyelet event adapter is an internal EyeProlog library primitive');
        assertEqual(registry.get('eyeprolog__random_value', 1), null, 'native random helper is absent from the ISO registry');
        assertEqual(Boolean(library.get('eyeprolog__random_value', 1)), true, 'native random helper is an internal EyeProlog library adapter');
        assertEqual(registry.get('eyeprolog__socket_client_open', 4), null, 'socket adapter is absent from the ISO registry');
        assertEqual(Boolean(library.get('eyeprolog__socket_client_open', 4)), true, 'socket client adapter is an internal EyeProlog library primitive');
        assertEqual(Boolean(registry.get('phrase', 2)), true, 'Part 3 phrase/2 exists');
        assertEqual(Boolean(registry.get('phrase', 3)), true, 'Part 3 phrase/3 exists');
        assertEqual(registry.get('statistics', 0), null, 'statistics/0 is absent from the ISO registry');
        assertEqual(registry.get('statistics', 2), null, 'statistics/2 is absent from the ISO registry');
        assertEqual(Boolean(library.get('statistics', 0)), true, 'statistics/0 is an EyeProlog observability extension');
        assertEqual(Boolean(library.get('statistics', 2)), true, 'statistics/2 is an EyeProlog observability extension');
        assertEqual(registry.get('tnot', 1), null, 'tnot/1 is absent from the ISO registry');
        assertEqual(Boolean(library.get('tnot', 1)), true, 'tnot/1 is an EyeProlog WFS extension');
        assertEqual(registry.get('wfs_truth', 2), null, 'wfs_truth/2 is absent from the ISO registry');
        assertEqual(Boolean(library.get('wfs_truth', 2)), true, 'wfs_truth/2 is an EyeProlog WFS extension');
        assertEqual(registry.get('time', 1), null, 'time/1 is absent from the ISO registry');
        assertEqual(Boolean(library.get('time', 1)), true, 'time/1 is an EyeProlog timing extension');
        assertEqual(registry.get('dif', 2), null, 'dif/2 is absent from the strict ISO core registry');
        assertEqual(Boolean(library.get('dif', 2)), true, 'dif/2 is an EyeProlog attributed-variable constraint extension');
        assertEqual(registry.get('call_cleanup', 2), null, 'call_cleanup/2 is absent from the ISO registry');
        assertEqual(Boolean(library.get('call_cleanup', 2)), true, 'call_cleanup/2 is an EyeProlog cleanup control');
        assertEqual(registry.get('setup_call_cleanup', 3), null, 'setup_call_cleanup/3 is absent from the ISO registry');
        assertEqual(Boolean(library.get('setup_call_cleanup', 3)), true, 'setup_call_cleanup/3 is an EyeProlog cleanup control');
        assertEqual(registeredNativeEyePrologLibraryNames().length, 122, 'public host-supported EyeProlog library count');
        assertEqual(eyePrologPortableLibraryIndicators.length, 281, 'portable Prolog library count');
        assertEqual(eyePrologInteropLibraryIndicators.length, 221, 'cross-implementation interop profile count');
        assertEqual(eyePrologInteropLibraryModules.length, 27, 'common explicit library module profile count');
        assertEqual(eyePrologInteropAutoload['member/2'], 'lists', 'member/2 canonical autoload');
        assertEqual(eyePrologInteropAutoload['between/3'], 'between', 'between/3 canonical internal autoload');
        assertEqual(eyePrologInteropAutoload['call_nth/2'], 'iso_ext', 'call_nth/2 canonical interop autoload');
        assertEqual(eyePrologInteropAutoload['call_residue_vars/2'], 'atts', 'call_residue_vars/2 canonical interop autoload');
        assertEqual(eyePrologInteropAutoload['time/1'], 'iso_ext', 'time/1 canonical interop autoload');
        assertEqual(eyePrologInteropAutoload['.../2'], 'dcgs', '.../2 canonical interop autoload');
        assertEqual(eyePrologInteropAutoload['set_nth0/4'] ?? null, null, 'set_nth0/4 is outside the conservative interop subset');
        assertEqual(eyePrologLibraryAutoload['set_nth0/4'], 'lists', 'complete library autoload includes EyeProlog-only exports');
        assertEqual(eyePrologLibraryAutoload['pairs_keys_values/3'], 'pairs', 'complete library autoload includes library(pairs)');
        assertEqual(eyePrologLibraryAutoload['stable/1'], 'eyelet', 'complete library autoload includes Eyelet stable/1');
        assertEqual(eyePrologLibraryAutoload['becomes/2'], 'eyelet', 'complete library autoload includes Eyelet becomes/2');
        assertEqual(eyePrologLibraryAutoloadModules.length, 42, 'all bundled src/lib modules are indexed for autoload');
        assertEqual(eyePrologNativeLibraryIndicators.length, 122, 'host-supported library count');
        assertEqual(eyePrologNativeLibraryIndicators.includes('call_nth/2'), true, 'call_nth/2 remains classified as host-supported');
        assertEqual(eyePrologNativeLibraryIndicators.includes('random/1'), true, 'stateful random/1 is classified as host-supported');
        assertEqual(eyePrologLibraryIndicators.length, 403, 'complete non-ISO EyeProlog library surface');
        assertEqual(registry.get('eyeprolog__call_nth', 2), null, 'private call_nth adapter is absent from ISO registry');
        assertEqual(Boolean(library.get('eyeprolog__call_nth', 2)), true, 'private call_nth adapter is registered for EyeProlog');
        assertEqual(Boolean(library.get('eyeprolog__call_residue_vars', 2)), true, 'private call_residue_vars adapter is registered for EyeProlog');
        assertEqual(library.get('eyeprolog__call_nth', 2)?.eyePrologLibrary, true, 'private adapter is marked as library support');
        assertEqual(library.get('eyeprolog__freeze', 2), null, 'freeze/2 no longer needs a private host adapter');
        assertEqual(eyePrologPortableLibraryIndicators.includes('freeze/2'), true, 'freeze/2 is implemented in Prolog');
        assertEqual(registry.get('eyeprolog__countall', 2), null, 'private countall adapter is absent from ISO registry');
        assertEqual(Boolean(library.get('eyeprolog__countall', 2)), true, 'private countall adapter is registered for EyeProlog');
        assertEqual(Boolean(library.get('eyeprolog__time', 1)), true, 'private time adapter is registered for EyeProlog');
        assertEqual(library.get('eyeprolog__clpz_labeling', 2), null, 'CLP(Z) labeling is implemented in Prolog');
        assertEqual(library.get('eyeprolog__clpz_global_cardinality', 3), null, 'CLP(Z) cardinality is implemented in Prolog');
        assertEqual(registry.get('put_atts', 2), null, 'put_atts/2 is absent from the ISO registry');
        assertEqual(Boolean(library.get('put_atts', 2)), true, 'put_atts/2 is registered for attributed-variable libraries');
        assertEqual(Boolean(library.get('$put_to_attr_list', 3)), true, 'private attribute-list adapter is registered');
        assertEqual(Boolean(library.get('eyeprolog__bb_get', 2)), true, 'private backtrackable blackboard reader is registered');
        assertEqual(Boolean(library.get('eyeprolog__bb_b_put', 2)), true, 'private backtrackable blackboard writer is registered');
        assertEqual(library.get('between', 3), null, 'between/3 remains portable Prolog');
        assertEqual(library.get('smallest_divisor_from', 3), null, 'smallest_divisor_from/3 remains portable Prolog');
        assertEqual(library.get('random', 3), null, 'random/3 remains portable Prolog');
        assertEqual(library.get('local_time', 1), null, 'local_time/1 is not a host builtin');
        assertEqual(library.get('eyeprolog__string_atom', 2), null, 'private string adapter is absent');
        assertEqual(library.get('append', 3), null, 'append/3 moved to portable Prolog');
        assertEqual(library.get('maplist', 3), null, 'maplist/3 moved to portable Prolog');
        assertEqual(library.get('matches', 3), null, 'matches/3 moved to portable Prolog');
        assertEqual(library.get('uuid', 3), null, 'uuid/3 remains portable Prolog');
        for (const [name, arity] of [['not_member', 2], ['head', 2], ['rest', 2], ['min', 3], ['max', 3]]) {
          assertEqual(library.get(name, arity), null, `${name}/${arity} removed from library`);
        }
      },
    },
    {
      name: 'module compatibility libraries load Prolog clauses explicitly',
      run: () => {
        const program = Program.parse(':- use_module(library(lists)).\n:- use_module(library(random)).\nanswer(X) :- append([a], [b], X).');
        const solver = new Solver(program);
        assertEqual(solver.program, program, 'solver keeps original program object');
        assertEqual(program.findGroup('append', 3)?.module, 'lists', 'append/3 is imported from library(lists)');
        assertEqual(fs.existsSync(path.join(packageRoot, 'src', 'lib', 'eyeprolog.pl')), false, 'obsolete umbrella module is absent');
        assertEqual(fs.existsSync(path.join(packageRoot, 'src', 'standard-library.js')), true, 'standard module registry exists');
        assertEqual(fs.existsSync(path.join(packageRoot, 'src', 'lib', 'aggregate.pl')), true, 'aggregate module exists');
        assertEqual(fs.existsSync(path.join(packageRoot, 'src', 'lib', 'clpz.pl')), true, 'CLP(Z) module exists');
        assertEqual(fs.existsSync(path.join(packageRoot, 'src', 'lib', 'iso_ext.pl')), true, 'ISO extension module exists');
        assertEqual(fs.existsSync(path.join(packageRoot, 'src', 'lib', 'lists.pl')), true, 'lists module exists');
        assertEqual(fs.existsSync(path.join(packageRoot, 'src', 'lib', 'prologue.pl')), true, 'Prologue module exists');
        assertEqual(fs.existsSync(path.join(packageRoot, 'src', 'lib', 'strings.pl')), true, 'strings module exists');
        assertEqual(fs.existsSync(path.join(packageRoot, 'src', 'eyeprolog-autoload.js')), false, 'obsolete autoloader is absent');
        assertEqual(fs.existsSync(path.join(packageRoot, 'src', 'library-source.js')), false, 'duplicate source loader is absent');
        assertEqual(fs.existsSync(path.join(packageRoot, 'src', 'portable-library.js')), false, 'obsolete duplicate module remains absent');
        assertEqual(run(program, { goal: 'answer(X)' }).stdout, 'answer("ab").\n', 'imported append execution');
        assertEqual(program.findGroup('random', 3)?.module, 'random', 'random/3 is imported from library(random)');
      },
    },
    {
      name: 'Trealla library overlap predicates execute with EyeProlog semantics',
      run: () => {
        const program = Program.parse(`
:- use_module(library(aggregate)).
:- use_module(library(error)).
:- use_module(library(freeze)).
:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(tabling)).

positive(X) :- X > 0.
inc(X, Y) :- Y is X + 1.

:- dynamic(edge/2).
:- table(path/2).
path(X, Y) :- edge(X, Y).
path(X, Z) :- edge(X, Y), path(Y, Z).

trealla_overlap_probe :-
    aggregate_all(count, member(_, [a,b,c]), 3),
    aggregate_all(sum(X), member(X, [1,2,3]), 6),
    aggregate_all(bag(X), member(X, [a,b]), [a,b]),
    aggregate_all(set(X), member(X, [b,a,b]), [a,b]),
    aggregate(sum(X), member(K-X, [a-1,a-2,b-3]), 3), K = a,
    aggregate(sum(Y), J^member(J-Y, [a-1,a-2,b-3]), 6),
    selectchk(b, [a,b,c], [a,c]),
    subtract([a,b,a,c], [a], [b,c]),
    union([a,b], [b,c], [a,b,c]),
    intersection([a,b,c], [b,d,c], [b,c]),
    is_set([a,b,c]), \\+ is_set([a,a]),
    include(positive, [-1,2,0,3], [2,3]),
    exclude(positive, [-1,2,0,3], [-1,0]),
    tasklist(inc, [1,2,3], [2,3,4]),
    maybe(1.0), maybe(1, 1),
    freeze(F, true), frozen(F, Frozen), Frozen \\== true, F = ready,
    catch(resource_error(memory, context), error(resource_error(memory), context), true),
    assertz(edge(a,b)), path(a,b),
    retract(edge(a,b)), assertz(edge(a,c)),
    abolish_table(path/2), \\+ path(a,b), path(a,c),
    catch(abolish_table(missing/1), error(existence_error(table, missing/1), abolish_table/1), true).
`);
        assertEqual(run(program, { goal: 'trealla_overlap_probe' }).stdout, 'trealla_overlap_probe.\n', 'Trealla overlap execution');
      },
    },
    {
      name: 'Prologue facade re-exports canonical library predicates without conflicts',
      run: () => {
        const sources = [
          ':- use_module(library(freeze)).\n:- use_module(library(lists)).\n:- use_module(library(iso_ext)).\n:- use_module(library(prologue)).',
          ':- use_module(library(prologue)).\n:- use_module(library(freeze)).\n:- use_module(library(lists)).\n:- use_module(library(iso_ext)).',
        ];
        for (const source of sources) {
          const program = Program.parse(source);
          assertEqual(program.findGroup('freeze', 2)?.module, 'freeze', 'freeze/2 canonical owner');
          assertEqual(program.findGroup('member', 2)?.module, 'lists', 'member/2 canonical owner');
          assertEqual(program.findGroup('call_nth', 2)?.module, 'iso_ext', 'call_nth/2 canonical owner');
          assertEqual(program.findGroup('between', 3)?.module, 'between', 'between/3 canonical owner');
        }

        const conflicting = new Program();
        conflicting.defineModule('first', [{ name: 'shared', arity: 1 }]);
        conflicting.defineModule('second', [{ name: 'shared', arity: 1 }]);
        conflicting.importModule('user', 'first');
        let conflict = null;
        try {
          conflicting.importModule('user', 'second');
        } catch (error) {
          conflict = error;
        }
        assertEqual(conflict?.formal, 'permission_error(import, procedure)', 'distinct implementations still conflict');
      },
    },
    {
      name: 'aligned bundled libraries have no conflicting full-module exports',
      run: () => {
        const owners = new Map();
        for (const [moduleName, entry] of standardLibrarySources) {
          // library(prologue) is an umbrella facade. Other aligned modules may
          // intentionally re-export a canonical predicate (for example
          // iso_ext:copy_term_nat/2 -> terms and time:time/1 -> iso_ext), but
          // two distinct implementations must never claim the same indicator.
          if (moduleName === 'prologue') continue;
          const parsed = Program.parse(entry.source);
          const definition = parsed.modules.get(moduleName);
          if (!definition) throw new Error(`missing module declaration for ${moduleName}`);
          for (const indicator of definition.exports.keys()) {
            const slash = indicator.lastIndexOf('/');
            const name = indicator.slice(0, slash);
            const arity = Number(indicator.slice(slash + 1));
            const canonical = parsed.findGroup(name, arity, moduleName)?.module ?? moduleName;
            const previous = owners.get(indicator);
            if (previous != null && previous !== canonical) {
              throw new Error(`conflicting export ${indicator}: ${previous}, ${canonical} via ${moduleName}`);
            }
            owners.set(indicator, canonical);
          }
        }
        assertEqual(owners.get('countall/2'), 'iso_ext', 'countall/2 has one aligned owner');
        assertEqual(owners.get('call_nth/2'), 'iso_ext', 'call_nth/2 has one aligned owner');
        assertEqual(owners.get('call_residue_vars/2'), 'atts', 'iso_ext re-exports canonical atts call_residue_vars/2');
        assertEqual(owners.get('copy_term_nat/2'), 'terms', 'iso_ext re-exports canonical terms copy_term_nat/2');
        assertEqual(owners.get('time/1'), 'iso_ext', 'time re-exports canonical iso_ext time/1');
      },
    },
    {
      name: 'portable library executes against the ISO-only registry',
      run: () => {
        const program = Program.parse(`:- use_module(library(strings)).
:- use_module(library(uuid)).
:- use_module(library(lists)).
portable_check(A, B, C) :- lowercase('HELLO', A), replace('banana', 'na', 'NA', B), append([x], [y], C).
`);
        const solver = new Solver(program, { registry: createDefaultRegistry() });
        const goal = parseGoalText('portable_check(A, B, C)');
        const answers = [...solver.solve([goal], new Env(), 0)].map((env) => termToString(goal, env, true));
        assertEqual(answers.join('\n'), 'portable_check(hello, baNANA, "xy")', 'ISO-only portable execution');
        assertEqual(Boolean(program.findGroup('uuid', 3)), true, 'uuid/3 is implemented in the portable module');
        assertEqual(program.findGroup('uuid', 1), null, 'obsolete uuid/1 is absent');
        assertEqual(program.findGroup('local_time', 1), null, 'local_time/1 is absent from the library');
      },
    },
    {
      name: 'countall validates Count before executing Goal and counts without a bag',
      run: () => {
        const source = `:- use_module(library(prologue)).
item(a).
item(b).
item(c).
candidate :- item(_).
`;
        let caught = null;
        try {
          run(source, { goal: 'countall(throw(x), -1)' });
        } catch (error) {
          caught = error;
        }
        assertEqual(caught?.formal, 'domain_error(not_less_than_zero)', 'negative Count error priority');
        assertEqual(run(source, { goal: 'countall(candidate, N)' }).stdout, 'countall(candidate, 3).\n', 'solution count');
      },
    },
    {
      name: 'ISO extension module provides portable control and collection relations',
      run: () => {
        const program = Program.parse(`:- use_module(library(iso_ext)).
item(a).
item(b).
answer(Count, Bag, Pairs, Same) :-
  forall(item(X), atom(X)),
  countall(item(_), Count),
  findall(X, item(X), Bag, [tail]),
  findall(N-S, (cfor(1, 2, N), succ(N, S)), Pairs),
  variant(node(A, A), node(B, B)),
  Same = true.
`);
        assertEqual(program.findGroup('forall', 2)?.module, 'iso_ext', 'forall/2 module');
        assertEqual(program.findGroup('findall', 4)?.module, 'iso_ext', 'findall/4 module');
        assertEqual(run(program, { goal: 'answer(Count, Bag, Pairs, Same)' }).stdout,
          'answer(2, [a, b, tail], [1 - 2, 2 - 3], true).\n', 'ISO extension answer');
      },
    },
    {
      name: 'CLP(Z) module keeps finite constraints logical through labeling',
      run: () => {
        const program = Program.parse(`:- use_module(library(clpz)).
answer(X, Y, B) :-
  [X, Y] ins 1..4,
  X + Y #= 5,
  X #< Y,
  all_distinct([X, Y]),
  chain(#<, [X, Y]),
  B in 0..1,
  B #<==> X #= 1,
  labeling([ff, down], [X, Y, B]).
contradiction :- Z in 1..3, Z = 4.
pruned(Domain) :- [X, Y] ins 1..3, all_distinct([X, Y]), X #= 2, fd_dom(Y, Domain).
hall(Domain) :- [X, Y] ins 1..2, Z in 1..3, all_distinct([X, Y, Z]), fd_dom(Z, Domain).
repeated(X) :- X in 1..3, all_distinct([X, X]).
`);
        assertEqual(program.findGroup('labeling', 2)?.module, 'clpz', 'labeling/2 module');
        assertEqual(run(program, { goals: ['answer(X, Y, B)', 'contradiction', 'pruned(Domain)', 'hall(Domain)', 'repeated(X)'] }).stdout,
          'answer(1, 4, 1).\nanswer(2, 3, 0).\npruned(1 \\/ 3).\nhall(3..3).\n', 'CLP(Z) constrained answers');
      },
    },
    {
      name: 'CLP(Z) finite global constraints match the portable example',
      run: () => {
        const filename = path.join(packageRoot, 'examples', 'clpz-global-constraints.pl');
        const source = fs.readFileSync(filename, 'utf8');
        const program = Program.parseSources([{ text: source, filename }]);
        assertEqual(program.findGroup('tuples_in', 2)?.module, 'clpz', 'tuples_in/2 module');
        assertEqual(program.findGroup('global_cardinality', 3)?.module, 'clpz', 'global_cardinality/3 module');
        assertEqual(program.findGroup('circuit', 1)?.module, 'clpz', 'circuit/1 module');
        const expected = fs.readFileSync(path.join(packageRoot, 'examples', 'output', 'clpz-global-constraints.pl'), 'utf8');
        assertEqual(run(program, { goal: 'advanced_clpz(X0, X1)' }).stdout, expected, 'global constraint answers');
      },
    },
    {
      name: 'module compatibility profile isolates predicates and supports selective imports',
      run: () => {
        const directory = path.join(tmp, `modules-${++tmpCounter}`);
        fs.mkdirSync(directory);
        fs.writeFileSync(path.join(directory, 'colors.pl'), [
          ':- module(colors, [tone/1]).',
          'tone(blue).',
          'hidden(module_private).',
          '',
        ].join('\n'));
        const source = [
          ":- use_module('colors.pl', [tone/1]).",
          'hidden(user_local).',
          'answer(Tone, Hidden) :- tone(Tone), hidden(Hidden).',
          'qualified(ok) :- colors:tone(blue).',
          '',
        ].join('\n');
        const program = Program.parseSources([{ text: source, filename: 'main.pl', baseDir: directory }]);
        assertEqual(program.findGroup('tone', 1)?.module, 'colors', 'selective import resolves exported predicate');
        assertEqual(program.findGroup('hidden', 1)?.module, 'user', 'same-named user predicate remains local');
        assertEqual(run(program, { goals: ['answer(Tone, Hidden)', 'qualified(Status)'] }).stdout,
          'answer(blue, user_local).\nqualified(ok).\n', 'module execution');
      },
    },
    {
      name: 'Part 3 nonterminal indicators import through module compatibility profile',
      run: () => {
        const directory = path.join(tmp, `dcg-modules-${++tmpCounter}`);
        fs.mkdirSync(directory);
        fs.writeFileSync(path.join(directory, 'vocabulary.pl'), [
          ':- module(vocabulary, [word//1]).',
          'word(hello) --> [hello].',
          '',
        ].join('\n'));
        const source = [
          ":- use_module('vocabulary.pl', [word//1]).",
          'answer(X) :- phrase(word(X), [hello]).',
          '',
        ].join('\n');
        const program = Program.parseSources([{ text: source, filename: 'main.pl', baseDir: directory }]);
        assertEqual(program.findGroup('word', 3)?.module, 'vocabulary', 'word//1 imports expanded word/3');
        assertEqual(run(program, { goal: 'answer(X)' }).stdout, 'answer(hello).\n', 'imported grammar execution');
      },
    },
    {
      name: 'EyeProlog library preserves relational and arithmetic behavior',
      run: () => {
        const result = run([
          '%% goal: answer(A, B, S, M)',
          'answer(A, B, S, M) :-',
          '  append(A, B, [a, b]),',
          '  sumall(X + 1, member(X, [1, 2]), S),',
          '  (9007199254740992 >= 9007199254740993 -> M = 9007199254740992 ; M = 9007199254740993).',
          '',
        ].join('\n'));
        assertEqual(result.stdout, [
          'answer([], "ab", 5, 9007199254740993).',
          'answer("a", "b", 5, 9007199254740993).',
          'answer("ab", [], 5, 9007199254740993).',
          '',
        ].join('\n'), 'EyeProlog library behavior');
      },
    },
    {
      name: 'EyeProlog library preserves strict modes and ISO arithmetic errors',
      run: () => {
        assertEqual(run("answer(X) :- substring('abc', '1', 1, X).", { goal: 'answer(X)' }).stdout, '', 'substring index type');
        assertEqual(run('answer(N) :- nth1(N, [a, b], _).', { goal: 'answer(N)' }).stdout, 'answer(1).\nanswer(2).\n', 'nth1 relational enumeration');
        let sumError = null;
        try { run('answer(S) :- sum_list([1, foo], S).', { goal: 'answer(S)' }); } catch (error) { sumError = error; }
        assertIncludes(sumError?.message ?? '', 'type_error(evaluable)', 'sum_list arithmetic error');
      },
    },
  ];
}

function whiteBoxCases() {
  return [
    {
      name: 'unification binds variables in Env',
      run: () => {
        const env = new Env();
        assertEqual(unify(variable('X'), atom('socrates'), env), true, 'unify result');
        assertEqual(termToString(variable('X'), env, true), 'socrates', 'binding');
      },
    },
    {
      name: 'variable term order is scoped to one comparison or sorted-list operation',
      run: () => {
        const left = variable('Left');
        const right = variable('Right');
        assertEqual(String(left.order), 'undefined', 'variables carry no persistent order ordinal');
        assertEqual(String(right.order), 'undefined', 'second variable carries no persistent order ordinal');

        // Separate comparisons are permitted to choose their own
        // implementation-dependent order under ISO 7.2.1.
        assertEqual(String(compareTerms(left, right)), '-1', 'first local comparison');
        assertEqual(String(compareTerms(right, left)), '-1', 'second local comparison is independent');

        // A sorted-list operation instead supplies one shared ranking context,
        // so all comparisons made while constructing that list are consistent.
        const ranks = new Map();
        assertEqual(String(compareTerms(left, right, ranks)), '-1', 'shared order first direction');
        assertEqual(String(compareTerms(right, left, ranks)), '1', 'shared order reverse direction');
      },
    },
    {
      name: 'numeric identity and term order handle noncanonical unbounded integers without host BigInts',
      run: () => {
        const env = new Env();
        assertEqual(unify(numberTerm('000123'), numberTerm('123'), env), true, 'leading-zero integer identity');
        assertEqual(unify(numberTerm('-000'), numberTerm('0'), env), true, 'negative-zero integer identity');
        assertEqual(compareTerms(numberTerm('99999999999999999999999999999999999999'),
          numberTerm('100000000000000000000000000000000000000')), -1, 'large positive integer order');
        assertEqual(compareTerms(numberTerm('-100000000000000000000000000000000000000'),
          numberTerm('-99999999999999999999999999999999999999')), -1, 'large negative integer order');
        assertEqual(publicApi.compareIntegerText('+1', '1'), 0, 'public helper retains host BigInt spelling compatibility');
        let invalidIntegerError = null;
        try { publicApi.compareIntegerText('not-an-integer', '1'); } catch (error) { invalidIntegerError = error; }
        assertEqual(invalidIntegerError?.name, 'SyntaxError', 'public helper retains invalid-spelling error');
      },
    },
    {
      name: 'character term order compares Unicode scalar values without materializing code-point arrays',
      run: () => {
        assertEqual(compareTerms(atom('a😀'), atom('a😁')), -1, 'supplementary scalar order');
        assertEqual(compareTerms(atom('a😀'), atom('a😀x')), -1, 'supplementary prefix order');
        assertEqual(compareTerms(atom('a😀x'), atom('a😀')), 1, 'supplementary reverse prefix order');
      },
    },
    {
      name: 'unification rejects direct and indirect cyclic bindings',
      run: () => {
        const direct = new Env();
        assertEqual(
          unify(variable('X'), compound('wrapper', [variable('X')]), direct),
          false,
          'direct cycle',
        );
        assertEqual(direct.has('X'), false, 'failed direct binding is not installed');

        const indirect = new Env();
        indirect.bind('Y', compound('wrapper', [variable('X')]));
        assertEqual(unify(variable('X'), variable('Y'), indirect), false, 'indirect cycle');
        assertEqual(indirect.has('X'), false, 'failed indirect binding is not installed');
      },
    },
    {
      name: 'cloned environments detach on first write',
      run: () => {
        const parent = new Env();
        parent.bind('Shared', atom('before'));
        const left = parent.clone();
        const right = parent.clone();
        left.bind('Left', atom('only_left'));
        right.bind('Right', atom('only_right'));
        parent.bind('Parent', atom('only_parent'));
        assertEqual(left.get('Shared').name, 'before', 'left keeps shared binding');
        assertEqual(left.has('Right'), false, 'left excludes right write');
        assertEqual(left.has('Parent'), false, 'left excludes parent write');
        assertEqual(right.has('Left'), false, 'right excludes left write');
        assertEqual(parent.has('Left'), false, 'parent excludes child write');
      },
    },
    {
      name: 'deep environment chains flatten without losing bindings',
      run: () => {
        const env = new Env();
        for (let i = 0; i < 40; i++) env.bind(`V${i}`, numberTerm(i));
        assertEqual(env.get('V0').name, '0', 'oldest binding');
        assertEqual(env.get('V31').name, '31', 'binding before flatten');
        assertEqual(env.get('V39').name, '39', 'latest binding');
        assertEqual(env.has('missing'), false, 'missing binding');
        assertEqual(env.has('missing'), false, 'cached missing binding');

        const clone = env.clone();
        clone.bind('OnlyClone', atom('yes'));
        clone.bind('missing', atom('now_present'));
        assertEqual(clone.get('OnlyClone').name, 'yes', 'clone write');
        assertEqual(clone.get('missing').name, 'now_present', 'clone write supersedes cached miss');
        assertEqual(env.has('OnlyClone'), false, 'clone remains isolated');
        assertEqual(env.has('missing'), false, 'parent retains cached miss');
      },
    },
    {
      name: 'copyResolved and termIsGround follow bindings',
      run: () => {
        const env = new Env();
        const term = compound('p', [variable('X'), atom('b')]);
        assertEqual(termIsGround(term, env), false, 'not ground before binding');
        assertEqual(unify(variable('X'), atom('a'), env), true, 'bind X');
        const resolved = copyResolved(term, env);
        assertEqual(termToString(resolved, new Env(), true), 'p(a, b)', 'resolved term');
        assertEqual(termIsGround(resolved), true, 'ground after copy');
      },
    },

    {
      name: 'parser accepts ISO infix subtraction terms',
      run: () => {
        const [clause] = parseProgramText('value(a-b, ok).\n');
        assertEqual(termToString(clause.head.args[0]), "'-'(a, b)", 'a-b term');
      },
    },
    {
      name: 'parser rejects zero-arity compound syntax',
      run: () => {
        let threw = false;
        try { parseProgramText('value(nil(), ok).\n'); } catch (_) { threw = true; }
        assertEqual(threw, true, 'zero-arity compound rejection');
      },
    },
    {
      name: 'parser preserves list syntax readback',
      run: () => {
        const goal = parseGoalText('member(X, [a, b])');
        assertEqual(termToString(goal, new Env(), true), 'member(X, "ab")', 'goal');
      },
    },
    {
      name: 'double-quoted lists honor every ISO double_quotes value',
      run: () => {
        const chars = parseGoalText('p("aλ")').args[0];
        const charItems = properListItems(chars, new Env());
        assertEqual(charItems.map((item) => `${item.type}:${item.name}`).join('|'), 'atom:a|atom:λ', 'chars');

        const codes = parseGoalText('p("aλ")', { doubleQuotes: 'codes' }).args[0];
        const codeItems = properListItems(codes, new Env());
        assertEqual(codeItems.map((item) => `${item.type}:${item.name}`).join('|'), 'number:97|number:955', 'codes');

        const quotedAtom = parseGoalText('p("aλ")', { doubleQuotes: 'atom' }).args[0];
        assertEqual(`${quotedAtom.type}:${quotedAtom.name}`, 'atom:aλ', 'atom');
      },
    },
    {
      name: 'double-bar syntax splices double-quoted list prefixes (issue #88)',
      run: () => {
        const chars = parseGoalText('p("ab"||Tail)').args[0];
        assertEqual(chars.args[0].name, 'a', 'chars first element');
        assertEqual(chars.args[1].args[0].name, 'b', 'chars second element');
        assertEqual(chars.args[1].args[1].type, 'var', 'chars partial tail type');
        assertEqual(chars.args[1].args[1].name, 'Tail', 'chars partial tail name');
        assertEqual(termToString(chars, new Env(), true, { doubleBar: true }), '"ab"||Tail', 'chars readback');

        const codes = parseGoalText('p("aλ" || Tail)', { doubleQuotes: 'codes' }).args[0];
        assertEqual(codes.args[0].name, '97', 'codes first element');
        assertEqual(codes.args[1].args[0].name, '955', 'codes second element');
        assertEqual(termToString(codes, new Env(), true, { doubleQuotes: 'codes', doubleBar: true }), '"aλ"||Tail', 'codes readback');

        const nested = parseGoalText('p(["ab"|Tail])');
        assertEqual(termToString(nested), 'p(["ab" | Tail])', 'single bar remains list syntax');

        for (const options of [{ isoStrict: true }, { doubleQuotes: 'atom' }]) {
          let threw = false;
          try { parseGoalText('p("ab"||Tail)', options); } catch (_) { threw = true; }
          assertEqual(threw, true, `double-bar rejected for ${JSON.stringify(options)}`);
        }
      },
    },
    {
      name: 'normal integer syntax accepts WG17 digit separators (issue #89)',
      run: () => {
        const values = parseGoalText(`values(
          1_000,
          0b1010_0101,
          0o7_ 7,
          0xCA_/* digit group */FE,
          -9_% line group
          223
        )`).args;
        assertEqual(values.map((value) => value.name).join(','), '1000,165,63,51966,-9223',
          'decimal and radix separator values');
        const program = Program.parse('decimal(1_000).\nhexadecimal(0xCA_FE).\n');
        assertEqual(program.findGroup('decimal', 1)?.clauses[0].head.args[0].name, '1000',
          'program decimal literal');
        assertEqual(program.findGroup('hexadecimal', 1)?.clauses[0].head.args[0].name, '51966',
          'program radix literal');
        assertEqual(parseNumberTokenText('1_ /* group */ 000').name, '1000',
          'number-token conversion with layout');
        assertEqual(parseNumberTokenText('0b1010_0101').name, '165', 'binary number-token conversion');
        assertEqual(parseNumberTokenText('0o7_% group\n7').name, '63', 'octal number-token conversion with line comment');
        assertEqual(parseNumberTokenText('0xCA_/* group */FE').name, '51966', 'hex number-token conversion with block comment');
        assertEqual(
          run('', { goal: 'number_chars(N,"1_000")' }).stdout,
          'number_chars(1000, "1_000").\n',
          'normal number_chars input',
        );
        assertEqual(
          run('', { goal: 'number_codes(N,[48,120,67,65,95,70,69])' }).stdout,
          'number_codes(51966, [48, 120, 67, 65, 95, 70, 69]).\n',
          'normal number_codes radix input',
        );
        assertEqual(
          run('', { goal: 'read_term(N, [])', ioOptions: { input: '1_ /* group */ 000. ' } }).stdout,
          'read_term(1000, []).\n',
          'stream term input',
        );

        for (const source of ['1__000', '1_', '1_a', '0b1_2', '1_1.25', '1.2_5', '1.0e1_0']) {
          let threw = false;
          try { parseGoalText(`p(${source})`); } catch (_) { threw = true; }
          assertEqual(threw, true, `malformed or non-integer separator rejected: ${source}`);
        }

        for (const source of ['1_000', '0b1010_0101', '0o7_7', '0xCA_FE']) {
          let threw = false;
          try { parseGoalText(`p(${source})`, { isoStrict: true }); } catch (_) { threw = true; }
          assertEqual(threw, true, `strict syntax rejects ${source}`);
        }
        let strictConversion = null;
        try { run('', { isoStrict: true, goal: 'number_chars(N,"1_000")' }); }
        catch (error) { strictConversion = error; }
        assertEqual(strictConversion?.formal, 'syntax_error(number)', 'strict number_chars rejection');
      },
    },
    {
      name: 'double_quotes(true) remains effective with ignore_ops(true) in either option order (issue #88 follow-up)',
      run: () => {
        const source = [
          'emit :-',
          `  write_term(f("ab",a+b), [double_quotes(true),ignore_ops(true),quoted(true)]), put_char('|'),`,
          `  write_term(f("ab",a+b), [ignore_ops(true),double_quotes(true),quoted(true)]), put_char('|'),`,
          `  write_term("ab"||tail, [double_quotes(true),ignore_ops(true)]), put_char('|'),`,
          `  write_term("ab"||tail, [ignore_ops(true),double_quotes(true)]), put_char('|'),`,
          '  write_term("ab", [double_quotes(false),ignore_ops(true)]).',
          '',
        ].join('\n');
        assertEqual(
          run(source, { goal: 'emit' }).stdout,
          'f("ab",+(a,b))|f("ab",+(a,b))|"ab"||tail|"ab"||tail|.(a,.(b,[]))emit.\n',
          'write_term option composition',
        );

        const codesSource = [
          'emit_codes :-',
          '  set_prolog_flag(double_quotes, codes),',
          '  write_term([97,955], [ignore_ops(true),double_quotes(true)]).',
          '',
        ].join('\n');
        assertEqual(run(codesSource, { goal: 'emit_codes' }).stdout, '"aλ"emit_codes.\n',
          'double_quotes(codes) representation');
      },
    },
    {
      name: 'double-quoted character and code suffixes are recognized inside proper lists (issue #88 suffix follow-up)',
      run: () => {
        const repl = runCli([], {
          input: 'T = [A,b,c,d,e,f].\nhalt.\n',
        });
        assertEqual(repl.status, 0, 'REPL exit status');
        assertIncludes(repl.stdout, 'T = [A|"bcdef"].', 'Scryer-compatible character suffix');
        assertNotIncludes(repl.stdout, 'T = [A, b, c, d, e, f].', 'expanded suffix suppressed');

        const chars = parseGoalText('p([foo,b,c])').args[0];
        assertEqual(
          formatTermForWrite(chars, new Env(), {
            quoted: true,
            doubleQuotes: 'chars',
            doubleBar: true,
            compact: true,
            operators: ISO_OPERATOR_DEFINITIONS,
          }),
          '[foo|"bc"]',
          'ordinary list notation uses a quoted suffix',
        );
        assertEqual(
          formatTermForWrite(chars, new Env(), {
            quoted: true,
            ignoreOps: true,
            doubleQuotes: 'chars',
            doubleBar: true,
            compact: true,
            operators: ISO_OPERATOR_DEFINITIONS,
          }),
          `'.'(foo,"bc")`,
          'ignore_ops remains orthogonal to suffix quoting',
        );
        assertEqual(
          formatTermForWrite(chars, new Env(), {
            quoted: true,
            doubleQuotes: null,
            doubleBar: true,
            compact: true,
            operators: ISO_OPERATOR_DEFINITIONS,
          }),
          '[foo,b,c]',
          'disabled double_quotes keeps expanded list notation',
        );
        const improper = parseGoalText('p([foo,b,c|tail])').args[0];
        assertEqual(
          formatTermForWrite(improper, new Env(), {
            quoted: true,
            doubleQuotes: 'chars',
            doubleBar: true,
            compact: true,
            operators: ISO_OPERATOR_DEFINITIONS,
          }),
          '[foo,b,c|tail]',
          'improper suffix is not mistaken for a proper string suffix',
        );

        const astral = parseGoalText("p([foo,'😀',x])").args[0];
        assertEqual(
          formatTermForWrite(astral, new Env(), {
            quoted: true,
            doubleQuotes: 'chars',
            doubleBar: true,
            compact: true,
            operators: ISO_OPERATOR_DEFINITIONS,
          }),
          '[foo|"😀x"]',
          'Unicode scalar suffix',
        );

        const codes = parseGoalText('p([foo,98,128512])', { doubleQuotes: 'codes' }).args[0];
        assertEqual(
          formatTermForWrite(codes, new Env(), {
            quoted: true,
            doubleQuotes: 'codes',
            doubleBar: true,
            compact: true,
            operators: ISO_OPERATOR_DEFINITIONS,
          }),
          '[foo|"b😀"]',
          'code-list suffix',
        );
      },
    },

    {
      name: 'charsio write_term_to_chars composes double_quotes with ignore_ops',
      run: () => {
        const source = [
          ':- use_module(library(charsio)).',
          'answer(A,B) :-',
          '  write_term_to_chars(f("ab",a+b), [double_quotes(true),ignore_ops(true)], A),',
          '  write_term_to_chars("ab"||tail, [ignore_ops(true),double_quotes(true)], B).',
          '',
        ].join('\n');
        assertEqual(
          run(source, { goal: 'answer(A,B)' }).stdout,
          'answer("f(\\"ab\\",+(a,b))", "\\"ab\\"||tail").\n',
          'charsio output',
        );
      },
    },
    {
      name: 'REPL prints partial character lists with double-bar syntax (issue #88)',
      run: () => {
        const result = runCli([], {
          input: 'phrase("Think of this text, and much more.", S0,S).\nhalt.\n',
        });
        assertEqual(result.status, 0, 'REPL exit status');
        assertIncludes(result.stdout,
          'S0 = "Think of this text, and much more."||S.',
          'Trealla-compatible partial string answer');
        assertNotIncludes(result.stdout, "S0 = ['T'", 'legacy expanded list answer');
      },
    },
    {
      name: 'double_quotes directives affect subsequent source text',
      run: () => {
        const clauses = parseProgramText([
          'chars("a").',
          ':- set_prolog_flag(double_quotes, codes).',
          'codes("a").',
          ':- set_prolog_flag(double_quotes, atom).',
          'quoted_atom("a").',
          '',
        ].join('\n'), { sourceMetadata: false });
        const facts = clauses.filter((clause) => clause.head.name !== ':-');
        assertEqual(termToString(facts[0].head), 'chars("a")', 'chars fact');
        assertEqual(termToString(facts[1].head, new Env(), true, { doubleQuotes: 'codes' }), 'codes("a")', 'codes fact');
        assertEqual(termToString(facts[2].head), 'quoted_atom(a)', 'atom fact');
      },
    },
    {
      name: 'double_quotes parser state flows across source files',
      run: () => {
        const program = Program.parseSources([
          ':- set_prolog_flag(double_quotes, codes).',
          'value("A").',
        ], { sourceMetadata: false });
        const value = program.findGroup('value', 1).clauses[0].head.args[0];
        assertEqual(properListItems(value, new Env())[0].name, '65', 'code in second source');
        assertEqual(program.doubleQuotes, 'codes', 'final parser flag');
      },
    },
    {
      name: 'parser double_quotes option flows into solver flags',
      run: () => {
        const result = run('answer(atom) :- atom("text").', {
          goal: 'answer(X)',
          doubleQuotes: 'atom',
        });
        assertEqual(result.stdout, 'answer(atom).\n', 'atom-mode execution');
      },
    },
    {
      name: 'parser accepts ISO-style uppercase variables',
      run: () => {
        const goal = parseGoalText('member(X, [a, b])');
        assertEqual(termToString(goal, new Env(), true), 'member(X, "ab")', 'goal');
      },
    },
    {
      name: 'parser treats bare underscore as anonymous',
      run: () => {
        const clauses = parseProgramText('p(_, _).\n');
        const left = clauses[0].head.args[0].name;
        const right = clauses[0].head.args[1].name;
        assertEqual(left.startsWith('__anon'), true, 'left anonymous');
        assertEqual(right.startsWith('__anon'), true, 'right anonymous');
        assertEqual(left === right, false, 'fresh anonymous variables');
      },
    },
    {
      name: 'parser rejects old question-mark variable spelling',
      run: () => {
        let threw = false;
        try { parseProgramText('p(?x).\n'); } catch (_) { threw = true; }
        assertEqual(threw, true, 'question-mark variable syntax rejected');
      },
    },
    {
      name: 'parser accepts bare underscore anonymous variable spelling',
      run: () => {
        let threw = false;
        try { parseProgramText('p(_).\n'); } catch (_) { threw = true; }
        assertEqual(threw, false, 'bare underscore syntax accepted');
      },
    },
    {
      name: 'parser rejects unquoted dotted atoms to stay ISO-compatible',
      run: () => {
        let threw = false;
        try { parseProgramText('p(web(be.ugent, josd)).\n'); } catch (_) { threw = true; }
        assertEqual(threw, true, 'unquoted dotted atoms must be quoted');
      },
    },
    {
      name: 'parser preserves quoted dotted atoms for web-style terms',
      run: () => {
        const clauses = parseProgramText("p(web('be.ugent', josd), 'org.schema').\n");
        assertEqual(termToString(clauses[0].head, new Env(), true), "p(web('be.ugent', josd), 'org.schema')", 'head');
      },
    },
    {
      name: 'parser accepts quoted angle-bracket atoms',
      run: () => {
        const clauses = parseProgramText("p('<https://example.org/alice>', '<urn:example:bob>').\n");
        assertEqual(termToString(clauses[0].head, new Env(), true), "p('<https://example.org/alice>', '<urn:example:bob>')", 'head');
      },
    },
    {
      name: 'readback leaves absolute IRI atoms as quoted atoms',
      run: () => {
        const clauses = parseProgramText("p('https://example.org/alice').\n");
        assertEqual(termToString(clauses[0].head, new Env(), true), "p('https://example.org/alice')", 'head');
      },
    },
    {
      name: 'angle IRI syntax does not steal graphic atom syntax',
      run: () => {
        const clauses = parseProgramText('p(<=>).\n');
        assertEqual(termToString(clauses[0].head, new Env(), true), 'p(<=>)', 'head');
      },
    },
    {
      name: 'list construction round-trips through properListItems',
      run: () => {
        const list = listFromItems([atom('a'), numberTerm(2), stringTerm('c')]);
        const items = properListItems(list, new Env());
        assertEqual(items.length, 3, 'length');
        assertEqual(termToString(list, new Env(), true), '[a, 2, "c"]', 'list text');
      },
    },
    {
      name: 'variantTerms recognizes alpha-equivalent goals',
      run: () => {
        const left = parseGoalText('edge(X, Y)');
        const right = parseGoalText('edge(A, B)');
        const nonVariant = parseGoalText('edge(A, A)');
        assertEqual(variantTerms(left, new Env(), right, new Env()), true, 'variant');
        assertEqual(variantTerms(left, new Env(), nonVariant, new Env()), false, 'non-variant');
      },
    },
    {
      name: 'flattenConjunction preserves left-to-right order',
      run: () => {
        const goal = parseGoalText('(a, b, c)');
        const parts = flattenConjunction(goal).map((part) => termToString(part, new Env(), true));
        assertEqual(parts.join(' | '), 'a | b | c', 'order');
      },
    },
    {
      name: 'parseProgramText returns clause objects',
      run: () => {
        const clauses = parseProgramText('p(a).\nq(X) :- p(X).\n');
        assertEqual(clauses.length, 2, 'clause count');
        assertEqual(termToString(clauses[1].head, new Env(), true), 'q(X)', 'rule head');
        assertEqual(clauses[1].body.length, 1, 'body length');
      },
    },
    {
      name: 'fast parser bounds rule-marker scans to the current fact line',
      run: () => {
        const lines = ['q(X, Y) :- p(X, Y).'];
        for (let index = 0; index < 2_000; index++) lines.push(`p(a${index}, b${index}).`);
        const source = lines.join('\n');
        const originalIndexOf = String.prototype.indexOf;
        let wholeSourceRuleScans = 0;
        String.prototype.indexOf = function patchedIndexOf(search, ...args) {
          if (search === ':-' && String(this) === source) wholeSourceRuleScans++;
          return originalIndexOf.call(this, search, ...args);
        };
        try {
          const program = Program.parse(source, { sourceMetadata: false });
          assertEqual(program.clauses.length, 2_001, 'clause count');
          assertEqual(wholeSourceRuleScans, 0, 'whole-source rule scans');
        } finally {
          String.prototype.indexOf = originalIndexOf;
        }
      },
    },
    {
      name: 'streaming program builder preserves source order and dynamic declarations',
      run: () => {
        const program = Program.parseSources([
          { text: 'item(a).\n:- dynamic(later/1).\n', filename: 'first.pl' },
          { text: 'item(b).\nlater(c).\n', filename: 'second.pl' },
        ], { sourceMetadata: false });
        assertEqual(program.clauses.length, 4, 'clause count');
        assertEqual(program.clauses.map((clause) => clause.index).join(','), '0,1,2,3', 'source indexes');
        assertEqual(program.findGroup('item', 1).clauses.map((clause) => clause.index).join(','), '0,2', 'group order');
        assertEqual(program.findGroup('later', 1).dynamic, true, 'dynamic declaration');
      },
    },
    {
      name: 'clause candidate selection builds arbitrary-width indexes on demand',
      run: () => {
        const facts = ['row(a0, b0, c0, first).', 'row(a0, X, c0, wildcard).'];
        for (let a = 0; a < 6; a++) {
          for (let b = 0; b < 6; b++) {
            for (let c = 0; c < 6; c++) {
              if (a !== 0 || b !== 0 || c !== 0) facts.push(`row(a${a}, b${b}, c${c}, other).`);
            }
          }
        }
        const program = Program.parse(facts.join('\n'));
        const group = program.findGroup('row', 4);
        assertEqual(group.demandIndexes.size, 0, 'indexes start empty');
        const goal = parseGoalText('row(a0, b0, c0, Result)');
        const candidates = selectClauseCandidates(group, goal, new Env());
        assertEqual(group.argIndexes.length, 4, 'any-argument indexes available');
        assertEqual(group.demandIndexes.has('0'), false, 'single indexes are not rebuilt lazily');
        assertEqual(group.demandIndexes.has('0,1,2'), true, 'three-argument index built');
        assertEqual(candidates.primary.length, 2, 'candidate length');
        assertEqual(candidates.fallback.length, 0, 'one ordered candidate stream');
        assertEqual(termToString(candidates.primary[0].head, new Env(), true), 'row(a0, b0, c0, first)', 'first head');
        assertEqual(termToString(candidates.primary[1].head, new Env(), true), 'row(a0, X, c0, wildcard)', 'wildcard head');

        // A user-defined name: ISO 7.4.3 forbids a Prolog text from defining
        // clauses for a built-in predicate such as open/3.
        const variableHeavy = Program.parse(Array.from(
          { length: 12 },
          (_, index) => `gate(X${index}, Y${index}, value${index}).`,
        ).join('\n'));
        const gateGroup = variableHeavy.findGroup('gate', 3);
        selectClauseCandidates(gateGroup, parseGoalText('gate(a, b, Result)'), new Env());
        assertEqual(gateGroup.demandIndexes.size, 0, 'poor wide index discarded');
        assertEqual(gateGroup.rejectedDemandIndexes.has('0,1'), true, 'poor call mode remembered');
      },
    },
    {
      name: 'dynamic mutations refresh recursive planning',
      run: () => {
        const program = Program.parse(':- dynamic(loop/1).\n:- table loop/1.\n');
        const group = program.findGroup('loop', 1);
        assertEqual(group.recursive, false, 'empty dynamic predicate is not recursive');
        assertEqual(program.revision, 0, 'initial revision');
        program.insertDynamicClause({
          head: compound('loop', [variable('X')]),
          body: [compound('loop', [variable('X')])],
        });
        assertEqual(program.revision, 1, 'mutation revision');
        assertEqual(group.recursive, true, 'recursive flag refreshed');
        assertEqual(group.tabled, true, 'explicit table declaration retained');
      },
    },
    {
      name: 'recursive predicate groups stay depth-first without a table directive',
      run: () => {
        const program = Program.parse('edge(a, b).\npath(X, Y) :- edge(X, Y).\npath(X, Z) :- path(X, Y), edge(Y, Z).\n');
        const group = program.findGroup('path', 2);
        assertEqual(Boolean(group), true, 'path/2 group exists');
        assertEqual(group.recursive, true, 'path/2 recursion detected');
        assertEqual(group.tabled, false, 'path/2 not tabled implicitly');
      },
    },
    {
      name: 'explicit table directives opt recursive groups into tabling',
      run: () => {
        const program = Program.parse(':- table path/2.\nedge(a, b).\npath(X, Y) :- edge(X, Y).\npath(X, Z) :- edge(X, Y), path(Y, Z).\n');
        const group = program.findGroup('path', 2);
        assertEqual(group.tabled, true, 'path/2 explicitly tabled');
      },
    },
    {
      name: 'cycles through negation retain guarded resolution',
      run: () => {
        const program = Program.parse('p(X) :- \\+ q(X).\nq(X) :- p(X).\n');
        assertEqual(program.findGroup('p', 1).recursive, true, 'p/1 recursive');
        assertEqual(program.findGroup('q', 1).recursive, true, 'q/1 recursive');
        assertEqual(program.findGroup('p', 1).tabled, false, 'p/1 not positively tabled');
        assertEqual(program.findGroup('q', 1).tabled, false, 'q/1 not positively tabled');
      },
    },
    {
      name: 'large finite Datalog uses an indexed least model only for broad calls',
      run: () => {
        const edges = Array.from({ length: 130 }, (_, i) => `edge(n${i}, n${i + 1}).`).join('\n');
        const source = `:- table path/2.\n${edges}\npath(X,Y) :- edge(X,Y).\npath(X,Y) :- edge(X,Z), path(Z,Y).\n`;
        const program = Program.parse(source);
        const group = program.findGroup('path', 2);
        assertEqual(group.datalogLeastModel, true, 'large range-restricted Datalog is eligible');

        const broad = run(program, { goal: 'path(X,Y)' });
        assertEqual(broad.stdout.trim().split('\n').length, 8515, 'semi-naive closure has every chain pair');
        assertEqual(broad.stats.datalog_evaluations, 1, 'broad query builds one least model');

        const ground = run(program, { goal: 'path(n0,n130)' });
        assertEqual(ground.stdout, 'path(n0, n130).\n', 'ground chain still succeeds');
        assertEqual(ground.stats.datalog_evaluations, 0, 'ground query keeps the ordinary indexed chain path');
      },
    },
    {
      name: 'compact finite Datalog planning preserves lazy clause terms',
      run: () => {
        const facts = Array.from({ length: 130 }, (_, i) => `compact_edge(n${i}, n${i + 1}).`).join('\n');
        const source = `:- table compact_edge/2.\n${facts}\ncompact_edge(X,Y) :- compact_edge(X,Y).\n`;
        const program = Program.parseSources([{ text: source, filename: 'compact-datalog.pl' }], {
          sourceMetadata: false,
        });
        const group = program.findGroup('compact_edge', 2);
        assertEqual(group.datalogLeastModel, true, 'compact recursive Datalog remains eligible');
        assertEqual(
          group.clauses.filter((clause) => clause._head != null || clause._body != null).length,
          0,
          'planning keeps compact clause terms lazy',
        );
      },
    },
    {
      name: 'findall length counting preserves multiplicity and observable bags',
      run: () => {
        const source = `
p(a).
p(b).
q(X) :- p(X).
q(X) :- p(X).
bench(N) :- findall(X, q(X), Bag), length(Bag, N).
collect(Bag,N) :- findall(X, q(X), Bag), length(Bag, N).
`;
        assertEqual(run(source, { goal: 'bench(N)' }).stdout, 'bench(4).\n', 'dead bag counts all four proof solutions');
        assertEqual(run(source, { goal: 'collect(Bag,N)' }).stdout, 'collect("abab", 4).\n', 'bag exposed through the rule head is materialized');
      },
    },
    {
      name: 'ground negation probes a complete positive Datalog model',
      run: () => {
        const edges = Array.from({ length: 130 }, (_, i) => `edge(n${i}, n${i + 1}).`).join('\n');
        const source = `:- table path/2.
${edges}
path(X,Y) :- edge(X,Y).
path(X,Y) :- edge(X,Z), path(Z,Y).
blocked(X,Y) :- path(X,Y).
candidate(n0,n130).
candidate(n130,n0).
keep(X,Y) :- candidate(X,Y), \\+ blocked(X,Y).
`;
        const result = run(source, { goal: 'keep(X,Y)' });
        assertEqual(result.stdout, 'keep(n130, n0).\n', 'negation sees the complete transitive closure');
        assertEqual(result.stats.datalog_evaluations, 1, 'ground truth probe reuses one complete least model');
      },
    },
    {
      name: 'tnot enables finite Datalog well-founded semantics without changing ISO negation',
      run: () => {
        const program = Program.parse(`
move(1, 2).
move(2, 3).
move(3, 4).
move(4, 1).
win(X) :- move(X, Y), tnot(win(Y)).
`);
        assertEqual(program.findGroup('win', 1).wfsDatalog, true, 'win/1 uses finite WFS evaluation');
        assertEqual(program.findGroup('win', 1).tabled, false, 'win/1 is not positive least-model tabled');
        const result = run(program, { goal: 'win(X)' });
        assertEqual(result.stdout, '', 'negative cycle does not expose undefined atoms as successful answers');
        assertEqual(result.stats.wfs_fixpoint_rounds, 2, 'alternating fixed point converges in two rounds');
        assertEqual(result.stats.wfs_undefined_answers, 4, 'cycle atoms are observed as undefined rather than unconditional truths');

        const nafProgram = Program.parse('p(X) :- \\+ q(X).\nq(X) :- p(X).\n');
        assertEqual(nafProgram.findGroup('p', 1).wfsDatalog, false, '\\+/1 remains ordinary negation as failure');
      },
    },
    {
      name: 'finite WFS distinguishes true false and undefined for ground tnot calls',
      run: () => {
        const source = `
move(a, b).
move(c, d).
move(d, c).
win(X) :- move(X, Y), tnot(win(Y)).
true_case :- win(a).
false_case :- tnot(win(a)).
undefined_case :- tnot(win(c)).
`;
        assertEqual(run(source, { goal: 'true_case' }).stdout, 'true_case.\n', 'win(a) is true because b is false');
        assertEqual(run(source, { goal: 'false_case' }).stdout, '', 'tnot(win(a)) fails for a true atom');
        assertEqual(run(source, { goal: 'undefined_case' }).stdout, '', 'tnot of an undefined WFS atom is not a successful answer');
      },
    },
    {
      name: 'wfs_truth exposes three-valued results without executing undefined goals',
      run: () => {
        const source = `
:- use_module(library(tabling)).
:- table(win/1).
move(a, b).
move(c, d).
move(d, c).
win(X) :- move(X, Y), tnot(win(Y)).
`;
        assertEqual(run(source, { goal: 'wfs_truth(win(a), Truth)' }).stdout,
          'wfs_truth(win(a), true).\n', 'true WFS atom');
        assertEqual(run(source, { goal: 'wfs_truth(win(b), Truth)' }).stdout,
          'wfs_truth(win(b), false).\n', 'false WFS atom');
        const undefinedResult = run(source, { goal: 'wfs_truth(win(c), Truth)' });
        assertEqual(undefinedResult.stdout, 'wfs_truth(win(c), undefined).\n', 'undefined WFS atom');
        assertEqual(undefinedResult.stats.wfs_undefined_answers, 1, 'undefined truth inspection is counted');
        assertEqual(run(source, { goal: 'wfs_truth(win(c), true)' }).stdout, '', 'truth filter can reject undefined');
        let nongroundError = null;
        try {
          run(source, { goal: 'wfs_truth(win(X), Truth)' });
        } catch (error) {
          nongroundError = error;
        }
        assertEqual(nongroundError?.formal, 'instantiation_error', 'inspected goal must be ground');

        const moduleSource = `
:- module(cycle, [status/1]).
:- use_module(library(tabling)).
:- table(a/0).
:- table(b/0).
a :- tnot(b).
b :- tnot(a).
status(Truth) :- wfs_truth(a, Truth).
`;
        assertEqual(run(moduleSource, { goal: 'cycle:status(Truth)' }).stdout,
          'cycle:status(undefined).\n', 'lexical module qualification');
        assertEqual(run(moduleSource, { goal: 'wfs_truth(cycle:a, Truth)' }).stdout,
          'wfs_truth(cycle:a, undefined).\n', 'explicit module qualification');
        assertEqual(run(moduleSource, { goal: 'tnot(cycle:a)' }).stdout, '',
          'qualified tnot preserves undefined failure');
      },
    },
    {
      name: 'undefined WFS goals do not run continuations or print CLI answers',
      run: () => {
        const source = `
:- use_module(library(tabling)).
:- table(a/0).
:- table(b/0).
a :- tnot(b).
b :- tnot(a).
`;
        const result = run(source, { goal: 'a, write(true), nl; halt' });
        assertEqual(result.stdout, '', 'undefined first branch neither writes nor produces a ground answer');
        assertEqual(result.haltCode, 0, 'fallback halt branch runs');
        assertEqual(result.stats.wfs_undefined_answers, 1, 'undefined atom remains observable in statistics');
      },
    },
    {
      name: 'cyclic tabling reaches a complete fixed point',
      run: () => {
        const result = run(Program.parse(`
:- table path/2.
edge(a, b).
edge(b, c).
edge(c, d).
edge(d, a).
path(X, Y) :- edge(X, Y).
path(X, Z) :- edge(X, Y), path(Y, Z).
`), { goal: 'path(X0, X1)' });
        const answers = result.stdout.trim().split('\n');
        assertEqual(answers.length, 16, 'four-node cycle transitive closure size');
        for (const node of ['a', 'b', 'c', 'd']) {
          assertIncludes(result.stdout, `path(${node}, ${node}).\n`, `${node} reaches itself`);
        }
        assertEqual(result.stats.table_fixpoint_rounds > 1, true, 'cyclic table required multiple rounds');
      },
    },
    {
      name: 'challenging examples declare their dynamic-programming tables explicitly',
      run: () => {
        const checks = [
          ['binomial-vandermonde.pl', 'choose_step', 5, true],
          ['catalan-convolution.pl', 'catalan', 2, true],
          ['chart-parser.pl', 'span', 4, true],
          ['continued-fraction-sqrt2.pl', 'conv', 3, true],
          ['critical-path-schedule.pl', 'earliest_start', 2, true],
          ['critical-path-schedule.pl', 'finish_time', 2, true],
          ['integer-partitions.pl', 'partitions', 3, true],
          ['matrix-chain-order.pl', 'cost', 3, true],
          ['modular-exponentiation.pl', 'pow_mod', 4, true],
          ['pell-equation.pl', 'pell', 3, true],
          ['stirling-bell-numbers.pl', 'stirling2', 3, false],
          ['totient-summatory.pl', 'gcd', 3, true],
          ['totient-summatory.pl', 'totient', 2, false],
          ['weighted-interval-scheduling.pl', 'best_from', 2, true],
        ];
        for (const [filename, name, arity, recursive] of checks) {
          const text = fs.readFileSync(path.join(packageRoot, 'examples', filename), 'utf8');
          const program = Program.parseSources([{ text, filename }]);
          const group = program.findGroup(name, arity);
          assertEqual(Boolean(group), true, `${filename} ${name}/${arity} group exists`);
          assertEqual(group.tabled, recursive, `${filename} ${name}/${arity} explicit table decision`);
          assertEqual(group.recursive, recursive, `${filename} ${name}/${arity} recursive`);
        }
      },
    },
    {
      name: 'recursive search pattern explicitly tables scan and search predicates',
      run: () => {
        const text = `
          :- table queens/3.
          :- table attack/3.

          queens([], Qs, Qs).
          queens(Us, Ps, Qs) :-
            select(Q, Us, Us1),
            \+ attack(Q, 1, Ps),
            queens(Us1, [Q|Ps], Qs).

          attack(X, N, [Y|_]) :- X is Y + N.
          attack(X, N, [Y|_]) :- X is Y - N.
          attack(X, N, [_|Ys]) :-
            N1 is N + 1,
            attack(X, N1, Ys).
        `;
        const program = Program.parseSources([{ text, filename: 'recursive-search.pl' }]);
        const attack = program.findGroup('attack', 3);
        assertEqual(Boolean(attack), true, 'attack/3 group exists');
        assertEqual(attack.tabled, true, 'attack/3 tabled');
        assertEqual(attack.recursive, true, 'attack/3 recursive');
        assertEqual(attack.tableInputPositions.join(','), '2', 'diagonal scan uses the placed rows as input');
        const queens = program.findGroup('queens', 3);
        assertEqual(Boolean(queens), true, 'queens/3 group exists');
        assertEqual(queens.tabled, true, 'queens/3 tabled');
        assertEqual(queens.recursive, true, 'queens/3 recursive');
      },
    },
    {
      name: 'collatz example explicitly tables the recursive trajectory predicate',
      run: () => {
        const text = fs.readFileSync(path.join(packageRoot, 'examples', 'collatz-1000.pl'), 'utf8');
        const program = Program.parseSources([{ text, filename: 'collatz-1000.pl' }]);
        const group = program.findGroup('collatz', 2);
        assertEqual(Boolean(group), true, 'collatz/2 group exists');
        assertEqual(group.tabled, true, 'collatz/2 tabled');
        assertEqual(group.recursive, true, 'collatz/2 recursive');
        assertEqual(group.tableInputPositions.join(','), '0', 'collatz uses its numeric seed as input');
      },
    },
    {
      name: 'collatz example remains stack-safe for browser-sized stacks',
      run: () => {
        // Use a deliberately tiny stack to catch browser-worker recursion regressions.
        const source = fs.readFileSync(path.join(packageRoot, 'examples', 'collatz-1000.pl'), 'utf8');
        const goalArgs = goalsFromSource(source).flatMap((goal) => ['--goal', goal]);
        const result = spawnSync(process.execPath, ['--stack-size=100', bin, ...goalArgs, 'examples/collatz-1000.pl'], {
          cwd: packageRoot,
          encoding: 'utf8',
        });
        assertEqual(result.status, 0, `exit status${result.stderr ? `\nstderr: ${result.stderr}` : ''}`);
        assertEqual(result.stderr, '', 'stderr');
        assertIncludes(result.stdout, 'collatzTrajectory(1000, [1000, 500, 250, 125', 'stdout');
        assertIncludes(result.stdout, 'collatzTrajectory(1, [1]).\n', 'stdout');
      },
    },
  ];
}

function runSection(reporter, name, cases) {
  reporter.section(name);
  for (const testCase of cases) reporter.test(testCase.name, testCase.run);
  reporter.sectionTotal(sectionLabel(name));
}

function sectionLabel(name) {
  if (name === 'Documentation sync') return 'documentation sync';
  if (name === 'API') return 'API';
  if (name === 'White-box') return 'white-box';
  return name.toLowerCase();
}

function bookReferenceDocumentationIssues() {
  const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyeprolog.md'), 'utf8');
  const guide = fs.readFileSync(path.join(testRoot, 'conformance', 'README.md'), 'utf8');
  const issues = [];

  if (!book.includes('This book is also the reference for the EyeProlog implementation.')) {
    issues.push('book introduction does not identify itself as the reference');
  }
  if (!book.includes('This book is the single reference for the EyeProlog implementation.')) {
    issues.push('book Chapter 42 does not state the single-reference policy');
  }
  for (const standard of [
    'ISO/IEC 13211-1:1995',
    'Technical Corrigendum 1:2007',
    'Technical Corrigendum 2:2012',
    'Technical Corrigendum 3:2017',
  ]) {
    if (!book.includes(standard)) issues.push(`book does not identify standards baseline: ${standard}`);
  }
  if (!book.includes('EyeProlog performs it consistently for ordinary\nunification as well as `unify_with_occurs_check/2`.')) {
    issues.push('book glossary does not match finite-tree unification');
  }
  if (book.includes('EyeProlog does not perform it.')) {
    issues.push('book contradicts implementation occurs-check behavior');
  }
  for (const heading of ['## 38. Language and ISO profile', '## 39. Predicate reference', '## 40. Running EyeProlog: command line and corpus']) {
    if (!book.includes(heading)) issues.push(`book is missing ${heading}`);
  }
  if (!guide.includes('[*The Art of EyeProlog*](../../the-art-of-eyeprolog.md) is the reference')) {
    issues.push('test guide does not identify the book as the reference');
  }
  if (!guide.includes('not a separate\nlanguage specification')) {
    issues.push('test guide presents the suite as a separate specification');
  }

  return issues;
}

function runWhy({ program, goalText, expected }) {
  program = withStandardModules(program);
  const programFile = path.join(tmp, `${++tmpCounter}.pl`);
  fs.writeFileSync(programFile, program);
  const goal = parseGoalText(goalText);
  const parsed = Program.parseSources([{ text: program, filename: path.basename(programFile) }], { sourceMetadata: true });
  const result = runEyeProlog(parsed, { proof: true, goal });
  const expectedText = expected.replaceAll('__FILE__', path.basename(programFile));
  assertEqual(result.stdout, expectedText, 'stdout');

  Program.parse(result.stdout);
  assertIncludes(result.stdout, '  proof(\n', 'stdout');
  assertIncludes(result.stdout, ' by(rule("', 'stdout');
  assertIncludes(result.stdout, ', clause(', 'stdout');
  assertNotIncludes(result.stdout, 'source(head(', 'stdout');
  assertIncludes(result.stdout, '\n).\n\n', 'stdout');
}

function runWhyLoose({ program, goalText }) {
  program = withStandardModules(program);
  const programFile = path.join(tmp, `${++tmpCounter}.pl`);
  fs.writeFileSync(programFile, program);
  const goal = parseGoalText(goalText);
  const parsed = Program.parseSources([{ text: program, filename: path.basename(programFile) }], { sourceMetadata: true });
  const result = runEyeProlog(parsed, { proof: true, goal });
  Program.parse(result.stdout);
  assertIncludes(result.stdout, '\n).\n\n', 'stdout');
  return result;
}

function listExampleNames() {
  return fs.readdirSync(path.join(packageRoot, 'examples'))
    .filter((name) => name.endsWith('.pl'))
    .map((name) => name.slice(0, -3))
    .sort();
}

function listGoldenExampleNames() {
  return fs.readdirSync(path.join(packageRoot, 'examples', 'output'))
    .filter((name) => name.endsWith('.pl'))
    .map((name) => name.slice(0, -3))
    .sort();
}

function exampleCorpusSyncIssues() {
  const examples = listExampleNames();
  const issues = arrayDiffMessages(listGoldenExampleNames(), examples, 'examples/output');
  const checks = [
    {
      file: path.join(packageRoot, 'the-art-of-eyeprolog.md'),
      pattern: /top-level directory contains \*\*(\d+) self-contained runnable programs\*\*/,
    },
  ];
  for (const check of checks) {
    const relative = path.relative(packageRoot, check.file);
    const match = fs.readFileSync(check.file, 'utf8').match(check.pattern);
    if (match == null) {
      issues.push(`${relative}: runnable example count not found`);
    } else if (Number(match[1]) !== examples.length) {
      issues.push(`${relative}: runnable example count ${match[1]} != ${examples.length}`);
    }
  }
  return issues.sort();
}


function proofCorpusSyncIssues() {
  const proofDir = path.join(packageRoot, 'examples', 'proof');
  const goldens = fs.readdirSync(proofDir)
    .filter((name) => name.endsWith('.pl'))
    .sort();
  const configured = [...proofExamples].sort();
  const issues = arrayDiffMessages(configured, goldens, 'proof example runner');
  for (const name of goldens) {
    if (!fs.existsSync(path.join(packageRoot, 'examples', name))) {
      issues.push(`examples/proof/${name}: source example is missing`);
    }
  }
  const checks = [
    {
      file: path.join(packageRoot, 'the-art-of-eyeprolog.md'),
      pattern: /\*\*(\d+) selected programs\*\* have a checked/,
    },
  ];
  for (const check of checks) {
    const relative = path.relative(packageRoot, check.file);
    const match = fs.readFileSync(check.file, 'utf8').match(check.pattern);
    if (match == null) {
      issues.push(`${relative}: proof example count not found`);
    } else if (Number(match[1]) !== goldens.length) {
      issues.push(`${relative}: proof example count ${match[1]} != ${goldens.length}`);
    }
  }
  return issues.sort();
}

function bookExampleCatalogIssues() {
  const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyeprolog.md'), 'utf8');
  const section = between(book, '### Further examples', '## 42. Standards, limits, and implementation boundaries');
  const names = [...section.matchAll(/github\.com\/eyereasoner\/eyeprolog\/blob\/main\/examples\/([A-Za-z0-9_-]+)\.pl/g)]
    .map((match) => match[1]);
  const issues = [];
  if (names.length === 0) issues.push('no source example links found');
  for (const name of names) {
    if (!fs.existsSync(path.join(packageRoot, "examples", name + ".pl"))) issues.push("missing examples/" + name + ".pl");
    if (!fs.existsSync(path.join(packageRoot, "examples", "output", name + ".pl"))) issues.push("missing examples/output/" + name + ".pl");
  }
  return [...new Set(issues)].sort();
}

function playgroundExampleIssues() {
  const issues = [];
  const expected = listExampleNames();
  const html = fs.readFileSync(path.join(packageRoot, 'playground.html'), 'utf8');
  const match = html.match(/const EXAMPLES = (\[[\s\S]*?\]);/);
  if (match == null) return ['playground EXAMPLES array not found'];
  const examples = JSON.parse(match[1]).sort();
  issues.push(...arrayDiffMessages(examples, expected, 'playground EXAMPLES'));
  if (!html.includes('new URL(`./examples/${name}.pl`, location.href)')) {
    issues.push('playground must load selected examples from relative ./examples/*.pl URLs');
  }
  if (!html.includes("fetch(exampleUrl, { cache: 'no-store' })")) {
    issues.push('playground must fetch selected example source from its relative URL');
  }
  return issues.sort();
}

function playgroundStaticIssues() {
  const issues = [];
  const playgroundPath = path.join(packageRoot, 'playground.html');
  const html = fs.readFileSync(playgroundPath, 'utf8');
  const readme = fs.readFileSync(path.join(packageRoot, 'README.md'), 'utf8');
  if (!pkg.files?.includes('playground.html')) issues.push('package files must include playground.html');
  if (!readme.includes('[Playground](https://eyereasoner.github.io/eyeprolog/playground)')) issues.push('README must link to the GitHub Pages playground URL');
  if (!html.includes('<meta name="viewport" content="width=device-width, initial-scale=1">')) issues.push('missing mobile viewport meta');
  if (!html.includes('main {') || !html.includes('display: block;')) {
    issues.push('playground must use a simple vertical layout');
  }
  if (!html.includes('@media (max-width: 560px)') || !html.includes('button,') || !html.includes('width: 100%')) {
    issues.push('playground must make controls usable at phone widths');
  }
  if (!html.includes('<summary id="advanced-heading">⚙ Advanced configuration</summary>')) {
    issues.push('playground must keep URL/proof controls inside advanced configuration');
  }
  if (!html.includes('id="load-background"') || !html.includes('backgroundSource') || !html.includes('combinedSource()')) {
    issues.push('playground must support loading URL content as background knowledge');
  }
  if (!html.includes('HIGHLIGHT_LIMIT') || !html.includes('text.length > HIGHLIGHT_LIMIT')) {
    issues.push('playground must avoid full syntax coloring for very large examples');
  }
  if (!html.includes('<script type="module">')) issues.push('playground script must be an ES module');
  if (!html.includes("new URL('./src/playground-worker.js?playground=")) issues.push('playground must cache-bust its dedicated module worker');
  if (!html.includes("new Worker(workerUrl, { type: 'module' })")) issues.push('playground must launch the dedicated module worker');
  const workerText = fs.readFileSync(path.join(packageRoot, 'src', 'playground-worker.js'), 'utf8');
if (!workerText.includes("from './index.js?playground=") ||
      !workerText.includes('createEyePrologRegistry') ||
      !workerText.includes('executePlaygroundRequest')) {
    issues.push('playground worker must install the EyeProlog library registry');
  }
  if (fs.existsSync(path.join(packageRoot, 'src', 'portable-library.js'))) {
    issues.push('obsolete portable-library.js must be absent');
  }
  for (const filename of ['src/playground-worker.js', 'src/index.js', 'src/program.js', 'src/io.js']) {
    const sourceText = fs.readFileSync(path.join(packageRoot, filename), 'utf8');
    if (/^\s*import\s+[^('\"]*['\"]node:/m.test(sourceText)) {
      issues.push(`${filename} must not statically import Node built-ins in the browser graph`);
    }
  }
  const platformText = fs.readFileSync(path.join(packageRoot, 'src', 'platform.js'), 'utf8');
  if (!platformText.includes("await import('node:fs')") || !platformText.includes("await import('node:path')")) {
    issues.push('browser platform bridge must guard Node built-ins behind dynamic imports');
  }
  if (!html.includes('activeWorker.onmessageerror') || !html.includes('Serve the checkout over HTTP(S)')) {
    issues.push('playground must report actionable worker startup and message errors');
  }
  if (!html.includes('class="editor"') || !html.includes('id="highlight"') || !html.includes('id="source"')) {
    issues.push('playground must include layered syntax-colored editor');
  }
  if (!html.includes('--editor-bg: #ffffff') || !html.includes('background: var(--editor-bg)')) {
    issues.push('playground editor must use a light editor background');
  }
  if (!html.includes('id="error-line-marker"') || !html.includes('extractParseErrorLine') || !html.includes('markSyntaxErrorLine') || !html.includes('--editor-error-line')) {
    issues.push('playground must highlight syntax-error lines in the editor');
  }
  if (!html.includes('id="line-numbers"') || !html.includes('updateLineNumbers') || !html.includes('lineNumbersInner.style.transform') || !html.includes('--line-number-bg')) {
    issues.push('playground editor must include synced line numbers');
  }
  if (!html.includes('MAX_SHARE_URL_LENGTH') || !html.includes('buildReferenceShareLink') || !html.includes("params.set('example'") || !html.includes("params.set('url'")) {
    issues.push('playground share links must avoid embedding large example or URL-loaded sources');
  }
  if (!html.includes('id="create-gist"') || !html.includes('createGistShare') || !html.includes('GIST_STATE_FILENAME') || !html.includes("fetch('https://api.github.com/gists'")) {
    issues.push('playground must support Gist-backed sharing for large programs');
  }
  if (!html.includes('await createGistShare({') || html.includes('Use “Create Gist share” instead')) {
    issues.push('playground Copy share link must automatically fall back to Gist sharing for large programs');
  }
  if (!html.includes("params.has('state-url')") || !html.includes('#state-url=')) {
    issues.push('playground must restore state from raw Gist state URLs');
  }
  if (!html.includes('id="example-search"') || !html.includes('id="examples"')) issues.push('playground must include searchable examples');
  const scriptMatch = html.match(new RegExp('<script type="module">\\n([\\s\\S]*?)\\n  <\\/script>'));
  if (scriptMatch == null) {
    issues.push('module script not found');
  } else {
    const scriptFile = path.join(tmp, 'playground-script.mjs');
    fs.writeFileSync(scriptFile, scriptMatch[1]);
    const result = spawnSync(process.execPath, ['--check', scriptFile], { encoding: 'utf8' });
    if (result.status !== 0) issues.push(`playground module syntax check failed: ${result.stderr.trim()}`);
  }
  return issues.sort();
}

function registeredBuiltinNames() {
  return [...createDefaultRegistry().defs.keys()].sort();
}

function registeredEyePrologLibraryNames() {
  return [...eyePrologLibraryIndicators].sort();
}

function registeredNativeEyePrologLibraryNames() {
  return [...eyePrologNativeLibraryIndicators].sort();
}

function registeredBuiltinSummary() {
  const names = registeredBuiltinNames();
  return {
    entries: names.length,
    names: new Set(names.map((name) => name.split('/')[0])).size,
  };
}

function bookBuiltinNames() {
  const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyeprolog.md'), 'utf8');
  return documentedBuiltinNames(
    between(book, '<!-- eyeprolog-core-catalog:start -->', '<!-- eyeprolog-core-catalog:end -->'),
  );
}

function bookEyePrologLibraryNames() {
  const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyeprolog.md'), 'utf8');
  const iso = new Set(registeredBuiltinNames());
  const section = between(book, '<!-- eyeprolog-library-catalog:start -->', '<!-- eyeprolog-library-catalog:end -->');
  const exports = section.split('\n')
    .filter((line) => line.trimStart().startsWith('**Exports:**'))
    .join('\n');
  return documentedBuiltinNames(exports).filter((indicator) => !iso.has(indicator));
}

function bookLibraryModuleIssues() {
  const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyeprolog.md'), 'utf8');
  const section = between(book, '<!-- eyeprolog-library-catalog:start -->', '<!-- eyeprolog-library-catalog:end -->');
  const documented = new Map();
  const lines = section.split('\n');
  for (let i = 0; i < lines.length; i++) {
    const match = lines[i].match(/^- \*\*`library\(([^)`]+)\)`\*\*/);
    if (match == null) continue;
    const exports = lines[i + 1] ?? '';
    documented.set(match[1], documentedBuiltinNames(exports));
  }

  const issues = [];
  for (const [moduleName, entry] of standardLibrarySources) {
    const parsed = Program.parse(entry.source);
    const definition = parsed.modules.get(moduleName);
    if (definition == null) {
      issues.push(`missing module declaration for ${moduleName}`);
      continue;
    }
    const actual = [...definition.exports.keys()].sort();
    const expected = documented.get(moduleName);
    if (expected == null) {
      issues.push(`book catalog omits library(${moduleName})`);
      continue;
    }
    if (JSON.stringify(expected) !== JSON.stringify(actual)) {
      issues.push(`library(${moduleName}) exports: expected ${actual.join(', ')}, documented ${expected.join(', ')}`);
    }
  }
  for (const moduleName of documented.keys()) {
    if (!standardLibrarySources.has(moduleName)) issues.push(`book catalogs unknown library(${moduleName})`);
  }
  return issues.sort();
}

function bookBuiltinSummary() {
  const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyeprolog.md'), 'utf8');
  const match = book.match(/(?:registers|contains) (\d+) name\/arity entries across (\d+) names/);
  if (match == null) throw new Error('book builtin summary not found');
  return { entries: Number(match[1]), names: Number(match[2]) };
}

function documentedBuiltinNames(section) {
  const names = [];
  for (const match of section.matchAll(/`([^`]+)`/g)) {
    const indicator = match[1].match(/^(.+)\/(\d+)$/);
    if (indicator == null) continue;
    names.push(`${indicator[1]}/${indicator[2]}`);
  }
  return [...new Set(names)].sort();
}

function runtimeExportNames() {
  return Object.keys(publicApi).sort();
}

function runtimeDefaultExportNames() {
  return Object.keys(publicDefaultApi).sort();
}

function declaredValueExportNames() {
  const dts = fs.readFileSync(path.join(packageRoot, 'index.d.ts'), 'utf8');
  return [...dts.matchAll(/^export\s+(?:declare\s+)?(?:class|function|const)\s+([A-Za-z_][A-Za-z0-9_]*)/gm)]
    .map((match) => match[1])
    .filter((name, index, names) => names.indexOf(name) === index)
    .sort();
}

function declaredDefaultExportNames() {
  const dts = fs.readFileSync(path.join(packageRoot, 'index.d.ts'), 'utf8');
  const declaration = dts.match(/declare const eyeprolog: \{([\s\S]*?)\n\};/);
  if (declaration == null) throw new Error('default export declaration not found');
  return [...declaration[1].matchAll(/^\s+([A-Za-z_][A-Za-z0-9_]*): typeof /gm)]
    .map((match) => match[1])
    .sort();
}

function missingDocumentedPackageScripts() {
  const docs = documentationFiles();
  const missing = [];
  const nativeCommands = new Set(['exec', 'install', 'link']);
  for (const file of docs) {
    const text = fs.readFileSync(file, 'utf8');
    for (const line of text.split('\n')) {
      const trimmed = line.trim();
      const commandTexts = [];
      if (trimmed.startsWith('npm ')) commandTexts.push(trimmed);
      for (const match of line.matchAll(/`([^`]*\bnpm\s+[^`]*)`/g)) commandTexts.push(match[1].trim());
      for (const commandText of commandTexts) {
        const match = commandText.match(/^npm\s+(?:run\s+)?([A-Za-z0-9:_-]+)/);
        if (match == null) continue;
        const command = match[1];
        if (nativeCommands.has(command)) continue;
        const script = command === 'test' ? 'test' : command;
        if (!pkg.scripts?.[script]) missing.push(`${path.relative(packageRoot, file)}: npm ${command === 'test' ? 'test' : `run ${script}`}`);
      }
    }
  }
  return [...new Set(missing)].sort();
}

function misleadingDependencyInstallDocs() {
  const misleading = [];
  for (const file of documentationFiles()) {
    const text = fs.readFileSync(file, 'utf8');
    if (text.includes('Install dependencies')) misleading.push(`${path.relative(packageRoot, file)}: Install dependencies`);
    if (text.includes('npm install\n```') || text.includes('npm install\r\n```')) {
      misleading.push(`${path.relative(packageRoot, file)}: bare npm install setup block`);
    }
  }
  return [...new Set(misleading)].sort();
}

function documentationSourceStyleIssues() {
  const issues = [];
  const file = path.join(packageRoot, 'the-art-of-eyeprolog.md');
  const text = fs.readFileSync(file, 'utf8');
  if (text.includes('```prolog')) {
    issues.push('the-art-of-eyeprolog.md: use eyeprolog code fences instead of prolog fences');
  }
  if (/\bv\d+\.\d+(?:\.\d+)?\b/i.test(text)) {
    issues.push('the-art-of-eyeprolog.md: describe the current system instead of release chronology');
  }
  for (const block of text.matchAll(/^```eyeprolog\s*\n([\s\S]*?)^```\s*$/gm)) {
    if (/^\s*(?:eyeprolog|node|npm)\b/m.test(block[1])) {
      issues.push('the-art-of-eyeprolog.md: keep host commands outside eyeprolog code fences');
    }
  }
  return issues;
}

function findBrokenDocLinks() {
  const broken = [];
  const anchorsByFile = new Map();
  for (const file of documentationFiles()) {
    const text = fs.readFileSync(file, 'utf8');
    for (const target of markdownLinkTargets(text)) {
      if (/^(?:https?:|mailto:)/i.test(target)) continue;
      const [targetPathRaw, fragmentRaw] = target.split('#');
      const targetPath = targetPathRaw === '' ? file : path.resolve(path.dirname(file), decodeURI(targetPathRaw));
      const display = `${path.relative(packageRoot, file)} -> ${target}`;
      if (!fs.existsSync(targetPath)) {
        broken.push(`${display} (missing target)`);
        continue;
      }
      if (fragmentRaw != null && fragmentRaw !== '') {
        const anchors = anchorsByFile.get(targetPath) ?? markdownAnchors(targetPath);
        anchorsByFile.set(targetPath, anchors);
        if (!anchors.has(fragmentRaw)) broken.push(`${display} (missing heading #${fragmentRaw})`);
      }
    }
  }
  return broken.sort();
}

function documentationFiles() {
  return listMarkdownFiles(packageRoot);
}

function listMarkdownFiles(directory) {
  return fs.readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
    if (entry.name === 'node_modules' || entry.name === '.git') return [];
    const target = path.join(directory, entry.name);
    if (entry.isDirectory()) return listMarkdownFiles(target);
    return entry.name.endsWith('.md') ? [target] : [];
  }).sort();
}

function documentedConformanceMetricIssues() {
  const report = buildConformanceReport();
  const iso = report.rows.find((row) => row.category === 'iso')?.total;
  const total = report.total.total;
  const wg17 = report.executable.find((gate) => gate.name === 'WG17 syntax')?.total;
  const checks = [
    {
      file: path.join(packageRoot, 'the-art-of-eyeprolog.md'),
      pattern: /contains (\d+) cases, including (\d+) focused ISO\s+cases/,
      expected: [total, iso],
      labels: ['total', 'ISO'],
    },
    {
      file: path.join(packageRoot, 'test', 'conformance', 'README.md'),
      pattern: /corpus has (\d+) cases in `iso\/` and (\d+) file-based conformance cases/,
      expected: [iso, total],
      labels: ['ISO', 'total'],
    },
  ];
  const issues = [];
  for (const check of checks) {
    const relative = path.relative(packageRoot, check.file);
    const match = fs.readFileSync(check.file, 'utf8').match(check.pattern);
    if (match == null) {
      issues.push(`${relative}: conformance totals not found`);
      continue;
    }
    for (let i = 0; i < check.expected.length; i++) {
      const actual = Number(match[i + 1]);
      if (actual !== check.expected[i]) {
        issues.push(`${relative}: ${check.labels[i]} count ${actual} != ${check.expected[i]}`);
      }
    }
  }
  for (const file of [
    path.join(packageRoot, 'test', 'conformance', 'README.md'),
    path.join(packageRoot, 'test', 'conformance', 'ISO-COMPLIANCE.md'),
  ]) {
    const relative = path.relative(packageRoot, file);
    const text = fs.readFileSync(file, 'utf8');
    const claims = [
      ...[...text.matchAll(/\b(\d+)-case[^\n|]*WG17/g)].map((match) => Number(match[1])),
      ...[...text.matchAll(/WG17[^\n|]*?\b(\d+) executable/g)].map((match) => Number(match[1])),
    ];
    if (claims.length === 0) {
      const dynamicPolicy = /live Neumerkel|current upstream inventory|discovered dynamically/i.test(text);
      if (!dynamicPolicy) issues.push(`${relative}: WG17 total or dynamic-upstream policy not found`);
    }
    for (const claim of claims) {
      if (claim !== wg17) issues.push(`${relative}: WG17 count ${claim} != ${wg17}`);
    }
  }
  return issues.sort();
}

function markdownLinkTargets(text) {
  const markdown = [...text.matchAll(/!?\[[^\]\n]*\]\(([^)\s]+)(?:\s+"[^"]*")?\)/g)]
    .map((match) => match[1]);
  const html = [...text.matchAll(/\b(?:src|href)="([^"]+)"/g)]
    .map((match) => match[1]);
  return [...markdown, ...html];
}

function bookIntroOutputIssues() {
  const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyeprolog.md'), 'utf8');
  const match = book.match(/The (?:first|EyeProlog) command should print:\s*```text\n([\s\S]*?)```/);
  if (match == null) return ['the-art-of-eyeprolog.md: introductory output block not found'];
  const documented = `${match[1].trimEnd()}\n`;
  const expected = fs.readFileSync(path.join(packageRoot, 'examples', 'output', 'socrates.pl'), 'utf8');
  return documented === expected
    ? []
    : ['the-art-of-eyeprolog.md: introductory Socrates output differs from examples/output/socrates.pl'];
}

function documentedPublicApiImportIssues() {
  const exported = new Set(runtimeExportNames());
  const issues = [];
  for (const file of documentationFiles()) {
    const text = fs.readFileSync(file, 'utf8');
    for (const block of text.matchAll(/^```js\s*\n([\s\S]*?)^```\s*$/gm)) {
      for (const imported of block[1].matchAll(/import\s*\{([\s\S]*?)\}\s*from\s*['"]eyeprolog['"]/g)) {
        for (const item of imported[1].split(',')) {
          const name = item.trim().split(/\s+as\s+/)[0];
          if (name && !exported.has(name)) {
            issues.push(`${path.relative(packageRoot, file)}: imports undocumented public name ${name}`);
          }
        }
      }
    }
  }
  return issues.sort();
}

function markdownAnchors(file) {
  if (!file.endsWith('.md')) return new Set();
  const text = fs.readFileSync(file, 'utf8');
  const anchors = new Set();
  const counts = new Map();
  for (const match of text.matchAll(/^#{1,6}\s+(.+)$/gm)) {
    const base = githubSlug(match[1]);
    const count = counts.get(base) ?? 0;
    counts.set(base, count + 1);
    anchors.add(count === 0 ? base : `${base}-${count}`);
  }
  for (const match of text.matchAll(/<(?:a|[A-Za-z][A-Za-z0-9:-]*)\b[^>]*\b(?:id|name)=["']([^"']+)["'][^>]*>/g)) {
    anchors.add(match[1]);
  }
  return anchors;
}

function githubSlug(heading) {
  return heading
    .replace(/`([^`]*)`/g, '$1')
    .replace(/<[^>]+>/g, '')
    .trim()
    .toLowerCase()
    .replace(/[^\p{Letter}\p{Number}\s-]/gu, '')
    .trim()
    .replace(/\s+/g, '-');
}

function between(text, startMarker, endMarker) {
  const start = text.indexOf(startMarker);
  if (start === -1) throw new Error(`${startMarker} not found`);
  const contentStart = start + startMarker.length;
  const end = text.indexOf(endMarker, contentStart);
  if (end === -1) throw new Error(`${endMarker} not found`);
  return text.slice(contentStart, end);
}

function shellQuote(value) {
  return `'${String(value).replaceAll("'", "'\"'\"'")}'`;
}

let utilLinuxScriptAvailable = null;

function hasUtilLinuxScript() {
  if (process.platform === 'win32') return false;
  if (utilLinuxScriptAvailable == null) {
    const available = spawnSync('sh', ['-c',
      'command -v script >/dev/null 2>&1 && script --version 2>/dev/null | grep -qi util-linux']);
    utilLinuxScriptAvailable = available.status === 0;
  }
  return utilLinuxScriptAvailable;
}

function runScriptedRepl(steps, { timeout = 5000 } = {}) {
  const command = `${shellQuote(process.execPath)} ${shellQuote(bin)}`;
  const payload = Buffer.from(JSON.stringify({
    command,
    cwd: packageRoot,
    steps,
    timeout,
  })).toString('base64');
  const helper = String.raw`
const { spawn } = require('node:child_process');
const config = JSON.parse(Buffer.from(process.env.EYEPROLOG_REPL_SCRIPT, 'base64').toString('utf8'));
const child = spawn('script', ['-qefc', config.command, '/dev/null'], {
  cwd: config.cwd,
  stdio: ['pipe', 'pipe', 'pipe'],
});
let stdout = '';
let stderr = '';
let cursor = 0;
let step = 0;
let finished = false;

function advance() {
  while (step < config.steps.length) {
    const current = config.steps[step];
    const index = stdout.indexOf(current.waitFor, cursor);
    if (index === -1) return;
    cursor = index + current.waitFor.length;
    child.stdin.write(current.send);
    step++;
  }
}

child.stdout.on('data', (chunk) => {
  stdout += chunk;
  advance();
});
child.stderr.on('data', (chunk) => {
  stderr += chunk;
});

const timer = setTimeout(() => {
  if (finished) return;
  finished = true;
  child.kill('SIGKILL');
  process.stdout.write(JSON.stringify({ status: null, stdout, stderr, timedOut: true, step }));
}, config.timeout);

child.on('close', (status, signal) => {
  if (finished) return;
  finished = true;
  clearTimeout(timer);
  process.stdout.write(JSON.stringify({ status, signal, stdout, stderr, timedOut: false, step }));
});
`;
  const helperResult = spawnSync(process.execPath, ['-e', helper], {
    cwd: packageRoot,
    encoding: 'utf8',
    env: { ...process.env, EYEPROLOG_REPL_SCRIPT: payload },
    timeout: timeout + 1000,
  });
  if (helperResult.error) return helperResult;
  if (helperResult.status !== 0) return helperResult;
  let result;
  try {
    result = JSON.parse(helperResult.stdout);
  } catch (error) {
    return {
      ...helperResult,
      error: new Error(`interactive REPL helper returned invalid JSON: ${error.message}`),
    };
  }
  return {
    status: result.status,
    stdout: result.stdout,
    stderr: `${result.stderr ?? ''}${helperResult.stderr ?? ''}`,
    error: result.timedOut
      ? Object.assign(new Error(`interactive REPL timed out after step ${result.step}`), { code: 'ETIMEDOUT' })
      : undefined,
  };
}

function runCli(args, options = {}) {
  return spawnSync(process.execPath, [bin, ...args], {
    cwd: options.cwd ?? packageRoot,
    encoding: 'utf8',
    env: options.env ? { ...process.env, ...options.env } : process.env,
    input: options.input ?? undefined,
    timeout: options.timeout ?? undefined,
  });
}

function arrayDiffMessages(actual, expected, label) {
  const messages = [];
  const actualSet = new Set(actual);
  const expectedSet = new Set(expected);
  for (const item of expected) if (!actualSet.has(item)) messages.push(`${label} missing ${item}`);
  for (const item of actual) if (!expectedSet.has(item)) messages.push(`${label} has unexpected ${item}`);
  if (new Set(actual).size !== actual.length) messages.push(`${label} has duplicate entries`);
  return messages;
}

function assertArrayEqual(actual, expected, label) {
  const actualText = actual.join('\n');
  const expectedText = expected.join('\n');
  if (actualText !== expectedText) {
    const onlyActual = actual.filter((item) => !expected.includes(item));
    const onlyExpected = expected.filter((item) => !actual.includes(item));
    throw new Error(`${label} mismatch\nonly actual: ${format(onlyActual)}\nonly expected: ${format(onlyExpected)}`);
  }
}

function format(value) {
  return typeof value === 'string' ? JSON.stringify(value) : String(value);
}

if (workerData?.regressionWorker) {
  startRegressionWorker();
} else if (isMainModule(import.meta.url)) {
  await runStandalone((reporter) => runRegression(reporter, process.argv[2] ?? null));
}
