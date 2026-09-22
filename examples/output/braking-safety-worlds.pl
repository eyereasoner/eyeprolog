% Prolog result format 4
query(1, safeInWorld(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 10).
answer(1, ['X0' = city_dry, 'X1' = w0]).
answer(1, ['X0' = city_dry, 'X1' = w1]).
answer(1, ['X0' = city_dry, 'X1' = w2]).
answer(1, ['X0' = city_dry, 'X1' = w3]).
answer(1, ['X0' = highway_dry_short_gap, 'X1' = w1]).
answer(1, ['X0' = highway_dry_short_gap, 'X1' = w2]).
answer(1, ['X0' = city_wet, 'X1' = w0]).
answer(1, ['X0' = city_wet, 'X1' = w1]).
answer(1, ['X0' = city_wet, 'X1' = w2]).
answer(1, ['X0' = city_ice, 'X1' = w2]).
query(2, riskyInWorld(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 6).
answer(2, ['X0' = highway_dry_short_gap, 'X1' = w0]).
answer(2, ['X0' = highway_dry_short_gap, 'X1' = w3]).
answer(2, ['X0' = city_wet, 'X1' = w3]).
answer(2, ['X0' = city_ice, 'X1' = w0]).
answer(2, ['X0' = city_ice, 'X1' = w1]).
answer(2, ['X0' = city_ice, 'X1' = w3]).
query(3, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = braking_safety_worlds, 'X1' = expected_world_pattern]).
query(4, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4,
       ['X0' = braking_safety_worlds,
        'X1' = "simplified and naive worlds can be optimistic while the cautious world tightens the reference model"]).
