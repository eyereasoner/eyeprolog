% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = parts, 'X1' = [alpha, beta, gamma]]).
answer(1, ['X0' = pipe, 'X1' = 'alpha|beta|gamma']).
answer(1, ['X0' = first_upper, 'X1' = 'ALPHA']).
answer(1, ['X0' = last_lower, 'X1' = gamma]).
