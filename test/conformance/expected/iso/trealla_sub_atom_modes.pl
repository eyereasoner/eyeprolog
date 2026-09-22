% Prolog result format 4
query(1, sub_atom_all(_0, _1, _2, _3), ['X0' = _0, 'X1' = _1, 'X2' = _2, 'X3' = _3]).
result(1, complete, 10).
answer(1, ['X0' = 0, 'X1' = 0, 'X2' = 3, 'X3' = '']).
answer(1, ['X0' = 0, 'X1' = 1, 'X2' = 2, 'X3' = a]).
answer(1, ['X0' = 0, 'X1' = 2, 'X2' = 1, 'X3' = ab]).
answer(1, ['X0' = 0, 'X1' = 3, 'X2' = 0, 'X3' = abc]).
answer(1, ['X0' = 1, 'X1' = 0, 'X2' = 2, 'X3' = '']).
answer(1, ['X0' = 1, 'X1' = 1, 'X2' = 1, 'X3' = b]).
answer(1, ['X0' = 1, 'X1' = 2, 'X2' = 0, 'X3' = bc]).
answer(1, ['X0' = 2, 'X1' = 0, 'X2' = 1, 'X3' = '']).
answer(1, ['X0' = 2, 'X1' = 1, 'X2' = 0, 'X3' = c]).
answer(1, ['X0' = 3, 'X1' = 0, 'X2' = 0, 'X3' = '']).
query(2, sub_atom_length_2(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(2, complete, 2).
answer(2, ['X0' = 0, 'X1' = 1, 'X2' = ab]).
answer(2, ['X0' = 1, 'X1' = 0, 'X2' = bc]).
query(3, sub_atom_before_0_length_2(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = 1, 'X1' = ab]).
query(4, sub_atom_before_0(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(4, complete, 4).
answer(4, ['X0' = 0, 'X1' = 3, 'X2' = '']).
answer(4, ['X0' = 1, 'X1' = 2, 'X2' = a]).
answer(4, ['X0' = 2, 'X1' = 1, 'X2' = ab]).
answer(4, ['X0' = 3, 'X1' = 0, 'X2' = abc]).
query(5, sub_atom_after_0(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(5, complete, 4).
answer(5, ['X0' = 0, 'X1' = 3, 'X2' = abc]).
answer(5, ['X0' = 1, 'X1' = 2, 'X2' = bc]).
answer(5, ['X0' = 2, 'X1' = 1, 'X2' = c]).
answer(5, ['X0' = 3, 'X1' = 0, 'X2' = '']).
query(6, sub_atom_length_2_after_0(_0, _1), ['X0' = _0, 'X1' = _1]).
result(6, complete, 1).
answer(6, ['X0' = 1, 'X1' = bc]).
