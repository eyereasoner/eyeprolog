% Adapted from SWI-Prolog tests/library/test_lists.pl.
% See test/conformance/THIRD_PARTY.md.
:- use_module(library(lists)).

%% goal: lists_reverse_mode(X0)

% A trailing cut keeps this deterministic: nothing else stops the search
% for a second (nonexistent) solution once L's unique correct length is
% found, since nothing else bounds how long a next candidate open list
% could grow while still failing to match (see SWI's own "must be
% deterministic" comment on this test).
lists_reverse_mode(L) :-
    reverse(L, [a, b]), L == [b, a], !.
