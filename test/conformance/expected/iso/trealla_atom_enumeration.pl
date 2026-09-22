% Prolog result format 4
query(1, concat_split(_0, _1), ['Left' = _0, 'Right' = _1]).
result(1, complete, 7).
answer(1, ['Left' = '', 'Right' = abcdef]).
answer(1, ['Left' = a, 'Right' = bcdef]).
answer(1, ['Left' = ab, 'Right' = cdef]).
answer(1, ['Left' = abc, 'Right' = def]).
answer(1, ['Left' = abcd, 'Right' = ef]).
answer(1, ['Left' = abcde, 'Right' = f]).
answer(1, ['Left' = abcdef, 'Right' = '']).
query(2, sub_atom_match(_0, _1, _2), ['Before' = _0, 'Length' = _1, 'After' = _2]).
result(2, complete, 2).
answer(2, ['Before' = 1, 'Length' = 3, 'After' = 2]).
answer(2, ['Before' = 3, 'Length' = 3, 'After' = 0]).
