sameGreatestLowerBound(a, b, g1, g2).
sameGreatestLowerBound(a, b, g2, g1).

clause(1, glbOf(g1, a, b), true).
clause(2, glbOf(g2, a, b), true).
clause(3, lowerBoundOf(var('M'), var('A'), var('B')), glbOf(var('M'), var('A'), var('B'))).
clause(4,
       leq(var('L'), var('M')),
       (glbOf(var('M'), var('A'), var('B')), lowerBoundOf(var('L'), var('A'), var('B')))).
clause(5, sameTerm(var('M'), var('N')), (leq(var('M'), var('N')), leq(var('N'), var('M')))).
clause(6,
       sameGreatestLowerBound(var('A'), var('B'), var('M'), var('N')),
       (glbOf(var('M'), var('A'), var('B')),
        glbOf(var('N'), var('A'), var('B')),
        sameTerm(var('M'), var('N')),
        var('M') \= var('N'))).

step(sameGreatestLowerBound(a, b, g1, g2),
     rule(6),
     ['A' = a, 'B' = b, 'M' = g1, 'N' = g2],
     [glbOf(g1, a, b), glbOf(g2, a, b), sameTerm(g1, g2), g1 \= g2]).
step(glbOf(g1, a, b), fact(1), [], []).
step(glbOf(g2, a, b), fact(2), [], []).
step(sameTerm(g1, g2), rule(5), ['M' = g1, 'N' = g2], [leq(g1, g2), leq(g2, g1)]).
step(leq(g1, g2),
     rule(4),
     ['L' = g1, 'M' = g2, 'A' = a, 'B' = b],
     [glbOf(g2, a, b), lowerBoundOf(g1, a, b)]).
step(lowerBoundOf(g1, a, b), rule(3), ['M' = g1, 'A' = a, 'B' = b], [glbOf(g1, a, b)]).
step(leq(g2, g1),
     rule(4),
     ['L' = g2, 'M' = g1, 'A' = a, 'B' = b],
     [glbOf(g1, a, b), lowerBoundOf(g2, a, b)]).
step(lowerBoundOf(g2, a, b), rule(3), ['M' = g2, 'A' = a, 'B' = b], [glbOf(g2, a, b)]).
step(g1 \= g2, builtin, [], []).
step(sameGreatestLowerBound(a, b, g2, g1),
     rule(6),
     ['A' = a, 'B' = b, 'M' = g2, 'N' = g1],
     [glbOf(g2, a, b), glbOf(g1, a, b), sameTerm(g2, g1), g2 \= g1]).
step(sameTerm(g2, g1), rule(5), ['M' = g2, 'N' = g1], [leq(g2, g1), leq(g1, g2)]).
step(g2 \= g1, builtin, [], []).
