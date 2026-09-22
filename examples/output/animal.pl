% Prolog result format 4
query(1, type(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 2).
answer(1, ['X0' = joe, 'X1' = human]).
answer(1, ['X0' = joe, 'X1' = animal]).
query(2, subclassOf(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = human, 'X1' = animal]).
query(3, succeeds(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = animalExample, 'X1' = true]).
