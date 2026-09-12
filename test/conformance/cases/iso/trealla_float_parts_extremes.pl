% Adapted from Trealla Prolog tests/tests/test0117.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: float_parts_1e30(X0, X1)

float_parts_1e30(I, F) :-
    I is float_integer_part(1.0e30),
    F is float_fractional_part(1.0e30).

%% goal: float_parts_neg1e30(X0, X1)

float_parts_neg1e30(I, F) :-
    I is float_integer_part(-1.0e30),
    F is float_fractional_part(-1.0e30).

%% goal: float_parts_1e300(X0, X1)

float_parts_1e300(I, F) :-
    I is float_integer_part(1.0e300),
    F is float_fractional_part(1.0e300).

%% goal: float_parts_zero(X0, X1)

float_parts_zero(I, F) :-
    I is float_integer_part(0.0),
    F is float_fractional_part(0.0).
