% Prolog result format 4
query(1, phrase(token(a), "a"), []).
result(1, complete, 1).
answer(1, []).
query(2, phrase(choice, _0), ['X' = _0]).
result(2, complete, 2).
answer(2, ['X' = "a"]).
answer(2, ['X' = "b"]).
query(3, phrase(guarded, _0), ['X' = _0]).
result(3, complete, 1).
answer(3, ['X' = "ab"]).
query(4, phrase(not_a, "b"), []).
result(4, complete, 1).
answer(4, []).
query(5, phrase(committed, _0), ['X' = _0]).
result(5, complete, 1).
answer(5, ['X' = "a"]).
