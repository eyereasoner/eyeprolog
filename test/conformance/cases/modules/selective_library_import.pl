:- use_module(library(lists), [member/2]).

answer(X) :- member(X, [module]).

%% ?- answer(X).
