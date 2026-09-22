% Prolog result format 4
query(1, name(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = a, 'X1' = "Alice"]).
query(2, log_nameOf(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = t, 'X1' = name(a, "Alice")]).
query(3, statedBy(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = t, 'X1' = bob]).
query(4, recorded(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = t, 'X1' = "2021-07-07"]).
