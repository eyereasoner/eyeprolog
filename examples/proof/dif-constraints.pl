% Prolog result format 4
query(1, allowed_pair(_0, _1), ['X' = _0, 'Y' = _1]).
result(1, complete, 1).
answer(1, ['X' = left, 'Y' = right]).
why(1, ['X' = left, 'Y' = right], [allowed_pair(left, right)]).
query(2, specialization(_0, _1), ['X' = _0, 'Y' = _1]).
result(2, complete, 1).
answer(2, ['X' = 1, 'Y' = 1]).
why(2, ['X' = 1, 'Y' = 1], [specialization(1, 1)]).

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
