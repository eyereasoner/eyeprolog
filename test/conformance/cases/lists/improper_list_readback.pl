% Improper lists preserve their tail in read-back.
%% ?- answer(X0).

seed([a, b | tail]).
answer(X) :- seed(X).
