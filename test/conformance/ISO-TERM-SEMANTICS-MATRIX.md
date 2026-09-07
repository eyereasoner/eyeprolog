# ISO Part 1 term-semantics coverage matrix

This file closes the Clause 7.1-7.3 review at a finer granularity than the
release-facing `ISO-COMPLIANCE.md`. The normative baseline is ISO/IEC
13211-1:1995 plus Technical Corrigenda 1-3.

`covered` means the applicable Part 1 semantic rule has an implementation
choice where the standard permits one and executable evidence in the strict
profile. This matrix is implementation evidence, not independent
certification.

## 7.1 - term types and derived term notions

| Requirement family | Status | EyeProlog evidence |
| --- | --- | --- |
| Five mutually exclusive core term types | covered | strict type predicates and ordering tests cover variable, float, integer, atom, and compound; the normal-profile host string term is rejected at strict program/goal entry |
| Atomic-term boundary | covered | integers, floats, and atoms satisfy the atomic predicates; compound terms do not |
| Variable set / repeated-variable identity | covered | `term_variables/2`, read-term Corrigendum 3 variable metadata, `copy_term/2`, collector tests, and repeated-variable unification preserve identity and first occurrence |
| Existential/free-variable use by collectors | covered | `bagof/3` and `setof/3` mode/semantic suites cover explicit `^/2` existential variables and grouping by free variables |
| Integer type | covered | `bounded=false` selects the full mathematical-integer model; `max_integer`/`min_integer` therefore have no value and host exhaustion is translated to `resource_error(memory)` rather than a numeric representation bound |
| Byte and character-code subranges | covered | byte I/O rows and the Unicode-scalar processor character set are separately pinned; byte values remain 0..255 while character codes follow the declared PCS |
| Floating-point type | covered | ECMAScript IEEE-754 binary64 is the documented implementation-defined float model; input overflow and arithmetic exceptional values have strict tests |
| Atoms and one-character atoms | covered | parser/reader/writer, atom conversion, character conversion, and PCS/collation suites cover atom identity and one-character atoms |
| Compound term / arguments / arity | covered | `functor/3`, `arg/3`, `=../2`, parser, predicate-indicator operations, and `max_arity=unbounded` tests cover construction/decomposition and arbitrary semantic arity |
| Lists, predicate indicators, and related derived term notions | covered | list, proper-list, sort/keysort, predicate-indicator, `current_predicate/1`, `abolish/1`, `call/N`, and module/DCG boundary tests exercise the applicable Part 1 derived forms |
| Variants / renamed copies | covered | `copy_term/2`, all-solutions collectors, clause selection, and Corrigendum variable-name tests verify renamed-copy behavior without sharing source variables |

## 7.2 - standard order of terms

| Rule | Status | EyeProlog evidence / decision |
| --- | --- | --- |
| Type order | covered | strict gate pins `variable < float < integer < atom < compound` |
| Distinct variable order | covered | implementation-dependent stable encounter order is documented in `ISO-IMPLEMENTATION-DEFINED.md`; sort/collector operations keep that order stable for the operation |
| Float order | covered | numeric floating ordering is used within the float type |
| Integer order | covered | mathematical BigInt ordering is used within the integer type |
| Atom order | covered | null atom and lexicographic ordering use the declared Unicode-scalar collating sequence |
| Compound order | covered | arity precedes functor name, then arguments are compared left-to-right by standard term order; strict regression pins representative arity/functor cases |

## 7.3 - unification

| Rule | Status | EyeProlog evidence / decision |
| --- | --- | --- |
| NSTO unifiable terms produce an MGU | covered | equality, clause-head matching, repeated-variable, list-tail, nested-compound, and explicit strict regression cases |
| NSTO non-unifiable terms fail | covered | scalar/functor/arity/repeated-variable mismatch suites and strict regression cases |
| STO ordinary unification | covered | Part 1 leaves the result undefined; EyeProlog consistently performs an occurs check and fails cyclic bindings, which is one permitted processor behavior for this undefined case |
| Explicit occurs-check unification | covered | `unify_with_occurs_check/2` succeeds for finite unifiable terms and fails positive-occurs-check cases |
| Implicit unification uses the same finite-tree model | covered | clause-head matching, database operations, control constructs, and collectors share the same unifier; the vendored Prologue STO annotations remain external comparison evidence rather than redefining Part 1 behavior |

## Closure note

The Clause 7.1-7.3 row is `covered` only for the published Part 1 + Corrigenda
baseline. Normal-mode string terms and other EyeProlog extensions remain outside
this strict five-type model and are documented separately under Clause 5.5.
