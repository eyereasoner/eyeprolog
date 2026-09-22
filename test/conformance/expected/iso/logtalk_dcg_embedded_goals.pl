% Prolog result format 4
query(1, phrase(checked(token), [token]), []).
result(1, complete, 1).
answer(1, []).
query(2, phrase(bind(_0), []), ['X' = _0]).
result(2, complete, 1).
answer(2, ['X' = bound]).
query(3, phrase(embedded_sequence(_0), _1), ['X' = _0, 'Tokens' = _1]).
result(3, complete, 1).
answer(3, ['X' = a, 'Tokens' = "a"]).
query(4, phrase(embedded_if, _0), ['Tokens' = _0]).
result(4, complete, 1).
answer(4, ['Tokens' = [yes]]).
