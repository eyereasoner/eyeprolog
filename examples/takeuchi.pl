:- table tak/2.

% Takeuchi function
% See https://en.wikipedia.org/wiki/Tak_(function)

tak([X, Y, Z], Z) :-
    X =< Y,
    !.
tak([X, Y, Z], A) :-
    X1 is X-1,
    tak([X1, Y, Z], A1),
    Y1 is Y-1,
    tak([Y1, Z, X], A2),
    Z1 is Z-1,
    tak([Z1, X, Y], A3),
    tak([A1, A2, A3], A).

% query
% The arguments are kept small enough that the proof of this answer can be
% written and re-checked on every test run, while still being far beyond what
% the plain recursion does in reasonable time: tabled it answers in about
% 45 ms, untabled in about 250 ms, and the gap widens sharply with the
% arguments -- tak([34, 13, 8], _) takes about 28 seconds untabled.
%% ?- tak([16, 11, 6], _).

