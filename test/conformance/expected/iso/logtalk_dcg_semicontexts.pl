% Prolog result format 4
query(1, phrase(look_ahead(a), "a", _0), ['Rest' = _0]).
result(1, complete, 1).
answer(1, ['Rest' = "a"]).
query(2, phrase(replace, [foo, tail], _0), ['Rest' = _0]).
result(2, complete, 1).
answer(2, ['Rest' = [a, b, tail]]).
query(3, phrase(push_one(x), "x", _0), ['Rest' = _0]).
result(3, complete, 1).
answer(3, ['Rest' = "x"]).
query(4, phrase(push_pair(a, b), "ab", _0), ['Rest' = _0]).
result(4, complete, 1).
answer(4, ['Rest' = "ab"]).
