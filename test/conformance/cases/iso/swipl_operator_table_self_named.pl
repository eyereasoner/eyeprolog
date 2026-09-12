% Adapted from SWI-Prolog tests/core_text/test_syntax.pl (iso_op_table_6).
% See test/conformance/THIRD_PARTY.md.
:- op(100, fy, fy).
:- op(100, xfy, xfy).
:- op(100, yfx, yfx).
:- op(100, yf, yf).

%% goal: operator_table_self_named(X0, X1, X2, X3, X4, X5)

operator_table_self_named(R1, R2, R3, R4, R5, R6) :-
    T1 = (fy fy 1), T1 == fy(fy(1)), R1 = T1,
    T2 = (1 xfy 2 xfy 3), T2 == xfy(1, xfy(2, 3)), R2 = T2,
    T3 = (1 xfy 2 yfx 3), T3 == xfy(1, yfx(2, 3)), R3 = T3,
    T4 = (fy 2 yf), T4 == fy(yf(2)), R4 = T4,
    T5 = (1 yf yf), T5 == yf(yf(1)), R5 = T5,
    T6 = (1 yfx 2 yfx 3), T6 == yfx(yfx(1, 2), 3), R6 = T6.
