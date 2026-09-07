# EyeProlog conformance report

This report combines an executable external conformance gate with the file-based
conformance corpus under `test/conformance/`. The executable result is measured
when this report is generated; it is not inferred from fixture counts.

## Latest Neumerkel evidence

See the tracked [latest Neumerkel conformity report](test/conformance/NEUMERKEL-LATEST.md).
`npm test` fetches all seven TU Wien sources once and executes the discovered inventory.
The release workflow then synchronizes this tracked report from those exact successful
cached source bytes, avoiding a second live fetch and its race window.

## Executable conformance status

| Gate | Passed | Total | Status |
|---|---:|---:|---|
| WG17 syntax | 366 | 366 | pass |

The WG17 syntax row executes the vendored 366-case conformity-testing matrix
against EyeProlog's strict ISO reader/writer. A behavior fix such as operator-token
spelling therefore changes this report even when no corpus file is added or removed.

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
| iso | 173 | 219 | 0 | 0 | 392 |
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
| **Total** | **495** | **274** | **19** | **21** | **809** |

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

