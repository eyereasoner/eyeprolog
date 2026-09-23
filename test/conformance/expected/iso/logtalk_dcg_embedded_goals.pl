phrase(checked(token), [token]).
phrase(bind(bound), []).
phrase(embedded_sequence(a), "a").
phrase(embedded_if, [yes]).
