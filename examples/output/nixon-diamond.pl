% Prolog result format 4
query(1, defaultSupports(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 2).
answer(1, ['X0' = nixon, 'X1' = pacifist]).
answer(1, ['X0' = nixon, 'X1' = hawk]).
query(2, conflict(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 2).
answer(2, ['X0' = nixon, 'X1' = conflict(pacifist, hawk)]).
answer(2, ['X0' = nixon, 'X1' = conflict(hawk, pacifist)]).
query(3, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = nixon, 'X1' = conflicted_default_case]).
