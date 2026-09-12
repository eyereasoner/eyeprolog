# EyeProlog conformance report

This report combines a live external conformance gate with the file-based
conformance corpus under `test/conformance/`. The file-based corpus is
measured when this report is generated; it is not inferred from fixture counts.

## Latest Neumerkel evidence

See the tracked [latest Neumerkel conformity report](test/conformance/NEUMERKEL-LATEST.md)
for the executable external gate, including WG17 syntax conformance: `npm test`
fetches all eight TU Wien sources (syntax discovered and executed live, not a
vendored fixture) and executes the discovered inventory. The release workflow
then synchronizes this tracked report from those exact successful cached source
bytes, avoiding a second live fetch and its race window.

## File-based corpus inventory

| Category | Positive | Errors | Warnings | Proofs | Total |
|---|---:|---:|---:|---:|---:|
| aggregation | 18 | 0 | 0 | 0 | 18 |
| arithmetic | 38 | 0 | 0 | 0 | 38 |
| atoms | 23 | 8 | 0 | 0 | 31 |
| builtins | 11 | 0 | 0 | 0 | 11 |
| context | 11 | 0 | 0 | 0 | 11 |
| control | 15 | 0 | 0 | 0 | 15 |
| explicit-tabling | 6 | 0 | 0 | 0 | 6 |
| iso | 211 | 219 | 0 | 0 | 430 |
| lists | 52 | 3 | 0 | 0 | 55 |
| modules | 2 | 0 | 0 | 0 | 2 |
| negation | 8 | 0 | 19 | 0 | 27 |
| proofs | 0 | 0 | 0 | 21 | 21 |
| query | 8 | 2 | 0 | 0 | 10 |
| rules | 13 | 3 | 0 | 0 | 16 |
| stc | 5 | 6 | 0 | 0 | 11 |
| strings | 40 | 0 | 0 | 0 | 40 |
| syntax | 12 | 23 | 0 | 0 | 35 |
| terms | 26 | 3 | 0 | 0 | 29 |
| unification | 18 | 0 | 0 | 0 | 18 |
| variables | 16 | 7 | 0 | 0 | 23 |
| **Total** | **533** | **274** | **19** | **21** | **847** |

## DCG conformance clarification

EyeProlog checks the input and remainder of `phrase/2-3` and reports
`type_error(list, S)` when an argument is neither a list nor a partial list.
These implementation-defined checks follow ISO/IEC TS 13211-3:2025,
8.18.1.3 g and h; this behavior is not a known deviation.
The checks are optional. EyeProlog elects to perform both consistently.
Dedicated regressions require the exact error for atomic non-lists and
improper lists across both arities and both sequence positions, while
accepting variables, proper lists, and partial lists. The upstream quads
allow checking and non-checking outcomes and do not prove this policy.

The Part 3 implementation target is
[ISO/IEC TS 13211-3:2025](https://www.iso.org/standard/83635.html).
The public [error subclause](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/draft-8.18.1.3)
also specifies `list` for these checks.

The [phrase comparison](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/phrase)
links the machine-readable `phrase_quad.pl` corpus. `npm test` fetches and
runs that corpus live through the Neumerkel gate; the offline regression
suite runs all 58 vendored quads. Neither expectations nor error matching
are relaxed for quads 41-44.


## Integer flag choice under `bounded=false`

EyeProlog reports `bounded=false` and uses arbitrary-precision integers.
It therefore associates no current value with `max_integer` or
`min_integer`, so `current_prolog_flag/2` does not enumerate them and
fails when either is named. Both flags stay registered, so
`set_prolog_flag/2` still reaches the normal non-changeable-flag errors.

This is an implementation choice, not a requirement of Part 1. Clause
7.11.1.1 defines the `bounded` flag and does not govern
`current_prolog_flag/2` outcomes, while 7.11.1.2 and 7.11.1.3 give both
flags an implementation-defined default value unconditionally; the
`bounded` condition constrains what that value *means*, not whether the
flag exists. Two alternative readings are equally defensible: expose
implementation-defined values so the flags enumerate, or treat them as
unsupported and raise `domain_error(prolog_flag, Flag)` per 8.17.2.3 b.
EyeProlog prefers silence over inventing a largest integer that its
arithmetic does not have. The vendored Prologue corpus records the
resulting single divergence rather than patching the upstream fixture.

