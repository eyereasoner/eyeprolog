# Test runners

Normally, run `npm test`. The eight upstream suites, including WG17 syntax,
reuse Git-ignored `.cache/neumerkel/`. A missing or incomplete cache is downloaded
automatically. `npm run sync` explicitly refreshes upstream, checks the suites
and updates the tracked report. Use `npm test -- --offline` to skip those suites
entirely, or `node test/run-neumerkel.mjs --cached` to run them without downloads.

For development, run a focused check directly from the repository root:

```sh
node test/run-regression.mjs        # all regression sections
node test/run-regression.mjs docs   # documentation checks only
node test/run-conformance-all.mjs   # conformance layers; accepts --offline
node test/run-iso-strict.mjs        # strict ISO core
node test/run-iso-part2-amendment.mjs
node test/run-neumerkel.mjs         # reuse cache; download if missing or incomplete
                                    # --live forces a refresh; --cached never fetches
                                    # --verify-report fails on a stale tracked report
node test/run-neumerkel-tests.mjs   # upstream-fetch harness
node test/run-examples.mjs
node test/run-playground.mjs
node test/run-architecture.mjs
node test/run-properties.mjs        # seeded random-term invariant checks (see below)
node test/run-openrulebench.mjs
node test/run-http-json.mjs
node test/run-interop.mjs           # requires the comparison engines
```

`npm run neumerkel` runs `node test/run-neumerkel.mjs --live --verify-report`:
it fetches upstream and makes a stale tracked report an error. Normal tests
warn about report drift while still checking every discovered case.
`npm run sync` uses `--live --update-report` to refresh and record that evidence.
The version lifecycle syncs once before the full test run; tests reuse the
same snapshot. Every other runner is invoked directly.
Focused checks do not replace the full release gate.

`run-properties.mjs` is different in kind from the rest of the suite: instead
of hand-picked inputs, it generates many random ground terms from a seeded
PRNG and checks invariants that must hold for any input. It covers term/list/
arithmetic/string library predicates (write/read round-tripping, `sort/2`
ordering and idempotence, `append/3`/`length/2` agreement, `compare/3`
symmetry, `keysort/2` stability, `=..` round-tripping, `copy_term/2` sharing,
`reverse/2` involution, `atom_codes/2`/`atom_chars/2`/`char_code/2`/
`number_codes/2` round-tripping, `succ/2` and `abs/1`/`sign/1` arithmetic
identities, `nth0/3`/`nth1/3` agreement, `last/2`, `min_list/2`/`max_list/2`
bounds, `sum_list/2` additivity, `atom_concat/3`/`string_concat/3` regrouping,
`atom_string/2`/`number_string/2` round-tripping, `list_to_set/2` idempotence,
`permutation/2`, `between/3` range generation, `split/3`/`join/3` inversion)
and, more broadly, control constructs, exceptions, the database, and grammar
rules (`catch/3` ball delivery, `findall/3` order/duplicate/no-match
behavior, double negation, the exact `existence_error` indicator for an
undefined predicate, `assertz/1`+`retract/1` leaving no trace, a DCG list
rule accepting exactly the list it was built from, `bagof/3` agreeing with
`findall/3`, and `numbervars/3` counting distinct variables) -- around 35
properties, each reported as its own trial (currently ~530 individual test
lines) so a failure names exactly which trial of which property broke rather
than leaving a reader to dig through one aggregate error. The whole file
still runs in about two seconds. The seed (`SEED` in that file) is fixed so a
failure is exactly reproducible by rerunning it -- change it only
deliberately, and say why, never to make a transient failure disappear.

There is no separate wall-clock benchmark harness: `npm test`'s own elapsed
time is the project's performance indicator.

Example, proof-example, and proof-checking tests print results as they finish,
so long-running proofs do not hide completed tests behind alphabetical order.
Every test still compares its results with the same golden files.

See the [conformance guide](conformance/README.md) for report maintenance.
