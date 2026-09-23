% A lone graphic < remains a graphic atom, not an IRI opener.
%% ?- answer(X0).

seed(<).
answer(X) :- seed(X).
