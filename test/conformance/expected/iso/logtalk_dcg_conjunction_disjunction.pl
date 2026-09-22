% Prolog result format 4
query(1, phrase(sequence, _0), ['X' = _0]).
result(1, complete, 1).
answer(1, ['X' = "ab"]).
query(2, phrase(optional_b, _0), ['X' = _0]).
result(2, complete, 2).
answer(2, ['X' = "ab"]).
answer(2, ['X' = "a"]).
query(3, phrase(bar_choice, _0), ['X' = _0]).
result(3, complete, 3).
answer(3, ['X' = "x"]).
answer(3, ['X' = "y"]).
answer(3, ['X' = "z"]).
query(4, phrase(nested_choice, _0), ['X' = _0]).
result(4, complete, 2).
answer(4, ['X' = "ab"]).
answer(4, ['X' = "ac"]).
