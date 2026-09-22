% Prolog result format 4
query(1, phrase_identity(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 6).
answer(1, ['X0' = empty_braces, 'X1' = [tail]]).
answer(1, ['X0' = true_goal, 'X1' = [tail]]).
answer(1, ['X0' = cut, 'X1' = [tail]]).
answer(1, ['X0' = terminals, 'X1' = "ab"]).
answer(1, ['X0' = suffix, 'X1' = "abb"]).
answer(1, ['X0' = committed_failures, 'X1' = preserved]).
