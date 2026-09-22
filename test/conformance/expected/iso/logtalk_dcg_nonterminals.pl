% Prolog result format 4
query(1, phrase(pair(a, b), _0), ['X' = _0]).
result(1, complete, 1).
answer(1, ['X' = "ab"]).
query(2, phrase(delegate("xy"), _0), ['X' = _0]).
result(2, complete, 1).
answer(2, ['X' = "xy"]).
query(3, phrase(via_call(z), _0), ['X' = _0]).
result(3, complete, 1).
answer(3, ['X' = "z"]).
