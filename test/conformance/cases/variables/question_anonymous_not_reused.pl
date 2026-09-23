% Each `_` occurrence is anonymous and independent.
%% ?- answer(X0).

pair(a, b).
pair(c, d).
answer(left(X)) :- pair(X, _).
answer(right(Y)) :- pair(_, Y).
