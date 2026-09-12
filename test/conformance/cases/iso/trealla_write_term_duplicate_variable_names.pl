% Adapted from Trealla Prolog tests/issues/test0225.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: write_term_last_variable_names_wins

write_term_last_variable_names_wins :-
    write_term(T, [variable_names(['Bad'=T]), variable_names(['Good'=T])]), nl.
