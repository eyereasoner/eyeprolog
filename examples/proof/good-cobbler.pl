holds_result(test, holds_result(joe, good(cobbler))).

clause(1, assertedIs(joe, good(cobbler)), true).
clause(2,
       holds_result(test, holds_result(var('X'), good(var('Y')))),
       assertedIs(var('X'), good(var('Y')))).

step(holds_result(test, holds_result(joe, good(cobbler))),
     rule(2),
     ['X' = joe, 'Y' = cobbler],
     [assertedIs(joe, good(cobbler))]).
step(assertedIs(joe, good(cobbler)), fact(1), [], []).
