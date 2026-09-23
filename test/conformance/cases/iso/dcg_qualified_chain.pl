% Qualified nonterminals retain module context through nested phrase//1 calls.
:- module(dcg_chain, [leaf//0, branch//0, wrapper//0, answer/1]).

leaf --> [x].
branch --> dcg_chain:leaf.
wrapper --> phrase(dcg_chain:branch).
answer(Tokens) :- phrase(wrapper, Tokens).

%% ?- dcg_chain:answer(Tokens).
%% ?- phrase(dcg_chain:wrapper, Tokens).
