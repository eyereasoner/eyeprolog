% Prolog result format 4
query(1, rh(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 3).
answer(1, ['X0' = scope, 'X1' = finite_catalog_only]).
answer(1, ['X0' = caveat, 'X1' = "finite catalogue evidence only; this is not a proof of RH"]).
answer(1, ['X0' = status, 'X1' = no_counterexample_in_catalog]).
query(2, zero_check(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(2, complete, 9).
answer(2, ['X0' = z1, 'X1' = real_part, 'X2' = 0.5]).
answer(2, ['X0' = z2, 'X1' = real_part, 'X2' = 0.5]).
answer(2, ['X0' = z3, 'X1' = real_part, 'X2' = 0.5]).
answer(2, ['X0' = z1, 'X1' = imaginary_part, 'X2' = 14.134725]).
answer(2, ['X0' = z2, 'X1' = imaginary_part, 'X2' = 21.02204]).
answer(2, ['X0' = z3, 'X1' = imaginary_part, 'X2' = 25.010858]).
answer(2, ['X0' = z1, 'X1' = classification, 'X2' = on_critical_line]).
answer(2, ['X0' = z2, 'X1' = classification, 'X2' = on_critical_line]).
answer(2, ['X0' = z3, 'X1' = classification, 'X2' = on_critical_line]).
