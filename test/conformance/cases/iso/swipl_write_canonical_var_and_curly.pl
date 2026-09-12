% Adapted from SWI-Prolog tests/core_text/test_write.pl (write_canonical tests).
% See test/conformance/THIRD_PARTY.md.
%% goal: write_canonical_var_and_curly(ok)

write_canonical_var_and_curly(ok) :-
    write_canonical('$VAR'(1)), nl,
    write_canonical({a, b}), nl,
    write_canonical(x(B, B)), nl.
