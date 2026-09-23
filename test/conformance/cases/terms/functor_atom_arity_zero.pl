% Atoms are zero-arity terms for functor/3.
%% ?- answer(X0, X1).

answer(Name, Arity) :- functor(nil, Name, Arity).
