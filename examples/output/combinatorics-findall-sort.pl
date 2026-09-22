% Prolog result format 4
query(1, combinations(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1,
       ['X0' = combinations_5_choose_3,
        'X1' = [[1, 2, 3], [1, 2, 4], [1, 2, 5], [1, 3, 4], [1, 3, 5], [1, 4, 5], [2, 3, 4], [2, 3, 5], [2, 4, 5], [3, 4, 5]]]).
query(2, count(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = combinations_5_choose_3, 'X1' = 10]).
query(3, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 0).
