:- set_prolog_flag(unknown, fail).

%% ?- answer(X0).

p(a) :- \+ q(a).
q(a) :- \+ p(a).
