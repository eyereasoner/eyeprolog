% Qualified unknown nonterminals report their expanded predicate indicator.
:- module(dcg_missing, [invoke//0]).
invoke --> dcg_missing:absent.
%% ?- phrase(dcg_missing:invoke, []).
