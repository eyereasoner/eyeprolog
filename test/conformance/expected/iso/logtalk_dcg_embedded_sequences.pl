% Prolog result format 4
query(1, phrase(three_checks(_0), _1), ['X' = _0, 'Tokens' = _1]).
result(1, complete, 1).
answer(1, ['X' = a, 'Tokens' = "a"]).
query(2, phrase(grouped_checks(_0), _1), ['X' = _0, 'Tokens' = _1]).
result(2, complete, 1).
answer(2, ['X' = b, 'Tokens' = "b"]).
query(3, phrase(embedded_choice, _0), ['Tokens' = _0]).
result(3, complete, 1).
answer(3, ['Tokens' = [ok]]).
