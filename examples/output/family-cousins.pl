% Prolog result format 4
query(1, branch(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 7).
answer(1, ['X0' = dave, 'X1' = b]).
answer(1, ['X0' = eve, 'X1' = b]).
answer(1, ['X0' = frank, 'X1' = c]).
answer(1, ['X0' = grace, 'X1' = c]).
answer(1, ['X0' = heidi, 'X1' = b]).
answer(1, ['X0' = ivan, 'X1' = b]).
answer(1, ['X0' = judy, 'X1' = c]).
query(2, generation(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 9).
answer(2, ['X0' = bob, 'X1' = 1]).
answer(2, ['X0' = carol, 'X1' = 1]).
answer(2, ['X0' = dave, 'X1' = 2]).
answer(2, ['X0' = eve, 'X1' = 2]).
answer(2, ['X0' = frank, 'X1' = 2]).
answer(2, ['X0' = grace, 'X1' = 2]).
answer(2, ['X0' = heidi, 'X1' = 3]).
answer(2, ['X0' = ivan, 'X1' = 3]).
answer(2, ['X0' = judy, 'X1' = 3]).
query(3, cousin(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 12).
answer(3, ['X0' = dave, 'X1' = frank]).
answer(3, ['X0' = dave, 'X1' = grace]).
answer(3, ['X0' = eve, 'X1' = frank]).
answer(3, ['X0' = eve, 'X1' = grace]).
answer(3, ['X0' = frank, 'X1' = dave]).
answer(3, ['X0' = frank, 'X1' = eve]).
answer(3, ['X0' = grace, 'X1' = dave]).
answer(3, ['X0' = grace, 'X1' = eve]).
answer(3, ['X0' = heidi, 'X1' = judy]).
answer(3, ['X0' = ivan, 'X1' = judy]).
answer(3, ['X0' = judy, 'X1' = heidi]).
answer(3, ['X0' = judy, 'X1' = ivan]).
