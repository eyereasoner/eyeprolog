derivative_result(square, add(mul(const(1), var(x)), mul(var(x), const(1)))).
derivative_result(linear_plus_const, add(const(1), const(0))).
derivative_result(product, add(mul(add(const(1), const(0)), mul(add(pow(var(x), 2), const(2)), add(pow(var(x), 3), const(3)))), mul(add(var(x), const(1)), add(mul(add(mul(mul(const(2), pow(var(x), 1)), const(1)), const(0)), add(pow(var(x), 3), const(3))), mul(add(pow(var(x), 2), const(2)), add(mul(mul(const(3), pow(var(x), 2)), const(1)), const(0))))))).
derivative_result(nested_log, divide(divide(const(1), var(x)), log(var(x)))).
