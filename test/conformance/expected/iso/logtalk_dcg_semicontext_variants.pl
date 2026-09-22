% Prolog result format 4
query(1, phrase(push_two, [rest], _0), ['Rest' = _0]).
result(1, complete, 1).
answer(1, ['Rest' = [a, b, rest]]).
query(2, phrase(consume_then_push, [head, middle, rest], _0), ['Rest' = _0]).
result(2, complete, 1).
answer(2, ['Rest' = [tail, rest]]).
query(3, phrase(echo(x), [x, rest], _0), ['Rest' = _0]).
result(3, complete, 1).
answer(3, ['Rest' = [x, rest]]).
query(4, phrase(echo_pair(a, b), [a, b, rest], _0), ['Rest' = _0]).
result(4, complete, 1).
answer(4, ['Rest' = [a, b, rest]]).
