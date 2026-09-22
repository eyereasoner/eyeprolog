% Prolog result format 4
query(1, invalid_state(_0, _1), ['X' = _0, 'Reason' = _1]).
result(1, complete, 1).
answer(1, ['X' = stone, 'Reason' = conflicting_colors]).
query(2, status(_0, _1), ['X' = _0, 'Value' = _1]).
result(2, complete, 1).
answer(2, ['X' = stone, 'Value' = invalid(conflicting_colors)]).
