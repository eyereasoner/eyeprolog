phrase(tokens("abc"), "abc").
phrase(tokens("xy"), "xy").
phrase(tokens("ab"), [a, b, rest], [rest]).
