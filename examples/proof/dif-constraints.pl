allowed_pair(left, right).
specialization(1, 1).

clause(1,
       allowed_pair(var('X'), var('Y')),
       (dif(var('X'), var('Y')), var('X') = left, var('Y') = right)).
clause(2,
       specialization(var('X'), var('Y')),
       (dif(var('X') - var('Y'), 1 - 2), var('X') = var('Y'), var('Y') = 1)).

step(allowed_pair(left, right),
     rule(1),
     ['X' = left, 'Y' = right],
     [dif(left, right), left = left, right = right]).
step(dif(left, right), builtin, [], []).
step(left = left, builtin, [], []).
step(right = right, builtin, [], []).
step(specialization(1, 1), rule(2), ['X' = 1, 'Y' = 1], [dif(1 - 1, 1 - 2), 1 = 1, 1 = 1]).
step(dif(1 - 1, 1 - 2), builtin, [], []).
step(1 = 1, builtin, [], []).
