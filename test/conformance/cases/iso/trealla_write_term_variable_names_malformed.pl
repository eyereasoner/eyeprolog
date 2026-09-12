% Adapted from Trealla Prolog tests/issues/test1090.pl (first sub-case only;
% see test/conformance/THIRD_PARTY.md).
%% goal: write_term_variable_names_malformed(X0)

write_term_variable_names_malformed(E1) :-
    catch(write_term(_, [variable_names([a | non_list])]), error(E1, _), true).
