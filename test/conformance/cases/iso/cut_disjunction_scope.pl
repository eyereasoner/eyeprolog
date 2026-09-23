% ISO cut discards choices in its own invocation but not its caller.
inner(X) :- (X = a, ! ; X = b).
outer(X) :- (inner(X) ; X = c).

%% ?- outer(X).
