value(sum, 3.75).
value(difference, 6.875).
value(product, 10.0).
value(quotient, 3.75).
value(sqrtByPower, 3.0).
value(mathSum, 1.0).
value(mathProduct, 3.0).
value(comfortable, true).
than(warmer, targetC).

clause(1, sample(roomC, 21.5), true).
clause(2, sample(targetC, 19.25), true).
clause(3, value(sum, var('X')), var('X') is 1.5 + 2.25).
clause(4, value(difference, var('X')), var('X') is 10.0 - 3.125).
clause(5, value(product, var('X')), var('X') is 2.5 * 4.0).
clause(6, value(quotient, var('X')), var('X') is 7.5 / 2).
clause(7, value(sqrtByPower, var('X')), var('X') is 9.0 ** 0.5).
clause(8, value(mathSum, var('X')), var('X') is 0.125 + 0.875).
clause(9, value(mathProduct, var('X')), var('X') is 6.0 * 0.5).
clause(10,
       than(warmer, targetC),
       (sample(roomC, var('R')), sample(targetC, var('T')), var('R') > var('T'))).
clause(11,
       value(comfortable, true),
       (sample(roomC, var('R')), var('R') >= 21.0, var('R') =< 22.0)).

step(value(sum, 3.75), rule(3), ['X' = 3.75], [3.75 is 1.5 + 2.25]).
step(3.75 is 1.5 + 2.25, builtin, [], []).
step(value(difference, 6.875), rule(4), ['X' = 6.875], [6.875 is 10.0 - 3.125]).
step(6.875 is 10.0 - 3.125, builtin, [], []).
step(value(product, 10.0), rule(5), ['X' = 10.0], [10.0 is 2.5 * 4.0]).
step(10.0 is 2.5 * 4.0, builtin, [], []).
step(value(quotient, 3.75), rule(6), ['X' = 3.75], [3.75 is 7.5 / 2]).
step(3.75 is 7.5 / 2, builtin, [], []).
step(value(sqrtByPower, 3.0), rule(7), ['X' = 3.0], [3.0 is 9.0 ** 0.5]).
step(3.0 is 9.0 ** 0.5, builtin, [], []).
step(value(mathSum, 1.0), rule(8), ['X' = 1.0], [1.0 is 0.125 + 0.875]).
step(1.0 is 0.125 + 0.875, builtin, [], []).
step(value(mathProduct, 3.0), rule(9), ['X' = 3.0], [3.0 is 6.0 * 0.5]).
step(3.0 is 6.0 * 0.5, builtin, [], []).
step(value(comfortable, true),
     rule(11),
     ['R' = 21.5],
     [sample(roomC, 21.5), 21.5 >= 21.0, 21.5 =< 22.0]).
step(sample(roomC, 21.5), fact(1), [], []).
step(21.5 >= 21.0, builtin, [], []).
step(21.5 =< 22.0, builtin, [], []).
step(than(warmer, targetC),
     rule(10),
     ['R' = 21.5, 'T' = 19.25],
     [sample(roomC, 21.5), sample(targetC, 19.25), 21.5 > 19.25]).
step(sample(targetC, 19.25), fact(2), [], []).
step(21.5 > 19.25, builtin, [], []).
