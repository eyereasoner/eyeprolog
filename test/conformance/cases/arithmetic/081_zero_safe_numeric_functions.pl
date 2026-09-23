% Reference 9.2: transcendental functions have stable exact outputs at simple inputs.
%% ?- answer(X0, X1).

answer(sin_zero, X) :- (X is sin(0)).
answer(cos_zero, X) :- (X is cos(0)).
answer(tan_zero, X) :- X is tan(0).
answer(exp_zero, X) :- (X is exp(0)).
answer(log_one, X) :- (X is log(1)).
answer(atan2_zero, X) :- X is atan2(0, 1).
answer(sqrt_one, X) :- (X is sqrt(1)).
