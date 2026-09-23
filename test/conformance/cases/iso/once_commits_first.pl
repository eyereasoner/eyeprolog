% Isolated ISO mode-table success case.
%% ?- answer.

choice(first).
choice(second).
answer :- once(choice(X)), X = first.
