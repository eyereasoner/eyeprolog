# ISO/IEC 13211-1 compliance ledger

This ledger is the release-facing review and high-level coverage map for
EyeProlog's ISO/IEC 13211-1 core. The normative baseline is ISO/IEC 13211-1:1995
together with Technical Corrigenda 1:2007, 2:2012, and 3:2017. Detailed
row-level evidence lives only where it adds information: the built-in, processor,
term-semantics, Prolog-text/execution, evaluable-functor, implementation-defined,
published-Corrigenda, WG17-syntax, and STC draft ledgers in this directory. The generated
[`conformance-report.md`](../../conformance-report.md) gives the current executable WG17 syntax result together with file-based case totals.

The ledger deliberately does **not** claim independent certification. A row
marked `covered` means EyeProlog has implementation and executable tests for
that family, an explicit disposition for every requirement accounted for by
the linked review rows, and no known open defect in the listed behavior. An
review row may group closely related modes or error conditions, but it must name
each grouped condition and its evidence; `covered` does not imply one Markdown
row per occurrence of the word `shall`. A row marked
`review` means the family is implemented and tested, but the project has not yet
mapped every normative `shall`, option combination, prescribed error, and
relevant implementation-dependent overlap choice to an explicit review outcome.

## Processor compliance requirements

| Requirement | Status | EyeProlog evidence / remaining work |
| --- | --- | --- |
| 5.1(a) prepare conforming Prolog text | covered | Clause 6 token/term production and rejection families are mapped by the strict production gate and the complete 379-case vendored WG17 syntax matrix; 7.4 preparation/directive behavior is separately closed. |
| 5.1(b) execute conforming Prolog goals | covered | Clause 7 term/control/execution semantics, the higher-level 7.10 stream model, 7.11 flags, the 7.12 error envelope, all 8.2-8.17 built-in rows, and Clause 9 arithmetic have explicit executable dispositions. |
| 5.1(c) reject nonconforming text/read-terms | covered | WG17 negative syntax cases, focused malformed-production/escape/comment/operator cases, read-term syntax errors, and strict rejection of implementation-specific syntax provide explicit rejection evidence across the Clause 6 families. |
| 5.1(d) document permitted variations | covered | The clause-by-clause [ISO 5.4 decision index](ISO-IMPLEMENTATION-DEFINED.md) records every explicit implementation-defined decision found in the Part 1 + Corrigenda baseline and separately inventories implementation-specific extension families. The index retains an `gap` category for future discoveries; no current release-facing row depends on one. |
| 5.1(e) offer a strictly conforming mode | covered | `--iso-strict` and API option `isoStrict: true` restrict the processor to the Part 1 + Corrigenda 1-3 core language surface, remove EyeProlog-only registry/flag/operator features, reject explicit tabling and other normal-profile extensions, and reject the normal-profile host `stringTerm(Text)` term type at strict program/goal entry. |
| 5.4 accompanying documentation | covered | *The Art of EyeProlog* remains the implementation reference; [ISO-IMPLEMENTATION-DEFINED.md](ISO-IMPLEMENTATION-DEFINED.md) is the closed clause-by-clause 5.4 decision index and points each decision to implementation evidence. |
| 5.5 extension boundaries | covered | [ISO-PROCESSOR-REQUIREMENTS.md](ISO-PROCESSOR-REQUIREMENTS.md) gives an explicit disposition for every 5.5 extension hook. The Clause 6 cross-profile gate verifies that normal-mode syntax extensions do not reinterpret standard text accepted by the strict reader. |

## Normative language families

| Standard area | Status | Current evidence |
| --- | --- | --- |
| Clause 6 — tokens, terms, lists, operators, quoted text | covered | The strict Clause 6 gate maps atomic/variable/compound/operator/list/curly/double-quoted term forms, layout/comments, quoted escapes, integer bases/character codes, floating tokens, and solo/meta token boundaries, with malformed counterparts rejected. The complete 379-case WG17 syntax matrix provides externally sourced production-level expectations, and a cross-profile gate verifies that normal syntax extensions preserve every strict-accepted standard observation. The implementation-defined 6.5/6.6 PCS/collation choices are documented separately. |
| 7.1-7.3 — term types, term order, unification | covered | [ISO-TERM-SEMANTICS-MATRIX.md](ISO-TERM-SEMANTICS-MATRIX.md) records the five mutually exclusive strict term types, derived variable/compound/list notions, the complete standard-order classes and implementation-dependent variable-order choice, NSTO MGU/failure behavior, and EyeProlog's permitted consistent occurs-check failure for Part 1's undefined STO ordinary-unification cases. The normal JavaScript API string term is documented as a 5.5.4 extension and rejected at strict program/goal entry. |
| 7.4 — Prolog text and directives | covered | [ISO-PROLOG-TEXT-EXECUTION-MATRIX.md](ISO-PROLOG-TEXT-EXECUTION-MATRIX.md) closes the preparation/directive rows: declaration semantics, source clauses, cross-text operators/character conversion/flags, initialization order/lifetime, `include/1`, and one-time `ensure_loaded/1`, with implementation-defined cross-text choices indexed under 5.4. |
| 7.5-7.6 — database and term/clause conversion | covered | [ISO-PROLOG-TEXT-EXECUTION-MATRIX.md](ISO-PROLOG-TEXT-EXECUTION-MATRIX.md) closes static/dynamic and private/public procedure semantics, clause order, logical-update visibility, empty/unknown lifetime, and term/body/clause conversion. Source and runtime assertion conversion recurse through `,/2`, `;/2`, and `->/2`, preserve variable identity, and protect standardized static/control procedures. |
| 7.7 — execution and backtracking | covered | [ISO-PROLOG-TEXT-EXECUTION-MATRIX.md](ISO-PROLOG-TEXT-EXECUTION-MATRIX.md) closes ordinary clause selection/backtracking, source/database order, empty-versus-unknown procedures, logical-update visibility, and strict dispatch. The normal-profile `table` declaration, `tnot/1`, and recursive numeric shortcuts remain outside the strict profile. |
| 7.8 — control constructs and exceptions | covered | [ISO-PROLOG-TEXT-EXECUTION-MATRIX.md](ISO-PROLOG-TEXT-EXECUTION-MATRIX.md) closes `true/0`, `fail/0`, `call/1`, cut, conjunction, disjunction, if-then(-else), and `catch/3`/`throw/1`, including Corrigendum 2 catchability of errors arising from the protected goal and Corrigendum 3 term-to-body conversion at `call/1` entry; the regression suite pins the resulting cut scope when an initially unbound variable goal later becomes `!`. The 8.15 built-in additions remain independently row-reviewed. |
| 7.9 — expression evaluation | covered | [ISO-EVALUABLE-FUNCTOR-MATRIX.md](ISO-EVALUABLE-FUNCTOR-MATRIX.md) closes recursive evaluation, direct-variable precedence, corrected non-evaluable `F/N` errors (including STC #69), operand template/type rules, mixed arithmetic-comparison conversion, exceptional values, and finite-host resource normalization. The review also fixes float-only `float_integer_part/1` and `float_fractional_part/1` so even huge valid integers reach `type_error(float,...)` before any I->F overflow. |
| 7.10 — input/output concepts | covered | Higher-level stream semantics are pinned for non-atom ground stream terms, alias lifetime, current/target stream selection and fallback, write truncation, append positioning, contradictory stream options, exact binary round-tripping, flushing, standard-stream close behavior, and repositioned overwrite. Term-output spelling is also checked lexically where ISO distinguishes token forms: Corrigendum 2 bar operators are written with bare `|`, ordinary atom/functor `|` remains quoted, and the semicolon name token is emitted bare by canonical output. The complete 8.11-8.14 built-in mode/error family remains row-reviewed in [ISO-BUILTIN-MODE-ERROR-MATRIX.md](ISO-BUILTIN-MODE-ERROR-MATRIX.md), while all implementation-defined stream choices are indexed in [ISO-IMPLEMENTATION-DEFINED.md](ISO-IMPLEMENTATION-DEFINED.md). |
| 7.11 — flags | covered | The complete Part 1 flag set, selected defaults, standard value domains, changeability, `current_prolog_flag/2`, and `set_prolog_flag/2` error behavior have dedicated strict tests. EyeProlog selects `bounded=false` and `integer_rounding_function=toward_zero`; valid alternative values of those fixed flags reach `permission_error(modify,flag,...)`, while `max_integer` and `min_integer` have no current value. STC #70 is recorded explicitly: EyeProlog has no separate finite procedure-arity ceiling, so the optional `max_procedure_arity` flag is absent while `max_arity` remains `unbounded`. Strict mode excludes the EyeProlog `occurs_check` extension. |
| 7.12 — errors | covered | The strict error-envelope gate exercises instantiation, type, domain, existence, permission, representation, evaluation, resource, syntax, and system errors through `error(Error, Context)`. Built-in rows provide the individual prescribed conditions, implementation-defined representation/context choices are documented, and simultaneous-error regressions pin deterministic EyeProlog choices without treating textual table order as normative. |
| 8.2-8.17 — built-in predicates | covered | [ISO-BUILTIN-MODE-ERROR-MATRIX.md](ISO-BUILTIN-MODE-ERROR-MATRIX.md) accounts for the complete Part 1 + Corrigenda built-in family across prescribed modes, success/failure behavior, individual error conditions, and conditional/not-applicable branches. Closely related conditions may share a row when every condition and its executable evidence are named. The review exposed and fixed source/runtime 7.6.2 body conversion/variable sharing, strict host-string leakage, input-code error timing, `close/2` force handling, and closed-stream `stream_property/2` behavior. Simultaneous-error choices are documented as implementation dependent under 7.12 unless separately constrained. |
| Clause 9 — evaluable functors | covered | [ISO-EVALUABLE-FUNCTOR-MATRIX.md](ISO-EVALUABLE-FUNCTOR-MATRIX.md) records the published Part 1 + Corrigenda arithmetic templates and exceptional branches across 9.1, 9.3, and 9.4. It pins the unbounded integer model, `rndI`/`rndF`/`resultF` choices, float-only conversion rules, I->F overflow, explicit `exp/1` and power underflow, Corrigendum 2 additions and mixed-type `max/2`/`min/2` implementation-dependent choice, Corrigendum 3 negative-power correction, signed bitwise/shift choices, and resource-error translation. Post-N289 STC #75 remains a separately tracked draft proposal rather than a silent change to the published baseline. |
| Corrigendum 1 | covered | [ISO-CORRIGENDA-MATRIX.md](ISO-CORRIGENDA-MATRIX.md) dispositions every amendment cluster, including the square-root boundary, double-quoted operator atoms, typed expression errors, clause/operator enumeration, and atomic-conversion corrections; editorial items and the later-superseded set-order example are identified explicitly. |
| Corrigendum 2 | covered | [ISO-CORRIGENDA-MATRIX.md](ISO-CORRIGENDA-MATRIX.md) tracks the bar/operator changes, new predicates and evaluable functors, catch and uninstantiation corrections, atomic-conversion errors, and every other amendment cluster to executable evidence or an explicit editorial disposition. |
| Corrigendum 3 | covered | [ISO-CORRIGENDA-MATRIX.md](ISO-CORRIGENDA-MATRIX.md) tracks option-extension/error rules, final layout, term-to-body conversion, metadata traversal, writing rules, stream/built-in corrections, and negative integer powers; editorial changes are dispositioned separately. |

## Conformance corrections and review closure

The review against the licensed Part 1 text and Corrigenda closed two
concrete mismatches that are now part of the closed Part 1 review:

- `bounded=false` no longer exposes implementation-specific `unbounded` values
  for `max_integer` or `min_integer`; the corresponding
  `current_prolog_flag/2` queries fail. Part 1 does not require that outcome
  (7.11.1.1 defines the `bounded` flag and does not govern
  `current_prolog_flag/2`), so it is recorded as an implementation choice;
- preparation-time `char_conversion/2` now converts later unquoted source text
  when the `char_conversion` flag is `on`, leaves quoted characters unchanged,
  and feeds the same mapping into execution-time term input.

A follow-on review made the processor-character-set/collation choices explicit.
A follow-up processor-character-set review corrected an over-strict interpretation: because PCS membership
and extended-character classification are implementation defined by Part 1,
`--iso-strict` must not replace EyeProlog's ordinary processor choice. Both
profiles now use Unicode scalar values as PCS members and collating integers;
Unicode letters/white-space/graphics receive documented extended lexical
classes, while surrogates and values above U+10FFFF remain representation
errors. Strict mode continues to reject implementation-specific facilities
without changing these implementation-defined character choices. The complete
WG17 syntax matrix remains a release gate.


The subsequent arity review originally selected a finite `max_arity=65535`, but
the post-Corrigendum STC arity review exposed that as the wrong
abstraction: Part 1 `max_arity` is the maximum arity of **compound terms**, not
a procedure-arity limit. EyeProlog now again selects `max_arity=unbounded` and
removes the artificial 65535 checks from source parsing, `functor/3`, `=../2`,
predicate indicators, and Corrigendum 2 `call/N` closure expansion. Practical
host exhaustion remains a resource condition rather than a declared term-arity
boundary. Focused strict tests also lock the corrected 8.5 term-construction
errors, selected 8.8 clause-access and 8.10 all-solutions overlap behavior,
database update errors, and Corrigendum 3 variable metadata traversal/write
naming.

The public WG17 `number_chars/2` comparison used in preparation of Corrigendum
2 has additionally been checked during the review. It remains supporting review
evidence rather than a duplicated vendored corpus or release criterion.

The flag and term-I/O review closes the Part 1 flag family and tightens the 8.14
term-I/O/operator error rules. The strict flag registry now distinguishes a
standard value that is valid but not selectable from a value outside the
standard domain: attempts to change fixed `bounded` or
`integer_rounding_function` to another standard value therefore reach the
required permission error. `read_term/3`, `write_term/3`, `op/3`, and
`current_op/3` now cover their required error conditions individually and keep
EyeProlog's chosen simultaneous-error behavior stable. Section 7.12 makes that
choice implementation dependent when several error conditions hold at once. Strict `write_term/2-3` accepts only
the Part 1 plus Corrigendum 3 option surface; the normal-profile
`double_quotes/1` and `spacing/1` write options remain explicitly documented
implementation-specific EyeProlog extensions.


The preparation, stream, conversion, sorting, and arithmetic review expands the coverage into Prolog-text,
stream, atomic-conversion, sorting, and arithmetic edge cases. Strict
preparation now enforces the Part 1 declaration constraints for `dynamic/1`,
`multifile/1`, and `discontiguous/1`, including cross-text multifile use and
one-time initialization per prepared program. Stream handling now distinguishes
text and binary permission errors, validates stream properties and stream-term
requirements, and tightens creation, truncation/append, repositioning, flush,
EOF, close, and current-stream behavior. Corrigendum 2 `keysort/2` variable and
non-pair errors are corrected. Strict arithmetic no longer exposes the
EyeProlog-only evaluable atom `e`, while the Corrigendum arithmetic additions
remain available. These corrections are retained as regression evidence inside the closed shall-by-shall/error-condition review.

The next Corrigendum 2 pass closed the prescribed `call/2..8` max-arity
branch for processors with a finite `max_arity`, and corrected reverse
`atom_chars/2` / `atom_codes/2` improper-list culprits. With EyeProlog's selected `max_arity=unbounded`, the conditional `call/N`
`representation_error(max_arity)` branch is intentionally unreachable unless a
future processor profile selects a finite compound-term limit; closure
expansion itself remains covered by strict regressions.


The following Part 1 pass tightens more of the still-open prescribed-error and
arithmetic matrix. `arg/3`, `atom_concat/3`, `sub_atom/5`, `number_chars/2`,
`number_codes/2`, and `char_conversion/2` now cover their individual standard
error conditions and retain deterministic EyeProlog choices for overlapping
conditions; 7.12 explicitly leaves such simultaneous-error selection
implementation dependent unless another rule constrains it. Corrigendum 2 partial
versus improper list distinctions are applied consistently to atomic and
number conversion. Clause 9 strict evaluation now gives the prescribed
number/integer operand diagnostics, checks direct-variable instantiation first,
enforces the float-only input modes of `floor/1`, `truncate/1`, `round/1`, and
`ceiling/1`, and reports zero raised to a negative power as undefined. Finally,
strict mixed integer/float arithmetic comparisons perform the Part 1
integer-to-float conversion (including `float_overflow`); normal EyeProlog keeps
its exact cross-type comparison as an extension. Dedicated strict regressions
cover these distinctions without changing the normal-profile arithmetic error
contract.

A further Clause 9 pass closes the floating conversion and exceptional-value
boundary exposed by unbounded integers. Strict floating evaluable functors now
perform the required integer-to-float conversion before invoking the host math
operation, so an integer outside the selected finite binary64 range reports
`evaluation_error(float_overflow)` rather than producing a secondary host-math
result. The explicit underflow clauses for `exp/1`, Part 1 `**/2`, and
Corrigendum 2 `^/2` are enforced even though EyeProlog retains the
implementation-defined `round(x)` choice for generic `resultF` arithmetic. The
power review also preserves the specified negative-base and zero/negative
exception conditions before any later I->F overflow, including Corrigendum 3's
correction to the `**/2` operand wording and Corrigendum 2's distinct rule that
`^/2` may accept an integer-valued float exponent.


A subsequent 8.11/8.12 pass closes two stream-option/error-overlap details.
For `get_code/1-2` and `peek_code/1-2`, a fixed integer which is not an
in-character code is now diagnosed only after the earlier stream
existence/direction/text-vs-binary/past-EOF and input-entity conditions, so it
cannot mask the stream error prescribed by the published table. `close/2` now
also treats `force(true)` as a presence-based option exactly as 8.11.6.1(a)
describes: a later `force(false)` does not cancel an earlier `force(true)` when
a Resource Error or System Error occurs during closure. Focused strict tests
cover both overlap families.

The row-level matrices make the exit criteria concrete rather than leaving conformance as a broad test-count claim.
[ISO-BUILTIN-MODE-ERROR-MATRIX.md](ISO-BUILTIN-MODE-ERROR-MATRIX.md) now records
each prescribed mode/error row for the 8.2-8.5 and 8.15-8.17 slices, and
[ISO-PROCESSOR-REQUIREMENTS.md](ISO-PROCESSOR-REQUIREMENTS.md) decomposes the
Clause 5 obligations into covered, review, and not-applicable decisions. While
doing that mapping, the 7.6.2 term-to-clause conversion review exposed a runtime
assertion defect: variables and invalid terms nested under `;/2` or `->/2` were
not being recursively converted. `asserta/1` and `assertz/1` now convert all
three standardized binary control forms `,/2`, `;/2`, and `->/2` recursively,
so nested variables become `call/1` and a non-callable nested branch is rejected
at assertion time with the complete clause-body culprit.

The Clause 5 decomposition also exposed an embedding-only type boundary that
source-text tests could not see. EyeProlog's normal JavaScript API deliberately
exports `stringTerm(Text)` as an implementation-specific additional term type.
Its normal-profile ordering, conversion, evaluation, and writing behavior is
now documented under 5.5.4, while strict `Program` construction and strict
`Solver` goal entry reject such terms with `representation_error(term)`. This
keeps the host extension available in normal mode without allowing it to become
a sixth term type in the Part 1 strict execution domain.

A row-level 8.6-8.10 pass then turns arithmetic predicates, clause/database
operations, and all-solutions predicates into explicit mode/error-condition
entries. During that review, strict source preparation exposed a 7.6.2 defect:
a clause such as `foo(X) :- X.` was executed as a variable goal but was not
stored in the converted `call(X)` form, so `clause(foo(C),call(C))` and the
corresponding `retract/1` pattern lost the required head/body variable identity.
Strict preparation now performs the same recursive body conversion used by
runtime assertion while preserving the original variable objects. The pass
also records the 7.12 rule for simultaneous errors, so deterministic overlap
tests are treated as processor choices unless more specific normative text
constrains them.

The subsequent 8.11-8.14 pass completes the built-in row review. Stream
selection/control, character/code input and output, byte I/O, term I/O,
operators, and character conversion now each have explicit success/mode and
individual-error outcomes in `ISO-BUILTIN-MODE-ERROR-MATRIX.md`. During this
pass `stream_property/2` exposed a lifecycle distinction: a syntactically valid
stream-term for a stream that has been closed denotes no currently open stream
property pair and therefore fails, whereas a term that is not a stream-term is
still a `domain_error(stream, ...)`. The higher-level Clause 6, 7.10, and 7.12 gates now close those surrounding processor requirements as well, so the built-in table participates in a fully dispositioned release-facing ledger.

## Post-Corrigendum STC cross-check

The public WG17 STC draft is tracked as useful defect-discovery material, but it
is not silently treated as a fourth published Corrigendum. The current review
confirms EyeProlog already has the behavior implicated by the substantive STC
items on negative-number layout/operator syntax, arithmetic instantiation
precedence, EOF actions/end tokens, character/code/byte output error overlap,
clause head/body variable identity, sequential `op/3` and `set_prolog_flag/2`
preparation effects, integer-to-float transcendental evaluation, `char_code/2`
type precedence, `read_term/3` EOF handling, mixed arithmetic comparison,
`integer_rounding_function=toward_zero`, `set_prolog_flag/2` variable errors,
and `bagof/3` answer order. STC #21 is also used to keep finite-host exhaustion
of unbounded integer operations inside the Prolog resource-error model.

The newer STC arity discussion clarifies that `max_arity` describes
compound terms. EyeProlog therefore selects `unbounded` and does not invent a
finite predicate/procedure ceiling merely to preserve the former 65535 value.
STC #56, which became a WG17 action item, is implemented narrowly for database
protection: `(:-)/1-2` are static/private for modification and `clause/2`
access, while ordinary calls retain their separate existence behavior. The 2026-08-23 post-N289 draft adds four more executable review points. STC
#73 confirms the draft `max_float` / `min_float` representation-limit shape for
`read/1-2` and `read_term/2-3`; STC #74 extends the same distinction to
`number_chars/2` and `number_codes/2`; STC #76 proposes the
`representation_error(character)` already exercised by EyeProlog's invalid-UTF-8
read regressions. STC #75 is deliberately different: it proposes changing the
published power-underflow conditions so that they depend on the 9.1.4.2
`resultF` choice. Because that proposal is not a published Corrigendum, strict
mode keeps the licensed Part 1/Corrigendum 2 power errors while the draft
divergence is pinned and documented.

Other draft/editorial or deliberately controversial proposals (for example deleting
standalone if-then) remain outside the Part 1 + Corrigenda 1-3 strict baseline
until standardized or adopted as an explicit compatibility extension.

## Strict-core boundary

`isoStrict: true` is intentionally a **Part 1 + Corrigenda 1-3** mode. It does
not interpret the following as core-language features:

- EyeProlog quads and the predefined infix `(?-)/2` quad operator;
- EyeProlog standard-library/native adapters and CLP(Z) predicates;
- the implementation-specific `occurs_check` Prolog flag;
- Part 2 module directives (`module/2`, `use_module/1-2`, `meta_predicate/1`);
- Part 3 grammar-rule expansion and `phrase/2-3`;
- explicit tabling, EyeProlog well-founded evaluation via `tnot/1` and
  `wfs_truth/2`, WFS runtime statistics, and recursive numeric execution shortcuts;
- normal-profile integer digit separators (the accepted WG17 single-underscore/layout form documented at <https://www.complang.tuwien.ac.at/ulrich/iso-prolog/digit_separators>) and Trealla-compatible
  `"text"||Tail` double-quoted-list splicing;
- the JavaScript API `stringTerm(Text)` additional term type (normal mode only).

The predefined Part 1 `1200 fx` `?-` operator and `1200 xfx` `-->` operator
remain ordinary operator syntax in strict core mode. A conforming `op/3`
directive may still add an infix `?-` definition; strict mode reads that as an
ordinary term rather than as a quad.

Module and DCG compatibility features remain supported and tested in the
normal EyeProlog profile, but they are not folded into the Part 1 strict-core
claim. The project does not currently assert that this evidence closes every
requirement of ISO/IEC 13211-2:2000 or ISO/IEC TS 13211-3.

## Release gate

A release intended to advance ISO conformance uses one canonical command:

```sh
npm test
```

That command first fetches and runs the **latest seven Neumerkel conformity
sources**, then executes the deterministic local conformance, strict ISO,
vendored WG17 regression, regression/API, examples, documentation and
architecture gates. The upstream case counts are discovered dynamically.

Useful focused commands are:

```sh
node test/run-conformance-all.mjs
node test/run-neumerkel.mjs
node test/run-iso-strict.mjs
node test/run-wg17.mjs
npm test -- --offline
```

`npm test -- --offline` is a development/reproduction aid; it is not sufficient for a
release claim that says EyeProlog passes the latest Neumerkel suites. Expected
conformance outputs are never auto-accepted.

## Exit criteria for a full conformance claim

The Part 1 review is closed by explicit dispositions, not by a test-count threshold.
The table below records the closure criteria used by the project. A `covered`
status is an implementation/review result, not an independent certification. Public
post-N289 STC drafts remain review input until standardized.

| Criterion | Status | Evidence |
| --- | --- | --- |
| Clause 5 processor obligations have explicit dispositions | covered | `ISO-PROCESSOR-REQUIREMENTS.md` gives explicit outcomes for 5.1-5.5, including the strict/normal extension boundary. |
| Clause 6 lexical/syntactic requirements have explicit dispositions | covered | the strict Clause 6 production/rejection gate and the 379-case vendored WG17 matrix cover the standard families; cross-profile preservation verifies that normal extensions do not reinterpret strict-accepted text. |
| Clause 7 semantic requirements have explicit dispositions | covered | 7.1-7.12 now have explicit semantic, implementation-defined, or error-envelope dispositions backed by strict tests and the specialized matrices. |
| Clause 8 built-in modes/errors have explicit dispositions | covered | `ISO-BUILTIN-MODE-ERROR-MATRIX.md` accounts for 8.2-8.17 condition by condition, using grouped rows only where every grouped condition and its evidence are named |
| Clause 9 evaluable-functor requirements have explicit dispositions | covered | `ISO-EVALUABLE-FUNCTOR-MATRIX.md` plus the strict arithmetic regression closes the published Part 1 + Corrigenda arithmetic rows |
| Implementation-defined choices are documented | covered | `ISO-IMPLEMENTATION-DEFINED.md` is the Clause 5.4 decision index and strict tests pin execution-visible choices |
| Implementation-specific strict/normal boundary is documented and tested | covered | all 5.5 hooks have explicit dispositions; the WG17 cross-profile gate verifies syntax-preservation for standard text accepted by the strict reader. |
| Published Corrigenda 1-3 are incorporated | covered | `ISO-CORRIGENDA-MATRIX.md` inventories every published amendment cluster with executable, editorial, or superseded disposition |
| Current post-N289 draft is tracked without silently changing the published baseline | covered | `STC-DRAFT-STATUS.md` tracks reviewed draft items separately from normative requirements |
| Latest Neumerkel conformity is a live release gate | covered | `npm test` fetches and executes the seven current TU Wien conformity sources with dynamic inventories; the vendored WG17 matrix remains an offline reviewed-outcome regression layer |
| Third-party standard-core regression provenance is retained | covered | adapted Logtalk, Scryer, Trealla, and SWI-Prolog cases retain source identifiers and licenses in `THIRD_PARTY.md` |
| No unexplained deviation remains in the release-facing ledger | covered | the release-facing ledger contains no remaining `review` rows; documented variation points are implementation-defined/specific or draft-only rather than unexplained deviations. |

The specialized row matrices are evidence for this ledger, not separate public
status documents. *The Art of EyeProlog* remains the implementation reference.
