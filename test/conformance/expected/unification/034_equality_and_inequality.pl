% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = eq_variable, 'X1' = pair(a, "bc")]).
answer(1, ['X0' = eq_nested, 'X1' = true]).
answer(1, ['X0' = neq_atoms, 'X1' = true]).
answer(1, ['X0' = neq_structures, 'X1' = true]).
