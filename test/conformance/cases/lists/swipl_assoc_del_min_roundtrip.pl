% Adapted from SWI-Prolog tests/library/test_assoc.pl (random_min, del_empty,
% del_no_member; a fixed key list stands in for SWI's random/1-seeded one).
% See test/conformance/THIRD_PARTY.md.
:- use_module(library(assoc)).

del_min_assoc_to_list(A, L) :- del_min_assoc_to_list(A, [], L).
del_min_assoc_to_list(t, L, L) :- !.
del_min_assoc_to_list(A, Rest, [Key - Val | Result]) :-
    del_min_assoc(A, Key, Val, A1) -> is_assoc(A1), del_min_assoc_to_list(A1, Rest, Result).

%% goal: assoc_del_min_roundtrip(X0)

assoc_del_min_roundtrip(L) :-
    list_to_assoc([5-e, 3-c, 8-h, 1-a, 4-d, 7-g, 2-b, 6-f, 10-j, 9-i, 11-k], A),
    del_min_assoc_to_list(A, L), !.

%% goal: assoc_del_min_empty_fails(ok)

assoc_del_min_empty_fails(ok) :-
    empty_assoc(A),
    \+ del_min_assoc(A, _, _, _), !.

%% goal: assoc_del_min_no_member_fails(ok)

assoc_del_min_no_member_fails(ok) :-
    list_to_assoc([1-a, 2-b, 4-c], A),
    \+ del_min_assoc(3, A, _, _), !.
