% Prolog result format 4
query(1, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = low_input, 'X1' = under_supplied]).
answer(1, ['X0' = balanced_loam, 'X1' = balanced]).
answer(1, ['X0' = sandy_high, 'X1' = over_supplied]).
answer(1, ['X0' = clay_surplus, 'X1' = over_supplied]).
query(2, availableN_kg_ha(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 4).
answer(2, ['X0' = low_input, 'X1' = 58.5]).
answer(2, ['X0' = balanced_loam, 'X1' = 110.0]).
answer(2, ['X0' = sandy_high, 'X1' = 117.0]).
answer(2, ['X0' = clay_surplus, 'X1' = 147.20000000000002]).
query(3, deficitN_kg_ha(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 4).
answer(3, ['X0' = low_input, 'X1' = 51.5]).
answer(3, ['X0' = balanced_loam, 'X1' = 0.0]).
answer(3, ['X0' = sandy_high, 'X1' = 0.0]).
answer(3, ['X0' = clay_surplus, 'X1' = 0.0]).
query(4, surplusN_kg_ha(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 4).
answer(4, ['X0' = sandy_high, 'X1' = 12.0]).
answer(4, ['X0' = clay_surplus, 'X1' = 27.200000000000017]).
answer(4, ['X0' = low_input, 'X1' = 0.0]).
answer(4, ['X0' = balanced_loam, 'X1' = 0.0]).
query(5, leachingIndex(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 4).
answer(5, ['X0' = sandy_high, 'X1' = 4.199999999999999]).
answer(5, ['X0' = clay_surplus, 'X1' = 2.1760000000000015]).
answer(5, ['X0' = low_input, 'X1' = 0.0]).
answer(5, ['X0' = balanced_loam, 'X1' = 0.0]).
query(6, highestLeachingRisk(_0, _1), ['X0' = _0, 'X1' = _1]).
result(6, complete, 1).
answer(6, ['X0' = field_nitrogen_balance, 'X1' = sandy_high]).
query(7, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(7, complete, 0).
