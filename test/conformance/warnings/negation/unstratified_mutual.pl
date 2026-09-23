% Warnings report unstratified negation without changing normal execution.
%% ?- answer(X0).

p(a) :- \+ q(a).
q(a) :- \+ p(a).
answer(ok).
