% Adapted from Trealla Prolog tests/issues/test1140.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: float_literal_representation_error(X0, X1, X2, X3)

float_literal_representation_error(MaxFloat, MinFloat, Underflow, BadSyntax) :-
    catch(number_chars(_, "9.9e999"), error(MaxFloat, _), true),
    catch(number_chars(_, "-9.9e999"), error(MinFloat, _), true),
    number_chars(Underflow, "9.9e-999"),
    catch(number_chars(_, "9.9ee"), error(BadSyntax, _), true).
