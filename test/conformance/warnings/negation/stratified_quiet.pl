:- set_prolog_flag(unknown, fail).

% Stratified negation emits no portability warning.
%% ?- answer(X0).

candidate(a).
answer(ok) :- candidate(a), \+ blocked(a).
