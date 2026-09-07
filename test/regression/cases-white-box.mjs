// whiteBoxCases: regression cases split out of run-regression.mjs.
// Case order is load-bearing (see support.mjs).
import fs from 'node:fs';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import * as publicApi from '../../src/index.js';
import { Env, Program, atom, compound, copyResolved, flattenConjunction, listFromItems, numberTerm, parseProgramText, properListItems, stringTerm, termIsGround, termToString, unify, variable, variantTerms } from '../../src/index.js';
import { ISO_OPERATOR_DEFINITIONS, parseGoalText, parseNumberTokenText } from '../../src/parser.js';
import { compareTerms } from '../../src/term.js';
import { formatTermForWrite } from '../../src/write.js';
import { selectClauseCandidates } from '../../src/program.js';
import { assertEqual, assertIncludes, assertNotIncludes } from '../test-style.mjs';
import { goalsFromSource } from '../goal-metadata.mjs';
import {
  bin,
  packageRoot,
  run,
  runCli,
} from './support.mjs';

export function whiteBoxCases() {
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
