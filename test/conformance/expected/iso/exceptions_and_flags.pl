% Prolog result format 4
query(1, answer(_0, _1, _2, _3, _4), ['X0' = _0, 'X1' = _1, 'X2' = _2, 'X3' = _3, 'X4' = _4]).
result(1, complete, 2).
answer(1,
       ['X0' = 7,
        'X1' = red,
        'X2' = caught([predicate - atom_length / 2]),
        'X3' = first,
        'X4' = caught([])]).
answer(1,
       ['X0' = 7,
        'X1' = red,
        'X2' = caught([predicate - atom_length / 2]),
        'X3' = second,
        'X4' = caught([])]).
query(2, flags(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(2, complete, 1).
answer(2,
       ['X0' = off,
        'X1' = on,
        'X2' = [pair(bounded, false), pair(integer_rounding_function, toward_zero), pair(char_conversion, on), pair(debug, off), pair(max_arity, unbounded), pair(unknown, fail), pair(double_quotes, chars), pair(occurs_check, true), pair(default_procedure_access, private)]]).
