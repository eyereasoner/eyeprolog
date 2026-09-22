% Prolog result format 4
query(1, sameInverse(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(1, complete, 2).
answer(1, ['X0' = x, 'X1' = i, 'X2' = j]).
why(1, ['X0' = x, 'X1' = i, 'X2' = j], [sameInverse(x, i, j)]).
answer(1, ['X0' = x, 'X1' = j, 'X2' = i]).
why(1, ['X0' = x, 'X1' = j, 'X2' = i], [sameInverse(x, j, i)]).

clause(7, group_op(i, x, e), true).
clause(8, group_op(x, j, e), true).
clause(9, group_op(j, x, e), true).
clause(10, group_op(x, i, e), true).
clause(12, sameTerm(i, j), true).
clause(13, sameTerm(j, i), true).
clause(14, leftInverse(var('A'), var('B')), group_op(var('B'), var('A'), e)).
clause(15, rightInverse(var('A'), var('B')), group_op(var('A'), var('B'), e)).
clause(16,
       sameInverse(var('A'), var('B'), var('C')),
       (leftInverse(var('A'), var('B')),
        rightInverse(var('A'), var('C')),
        sameTerm(var('B'), var('C')),
        var('B') \= var('C'))).

step(sameInverse(x, i, j),
     rule(16),
     ['A' = x, 'B' = i, 'C' = j],
     [leftInverse(x, i), rightInverse(x, j), sameTerm(i, j), i \= j]).
step(leftInverse(x, i), rule(14), ['A' = x, 'B' = i], [group_op(i, x, e)]).
step(group_op(i, x, e), fact(7), [], []).
step(rightInverse(x, j), rule(15), ['A' = x, 'B' = j], [group_op(x, j, e)]).
step(group_op(x, j, e), fact(8), [], []).
step(sameTerm(i, j), fact(12), [], []).
step(i \= j, builtin, [], []).
step(sameInverse(x, j, i),
     rule(16),
     ['A' = x, 'B' = j, 'C' = i],
     [leftInverse(x, j), rightInverse(x, i), sameTerm(j, i), j \= i]).
step(leftInverse(x, j), rule(14), ['A' = x, 'B' = j], [group_op(j, x, e)]).
step(group_op(j, x, e), fact(9), [], []).
step(rightInverse(x, i), rule(15), ['A' = x, 'B' = i], [group_op(x, i, e)]).
step(group_op(x, i, e), fact(10), [], []).
step(sameTerm(j, i), fact(13), [], []).
step(j \= i, builtin, [], []).
