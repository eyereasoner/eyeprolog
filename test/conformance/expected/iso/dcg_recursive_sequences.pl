% Prolog result format 4
query(1, phrase(tokens("abc"), _0), ['Generated' = _0]).
result(1, complete, 1).
answer(1, ['Generated' = "abc"]).
query(2, phrase(tokens(_0), "xy"), ['Parsed' = _0]).
result(2, complete, 1).
answer(2, ['Parsed' = "xy"]).
query(3, phrase(tokens("ab"), [a, b, rest], _0), ['Rest' = _0]).
result(3, complete, 1).
answer(3, ['Rest' = [rest]]).
