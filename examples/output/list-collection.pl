% Prolog result format 4
query(1, collectionLength(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = numbers, 'X1' = 3]).
query(2, collectionMember(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 3).
answer(2, ['X0' = numbers, 'X1' = 1]).
answer(2, ['X0' = numbers, 'X1' = 2]).
answer(2, ['X0' = numbers, 'X1' = 3]).
query(3, collectionAppend(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = letters, 'X1' = "abc"]).
query(4, head(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = letters, 'X1' = a]).
query(5, tail(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5, ['X0' = letters, 'X1' = "b"]).
