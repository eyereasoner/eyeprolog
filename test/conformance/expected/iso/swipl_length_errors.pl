% Prolog result format 4
query(1, length_errors(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(1, complete, 1).
answer(1,
       ['X0' = domain_error(not_less_than_zero, -2),
        'X1' = type_error(integer, a),
        'X2' = type_error(integer, 0.1)]).
