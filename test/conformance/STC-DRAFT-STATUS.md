# WG17 STC draft review status

Source: [post-N289 draft for further technical corrigenda](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc)

This file tracks implementation-relevant questions from the WG17 **working
draft**. It is deliberately separate from the ISO/IEC 13211-1 conformance
claim: an STC item is a proposal or defect report until WG17 adopts normative
wording.

The purpose of this ledger is practical. Where an STC item can be expressed as
an executable Prolog observation, EyeProlog keeps a standards-facing case under
`test/conformance/cases/stc/` (or points to an existing strict/WG17 case) so discussion
of the draft can expose implementation problems before they become release
regressions.

## Reviewed executable items

| STC item | Topic | EyeProlog evidence / finding |
| --- | --- | --- |
| [#17](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#17) | expression-error overlap | The strict suite pins both `X is 1/0+_` and `X is _+1/0` to `instantiation_error`, so the direct-variable rule is not masked by implementation evaluation order or a zero-divisor on the other operand. |
| [#18](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#18) | `eof_action(error)` | Stream regressions verify the first EOF observation yields the EOF value and a subsequent read with `eof_action(error)` raises `permission_error(input,past_end_of_stream,...)`; `eof_code` and `reset` remain distinct. |
| [#21](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#21) | unbounded-integer resource exhaustion | The strict suite now prevents host `RangeError` leakage from oversized integer shifts/powers and reports `resource_error(memory)`, consistent with the Part 1 resource-error note and the STC correction proposal. The same principle is used when unbounded `functor/3` construction exhausts a finite host resource. |
| [#27](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#27)-[#29](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#29) | overlapping character/code/byte stream errors | Existing stream tests plus strict probes preserve argument validation before later stream-state errors where the published error clauses require it; the STC examples with an open alias produce the stated instantiation/type errors. |
| [#32](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#32) | `number_chars/2` declarative/procedural wording | The strict suite follows the published procedural number-syntax path: `number_chars(N,['0','1'])` succeeds with `N = 1`. This records the executable behavior without treating the draft wording proposal as a new normative clause. |
| [#37](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#37) | `clause/2` variable identity | `stc/clause_variable_identity` verifies sharing between head and body is preserved. |
| [#39](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#39) | negative-number syntax | Covered extensively by the upstream-first WG17 syntax matrix; unary-minus read-back discrepancies found by that matrix were fixed in v1.3.27. |
| [#40](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#40) | inexact float representation | EyeProlog uses the host IEEE-754 binary64 value and requires written floats to read back to that same value. Input underflow is covered by `stc/float_underflow_input`. |
| [#41](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#41) | preparation-time `op/3` ordering | A strict parser regression verifies an `op/3` directive affects following text and cannot retroactively make preceding text parse with the new operator. The same preparation machinery is used for `set_prolog_flag/2`. |
| [#42](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#42) | integer-to-float conversion for float functions | `stc/integer_to_float_evaluable` verifies an integer expression is accepted by `sin/1` and produces a float. The strict suite additionally verifies that an unbounded integer outside the finite binary64 range raises `evaluation_error(float_overflow)` during I->F conversion before `sin/1`, `cos/1`, `atan/1`, the Corrigendum 2 inverse/trigonometric additions, `exp/1`, `log/1`, `sqrt/1`, or `float/1` can observe a host infinity. |
| [#44](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#44) | `char_code/2` error classification | Strict coverage distinguishes `type_error(integer,Code)` for a non-integer code from `representation_error(character_code)` for an integer outside the character-code set. |
| [#48](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#48) | `read_term/3` option wording with `variables([])` | The strict suite verifies `read_term(T,[variables([])])` on input `T.` has no solution because the actual variable list cannot unify with `[]`; this keeps the operational option semantics clear despite the draft's wording concern. |
| [#49](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#49) | `read_term/3` and EOF | Covered by strict reader/conformance tests and the interactive-read regressions. |
| [#50](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#50) | mixed integer/float arithmetic comparison | The STC-facing normal-profile case requires exact cross-type ordering and `max/2`/`min/2` use the same comparison. `--iso-strict` deliberately retains the published Part 1 integer-to-float comparison rule; the draft case is not silently substituted for that normative baseline. |
| [#55](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#55) | integer rounding function | Existing flag conformance verifies `integer_rounding_function = toward_zero`. |
| [#56](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#56) | protect `(:-)/1` and `(:-)/2` from database modification | **The review found a gap.** Strict database operations now treat both functors as static/private for `assert*`, `retract*`, `abolish/1`, declarations, and `clause/2`, while ordinary calls still follow the separate procedure-existence behavior described by the STC item. |
| [#58](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#58) | `set_prolog_flag/2` instantiation error | Existing strict/error coverage requires an instantiation error when a required flag value is a variable. |
| [#67](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#67) | `bagof/3` answer-order example | `stc/bagof_answer_order` verifies the proposed clarifying example produces `[2,1]`. |
| [#68](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#68) | division examples | Existing arithmetic coverage evaluates signed integer `/` through the floating operation; no implementation-defined signed-division result is used. |
| [#69](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#69) | arithmetic example culprit | **The review found a gap.** Strict expression evaluation now applies 7.9.2(c) to an atomic subexpression such as `foo`: it reports `type_error(evaluable,foo/0)` rather than the misleading `type_error(number,foo)` shown by the old 9.1.7 example. |
| [#70](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#70) | optional `max_procedure_arity` | Reviewed after the STC arity discussion corrected the earlier #71 pointer. EyeProlog has no declared procedure-arity limit smaller than its `max_arity=unbounded` term model, so the implementation-defined optional flag is intentionally absent. |
| [#72](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#72) | tentative non-ground stream-term instances | Reviewed as a tentative post-2026 proposal. EyeProlog does not make this draft wording normative in `--iso-strict`; the published Part 1 stream-term/domain rules remain the baseline until WG17 settles the proposal. |
| [#73](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#73) | `read/1-2` and `read_term/2-3` representation limits | The 2026-08-23 post-N289 draft now explicitly proposes `max_float` / `min_float` alongside the existing representation-limit flags. EyeProlog already reports those errors while reading overflowing positive/negative float tokens; strict regression coverage now exercises both `read/1` and `read_term/2`, and the literal STC cases pin parser preparation. |
| [#74](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#74) | `number_chars/2` and `number_codes/2` representation limits | Positive and negative overflow now have explicit draft-facing cases for both conversion predicates, reporting `representation_error(max_float)` / `representation_error(min_float)` rather than a syntax error. |
| [#75](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#75) | power underflow versus the 9.1.4.2 `resultF` choice | The draft proposes making the Part 1 `**/2` and Corrigendum 2 `^/2` underflow rows conditional on the implementation-defined `resultF` underflow choice. EyeProlog's published-baseline strict mode intentionally retains the currently published unconditional power-underflow clauses; its separate 9.1.4.2 choice remains `round(x)`. This proposal is tracked, not silently adopted. |
| [#76](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/stc#76) | `read/1-2` and `read_term/2-3` invalid input entity | Existing file-stream regressions already require `representation_error(character)` for invalid UTF-8 through all four read/read_term arities. The regression is now cross-referenced to the new draft item. |

## Float-reading implementation note

EyeProlog currently has a finite-double numeric profile. The draft-facing cases
record EyeProlog's finite-double behavior:

- a positive finite numeric token beyond the representable range raises
  `representation_error(max_float)`;
- the corresponding negative overflow raises `representation_error(min_float)`;
- float input and arithmetic underflow use the same binary64 rounding policy;
  values smaller than the representable range round to `0.0`;
- overflow produced by arithmetic evaluation remains
  `evaluation_error(float_overflow)`.

These `max_float` / `min_float` names are treated as a **draft-facing representation-limit extension**, now explicitly reflected by post-N289 STC #73/#74, not as a claim that the currently published ISO core standard already contains those flag names.
The earlier WG17 float-update material also uses
`representation_error(float_overflow)` for unsupported infinity input, while
STC #73/#74 use `max_float` / `min_float` for a finite numeric text that lies
outside the implementation's finite float range. Those cases should remain
distinct when WG17 settles the wording. STC #75 is independent again: it asks
how power underflow relates to the implementation-defined `resultF` choice.

Relevant background:

- [WG17 float update](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/core_update_float-2014-07-21)

## Maintenance rule

When the STC draft changes, review executable changes before a release. Draft
expectations must never silently replace the normative ISO/WG17 expectations;
where the two differ, keep the draft test clearly labelled `stc/` until the
standardization status changes.
