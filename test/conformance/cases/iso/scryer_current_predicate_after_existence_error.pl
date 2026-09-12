% Adapted from Scryer Prolog tests-pl/issue3370_current_predicate_call.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: current_predicate_after_existence_error(X0)

current_predicate_after_existence_error(R) :-
    catch(call(foo_undefined, 1), _, true),
    ( current_predicate(foo_undefined/1) -> R = defined ; R = not_defined ).
