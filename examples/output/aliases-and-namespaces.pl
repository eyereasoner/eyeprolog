% Prolog result format 4
query(1, value(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = nativeMath, 'X1' = 1.0]).
query(2, ok(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 2).
answer(2, ['X0' = nativeCompare, 'X1' = true]).
answer(2, ['X0' = nativeString, 'X1' = true]).
query(3, tail(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = nativeList, 'X1' = "bc"]).
query(4, label(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = vocabularyExample, 'X1' = "vocabulary names are ordinary predicate names"]).
