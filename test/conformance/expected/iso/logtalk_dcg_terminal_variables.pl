% Prolog result format 4
query(1, phrase(capture(_0), [term(a)]), ['X' = _0]).
result(1, complete, 1).
answer(1, ['X' = term(a)]).
query(2, phrase(capture(value), _0), ['Tokens' = _0]).
result(2, complete, 1).
answer(2, ['Tokens' = [value]]).
query(3, phrase(duplicate(same), _0), ['Tokens' = _0]).
result(3, complete, 1).
answer(3, ['Tokens' = [same, same]]).
