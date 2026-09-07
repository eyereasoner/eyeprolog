# ISO Part 1 expression/evaluable-functor coverage matrix

This file is the row-level review for Part 1 Clause 7.9 and Clause 9, including
the arithmetic additions and corrections in Technical Corrigenda 1-3. It is
paired with the strict regression named `closes the ISO 7.9 and Clause 9
evaluable-functor rows`.

The published ISO/IEC 13211-1:1995 + Corrigenda 1-3 text is the normative
baseline. Post-N289 STC draft proposals are tracked separately in
`STC-DRAFT-STATUS.md`; they do not silently replace published requirements.

## 7.9 - evaluating an expression

| Requirement | Status | Evidence / decision |
| --- | --- | --- |
| Evaluate variables | covered | direct variable operands raise `instantiation_error` before competing expression errors in strict mode |
| Evaluate numeric constants | covered | integer and float constants retain their numeric types subject to the documented float representation |
| Select an evaluable functor by name/arity | covered | Part 1 + Corrigenda functors are accepted; a non-evaluable term reports `type_error(evaluable,F/N)`, including the corrected zero-arity culprit shape |
| Recursively evaluate operands | covered | nested arithmetic, arithmetic comparisons, and `is/2` suites cover recursive evaluation; EyeProlog documents its stable operand-evaluation choice where Part 1 permits implementation dependence |
| Operand type constraints | covered | integer-only and float-only templates report the required type errors after expression evaluation |
| Exceptional values | covered | zero divisor, undefined, float overflow, explicit underflow, and finite-host resource exhaustion are pinned in strict tests |

## 9.1 - simple arithmetic and type conversion

| Functor / operation family | Required templates and exceptional branches | Status | Evidence / implementation choice |
| --- | --- | --- | --- |
| `+/2`, `-/2`, `*/2` | integer/integer -> integer; mixed/float -> float | covered | BigInt exact integer operations; binary64 mixed/float operations; host BigInt exhaustion -> `resource_error(memory)` |
| `/2` | numeric operands -> float; zero divisor | covered | binary64 division; zero divisor is an evaluation error |
| `//2` | integer operands; zero divisor | covered | `integer_rounding_function=toward_zero` and BigInt truncating division |
| `rem/2`, `mod/2` | integer operands; zero divisor | covered | sign behavior is pinned for negative operands |
| unary `-/1` | integer or float | covered | preserves numeric type |
| `abs/1`, `sign/1` | integer or float | covered | preserves integer results for integer operands and float results for float operands |
| `float/1` | integer -> float; float -> float | covered | integer-to-float overflow is detected before the selected floating operation |
| `floor/1`, `truncate/1`, `round/1`, `ceiling/1` | float -> integer only | covered | integer operands report `type_error(float,...)`; representative negative/positive rounding results are pinned |
| `float_integer_part/1`, `float_fractional_part/1` | float -> float only | covered | integer operands report `type_error(float,...)` before any I->F conversion; regression includes huge unbounded integers so float overflow cannot mask the required type error |
| integer model | bounded or unbounded choice | covered | `bounded=false`; semantic integer range is unbounded, with finite-host exhaustion represented as a resource error |
| `rndI` | processor integer-division rounding choice | covered | toward zero, consistent with the fixed flag |
| `rndF` / float representation | implementation-defined float rounding model | covered | ECMAScript IEEE-754 binary64 |
| `resultF` | choose generic tiny-result rounding or underflow | covered | EyeProlog selects `round(x)`; representable subnormals survive and still-smaller generic arithmetic may round to `0.0` |
| approximate addition | implementation-defined floating addition | covered | ECMAScript binary64 addition |

## Corrigendum 2 simple-arithmetic additions

| Functor | Status | Evidence / decision |
| --- | --- | --- |
| unary `+/1` | covered | identity over numeric expressions |
| `div/2` | covered | integer floor division; negative-operand cases distinguish it from `//2` |

## 9.3 - other evaluable functors

| Functor family | Status | Exceptional / implementation-dependent coverage |
| --- | --- | --- |
| `**/2` | covered | negative-base restrictions, zero/negative exponent, float overflow, and the published explicit underflow row are pinned |
| `sin/1`, `cos/1`, `atan/1` | covered | integer templates perform I->F conversion first; conversion overflow is detected |
| `exp/1` | covered | float overflow and published non-zero-result underflow are pinned |
| `log/1`, `sqrt/1` | covered | non-positive/domain-invalid values report `evaluation_error(undefined)` as applicable |
| Corrigendum 2 `max/2`, `min/2` | covered | all type templates are supported; mixed numeric types use the documented implementation-dependent exact comparison and return one original operand, preserving its type |
| Corrigendum 2 `^/2` plus Corrigendum 3 correction | covered | integer powers remain exact where defined; negative integer exponent/type rules, negative-base rules, zero-negative exponent, overflow, and published underflow are pinned |
| Corrigendum 2 `asin/1`, `acos/1` | covered | valid values plus out-of-domain undefined errors |
| Corrigendum 2 `atan2/2` | covered | numeric templates plus the zero/zero undefined condition |
| Corrigendum 2 `tan/1` | covered | integer/float templates and I->F conversion behavior |
| Corrigendum 2 `pi/0` | covered | strict evaluable constant is available |

The 2026-08-23 post-N289 draft item #75 proposes conditioning the published
`**/2` and `^/2` underflow rows on the processor's `resultF` choice. EyeProlog
records that proposal but keeps the published unconditional strict behavior
until a normative corrigendum changes the baseline.

## 9.4 - bitwise functors

| Functor | Status | Implementation-defined negative/signed behavior |
| --- | --- | --- |
| `>>/2` | covered | BigInt arithmetic/sign-propagating right shift; negative shift count reverses direction |
| `<</2` | covered | BigInt signed left shift; negative shift count reverses direction |
| `/\\/2` | covered | BigInt infinite-two's-complement semantics |
| `\\//2` | covered | BigInt infinite-two's-complement semantics |
| `\\/1` | covered | BigInt complement, equivalent to `-N-1` |
| Corrigendum 2 `xor/2` | covered | BigInt infinite-two's-complement semantics |

All 9.4 functors require integer operands; non-integers report
`type_error(integer,...)`. Very large otherwise-valid shifts retain the
unbounded integer model and translate finite-host exhaustion to
`resource_error(memory)`.

## Closure note

With this matrix and the strict arithmetic regression, the release-facing
Clause 7.9 and Clause 9 rows are `covered`. The surrounding processor and syntax
requirements are dispositioned in `ISO-PROCESSOR-REQUIREMENTS.md` and
`ISO-COMPLIANCE.md`.
