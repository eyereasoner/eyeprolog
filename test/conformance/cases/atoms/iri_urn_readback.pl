% URN IRI atoms read back in angle-bracket form.
%% ?- answer(X0).

seed('<urn:example:alpha>').
answer(X) :- seed(X).
