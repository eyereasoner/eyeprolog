% Query strings and fragments are part of the IRI atom text.
%% ?- answer(X0).

seed('<https://example.org/path?x=1#frag>').
answer(X) :- seed(X).
