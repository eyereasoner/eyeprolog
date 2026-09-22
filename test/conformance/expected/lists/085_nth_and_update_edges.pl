% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 8).
answer(1, ['X0' = index_value, 'X1' = pair(0, red)]).
answer(1, ['X0' = index_value, 'X1' = pair(1, green)]).
answer(1, ['X0' = index_value, 'X1' = pair(2, blue)]).
answer(1, ['X0' = bound_index, 'X1' = green]).
answer(1, ['X0' = set_first, 'X1' = [blue, green]]).
answer(1, ['X0' = set_last, 'X1' = "abz"]).
answer(1, ['X0' = index_too_large_rejected, 'X1' = ok]).
answer(1, ['X0' = set_too_large_rejected, 'X1' = ok]).
