% Prolog result format 4
query(1, missionaries_cannibals_answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 3).
answer(1,
       ['X0' = first_solution,
        'X1' = [state(3, 3, left), state(3, 1, right), state(3, 2, left), state(3, 0, right), state(3, 1, left), state(1, 1, right), state(2, 2, left), state(0, 2, right), state(0, 3, left), state(0, 1, right), state(1, 1, left), state(0, 0, right)]]).
answer(1, ['X0' = state_count, 'X1' = 10]).
answer(1, ['X0' = step_count, 'X1' = 11]).
