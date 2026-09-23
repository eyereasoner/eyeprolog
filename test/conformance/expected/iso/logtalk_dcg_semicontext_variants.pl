phrase(push_two, [rest], [a, b, rest]).
phrase(consume_then_push, [head, middle, rest], [tail, rest]).
phrase(echo(x), [x, rest], [x, rest]).
phrase(echo_pair(a, b), [a, b, rest], [a, b, rest]).
