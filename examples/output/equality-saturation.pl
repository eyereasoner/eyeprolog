% Prolog result format 4
query(1, egraphAnswer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 5).
answer(1, ['X0' = start, 'X1' = add(mul(add(x, 0), 1), mul(2, add(1, 2)))]).
answer(1, ['X0' = best, 'X1' = add(x, 6)]).
answer(1, ['X0' = cost, 'X1' = 3]).
answer(1, ['X0' = candidate_count, 'X1' = 32]).
answer(1,
       ['X0' = note,
        'X1' = "bounded equality saturation extracts the cheapest term without a real e-graph"]).
