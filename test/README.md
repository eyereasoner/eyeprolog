# Test runners

Normally, run `npm test`. Use `npm test -- --offline` to skip live upstream fetching.
`npm run conformance:update:wg17` refreshes the vendored WG17 snapshot.

For development, run a focused check directly from the repository root:

```sh
node test/run-regression.mjs        # all regression sections
node test/run-regression.mjs docs   # documentation checks only
node test/run-conformance-all.mjs   # conformance layers; accepts --offline
node test/run-wg17.mjs              # vendored WG17 syntax
node test/run-iso-strict.mjs        # strict ISO core
node test/run-iso-part2-amendment.mjs
node test/run-neumerkel.mjs         # live upstream; --cached reproduces last fetch
node test/run-neumerkel-tests.mjs   # upstream-fetch harness
node test/run-examples.mjs
node test/run-playground.mjs
node test/run-architecture.mjs
node test/run-openrulebench.mjs
node test/run-http-json.mjs
node test/run-interop.mjs           # requires the comparison engines
node test/run-benchmark-tests.mjs   # benchmark harness
```

These runners retain their existing options; there is no separate npm alias for
each one. Focused checks do not replace the full release gate.

For performance measurements, use `npm run benchmark`. Save a local baseline with
`npm run benchmark -- --save .benchmarks/baseline.json`, or run
`node test/lips-benchmark.mjs` for the classic LIPS measurement.

See the [conformance guide](conformance/README.md) for report maintenance.
