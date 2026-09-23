phrase_identity(empty_braces, [tail]).
phrase_identity(true_goal, [tail]).
phrase_identity(cut, [tail]).
phrase_identity(terminals, "ab").
phrase_identity(suffix, "abb").
phrase_identity(committed_failures, preserved).
