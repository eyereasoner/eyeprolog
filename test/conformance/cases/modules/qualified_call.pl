:- module(colors, [tone/1, answer/1]).

tone(blue).
answer(X) :- tone(X).

%% ?- colors:answer(X).
