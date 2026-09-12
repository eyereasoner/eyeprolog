% Adapted from Scryer Prolog tests-pl/invalid_decl7.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: op_specifier_type_error(X0)

op_specifier_type_error(E) :-
    catch(op(10, 42, example), error(E, _), true).
