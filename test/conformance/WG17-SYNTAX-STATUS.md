# WG17 syntax traceability status

Source: [Conformity Testing I: Syntax](https://www.complang.tuwien.ac.at/ulrich/iso-prolog/conformity_testing)  
Upstream inventory checked: 2026-09-10

This ledger counts an upstream case when its WG17 identifier, query, and
expected ISO disposition are stored in the offline executable matrix. Every
case is executed against the upstream Codex expectation. Reviewed exact
EyeProlog outcomes are additional regression locks and can never override the
upstream assertion. Concrete writer expectations are matched lexically: layout,
parentheses, and quoting are significant. Only Codex expectations explicitly
marked e.g. use controlled flexibility for representation choices such as
generated variable names or equivalent numeric spellings.

## Current standing

The percentage below is **traceability coverage**, not a conformance pass rate.
A represented case still has to pass the executable upstream assertion in
`test/run-wg17.mjs`.

| Measure | Count |
| --- | ---: |
| Active upstream cases | 379 |
| Upstream cases represented in the executable matrix | 379 (100.0%) |
| Not yet traced one-by-one | 0 |
| Deleted upstream identifiers | #20, #273 |

The matrix runs in strict ISO stream-reader mode as part of `npm test`. The
3 upstream `waits` cases are checked through EyeProlog's interactive input
hook. All 379 executable cases are independently checked against the
upstream Codex expectation. 365 cases additionally retain exact reviewed
outcomes for stronger regression checking; 14 cases currently rely on the upstream assertion alone.

## Traceable evidence

| Executable evidence | Referenced IDs | WG17 cases |
| --- | ---: | --- |
| [complete offline executable matrix](../run-wg17.mjs) | 379 | #1–#19, #21–#272, #274–#381 |

The evidence groups overlap. Their union is **379** active cases:
#1–#19, #21–#272, #274–#381.

## Untraced upstream identifiers

None.

## Maintenance

1. Run `npm run conformance:update:wg17` to reconcile the dated fixture with upstream.
2. Review every new or changed ISO expectation before adding its expected outcome.
3. Run `node test/run-wg17.mjs` and keep this generated status page synchronized.
