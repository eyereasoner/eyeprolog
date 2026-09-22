% Prolog result format 4
query(1, isIndeedMoreInterestingThan(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = 5, 'X1' = 3]).
why(1, ['X0' = 5, 'X1' = 3], [isIndeedMoreInterestingThan(5, 3)]).

clause(1, moreInterestingThan(var('X'), var('Y')), var('X') > var('Y')).
clause(2, isIndeedMoreInterestingThan(5, 3), moreInterestingThan(5, 3)).

step(isIndeedMoreInterestingThan(5, 3), rule(2), [], [moreInterestingThan(5, 3)]).
step(moreInterestingThan(5, 3), rule(1), ['X' = 5, 'Y' = 3], [5 > 3]).
step(5 > 3, builtin, [], []).
