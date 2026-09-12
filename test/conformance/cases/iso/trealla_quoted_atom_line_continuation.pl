% Adapted from Trealla Prolog tests/tests/test0039.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: quoted_atom_line_continuation(ok)

quoted_atom_line_continuation(ok) :-
    write('foo\
bar'), nl.
