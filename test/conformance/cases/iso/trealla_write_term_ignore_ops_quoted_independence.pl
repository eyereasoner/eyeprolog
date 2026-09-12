% Adapted from Trealla Prolog tests/issues/test1137.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: write_term_ignore_ops_quoted_independence(ok)

write_term_ignore_ops_quoted_independence(ok) :-
    write_term('a b', [ignore_ops(true)]), nl,
    write_term('a b', [ignore_ops(true), quoted(true)]), nl,
    write_term(1 + 2 * 3, [ignore_ops(true)]), nl,
    write_term([a, b | c], [ignore_ops(true)]), nl,
    write_term({a}, [ignore_ops(true)]), nl.
