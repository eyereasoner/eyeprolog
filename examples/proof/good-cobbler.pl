% Prolog result format 4
query(1, holds_result(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = test, 'X1' = holds_result(joe, good(cobbler))]).
why(1,
    ['X0' = test, 'X1' = holds_result(joe, good(cobbler))],
    [holds_result(test, holds_result(joe, good(cobbler)))]).

clause(1, assertedIs(joe, good(cobbler)), true).
clause(2,
       holds_result(test, holds_result(var('X'), good(var('Y')))),
       assertedIs(var('X'), good(var('Y')))).

step(holds_result(test, holds_result(joe, good(cobbler))),
     rule(2),
     ['X' = joe, 'Y' = cobbler],
     [assertedIs(joe, good(cobbler))]).
step(assertedIs(joe, good(cobbler)), fact(1), [], []).
