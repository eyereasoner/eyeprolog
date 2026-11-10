% A lone < is an ordinary graphic atom.
%% ?- answer(X0).

seed(<).
answer(X) :- seed(X).
