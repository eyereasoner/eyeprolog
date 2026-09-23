% Reference 9.7: nth0/3 can bind the index for a known list element.
answer(index, I) :- nth0(I, [a, b, c], b).
%% ?- answer(X0, X1).

