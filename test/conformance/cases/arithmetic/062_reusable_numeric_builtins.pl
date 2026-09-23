% Reference 9.1: reusable numeric functions compose with ISO control.
%% ?- answer(X0, X1).

answer(max, X) :- (17 >= 42 -> X = 17 ; X = 42).
answer(sqrt, X) :- (X is sqrt(81)).
answer(floor, X) :- (X is floor(3.9)).
answer(ceiling, X) :- (X is ceiling(3.1)).
answer(trunc, X) :- (X is truncate(-3.9)).
answer(exp, X) :- (X is exp(0)).
answer(tan, X) :- X is tan(0).
answer(atan2, X) :- X is atan2(0, -1).
