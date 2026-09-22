% Prolog result format 4
query(1, phrase(via_call(a), "a"), []).
result(1, complete, 1).
answer(1, []).
query(2, phrase(via_phrase, _0), ['X' = _0]).
result(2, complete, 1).
answer(2, ['X' = "xy"]).
query(3, phrase(look_ahead(a), "a", _0), ['R' = _0]).
result(3, complete, 1).
answer(3, ['R' = "a"]).
query(4, phrase(variable_body("z"), _0), ['X' = _0]).
result(4, complete, 1).
answer(4, ['X' = "z"]).
