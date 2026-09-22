% Prolog result format 4
query(1, default_chars(_0), ['X0' = _0]).
result(1, complete, 1).
answer(1, ['X0' = "ab"]).
query(2, default_empty(_0), ['X0' = _0]).
result(2, complete, 1).
answer(2, ['X0' = []]).
query(3, default_shape(_0), ['X0' = _0]).
result(3, complete, 1).
answer(3, ['X0' = compound]).
query(4, atom_mode(_0), ['X0' = _0]).
result(4, complete, 1).
answer(4, ['X0' = ab]).
query(5, atom_functor(_0), ['X0' = _0]).
result(5, complete, 1).
answer(5, ['X0' = pair(a, b)]).
query(6, atom_shape(_0), ['X0' = _0]).
result(6, complete, 1).
answer(6, ['X0' = atomic]).
query(7, codes_mode(_0), ['X0' = _0]).
result(7, complete, 1).
answer(7, ['X0' = [97, 98]]).
query(8, codes_shape(_0), ['X0' = _0]).
result(8, complete, 1).
answer(8, ['X0' = compound]).
