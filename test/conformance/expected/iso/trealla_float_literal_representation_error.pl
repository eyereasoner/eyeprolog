% Prolog result format 4
query(1,
      float_literal_representation_error(_0, _1, _2, _3),
      ['X0' = _0, 'X1' = _1, 'X2' = _2, 'X3' = _3]).
result(1, complete, 1).
answer(1,
       ['X0' = representation_error(max_float),
        'X1' = representation_error(min_float),
        'X2' = 0.0,
        'X3' = syntax_error(number)]).
