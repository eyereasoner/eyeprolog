phrase(empty, []).
phrase(one(value), [value]).
phrase(mixed, [[], {}, 3, 3.2, a(b)]).
phrase(letters, "abc").
phrase(letters_or_q, "abc").
phrase(letters_or_q, "q").
