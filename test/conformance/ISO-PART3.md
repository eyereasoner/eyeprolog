# ISO/IEC 13211-3 (Definite clause grammar rules) — implementation status

This document records what EyeProlog implements of Prolog Part 3, non-terminal
by non-terminal and predicate by predicate. It is a status ledger, not a
conformance claim.

Normal mode implements the whole grammar surface below. `--iso-strict` leaves
`-->/2` as ordinary Part 1 operator syntax and excludes grammar expansion and
`phrase/2-3` from the strict registry, so `phrase/2` there raises
`existence_error(procedure, phrase/2)`.

## Grammar control constructs (clause 7.14)

| Clause | Construct | Status |
| --- | --- | --- |
| 7.14.1 | `[]//0` — empty terminal-sequence | **implemented** |
| 7.14.2 | `('.')//2` — terminal sequence | **implemented** |
| 7.14.3 | `(',')//2` — concatenation | **implemented** |
| 7.14.4 | `(;)//2` — alternative | **implemented** |
| 7.14.5 | `(;)//2` with `(->)//2` — if-then-else | **implemented** |
| 7.14.6 | `('\|')//2` — second form of alternative | **implemented** |
| 7.14.7 | `{}//1` — grammar-body-goal | **implemented** |
| 7.14.8 | `call//1` | **implemented** |
| 7.14.9 | `phrase//1` | **implemented** |
| 7.14.10 | `!//0` — grammar-body-cut | **implemented** |
| 7.14.11 | `(\+)//1` — grammar-body-not | **implemented** |
| 7.14.12 | `(->)//2` — if-then | **implemented** |

## Built-in predicates (clause 8.18)

| Clause | Predicate | Status |
| --- | --- | --- |
| 8.18.1 | `phrase/3` | **implemented** |
| 8.18.1.3 | `phrase/2` (bootstrapped as `phrase(GRBody, S0, [])`) | **implemented** |

### Prescribed errors (8.18.1.4)

| Error | Requirement | EyeProlog |
| --- | --- | --- |
| a) `GRBody` is a variable | `instantiation_error` | **matches** |
| b) `GRBody` is neither a variable nor callable | `type_error(callable, GRBody)` | **matches** |
| c) `S0` is not a terminal-sequence | `type_error(terminal_sequence, S0)` — implementation-defined for `phrase/3`, **required for `phrase/2`** | **diverges**: EyeProlog raises `type_error(list, S0)` |
| d) `S` is not a terminal-sequence | `type_error(terminal_sequence, S)` — implementation-defined | **diverges**: EyeProlog raises `type_error(list, S)` |

**Open divergence.** EyeProlog performs both optional checks — which the draft
permits, and which for `phrase/2` clause c it requires — but reports
`type_error(list, Culprit)` where the 2023-08-14 draft specifies
`type_error(terminal_sequence, Culprit)`. The draft is explicit that if a
processor offers these errors, "their form and consequence must be the
following", so the *form* is not left open even though performing the check is.

This appears to track an earlier edition, in which these clauses were numbered
8.18.1.3 g and h and specified `list`. The behaviour is deliberate and covered
by a dedicated regression matrix, so changing the error term is a decision to
take explicitly rather than a bug to patch silently. Until it is taken, this
row is the one known Part 3 deviation.

What the regression matrix does pin, independently of the error term: the same
diagnostic across both arities, both sequence positions, atomic and compound
non-lists, and improper lists at several depths; the culprit is the whole
invalid argument, including an improper list, not just its tail; variables,
proper lists, and partial lists are accepted; and for otherwise valid grammar
bodies, validation precedes execution even when the grammar would fail or
produce a side effect. The upstream phrase quads permit both checking and
non-checking outcomes and so do not establish this consistency on their own.

## Language concepts

| Clause | Concept | Status |
| --- | --- | --- |
| 7.4.4 | grammar rules in Prolog text | **implemented** |
| 7.5.1 | grammar-rule expansion during preparation | **implemented** |
| 7.13.1 | terminals and non-terminals | **implemented** |
| 7.13.2 | format of grammar rules | **implemented** |
| 7.13.3 | semicontext (pushback) | **implemented** — `head, [Pushback] --> Body` |
| 7.13.4 | non-terminal indicator `A//N` | **implemented** — accepted in module export lists |
| 7.15 | executing clauses expanded from grammar rules | **implemented** |
| 5.5.2 | predefined operators | **implemented** — `-->` is predeclared in both profiles; it is grammar syntax only in normal mode |

`predicate_property/2` does not appear in the 2023-08-14 draft, so no Part 3
predicate-property extension is claimed here. See `ISO-PART2.md` for the Part 2
status of that predicate.

## Executable evidence

Grammar expansion, sequence validation, grammar-body callability, variable-body
instantiation errors, and `phrase/3` steadfastness are under focused tests in
`test/run-regression.mjs` and the conformance corpus. The live Neumerkel gate
covers the upstream phrase quads.

Changes intended to advance a formal Part 3 claim should update this ledger and
the corresponding error cases rather than silently changing the compatibility
profile.

## See also

- `ISO-PART2.md` — Part 2 (modules) status
- `ISO-COMPLIANCE.md` — the Part 1 review that carries the release-facing claim
- `NEUMERKEL-LIVE.md` — the live upstream gate
