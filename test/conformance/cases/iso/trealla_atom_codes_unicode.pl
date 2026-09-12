% Adapted from Trealla Prolog tests/tests/test0034.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: atom_codes_cjk(ok)

atom_codes_cjk(ok) :-
    atom_codes('一二三', [19968, 20108, 19977]).

%% goal: atom_codes_cjk_reverse(X0)

atom_codes_cjk_reverse(Atom) :-
    atom_codes(Atom, [19968, 20108, 19977]).
