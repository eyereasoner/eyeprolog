% Prolog result format 4
query(1, root_cause(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(1, complete, 1).
answer(1, ['X0' = inc900, 'X1' = primary_db, 'X2' = disk_full]).
query(2, impacted_service(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 5).
answer(2, ['X0' = inc900, 'X1' = primary_db]).
answer(2, ['X0' = inc900, 'X1' = payment_api]).
answer(2, ['X0' = inc900, 'X1' = storefront]).
answer(2, ['X0' = inc900, 'X1' = mobile_app]).
answer(2, ['X0' = inc900, 'X1' = checkout_api]).
query(3, recommended_action(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = inc900, 'X1' = failover(primary_db, replica_db)]).
query(4, evidence_chain(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4,
       ['X0' = inc900,
        'X1' = [payment_api_db_timeout, primary_db_unhealthy, primary_db_disk_100_percent, auth_service_healthy, replica_db_healthy]]).
