# ISO Part 1 processor-requirements review

This is the clause-level checklist for the processor requirements that sit
above the individual built-ins. It complements `ISO-COMPLIANCE.md`: the latter
is release-facing prose, while this file keeps each Clause 5 requirement or
extension boundary visible as its own reviewable row.

The normative baseline is ISO/IEC 13211-1:1995 plus Technical Corrigenda 1-3.
`covered` means the requirement has an implementation/documentation decision
and executable evidence. `not applicable` records a standard variation that does
not apply to EyeProlog's selected processor profile. No row here is an independent
certification claim.

## 5.1 — conforming processor obligations

| Requirement | Status | Current evidence |
| --- | --- | --- |
| 5.1(a) prepare conforming Prolog text | covered | the strict Clause 6 production/rejection gate, complete vendored WG17 syntax matrix, and closed 7.4 preparation/directive matrix cover text recognition and preparation |
| 5.1(b) execute conforming Prolog goals | covered | 7.1-7.12 semantics, all 8.2-8.17 built-in rows, and Clause 9 evaluable functors have explicit executable dispositions |
| 5.1(c) reject nonconforming text/read terms | covered | WG17 negative cases plus focused malformed token, list, operator, argument, escape, comment, and extension-syntax cases exercise rejection across the Clause 6 families |
| 5.1(d) specify permitted variations | covered | `ISO-IMPLEMENTATION-DEFINED.md` records the Part 1 implementation-defined choices and implementation-specific extension families |
| 5.1(e) offer a strictly conforming mode | covered | CLI `--iso-strict` and API `isoStrict: true`; registry/directive/operator/flag extension filtering plus disabled implementation-specific execution shortcuts |

## 5.2-5.4 — text, goals, and documentation

| Requirement | Status | Current evidence |
| --- | --- | --- |
| 5.2 conforming and strictly conforming Prolog text boundary | covered | strict parsing/preparation accepts the Part 1 + Corrigenda language under the documented PCS choices and rejects implementation-specific language facilities; normal-profile preservation is checked against every strict-accepted WG17 case |
| 5.3 conforming and strictly conforming Prolog goal boundary | covered | strict registry/control/evaluable filtering plus closed 7.1-7.12, 8.2-8.17, and Clause 9 reviews define the goal boundary |
| 5.4 accompanying documentation for implementation-defined and implementation-specific features | covered | `ISO-IMPLEMENTATION-DEFINED.md`, *The Art of EyeProlog*, strict-boundary documentation, and release-facing conformance ledgers |

## 5.5 — extension boundaries

| Requirement | Status | EyeProlog decision / evidence |
| --- | --- | --- |
| 5.5 general extension rule | covered | normal mode may provide documented extensions; strict mode removes their Part 1 interpretation rather than changing implementation-defined choices |
| 5.5.1 syntax extensions preserve standard token/text meaning | covered | WG17 syntax is a release gate and strict mode removes module/DCG/quad, digit-separator, and double-bar interpretation. Every vendored WG17 case that succeeds in the strict reader has the same observable outcome in normal mode; the focused Clause 6 gate separately covers each standard token/term family and malformed counterparts. |
| 5.5.2 additional predefined operators | covered | strict mode starts from the Part 1 predefined operator table; normal-profile extra operators are documented and filtered |
| 5.5.3 initial character-conversion mapping | covered | identity initial mapping; user changes are exercised through preparation/execution `char_conversion/2` behavior |
| 5.5.4 additional term types | covered | the normal JavaScript API's `stringTerm(Text)` is documented as an implementation-specific sixth term type, including disjointness, ordering, clause conversion, lack of source token syntax, expression behavior, and writing; strict program/goal entry rejects that type with `representation_error(term)` |
| 5.5.5 additional directives | covered | normal module/library directives are documented implementation-specific features and are rejected by strict mode |
| 5.5.6 additional side effects | covered | normal-profile `statistics/0-2`, cleanup/library state, proof/statistics host instrumentation, and other extension effects are documented outside the Part 1 core; strict registry tests exclude the Prolog-visible statistics/cleanup extensions. Host instrumentation is an embedding observation rather than an extra strict Prolog goal effect |
| 5.5.7 additional control constructs | covered | `tnot/1`, `wfs_truth/2`, and implementation-specific execution optimizations are absent/disabled in strict mode; standard control constructs remain separately reviewed |
| 5.5.8 additional flags | covered | normal `occurs_check` extension is absent from strict mode; the Part 1 flag family is fully reviewed |
| 5.5.9 additional built-in predicates and error forms | covered | strict registry excludes normal-profile library/native additions; `ISO-BUILTIN-MODE-ERROR-MATRIX.md` closes the complete 8.2-8.17 family row-by-row; simultaneous-error choices are documented per 7.12 rather than treated as a global table-order mandate |
| 5.5.10 additional evaluable functors/types | covered | strict mode rejects the normal-profile evaluable `e` extension while retaining the full Part 1 + Corrigenda arithmetic set. `ISO-EVALUABLE-FUNCTOR-MATRIX.md` now closes the Clause 9 semantic/error review and pins the 9.1.4.2 `resultF`, mixed-type `max/2`/`min/2`, and signed bitwise/shift choices. Post-N289 STC #75 remains separate from the published baseline |
| 5.5.11 reserved atoms | not applicable | EyeProlog declares no reserved-atom extension; extension names remain ordinary atoms unless used in a documented syntactic/predicate/directive role |

## Clause 6 syntax-preservation closure

The production review is kept here rather than in another status file. The strict
regression gate covers the following families directly, while the complete WG17
matrix supplies detailed externally sourced syntax expectations.

| Clause family | Disposition | Executable evidence |
| --- | --- | --- |
| 6.2 Prolog text/data boundary | covered | complete-term parsing, end-token/boundary rejection, preparation tests |
| 6.3.1-6.3.3 atomic, variable, functional compound terms | covered | atoms, integers/floats, negative numbers, variables, functional arguments |
| 6.3.4 operator notation | covered | precedence/associativity/operator-table tests plus invalid `xfx` chaining |
| 6.3.5-6.3.7 list, curly and double-quoted notation | covered | list tails, curly terms, `double_quotes` behavior and read/write round trips |
| 6.4.1-6.4.8 tokens | covered | layout/comments, quoted escapes, names, integer bases/character codes, floats, double-quoted tokens, solo/meta tokens, malformed counterparts |
| 6.5 processor characters | covered | documented Unicode-scalar PCS and lexical classes, invalid-scalar representation errors |
| 6.6 collating sequence | covered | Unicode scalar value collation, atom-order regressions |
| 5.5.1 preservation under extensions | covered | every WG17 case accepted in strict mode has the same observable result in normal mode |

## Exit-use rule

All top-level rows now have covered, not-applicable, or documented
implementation-defined outcomes. `ISO-COMPLIANCE.md` records the same closure in
its embedded release-exit checklist. The green suite is evidence for those
dispositions; it is not presented as independent certification.
