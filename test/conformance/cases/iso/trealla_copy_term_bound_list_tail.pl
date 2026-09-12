% Adapted from Trealla Prolog tests/tests/test0070.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: copy_term_bound_list_tail(X0)

copy_term_bound_list_tail(T2) :-
    L = [aa, bb, cc], L = [_ | T], copy_term(T, T2).
