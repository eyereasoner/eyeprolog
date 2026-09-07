# ISO/IEC 13211-1 published Corrigenda review

This matrix records every amendment cluster in Technical Corrigenda 1:2007,
2:2012, and 3:2017 against EyeProlog's published Part 1 baseline. It separates
behavior-changing requirements from editorial/example-only corrections and
from text superseded by a later Corrigendum. A `covered` behavior row names
executable evidence; an `editorial` row records that no processor behavior was
changed; a `superseded` row points to the later published amendment.

The stable review IDs are checked by the documentation regression suite. They
make omission detectable without reproducing the licensed standard text here.

## Technical Corrigendum 1:2007

| Review ID | Clauses / amendment cluster | Disposition | EyeProlog evidence |
| --- | --- | --- | --- |
| C1-01 | 3.106, 3.108, 3.125, 3.148 terminology and typography | editorial | Definitions/source typography; no processor behavior changes. |
| C1-02 | 4.1.3.5 non-negative square-root axiom | covered | Strict test `pins behavior-changing Technical Corrigendum 1 corrections` checks `sqrt(0)`. |
| C1-03 | 6.3.7 priority of a double-quoted atom that names an operator | covered | Same strict test plus `iso/corrigendum1_double_quote_operator`. |
| C1-04 | 7.2.5 compound-term ordering wording | editorial | The corrected condition is represented by the Clause 7.2 standard-order tests. |
| C1-05 | 7.8.5.4, table 35, and 7.8.8.4 control-model/example corrections | editorial | Corrected notation; conjunction and if-then-else behavior is independently covered by the strict 7.8 review. |
| C1-06 | 7.9.2 integer- and float-operand type errors | covered | Strict Clause 7.9 tests exercise integer-only and float-only templates. |
| C1-07 | 7.12.2 representation-error metavariable capitalization | editorial | Error-term representation is covered by the 7.12 envelope; this amendment changes notation only. |
| C1-08 | 8.8.1.1 selected `clause/2` result is unified with head/body | covered | Strict test `pins behavior-changing Technical Corrigendum 1 corrections`. |
| C1-09 | 8.9.4.1 `abolish/1` note wording | editorial | Singular/plural note correction only. |
| C1-10 | 8.10.3.4 set-order example | superseded | Corrigendum 3 explicitly restores the original example; current behavior follows Corrigendum 3. |
| C1-11 | 8.13.3.4 `put_byte/1-2` example values | editorial | Examples corrected; byte-output semantics are covered by the strict 8.13 review. |
| C1-12 | 8.14.1.4 input-stream names and post-syntax-error example state | editorial | Examples corrected; read-stream behavior is covered by strict term-I/O tests. |
| C1-13 | 8.14.4.1 selected `current_op/3` result is unified with its arguments | covered | Strict test `pins behavior-changing Technical Corrigendum 1 corrections`. |
| C1-14 | 8.16.4 `atom_chars/2` accepts a matching supplied list prefix | covered | Strict test `pins behavior-changing Technical Corrigendum 1 corrections`. |
| C1-15 | 8.16.5 `atom_codes/2` accepts a matching supplied list prefix | covered | Strict test `pins behavior-changing Technical Corrigendum 1 corrections`. |
| C1-16 | 9.1.4.1 and 9.1.7 arithmetic notes/examples | editorial | Corrected examples and reference; corresponding arithmetic operations are covered by the Clause 9 matrix. |
| C1-17 | 9.3.5.4 and 9.3.6.4 transcendental example constants | editorial | Example constants only; `exp/1` and `log/1` have executable strict coverage. |
| C1-18 | 9.4.1-9.4.4 example error terms | editorial | Corrected examples; evaluable-functor and integer-operand errors are covered by strict Clause 9 tests. |

## Technical Corrigendum 2:2012

| Review ID | Clauses / amendment cluster | Disposition | EyeProlog evidence |
| --- | --- | --- | --- |
| C2-01 | 6.3.4, 6.4, 6.5 bar token/operator rules and protected `[]`/`{}` operators | covered | WG17 lexical output cases, `corrigenda_bar_operator`, and strict `op/3` tests. |
| C2-02 | 6.3.4.4 predefined unary plus and `div` operators | covered | Strict predefined-operator and arithmetic tests. |
| C2-03 | 7.1.1.5 witness-variable list | covered | `term_variables/2`, read-option traversal, and variable-order tests. |
| C2-04 | 7.1.6.9 list-prefix definition | covered | Atomic-conversion partial/improper-list tests. |
| C2-05 | 7.8.3.4 complete term-to-body error culprit for `call/1` | covered | Strict 7.8 callability and recursive body-conversion tests. |
| C2-06 | 7.8.9 `catch/3` catches errors arising from its protected goal | covered | `corrigenda_catch_callability` and strict exception tests. |
| C2-07 | 7.9 typed evaluable-operand error selection | covered | Strict Clause 7.9/9 operand-template tests. |
| C2-08 | 7.12.2 pair/order domains and uninstantiation error class | covered | Strict error envelope and Corrigendum-specific output-argument tests. |
| C2-09 | 8.1.3 output-mode arguments use uninstantiation errors | covered | Strict `open/4` output argument test. |
| C2-10 | 8.2.4 `subsumes_term/2` | covered | Strict registry and Corrigendum term-predicate tests. |
| C2-11 | 8.3.9-8.3.11 `callable/1`, `ground/1`, `acyclic_term/1` | covered | Strict registry/type tests and `corrigenda_term_predicates`. |
| C2-12 | 8.4.2-8.4.4 `compare/3`, `sort/2`, `keysort/2` | covered | Strict mode/error rows and `corrigenda_sort_keysort`. |
| C2-13 | 8.5.5 `term_variables/2` | covered | Strict mode/error rows and `corrigenda_term_predicates`. |
| C2-14 | 8.9.3 static `retract/1` uses modify permission | covered | Strict database predicate error tests. |
| C2-15 | 8.9.5 `retractall/1` | covered | Strict lifetime/error tests and `corrigenda_retractall`. |
| C2-16 | 8.11.5 non-variable `open/4` stream result | covered | Strict uninstantiation-error test. |
| C2-17 | 8.14.3 protected operator priority/specifier combinations | covered | Strict `op/3` row review and bar-operator cases. |
| C2-18 | 8.15.4 `call/2..8` and implementation-dependent higher arities | covered | Strict closure expansion, error, and selected ceiling tests. |
| C2-19 | 8.15.5 `false/0` | covered | Strict registry, execution, and static-procedure protection tests. |
| C2-20 | 8.16.4-8.16.8 atomic/number conversion partial-list errors | covered | Individual strict mode/error assertions for all four predicates. |
| C2-21 | 9.1 unary plus and flooring integer `div/2` | covered | Strict arithmetic matrix and negative-operand distinction from `//2`. |
| C2-22 | 9.3 `max/2`, `min/2`, `^/2`, inverse trig, `atan2/2`, `tan/1`, and `pi/0` | covered | Strict evaluable-functor matrix and exceptional-value tests. |
| C2-23 | 9.4.6 `xor/2` | covered | Strict signed bitwise and operand-type tests. |

## Technical Corrigendum 3:2017

| Review ID | Clauses / amendment cluster | Disposition | EyeProlog evidence |
| --- | --- | --- | --- |
| C3-01 | 5.5.12 implementation-specific options and their error classification | covered | Strict option surfaces reject normal-only options and exercise variable/domain distinctions. |
| C3-02 | 6.2.1 optional final layout text | covered | Strict test `pins behavior-changing Technical Corrigendum 3 corrections`. |
| C3-03 | 7.1.6.3 iterated-goal term uses structural form rather than unification | covered | Strict `bagof/3`/`setof/3` grouping and error tests. |
| C3-04 | 7.8.3 `call/1` applies term-to-body conversion before execution | covered | Strict call/cut-scope and variable-body conversion regressions. |
| C3-05 | 7.10.3 read-option unification and left-to-right variable traversal | covered | Corrigendum 3 metadata traversal tests. |
| C3-06 | 7.10.4 `variable_names/1` write option | covered | Strict test `pins behavior-changing Technical Corrigendum 3 corrections` and file-based writer case. |
| C3-07 | 7.10.5 variable, list, curly, functional, and operator writing rules | covered | Strict writer suite and exact WG17 writer assertions. |
| C3-08 | 7.12.2 error-classification set corrections | editorial | Corrected type/domain/permission enumerations are reflected by individual strict errors. |
| C3-09 | 8.1.2/8.1.3 option-list modes and component-variable errors | covered | Strict open/close/read/write option-list assertions. |
| C3-10 | 8.5.1.4 conditional `max_arity` example | editorial | Example disposition is documented; EyeProlog selects `max_arity=unbounded`. |
| C3-11 | 8.9.2.1 assertion-description variable correction | editorial | Metavariable typo only; `assertz/1` conversion behavior is strictly tested. |
| C3-12 | 8.10.3.4 restores the original set-order example | superseded | Supersedes C1-10; current grouped-solution order is tested and documented as implementation dependent where permitted. |
| C3-13 | 8.11.4.1 explicit success of `set_output/1` | covered | Strict stream-selection success test. |
| C3-14 | 8.11.5, 8.11.6, 8.14.1, 8.14.2 option-list error rewrites | covered | Individual strict option instantiation/list/domain assertions. |
| C3-15 | 8.14.1.1 corrected syntax reference | editorial | Reference correction only; read-term syntax errors are executable. |
| C3-16 | 8.14.2.4 canonical-list and option-error examples | covered | Canonical list output, variable option, and invalid option tests. |
| C3-17 | 8.17.1.4 unknown flag uses the `prolog_flag` domain | covered | Strict `set_prolog_flag/2` unknown-flag test. |
| C3-18 | 9.3.1.3 arithmetic metavariable correction | editorial | Metavariable typo only. |
| C3-19 | 9.3.10 negative integer exponent requires a float base | covered | Strict test `pins behavior-changing Technical Corrigendum 3 corrections`. |

## Closure rule

The three Corrigenda rows in `ISO-COMPLIANCE.md` may be marked `covered` only
while this complete stable-ID inventory passes its structural regression and
every behavior-changing row retains executable evidence. Editorial and
superseded rows are explicit dispositions rather than silently omitted tests.
