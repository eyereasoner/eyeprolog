% Prolog result format 4
query(1, database_roundtrip(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(1, complete, 1).
answer(1, ['X0' = [first, old, last], 'X1' = [first, last], 'X2' = item(selected)]).
query(2, retracted(_0), ['X0' = _0]).
result(2, complete, 2).
answer(2, ['X0' = a]).
answer(2, ['X0' = b]).
