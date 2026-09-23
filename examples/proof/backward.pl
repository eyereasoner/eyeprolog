isIndeedMoreInterestingThan(5, 3).

clause(1, moreInterestingThan(var('X'), var('Y')), var('X') > var('Y')).
clause(2, isIndeedMoreInterestingThan(5, 3), moreInterestingThan(5, 3)).

step(isIndeedMoreInterestingThan(5, 3), rule(2), [], [moreInterestingThan(5, 3)]).
step(moreInterestingThan(5, 3), rule(1), ['X' = 5, 'Y' = 3], [5 > 3]).
step(5 > 3, builtin, [], []).
