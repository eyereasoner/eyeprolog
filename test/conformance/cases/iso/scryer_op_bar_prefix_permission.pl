% Adapted from Scryer Prolog tests-pl/invalid_decl15.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: op_bar_prefix_permission(X0)

op_bar_prefix_permission(E) :-
    catch(op(1150, fx, '|'), error(E, _), true).
