% Negation fails when its inner goal succeeds.
%% ?- answer(X0).

seen(a).
answer(ok) :- \+ seen(a).
