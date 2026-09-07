// apiCases: regression cases split out of run-regression.mjs.
// Case order is load-bearing (see support.mjs).
import fs from 'node:fs';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { BuiltinRegistry, Env, Program, Solver, atom, compound, createDefaultRegistry, eyePrologInteropAutoload, eyePrologInteropLibraryIndicators, eyePrologInteropLibraryModules, eyePrologLibraryAutoload, eyePrologLibraryAutoloadModules, eyePrologLibraryIndicators, eyePrologNativeLibraryIndicators, eyePrologPortableLibraryIndicators, getEyePrologRegistry, listFromItems, makeProgram, proofCertificate, proofCertificatesFromText, run as runEyeProlog, standardLibrarySources, termToString, unify, variable, variantTerms, verifyProof } from '../../src/index.js';
import { parseGoalText } from '../../src/parser.js';
import { PrologError, formalErrorTerm } from '../../src/iso.js';
import { assertEqual, assertIncludes } from '../test-style.mjs';
import { goalsFromSource } from '../goal-metadata.mjs';
import {
  assertArrayEqual,
  declaredDefaultExportNames,
  declaredValueExportNames,
  packageRoot,
  registeredNativeEyePrologLibraryNames,
  run,
  runtimeDefaultExportNames,
  runtimeExportNames,
  sourceAtom,
  temp,
  testDirUrl,
} from './support.mjs';

export function apiCases() {
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
        const root = path.join(temp.dir, 'common-system-libs');
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
        const root = path.join(temp.dir, 'scryer-files-full');
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
        const file = path.join(temp.dir, 'pio-scryer-chars.txt');
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
        const file = path.join(temp.dir, 'pio-common.txt');
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
        const engineUrl = new URL('../src/index.js', testDirUrl).href;
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
        const engineUrl = new URL('../src/index.js', testDirUrl).href;
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
        const engineUrl = new URL('../src/index.js', testDirUrl).href;
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
        const engineUrl = new URL('../src/index.js', testDirUrl).href;
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
        const engineUrl = new URL('../src/index.js', testDirUrl).href;
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
        const engineUrl = new URL('../src/index.js', testDirUrl).href;
        const platformUrl = new URL('../src/platform.js', testDirUrl).href;
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
        const engineUrl = new URL('../src/index.js', testDirUrl).href;
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
        const directory = path.join(temp.dir, `modules-${++temp.counter}`);
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
        const directory = path.join(temp.dir, `dcg-modules-${++temp.counter}`);
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
