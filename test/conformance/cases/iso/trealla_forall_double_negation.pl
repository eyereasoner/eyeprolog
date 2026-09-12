% Adapted from Trealla Prolog tests/tests/test0010.pl, test0011.pl.
% See test/conformance/THIRD_PARTY.md.
:- dynamic(seen/2).

upto(N, X) :- N > 0, N1 is N - 1, upto(N1, X).
upto(N, X) :- N > 0, X = N.

%% goal: forall_via_double_negation(X0)

forall_via_double_negation(Pairs) :-
    \+ (upto(3, I), upto(I, J), \+ assertz(seen(I, J))),
    findall(I-J, retract(seen(I, J)), Pairs).
