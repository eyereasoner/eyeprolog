% Adapted from Trealla Prolog tests/issues/test0114.pl.
% See test/conformance/THIRD_PARTY.md.
%% goal: sort_duplicates_and_empty(X0, X1, X2)

sort_duplicates_and_empty(Empty, Sorted, SortedCodes) :-
    sort([], Empty),
    sort("", Empty),
    sort([c, b, a, ' ', a, b, c], Sorted),
    sort("cba abc", SortedCodes).
