% Adapted from Trealla Prolog tests/issues/test0791.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: number_chars_syntax_error(X0)

number_chars_syntax_error(E) :-
    catch(number_chars(_, "1-2"), error(E, _), true).
