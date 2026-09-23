% Corrigendum 2 arithmetic additions and distinct // versus div rounding.
%% ?- corrigenda_arithmetic(Div, Trunc, Max, Min, Power, Asin, Acos, Atan2, Tan, Pi, Xor).

corrigenda_arithmetic(Div, Trunc, Max, Min, Power, Asin, Acos, Atan2, Tan, Pi, Xor) :-
    Div is -7 div 3,
    Trunc is -7 // 3,
    Max is max(2, 3.0),
    Min is min(2.0, 3),
    Power is 3^3,
    Asin is asin(0),
    Acos is acos(1),
    Atan2 is atan2(1, 0),
    Tan is tan(0),
    Pi is pi,
    Xor is xor(10, 12).
