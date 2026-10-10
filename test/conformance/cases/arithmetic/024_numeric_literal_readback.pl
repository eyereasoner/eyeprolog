% Signed, decimal, and exponent numeric literals read back as their values (ISO 7.1.3, 7.10.5 c).
raw(negative_decimal, -3.5).
raw(positive_exp, 6.02e23).
raw(negative_exp, -1.0e-3).
answer(K, V) :- raw(K, V).
%% ?- answer(X0, X1).

