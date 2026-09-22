% Prolog result format 4
query(1, edge(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 9).
answer(1, ['X0' = "ba", 'X1' = 4]).
answer(1, ['X0' = "ca", 'X1' = 2]).
answer(1, ['X0' = "cb", 'X1' = 1]).
answer(1, ['X0' = "db", 'X1' = 5]).
answer(1, ['X0' = "dc", 'X1' = 8]).
answer(1, ['X0' = "ec", 'X1' = 10]).
answer(1, ['X0' = "ed", 'X1' = 2]).
answer(1, ['X0' = "fd", 'X1' = 6]).
answer(1, ['X0' = "fe", 'X1' = 3]).
query(2, path(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 7).
answer(2, ['X0' = "af", 'X1' = ["abdef", 14]]).
answer(2, ['X0' = "af", 'X1' = ["abdf", 15]]).
answer(2, ['X0' = "af", 'X1' = ["acdef", 15]]).
answer(2, ['X0' = "af", 'X1' = ["acdf", 16]]).
answer(2, ['X0' = "af", 'X1' = ["acef", 15]]).
answer(2, ['X0' = "af", 'X1' = ["acbdef", 13]]).
answer(2, ['X0' = "af", 'X1' = ["acbdf", 14]]).
