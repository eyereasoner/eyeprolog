% Reference 5.5: comma terms remain data outside goal position.
record((name(alice, "Alice"), knows(alice, bob))).
answer(formula, F) :- record(F).
%% ?- answer(X0, X1).

