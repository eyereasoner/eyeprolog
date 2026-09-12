% Adapted from SWI-Prolog tests/library/test_ordsets.pl.
% See test/conformance/THIRD_PARTY.md.
:- use_module(library(ordsets)).

%% goal: ordsets_intersection_difference(X0, X1, X2, X3, X4)

ordsets_intersection_difference(R1, R2, R3, R4, R5) :-
    ord_intersection([], [], X1, Y1), R1 = X1 - Y1,
    ord_intersection([a, b, c], [b], X2, Y2), R2 = X2 - Y2,
    ord_intersection([a], [a, b, c], X3, Y3), R3 = X3 - Y3,
    ord_intersection([b], [a, b, c], X4, Y4), R4 = X4 - Y4,
    ord_intersection([c], [a, b, c], X5, Y5), R5 = X5 - Y5,
    !.
