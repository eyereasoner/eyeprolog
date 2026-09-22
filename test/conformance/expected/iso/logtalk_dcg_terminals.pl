% Prolog result format 4
query(1, phrase(empty, []), []).
result(1, complete, 1).
answer(1, []).
query(2, phrase(one(value), [value]), []).
result(2, complete, 1).
answer(2, []).
query(3, phrase(mixed, [[], {}, 3, 3.2, a(b)]), []).
result(3, complete, 1).
answer(3, []).
query(4, phrase(letters, _0), ['X' = _0]).
result(4, complete, 1).
answer(4, ['X' = "abc"]).
query(5, phrase(letters_or_q, _0), ['X' = _0]).
result(5, complete, 2).
answer(5, ['X' = "abc"]).
answer(5, ['X' = "q"]).
