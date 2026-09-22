% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 9).
answer(1, ['X0' = first, 'X1' = alpha]).
answer(1, ['X0' = last, 'X1' = beta]).
answer(1, ['X0' = take, 'X1' = [alpha, beta]]).
answer(1, ['X0' = drop, 'X1' = [gamma, beta]]).
answer(1, ['X0' = slice, 'X1' = [beta, gamma]]).
answer(1, ['X0' = sum, 'X1' = 6.5]).
answer(1, ['X0' = min, 'X1' = 1]).
answer(1, ['X0' = max, 'X1' = 3]).
answer(1, ['X0' = set, 'X1' = [beta, alpha, gamma]]).
