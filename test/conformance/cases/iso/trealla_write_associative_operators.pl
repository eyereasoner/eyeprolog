% Adapted from Trealla Prolog tests/tests/test0035.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: write_associative_operators(ok)

write_associative_operators(ok) :-
    write((1 / 2 / 3)), nl,
    write((a, b, c)), nl,
    write({a, b, c}), nl,
    write(((1 / 2) / 3)), nl,
    write((a, (b, c))), nl,
    write({a, (b, c)}), nl.
