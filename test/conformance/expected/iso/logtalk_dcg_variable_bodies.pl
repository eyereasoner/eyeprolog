phrase(delegate("ab"), "ab").
phrase(surrounded([center]), [left, center, right]).
phrase(body_or_fallback([chosen]), [chosen]).
phrase(body_or_fallback([chosen]), [fallback]).
