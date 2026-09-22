% Prolog result format 4
query(1, type(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = msg1, 'X1' = local_observation]).
answer(1, ['X0' = probe7, 'X1' = temperature_probe]).
answer(1, ['X0' = msg1, 'X1' = sosa_observation]).
answer(1, ['X0' = probe7, 'X1' = sosa_sensor]).
query(2, target_fact(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(2, complete, 5).
answer(2, ['X0' = msg1, 'X1' = sosa_madeBySensor, 'X2' = probe7]).
answer(2, ['X0' = msg1, 'X1' = sosa_resultTime, 'X2' = "2026-06-17T12:34:56Z"]).
answer(2, ['X0' = msg1, 'X1' = sosa_hasSimpleResult, 'X2' = 18.6]).
answer(2, ['X0' = msg1, 'X1' = fpv_hasFlowStep, 'X2' = ingest_step]).
answer(2, ['X0' = msg1, 'X1' = sosa_hasFeatureOfInterest, 'X2' = platform_b]).
query(3, runtime_rule(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 5).
answer(3, ['X0' = observed_by, 'X1' = copy_to_target]).
answer(3, ['X0' = observed_at, 'X1' = copy_to_target]).
answer(3, ['X0' = temperature_celsius, 'X1' = copy_to_target]).
answer(3, ['X0' = in_flow, 'X1' = copy_to_target]).
answer(3, ['X0' = observed_feature, 'X1' = copy_to_target]).
query(4, target_predicate(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 5).
answer(4, ['X0' = observed_by, 'X1' = sosa_madeBySensor]).
answer(4, ['X0' = observed_at, 'X1' = sosa_resultTime]).
answer(4, ['X0' = temperature_celsius, 'X1' = sosa_hasSimpleResult]).
answer(4, ['X0' = in_flow, 'X1' = fpv_hasFlowStep]).
answer(4, ['X0' = observed_feature, 'X1' = sosa_hasFeatureOfInterest]).
query(5, flow_emits(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5, ['X0' = ingest_step, 'X1' = msg1]).
query(6, trusted_by(_0, _1), ['X0' = _0, 'X1' = _1]).
result(6, complete, 1).
answer(6, ['X0' = ingest_step, 'X1' = probe7]).
