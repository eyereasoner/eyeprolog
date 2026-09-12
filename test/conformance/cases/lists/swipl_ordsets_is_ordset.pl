% Adapted from SWI-Prolog tests/library/test_ordsets.pl.
% See test/conformance/THIRD_PARTY.md.
:- use_module(library(ordsets)).

%% goal: ordsets_is_ordset_basic(ok)

ordsets_is_ordset_basic(ok) :-
    is_ordset([a, b, c]), !.

% Genuinely interesting: is_ordset/1 must check standard order of terms
% rather than being implemented as a cheap sort(L,L) check -- that would
% wrongly succeed here, since X and Y are indistinguishable unbound
% variables at the point [Y,X] is checked.
%% goal: ordsets_is_ordset_unbound_pair(ok)

unbound_pair(_).

ordsets_is_ordset_unbound_pair(ok) :-
    unbound_pair(T),
    T = a(X, Y),
    \+ is_ordset([Y, X]), !.
