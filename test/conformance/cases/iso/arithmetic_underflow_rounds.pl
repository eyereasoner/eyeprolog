%% ?- arithmetic_underflow_rounds.

arithmetic_underflow_rounds :-
    A is 0.1*10** -999,
    B is exp(-1000.0),
    A =:= 0.0,
    B =:= 0.0.
