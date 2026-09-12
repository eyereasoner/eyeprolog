% Adapted from Scryer Prolog tests-pl/invalid_decl3.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: op_name_type_error(X0)

op_name_type_error(E) :-
    catch(op(5, xfx, example(a, b)), error(E, _), true).
