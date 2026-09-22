% Prolog result format 4
query(1, blocker(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(1, complete, 3).
answer(1, ['X0' = depot_a, 'X1' = rapid50, 'X2' = insufficient_site_power(60, 80)]).
answer(1, ['X0' = depot_a, 'X1' = budget11, 'X2' = insufficient_charge_rate(11, 22)]).
answer(1, ['X0' = depot_a, 'X1' = legacy22, 'X2' = connector_mismatch(type2, ccs2)]).
query(2, compatible(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = depot_a, 'X1' = fleet22]).
query(3, recommendation(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = depot_a, 'X1' = fleet22]).
query(4, required_change(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(4, complete, 3).
answer(4, ['X0' = depot_a, 'X1' = rapid50, 'X2' = increase_site_power_to(80)]).
answer(4, ['X0' = depot_a, 'X1' = budget11, 'X2' = choose_charger_at_least_kw(22)]).
answer(4, ['X0' = depot_a, 'X1' = legacy22, 'X2' = use_connector(ccs2)]).
