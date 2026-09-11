// regressionCases: regression cases split out of run-regression.mjs.
// Case order is load-bearing (see support.mjs).
import fs from 'node:fs';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import * as publicApi from '../../src/index.js';
import { BuiltinRegistry, Env, Program, Solver, atom, compactVariableList, compound, copyResolved, createDefaultRegistry, eyePrologAmbiguousLibraryAutoload, eyePrologLibraryAutoload, eyePrologLibraryAutoloadModules, getEyePrologRegistry, getStrictIsoRegistry, listFromItems, numberTerm, numberTextFromDouble, parseProgramText, run as runEyeProlog, standardLibrarySources, termToString, unify, variable } from '../../src/index.js';
import { ISO_OPERATOR_DEFINITIONS, parseGoalText, parseNumberTokenText, tryParseClausesFastInto } from '../../src/parser.js';
import { defaultsToStdin } from '../../src/cli.js';
import { formatTermForWrite } from '../../src/write.js';
import { assertEqual, assertIncludes, assertNotIncludes } from '../test-style.mjs';
import {
  DCG_HANDOFF_TEST_TIMEOUT_MS,
  bin,
  hasUtilLinuxScript,
  packageRoot,
  pkg,
  run,
  runCli,
  runScriptedRepl,
  runWhy,
  runWhyLoose,
  sourceAtom,
  temp,
  testDirUrl,
  testRoot,
} from './support.mjs';

export function regressionCases() {
  return [
    {
      name: 'close/1 accepts a $stream/1 term rebuilt via functor/3 and arg/3 that is structurally == to the real handle (issue #109)',
      run: () => {
        const file = sourceAtom(path.join(temp.dir, `stream-109-${++temp.counter}.txt`));
        const result = runCli([], { input:
          `open(${file},write,S),functor(S,Fn,A),functor(S2,Fn,A),arg(1,S,A1),arg(1,S2,A1),S==S2,close(S2).\n` +
          'halt.\n',
        });
        assertEqual(result.status, 0, result.stderr);
        // S2's argument only becomes the real stream number through
        // unification rather than being built in place by open/3, so
        // close/1 must deref it like any other compound argument instead of
        // rejecting an equally valid, structurally-== stream reference as
        // malformed.
        assertNotIncludes(result.stdout + result.stderr, 'error(', 'no domain_error(stream_or_alias, ...) from close/1');
        assertIncludes(result.stdout, 'A1 = ', 'query succeeds and reports the shared stream number');
      },
    },
    {
      name: 'close/1 raises instantiation_error, not domain_error(stream_or_alias), for a $stream/1 term whose argument is unbound (issue #109 follow-up)',
      run: () => {
        const result = runCli([], { input:
          "S='$stream'(X),close(S).\nhalt.\n",
        });
        assertEqual(result.status, 0, result.stderr);
        // The argument that would identify the stream is still unbound, so
        // whether this term is a valid stream reference cannot be decided
        // yet — that calls for instantiation_error, not a domain_error
        // claiming the term itself is already known to be invalid.
        assertIncludes(result.stdout, 'error(instantiation_error,', 'unbound $stream/1 argument reports instantiation_error');
        assertNotIncludes(result.stdout, 'domain_error(stream_or_alias', 'no domain_error(stream_or_alias, ...) once the argument is still unbound');
      },
    },
    {
      name: 'top level never mints a generated variable name that collides with a query variable\'s own name (issue #108)',
      run: () => {
        const result = runCli([], { input: 'length(L,1),_A=99.\nhalt.\n' });
        assertEqual(result.status, 0, result.stderr);
        // `_A` is a real query variable here, not the top level's own first
        // generated name. Printing the anonymous variable inside L as `_A` as
        // well would misleadingly suggest it is the same variable as the
        // query's own `_A`, which is bound to 99 and unrelated to L.
        assertIncludes(result.stdout, '?-    L = [_B], _A = 99.\n', 'generated name skips the query\'s own _A');
      },
    },
    {
      name: 'REPL current_input/1 and current_output/1 fail on closed stream handles (issue #107)',
      run: () => {
        const file = sourceAtom(path.join(temp.dir, 'closed-stream-107.txt'));
        const result = runCli([], { input:
          `open(${file},write,S),close(S),current_input(S).\n` +
          `open(${file},write,S),close(S),current_output(S).\nhalt.\n`,
        });
        assertEqual(result.status, 0, result.stderr);
        assertEqual((result.stdout.match(/false\./g) ?? []).length, 2, 'both closed-handle queries fail');
        assertNotIncludes(result.stdout + result.stderr, 'error(', 'no stream domain error');
      },
    },
    {
      name: 'must_be/2 and can_be/2 reject invalid type descriptors before checking values (issue #106)',
      run: () => {
        for (const predicate of ['must_be', 'can_be']) {
          for (const type of ['nontype', '42', 'foo(integer)', 'list(nontype)', 'list(list(nontype))']) {
            const culprit = type.startsWith('list(') ? 'nontype' : type;
            for (const value of ['0', 'X', '[]']) {
              const result = runEyeProlog(`answer(ok) :- catch((${predicate}(${type},${value}),fail),error(type_error(type,${culprit}),[predicate-${predicate}/2]),true),var(X).`, { goals: ['answer(X)'] });
              assertIncludes(result.stdout, 'answer(ok)', `${predicate}(${type},${value})`);
            }
          }
          for (const type of ['T', 'list(T)', 'list(list(T))']) {
            const result = runEyeProlog(`answer(ok) :- catch((${predicate}(${type},[]),fail),error(instantiation_error,[predicate-${predicate}/2]),true),var(T).`, { goals: ['answer(X)'] });
            assertIncludes(result.stdout, 'answer(ok)', `${predicate}(${type},[])`);
          }
        }
        const valid = [
          ['integer', '1'], ['atom', 'a'], ['number', '1.5'], ['var', 'X'],
          ['ground', 'f(a)'], ['acyclic', 'f(X)'], ['list', '[X]'],
          ['character', 'a'], ['chars', '[a,b]'], ['pair', 'a-b'],
          ['not_less_than_zero', '0'], ['list(integer)', '[1,2]'],
          ['list(list(integer))', '[[1],[]]'],
        ];
        for (const [type, value] of valid) {
          const result = runEyeProlog(`answer(ok) :- must_be(${type},${value}),can_be(${type},${value}),can_be(${type},Fresh),var(Fresh).`, { goals: ['answer(X)'] });
          assertIncludes(result.stdout, 'answer(ok)', `supported type ${type}`);
        }
        const context = runEyeProlog('answer(ok) :- catch((call_with_error_context(can_be(nontype,X),outer-1),fail),error(type_error(type,nontype),[outer-1,predicate-can_be/2]),true),var(X).', { goals: ['answer(X)'] });
        assertIncludes(context.stdout, 'answer(ok)', 'composable error context');
      },
    },
    {
      name: 'forward bundled append/3 matches the portable relation across sharing and fallback modes',
      run: () => {
        const goals = [
          'append([],Y,Z),Y=tail',
          'append([X,Y],[Y,X],Z),X=a,Y=b',
          'append([X],T,Z),T=[X|Rest],Rest=tail',
          'append([a,b],tail,Z)',
          'append([X],[],X)',
          'append([a],Z,Z)',
          'append([X],[],Z),X=Z',
          'append([a],T,Z),T=Z',
          'append([a],[],[b])',
          'append([a|T],[b],[a,c,b])',
          'append([a|bad],[],Z)',
          'append(X,Y,[a,b])',
          '(append([a],[],Z);append([b],[],Z))',
          'freeze(X,Y=woke),append([X],[],Z),X=a',
          'dif(X,a),append([X],[],Z),X=b',
          'set_prolog_flag(occurs_check,error),catch(append([X],[],X),error(E,_),true)',
        ];
        for (const goal of goals) {
          const source = `answer(X,Y,Z,T,Rest,E) :- ${goal}.`;
          const options = { goals: ['answer(X,Y,Z,T,Rest,E)'] };
          const optimized = runEyeProlog(source, options);
          const portable = runEyeProlog(
            'portable_append([],Ys,Ys). portable_append([X|Xs],Ys,[X|Zs]) :- portable_append(Xs,Ys,Zs).\n' +
            source.replaceAll('append(', 'portable_append('), options);
          assertEqual(optimized.stdout, portable.stdout, goal);
          assertEqual(optimized.stderr, portable.stderr, `${goal} diagnostics`);
        }
        const custom = runEyeProlog('append(custom,_,ok).', { goals: ['append(custom,[],Z)'] });
        assertIncludes(custom.stdout, 'append(custom, [], ok)', 'user definition');
      },
    },
    {
      name: 'forward append/3 constructs long shared-variable lists within a bounded heap and time',
      run: () => {
        const script = `
          import {run} from './src/index.js';
          const result=run('answer(ok) :- length(P,8192),append(P,[1],L1),append(P,[2],L2),compare(R,L1,L2),compare_si(S,L1,L2),R==(<),S==(<).', {goals:['answer(X)']});
          if (!result.stdout.includes('answer(ok)')) throw new Error(result.stdout+'\\n'+result.stderr);
          console.log('ok');
        `;
        const result = spawnSync(process.execPath, ['--max-old-space-size=128', '--stack-size=256', '--input-type=module', '--eval', script], {
          cwd: packageRoot, encoding: 'utf8', timeout: 10000,
        });
        if (result.error) throw result.error;
        assertEqual(result.status, 0, result.stderr);
        assertIncludes(result.stdout, 'ok', 'long forward append');
      },
    },
    {
      name: 'autoload follows declared meta-predicates and closure arities (issue #105)',
      run: () => {
        const wrappers = ':- meta_predicate(mytime(0)).\nmytime(G) :- time(G).\n' +
          ':- meta_predicate(apply_one(1,?)).\napply_one(G,X) :- call(G,X).\n';
        for (const goal of ['mytime(mytime(compare_si(<,a,b)))',
          'apply_one(compare_si(<,a),b)', 'call(compare_si(<),a,b)', 'time(compare_si(<,a,b))']) {
          const result = runEyeProlog(wrappers, { goals: [goal] });
          assertIncludes(result.stdout, goal.startsWith('apply_one') ? 'apply_one' : goal.split('(')[0], goal);
        }
        const initialized = runEyeProlog(wrappers + ':- initialization((mytime(compare_si(<,a,b)),write(ok))).', { goals: [] });
        assertIncludes(initialized.stdout, 'ok', 'initialization meta-goal');
        // A predicate with the same name as a library wrapper can take data.
        const data = Program.parse('time(_). answer :- time(compare_si(O,a,b)).');
        assertEqual(data.autoloadedPredicates.some(({ indicator }) => indicator === 'compare_si/3'), false, 'data argument is not a goal');
      },
    },
    {
      name: 'imported user meta-wrappers autoload caller goals on the first REPL invocation',
      run: () => {
        const file = path.join(temp.dir, 'mytime.pl');
        fs.writeFileSync(file, ':- module(timing_wrapper,[mytime/1]).\n:- meta_predicate(mytime(0)).\nmytime(G) :- time(G).\n');
        const source = `:- use_module(${sourceAtom(file)}).\nanswer(ok) :- mytime(compare_si(<,a,b)).\n`;
        assertIncludes(runEyeProlog(source, { goals: ['answer(X)'] }).stdout, 'answer(ok)', 'imported wrapper');
        const repl = runCli([], { input: `use_module(${sourceAtom(file)}).\nmytime(compare_si(O,a,b)).\n.\nhalt.\n` });
        assertEqual(repl.status, 0, repl.stderr);
        assertIncludes(repl.stdout, 'O = (<)', 'first meta-call');
        assertNotIncludes(repl.stdout + repl.stderr, 'existence_error', 'meta autoload');
      },
    },
    {
      name: 'bundled compare_si/3 matches the portable definition and respects user definitions',
      run: () => {
        const terms = ['X', 'Y', '1', '1.0', '-2', 'a', 'b', '[]', '[X,a]', '[X|Y]',
          'f(X)', 'f(Y)', 'g(X)', 'f(X,a)', 'f(X,b)', 'f(g(X),a)'];
        const clauses = [];
        for (const left of terms) for (const right of terms) {
          clauses.push(`answer(${clauses.length},R) :- catch((compare_si(O,${left},${right})->R=O;R=failed),error(E,C),R=error(E,C)).`);
        }
        const source = clauses.join('\n');
        const optimized = runEyeProlog(source, { goals: ['answer(I,R)'] });
        const portable = runEyeProlog(source, { goals: ['answer(I,R)'], registry: createDefaultRegistry() });
        assertEqual(optimized.stdout, portable.stdout, 'all scalar, variable, compound and list comparisons');
        const custom = runEyeProlog('compare_si(custom,_,_).', { goals: ['compare_si(O,a,b)'] });
        assertIncludes(custom.stdout, 'compare_si(custom, a, b)', 'user definition');
      },
    },
    {
      name: 'compare/3 and compare_si/3 compare large lists and deep terms with a bounded host stack',
      run: () => {
        // A separate process bounds regressions in both memory and time. Build
        // the operands directly so this measures comparison, not append/3.
        const script = `
          import {Program,Solver,Env,getEyePrologRegistry,variable,atom,compound,listFromItems,termToString} from './src/index.js';
          const program = Program.parse(':- use_module(library(si)).');
          const solver = new Solver(program,{registry:getEyePrologRegistry()});
          function check(a,b,expected) {
            for(const name of ['compare','compare_si']) {
              const order=variable('Order');
              const answers=[...solver.solve([compound(name,[order,a,b])],new Env(),0)];
              if (answers.length!==1 || termToString(order,answers[0])!==expected) throw new Error(name+': wrong order');
            }
          }
          for (const n of [16384,65536]) {
            const prefix=Array.from({length:n},(_,i)=>variable('X'+i));
            const a=listFromItems([...prefix,atom('a')]);
            const b=listFromItems([...prefix,atom('b')]);
            check(a,b,'<'); check(b,a,'>');
            check(a,listFromItems([...prefix,atom('a')]),'=');
          }
          let a=atom('a'), b=atom('b');
          for(let i=0;i<16384;i++) {a=compound('f',[a]);b=compound('f',[b]);}
          check(a,b,'<');
          console.log('ok');
        `;
        const result = spawnSync(process.execPath, ['--max-old-space-size=128', '--stack-size=256', '--input-type=module', '--eval', script], {
          cwd: packageRoot, encoding: 'utf8', timeout: 15000,
        });
        if (result.error) throw result.error;
        assertEqual(result.status, 0, `large comparison: ${result.stderr}`);
        assertIncludes(result.stdout, 'ok', 'large comparison completes');
      },
    },
    {
      name: 'REPL prints the complete 8192-cell timed comparison answer (issue #105)',
      run: () => {
        // Keep the large variable-list answer that overflowed REPL printing,
        // but prepend the differing elements to avoid expensive append/3 setup.
        // The adjacent cases cover long shared-prefix comparison and append/3
        // backtracking separately.
        const result = runCli([], { input:
          'length(_,I),I=13,N is 2^I,length(P,N),L1=[1|P],L2=[2|P],' +
          'time(compare(R,L1,L2)),time(compare_si(S,L1,L2)).\n.\nhalt.\n',
          timeout: 60000,
        });
        if (result.error) throw result.error;
        assertEqual(result.status, 0, result.stderr);
        assertNotIncludes(result.stdout + result.stderr, 'Maximum call stack', 'host stack');
        assertIncludes(result.stdout, 'I = 13, N = 8192', 'large answer');
        assertIncludes(result.stdout, 'R = (<), S = (<)', 'both comparison results');
      },
    },
    {
      name: 'timed compare_si/3 backtracks over growing prefixes without exhausting the host stack (issue #105)',
      run: () => {
        // Bound the reported generator so the regression exhausts every
        // answer, including sizes beyond the original 256-cell failure.
        const result = runCli(['-'], { input:
          '%% goal: answer(I,R,S)\n' +
          'answer(I,R,S) :- length(_,I), (I =< 9 -> true ; !, fail), ' +
          'N is 2^I, length(P,N), append(P,[1],L1), append(P,[2],L2), ' +
          'time(compare(R,L1,L2)), time(compare_si(S,L1,L2)).\n',
          timeout: 20000,
        });
        assertEqual(result.status, 0, `exit status; error=${result.error}; stderr=${result.stderr}`);
        for (let i = 0; i <= 9; i++) {
          assertIncludes(result.stdout, `answer(${i}, <, <).`, 'comparison result');
        }
        assertNotIncludes(result.stderr + result.stdout, 'Maximum call stack', 'host stack');
      },
    },
    {
      name: 'compare_si/3 work list preserves argument priority and instantiation errors',
      run: () => {
        const goals = [
          'compare_si(=,f(X,g(Y)),f(X,g(Y))),var(X),var(Y)',
          'compare_si(<,f(g(X),a),f(g(X),b)),var(X)',
          'compare_si(>,f(g(b),a),f(g(a),z))',
          'compare_si(<,[a|X],[b|Y]),var(X),var(Y)',
          'compare_si(>,f(X),a),var(X)',
          'compare_si(<,a,f(X)),var(X)',
          '\\+ compare_si(>,f(g(X),a),f(g(X),b))',
          'catch((compare_si(_,f(g(X),a),f(g(Y),b)),fail),error(instantiation_error,[predicate-compare_si/3]),true),var(X),var(Y)',
        ];
        for (const goal of goals) {
          const result = runEyeProlog(`answer(ok) :- ${goal}.`, { goals: ['answer(X)'] });
          assertIncludes(result.stdout, 'answer(ok)', goal);
        }
      },
    },
    {
      name: 'compare_si/3 validates Order before term instantiation (issue #100)',
      run: () => {
        for (const terms of ['A,B', 'A,A', '1,2']) {
          for (const [order, formal] of [['x', 'domain_error(order, x)'], ['1', 'type_error(atom, 1)']]) {
            const result = runCli([], { input: `compare_si(${order},${terms}).\nhalt.\n` });
            assertIncludes(result.stdout, `error(${formal}, [predicate-compare_si/3])`, 'order error');
          }
        }
      },
    },
    {
      name: 'list and chars type checks preserve partial lists and report precise errors (issues #102 and #103)',
      run: () => {
        const goals = [
          'catch(must_be(list,L),error(instantiation_error,[predicate-must_be/2]),true),var(L)',
          'catch(must_be(list,[a|L]),error(instantiation_error,[predicate-must_be/2]),true),var(L)',
          'catch(must_be(list(integer),L),error(instantiation_error,[predicate-must_be/2]),true),var(L)',
          'catch(must_be(list(integer),[1|L]),error(instantiation_error,[predicate-must_be/2]),true),var(L)',
          'must_be(list,[X]),var(X)',
          'must_be(chars,[a,b])',
          'catch(must_be(chars,[C]),error(instantiation_error,[predicate-must_be/2]),true),var(C)',
          'catch(must_be(chars,[C,ab]),error(type_error(character,ab),[predicate-must_be/2]),true),var(C)',
          'can_be(chars,[C|L]),var(C),var(L)',
          'can_be(list(integer),[C|L]),var(C),var(L)',
          'catch(can_be(chars,[C|1]),error(type_error(list,[D|1]),[predicate-can_be/2]),true),var(C),var(D)',
          'catch(must_be(chars,[C|1]),error(type_error(list,[D|1]),[predicate-must_be/2]),true),var(C),var(D)',
          'catch(can_be(chars,[ab|L]),error(type_error(character,ab),[predicate-can_be/2]),true),var(L)',
          'catch(can_be(pair,a),error(type_error(pair,a),[predicate-can_be/2]),true)',
          'catch(can_be(integer,a),error(type_error(integer,a),[predicate-can_be/2]),true)',
        ];
        for (const goal of goals) {
          const result = runCli(['-'], { input: `:- use_module(library(error)).\n%% goal: answer(X)\nanswer(ok) :- ${goal}.\n` });
          assertEqual(result.status, 0, `${goal}: ${result.stderr}`);
          assertIncludes(result.stdout, 'answer(ok)', goal);
        }
      },
    },
    {
      name: 'call_with_error_context/2 preserves repeated variables in context pairs (issue #104)',
      run: () => {
        const result = runCli(['-'], { input: ':- use_module(library(error)).\n%% goal: answer(X)\n' +
          'answer(ok) :- catch(call_with_error_context(throw(error(problem(X),[inner-X])),outer-f(Y,Y)),error(problem(A),[outer-f(B,C),inner-D]),true),B==C,A==D,var(Y).\n' });
        assertEqual(result.status, 0, result.stderr);
        assertIncludes(result.stdout, 'answer(ok)', 'shared error variables');
      },
    },
    {
      name: 'time/1 autoloads compare_si/3 on its first call (issue #105)',
      run: () => {
        const goal = 'length(P,8),append(P,[1],L1),append(P,[2],L2),time(compare(R,L1,L2)),time(compare_si(S,L1,L2))';
        const repl = runCli([], { input: `${goal}.\n.\nhalt.\n` });
        assertNotIncludes(repl.stdout, 'existence_error', 'first REPL call');
        assertIncludes(repl.stdout, 'S = (<)', 'timed comparison');
        const file = runCli(['-'], { input: `%% goal: answer(X)\nanswer(ok) :- ${goal},R==S.\n` });
        assertEqual(file.status, 0, file.stderr);
        assertIncludes(file.stdout, 'answer(ok)', 'file autoload');
      },
    },
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

        const residualFile = path.join(temp.dir, `atts-residual-${++temp.counter}.pl`);
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

        const hiddenResidualFile = path.join(temp.dir, `atts-hidden-residual-${++temp.counter}.pl`);
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
        // The reported line is the answer description's own line (2), not the
        // query's (1), so a failure among many descriptions stays easy to
        // find (issue #110).
        assertIncludes(nonGround.stdout, 'quads: BAD_ID Id, <input>:2', 'non-ground id diagnostic');
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
        const engineUrl = new URL('../src/index.js', testDirUrl).href;
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
          '?-    error(type_error(callable, (write(3),3)), []).\n' +
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

        const bufferedPath = path.join(temp.dir, 'graphic-atom-boundary.pl');
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
        assertIncludes(repl.stdout, 'error(syntax_error(read_term), [predicate-read/1])', 'REPL syntax error');
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
      name: 'runQuads passes the complete vendored Prolog Prologue corpus, with one documented max_integer divergence',
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

        // The full 33-quad corpus, including its two STO examples
        // (member(X,X) and select(E,Xs,Xs), both open-ended native-generator
        // searches -- see the maxInferences accounting added to
        // generatedLengthAllocationCheckpoint in src/solver.js) is bounded and
        // takes on the order of several seconds, not the indefinite hang it
        // used to depend on ambient heap pressure to avoid (see
        // Solver#reclaimMemory in src/solver.js).
        const result = publicApi.runQuads(program);
        // The upstream working-draft max_integer quad accepts either integer
        // overflow or Max=unbounded. EyeProlog reports no value for
        // max_integer when bounded=false, so
        // current_prolog_flag(max_integer, N) fails. Part 1 does not mandate
        // that outcome, so this is an implementation choice rather than a
        // standards requirement. Preserve the upstream fixture unchanged and
        // record the one deliberate divergence explicitly.
        assertEqual(result.total, 33, 'quad total');
        assertEqual(result.passed, 32, 'quad passed');
        assertEqual(result.failed, 1, 'quad failed');
        assertIncludes(result.stdout, 'current_prolog_flag(max_integer, Max)', 'max_integer divergence');
        assertIncludes(result.stdout, 'quads: 33 run, 32 passed, 1 failed.', 'quad report');
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
        const result = runCli(['-q', filename], { cwd: temp.dir });
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
        assertIncludes(result.stdout, 'quads: MALFORMED malformed-quad.pl:2', 'malformed report');
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
          'quads: UNDECIDED 24, passes / too_expensive, <stdin>:3',
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
        assertIncludes(nsto.stdout, 'quads: FAILED 34, <input>:3', 'NSTO diagnostic');
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
        assertIncludes(failing.stdout, 'quads: FAILED smoke, <stdin>:4', 'failing quad report');
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
          '?-    error(type_error(list, [1, [], _A | 2]), [predicate-number_chars/2]).\n' +
          '?-    error(type_error(list, [1, [], _A | 2]), [predicate-number_chars/2]).\n' +
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
          '?-    error(instantiation_error, [predicate-(is)/2]).\n' +
          '?-    Error = instantiation_error, Imp_def = [predicate-(is)/2].\n' +
          '?- ',
          'stdout');
        assertEqual(result.stderr, '', 'stderr');
      },
    },
    {
      name: 'occurs_check error mode reports representation_error(term) while ISO occurs-check unification still fails',
      run: () => {
        const filename = path.join(temp.dir, `occurs-check-${++temp.counter}.pl`);
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
        const engineUrl = new URL('../src/index.js', testDirUrl).href;
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
        const engineUrl = new URL('../src/index.js', testDirUrl).href;
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
        const filename = path.join(temp.dir, `issue49-small-handoff-${temp.counter++}.pl`);
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
        const engineUrl = new URL('../src/index.js', testDirUrl).href;
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
        const filename = path.join(temp.dir, `issue49-handoff-${temp.counter++}.pl`);
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
        const filename = path.join(temp.dir, `issue49-handoff-deep-${temp.counter++}.pl`);
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
        const filename = path.join(temp.dir, `repl-consult-${++temp.counter}.pl`);
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
        const stem = path.join(temp.dir, `repl-consult-order-${++temp.counter}`);
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
        const filename = path.join(temp.dir, `repl-reconsult-${++temp.counter}.pl`);
        fs.writeFileSync(filename, 'factum(f).\n');
        const harness = path.join(temp.dir, `repl-reconsult-harness-${++temp.counter}.mjs`);
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
        const filename = path.join(temp.dir, `repl-consult-predicate-${++temp.counter}.pl`);
        fs.writeFileSync(filename, 'factum(f).\n');
        const harness = path.join(temp.dir, `repl-consult-predicate-harness-${++temp.counter}.mjs`);
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
        const filename = path.join(temp.dir, `repl-empty-${++temp.counter}.pl`);
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
          '?-    error(existence_error(procedure, missing_after_consult/0), []).\n' +
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
        const prefix = path.join(temp.dir, `npm-prefix-${++temp.counter}`);
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
        const programFile = path.join(temp.dir, `proof-program-${++temp.counter}.pl`);
        const proofFile = path.join(temp.dir, `proof-certificate-${++temp.counter}.pl`);
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
        const tamperedFile = path.join(temp.dir, `proof-certificate-bad-${++temp.counter}.pl`);
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
          'error(domain_error(statistics_key, nonsense), [predicate-statistics/2]).',
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
      // A user clause for a bundled-library indicator suppresses the autoload,
      // so other user code in the same program silently gets the user's
      // definition instead of the library one (issue #97 follow-up).
      name: 'autoload shadowing is reported without opting in to --warnings',
      run: () => {
        const input = '%% goal: answer(X)\nappend(left, right, joined).\np(a).\nanswer(ok) :- p(a).\n';
        const result = runCli(['-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertEqual(result.stdout, 'answer(ok).\n', 'stdout');
        assertIncludes(result.stderr, 'shadows a bundled library predicate', 'shadowing warning');
        assertIncludes(result.stderr, 'append/3 replaces library(lists) append/3', 'shadowed indicator');
      },
    },
    {
      // Whole-module import keeps the library predicate a weak symbol, so a
      // local definition overrides it with a warning rather than an error.
      name: 'whole-module library import still allows a warned local override',
      run: () => {
        const input = ':- use_module(library(lists)).\n%% goal: answer(X)\nappend(left, right, joined).\np(a).\nanswer(ok) :- p(a).\n';
        const result = runCli(['-'], { input });
        assertEqual(result.status, 0, `exit status; stderr=${result.stderr}`);
        assertIncludes(result.stderr, 'shadows a bundled library predicate', 'shadowing warning');
      },
    },
    {
      // Naming the predicate in the import list and then defining it is a
      // contradiction, so it is a permission_error rather than a warning.
      name: 'explicitly imported library predicates cannot be redefined',
      run: () => {
        const input = ':- use_module(library(lists), [append/3]).\n%% goal: answer(X)\nappend(left, right, joined).\nanswer(ok).\n';
        const result = runCli(['-'], { input });
        assertEqual(result.status, 1, 'exit status');
        assertIncludes(result.stderr, 'permission_error(modify, static_procedure)', 'permission error');
        assertIncludes(result.stderr, 'append', 'culprit indicator');
      },
    },
    {
      // Shadowing is only reported for predicates a bundled library actually
      // exports, so ordinary user predicates stay quiet.
      name: '--warnings stays quiet for user predicates that shadow nothing',
      run: () => {
        const input = '%% goal: answer(X)\nmy_own_join(a, b, ab).\nanswer(ok) :- my_own_join(a, b, _ab).\n';
        const result = runCli(['--warnings', '-'], { input });
        assertEqual(result.status, 0, 'exit status');
        assertNotIncludes(result.stderr, 'shadows a bundled library predicate', 'no shadowing warning');
      },
    },
    {
      // The library keeps resolving its own internal calls, so a shadowing
      // user definition must not change library behaviour (issue #97).
      name: 'user definitions do not leak into bundled library internals',
      run: () => {
        const input = '%% goal: answer(X)\nappend(left, right, joined).\nanswer(L) :- append([[1,2],[3]], L).\n';
        const result = runCli(['-'], { input });
        assertEqual(result.status, 0, `exit status; stderr=${result.stderr}`);
        assertIncludes(result.stdout, 'answer([1, 2, 3])', 'library append/2 still uses the library append/3');
      },
    },
    {
      // Directives come from a fixed list, so an unrecognized one is a
      // different mistake from unparseable input and gets its own message
      // instead of the generic parser 'bad term'.
      name: 'unsupported directives report why they were rejected',
      run: () => {
        const goalDirective = runCli(['-'], { input: ':- write(hello), nl.\n' });
        assertEqual(goalDirective.status, 1, 'goal directive status');
        assertIncludes(goalDirective.stderr, 'unknown directive write/1', 'goal directive indicator');
        assertIncludes(goalDirective.stderr, 'initialization(Goal)', 'goal directive remedy');
        assertNotIncludes(goalDirective.stderr, 'bad term', 'no generic parser message');

        const misspelt = runCli(['-'], { input: ':- dynamc(foo/1).\n' });
        assertEqual(misspelt.status, 1, 'misspelt status');
        assertIncludes(misspelt.stderr, 'did you mean dynamic?', 'near-miss suggestion');

        const wrongArity = runCli(['-'], { input: ':- dynamic(foo/1, bar).\n' });
        assertEqual(wrongArity.status, 1, 'wrong arity status');
        assertIncludes(wrongArity.stderr, 'expected dynamic/1', 'arity guidance');

        const notCallable = runCli(['-'], { input: ':- 42.\n' });
        assertEqual(notCallable.status, 1, 'non-callable status');
        assertIncludes(notCallable.stderr, 'must be a callable term', 'callable guidance');
      },
    },
    {
      // Genuinely malformed input must keep reporting a syntax error rather
      // than being misreported as a directive problem.
      name: 'malformed terms still report a parse error',
      run: () => {
        const result = runCli(['-'], { input: 'foo(1). bar(\n' });
        assertEqual(result.status, 1, 'exit status');
        assertIncludes(result.stderr, 'parse line', 'parse error');
        assertNotIncludes(result.stderr, 'unknown directive', 'not a directive message');
      },
    },
    {
      // Issue #98: error contexts are lists of context elements, so a built-in
      // error composes with library(error)'s call_with_error_context/2 into a
      // proper list instead of the improper [Element|eyeprolog] it used to be.
      name: 'error contexts compose into proper lists (issue #98)',
      run: () => {
        const input = ':- use_module(library(error)).\n%% goal: answer(X)\n' +
          'answer(C) :- catch(call_with_error_context(atom_length(1.0,_), outer-1), error(_,C), true).\n';
        const result = runCli(['-'], { input });
        assertEqual(result.status, 0, `exit status; stderr=${result.stderr}`);
        assertIncludes(result.stdout, 'answer([outer - 1, predicate - atom_length / 2])', 'composed context');
      },
    },
    {
      // Issue #98: library predicates declare their context once with
      // call_with_error_context/2 rather than handing it over manually at each
      // raise site. Manual handover produced a bare, non-list context, so it
      // composed into an improper list.
      name: 'library predicates yield composable contexts, not manual ones',
      run: () => {
        const input = ':- use_module(library(error)).\n:- use_module(library(random)).\n%% goal: answer(X)\n' +
          'answer(C) :- catch(must_be(integer, a), error(_,C), true).\n';
        const result = runCli(['-'], { input });
        assertEqual(result.status, 0, `exit status; stderr=${result.stderr}`);
        assertIncludes(result.stdout, 'answer([predicate - must_be / 2])', 'must_be context is a list');

        const composed = ':- use_module(library(error)).\n%% goal: answer(X)\n' +
          'answer(C) :- catch(call_with_error_context(must_be(integer, a), outer-1), error(_,C), true).\n';
        const nested = runCli(['-'], { input: composed });
        assertEqual(nested.status, 0, `nested exit status; stderr=${nested.stderr}`);
        assertIncludes(nested.stdout, 'answer([outer - 1, predicate - must_be / 2])', 'composes as a proper list');
      },
    },
    {
      // An error/2 ball raised by Prolog throw/1 is the same thing a built-in
      // raises, so the top level must display it the same way. Only balls
      // without an error/2 envelope keep the throw/1 wrapper.
      name: 'uncaught error/2 balls display without a throw/1 wrapper',
      run: () => {
        const repl = runCli([], {
          input: 'must_be(integer, a).\nthrow(foo).\nhalt.\n',
        });
        assertIncludes(repl.stdout, 'error(type_error(integer, a), [predicate-must_be/2])', 'thrown ISO error');
        assertNotIncludes(repl.stdout, 'throw(error(type_error', 'no throw/1 wrapper on error/2');
        assertIncludes(repl.stdout, 'throw(foo)', 'non-error ball keeps the wrapper');
      },
    },
    {
      // must_be/2 is called constantly by library code, so its context must be
      // supplied without a catch/3 frame: wrapping a Prolog goal in catch/3
      // costs a child Solver per call and made the suite ~35% slower.
      name: 'must_be/2 does not pay for a catch frame on success',
      run: () => {
        const input = '%% goal: answer(X)\n' +
          'loop(0) :- !.\nloop(N) :- must_be(integer, N), M is N - 1, loop(M).\n' +
          'answer(ok) :- loop(20000).\n';
        const started = Date.now();
        const result = runCli(['-'], { input });
        const elapsed = Date.now() - started;
        assertEqual(result.status, 0, `exit status; stderr=${result.stderr}`);
        assertIncludes(result.stdout, 'answer(ok)', 'loop completes');
        // Generous bound: the catch/3 wrapper made this roughly 2x slower.
        if (elapsed >= 20000) throw new Error(`20k must_be/2 calls took ${elapsed}ms`);
      },
    },
    {
      // The pair check runs on every call_with_error_context/2 call, so it is
      // written as indexed clauses. An if-then-else costs several times what
      // clause selection does, and this guard used to dominate the wrapper.
      name: 'call_with_error_context/2 pair check stays off the hot path',
      run: () => {
        const input = '%% goal: answer(X)\np(X) :- integer(X).\n' +
          'loop(0) :- !.\nloop(N) :- call_with_error_context(p(N), c-1), M is N - 1, loop(M).\n' +
          'answer(ok) :- loop(20000).\n';
        const started = Date.now();
        const result = runCli(['-'], { input });
        const elapsed = Date.now() - started;
        assertEqual(result.status, 0, `exit status; stderr=${result.stderr}`);
        assertIncludes(result.stdout, 'answer(ok)', 'loop completes');
        if (elapsed >= 20000) throw new Error(`20k wrapped calls took ${elapsed}ms`);
      },
    },
    {
      name: 'sufficient-instantiation list checks reject unknown tails without binding elements',
      run: () => {
        const input = ':- use_module(library(si)).\n%% goal: answer(X)\n' +
          'answer(ok) :- ' +
          'catch(list_si(X), error(instantiation_error,_), C1 = caught), C1 == caught, var(X), ' +
          'catch(list_si([a|T]), error(instantiation_error,_), C2 = caught), C2 == caught, var(T), ' +
          'catch(chars_si(Cs), error(instantiation_error,_), C3 = caught), C3 == caught, var(Cs), ' +
          'catch(chars_si([a|Tail]), error(instantiation_error,_), C4 = caught), C4 == caught, var(Tail), ' +
          'list_si([]), list_si([Element]), var(Element), chars_si([a,b]), ' +
          '\\+ list_si([a|bad]), \\+ chars_si([ab]).\n';
        const result = runCli(['-'], { input });
        assertEqual(result.status, 0, `exit status; stderr=${result.stderr}`);
        assertIncludes(result.stdout, 'answer(ok)', 'list checks preserve sufficient instantiation');
      },
    },
    {
      // Issue #100: compare_si/3 decides the standard order only when no
      // instantiation could change it, and raises instantiation_error as
      // rarely as possible.
      name: 'compare_si/3 decides the order only when instantiation cannot change it',
      run: () => {
        const decided = [
          ['compare_si(O, 1, a)', '<'],
          ['compare_si(O, X, X)', '='],
          ['compare_si(O, f(X), g(Y))', '<'],
          ['compare_si(O, f(X,a), f(X,b))', '<'],
          ['compare_si(O, f(a,b), f(a,b,c))', '<'],
          ['compare_si(O, [a|X], [b|Y])', '<'],
          ['compare_si(O, 1, 1.0)', '>'],
        ];
        for (const [goal, order] of decided) {
          const input = ':- use_module(library(si)).\n%% goal: answer(X)\n' +
            `answer(O) :- ${goal}.\n`;
          const result = runCli(['-'], { input });
          assertEqual(result.status, 0, `${goal} status; stderr=${result.stderr}`);
          assertIncludes(result.stdout, `answer(${order})`, `${goal} order`);
        }
        for (const goal of ['compare_si(O, X, 1)', 'compare_si(O, f(a), f(Y))',
          'compare_si(O, X, Y)', 'compare_si(O, [a|X], [a|Y])']) {
          const input = ':- use_module(library(si)).\n%% goal: answer(X)\n' +
            `answer(E) :- catch(${goal}, error(E,_), true).\n`;
          const result = runCli(['-'], { input });
          assertEqual(result.status, 0, `${goal} status; stderr=${result.stderr}`);
          assertIncludes(result.stdout, 'answer(instantiation_error)', `${goal} is undecided`);
        }
      },
    },
    {
      // compare_si/3 must not bind anything while deciding.
      name: 'compare_si/3 leaves its arguments unbound',
      run: () => {
        const input = ':- use_module(library(si)).\n%% goal: answer(X)\n' +
          'answer(ok) :- X = f(Y), compare_si(<, X, g(1)), var(Y).\n';
        const result = runCli(['-'], { input });
        assertEqual(result.status, 0, `exit status; stderr=${result.stderr}`);
        assertIncludes(result.stdout, 'answer(ok)', 'no bindings made');
      },
    },
    {
      // Issue #99: the context element must be a pair, as in Scryer and
      // Trealla, and predicate contexts use the predicate-F/A convention.
      name: 'call_with_error_context/2 requires a pair as its context element',
      run: () => {
        const bad = ':- use_module(library(error)).\n%% goal: answer(X)\n' +
          'answer(C) :- catch(call_with_error_context(true, x), error(E,_), C = E).\n';
        const result = runCli(['-'], { input: bad });
        assertEqual(result.status, 0, `exit status; stderr=${result.stderr}`);
        assertIncludes(result.stdout, 'answer(type_error(pair, x))', 'non-pair element rejected');

        const unbound = ':- use_module(library(error)).\n%% goal: answer(X)\n' +
          'answer(C) :- catch(call_with_error_context(true, _), error(E,_), C = E).\n';
        const varResult = runCli(['-'], { input: unbound });
        assertIncludes(varResult.stdout, 'answer(instantiation_error)', 'unbound element rejected');

        const good = ':- use_module(library(error)).\n%% goal: answer(X)\n' +
          'answer(ok) :- call_with_error_context(true, a-b).\n';
        const okResult = runCli(['-'], { input: good });
        assertIncludes(okResult.stdout, 'answer(ok)', 'pair element accepted');
      },
    },
    {
      // Nesting prepends outermost-first and keeps the raising predicate last.
      name: 'nested call_with_error_context/2 accumulates outermost first',
      run: () => {
        const input = ':- use_module(library(error)).\n%% goal: answer(X)\n' +
          'answer(C) :- catch(call_with_error_context(call_with_error_context(atom_length(1.0,_), inner-1), outer-2), error(_,C), true).\n';
        const result = runCli(['-'], { input });
        assertEqual(result.status, 0, `exit status; stderr=${result.stderr}`);
        assertIncludes(result.stdout, 'answer([outer - 2, inner - 1, predicate - atom_length / 2])', 'nesting order');
      },
    },
    {
      // Throwing the error ball already freshens its variables; the wrapper
      // does not need a separate copy_term/2 call (issue #104).
      name: 'throw/1 freshens variables in the propagated context element',
      run: () => {
        const input = ':- use_module(library(error)).\n%% goal: answer(X)\n' +
          'answer(ok) :- catch(call_with_error_context(atom_length(1.0,_), ctx-V), error(_,[ctx-W|_]), (V == W -> fail ; true)).\n';
        const result = runCli(['-'], { input });
        assertEqual(result.status, 0, `exit status; stderr=${result.stderr}`);
        assertIncludes(result.stdout, 'answer(ok)', 'context element is a fresh copy');
      },
    },
    {
      name: 'double dash permits option-shaped file names',
      run: () => {
        const file = path.join(temp.dir, '-h');
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
        const directory = path.join(temp.dir, `include-operators-${++temp.counter}`);
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
        const directory = path.join(temp.dir, `ensure-self-${++temp.counter}`);
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
        const escapePath = path.join(temp.dir, `read-escapes-${++temp.counter}.term`);
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
          'answer(error(syntax_error(read_term), [predicate - read / 1])).\n',
          'read/1 rejects non-octal numeric escape',
        );
      },
    },
    {
      name: 'term input keeps dotted operators intact and uses program operators',
      run: () => {
        const univPath = path.join(temp.dir, `read-univ-${++temp.counter}.term`);
        const customPath = path.join(temp.dir, `read-custom-${++temp.counter}.term`);
        const invalidPath = path.join(temp.dir, `read-invalid-${++temp.counter}.term`);
        const quotesPath = path.join(temp.dir, `read-quotes-${++temp.counter}.term`);
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
        const invalidPath = path.join(temp.dir, `invalid-utf8-${++temp.counter}.bin`);
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
        const invalidPath = path.join(temp.dir, `read-invalid-utf8-${++temp.counter}.bin`);
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
