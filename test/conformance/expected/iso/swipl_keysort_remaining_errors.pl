% Prolog result format 4
query(1, keysort_remaining_errors(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(1, complete, 1).
answer(1,
       ['X0' = instantiation_error,
        'X1' = type_error(list, [a - b, b - b | a]),
        'X2' = instantiation_error]).
