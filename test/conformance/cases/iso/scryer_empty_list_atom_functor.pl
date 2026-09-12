% Adapted from Scryer Prolog tests-pl/iso-conformity-tests.pl, test
% 97. See test/conformance/THIRD_PARTY.md.

%% goal: empty_list_atom_functor(X)

empty_list_atom_functor(X) :-
    '[]'(1) = [ ](X).
