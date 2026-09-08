#!/usr/bin/env node
// Release gate for the ISO/IEC 13211-1 strict-core execution profile.
// This is intentionally separate from the broader `iso/` corpus because that
// corpus also exercises Part 2 modules and Part 3 grammar rules.
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';

import {
  Program,
  Solver,
  Env,
  compound,
  createStrictIsoRegistry,
  getEyePrologRegistry,
  parseGoalText,
  parseProgramText,
  run,
  stringTerm,
} from '../src/index.js';
import { TestReporter, isMainModule, runStandalone } from './test-style.mjs';

export function runIsoStrict(reporter = new TestReporter()) {
  reporter.section('Strict ISO core');

  reporter.test('executes ordinary Part 1 clauses', () => {
    const result = run('p(X) :- X = 1.\n', { isoStrict: true, goal: 'p(1)' });
    equal(result.stdout, 'p(1).\n', 'stdout');
  });

  reporter.test('pins behavior-changing Technical Corrigendum 1 corrections', () => {
    equal(run('', { isoStrict: true, goal: 'X is sqrt(0), X =:= 0.0' }).stats.completed_goal_lists,
      1, 'non-negative square-root boundary');
    equal(run('', {
      isoStrict: true,
      goal: "atom_chars('North',['N'|Tail]), Tail == [o,r,t,h]",
    }).stats.completed_goal_lists, 1, 'atom_chars/2 accepts a supplied list prefix');
    equal(run('', {
      isoStrict: true,
      goal: "atom_codes('North',[78|Tail]), Tail == [111,114,116,104]",
    }).stats.completed_goal_lists, 1, 'atom_codes/2 accepts a supplied list prefix');

    const source = [
      ':- dynamic(p/1).',
      'p(a).',
      'p(b).',
      ':- op(500, xfy, likes).',
      ':- set_prolog_flag(double_quotes, atom).',
      'double_quote_operator :- (alice "likes" bob) = likes(alice,bob).',
      '',
    ].join('\n');
    equal(run(source, { isoStrict: true, goal: 'clause(p(X),true), X == a' }).stats.completed_goal_lists,
      1, 'clause/2 unifies the selected clause');
    equal(run(source, { isoStrict: true, goal: 'current_op(500,xfy,likes)' }).stats.completed_goal_lists,
      1, 'current_op/3 unifies the selected operator');
    equal(run(source, { isoStrict: true, goal: 'double_quote_operator' }).stats.completed_goal_lists,
      1, 'double-quoted atom receives its operator priority');
  });

  reporter.test('pins behavior-changing Technical Corrigendum 3 corrections', () => {
    const trailingLayout = Program.parse('p.\n  % trailing layout is a complete Prolog text\n', {
      isoStrict: true,
    });
    equal(Boolean(trailingLayout.findGroup('p', 0)), true, 'optional final layout text');

    const written = run('', {
      isoStrict: true,
      goal: "write_term(pair(X,X),[variable_names(['Named'=X])])",
    });
    includes(written.stdout, 'pair(Named,Named)', 'write variable_names/1');
    equal(capture(() => run('', { isoStrict: true, goal: 'X is 2^(-1)' })).formal,
      'type_error(float)', 'negative integer exponent correction');
  });

  reporter.test('round-trips ISO floats through number_chars/2 and quoted write_term/2', () => {
  for (const literal of ['1.0000000000000001', '0.10000000000000002']) {
    const converted = run('', {
      isoStrict: true,
      goal: `N=${literal}, number_chars(N,Chars), number_chars(M,Chars), M == N`,
    });
    equal(converted.stats.completed_goal_lists, 1, `number_chars/2 float round-trip ${literal}`);

    let written = '';
    run('', {
      isoStrict: true,
      goal: `write_term(${literal},[quoted(true)])`,
      ioOptions: { write: (text) => { written += text; } },
    });
    const reread = run('', {
      isoStrict: true,
      goal: `read_term(X,[]), X == ${literal}`,
      ioOptions: { input: `${written}.` },
    });
    equal(reread.stats.completed_goal_lists, 1, `quoted write_term/2 float round-trip ${literal}`);
  }
});

  // ISO 7.10.5 and 8.14.2: write_term/2 with quoted(true) shall emit text that
  // reads back as the same term under the current operator table. Individual
  // spellings are pinned elsewhere; this is the general property, over a corpus
  // chosen to stress operator priority, prefix minus, and quoted atoms.
  reporter.test('writeq output reads back as the identical term', () => {
    const corpus = [
      '-(1)', '- (-(1))', '-(a)', '- - 1', '1 - -1', 'f(-1)', '-(1)^2', '2^ -1',
      '1*(2+3)', '(1*2)+3', '2** -3', 'a* -1', 'a- (-1)', '1 rem 2', 'a mod b',
      '[a|b]', '[[]]', '[]', '[-]', '[-,+]', '[a,b,c]', '{}', '{a,b}',
      "f(',')", "','(a,b)", 'f(;)', 'f(!)', 'f(-)', 'f(+)', 'f(*)',
      'f(a,(b,c))', 'f((a,b))', 'f(g(h(1)))', '(a:-b,c)', '(a;b;c)', '(a->b;c)',
      '*(1,2)', '+(1)', 'a=..b', "'ABC'", 'abc', "''", "' '", "'/*'", "'%'",
      '1.0', '-1.0', '0.0', '1.0e-10', '1.5e300',
      String.raw`'\n'`, String.raw`'\t'`, String.raw`'don''t'`,
      String.raw`\+ a`, String.raw`f('|')`,
    ];
    for (const text of corpus) {
      let written = '';
      run('', {
        isoStrict: true,
        goal: `writeq(${text})`,
        ioOptions: { write: (chunk) => { written += chunk; } },
      });
      const reread = run('', {
        isoStrict: true,
        goal: `read_term(X,[]), X == (${text})`,
        ioOptions: { input: `${written}.` },
      });
      equal(reread.stats.completed_goal_lists, 1, `writeq round-trip ${text} -> ${written}`);
    }
  });

  reporter.test('keeps Corrigendum 2 core predicates and excludes Part 3 phrase', () => {
    const registry = createStrictIsoRegistry();
    equal(Boolean(registry.get('subsumes_term', 2)), true, 'subsumes_term/2');
    equal(Boolean(registry.get('term_variables', 2)), true, 'term_variables/2');
    equal(Boolean(registry.get('call', 2)), true, 'call/2');
    equal(Boolean(registry.get('false', 0)), true, 'false/0');
    equal(Boolean(registry.get('phrase', 2)), false, 'phrase/2');
    equal(Boolean(registry.get('phrase', 3)), false, 'phrase/3');
  });

  reporter.test('exposes only ISO core Prolog flags', () => {
    const solver = new Solver(Program.parse('', { isoStrict: true }), { isoStrict: true });
    equal(solver.prologFlags.has('occurs_check'), false, 'occurs_check');
    equal(solver.prologFlags.get('unknown')?.value?.name, 'error', 'unknown default');
  });

  reporter.test('unbounded integer profile does not expose max_integer or min_integer values', () => {
    const program = Program.parse('', { isoStrict: true });
    const solver = new Solver(program, { isoStrict: true });
    const answers = (text) => [...solver.solve([parseGoalText(text, { isoStrict: true })], new Env(), 0)].length;
    equal(answers('current_prolog_flag(bounded,false)'), 1, 'bounded=false');
    equal(answers('current_prolog_flag(max_integer,_)'), 0, 'max_integer unavailable');
    equal(answers('current_prolog_flag(min_integer,_)'), 0, 'min_integer unavailable');
  });


  reporter.test('covers the Part 1 flag defaults, value domains, and changeability', () => {
    const program = Program.parse('', { isoStrict: true });
    const solver = new Solver(program, { isoStrict: true });
    const answers = (text) => [...solver.solve([parseGoalText(text, { isoStrict: true })], new Env(), 0)].length;
    for (const goalText of [
      'current_prolog_flag(bounded,false)',
      'current_prolog_flag(integer_rounding_function,toward_zero)',
      'current_prolog_flag(char_conversion,on)',
      'current_prolog_flag(debug,off)',
      'current_prolog_flag(max_arity,unbounded)',
      'current_prolog_flag(unknown,error)',
      'current_prolog_flag(double_quotes,chars)',
    ]) equal(answers(goalText), 1, goalText);

    for (const goalText of [
      'set_prolog_flag(char_conversion,off)',
      'set_prolog_flag(debug,on)',
      'set_prolog_flag(unknown,fail)',
      'set_prolog_flag(double_quotes,codes)',
    ]) run('', { isoStrict: true, goal: goalText });

    equal(capture(() => run('', { isoStrict: true, goal: 'set_prolog_flag(bounded,true)' })).formal,
      'permission_error(modify, flag)', 'bounded valid-but-fixed value');
    equal(capture(() => run('', { isoStrict: true, goal: 'set_prolog_flag(integer_rounding_function,down)' })).formal,
      'permission_error(modify, flag)', 'rounding valid-but-fixed value');
    equal(capture(() => run('', { isoStrict: true, goal: 'set_prolog_flag(max_arity,unbounded)' })).formal,
      'permission_error(modify, flag)', 'max_arity valid-but-fixed value');
    equal(capture(() => run('', { isoStrict: true, goal: 'set_prolog_flag(max_integer,unbounded)' })).formal,
      'domain_error(flag_value)', 'max_integer has no value when unbounded');
    equal(capture(() => run('', { isoStrict: true, goal: 'set_prolog_flag(unknown,maybe)' })).formal,
      'domain_error(flag_value)', 'unknown value domain');
    equal(capture(() => run('', { isoStrict: true, goal: 'set_prolog_flag(not_a_flag,on)' })).formal,
      'domain_error(prolog_flag)', 'unsupported flag');
  });

  reporter.test('keeps max_arity unbounded for compound terms', () => {
    const program = Program.parse('', { isoStrict: true });
    const solver = new Solver(program, { isoStrict: true });
    const answers = (text) => [...solver.solve([parseGoalText(text, { isoStrict: true })], new Env(), 0)].length;
    equal(answers('current_prolog_flag(max_arity,unbounded)'), 1, 'unbounded flag value');
    equal(answers('functor(T,foo,65536),arg(65536,T,z)'), 1, 'functor beyond former 65535 ceiling');

    const source = `wide(${Array.from({ length: 65536 }, () => 'a').join(',')}).`;
    const clauses = parseProgramText(source, { isoStrict: true, sourceMetadata: true });
    equal(clauses[0]?.head?.arity, 65536, 'source term beyond former 65535 ceiling');

    // A very large predicate indicator that names no procedure must not be
    // rounded through JavaScript Number or misreported as max_arity.
    equal(run('', { isoStrict: true, goal: 'abolish(foo/9007199254740993)' }).stats.completed_goal_lists,
      1, 'large nonexistent predicate indicator');
  });

  reporter.test('does not invent max_procedure_arity without a separate procedure ceiling', () => {
    // STC #70 makes max_procedure_arity implementation defined and needed
    // only when a processor has a smaller procedure-arity ceiling. EyeProlog
    // has no such separate declared ceiling, so the optional flag is absent.
    equal(capture(() => run('', { isoStrict: true, goal: 'current_prolog_flag(max_procedure_arity,_)' })).formal,
      'domain_error(prolog_flag)', 'STC #70 optional flag absent');
  });

  reporter.test('preparation-time char_conversion affects later unquoted source only', () => {
    const program = Program.parse(
      ":- char_conversion(x,y).\np(x).\nquoted('x').\n:- set_prolog_flag(char_conversion,off).\nraw(x).\n",
      { isoStrict: true },
    );
    equal(Boolean(program.findGroup('p', 1)?.clauses.some((clause) => clause.head.args[0]?.name === 'y')), true, 'converted p/1');
    equal(Boolean(program.findGroup('quoted', 1)?.clauses.some((clause) => clause.head.args[0]?.name === 'x')), true, 'quoted atom unchanged');
    equal(Boolean(program.findGroup('raw', 1)?.clauses.some((clause) => clause.head.args[0]?.name === 'x')), true, 'conversion disabled');
  });


  reporter.test('uses the implementation-defined Unicode scalar PCS and collation', () => {
    const program = Program.parse('', { isoStrict: true });
    const solver = new Solver(program, { isoStrict: true });
    const answers = (text) => [...solver.solve([parseGoalText(text, { isoStrict: true })], new Env(), 0)].length;
    equal(answers("char_code('\\0\\',0)"), 1, 'NUL collating integer');
    equal(answers("char_code('A',65)"), 1, 'A collating integer');
    equal(answers("char_code('ä',228)"), 1, 'extended Latin character');
    equal(answers("char_code('😀',128512)"), 1, 'supplementary Unicode scalar');
    equal(answers("'\\0\\' @< 'A'"), 1, 'control before capital');
    equal(answers("'A' @< 'a'"), 1, 'capital before small letter');
    equal(answers("'\\xe000\\' @< '\\x10000\\'"), 1, 'atom order follows scalar collating integers');
  });

  reporter.test('follows the Part 1 standard term-type and atom ordering', () => {
    const program = Program.parse('', { isoStrict: true });
    const solver = new Solver(program, { isoStrict: true });
    const answers = (text) => [...solver.solve([parseGoalText(text, { isoStrict: true })], new Env(), 0)].length;
    equal(answers("X @< 1.0"), 1, 'variable before float');
    equal(answers("1.0 @< 1"), 1, 'float before integer');
    equal(answers("1 @< a"), 1, 'integer before atom');
    equal(answers("a @< f(a)"), 1, 'atom before compound');
    equal(answers("'' @< 'A'"), 1, 'null atom first');
    equal(answers("'A' @< 'B'"), 1, 'atom collation');
  });

  reporter.test('does not narrow implementation-defined character choices in strict mode', () => {
    const program = Program.parse("p('é').\nä.\n", { isoStrict: true });
    equal(Boolean(program.findGroup('p', 1)), true, 'quoted extended character in source');
    equal(Boolean(program.findGroup('ä', 0)), true, 'extended small-letter atom in source');

    const readResult = run('', {
      isoStrict: true,
      goal: "read('é')",
      ioOptions: { input: "'é'." },
    });
    equal(readResult.stats.completed_goal_lists, 1, 'extended character through strict text input');

    const written = run('', { isoStrict: true, goal: 'writeq("ä")' });
    includes(written.stdout, 'ä', 'issue #67 writeq example');
  });

  reporter.test('restricts character codes only to the Unicode scalar PCS boundary', () => {
    equal(run('', { isoStrict: true, goal: 'char_code(_,128)' }).stats.completed_goal_lists, 1,
      'code 128 is a PCS member');
    equal(capture(() => run('', { isoStrict: true, goal: 'char_code(_,55296)' })).formal,
      'representation_error(character_code)', 'surrogate is not a scalar');
    equal(capture(() => run('', { isoStrict: true, goal: 'atom_codes(_, [1114112])' })).formal,
      'representation_error(character_code)', 'above Unicode scalar range');
    equal(capture(() => run('', { isoStrict: true, goal: 'put_code(1114112)' })).formal,
      'representation_error(character_code)', 'put_code/1 above scalar range');
  });

  reporter.test('uses the same processor character repertoire in normal and strict profiles', () => {
    const normal = run('', { goal: "char_code('é',233)" });
    const strict = run('', { isoStrict: true, goal: "char_code('é',233)" });
    equal(normal.stats.completed_goal_lists, 1, 'normal Unicode char_code/2');
    equal(strict.stats.completed_goal_lists, 1, 'strict Unicode char_code/2');
  });

  reporter.test('closes the Clause 6 syntax production and rejection rows', () => {
    const accepted = [
      ['p(a).', '6.3.1 atom'],
      ['p(123).', '6.3.1 integer'],
      ['p(1.5).', '6.3.1 float'],
      ['p(-1).', '6.3.1 negative integer'],
      ['p(-1.5).', '6.3.1 negative float'],
      ['p(X,_,_).', '6.3.2 variables'],
      ['p(f(a,b)).', '6.3.3 functional compound'],
      ['p((a+b*c)).', '6.3.4 operator notation'],
      ['p([a,b|T]).', '6.3.5 list notation'],
      ['p({a}).', '6.3.6 curly term'],
      ['p("ab").', '6.3.7/6.4.6 double quoted list'],
      ['% line comment\np(a).', '6.4.1 layout and line comment'],
      ['/* block comment */ p(a).', '6.4.1 bracketed comment'],
      ["p('a\\n').", '6.4.2 quoted character escape'],
      ['p(0b101).', '6.4.4 binary integer'],
      ['p(0o17).', '6.4.4 octal integer'],
      ['p(0x1f).', '6.4.4 hexadecimal integer'],
      ["p(0'a).", '6.4.4 character-code integer'],
      ['p(1.2e3).', '6.4.5 exponent float'],
      ['p(!).', '6.4.8 solo token'],
    ];
    for (const [source, label] of accepted) {
      equal(parseProgramText(source, { isoStrict: true }).length, 1, label);
    }

    const rejected = [
      ['p(`x`).', '6.4.7 back quoted string has no Part 1 token'],
      ["p('x).", 'unterminated quoted token'],
      ['p([a|b,c]).', 'invalid list production'],
      ['p((1 = 2 = 3)).', 'invalid xfx associativity'],
      ['p(a).x', 'end character requires a token boundary'],
      ['p(1.0e).', 'malformed floating point token'],
      ['p(a b).', 'adjacent alphanumeric tokens need separation/grammar'],
      ['p(a,,b).', 'invalid argument production'],
      ['/* unterminated', 'unterminated bracketed comment'],
      ["p('\\x').", 'invalid hexadecimal escape'],
    ];
    for (const [source, label] of rejected) {
      let threw = false;
      try {
        parseProgramText(source, { isoStrict: true });
      } catch (_) {
        threw = true;
      }
      equal(threw, true, label);
    }
  });

  reporter.test('rejects the normal-profile string term extension at strict API boundaries', () => {
    const normalSolver = new Solver(Program.parse(''), {});
    const normalGoal = compound('=', [stringTerm('x'), stringTerm('x')]);
    equal([...normalSolver.solve([normalGoal], new Env(), 0)].length, 1,
      'normal API string terms remain usable');

    const strictSolver = new Solver(Program.parse('', { isoStrict: true }), { isoStrict: true });
    equal(capture(() => [...strictSolver.solve([normalGoal], new Env(), 0)]).formal,
      'representation_error(term)', 'strict execution rejects API string terms');

    equal(capture(() => new Program([{
      head: compound('p', [stringTerm('x')]),
      body: [],
    }], { isoStrict: true })).formal,
      'representation_error(term)', 'strict program construction rejects API string terms');
  });


  reporter.test('closes the ISO 7.1-7.3 term-semantics rows', () => {
    for (const goal of [
      'var(X), \\+ nonvar(X)',
      'integer(1), float(1.0), atom(a), compound(f(a))',
      'atomic(1), atomic(1.0), atomic(a), \\+ atomic(f(a))',
      'term_variables(f(X,Y,X),[X,Y])',
      'f(X,a)=f(b,Y), X==b, Y==a',
      '\\+ (f(a)=g(a))',
      '\\+ (X=f(X))',
      '\\+ unify_with_occurs_check(X,f(X))',
      'copy_term(f(X,X),f(Y,Y)), X \\== Y',
      'f(a) @< f(a,b)',
      'f(a) @< g(a)',
    ]) equal(run('', { isoStrict: true, goal }).stats.completed_goal_lists, 1, goal);

    const program = Program.parse('', { isoStrict: true });
    const solver = new Solver(program, { isoStrict: true });
    const answers = (goal) => [...solver.solve([parseGoalText(goal, { isoStrict: true })], new Env(), 0)].length;
    equal(answers('X @< 1.0'), 1, 'variable < float');
    equal(answers('1.0 @< 1'), 1, 'float < integer');
    equal(answers('1 @< a'), 1, 'integer < atom');
    equal(answers('a @< f(a)'), 1, 'atom < compound');
  });

  reporter.test('keeps the strict write-option surface to Part 1 plus Corrigendum 3', () => {
    const strictError = capture(() => run('', {
      isoStrict: true,
      goal: 'write_term(a,[double_quotes(true)])',
    }));
    equal(strictError.formal, 'domain_error(write_option)', 'strict extension rejection');

    const strictSpacingError = capture(() => run('', {
      isoStrict: true,
      goal: 'write_term(1+1,[spacing(false)])',
    }));
    equal(strictSpacingError.formal, 'domain_error(write_option)', 'strict spacing extension rejection');

    const normal = run('', { goal: 'write_term("ab",[double_quotes(true)])' });
    includes(normal.stdout, '"ab"', 'normal-profile extension remains available');
    includes(run('', { goal: 'write_term(1+1,[spacing(true)])' }).stdout,
      '1 + 1', 'normal-profile spacing extension remains available');
  });

  reporter.test('follows Corrigendum 3 variable metadata traversal and write naming', () => {
    const readMetadata = run('', {
      isoStrict: true,
      goal: "read_term(f(B,A,B,C,D,E),[variables([B,A,C,D,E]),variable_names(['B'=B,'A'=A,'C'=C,'_D'=D]),singletons(['A'=A,'C'=C,'_D'=D])])",
      ioOptions: { input: 'f(B,A,B,C,_D,_).' },
    });
    equal(readMetadata.stats.completed_goal_lists, 1, 'read metadata order');

    const named = run('', {
      isoStrict: true,
      goal: "write_term(f(X,Y,X),[quoted(true),variable_names([z=X,a=X,y=Y])])",
    });
    includes(named.stdout, 'f(z,y,z)', 'leftmost variable name wins');

    const ignoredNonVariable = run('', {
      isoStrict: true,
      goal: "write_term(X,[variable_names([ignored=42,x=X])])",
    });
    includes(ignoredNonVariable.stdout, 'x', 'non-variable right side is permitted and ignored');
  });


  reporter.test('reports the complete alias option in open/4 alias collisions', () => {
    const error = capture(() => run('', {
      isoStrict: true,
      goal: 'open(dummy,write,_,[alias(user_input)])',
    }));
    equal(error.formal, 'permission_error(open, source_sink)', 'formal error');
    includes(error.message, 'alias(user_input)', 'alias option culprit');
  });

  reporter.test('covers ISO 8.14.1.3 read_term/3 errors and selected overlaps', () => {
    equal(capture(() => run('', { isoStrict: true, goal: 'read_term(f(a),_,[X])' })).formal,
      'instantiation_error', 'partial/variable option before stream domain');
    equal(capture(() => run('', { isoStrict: true, goal: 'read_term(f(a),_,foo)' })).formal,
      'domain_error(stream_or_alias)', 'stream domain before non-list options');
    equal(capture(() => run('', { isoStrict: true, goal: 'read_term(user_output,_,foo)' })).formal,
      'type_error(list)', 'non-list options before stream permission');
    equal(capture(() => run('', { isoStrict: true, goal: 'read_term(user_output,_,[bogus])' })).formal,
      'domain_error(read_option)', 'invalid option before stream permission');
    equal(capture(() => run('', { isoStrict: true, goal: "read_term('$stream'(999),_,[bogus])" })).formal,
      'domain_error(read_option)', 'invalid option before stream existence');

    const program = Program.parse('', { isoStrict: true });
    const solver = new Solver(program, { isoStrict: true, ioOptions: { input: 'a.' } });
    const error = capture(() => [...solver.solve([
      parseGoalText('read_term(user_input,_,[bogus])', { isoStrict: true }),
    ], new Env(), 0)]);
    equal(error.formal, 'domain_error(read_option)', 'invalid read option');
    equal(solver.io.resolve('user_input').position, 0, 'invalid options are rejected before input');
  });

  reporter.test('covers ISO 8.14.2.3 write_term/3 errors and selected overlaps', () => {
    equal(capture(() => run('', { isoStrict: true, goal: 'write_term(f(a),a,[X])' })).formal,
      'instantiation_error', 'partial/variable option before stream domain');
    equal(capture(() => run('', { isoStrict: true, goal: 'write_term(f(a),a,foo)' })).formal,
      'type_error(list)', 'non-list options before stream domain');
    equal(capture(() => run('', { isoStrict: true, goal: 'write_term(f(a),a,[bogus])' })).formal,
      'domain_error(stream_or_alias)', 'stream domain before invalid option');
    equal(capture(() => run('', { isoStrict: true, goal: "write_term('$stream'(999),a,[bogus])" })).formal,
      'domain_error(write_option)', 'invalid option before stream existence');
    equal(capture(() => run('', { isoStrict: true, goal: 'write_term(user_input,a,[bogus])' })).formal,
      'domain_error(write_option)', 'invalid option before stream permission');
  });

  reporter.test('covers ISO 8.14.3.3 op/3 errors and selected overlaps', () => {
    equal(capture(() => run('', { isoStrict: true, goal: 'op(a,X,0)' })).formal,
      'instantiation_error', 'specifier variable before priority type');
    equal(capture(() => run('', { isoStrict: true, goal: 'op(a,xfy,[X])' })).formal,
      'instantiation_error', 'operator variable element before priority type');
    equal(capture(() => run('', { isoStrict: true, goal: 'op(a,1,0)' })).formal,
      'type_error(integer)', 'priority type before specifier type');
    equal(capture(() => run('', { isoStrict: true, goal: 'op(1,1,0)' })).formal,
      'type_error(atom)', 'specifier type before operator-list type');
    equal(capture(() => run('', { isoStrict: true, goal: 'op(1300,xfy,[1])' })).formal,
      'type_error(atom)', 'operator element type before priority domain');
    equal(capture(() => run('', { isoStrict: true, goal: 'op(1300,foo,a)' })).formal,
      'domain_error(operator_priority)', 'priority domain before specifier domain');
    equal(capture(() => run('', { isoStrict: true, goal: 'op(100,foo,a)' })).formal,
      'domain_error(operator_specifier)', 'specifier domain');
  });

  reporter.test('uses ISO 8.14.4.3 domain errors for current_op/3 filters', () => {
    equal(capture(() => run('', { isoStrict: true, goal: 'current_op(a,_,_)' })).formal,
      'domain_error(operator_priority)', 'priority domain');
    equal(capture(() => run('', { isoStrict: true, goal: 'current_op(1,1,_)' })).formal,
      'domain_error(operator_specifier)', 'specifier domain');
    equal(capture(() => run('', { isoStrict: true, goal: 'current_op(1,fx,1)' })).formal,
      'type_error(atom)', 'operator type');
  });

  reporter.test('covers remaining Part 1 built-in error conditions and overlap choices', () => {
    const cases = [
      ['arg(a,X,_)', 'instantiation_error', 'arg/3 second-argument instantiation before index type'],
      ['atom_concat(1,X,Y)', 'instantiation_error', 'atom_concat/3 second/whole under-instantiation before first type'],
      ['atom_concat(X,1,Y)', 'instantiation_error', 'atom_concat/3 first/whole under-instantiation before second type'],
      ['sub_atom(a,-1,bad,_,_)', 'type_error(integer)', 'sub_atom/5 integer type before non-negative domain'],
      ['number_chars(N,[1|T])', 'instantiation_error', 'number_chars/2 partial list before element type'],
      ['number_chars(N,[X,1])', 'instantiation_error', 'number_chars/2 variable element before later element type'],
      ['number_codes(N,[foo|T])', 'instantiation_error', 'number_codes/2 partial list before element type'],
      ['number_codes(N,[X,foo])', 'instantiation_error', 'number_codes/2 variable element before later element type'],
      ['atom_chars(A,[X|foo])', 'type_error(list)', 'atom_chars/2 improper list before prefix variable'],
      ['atom_codes(A,[X|foo])', 'type_error(list)', 'atom_codes/2 improper list before prefix variable'],
      ['char_conversion(foo,X)', 'instantiation_error', 'char_conversion/2 output instantiation before input representation'],
    ];
    for (const [goal, formal, label] of cases) {
      equal(capture(() => run('', { isoStrict: true, goal })).formal, formal, label);
    }
  });

  reporter.test('orders input-code representation errors after stream diagnostics', () => {
    // Keep EyeProlog's selected 8.12 overlap behavior stable: integer type
    // errors are detected before stream access, while a valid integer outside
    // the in-character-code domain is diagnosed after stream/entity errors.
    for (const predicate of ['get_code', 'peek_code']) {
      equal(capture(() => run('', { isoStrict: true, goal: `${predicate}(user_output,-2)` })).formal,
        'permission_error(input, stream)', `${predicate}/2 output stream before bad code`);
    }

    const program = Program.parse('', { isoStrict: true });
    const binarySolver = new Solver(program, { isoStrict: true });
    binarySolver.io.add({
      id: 2, alias: 'bin_in', mode: 'read', type: 'binary', content: [], position: 0, path: '',
      reposition: false, eofAction: 'error', standard: false, pastEnd: false,
    });
    equal(capture(() => [...binarySolver.solve([parseGoalText('get_code(bin_in,-2)', { isoStrict: true })], new Env(), 0)]).formal,
      'permission_error(input, binary_stream)', 'binary stream before bad code');

    const eofSolver = new Solver(Program.parse('', { isoStrict: true }), { isoStrict: true });
    eofSolver.io.add({
      id: 2, alias: 'past_in', mode: 'read', type: 'text', content: '', position: 0, path: '',
      reposition: false, eofAction: 'error', standard: false, pastEnd: true,
    });
    equal(capture(() => [...eofSolver.solve([parseGoalText('peek_code(past_in,-2)', { isoStrict: true })], new Env(), 0)]).formal,
      'permission_error(input, past_end_of_stream)', 'past EOF before bad code');

    const badEntitySolver = new Solver(Program.parse('', { isoStrict: true }), { isoStrict: true });
    badEntitySolver.io.add({
      id: 2, alias: 'bad_utf8', mode: 'read', type: 'text', content: '\udc00', position: 0, path: '',
      reposition: false, eofAction: 'error', standard: false, pastEnd: false, strictUtf8: true,
    });
    equal(capture(() => [...badEntitySolver.solve([parseGoalText('peek_code(bad_utf8,-2)', { isoStrict: true })], new Env(), 0)]).formal,
      'representation_error(character)', 'invalid input entity before bad code');

    equal(capture(() => run('', { isoStrict: true, goal: 'get_code(-2)' })).formal,
      'representation_error(in_character_code)', 'bad code once no earlier stream error applies');
  });

  reporter.test('closes the ISO 8.11 stream selection/control rows', () => {
    const errors = [
      ['current_input(foo)', 'domain_error(stream)', 'current_input/1 stream term'],
      ['current_output(foo)', 'domain_error(stream)', 'current_output/1 stream term'],
      ['set_input(X)', 'instantiation_error', 'set_input/1 variable'],
      ['set_input(f(a))', 'domain_error(stream_or_alias)', 'set_input/1 stream-or-alias domain'],
      ['set_input(no_such_stream)', 'existence_error(stream)', 'set_input/1 closed/missing stream'],
      ['set_input(user_output)', 'permission_error(input, stream)', 'set_input/1 output stream'],
      ['set_output(X)', 'instantiation_error', 'set_output/1 variable'],
      ['set_output(f(a))', 'domain_error(stream_or_alias)', 'set_output/1 stream-or-alias domain'],
      ['set_output(no_such_stream)', 'existence_error(stream)', 'set_output/1 closed/missing stream'],
      ['set_output(user_input)', 'permission_error(output, stream)', 'set_output/1 input stream'],
      ['open(X,read,S,[])', 'instantiation_error', 'open/4 source instantiation'],
      ['open(dummy,X,S,[])', 'instantiation_error', 'open/4 mode instantiation'],
      ['open(dummy,read,S,[X])', 'instantiation_error', 'open/4 option instantiation'],
      ['open(dummy,1,S,[])', 'type_error(atom)', 'open/4 mode type'],
      ['open(dummy,read,S,foo)', 'type_error(list)', 'open/4 options list type'],
      ['open(dummy,read,already_bound,[])', 'uninstantiation_error', 'open/4 stream output mode'],
      ['open(4,read,S,[])', 'domain_error(source_sink)', 'open/4 source/sink domain'],
      ['open(dummy,bad,S,[])', 'domain_error(io_mode)', 'open/4 io mode domain'],
      ['open(dummy,write,S,[bogus])', 'domain_error(stream_option)', 'open/4 stream option domain'],
      ['close(X,[])', 'instantiation_error', 'close/2 stream instantiation'],
      ['close(no_such_stream,[X])', 'instantiation_error', 'close/2 option instantiation'],
      ['close(no_such_stream,foo)', 'type_error(list)', 'close/2 options list type'],
      ['close(f(a),[])', 'domain_error(stream_or_alias)', 'close/2 stream-or-alias domain'],
      ['close(no_such_stream,[bogus])', 'domain_error(close_option)', 'close/2 close option domain'],
      ['close(no_such_stream,[])', 'existence_error(stream)', 'close/2 missing stream'],
      ['flush_output(X)', 'instantiation_error', 'flush_output/1 variable'],
      ['flush_output(f(a))', 'domain_error(stream_or_alias)', 'flush_output/1 stream-or-alias domain'],
      ['flush_output(no_such_stream)', 'existence_error(stream)', 'flush_output/1 missing stream'],
      ['flush_output(user_input)', 'permission_error(output, stream)', 'flush_output/1 input stream'],
      ['stream_property(foo,P)', 'domain_error(stream)', 'stream_property/2 stream term domain'],
      ['stream_property(S,bogus)', 'domain_error(stream_property)', 'stream_property/2 property domain'],
      ['at_end_of_stream(X)', 'instantiation_error', 'at_end_of_stream/1 variable'],
      ['at_end_of_stream(f(a))', 'domain_error(stream_or_alias)', 'at_end_of_stream/1 stream-or-alias domain'],
      ['at_end_of_stream(no_such_stream)', 'existence_error(stream)', 'at_end_of_stream/1 missing stream'],
      ['set_stream_position(X,0)', 'instantiation_error', 'set_stream_position/2 stream instantiation'],
      ['set_stream_position(user_input,X)', 'instantiation_error', 'set_stream_position/2 position instantiation'],
      ['set_stream_position(f(a),0)', 'domain_error(stream_or_alias)', 'set_stream_position/2 stream-or-alias domain'],
      ['set_stream_position(user_input,foo)', 'domain_error(stream_position)', 'set_stream_position/2 position domain'],
      ['set_stream_position(no_such_stream,0)', 'existence_error(stream)', 'set_stream_position/2 missing stream'],
      ['set_stream_position(user_input,0)', 'permission_error(reposition, stream)', 'set_stream_position/2 non-repositionable stream'],
    ];
    for (const [goal, formal, label] of errors) {
      equal(capture(() => run('', { isoStrict: true, goal })).formal, formal, label);
    }

    equal(run('', { isoStrict: true, goal: 'current_input(S),stream_property(S,input)' }).stats.completed_goal_lists, 1,
      'current_input/1 successful mode');
    equal(run('', { isoStrict: true, goal: 'current_output(S),stream_property(S,output)' }).stats.completed_goal_lists, 1,
      'current_output/1 successful mode');
    equal(run('', { isoStrict: true, goal: 'flush_output(user_output)' }).stats.completed_goal_lists, 1,
      'flush_output/1 successful mode');
    equal(run('', { isoStrict: true, goal: 'at_end_of_stream(user_input)' }).stats.completed_goal_lists, 1,
      'at_end_of_stream/1 at empty standard input');

    const openErrorSolver = new Solver(Program.parse('', { isoStrict: true }), { isoStrict: true });
    openErrorSolver.io.open = () => { throw Object.assign(new Error('missing'), { code: 'ENOENT' }); };
    equal(capture(() => [...openErrorSolver.solve([
      parseGoalText('open(missing,read,S,[])', { isoStrict: true }),
    ], new Env(), 0)]).formal, 'existence_error(source_sink)', 'open/4 missing read source');
    openErrorSolver.io.open = () => { throw new Error('denied'); };
    equal(capture(() => [...openErrorSolver.solve([
      parseGoalText('open(denied,write,S,[])', { isoStrict: true }),
    ], new Env(), 0)]).formal, 'permission_error(open, source_sink)', 'open/4 cannot open sink');

    const closedSolver = new Solver(Program.parse('', { isoStrict: true }), { isoStrict: true });
    const closed = closedSolver.io.add({
      id: 2, alias: 'closed_stream', mode: 'read', type: 'text', content: 'a', position: 0, path: '',
      reposition: true, eofAction: 'error', standard: false, pastEnd: false,
    });
    closedSolver.io.discard(closed);
    equal([...closedSolver.solve([
      parseGoalText("stream_property('$stream'(2),_)", { isoStrict: true }),
    ], new Env(), 0)].length, 0, 'closed valid stream-term has no current stream property');

    const positionedSolver = new Solver(Program.parse('', { isoStrict: true }), { isoStrict: true });
    positionedSolver.io.add({
      id: 2, alias: 'positioned', mode: 'read', type: 'text', content: 'ab', position: 0, path: '',
      reposition: true, eofAction: 'error', standard: false, pastEnd: false,
    });
    equal([...positionedSolver.solve([
      parseGoalText('set_stream_position(positioned,1)', { isoStrict: true }),
      parseGoalText("get_char(positioned,'b')", { isoStrict: true }),
    ], new Env(), 0)].length, 1, 'set_stream_position/2 successful mode');
  });

  reporter.test('closes the higher-level ISO 7.10 stream model rows', () => {
    const directory = mkdtempSync(join(tmpdir(), 'eyeprolog-iso-710-'));
    const atomPath = (value) => `'${String(value).replaceAll("'", "''")}'`;
    try {
      const inputPath = join(directory, 'input.txt');
      writeFileSync(inputPath, 'ab');
      equal(run('', {
        isoStrict: true,
        goal: [
          `open(${atomPath(inputPath)},read,S,[alias(tmp_in),reposition(true),eof_action(eof_code)])`,
          '\\+ atom(S)',
          'stream_property(S,input)',
          'stream_property(S,alias(tmp_in))',
          'stream_property(S,reposition(true))',
          'stream_property(S,eof_action(eof_code))',
          'set_input(tmp_in)',
          "get_char('a')",
          'close(tmp_in)',
          'current_input(C)',
          'stream_property(C,alias(user_input))',
          'catch(set_input(tmp_in),error(existence_error(stream,tmp_in),[set_input/1]),true)',
        ].join(','),
      }).stats.completed_goal_lists, 1, 'stream-term, alias lifetime, target/current input, and close fallback');

      const truncatePath = join(directory, 'truncate.txt');
      writeFileSync(truncatePath, 'old');
      equal(run('', {
        isoStrict: true,
        goal: `open(${atomPath(truncatePath)},write,S,[]),close(S)`,
      }).stats.completed_goal_lists, 1, 'write open/close succeeds');
      equal(readFileSync(truncatePath, 'utf8'), '', 'write mode empties an existing sink');

      const appendPath = join(directory, 'append.txt');
      writeFileSync(appendPath, 'ab');
      equal(run('', {
        isoStrict: true,
        goal: `open(${atomPath(appendPath)},append,S,[reposition(true)]),put_char(S,c),set_stream_position(S,1),put_char(S,'Z'),close(S)`,
      }).stats.completed_goal_lists, 1, 'append and repositioned output succeed');
      equal(readFileSync(appendPath, 'utf8'), 'aZc', 'append starts at end and repositioned output overwrites');

      const optionsPath = join(directory, 'options.txt');
      writeFileSync(optionsPath, 'x');
      equal(run('', {
        isoStrict: true,
        goal: [
          `open(${atomPath(optionsPath)},read,S,[type(binary),type(text),reposition(false),reposition(true),eof_action(error),eof_action(eof_code)])`,
          'stream_property(S,type(text))',
          'stream_property(S,reposition(true))',
          'stream_property(S,eof_action(eof_code))',
          'close(S)',
        ].join(','),
      }).stats.completed_goal_lists, 1, 'rightmost contradictory stream option applies');

      const binaryPath = join(directory, 'roundtrip.bin');
      equal(run('', {
        isoStrict: true,
        goal: [
          `open(${atomPath(binaryPath)},write,W,[type(binary)])`,
          'put_byte(W,0)',
          'put_byte(W,255)',
          'close(W)',
          `open(${atomPath(binaryPath)},read,R,[type(binary)])`,
          'get_byte(R,0)',
          'get_byte(R,255)',
          'get_byte(R,-1)',
          'close(R)',
        ].join(','),
      }).stats.completed_goal_lists, 1, 'binary stream round-trip is byte exact');
      equal([...readFileSync(binaryPath)].join(','), '0,255', 'binary sink contains exactly the output bytes');

      const textPath = join(directory, 'text.txt');
      equal(run('', {
        isoStrict: true,
        goal: `open(${atomPath(textPath)},write,S,[]),put_char(S,a),flush_output(S),close(S)`,
      }).stats.completed_goal_lists, 1, 'text flush/close succeeds');
      equal(readFileSync(textPath, 'utf8'), 'a', 'flush/close does not synthesize a final newline');

      equal(run('', {
        isoStrict: true,
        goal: 'current_input(I),close(I),current_input(I),current_output(O),close(O),current_output(O)',
      }).stats.completed_goal_lists, 1, 'standard streams remain open when close/1 is called');
    } finally {
      rmSync(directory, { recursive: true, force: true });
    }
  });

  reporter.test('closes the ISO 8.12-8.14 character, byte, and term-I/O rows', () => {
    const errors = [
      ['get_char(S,C)', 'instantiation_error', 'get_char/2 stream instantiation'],
      ['get_char(user_input,ab)', 'type_error(in_character)', 'get_char/2 in-character type'],
      ['get_char(f(a),C)', 'domain_error(stream_or_alias)', 'get_char/2 stream-or-alias domain'],
      ['get_char(no_such_stream,C)', 'existence_error(stream)', 'get_char/2 missing stream'],
      ['get_char(user_output,C)', 'permission_error(input, stream)', 'get_char/2 output stream'],
      ['get_code(S,C)', 'instantiation_error', 'get_code/2 stream instantiation'],
      ['get_code(user_input,foo)', 'type_error(integer)', 'get_code/2 integer type'],
      ['get_code(f(a),C)', 'domain_error(stream_or_alias)', 'get_code/2 stream-or-alias domain'],
      ['get_code(no_such_stream,C)', 'existence_error(stream)', 'get_code/2 missing stream'],
      ['get_code(user_output,C)', 'permission_error(input, stream)', 'get_code/2 output stream'],
      ['get_code(-2)', 'representation_error(in_character_code)', 'get_code/1 in-character-code representation'],
      ['peek_char(S,C)', 'instantiation_error', 'peek_char/2 stream instantiation'],
      ['peek_char(user_input,ab)', 'type_error(in_character)', 'peek_char/2 in-character type'],
      ['peek_code(user_input,foo)', 'type_error(integer)', 'peek_code/2 integer type'],
      ['put_char(S,a)', 'instantiation_error', 'put_char/2 stream instantiation'],
      ['put_char(X)', 'instantiation_error', 'put_char/1 character instantiation'],
      ['put_char(ab)', 'type_error(character)', 'put_char/1 character type'],
      ['put_char(f(a),a)', 'domain_error(stream_or_alias)', 'put_char/2 stream-or-alias domain'],
      ['put_char(no_such_stream,a)', 'existence_error(stream)', 'put_char/2 missing stream'],
      ['put_char(user_input,a)', 'permission_error(output, stream)', 'put_char/2 input stream'],
      ['put_code(S,97)', 'instantiation_error', 'put_code/2 stream instantiation'],
      ['put_code(X)', 'instantiation_error', 'put_code/1 code instantiation'],
      ['put_code(foo)', 'type_error(integer)', 'put_code/1 integer type'],
      ['put_code(f(a),97)', 'domain_error(stream_or_alias)', 'put_code/2 stream-or-alias domain'],
      ['put_code(no_such_stream,97)', 'existence_error(stream)', 'put_code/2 missing stream'],
      ['put_code(user_input,97)', 'permission_error(output, stream)', 'put_code/2 input stream'],
      ['put_code(1114112)', 'representation_error(character_code)', 'put_code/1 character-code representation'],
      ['nl(S)', 'instantiation_error', 'nl/1 stream instantiation'],
      ['nl(f(a))', 'domain_error(stream_or_alias)', 'nl/1 stream-or-alias domain'],
      ['nl(no_such_stream)', 'existence_error(stream)', 'nl/1 missing stream'],
      ['nl(user_input)', 'permission_error(output, stream)', 'nl/1 input stream'],
      ['get_byte(S,B)', 'instantiation_error', 'get_byte/2 stream instantiation'],
      ['get_byte(256)', 'type_error(in_byte)', 'get_byte/1 in-byte type'],
      ['get_byte(f(a),B)', 'domain_error(stream_or_alias)', 'get_byte/2 stream-or-alias domain'],
      ['get_byte(no_such_stream,B)', 'existence_error(stream)', 'get_byte/2 missing stream'],
      ['get_byte(user_output,B)', 'permission_error(input, stream)', 'get_byte/2 output stream'],
      ['get_byte(B)', 'permission_error(input, text_stream)', 'get_byte/1 text stream'],
      ['peek_byte(S,B)', 'instantiation_error', 'peek_byte/2 stream instantiation'],
      ['peek_byte(256)', 'type_error(in_byte)', 'peek_byte/1 in-byte type'],
      ['put_byte(S,1)', 'instantiation_error', 'put_byte/2 stream instantiation'],
      ['put_byte(X)', 'instantiation_error', 'put_byte/1 byte instantiation'],
      ['put_byte(256)', 'type_error(byte)', 'put_byte/1 byte type'],
      ['put_byte(f(a),1)', 'domain_error(stream_or_alias)', 'put_byte/2 stream-or-alias domain'],
      ['put_byte(no_such_stream,1)', 'existence_error(stream)', 'put_byte/2 missing stream'],
      ['put_byte(user_input,1)', 'permission_error(output, stream)', 'put_byte/2 input stream'],
      ['put_byte(1)', 'permission_error(output, text_stream)', 'put_byte/1 text stream'],
      ['read_term(S,T,[])', 'instantiation_error', 'read_term/3 stream instantiation'],
      ['read_term(f(a),T,[])', 'domain_error(stream_or_alias)', 'read_term/3 stream-or-alias domain'],
      ['read_term(T,foo)', 'type_error(list)', 'read_term/2 options list type'],
      ['read_term(T,[bogus])', 'domain_error(read_option)', 'read_term/2 read option domain'],
      ['read_term(no_such_stream,T,[])', 'existence_error(stream)', 'read_term/3 missing stream'],
      ['read_term(user_output,T,[])', 'permission_error(input, stream)', 'read_term/3 output stream'],
      ['write_term(S,a,[])', 'instantiation_error', 'write_term/3 stream instantiation'],
      ['write_term(f(a),a,[])', 'domain_error(stream_or_alias)', 'write_term/3 stream-or-alias domain'],
      ['write_term(a,foo)', 'type_error(list)', 'write_term/2 options list type'],
      ['write_term(a,[bogus])', 'domain_error(write_option)', 'write_term/2 write option domain'],
      ['write_term(no_such_stream,a,[])', 'existence_error(stream)', 'write_term/3 missing stream'],
      ['write_term(user_input,a,[])', 'permission_error(output, stream)', 'write_term/3 input stream'],
      ["op(100,xfy,',')", 'permission_error(modify, operator)', 'op/3 protects comma'],
      ['current_op(a,_,_)', 'domain_error(operator_priority)', 'current_op/3 priority domain'],
      ['current_op(1,1,_)', 'domain_error(operator_specifier)', 'current_op/3 specifier domain'],
      ['current_op(1,fx,1)', 'type_error(atom)', 'current_op/3 operator type'],
      ['char_conversion(X,a)', 'instantiation_error', 'char_conversion/2 input instantiation'],
      ['char_conversion(a,X)', 'instantiation_error', 'char_conversion/2 output instantiation'],
      ['char_conversion(ab,a)', 'representation_error(character)', 'char_conversion/2 input representation'],
      ['char_conversion(a,ab)', 'representation_error(character)', 'char_conversion/2 output representation'],
      ['current_char_conversion(ab,X)', 'type_error(character)', 'current_char_conversion/2 input type'],
      ['current_char_conversion(a,ab)', 'type_error(character)', 'current_char_conversion/2 output type'],
    ];
    for (const [goal, formal, label] of errors) {
      equal(capture(() => run('', { isoStrict: true, goal })).formal, formal, label);
    }

    const binaryInput = new Solver(Program.parse('', { isoStrict: true }), { isoStrict: true });
    binaryInput.io.add({
      id: 2, alias: 'bin_in', mode: 'read', type: 'binary', content: [65], position: 0, path: '',
      reposition: false, eofAction: 'error', standard: false, pastEnd: false,
    });
    for (const goal of ['get_char(bin_in,C)', 'get_code(bin_in,C)', 'peek_char(bin_in,C)', 'peek_code(bin_in,C)', 'read_term(bin_in,T,[])']) {
      equal(capture(() => [...binaryInput.solve([parseGoalText(goal, { isoStrict: true })], new Env(), 0)]).formal,
        'permission_error(input, binary_stream)', `${goal} binary stream`);
    }
    equal([...binaryInput.solve([parseGoalText('peek_byte(bin_in,65)', { isoStrict: true })], new Env(), 0)].length, 1,
      'peek_byte/2 successful binary mode');
    equal([...binaryInput.solve([parseGoalText('get_byte(bin_in,65)', { isoStrict: true })], new Env(), 0)].length, 1,
      'get_byte/2 successful binary mode');

    const binaryOutput = new Solver(Program.parse('', { isoStrict: true }), { isoStrict: true });
    binaryOutput.io.add({
      id: 2, alias: 'bin_out', mode: 'write', type: 'binary', content: [], position: 0, path: '',
      reposition: false, eofAction: 'error', standard: false, pastEnd: false,
    });
    for (const goal of ['put_char(bin_out,a)', 'put_code(bin_out,97)', 'nl(bin_out)', 'write_term(bin_out,a,[])']) {
      equal(capture(() => [...binaryOutput.solve([parseGoalText(goal, { isoStrict: true })], new Env(), 0)]).formal,
        'permission_error(output, binary_stream)', `${goal} binary stream`);
    }
    equal([...binaryOutput.solve([parseGoalText('put_byte(bin_out,65)', { isoStrict: true })], new Env(), 0)].length, 1,
      'put_byte/2 successful binary mode');

    const pastInput = new Solver(Program.parse('', { isoStrict: true }), { isoStrict: true });
    pastInput.io.add({
      id: 2, alias: 'past_in', mode: 'read', type: 'text', content: '', position: 0, path: '',
      reposition: false, eofAction: 'error', standard: false, pastEnd: true,
    });
    for (const goal of ['get_char(past_in,C)', 'get_code(past_in,C)', 'peek_char(past_in,C)', 'peek_code(past_in,C)', 'read_term(past_in,T,[])']) {
      equal(capture(() => [...pastInput.solve([parseGoalText(goal, { isoStrict: true })], new Env(), 0)]).formal,
        'permission_error(input, past_end_of_stream)', `${goal} past EOF`);
    }

    equal(capture(() => run('', {
      isoStrict: true,
      goal: 'read_term(T,[])',
      ioOptions: { input: "'unterminated." },
    })).formal, 'syntax_error(read_term)', 'read_term/2 syntax error');

    equal(run('', { isoStrict: true, goal: "char_conversion(a,b),current_char_conversion(a,b)" }).stats.completed_goal_lists, 1,
      'char_conversion/2 and current_char_conversion/2 successful mode');
    equal(run('', { isoStrict: true, goal: 'op(100,xf,zz),current_op(100,xf,zz)' }).stats.completed_goal_lists, 1,
      'op/3 and current_op/3 successful mode');
  });

  reporter.test('treats close force(true) as presence-based', () => {
    const closeWith = (options) => {
      const solver = new Solver(Program.parse('', { isoStrict: true }), { isoStrict: true });
      solver.io.add({
        id: 2, alias: 'tmp_out', mode: 'write', type: 'text', content: '', position: 0, path: '',
        reposition: false, eofAction: 'error', standard: false, pastEnd: false,
      });
      solver.io.close = () => { throw new Error('simulated close failure'); };
      const answers = [...solver.solve([parseGoalText(`close(tmp_out,${options})`, { isoStrict: true })], new Env(), 0)];
      equal(answers.length, 1, `${options} succeeds under force(true)`);
      equal(Boolean(solver.io.resolve('tmp_out')), false, `${options} discards stream`);
    };
    closeWith('[force(true),force(false)]');
    closeWith('[force(false),force(true)]');
  });

  reporter.test('closes the ISO 7.12 processor error envelope and classification rows', () => {
    const caught = [
      "catch(atom_length(X,N),error(instantiation_error,[atom_length/2]),true)",
      "catch(atom_length(1,N),error(type_error(atom,1),[atom_length/2]),true)",
      "catch(op(1300,xfx,foo),error(domain_error(operator_priority,1300),[op/3]),true)",
      "catch(call(no_such_predicate),error(existence_error(procedure,no_such_predicate/0),[]),true)",
      "catch(abolish(atom/1),error(permission_error(modify,static_procedure,atom/1),[abolish/1]),true)",
      "catch(char_code(C,1114112),error(representation_error(character_code),[char_code/2]),true)",
      "catch(X is 1/0,error(evaluation_error(zero_divisor),[(is)/2]),true)",
      "catch(X is 1<<4294967296,error(resource_error(memory),[(is)/2]),true)",
    ];
    for (const goal of caught) {
      equal(run('', { isoStrict: true, goal }).stats.completed_goal_lists, 1, goal);
    }

    equal(run('', {
      isoStrict: true,
      goal: "catch(read_term(T,[]),error(syntax_error(read_term),[read_term/2]),true)",
      ioOptions: { input: "'unterminated." },
    }).stats.completed_goal_lists, 1, 'syntax error uses error/2 envelope and implementation-defined context');

    const systemSolver = new Solver(Program.parse('', { isoStrict: true }), { isoStrict: true });
    systemSolver.io.flush = () => { throw new Error('simulated host I/O failure'); };
    equal([...systemSolver.solve([
      parseGoalText('catch(flush_output(user_output),error(system_error,[flush_output/1]),true)', { isoStrict: true }),
    ], new Env(), 0)].length, 1, 'system error uses error/2 envelope and implementation-defined context');

    // ISO 7.12 deliberately leaves the choice implementation-dependent when
    // several error conditions hold simultaneously. Existing overlap tests
    // above pin EyeProlog's deterministic choices without treating table order
    // as an additional normative requirement.
  });

  reporter.test('follows Part 1 arithmetic type and exceptional errors', () => {
    const cases = [
      ["X is '+'(foo,77)", 'type_error(evaluable)', 'STC #69 simple arithmetic atom is foo/0'],
      ['X is mod(foo,77)', 'type_error(evaluable)', 'integer arithmetic atom is non-evaluable'],
      ['X is mod(7.5,2)', 'type_error(integer)', 'integer arithmetic numeric type'],
      ['X is truncate(foo)', 'type_error(evaluable)', 'rounding atom is non-evaluable'],
      ['X is sin(foo)', 'type_error(evaluable)', 'transcendental atom is non-evaluable'],
      ['X is foo+Y', 'instantiation_error', 'direct variable before another operand error'],
      ['X is floor(7)', 'type_error(float)', 'floor integer operand'],
      ['X is truncate(7)', 'type_error(float)', 'truncate integer operand'],
      ['X is round(7)', 'type_error(float)', 'round integer operand'],
      ['X is ceiling(7)', 'type_error(float)', 'ceiling integer operand'],
      ['X is 0 ** -1', 'evaluation_error(undefined)', 'power zero negative exponent'],
      ['X is 0.0 ^ -1', 'evaluation_error(undefined)', 'Corrigendum 2 power zero negative exponent'],
    ];
    for (const [goal, formal, label] of cases) {
      equal(capture(() => run('', { isoStrict: true, goal })).formal, formal, label);
    }
  });

  reporter.test('uses the STC #69 evaluable culprit for atomic arithmetic expressions', () => {
    const error = capture(() => run('', { isoStrict: true, goal: "X is '+'(foo,77)" }));
    equal(error.formal, 'type_error(evaluable)', 'formal error');
    includes(error.message, '/(foo, 0)', 'foo/0 culprit');
  });

  reporter.test('applies integer-to-float conversion before floating evaluable functors', () => {
    const huge = `1${'0'.repeat(400)}`;
    for (const functor of ['float', 'sin', 'cos', 'atan', 'asin', 'acos', 'tan', 'exp', 'log', 'sqrt']) {
      equal(capture(() => run('', { isoStrict: true, goal: `X is ${functor}(${huge})` })).formal,
        'evaluation_error(float_overflow)', `${functor}/1 integer-to-float overflow`);
    }
  });

  reporter.test('tracks post-N289 STC draft items 73-76 without replacing the published baseline', () => {
    for (const [goal, input, expected, label] of [
      ['read(X)', '1.0e99999.\n', 'representation_error(max_float)', 'STC #73 read/1 max_float'],
      ['read_term(X,[])', '-1.0e99999.\n', 'representation_error(min_float)', 'STC #73 read_term/2 min_float'],
    ]) {
      equal(capture(() => run('', { isoStrict: true, goal, ioOptions: { input } })).formal, expected, label);
    }

    for (const [goal, expected, label] of [
      ["number_chars(N,['1','.','0',e,'9','9','9','9','9'])", 'representation_error(max_float)', 'STC #74 number_chars/2'],
      ['number_codes(N,[45,49,46,48,101,57,57,57,57,57])', 'representation_error(min_float)', 'STC #74 number_codes/2'],
    ]) equal(capture(() => run('', { isoStrict: true, goal })).formal, expected, label);

    // STC #75 proposes conditioning the published **/2 and Corrigendum 2 ^/2
    // underflow rows on the implementation-defined 9.1.4.2 resultF choice.
    // Until that proposal is standardized, strict mode keeps the published
    // unconditional error clauses; the draft divergence is documented.
    equal(capture(() => run('', { isoStrict: true, goal: 'X is 2.0 ** -1075.0' })).formal,
      'evaluation_error(underflow)', 'published **/2 underflow baseline');
    equal(capture(() => run('', { isoStrict: true, goal: 'X is 2.0 ^ -1075.0' })).formal,
      'evaluation_error(underflow)', 'published ^/2 underflow baseline');
  });

  reporter.test('reports explicit transcendental and power underflow in strict mode', () => {
    for (const [goal, label] of [
      ['X is exp(-1000.0)', 'exp/1 underflow'],
      ['X is 2.0 ** -1075.0', '**/2 underflow'],
      ['X is 2.0 ^ -1075.0', 'Corrigendum 2 ^/2 underflow'],
    ]) {
      equal(capture(() => run('', { isoStrict: true, goal })).formal,
        'evaluation_error(underflow)', label);
    }

    equal(run('', { isoStrict: true, goal: 'X is 0.0 ** 2.0' }).stats.completed_goal_lists,
      1, 'exact zero power remains zero');
    equal(run('', { isoStrict: true, goal: 'X is 4.9406564584124654e-324 * 0.5' }).stats.completed_goal_lists,
      1, 'generic resultF retains the selected round-to-zero policy');

    // Keep these stricter exceptional conditions confined to --iso-strict.
    equal(run('', { goal: 'X is exp(-1000.0)' }).stats.completed_goal_lists, 1, 'normal exp behavior');
    equal(run('', { goal: 'X is 2.0 ** -1075.0' }).stats.completed_goal_lists, 1, 'normal power behavior');
  });

  reporter.test('preserves prescribed power errors before integer-to-float conversion', () => {
    const hugeNegative = `-1${'0'.repeat(400)}`;
    equal(capture(() => run('', { isoStrict: true, goal: 'X is (-2) ** 2.0' })).formal,
      'evaluation_error(undefined)', '**/2 negative base requires integer-typed exponent');
    equal(run('', { isoStrict: true, goal: 'X is (-2.0) ** 2' }).stats.completed_goal_lists,
      1, '**/2 negative base with integer exponent');
    equal(run('', { isoStrict: true, goal: 'X is (-2) ^ 2.0' }).stats.completed_goal_lists,
      1, 'Corrigendum 2 ^/2 accepts integer-valued float exponent');
    equal(capture(() => run('', { isoStrict: true, goal: 'X is (-2) ^ 0.5' })).formal,
      'evaluation_error(undefined)', 'Corrigendum 2 ^/2 fractional exponent');
    equal(capture(() => run('', { isoStrict: true, goal: `X is ${hugeNegative} ** 0.5` })).formal,
      'evaluation_error(undefined)', 'undefined power precedes base conversion overflow');
    equal(capture(() => run('', { isoStrict: true, goal: `X is 0.0 ** (${hugeNegative})` })).formal,
      'evaluation_error(undefined)', 'zero-negative power precedes exponent conversion overflow');
  });

  reporter.test('closes the 5.5.6 additional side-effect extension boundary', () => {
    const normalRegistry = getEyePrologRegistry();
    const strictRegistry = createStrictIsoRegistry();
    equal(Boolean(normalRegistry.get('statistics', 0)), true, 'normal statistics/0 side-effect extension');
    equal(Boolean(strictRegistry.get('statistics', 0)), false, 'strict statistics/0 excluded');
    equal(Boolean(strictRegistry.get('statistics', 2)), false, 'strict statistics/2 excluded');
    equal(Boolean(strictRegistry.get('call_cleanup', 2)), false, 'strict cleanup extension excluded');
    equal(Boolean(strictRegistry.get('setup_call_cleanup', 3)), false, 'strict setup/cleanup extension excluded');
    equal(capture(() => run('', { isoStrict: true, goal: 'statistics' })).formal,
      'existence_error(procedure)', 'strict execution cannot invoke statistics/0');
  });

  reporter.test('closes the 5.5.10 evaluable-functor extension boundary', () => {
    const strictExtension = capture(() => run('', { isoStrict: true, goal: 'X is e' }));
    equal(strictExtension.formal, 'type_error(evaluable)', 'normal-only e/0 is not evaluable in strict mode');
    equal(run('', { goal: 'X is e' }).stats.completed_goal_lists, 1, 'normal e/0 extension remains available');

    for (const goal of [
      'X is +1',
      'X is -7 div 3',
      'X is max(2,3.0)',
      'X is min(2.0,3)',
      'X is 3^3',
      'X is asin(0)',
      'X is acos(1)',
      'X is atan2(1,0)',
      'X is tan(0)',
      'X is pi',
      'X is xor(10,12)',
    ]) equal(run('', { isoStrict: true, goal }).stats.completed_goal_lists, 1, `Corrigendum evaluable ${goal}`);
  });

  reporter.test('pins Corrigendum 2 mixed-type max/min implementation-dependent behavior', () => {
    for (const goal of [
      'X is max(2.0,3), X == 3',
      'X is max(2,3.0), X == 3.0',
      'X is min(2.0,3), X == 2.0',
      'X is min(2,3.0), X == 2',
      'X is max(0,0.0), X == 0',
      'X is max(0.0,0), X == 0.0',
    ]) equal(run('', { isoStrict: true, goal }).stats.completed_goal_lists, 1, goal);

    // Corrigendum 2 permits several mixed-type choices, including returning
    // one of the original operands without converting the integer to float.
    // EyeProlog compares the mathematical values exactly and preserves the
    // selected operand's original type, so a huge integer does not create a
    // float-overflow merely because the other operand is a float.
    const huge = `1${'0'.repeat(400)}`;
    equal(run('', { isoStrict: true, goal: `X is max(${huge},1.0), X == ${huge}` }).stats.completed_goal_lists,
      1, 'mixed max/2 does not force integer-to-float conversion');
    equal(run('', { isoStrict: true, goal: `X is min(${huge},1.0), X == 1.0` }).stats.completed_goal_lists,
      1, 'mixed min/2 preserves selected float operand');
  });

  reporter.test('pins implementation-defined Clause 9.4 signed bitwise and shift behavior', () => {
    for (const goal of [
      'X is ((-16) >> 2), X == -4',
      'X is (16 >> -2), X == 64',
      'X is (16 << -2), X == 4',
      'X is ((-1) /\\ 5), X == 5',
      'X is ((-1) \\/ 5), X == -1',
      'X is xor(-1,5), X == -6',
      'X is \\ 5, X == -6',
    ]) equal(run('', { isoStrict: true, goal }).stats.completed_goal_lists, 1, goal);
  });


  reporter.test('closes the ISO 7.9 and Clause 9 evaluable-functor rows', () => {
    for (const goal of [
      'X is 7+35, X==42',
      'X is 7-35, X== -28',
      'X is 7*5, X==35',
      'X is 7/2, X =:= 3.5',
      'X is 7//(-3), X== -2',
      'X is 7 div (-3), X== -3',
      'X is (-7) rem 3, X== -1',
      'X is (-7) mod 3, X==2',
      'X is +7, X==7',
      'X is -7, X== -7',
      'X is abs(-7), X==7',
      'X is sign(-7), X== -1',
      'X is float(7), X =:= 7.0',
      'X is floor(1.9), X==1',
      'X is truncate(-1.9), X== -1',
      'X is round(1.4), X==1',
      'X is ceiling(1.1), X==2',
      'X is float_integer_part(1.5), X =:= 1.0',
      'X is float_fractional_part(-1.5), X =:= -0.5',
      'X is 2 ** 3, X =:= 8.0',
      'X is sin(0), X =:= 0.0',
      'X is cos(0), X =:= 1.0',
      'X is atan(0), X =:= 0.0',
      'X is exp(0), X =:= 1.0',
      'X is log(1), X =:= 0.0',
      'X is sqrt(4), X =:= 2.0',
      'X is max(2,3.0), X==3.0',
      'X is min(2.0,3), X==2.0',
      'X is 3^3, X==27',
      'X is asin(0), X =:= 0.0',
      'X is acos(1), X =:= 0.0',
      'X is atan2(1,0), X > 1.5',
      'X is tan(0), X =:= 0.0',
      'X is pi, X > 3.14',
      'X is xor(10,12), X==6',
      'X is (10 /\\ 12), X==8',
      'X is (10 \\/ 12), X==14',
      'X is (8 << 2), X==32',
      'X is (8 >> 2), X==2',
      'X is \\ 5, X== -6',
    ]) equal(run('', { isoStrict: true, goal }).stats.completed_goal_lists, 1, goal);

    const huge = `1${'0'.repeat(400)}`;
    for (const functor of ['float_integer_part', 'float_fractional_part']) {
      equal(capture(() => run('', { isoStrict: true, goal: `X is ${functor}(${huge})` })).formal,
        'type_error(float)', `${functor}/1 float-only template precedes I->F overflow`);
    }

    for (const [goal, formal, label] of [
      ['X is Y+1', 'instantiation_error', 'direct variable expression'],
      ['X is foo', 'type_error(evaluable)', 'non-evaluable atom'],
      ['X is 1.5 // 1', 'type_error(integer)', 'integer-only arithmetic'],
      ['X is floor(1)', 'type_error(float)', 'float-only rounding'],
      ['X is 1/0', 'evaluation_error(zero_divisor)', 'floating division zero'],
      ['X is 1 div 0', 'evaluation_error(zero_divisor)', 'integer division zero'],
      ['X is log(0)', 'evaluation_error(undefined)', 'log domain'],
      ['X is sqrt(-1)', 'evaluation_error(undefined)', 'sqrt domain'],
      ['X is asin(2)', 'evaluation_error(undefined)', 'asin domain'],
      ['X is acos(2)', 'evaluation_error(undefined)', 'acos domain'],
      ['X is atan2(0,0)', 'evaluation_error(undefined)', 'atan2 zero pair'],
      ['X is 0 ** -1', 'evaluation_error(undefined)', 'power zero-negative'],
      ['X is (-2) ** 0.5', 'evaluation_error(undefined)', 'negative-base power'],
      ['X is exp(1000.0)', 'evaluation_error(float_overflow)', 'transcendental overflow'],
      ['X is exp(-1000.0)', 'evaluation_error(underflow)', 'transcendental underflow'],
      ['X is 2.0 ** -1075.0', 'evaluation_error(underflow)', 'published power underflow'],
    ]) equal(capture(() => run('', { isoStrict: true, goal })).formal, formal, label);
  });

  reporter.test('uses the Part 1 mixed arithmetic comparison operations', () => {
    // 8.7 converts the integer operand to float in mixed comparisons.
    equal(run('', { isoStrict: true, goal: '18014398509481985 =:= 18014398509481984.0' }).stats.completed_goal_lists,
      1, 'mixed equality after float conversion');
    equal(run('', { isoStrict: true, goal: '\\+ (18014398509481985 > 18014398509481984.0)' }).stats.completed_goal_lists,
      1, 'mixed ordering after float conversion');
    const huge = `1${'0'.repeat(400)}`;
    equal(capture(() => run('', { isoStrict: true, goal: `${huge} > 1.0` })).formal,
      'evaluation_error(float_overflow)', 'mixed integer-to-float overflow');

    // The normal profile retains EyeProlog's exact cross-type extension.
    equal(run('', { goal: '9007199254740993 > 9007199254740992.0' }).stats.completed_goal_lists,
      1, 'normal exact mixed ordering extension');
  });

  reporter.test('follows ISO term-construction error types and precedence', () => {
    equal(capture(() => run('', { isoStrict: true, goal: 'functor(_,foo(a),1)' })).formal,
      'type_error(atomic)', 'functor compound name');
    equal(capture(() => run('', { isoStrict: true, goal: 'functor(_,foo(a),bad)' })).formal,
      'type_error(atomic)', 'functor name error before arity type');
    equal(capture(() => run('', { isoStrict: true, goal: "'=..'(foo,bar)" })).formal,
      'type_error(list)', '=../2 fixed non-list');
  });

  reporter.test('keeps Corrigendum 2 call/N compatible with unbounded max_arity', () => {
    // Corrigendum 2 prescribes representation_error(max_arity) only when the
    // resulting closure exceeds a finite max_arity. With the selected
    // `unbounded` value that conditional branch does not apply.
    equal(run('', { isoStrict: true, goal: "call(=(x),x)" }).stdout,
      'call(=(x), x).\n', 'call/2 closure expansion');
  });

  reporter.test('reports the complete List culprit for Corrigendum 2 atomic conversions', () => {
    for (const goal of ['atom_chars(A,[a|foo])', 'atom_codes(A,[97|foo])']) {
      const error = capture(() => run('', { isoStrict: true, goal }));
      equal(error.formal, 'type_error(list)', `${goal} formal`);
      includes(error.message, '[', `${goal} complete list culprit`);
      if (error.message.endsWith(', foo)')) throw new Error(`${goal}: reported only the improper tail`);
    }
  });

  reporter.test('keeps the selected clause/2 private-procedure overlap behavior', () => {
    equal(capture(() => run('p.\n', { isoStrict: true, goal: 'clause(atom(_),4)' })).formal,
      'permission_error(access, private_procedure)', 'private procedure before body callability');
  });

  reporter.test('keeps the selected all-solutions Goal-before-Instances overlap behavior', () => {
    for (const predicate of ['findall', 'bagof', 'setof']) {
      equal(capture(() => run('', { isoStrict: true, goal: `${predicate}(X,Y,foo)` })).formal,
        'instantiation_error', `${predicate}/3 variable goal`);
      equal(capture(() => run('', { isoStrict: true, goal: `${predicate}(X,4,foo)` })).formal,
        'type_error(callable)', `${predicate}/3 non-callable goal`);
    }
  });

  reporter.test('uses the Part 1 predefined operator table', () => {
    const program = Program.parse('', { isoStrict: true });
    equal(program.operators.has('fx\u0000?-'), true, 'fx ?-');
    equal(program.operators.has('xfx\u0000?-'), false, 'xfx ?-');
  });

  reporter.test('pins applicable post-Corrigendum STC clarifications', () => {
    equal(capture(() => run('', { isoStrict: true, goal: 'X is 1/0+_' })).formal,
      'instantiation_error', 'STC 17 direct variable precedes zero divisor on the other branch');
    equal(capture(() => run('', { isoStrict: true, goal: 'X is _+1/0' })).formal,
      'instantiation_error', 'STC 17 is independent of operand order');

    equal(run('', { isoStrict: true, goal: 'integer(- /**/ 1)' }).stats.completed_goal_lists,
      1, 'layout between minus and integer token');
    equal(run('', { isoStrict: true, goal: "number_chars(N,['0','1']),N=1" }).stats.completed_goal_lists,
      1, 'STC 32 number_chars/2 follows the procedural number syntax for leading zero');

    const shared = run(
      ':- dynamic(a/1).\na(X) :- b(X).\n',
      { isoStrict: true, goal: 'clause(a(A),b(B)),A==B,A=ok' },
    );
    equal(shared.stats.completed_goal_lists, 1, 'clause/2 preserves head/body variable identity');

    equal(capture(() => run('', { isoStrict: true, goal: 'char_code(_,c)' })).formal,
      'type_error(integer)', 'char_code/2 non-integer code');
    equal(capture(() => run('', { isoStrict: true, goal: 'set_prolog_flag(unknown,_)' })).formal,
      'instantiation_error', 'set_prolog_flag/2 variable value');
    equal(run('', {
      isoStrict: true,
      goal: 'read(T),T=end_of_file',
      ioOptions: { input: '' },
    }).stats.completed_goal_lists, 1, 'read/1 end_of_file');
    includes(run('', {
      isoStrict: true,
      goal: 'bagof(X,(X=2;X=1),S),S=[2,1],X=ok',
    }).stdout, '[2, 1]', 'bagof/3 preserves answer order');

    Program.parse(':- op(500,xfx,foo).\na foo b.\n', { isoStrict: true });
    const beforeDefinition = capture(() => Program.parse('a foo b.\n:- op(500,xfx,foo).\n', { isoStrict: true }));
    includes(beforeDefinition.message, 'expected .', 'STC 41 op/3 directive applies only to following text');

    equal(run('', {
      isoStrict: true,
      goal: 'read_term(T,[variables([])])',
      ioOptions: { input: 'T.' },
    }).stats.completed_goal_lists, 0, 'STC 48 variables([]) does not match an input variable');
  });

  reporter.test('closes ISO 7.4 Prolog-text preparation and directive rows', () => {
    const directory = mkdtempSync(join(tmpdir(), 'eyeprolog-iso-74-'));
    try {
      writeFileSync(join(directory, 'child.pl'), [
        'child.',
        ":- op(500,'xfx',trusts).",
        'child_rule(carol trusts dave).',
        '',
      ].join('\n'));
      writeFileSync(join(directory, 'once.pl'), 'once_loaded.\n');
      const source = [
        ':- op(500,xfx,likes).',
        ':- char_conversion(x,y).',
        ':- set_prolog_flag(double_quotes,codes).',
        ':- dynamic(seen/1).',
        ':- initialization(assertz(seen(1))).',
        ':- initialization(assertz(seen(2))).',
        ":- include('child.pl').",
        ":- ensure_loaded('once.pl').",
        ":- ensure_loaded('once.pl').",
        'relation(alice likes bob).',
        'parent_rule(alice trusts bob).',
        'converted(x).',
        'quoted("ab").',
        '',
      ].join('\n');
      const program = Program.parseSources([{ text: source, filename: 'main.pl', baseDir: directory }], {
        isoStrict: true,
        sourceMetadata: true,
      });

      equal(program.findGroup('child', 0)?.clauses.length, 1, 'include/1 textual inclusion');
      equal(program.findGroup('once_loaded', 0)?.clauses.length, 1, 'ensure_loaded/1 loads once');
      equal(program.findGroup('relation', 1)?.clauses[0]?.head?.args[0]?.name, 'likes', 'op/3 affects following text');
      equal(program.findGroup('parent_rule', 1)?.clauses[0]?.head?.args[0]?.name, 'trusts', 'included op/3 affects following parent text');
      equal(program.findGroup('converted', 1)?.clauses[0]?.head?.args[0]?.name, 'y', 'char_conversion/2 affects following unquoted source');
      equal(run(program, { isoStrict: true, goal: 'quoted([97,98])' }).stats.completed_goal_lists > 0, true,
        'set_prolog_flag/2 affects following source and execution');

      const first = run(program, { isoStrict: true, goal: 'findall(X,seen(X),[1,2])' });
      const second = run(program, { isoStrict: true, goal: 'findall(X,seen(X),[1,2])' });
      equal(first.stats.completed_goal_lists > 0, true, 'initialization/1 order');
      equal(second.stats.completed_goal_lists > 0, true, 'initialization/1 executes once per prepared Program');
    } finally {
      rmSync(directory, { recursive: true, force: true });
    }
  });

  reporter.test('closes ISO 7.5-7.7 database, conversion, and execution rows', () => {
    const source = [
      ':- dynamic(p/1).',
      ':- dynamic(empty/0).',
      'p(1).',
      'p(2).',
      'body(X) :- X.',
      '',
    ].join('\n');

    equal(run(source, {
      isoStrict: true,
      goal: 'findall(X,(p(X),retract(p(X))),Xs),Xs=[1,2],\\+p(_)',
    }).stats.completed_goal_lists > 0, true, 'logical-update view and source clause order');
    equal(run(source, { isoStrict: true, goal: '\\+ empty' }).stats.completed_goal_lists > 0, true,
      'declared empty procedure fails as a defined procedure');
    equal(capture(() => run(source, { isoStrict: true, goal: 'missing' })).formal,
      'existence_error(procedure)', 'unknown procedure remains distinct from empty procedure');
    equal(run('', {
      isoStrict: true,
      goal: 'assertz(fresh(a)),current_predicate(fresh/1),clause(fresh(a),true)',
    }).stats.completed_goal_lists > 0, true, 'asserting a new procedure makes it dynamic/public');
    equal(run(source, { isoStrict: true, goal: 'body(true)' }).stats.completed_goal_lists > 0, true,
      'source variable body is converted to call/1');
  });

  reporter.test('closes ISO 7.8 general control-construct and exception rows', () => {
    equal(run('', { isoStrict: true, goal: 'true' }).stats.completed_goal_lists, 1, 'true/0');
    equal(run('', { isoStrict: true, goal: 'fail' }).stats.completed_goal_lists, 0, 'fail/0');
    equal(run('', { isoStrict: true, goal: 'X=true,call(X)' }).stats.completed_goal_lists > 0, true,
      'call/1 executes the converted goal');
    equal(run('', { isoStrict: true, goal: '(fail;true)' }).stats.completed_goal_lists > 0, true,
      'disjunction backtracks to the second branch');
    equal(run('', { isoStrict: true, goal: '(true->true;fail)' }).stats.completed_goal_lists > 0, true,
      'if-then-else commits after a successful condition');
    equal(capture(() => run('', { isoStrict: true, goal: 'call((write(a),3))' })).formal,
      'type_error(callable)', 'nested non-callable control term is rejected');
    let issue93Output = '';
    const issue93Error = capture(() => run('', {
      isoStrict: true,
      goal: 'X=3,Y=(write(X),X),call(Y)',
      ioOptions: { write: (chunk) => { issue93Output += chunk; } },
    }));
    equal(issue93Error.formal, 'type_error(callable)', 'issue #93 raises the ISO callability error');
    equal(issue93Error.message, 'error(type_error(callable), (write(3), 3))',
      'issue #93 reports the fully instantiated control-term culprit');
    equal(issue93Output, '', 'issue #93 validates the complete body before executing write/1');
    equal(run('', {
      isoStrict: true,
      goal: 'catch(X,error(instantiation_error,_),true)',
    }).stats.completed_goal_lists > 0, true, 'Corrigendum 2 catch/3 can catch callability errors from its protected goal');
    equal(run('', {
      isoStrict: true,
      goal: 'catch(throw(ball(X)),ball(Y),X=Y)',
    }).stats.completed_goal_lists > 0, true, 'throw/1 and catch/3 unify through a renamed thrown term');

    const answerCount = (text) => {
      const program = Program.parse('', { isoStrict: true });
      const solver = new Solver(program, { isoStrict: true });
      return [...solver.solve([parseGoalText(text, {
        isoStrict: true,
        operatorDefinitions: [...program.operators.values()],
      })], new Env(), 0)].length;
    };
    equal(answerCount('call((Z=!, (X=1;X=2), Z)) ; T=end'), 3,
      'call/1 converts an initially unbound variable goal before it can become a cut (issue #86)');
    equal(answerCount('call((Z=!, (X=1;X=2), Z, X=2))'), 1,
      'call(Var) cut remains opaque to choices made earlier in the converted body');
    equal(answerCount('Z=!, (call(((X=1;X=2),Z)) ; T=end)'), 2,
      'a variable already bound before call/1 conversion is dereferenced as a direct cut');
  });

  reporter.test('rejects EyeProlog module directives', () => {
    const error = capture(() => Program.parse(':- use_module(library(lists)).\n', { isoStrict: true }));
    includes(error.message, 'implementation-specific directive use_module/1', 'message');
  });

  reporter.test('does not expand Part 3 grammar rules', () => {
    const program = Program.parse('sentence --> [a].\n', { isoStrict: true });
    equal(Boolean(program.findGroup('-->', 2)), true, '-->/2');
    equal(Boolean(program.findGroup('sentence', 2)), false, 'sentence/2');
  });

  reporter.test('rejects clauses for standardized built-ins', () => {
    const error = capture(() => Program.parse('true.\n', { isoStrict: true }));
    equal(error.formal, 'permission_error(modify, static_procedure)', 'formal error');
  });

  reporter.test('keeps static procedures private to clause/2', () => {
    const program = Program.parse('p.\n', { isoStrict: true });
    const solver = new Solver(program, { isoStrict: true });
    const error = capture(() => [...solver.solve([
      parseGoalText('clause(p,B)', { isoStrict: true }),
    ], new Env(), 0)]);
    equal(error.formal, 'permission_error(access, private_procedure)', 'formal error');
  });

  reporter.test('keeps dynamic procedures public to clause/2', () => {
    const program = Program.parse(':- dynamic(p/0).\np.\n', { isoStrict: true });
    const solver = new Solver(program, { isoStrict: true });
    const answers = [...solver.solve([
      parseGoalText('clause(p,B)', { isoStrict: true }),
    ], new Env(), 0)];
    equal(answers.length, 1, 'answer count');
  });

  reporter.test('protects conjunction as an ISO static/private control construct at runtime', () => {
    for (const goal of [
      "asserta(','(a,b))",
      "assertz(','(a,b))",
      "retract(','(a,b))",
      "retractall(','(a,b))",
      "abolish('/'(',',2))",
    ]) {
      equal(capture(() => run('', { isoStrict: true, goal })).formal,
        'permission_error(modify, static_procedure)', goal);
    }
    equal(capture(() => run('', { isoStrict: true, goal: "clause(','(a,b),_)" })).formal,
      'permission_error(access, private_procedure)', 'clause/2 conjunction access');
  });

  reporter.test('protects directive and rule functors from database modification per STC 56', () => {
    const protectedGoals = [
      "asserta(((':-'(a,b)):-true))",
      "asserta(((':-'(b)):-true))",
      "assertz(((':-'(a,b)):-true))",
      "retract((':-'(a,b):-true))",
      "retractall((':-'(a,b):-true))",
      "abolish('/'(':-',2))",
      "abolish('/'(':-',1))",
    ];
    for (const goal of protectedGoals) {
      equal(capture(() => run('', { isoStrict: true, goal })).formal,
        'permission_error(modify, static_procedure)', goal);
    }
    equal(capture(() => run('', { isoStrict: true, goal: "clause(':-'(a,b),_)" })).formal,
      'permission_error(access, private_procedure)', 'clause/2 (:-)/2 access');
    equal(capture(() => run('', { isoStrict: true, goal: "clause(':-'(b),_)" })).formal,
      'permission_error(access, private_procedure)', 'clause/2 (:-)/1 access');
    equal(capture(() => run('', { isoStrict: true, goal: "call(':-'(a,b))" })).formal,
      'existence_error(procedure)', 'STC 56 keeps calls distinct from modification');
    equal(capture(() => Program.parse(":- dynamic('/'(':-',2)).\n", { isoStrict: true })).formal,
      'permission_error(modify, static_procedure)', 'preparation-time (:-)/2 declaration protection');
  });

  reporter.test('reports finite host exhaustion without imposing ISO representation bounds', () => {
    equal(capture(() => run('', { isoStrict: true, goal: 'functor(T,f,4294967296)' })).formal,
      'resource_error(memory)', 'unbounded max_arity host array exhaustion');
    equal(capture(() => run('', { isoStrict: true, goal: 'X is 1 << 4294967296' })).formal,
      'resource_error(memory)', 'unbounded integer shift host exhaustion');
    equal(capture(() => run('', { isoStrict: true, goal: 'X is 2 ^ 4294967296' })).formal,
      'resource_error(memory)', 'unbounded integer power host exhaustion');
    equal(run('', { isoStrict: true, goal: 'current_prolog_flag(max_arity,unbounded)' }).stats.completed_goal_lists,
      1, 'resource handling does not reintroduce a finite max_arity');
  });

  reporter.test('converts asserted control bodies recursively per ISO 7.6.2', () => {
    const source = ':- dynamic(p/0).\n:- dynamic(q/0).\n:- dynamic(r/0).\n';
    const disjunction = run(source, {
      isoStrict: true,
      goal: 'assertz((p :- (X;true))), clause(p,B), arg(1,B,L), nonvar(L), functor(L,call,1)',
    });
    equal(disjunction.stats.completed_goal_lists, 1, 'variable in asserted disjunction becomes call/1');

    const ifThenElse = run(source, {
      isoStrict: true,
      goal: 'assertz((q :- (X->Y;Z))), clause(q,B), arg(1,B,I), arg(1,I,XG), arg(2,I,YG), arg(2,B,ZG), nonvar(XG), nonvar(YG), nonvar(ZG), functor(XG,call,1), functor(YG,call,1), functor(ZG,call,1)',
    });
    equal(ifThenElse.stats.completed_goal_lists, 1, 'variables in asserted if-then-else become call/1');

    const disjunctionError = capture(() => run(source, { isoStrict: true, goal: 'assertz((r :- (true;4)))' }));
    equal(disjunctionError.formal, 'type_error(callable)', 'invalid asserted disjunction rejected during conversion');
    includes(disjunctionError.message, "';'(true, 4)", 'asserted disjunction error identifies body');

    const conjunctionError = capture(() => run(source, { isoStrict: true, goal: 'asserta((r :- (true,4)))' }));
    equal(conjunctionError.formal, 'type_error(callable)', 'invalid asserted conjunction rejected during conversion');
    includes(conjunctionError.message, '(true, 4)', 'asserted conjunction error identifies body');
  });

  reporter.test('closes the ISO 8.2-8.5 prescribed mode/error rows', () => {
    const cases = [
      ['compare(1,3,3.0)', 'type_error(atom)', 'compare/3 order type'],
      ['compare(>=,3,3.0)', 'domain_error(order)', 'compare/3 order domain'],
      ['sort([1|T],_)', 'instantiation_error', 'sort/2 partial input'],
      ['sort(foo,_)', 'type_error(list)', 'sort/2 input list type'],
      ['sort([],foo)', 'type_error(list)', 'sort/2 output list type'],
      ['keysort([1-a|T],_)', 'instantiation_error', 'keysort/2 partial input'],
      ['keysort(foo,_)', 'type_error(list)', 'keysort/2 input list type'],
      ['keysort([],foo)', 'type_error(list)', 'keysort/2 output list type'],
      ['keysort([X],_)', 'instantiation_error', 'keysort/2 variable pair'],
      ['keysort([foo],_)', 'type_error(pair)', 'keysort/2 input pair type'],
      ['keysort([],[foo])', 'type_error(pair)', 'keysort/2 output pair type'],
      ['functor(X,Y,3)', 'instantiation_error', 'functor/3 Name instantiation'],
      ['functor(X,foo,N)', 'instantiation_error', 'functor/3 Arity instantiation'],
      ['functor(X,foo(a),a)', 'type_error(atomic)', 'functor/3 Name atomic type before Arity type'],
      ['functor(X,foo,a)', 'type_error(integer)', 'functor/3 Arity integer type'],
      ['functor(X,1.5,1)', 'type_error(atom)', 'functor/3 positive-arity atom name'],
      ['functor(X,foo,-1)', 'domain_error(not_less_than_zero)', 'functor/3 non-negative arity'],
      ['arg(X,foo(a),_)', 'instantiation_error', 'arg/3 index instantiation'],
      ['arg(1,X,_)', 'instantiation_error', 'arg/3 term instantiation'],
      ['arg(a,foo(a),_)', 'type_error(integer)', 'arg/3 index type'],
      ['arg(0,atom,_)', 'type_error(compound)', 'arg/3 term type before index domain'],
      ['arg(-1,foo(a),_)', 'domain_error(not_less_than_zero)', 'arg/3 index domain'],
      ['X=..Y', 'instantiation_error', '=../2 both variables'],
      ['X=..[foo|T]', 'instantiation_error', '=../2 partial list'],
      ['X=..foo', 'type_error(list)', '=../2 list type'],
      ['X=..[F,a]', 'instantiation_error', '=../2 head instantiation'],
      ['X=..[3,a]', 'type_error(atom)', '=../2 compound functor atom type'],
      ['X=..[foo(a)]', 'type_error(atomic)', '=../2 singleton atomic type'],
      ['X=..[]', 'domain_error(non_empty_list)', '=../2 non-empty list'],
      ['term_variables(t,[X|foo])', 'type_error(list)', 'term_variables/2 output list type'],
    ];
    for (const [goal, formal, label] of cases) {
      equal(capture(() => run('', { isoStrict: true, goal })).formal, formal, label);
    }

    for (const goal of [
      'unify_with_occurs_check(X,1)',
      'subsumes_term(f(X,Y),f(Z,Z))',
      'compare(<,a,b)',
      'sort([1,1],[1])',
      'keysort([2-b,1-a],[1-a,2-b])',
      'copy_term(f(X,X),f(Y,Y))',
      'term_variables(A+B+B,[A,B])',
    ]) {
      equal(run('', { isoStrict: true, goal }).stats.completed_goal_lists, 1, `${goal} mode`);
    }
  });

  reporter.test('closes the ISO 8.6-8.10 prescribed mode/error rows', () => {
    const errors = [
      ['X is Y', 'instantiation_error', 'is/2 variable expression'],
      ['X is foo', 'type_error(evaluable)', 'is/2 expression evaluation error'],
      ['X =:= 1', 'instantiation_error', '=:=/2 left variable'],
      ['1 =:= X', 'instantiation_error', '=:=/2 right variable'],
      ['X =\\= 1', 'instantiation_error', '=\\=/2 left variable'],
      ['1 < X', 'instantiation_error', '</2 right variable'],
      ['X =< 1', 'instantiation_error', '=</2 left variable'],
      ['1 > X', 'instantiation_error', '>/2 right variable'],
      ['X >= 1', 'instantiation_error', '>=/2 left variable'],
      ['foo =:= 1', 'type_error(evaluable)', 'arithmetic comparison evaluation error'],
      ['clause(X,_)', 'instantiation_error', 'clause/2 variable head'],
      ['clause(4,_)', 'type_error(callable)', 'clause/2 head type'],
      ['current_predicate(4)', 'type_error(predicate_indicator)', 'current_predicate/1 indicator type'],
      ['asserta(_)', 'instantiation_error', 'asserta/1 variable head'],
      ['asserta(4)', 'type_error(callable)', 'asserta/1 head type'],
      ['asserta((p:-4))', 'type_error(callable)', 'asserta/1 body conversion'],
      ['assertz(_)', 'instantiation_error', 'assertz/1 variable head'],
      ['assertz(4)', 'type_error(callable)', 'assertz/1 head type'],
      ['assertz((p:-4))', 'type_error(callable)', 'assertz/1 body conversion'],
      ['retract(_)', 'instantiation_error', 'retract/1 variable head'],
      ['retract(4)', 'type_error(callable)', 'retract/1 head type'],
      ['retractall(_)', 'instantiation_error', 'retractall/1 variable head'],
      ['retractall(4)', 'type_error(callable)', 'retractall/1 head type'],
      ['abolish(X)', 'instantiation_error', 'abolish/1 variable indicator'],
      ['abolish(foo/X)', 'instantiation_error', 'abolish/1 variable arity'],
      ['abolish(foo)', 'type_error(predicate_indicator)', 'abolish/1 indicator type'],
      ['abolish(foo/a)', 'type_error(integer)', 'abolish/1 arity type'],
      ['abolish(4/1)', 'type_error(atom)', 'abolish/1 name type'],
      ['abolish(foo/(-1))', 'domain_error(not_less_than_zero)', 'abolish/1 negative arity'],
      ['findall(X,Y,L)', 'instantiation_error', 'findall/3 variable goal'],
      ['findall(X,4,L)', 'type_error(callable)', 'findall/3 goal type'],
      ['findall(X,true,foo)', 'type_error(list)', 'findall/3 Instances type'],
      ['bagof(X,Y,L)', 'instantiation_error', 'bagof/3 variable iterated goal'],
      ['bagof(X,4,L)', 'type_error(callable)', 'bagof/3 iterated-goal type'],
      ['bagof(X,true,foo)', 'type_error(list)', 'bagof/3 Instances type'],
      ['setof(X,Y,L)', 'instantiation_error', 'setof/3 variable iterated goal'],
      ['setof(X,4,L)', 'type_error(callable)', 'setof/3 iterated-goal type'],
      ['setof(X,true,foo)', 'type_error(list)', 'setof/3 Instances type'],
    ];
    for (const [goal, formal, label] of errors) {
      equal(capture(() => run('', { isoStrict: true, goal })).formal, formal, label);
    }

    for (const goal of [
      'X is 1+2, X=3',
      '1 =:= 1',
      '1 =\\= 2',
      '1 < 2',
      '1 =< 1',
      '2 > 1',
      '2 >= 2',
      'findall(X,(X=1;X=2),[1,2])',
      'bagof(X,(X=1;X=2),[1,2])',
      'setof(X,(X=2;X=1;X=2),[1,2])',
    ]) {
      equal(run('', { isoStrict: true, goal }).stats.completed_goal_lists > 0, true, `${goal} successful mode`);
    }
    equal(run('', { isoStrict: true, goal: '4 is 1+2' }).stats.completed_goal_lists, 0, 'is/2 failed unification');
    equal(run('', { isoStrict: true, goal: 'bagof(X,fail,L)' }).stats.completed_goal_lists, 0, 'bagof/3 empty solution set fails');
    equal(run('', { isoStrict: true, goal: 'setof(X,fail,L)' }).stats.completed_goal_lists, 0, 'setof/3 empty solution set fails');

    const current = run('p(a).\nq.\n', { isoStrict: true, goal: 'current_predicate(p/1)' });
    equal(current.stats.completed_goal_lists, 1, 'current_predicate/1 finds a user procedure');
  });

  reporter.test('preserves 7.6.2 source-body conversion identity for clause/2 and retract/1', () => {
    const source = [
      ':- dynamic(foo/1).',
      'foo(X) :- X.',
      ':- dynamic(bar/1).',
      'bar(X) :- (X ; true).',
      ':- dynamic(baz/1).',
      'baz(X) :- (X -> true).',
      '',
    ].join('\n');
    equal(run(source, { isoStrict: true, goal: 'clause(foo(C),call(C))' }).stats.completed_goal_lists, 1,
      'variable body converts to call/1 with head sharing');
    equal(run(source, { isoStrict: true, goal: 'clause(bar(C),(call(C);true))' }).stats.completed_goal_lists, 1,
      'disjunction recursively converts a variable branch');
    equal(run(source, { isoStrict: true, goal: 'clause(baz(C),(call(C)->true))' }).stats.completed_goal_lists, 1,
      'if-then recursively converts a variable branch');
    equal(run(source, { isoStrict: true, goal: 'retract((foo(C):-call(C)))' }).stats.completed_goal_lists, 1,
      'retract/1 sees the converted body with shared variables');
  });

  reporter.test('closes the ISO 8.15-8.17 prescribed mode/error rows', () => {
    const cases = [
      ['\\+(X)', 'instantiation_error', '\+/1 variable goal'],
      ['\\+(3)', 'type_error(callable)', '\+/1 callable type'],
      ['once(X)', 'instantiation_error', 'once/1 variable goal'],
      ['once(3)', 'type_error(callable)', 'once/1 callable type'],
      ['call(X,a)', 'instantiation_error', 'call/2 variable closure'],
      ['call(3,a)', 'type_error(callable)', 'call/2 callable closure'],
      ['call(foo,a,b,c,d,e,f,g,h)', 'existence_error(procedure)', 'selected call/N ceiling at call/8'],
      ['atom_length(X,4)', 'instantiation_error', 'atom_length/2 atom instantiation'],
      ['atom_length(1.2,4)', 'type_error(atom)', 'atom_length/2 atom type'],
      ["atom_length(atom,'4')", 'type_error(integer)', 'atom_length/2 length type'],
      ['atom_length(atom,-1)', 'domain_error(not_less_than_zero)', 'atom_length/2 length domain'],
      ['atom_concat(X,small,Y)', 'instantiation_error', 'atom_concat/3 first/whole under-instantiation'],
      ['atom_concat(small,X,Y)', 'instantiation_error', 'atom_concat/3 second/whole under-instantiation'],
      ['atom_concat(1,a,b)', 'type_error(atom)', 'atom_concat/3 first type'],
      ['atom_concat(a,1,b)', 'type_error(atom)', 'atom_concat/3 second type'],
      ['atom_concat(a,b,1)', 'type_error(atom)', 'atom_concat/3 whole type'],
      ['sub_atom(X,0,1,0,a)', 'instantiation_error', 'sub_atom/5 source instantiation'],
      ['sub_atom(1,0,1,0,a)', 'type_error(atom)', 'sub_atom/5 source type'],
      ['sub_atom(a,0,1,0,1)', 'type_error(atom)', 'sub_atom/5 result atom type'],
      ['sub_atom(a,x,1,0,_)', 'type_error(integer)', 'sub_atom/5 Before type'],
      ['sub_atom(a,0,x,0,_)', 'type_error(integer)', 'sub_atom/5 Length type'],
      ['sub_atom(a,0,1,x,_)', 'type_error(integer)', 'sub_atom/5 After type'],
      ['sub_atom(a,-1,1,0,_)', 'domain_error(not_less_than_zero)', 'sub_atom/5 Before domain'],
      ['sub_atom(a,0,-1,0,_)', 'domain_error(not_less_than_zero)', 'sub_atom/5 Length domain'],
      ['sub_atom(a,0,1,-1,_)', 'domain_error(not_less_than_zero)', 'sub_atom/5 After domain'],
      ['atom_chars(X,Y)', 'instantiation_error', 'atom_chars/2 under-instantiation'],
      ['atom_chars(1,[])', 'type_error(atom)', 'atom_chars/2 atom type'],
      ['atom_chars(X,[a|foo])', 'type_error(list)', 'atom_chars/2 improper list'],
      ['atom_chars(X,[Y,a])', 'instantiation_error', 'atom_chars/2 variable prefix element'],
      ['atom_chars(X,[a,1])', 'type_error(character)', 'atom_chars/2 character element type'],
      ['atom_codes(X,Y)', 'instantiation_error', 'atom_codes/2 under-instantiation'],
      ['atom_codes(1,[])', 'type_error(atom)', 'atom_codes/2 atom type'],
      ['atom_codes(X,[97|foo])', 'type_error(list)', 'atom_codes/2 improper list'],
      ['atom_codes(X,[Y,97])', 'instantiation_error', 'atom_codes/2 variable prefix element'],
      ['atom_codes(X,[97,foo])', 'type_error(integer)', 'atom_codes/2 code integer type'],
      ['atom_codes(X,[97,-1])', 'representation_error(character_code)', 'atom_codes/2 code representation'],
      ['char_code(X,Y)', 'instantiation_error', 'char_code/2 under-instantiation'],
      ['char_code(ab,foo)', 'type_error(character)', 'char_code/2 character type before code type'],
      ['char_code(a,foo)', 'type_error(integer)', 'char_code/2 code type'],
      ['char_code(a,-1)', 'representation_error(character_code)', 'char_code/2 code representation'],
      ['number_chars(X,Y)', 'instantiation_error', 'number_chars/2 under-instantiation'],
      ['number_chars(foo,[])', 'type_error(number)', 'number_chars/2 number type'],
      ['number_chars(X,[a|foo])', 'type_error(list)', 'number_chars/2 improper list'],
      ['number_chars(X,[Y,a])', 'instantiation_error', 'number_chars/2 variable prefix element'],
      ['number_chars(X,[a,1])', 'type_error(character)', 'number_chars/2 character element type'],
      ['number_chars(X,[a])', 'syntax_error(number)', 'number_chars/2 number syntax'],
      ['number_codes(X,Y)', 'instantiation_error', 'number_codes/2 under-instantiation'],
      ['number_codes(foo,[])', 'type_error(number)', 'number_codes/2 number type'],
      ['number_codes(X,[49|foo])', 'type_error(list)', 'number_codes/2 improper list'],
      ['number_codes(X,[Y,49])', 'instantiation_error', 'number_codes/2 variable prefix element'],
      ['number_codes(X,[49,foo])', 'type_error(integer)', 'number_codes/2 code integer type'],
      ['number_codes(X,[49,-1])', 'representation_error(character_code)', 'number_codes/2 code representation'],
      ['number_codes(X,[97])', 'syntax_error(number)', 'number_codes/2 number syntax'],
      ['current_prolog_flag(1,_)', 'type_error(atom)', 'current_prolog_flag/2 flag type'],
      ['current_prolog_flag(no_such_iso_flag,_)', 'domain_error(prolog_flag)', 'current_prolog_flag/2 flag domain'],
      ['halt(X)', 'instantiation_error', 'halt/1 instantiation'],
      ['halt(a)', 'type_error(integer)', 'halt/1 integer type'],
    ];
    for (const [goal, formal, label] of cases) {
      equal(capture(() => run('', { isoStrict: true, goal })).formal, formal, label);
    }

    equal(run('', { isoStrict: true, goal: 'false' }).stats.completed_goal_lists, 0, 'false/0 fails');
    const onceSolver = new Solver(Program.parse('', { isoStrict: true }), { isoStrict: true });
    equal([...onceSolver.solve([parseGoalText('once((X=1;X=2))', { isoStrict: true })], new Env(), 0)].length,
      1, 'once/1 first solution');
    const onceCommittedSolver = new Solver(Program.parse('', { isoStrict: true }), { isoStrict: true });
    equal([...onceCommittedSolver.solve([parseGoalText('once((X=1;X=2)), X=2', { isoStrict: true })], new Env(), 0)].length,
      0, 'once/1 commits to its first solution');
    const callSolver = new Solver(Program.parse('', { isoStrict: true }), { isoStrict: true });
    equal([...callSolver.solve([parseGoalText('call(atom_concat,pro,log,prolog)', { isoStrict: true })], new Env(), 0)].length,
      1, 'call/4 closure expansion');
    equal(run('', { isoStrict: true, goal: 'atom_concat(A,B,ab)' }).stats.completed_goal_lists, 3, 'atom_concat/3 re-executable splits');
    equal(run('', { isoStrict: true, goal: 'sub_atom(ab,_,_,_,_)' }).stats.completed_goal_lists, 6, 'sub_atom/5 re-executable slices');
  });

  reporter.test('covers ISO database predicate errors and empty-procedure lifetime', () => {
    const errors = [
      ['current_predicate(4)', '', 'type_error(predicate_indicator)'],
      ['asserta(_)', '', 'instantiation_error'],
      ['asserta(4)', '', 'type_error(callable)'],
      ['asserta((atom(_):-true))', '', 'permission_error(modify, static_procedure)'],
      ['assertz(_)', '', 'instantiation_error'],
      ['assertz(4)', '', 'type_error(callable)'],
      ['retract(_)', '', 'instantiation_error'],
      ['retract(4)', '', 'type_error(callable)'],
      ['retract(atom(_))', '', 'permission_error(modify, static_procedure)'],
      ['retractall(_)', '', 'instantiation_error'],
      ['retractall(3)', '', 'type_error(callable)'],
      ['retractall(retractall(_))', '', 'permission_error(modify, static_procedure)'],
      ['abolish(foo/_)', '', 'instantiation_error'],
      ['abolish(foo)', '', 'type_error(predicate_indicator)'],
      ['abolish(foo/a)', '', 'type_error(integer)'],
      ['abolish(4/1)', '', 'type_error(atom)'],
      ['abolish(foo/(-1))', '', 'domain_error(not_less_than_zero)'],
      ['abolish(atom/1)', '', 'permission_error(modify, static_procedure)'],
    ];
    for (const [goal, source, formal] of errors) {
      equal(capture(() => run(source, { isoStrict: true, goal })).formal, formal, goal);
    }

    const retained = run(':- dynamic(p/1).\np(a).\n', {
      isoStrict: true,
      goal: 'retractall(p(_)), current_predicate(p/1), \\+ clause(p(_),_)',
    });
    equal(retained.stats.completed_goal_lists, 1, 'retractall keeps the dynamic procedure');

    const empty = run(':- dynamic(empty/1).\n', { isoStrict: true, goal: 'current_predicate(empty/1)' });
    equal(empty.stats.completed_goal_lists, 1, 'declared empty procedure exists');

    const abolished = run(':- dynamic(q/1).\nq(a).\n', {
      isoStrict: true,
      goal: 'abolish(q/1), \\+ current_predicate(q/1)',
    });
    equal(abolished.stats.completed_goal_lists, 1, 'abolish removes the procedure');
  });

  reporter.test('disables normal-profile recursion planning', () => {
    const group = Program.parse('p :- p.\n', { isoStrict: true }).findGroup('p', 0);
    equal(group?.recursive, false, 'recursive planner');
    equal(group?.tabled, false, 'tabled planner');
  });

  reporter.sectionTotal('strict ISO core');
}

function capture(fn) {
  try {
    fn();
  } catch (error) {
    return error;
  }
  throw new Error('expected an error');
}

function equal(actual, expected, label) {
  if (actual !== expected) throw new Error(`${label}: expected ${String(expected)}, got ${String(actual)}`);
}

function includes(actual, expected, label) {
  if (!String(actual).includes(expected)) throw new Error(`${label}: ${String(actual)} did not include ${expected}`);
}

if (isMainModule(import.meta.url)) {
  await runStandalone(runIsoStrict);
}
