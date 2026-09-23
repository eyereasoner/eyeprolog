% Ambiguous grammars retain every distinct semantic result.
%% ?- ambiguity(X0).

reading(first) --> [token].
reading(second) --> [token].

ambiguity(Readings) :-
    findall(Reading, phrase(reading(Reading), [token]), Readings).
