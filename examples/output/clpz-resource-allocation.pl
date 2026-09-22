% Prolog result format 4
query(1, clpz_example(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 3).
answer(1, ['X0' = allocation, 'X1' = plan([2, 3, 1], durations([3, 2, 7]), 12)]).
answer(1, ['X0' = allocation, 'X1' = plan([3, 1, 2], durations([4, 4, 2]), 10)]).
answer(1, ['X0' = domain, 'X1' = domain(2, 7, 4, 2..4 \/ 7)]).
