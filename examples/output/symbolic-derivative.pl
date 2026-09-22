% Prolog result format 4
query(1, derivative_result(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = square, 'X1' = add(mul(const(1), var(x)), mul(var(x), const(1)))]).
answer(1, ['X0' = linear_plus_const, 'X1' = add(const(1), const(0))]).
answer(1,
       ['X0' = product,
        'X1' = add(mul(add(const(1), const(0)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))), mul(add(var(x), const(1)), add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0))))))]).
answer(1, ['X0' = nested_log, 'X1' = divide(divide(const(1), var(x)), log(var(x)))]).
