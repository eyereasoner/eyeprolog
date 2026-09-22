% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 6).
answer(1, ['X0' = once_choice, 'X1' = a]).
answer(1, ['X0' = nested_once, 'X1' = ok]).
answer(1, ['X0' = negated_missing, 'X1' = ok]).
answer(1, ['X0' = negated_existing_rejected, 'X1' = ok]).
answer(1, ['X0' = all_allowed, 'X1' = ok]).
answer(1, ['X0' = not_all_allowed_after_extra, 'X1' = ok]).
