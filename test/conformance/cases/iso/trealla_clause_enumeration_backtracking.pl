% Adapted from Trealla Prolog tests/tests/test0019.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: clause_enumeration_backtracking(X0)

populate_x24c :-
    assertz(x24c(0)),
    assertz(x24c(1)),
    assertz(x24c(2)),
    assertz(x24c(3)).

clause_enumeration_backtracking(L) :-
    populate_x24c,
    findall(X - B, clause(x24c(X), B), L).
