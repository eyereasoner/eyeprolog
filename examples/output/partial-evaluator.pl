% Prolog result format 4
query(1, partialEvalAnswer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = residual(poly_y), 'X1' = add(mul(const(10), var(y)), const(13))]).
answer(1, ['X0' = residual(static_branch), 'X1' = const(11)]).
answer(1,
       ['X0' = residual(dynamic_branch), 'X1' = if(var(flag), const(11), mul(var(y), const(2)))]).
answer(1,
       ['X0' = note,
        'X1' = "static inputs are folded while dynamic variables remain as residual code"]).
