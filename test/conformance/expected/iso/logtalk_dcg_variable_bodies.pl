% Prolog result format 4
query(1, phrase(delegate("ab"), _0), ['Tokens' = _0]).
result(1, complete, 1).
answer(1, ['Tokens' = "ab"]).
query(2, phrase(surrounded([center]), _0), ['Tokens' = _0]).
result(2, complete, 1).
answer(2, ['Tokens' = [left, center, right]]).
query(3, phrase(body_or_fallback([chosen]), _0), ['Tokens' = _0]).
result(3, complete, 2).
answer(3, ['Tokens' = [chosen]]).
answer(3, ['Tokens' = [fallback]]).
