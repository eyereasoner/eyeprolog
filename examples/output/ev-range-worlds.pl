% Prolog result format 4
query(1, safeInWorld(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 12).
answer(1, ['X0' = city_errand, 'X1' = w1]).
answer(1, ['X0' = city_errand, 'X1' = w2]).
answer(1, ['X0' = city_errand, 'X1' = w0]).
answer(1, ['X0' = city_errand, 'X1' = w3]).
answer(1, ['X0' = winter_highway, 'X1' = w1]).
answer(1, ['X0' = heavy_delivery, 'X1' = w1]).
answer(1, ['X0' = heavy_delivery, 'X1' = w2]).
answer(1, ['X0' = heavy_delivery, 'X1' = w0]).
answer(1, ['X0' = cold_commute, 'X1' = w1]).
answer(1, ['X0' = cold_commute, 'X1' = w2]).
answer(1, ['X0' = cold_commute, 'X1' = w0]).
answer(1, ['X0' = cold_commute, 'X1' = w3]).
query(2, riskyInWorld(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 4).
answer(2, ['X0' = winter_highway, 'X1' = w2]).
answer(2, ['X0' = winter_highway, 'X1' = w0]).
answer(2, ['X0' = winter_highway, 'X1' = w3]).
answer(2, ['X0' = heavy_delivery, 'X1' = w3]).
query(3, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 2).
answer(3,
       ['X0' = winter_highway,
        'X1' = "cold fast payload trip exceeds battery in physics-aware worlds"]).
answer(3,
       ['X0' = heavy_delivery,
        'X1' = "safety buffer turns a physics-safe delivery into a cautious risk"]).
query(4, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = ev_range_worlds, 'X1' = expected_world_pattern]).
