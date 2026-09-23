% Non-http absolute IRI atoms are ordinary atoms.
%% ?- answer(X0).

seed('<mailto:alice@example.org>').
answer(X) :- seed(X).
