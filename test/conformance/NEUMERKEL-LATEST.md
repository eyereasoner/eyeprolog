# EyeProlog — latest Neumerkel conformity

Status: **PASS** — **686/686** discovered upstream cases passed.

This tracked report records the latest upstream inventory successfully checked by EyeProlog.
`npm test` fetches the seven TU Wien sources again and executes the discovered cases.
Release/report checks can additionally require these tracked counts to match the live suites.
Counts are output from upstream, not hard-coded test constants.

| Suite | Passed | Total |
|---|---:|---:|
| syntax | 379 | 379 |
| number_chars/2 | 86 | 86 |
| variable_names/1 | 75 | 75 |
| dif/2 | 26 | 26 |
| length/2 | 37 | 37 |
| phrase/2,3 | 58 | 58 |
| setup_call_cleanup/3 | 25 | 25 |
| **Total** | **686** | **686** |

## Upstream sources

- [syntax](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/conformity_testing)
- [number_chars](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/number_chars_cont_quad.pl)
- [variable_names](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/variable_names_quad.pl)
- [dif](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/dif)
- [length](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/length_quad.pl)
- [phrase](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/phrase_quad.pl)
- [cleanup](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/cleanup)

Exact fetched bytes, SHA-256 hashes, fetch timestamps, and HTTP validators remain under
Git-ignored `.cache/neumerkel/` for local inspection/reproduction and are intentionally not committed.
A normal test run warns when this tracked report is stale. Refresh directly from live
upstream with `npm run conformance:update:neumerkel`, or sync the exact successful
snapshot already fetched by `npm test` with `npm run conformance:sync:neumerkel`.
`npm run conformance:check:neumerkel` verifies the tracked report against that last
successful live snapshot without fetching upstream a second time.

