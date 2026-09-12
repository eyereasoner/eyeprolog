% Adapted from Trealla Prolog tests/tests/test0046.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: append_concat(X0)

append_concat(L) :-
    append([a,b],[c,d],L).

%% goal: append_split(X0, X1)

append_split(L1, L2) :-
    append(L1, L2, [a,b,c,d]).
