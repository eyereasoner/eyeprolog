// documentationSyncCases: regression cases split out of run-regression.mjs.
// Case order is load-bearing (see support.mjs).
import fs from 'node:fs';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import * as publicApi from '../../src/index.js';
import { createDefaultRegistry, eyePrologLibraryIndicators, eyePrologNativeLibraryIndicators, eyePrologPortableLibraryIndicators, standardLibrarySources } from '../../src/index.js';
import { assertEqual, assertIncludes, assertNotIncludes } from '../test-style.mjs';
import { buildConformanceReport, formatConformanceReport } from '../run-conformance-report.mjs';
import { renderWg17SyntaxStatus } from '../../tools/report-wg17-syntax-coverage.mjs';
import { parseWg17SyntaxTable, updateWg17InventoryReferences } from '../../tools/upgrade-wg17.mjs';
import { executeWg17Item, matchesUpstreamExpectation, readWg17SyntaxFixture } from '../run-wg17.mjs';
import {
  assertArrayEqual,
  between,
  bookBuiltinNames,
  bookBuiltinSummary,
  bookExampleCatalogIssues,
  bookEyePrologLibraryNames,
  bookIntroOutputIssues,
  bookLibraryModuleIssues,
  bookReferenceDocumentationIssues,
  documentationSourceStyleIssues,
  documentedConformanceMetricIssues,
  documentedPublicApiImportIssues,
  exampleCorpusSyncIssues,
  findBrokenDocLinks,
  listMarkdownFiles,
  misleadingDependencyInstallDocs,
  missingDocumentedPackageScripts,
  packageRoot,
  pkg,
  playgroundExampleIssues,
  playgroundStaticIssues,
  proofCorpusSyncIssues,
  registeredBuiltinNames,
  registeredBuiltinSummary,
  registeredEyePrologLibraryNames,
  testRoot,
} from './support.mjs';

export function documentationSyncCases() {
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
        assertIncludes(result.stdout, 'predicate reference is up to date (533 predicates)', 'stdout');
        assertEqual(result.stderr, '', 'stderr');

        const book = fs.readFileSync(path.join(packageRoot, 'the-art-of-eyeprolog.md'), 'utf8');
        const section = between(book, '<!-- eyeprolog-predicate-reference:start -->', '<!-- eyeprolog-predicate-reference:end -->');
        assertEqual(section.split('\n').some((line) => line.trimStart().startsWith('|')), false, 'predicate reference avoids wide table markup');
        assertEqual((section.match(/^- \*\*`/gm) ?? []).length, 533, 'one reference entry per predicate');
        assertEqual((section.match(/<a id="predicate-reference-\d{4}"><\/a>/g) ?? []).length, 533, 'one explicit anchor per predicate');
        assertEqual((section.match(/\]\(#predicate-reference-\d{4}\)/g) ?? []).length, 533, 'one direct index link per predicate');
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
      name: 'WG17 inventory documentation accepts omitted counts and repairs partial updates',
      run: () => {
        const countFree = 'The vendored WG17 syntax snapshot is intentionally secondary.';
        assertEqual(updateWg17InventoryReferences(countFree, 379), countFree, 'no count required');
        const stale = 'The 366-case vendored WG17 matrix and 365-case WG17 syntax matrix; WG17 matrix has 366 executable cases. An unrelated 366-case suite stays unchanged.';
        const expected = 'The 379-case vendored WG17 matrix and 379-case WG17 syntax matrix; WG17 matrix has 379 executable cases. An unrelated 366-case suite stays unchanged.';
        const updated = updateWg17InventoryReferences(stale, 379);
        assertEqual(updated, expected, 'all stale WG17 counts repaired independently of fixture state');
        assertEqual(updateWg17InventoryReferences(updated, 379), updated, 'retry is idempotent');
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
        assertArrayEqual(Object.keys(pkg.scripts).sort(), ['benchmark', 'conformance:update:wg17', 'generate', 'postversion', 'preversion', 'test'], 'small npm command surface');
        assertEqual(pkg.scripts.test, 'node test/run-all.mjs', 'full release gate');
        const runner = fs.readFileSync(path.join(packageRoot, 'test', 'run-all.mjs'), 'utf8');
        assertIncludes(runner, 'runOpenRuleBenchChecks(reporter)', 'OpenRuleBench remains in release gate');
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
