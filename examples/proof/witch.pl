witch(girl).
burns(duck).
burns(girl).
madeOfWood(duck).
madeOfWood(girl).
floats(girl).
holds_result(witchExample, true).

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
