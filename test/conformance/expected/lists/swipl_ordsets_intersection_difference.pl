% Prolog result format 4
query(1,
      ordsets_intersection_difference(_0, _1, _2, _3, _4),
      ['X0' = _0, 'X1' = _1, 'X2' = _2, 'X3' = _3, 'X4' = _4]).
result(1, complete, 1).
answer(1,
       ['X0' = [] - [],
        'X1' = "b" - [],
        'X2' = "a" - "bc",
        'X3' = "b" - "ac",
        'X4' = "c" - "ab"]).
