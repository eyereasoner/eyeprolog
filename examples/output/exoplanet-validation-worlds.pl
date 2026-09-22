% Prolog result format 4
query(1, ppvPlanetGivenDetection(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = rare_wide_orbit, 'X1' = 0.09016393442622944]).
answer(1, ['X0' = mstar_short_period, 'X1' = 0.9611650485436893]).
answer(1, ['X0' = common_hot_neptune_good, 'X1' = 0.9134615384615384]).
answer(1, ['X0' = common_hot_neptune_low_spec, 'X1' = 0.76]).
query(2, confirmsInWorld(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 9).
answer(2, ['X0' = mstar_short_period, 'X1' = w0]).
answer(2, ['X0' = common_hot_neptune_good, 'X1' = w0]).
answer(2, ['X0' = rare_wide_orbit, 'X1' = w1]).
answer(2, ['X0' = mstar_short_period, 'X1' = w1]).
answer(2, ['X0' = common_hot_neptune_good, 'X1' = w1]).
answer(2, ['X0' = common_hot_neptune_low_spec, 'X1' = w1]).
answer(2, ['X0' = mstar_short_period, 'X1' = w2]).
answer(2, ['X0' = common_hot_neptune_good, 'X1' = w2]).
answer(2, ['X0' = mstar_short_period, 'X1' = w3]).
query(3, rejectsInWorld(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 7).
answer(3, ['X0' = rare_wide_orbit, 'X1' = w0]).
answer(3, ['X0' = common_hot_neptune_low_spec, 'X1' = w0]).
answer(3, ['X0' = rare_wide_orbit, 'X1' = w2]).
answer(3, ['X0' = common_hot_neptune_low_spec, 'X1' = w2]).
answer(3, ['X0' = rare_wide_orbit, 'X1' = w3]).
answer(3, ['X0' = common_hot_neptune_good, 'X1' = w3]).
answer(3, ['X0' = common_hot_neptune_low_spec, 'X1' = w3]).
query(4, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = exoplanet_validation_worlds, 'X1' = expected_world_pattern]).
query(5, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5,
       ['X0' = exoplanet_validation_worlds,
        'X1' = "Bayesian worlds account for occurrence and false positives while the naive world trusts sensitivity alone"]).
