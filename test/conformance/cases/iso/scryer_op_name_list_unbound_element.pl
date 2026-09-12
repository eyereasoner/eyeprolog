% Adapted from Scryer Prolog tests-pl/invalid_decl11.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: op_name_list_unbound_element(X0)

op_name_list_unbound_element(E) :-
    catch(op(10, xf, [example, _]), error(E, _), true).
