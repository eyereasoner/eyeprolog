% Adapted from Scryer Prolog tests-pl/invalid_decl4.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: op_wrong_arity_existence_error(X0)

op_wrong_arity_existence_error(E) :-
    catch(op(5, xfx, example, extra), error(E, _), true).
