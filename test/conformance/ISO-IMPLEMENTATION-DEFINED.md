# ISO/IEC 13211-1 implementation-defined and implementation-specific profile

This is the clause-by-clause ISO 5.4 decision index for EyeProlog. The
normative baseline used for this table is **ISO/IEC 13211-1:1995** together
with **Technical Corrigenda 1:2007, 2:2012, and 3:2017**. The current WG17/STC
pages at complang.tuwien.ac.at are useful review input, but draft proposals are
not silently treated as normative changes to that licensed baseline.

[*The Art of EyeProlog*](../../the-art-of-eyeprolog.md) remains the single
implementation reference. This file is an review index: it identifies each
explicitly implementation-defined decision in Part 1, states the EyeProlog
choice, and points to the implementation boundary that realizes it. Repeated
references to the same decision are folded into one row. Requirements that the
standard calls **implementation dependent** are listed separately because ISO
5.4 does not require their documentation in the same way.

Status values are:

- **defined** — the current behavior is implemented and stated here;
- **not applicable** — the standard decision is conditional and the condition
  is false for EyeProlog's selected profile;
- **gap** — retained for any future implementation-defined choice whose
  code/documentation boundary is still unresolved. Open *normative* shall-by-
  shall work is tracked separately in `ISO-COMPLIANCE.md`.

## Explicit implementation-defined decisions

| Clause | Decision completed by ISO 5.4 documentation | EyeProlog choice | Status / implementation evidence |
| --- | --- | --- | --- |
| 5.5.11 | Reserved atoms and the effect of instantiating a variable to one | EyeProlog reserves no Prolog atom under 5.5.11. Atoms with implementation-looking names remain ordinary terms unless a particular predicate interprets them. | **defined** — term representation and built-ins in `src/term.js`, `src/iso.js`. |
| 6.5 | Processor character set (PCS) | EyeProlog's PCS is the Unicode scalar repertoire U+0000..U+10FFFF excluding surrogates. This implementation-defined processor choice is shared by normal and `--iso-strict` modes; strict conformance does not narrow it. | **defined** — `src/iso-character.js`, parser/character-I/O validation, and strict-core/WG17 coverage. |
| 6.5 | Classification of additional/extended PCS characters | Printable ASCII uses the lexical classes specified by Part 1. C0 controls and DEL are extended layout characters. Non-ASCII Unicode letters extend alphanumeric name syntax; Unicode white-space is layout; remaining non-ASCII symbols/punctuation are extended graphic characters. | **defined** — `src/parser.js`, `src/syntax-scan.js`, `src/iso-character.js`. |
| 6.6 | Collating-sequence integers | Each PCS character's collating-sequence integer is its Unicode scalar value. Atom/functor comparison is lexicographic by those scalar integers, satisfying the required monotonic ASCII capital-letter, small-letter, and contiguous decimal-digit constraints while remaining well-defined for supplementary characters. | **defined** — `src/iso-character.js`, `src/term.js` (`compareTerms`), `src/iso.js` character-code predicates. |
| 6.6 | Collating values of control escapes and extended characters | Control escapes, octal/hexadecimal escapes, character-code constants, and extended Unicode characters all use the denoted Unicode scalar value as collating integer. | **defined** — `src/iso-character.js`, parser escape handling, `char_code/2`, `atom_codes/2`, and WG17 escape cases. |
| 7.1.2.2 | Mapping between a character code and bytes | Text file streams decode and encode UTF-8. Binary streams expose bytes 0..255 directly. | **defined** — `src/io.js`. |
| 7.1.4.1 | Set `C` of characters represented by one-char atoms | In both profiles `C` is the Unicode scalar repertoire U+0000..U+10FFFF excluding surrogates. | **defined** — `src/iso-character.js`, `src/iso.js` character-code validation. |
| 7.4.2.4 | Whether `op/3` directives affect other Prolog texts or execution | An `op/3` directive changes parsing of subsequent text loaded into the same `Program`; the resulting operator table is also used by execution-time term I/O. Separately created `Program` objects are independent. | **defined** — `src/parser.js`, `src/program.js`, `src/iso.js`. |
| 7.4.2.5 | Whether directive-created `Convc` affects other text/execution | Yes. A `char_conversion/2` directive updates preparation-time conversion for later unquoted source characters and the recorded mapping initializes execution-time term input. Quoted characters are not converted; `char_conversion=off` disables following preparation-time conversion. | **defined** — `src/parser.js`, `src/program.js`, `src/solver.js`; strict-core regression coverage. |
| 7.4.2.6 | Order of `initialization/1` goals | Initialization goals run once per prepared `Program`, in source/inclusion order, before requested goals; each must obtain a first solution. Reusing the same prepared program in another solver does not execute its initialization goals again. | **defined** — `Program.initializations`, preparation state, `Solver.runInitializations()`. |
| 7.4.2.7 | Ground term designating a Prolog text for `include/1` | A source designation is an atom interpreted as a file path; relative paths resolve from the including file's directory (or the current working directory for unanchored input). | **defined** — `src/program.js` (`readIncludedSource`). |
| 7.4.2.8 | Ground term designating a Prolog text for `ensure_loaded/1` | Same atom/file-path designation as `include/1`. | **defined** — `src/program.js`. |
| 7.4.2.8 | Position at which an ensured text is included | The first `ensure_loaded/1` expands the text in place at the directive; later requests for the same resolved path are ignored. | **defined** — `src/program.js` (`ensured` set and in-place builder loading). |
| 7.4.2.9 | Whether `set_prolog_flag/2` directives affect other texts/execution | Parser-relevant `double_quotes` changes following source text in the same parse; recorded flag directives initialize the solver used for execution. Separately created programs/solvers are independent. | **defined** — `src/parser.js`, `src/program.js`, `src/solver.js`. |
| 7.5.1 | Means by which the processor is asked to prepare Prolog text | Text is prepared through the CLI/REPL, the JavaScript `Program.parse`/`run` API, source files/URLs, and `include/1`/`ensure_loaded/1`. | **defined** — Chapter 40 and `src/cli.js`, `src/index.js`, `src/program.js`. |
| 7.5.1 | Effects of directive-driven reordering, addition, or removal of clauses during preparation | Includes are expanded in place; declarations annotate the affected procedure; clauses otherwise retain source order. No directive silently reorders ordinary clauses. | **defined** — streaming builder in `src/program.js`. |
| 7.7.1 | External form of a negative answer | The interactive top level prints `false.`. Non-interactive `run()`/CLI corpus execution emits no answer line for a failed goal. | **defined** — Chapter 40, `src/repl.js`, `src/execute.js`. |
| 7.7.1 | External form of a positive answer | The REPL prints `true.` for a solution without visible bindings or `Name = Term` bindings; the file/API runner emits each resolved ground goal as a Prolog term followed by `.`. | **defined** — Chapter 40, `src/repl.js`, `src/execute.js`. |
| 7.7.3 | Method by which a user delivers a goal | REPL queries, CLI `--goal`, `%% goal:` host comments, and the JavaScript `goal` option are supported host interfaces. | **defined** — Chapter 40. |
| 7.10.1 | Additional source/sink possibilities | Node runtimes support local files plus the predefined standard streams; embedding supplies `user_input` text and a `user_output` callback. URL loading is a source-loading facility, not an ISO stream opened by `open/4`. | **defined** — `src/io.js`, `src/cli.js`, `src/index.js`. |
| 7.10.1 | Ground term designating a source/sink to `open/4` | An atom is interpreted as a local file-system path. | **defined** — `src/iso.js`, `src/io.js`. |
| 7.10.2.6 | Record-based/non-record-based text stream support | EyeProlog exposes non-record-based text streams. | **defined** — `src/io.js`. |
| 7.10.2.6 | Alteration of spaces at line ends | None. EyeProlog preserves text-stream characters; it does not trim or pad line endings. | **defined** — `src/io.js`. |
| 7.10.2.6 | Whether the last line is followed by newline / close adds one | Closing a text output stream writes exactly the accumulated content and does not synthesize a final newline. | **defined** — `StreamManager.close()`. |
| 7.10.2.6 | Effect of outputting control characters | The Unicode character is appended unchanged to a text stream (subject to the host sink's ordinary string handling). | **defined** — `StreamManager.writeUnit()`. |
| 7.10.2.7 | Number of zero bytes that may be appended on binary re-input | Zero. Binary file output is written and read byte-for-byte. | **defined** — `src/io.js`. |
| 7.10.2.8 | Whether a source/sink can be arbitrarily repositioned | File streams are repositionable only when opened with `reposition(true)`; standard streams are not repositionable. | **defined** — `src/io.js`, `set_stream_position/2` in `src/iso.js`. |
| 7.10.2.9 | Terms denoting end/past-end stream positions when repositionable | Stream positions are non-negative integer offsets; `position(N)` is also accepted by `set_stream_position/2`. End/past-end state is separately exposed by `end_of_stream/1`. | **defined** — `streamProperties()` and `setStreamPositionBuiltin()` in `src/iso.js`. |
| 7.10.2.11 | Default `eof_action` | Newly opened file streams default to `error`. The predefined standard streams use `reset`. | **defined** — `src/io.js`. |
| 7.10.2.13 | `eof_action(Action)` property when the stream uses its default action | Reports the same selected action: `error` for ordinary opened files and `reset` for the predefined standard streams. | **defined** — `streamProperties()` in `src/iso.js`, defaults in `src/io.js`. |
| 7.10.2.11 | Whether `reposition(false)` streams may nevertheless be repositioned | No. `set_stream_position/2` raises a permission error unless the stream was created with `reposition(true)`. | **defined** — `src/iso.js`. |
| 7.11.1.1 | Default `bounded` flag | `false`: EyeProlog's Prolog integer model uses arbitrary-precision `BigInt`, subject to host resources. The standard values remain `true` and `false`; because this flag is fixed, selecting either value through `set_prolog_flag/2` reaches the standard non-changeable-flag rule rather than narrowing the value domain to the current choice. | **defined** — `defaultPrologFlags()` in `src/solver.js`; strict flag tests. |
| 7.11.1.2 | Default `max_integer` when `bounded=true` | Not applicable because EyeProlog selects `bounded=false`; consequently `current_prolog_flag(max_integer, _)` fails. | **not applicable** — `src/solver.js`, `current_prolog_flag/2`; strict-core regression coverage. |
| 7.11.1.3 | Default `min_integer` when `bounded=true` | Not applicable because EyeProlog selects `bounded=false`; consequently `current_prolog_flag(min_integer, _)` fails. | **not applicable** — `src/solver.js`, `current_prolog_flag/2`; strict-core regression coverage. |
| 7.11.1.4 | Default `integer_rounding_function` flag | `toward_zero`; `//` uses truncation toward zero. The standard flag values are `down` and `toward_zero`, but the selected flag is non-changeable; an attempt to select the other valid value is therefore a permission error. `div` is provided separately with downward/floor division semantics. | **defined** — `src/solver.js`, `src/iso-arithmetic.js`; strict flag tests. |
| 9.1.3.1 | Integer division rounding function `rndI` | Truncation toward zero, matching the `integer_rounding_function=toward_zero` flag. | **defined** — BigInt division for `//` in `src/iso-arithmetic.js`. |
| 7.11.2.1 | Whether preparation-time `Convc` affects execution-time `Convc` | Yes: mappings created while Prolog text is prepared are retained and initialize the solver's execution-time conversion map. | **defined** — `src/parser.js`, `src/program.js`, `src/solver.js`. |
| 7.11.2.2 | Effect when `debug=on` | The flag is accepted and stored; it does not change goal semantics or enable a debugger. | **defined** — `src/solver.js`; no semantic branch depends on `debug`. |
| 7.11.2.3 | Default `max_arity` | `unbounded`: EyeProlog imposes no fixed semantic ceiling on compound-term arity. Practical host allocation exhaustion is a resource condition. This flag is distinct from any potential implementation-specific procedure-arity limit; EyeProlog currently declares no separate finite procedure limit. | **defined** — `src/iso-limits.js`, `src/solver.js`, `src/parser.js`, `src/iso.js`; strict regression coverage. |
| 7.11.2.5 | Default `double_quotes` | `chars`. | **defined** — `src/solver.js`, parser flag state. |
| 7.12.1 | Second argument of `error/2` | A list of context elements, innermost last. A built-in contributes its own predicate indicator, so `atom_length(1.0, _)` raises `error(type_error(atom, 1.0), [atom_length/2])`. Errors raised outside a built-in frame, and errors thrown from shared pre-built instances reused by several built-ins, use `[]`. Each enclosing `call_with_error_context/2` prepends a copy of its own element, so contexts compose into proper lists. | **defined** — `attachBuiltinErrorContext()` in `src/errors.js`, `formalErrorTerm()` in `src/iso.js`, `call_with_error_context/2` in `src/lib/error.pl`. |
| 7.12.2(f) | Implementation-defined representation limits | Character and character-code operations are limited to Unicode scalar values; surrogates and values above U+10FFFF are representation errors. Arity/integer values are modeled as unbounded but may hit host/resource limits. Float input overflow uses the implementation-specific `max_float`/`min_float` representation names documented by the STC-oriented tests. | **defined** — parser/ISO numeric and character guards. |
| 8.17.1 | Implementation-defined flag value ranges | Strict mode exposes only Part 1 core flags and their standard value sets. Normal mode additionally exposes EyeProlog's `occurs_check` and `default_procedure_access` flags. With `bounded=false`, `max_integer` and `min_integer` have no current or selectable value and their `current_prolog_flag/2` queries fail. Valid alternative values of fixed standard flags are distinguished from invalid values so `set_prolog_flag/2` reports permission versus domain errors as prescribed. | **defined** — strict registry/flag filtering in `src/solver.js`; strict flag tests. |
| 8.17.3 | Other effects of `halt/0` | Terminates EyeProlog execution and returns host/process status `0`; it produces no Prolog solution. | **defined** — `HaltSignal`, `haltBuiltin()`, CLI/runner handling. |
| 8.17.4 | Meaning/effects of `halt(Status)` | Integer `Status` is converted to the host process/runner halt code; it produces no Prolog solution. | **defined** — `haltBuiltin()`, `src/execute.js`, `src/cli.js`. |
| 9.1.4.1 | Floating-point rounding function `rndF` | Floating values and operations use ECMAScript `Number` (IEEE-754 binary64) and the host's specified binary64 arithmetic/conversions. | **defined** — `src/iso-arithmetic.js`, `src/number-value.js`. |
| 9.1.4.2 | Floating-point result function for operations whose result is governed only by `resultF` | EyeProlog chooses `round(x)` rather than the optional exceptional value `underflow`. ECMAScript binary64 arithmetic therefore preserves a representable subnormal result and rounds a still-smaller generic arithmetic result to `0.0`, consistently with float-token, `number_chars/2`, and `number_codes/2` input. The published Part 1 `**/2` and Corrigendum 2 `^/2` tables still contain separate unconditional underflow rows, which strict mode retains; post-N289 STC #75 proposes making those two power rows conditional on this `resultF` choice and is tracked separately as draft work. `exp/1` has its own published exceptional condition and is not the subject of STC #75. | **defined** — arithmetic evaluation in `src/iso-arithmetic.js` and parser/number conversion; strict exceptional-value regressions. |
| 9.1.4.3 | Approximate-addition function | ECMAScript binary64 addition is used; subtraction is implemented through the corresponding host operation and all finite results remain binary64 values. | **defined** — arithmetic evaluation in `src/iso-arithmetic.js`. |
| 9.4 | Representation of negative integers for bitwise operations | BigInt's unbounded signed binary semantics are used, equivalent to an infinite two's-complement sign extension for bitwise operations. | **defined** — `src/iso-arithmetic.js` BigInt bitwise operators and strict Clause 9.4 boundary regressions. |
| 9.4.1 | Right shift of negative integers and unusual shift counts | `>>` is arithmetic/sign-propagating. A negative count reverses direction according to JavaScript BigInt shift semantics; there is no finite integer bit-size ceiling in the Prolog model. | **defined** — `a >> b` in `src/iso-arithmetic.js`; strict regressions pin negative operands/counts. |
| 9.4.2 | Left shift of negative integers and unusual shift counts | `<<` uses BigInt signed shift semantics; a negative count reverses direction. Resource exhaustion remains possible for very large results. | **defined** — `a << b` in `src/iso-arithmetic.js`; strict regressions pin negative counts and resource exhaustion. |
| 9.4.3 | Bitwise AND with negative operands | BigInt infinite-two's-complement semantics. | **defined** — `a & b`. |
| 9.4.4 | Bitwise OR with negative operands | BigInt infinite-two's-complement semantics. | **defined** — `a \| b`. |
| 9.4.5 | Bitwise complement | BigInt complement, i.e. `~N = -N-1`. | **defined** — `~a`. |
| Cor.2 9.4.6 | `xor/2` with negative operands | BigInt infinite-two's-complement semantics. | **defined** — `a ^ b`. |

### Floating underflow policy

Clause 9.1.4.2 permits the processor to choose `round(x)` or the exceptional
value `underflow` for a tiny non-zero result when an operation is governed by
the generic floating result function. EyeProlog chooses `round(x)`. Because its
floating-point profile is ECMAScript IEEE-754 binary64, representable
subnormal values remain non-zero and still-smaller generic results round to
`0.0`. Float-token and `number_chars/2` input use the same finite-double
rounding policy.

That generic implementation-defined choice is distinct from the currently
published evaluable-functor error clauses. In the licensed Part 1 + Corrigenda
baseline, `exp/1`, Part 1 `**/2`, and Corrigendum 2 `^/2` have explicit
underflow conditions, so strict mode raises `evaluation_error(underflow)` when
those published conditions are met. The 2026-08-23 post-N289 draft adds STC
#75, proposing that the two *power* underflow rows apply only when the processor
selects `underflow` in 9.1.4.2. EyeProlog records that proposal but does not
silently replace the published strict baseline with it. The regression suite
pins both the published power behavior and the generic round-to-zero choice;
`stc/float_underflow_input` covers the separate input-conversion policy.

## Implementation-specific features required to be documented by 5.4

Part 1 clause 5.5 permits extensions only as implementation-specific features.
Corrigendum 3 additionally makes extra option names explicit implementation-
specific features. EyeProlog's normal profile provides the following extension
families; `--iso-strict` is intended to remove their Part 1 interpretation.

| Part 1 extension hook | EyeProlog normal-profile feature | Strict-core disposition |
| --- | --- | --- |
| 5.5.1 Syntax | Part 2 modules, Part 3 grammar-rule expansion, embedded quad syntax, digit-separated integer constants (`1_000`, `0xCA_FE`, with optional layout after `_`), and Trealla-compatible `"text"||Tail` right-splicing for double-quoted `chars`/`codes` lists | Module directives are rejected; grammar rules remain ordinary `-->/2` terms rather than being expanded; quad syntax, integer digit separators, and double-bar right-splicing are rejected. Unicode PCS membership/classification is implementation defined and therefore shared with normal mode rather than treated as an extension. |
| 5.5.2 Predefined operators | Part 3 `|` and EyeProlog's labelable infix `(?-)/2`; CLP(Z) operators when that library is imported | Only the Part 1 operator table is predefined; a conforming `op/3` may still add permitted operators. |
| 5.5.3 Character-conversion mapping | No non-identity initial `Convc` extension | Identity initial mapping. |
| 5.5.4 Types | The normal JavaScript API exposes an implementation-specific string term `stringTerm(Text)`. It is disjoint from the five Part 1 term types; normal term order places it after atoms and before compound terms, and normal `atomic/1` treats it as atomic. It has no Prolog source token syntax (double-quoted source still follows `double_quotes`), is non-callable for term-to-clause conversion, is not evaluable as an arithmetic expression, and writes as a double-quoted host string. | Strict mode rejects a programmatic string term at program/goal entry with `representation_error(term)`, so the additional type cannot enter the Part 1 execution domain. **defined** — `src/term.js`, `src/program.js`, `src/solver.js`; strict API-boundary regression. |
| 5.5.5 Directives | `module/2`, `use_module/1-2`, `meta_predicate/1` and normal-profile library behavior | Rejected as implementation-specific Part 1 directives. |
| 5.5.6 Side effects | Normal mode adds `statistics/0-2`, cleanup/library state, and optional proof/statistics host instrumentation. | The strict registry excludes Prolog-visible statistics/cleanup/library adapters; ordinary Part 1 I/O/database/flag/operator side effects remain. Host proof/statistics collection observes execution through the embedding API rather than adding a strict Prolog goal effect. **covered** — strict registry/execution regression. |
| 5.5.7 Control constructs | `tnot/1`, `wfs_truth/2`, and normal-profile execution optimizations | `tnot/1`, `wfs_truth/2`, and the normal-profile explicit `table` declaration are absent. |
| 5.5.8 Flags | `occurs_check` | Absent in strict mode. |
| 5.5.8 Flags, 7.5.3 NOTE | `public/1` directive, `default_procedure_access` flag | Absent in strict mode. The 7.5.3 NOTE anticipates a `public/1` extension declaring user-defined procedures public; the flag generalizes it to all of them at once, which meta-interpreters need without annotating the interpreted program. Read access only: a public procedure stays static, so `assert`/`retract` still report `permission_error(modify, static_procedure)`, and built-ins stay private. |
| 5.5.9 Built-in predicates | EyeProlog libraries, CLP(Z), statistics, Part 3 `phrase/2-3`, and bundled-library autoloaded predicates | Strict registry contains only the Part 1 + Corrigenda core registry. |
| 5.5.10 Evaluable functors | Normal mode additionally accepts the EyeProlog evaluable atom `e`; the remaining arithmetic functors accepted by strict mode are the Part 1 + Corrigenda set. | Strict mode rejects `e/0` as non-evaluable and retains the Corrigendum arithmetic additions. **covered** — strict extension-boundary regression plus `src/iso-arithmetic.js`. |
| 5.5.11 Reserved atoms | None | None. |
| Cor.3 5.5.12 Options | Extra library/host options may exist outside core option lists | Normal mode additionally accepts the EyeProlog `write_term/2-3` options `double_quotes(true|false)` and `spacing(true|false)`. `double_quotes(true)` is orthogonal to `ignore_ops(true)`: eligible character/code lists, including a proper list's maximal character/code suffix of at least two elements, retain double-quoted notation while operator terms use functional notation, and the order of those distinct options does not affect the result. `spacing(false)` emits only lexically required separators; `spacing(true)` adds conventional layout around operators. Strict core excludes these implementation-specific extensions and accepts only the Part 1 plus Corrigendum 3 write-option surface; unknown extension options raise `domain_error(write_option,...)`. |

Normal mode provides documented module and DCG compatibility profiles whose
features overlap standardized Part 2 and Part 3 facilities. They are extensions
relative to the Part 1 strict-core boundary and are tested separately; this
ledger does not assert complete Part 2 or Part 3 conformance. The concrete
per-directive and per-predicate boundary is recorded in `ISO-PART2.md` and
`ISO-PART3.md`, including the 2013 module-amendment evidence and the
normal-profile `phrase/2-3` terminal-sequence error choice.

## Important implementation-dependent behavior (not the 5.4 mandatory table)

For portability work, EyeProlog also documents these choices even though the
1995 text labels them implementation **dependent**, not implementation defined:

- distinct variables are ordered by first encounter within the operation that
  needs a stable ordering;
- expression arguments are evaluated left-to-right by the JavaScript evaluator;
- Corrigendum 2 mixed integer/float `max/2` and `min/2` use exact mathematical comparison and return one of the original operands without forcing integer-to-float conversion; equal values choose the left operand, so its original numeric type is preserved. EyeProlog does not elect the optional mixed-type `undefined` or `float_overflow` outcomes solely because the operand types differ;
- generated variable names use EyeProlog's stable `_A`, `_B`, ... style within
  a write operation/top-level query;
- resource and syntax-error detail atoms are EyeProlog implementation details;
- the order of `current_prolog_flag/2` solutions is the insertion order of the
  flag registry.

These rows are intentionally separate so that the ISO 5.4 checklist does not
blur the standard's distinction between *implementation defined* (documented),
*implementation dependent* (need not be documented), and *implementation
specific* (an extension that must be documented for a conforming processor).
