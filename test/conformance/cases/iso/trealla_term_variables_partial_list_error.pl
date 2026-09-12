% Adapted from Trealla Prolog tests/tests/test0074.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: term_variables_partial_list_type_error(ok)

term_variables_partial_list_type_error(ok) :-
    catch(term_variables(t, [_, _|a]), error(type_error(list, [_, _|a]), _), true).
