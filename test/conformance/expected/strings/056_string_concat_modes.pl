% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 5).
answer(1, ['X0' = concat, 'X1' = eyeprolog]).
answer(1, ['X0' = check, 'X1' = true]).
answer(1, ['X0' = prefix, 'X1' = eye]).
answer(1, ['X0' = suffix, 'X1' = prolog]).
answer(1, ['X0' = atom_inputs, 'X1' = eyeprolog]).
query(2, answer(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(2, complete, 4).
answer(2, ['X0' = split, 'X1' = '', 'X2' = eye]).
answer(2, ['X0' = split, 'X1' = e, 'X2' = ye]).
answer(2, ['X0' = split, 'X1' = ey, 'X2' = e]).
answer(2, ['X0' = split, 'X1' = eye, 'X2' = '']).
