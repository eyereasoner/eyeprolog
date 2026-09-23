% Graphic atoms that are not absolute IRIs remain graphic atoms.
%% ?- answer(X0).

operator(<=>).
answer(Op) :- operator(Op).
