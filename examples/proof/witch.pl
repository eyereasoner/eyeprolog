% Prolog result format 4
query(1, witch(_0), ['X0' = _0]).
result(1, complete, 1).
answer(1, ['X0' = girl]).
why(1, ['X0' = girl], [witch(girl)]).
query(2, burns(_0), ['X0' = _0]).
result(2, complete, 2).
answer(2, ['X0' = duck]).
why(2, ['X0' = duck], [burns(duck)]).
answer(2, ['X0' = girl]).
why(2, ['X0' = girl], [burns(girl)]).
query(3, madeOfWood(_0), ['X0' = _0]).
result(3, complete, 2).
answer(3, ['X0' = duck]).
why(3, ['X0' = duck], [madeOfWood(duck)]).
answer(3, ['X0' = girl]).
why(3, ['X0' = girl], [madeOfWood(girl)]).
query(4, floats(_0), ['X0' = _0]).
result(4, complete, 1).
answer(4, ['X0' = girl]).
why(4, ['X0' = girl], [floats(girl)]).
query(5, holds_result(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5, ['X0' = witchExample, 'X1' = true]).
why(5, ['X0' = witchExample, 'X1' = true], [holds_result(witchExample, true)]).

clause(1, witch(var('X')), (burns(var('X')), woman(var('X')))).
clause(2, woman(girl), true).
clause(3, burns(var('X')), madeOfWood(var('X'))).
clause(4, madeOfWood(var('X')), floats(var('X'))).
clause(5, floats(duck), true).
clause(6, floats(var('Y')), (sameWeight(var('X'), var('Y')), floats(var('X')))).
clause(7, sameWeight(duck, girl), true).
clause(8, holds_result(witchExample, true), witch(girl)).

step(witch(girl), rule(1), ['X' = girl], [burns(girl), woman(girl)]).
step(burns(girl), rule(3), ['X' = girl], [madeOfWood(girl)]).
step(madeOfWood(girl), rule(4), ['X' = girl], [floats(girl)]).
step(floats(girl), rule(6), ['Y' = girl, 'X' = duck], [sameWeight(duck, girl), floats(duck)]).
step(sameWeight(duck, girl), fact(7), [], []).
step(floats(duck), fact(5), [], []).
step(woman(girl), fact(2), [], []).
step(burns(duck), rule(3), ['X' = duck], [madeOfWood(duck)]).
step(madeOfWood(duck), rule(4), ['X' = duck], [floats(duck)]).
step(holds_result(witchExample, true), rule(8), [], [witch(girl)]).
