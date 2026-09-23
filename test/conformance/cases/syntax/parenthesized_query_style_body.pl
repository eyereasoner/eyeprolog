% Parentheses may group a body conjunction without changing meaning.
%% ?- answer(X0).

a(ok).
b(ok).
answer(X) :- (a(X), b(X)).
