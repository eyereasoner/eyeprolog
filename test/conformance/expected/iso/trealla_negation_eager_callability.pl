% Prolog result format 4
query(1,
      negation_eager_callability(_0, _1, _2, _3),
      ['X0' = _0, 'X1' = _1, 'X2' = _2, 'X3' = _3]).
result(1, complete, 1).
answer(1,
       ['X0' = type_error(callable, (true ; 1)),
        'X1' = type_error(callable, (1 ; true)),
        'X2' = type_error(callable, (fail, 1)),
        'X3' = ok]).
