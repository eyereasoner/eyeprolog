% Isolated ISO mode-table success case.
%% ?- answer.

answer :- functor(Term, made, 2), Term = made(left, right).
