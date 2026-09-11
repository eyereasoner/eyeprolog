% Adapted from Trealla Prolog tests/tests/test0058.pl.
% See test/conformance/THIRD_PARTY.md.

%% goal: sub_atom_all(X0, X1, X2, X3)

sub_atom_all(B, L, A, S) :-
    sub_atom(abc, B, L, A, S).

%% goal: sub_atom_length_2(X0, X1, X2)

sub_atom_length_2(B, A, S) :-
    sub_atom(abc, B, 2, A, S).

%% goal: sub_atom_before_0_length_2(X0, X1)

sub_atom_before_0_length_2(A, S) :-
    sub_atom(abc, 0, 2, A, S).

%% goal: sub_atom_before_0(X0, X1, X2)

sub_atom_before_0(L, A, S) :-
    sub_atom(abc, 0, L, A, S).

%% goal: sub_atom_after_0(X0, X1, X2)

sub_atom_after_0(B, L, S) :-
    sub_atom(abc, B, L, 0, S).

%% goal: sub_atom_length_2_after_0(X0, X1)

sub_atom_length_2_after_0(B, S) :-
    sub_atom(abc, B, 2, 0, S).
