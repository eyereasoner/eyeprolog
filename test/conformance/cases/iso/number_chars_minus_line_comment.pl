% ISO 13211-1 8.16.7/8.16.8 with 6.3.1 and token layout from 6.4.
%% ?- answer(X0, X1, X2, X3).

answer(CharZero, CharOne, CodeZero, CodeOne) :-
    number_chars(CharZero, "-%\n0"),
    number_chars(CharOne, "-% comment\n1"),
    number_codes(CodeZero, [45, 37, 10, 48]),
    number_codes(CodeOne, [45, 37, 32, 99, 111, 109, 109, 101, 110, 116, 10, 49]).
