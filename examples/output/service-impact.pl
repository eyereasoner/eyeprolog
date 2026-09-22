% Prolog result format 4
query(1, impactedByFailureOf(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 6).
answer(1, ['X0' = checkout_api, 'X1' = payment_service]).
answer(1, ['X0' = risk_rules, 'X1' = payment_service]).
answer(1, ['X0' = web_store, 'X1' = payment_service]).
answer(1, ['X0' = mobile_app, 'X1' = payment_service]).
answer(1, ['X0' = payment_service, 'X1' = payment_service]).
answer(1, ['X0' = fraud_service, 'X1' = payment_service]).
query(2, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = payment_service, 'X1' = failed]).
query(3, businessFunctionAtRisk(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 4).
answer(3, ['X0' = place_order, 'X1' = true]).
answer(3, ['X0' = mobile_checkout, 'X1' = true]).
answer(3, ['X0' = collect_payment, 'X1' = true]).
answer(3, ['X0' = screen_fraud, 'X1' = true]).
