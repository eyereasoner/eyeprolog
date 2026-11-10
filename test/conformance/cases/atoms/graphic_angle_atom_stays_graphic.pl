% A sequence of graphic characters is an ordinary atom.
%% ?- answer(X0).

operator(<=>).
answer(Op) :- operator(Op).
