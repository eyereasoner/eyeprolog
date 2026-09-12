% Adapted from Trealla Prolog tests/tests/test0021.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: retract_backtracking(ok)

:- dynamic(x24/1).

populate_x24 :-
    assertz(x24(0)),
    assertz(x24(1)),
    assertz(x24(2)),
    assertz(x24(3)).

retract_backtracking(ok) :-
    populate_x24,
    ( retract(x24(X)), write(X), nl, fail ; true ).
