% Adapted from SWI-Prolog tests/library/test_apply.pl (foldl empty tests).
% See test/conformance/THIRD_PARTY.md.
:- use_module(library(lists)).

false_foldl(_, _, _) :- fail.

%% goal: lists_foldl_empty_atom_starter(X0)

lists_foldl_empty_atom_starter(V) :-
    foldl(false_foldl, [], foo, V), V == foo, !.

%% goal: lists_foldl_empty_unbound_starter(ok)

lists_foldl_empty_unbound_starter(ok) :-
    foldl(false_foldl, [], VA, VB), VA == VB, !.
