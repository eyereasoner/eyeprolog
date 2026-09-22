% Prolog result format 4
query(1,
      answer(_0, _1, _2, _3, _4, _5, _6, _7),
      ['X0' = _0, 'X1' = _1, 'X2' = _2, 'X3' = _3, 'X4' = _4, 'X5' = _5, 'X6' = _6, 'X7' = _7]).
result(1, complete, 1).
answer(1,
       ['X0' = 17,
        'X1' = 'small world',
        'X2' = acada,
        'X3' = "ant",
        'X4' = [97, 110, 116],
        'X5' = c,
        'X6' = -25,
        'X7' = 4.2]).
query(2, split(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 3).
answer(2, ['X0' = '', 'X1' = ab]).
answer(2, ['X0' = a, 'X1' = b]).
answer(2, ['X0' = ab, 'X1' = '']).
query(3, occurrence(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(3, complete, 2).
answer(3, ['X0' = 0, 'X1' = 2, 'X2' = 9]).
answer(3, ['X0' = 7, 'X1' = 2, 'X2' = 2]).
