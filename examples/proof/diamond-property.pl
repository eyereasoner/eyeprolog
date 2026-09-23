holdsFor(diamondProperty, r).
holdsFor(diamondProperty, re).
commonSuccessor(diamondProperty, d).
preservedUnderReflexiveClosure(diamondProperty, true).

clause(5, r(a, b), true).
clause(6, r(a, c), true).
clause(7, r(b, d), true).
clause(8, r(c, d), true).
clause(10, re(var('X'), var('Y')), r(var('X'), var('Y'))).
clause(11,
       diamond(var('Rel'), var('A'), var('B'), var('C'), var('D')),
       (step(var('Rel'), var('A'), var('B')),
        step(var('Rel'), var('A'), var('C')),
        step(var('Rel'), var('B'), var('D')),
        step(var('Rel'), var('C'), var('D')))).
clause(12, step(r, var('X'), var('Y')), r(var('X'), var('Y'))).
clause(13, step(re, var('X'), var('Y')), re(var('X'), var('Y'))).
clause(14, holdsFor(diamondProperty, var('Rel')), diamond(var('Rel'), a, b, c, d)).
clause(15, commonSuccessor(diamondProperty, var('D')), diamond(r, a, b, c, var('D'))).
clause(16, preservedUnderReflexiveClosure(diamondProperty, true), diamond(re, a, b, c, d)).

step(holdsFor(diamondProperty, r), rule(14), ['Rel' = r], [diamond(r, a, b, c, d)]).
step(diamond(r, a, b, c, d),
     rule(11),
     ['Rel' = r, 'A' = a, 'B' = b, 'C' = c, 'D' = d],
     [step(r, a, b), step(r, a, c), step(r, b, d), step(r, c, d)]).
step(step(r, a, b), rule(12), ['X' = a, 'Y' = b], [r(a, b)]).
step(r(a, b), fact(5), [], []).
step(step(r, a, c), rule(12), ['X' = a, 'Y' = c], [r(a, c)]).
step(r(a, c), fact(6), [], []).
step(step(r, b, d), rule(12), ['X' = b, 'Y' = d], [r(b, d)]).
step(r(b, d), fact(7), [], []).
step(step(r, c, d), rule(12), ['X' = c, 'Y' = d], [r(c, d)]).
step(r(c, d), fact(8), [], []).
step(holdsFor(diamondProperty, re), rule(14), ['Rel' = re], [diamond(re, a, b, c, d)]).
step(diamond(re, a, b, c, d),
     rule(11),
     ['Rel' = re, 'A' = a, 'B' = b, 'C' = c, 'D' = d],
     [step(re, a, b), step(re, a, c), step(re, b, d), step(re, c, d)]).
step(step(re, a, b), rule(13), ['X' = a, 'Y' = b], [re(a, b)]).
step(re(a, b), rule(10), ['X' = a, 'Y' = b], [r(a, b)]).
step(step(re, a, c), rule(13), ['X' = a, 'Y' = c], [re(a, c)]).
step(re(a, c), rule(10), ['X' = a, 'Y' = c], [r(a, c)]).
step(step(re, b, d), rule(13), ['X' = b, 'Y' = d], [re(b, d)]).
step(re(b, d), rule(10), ['X' = b, 'Y' = d], [r(b, d)]).
step(step(re, c, d), rule(13), ['X' = c, 'Y' = d], [re(c, d)]).
step(re(c, d), rule(10), ['X' = c, 'Y' = d], [r(c, d)]).
step(commonSuccessor(diamondProperty, d), rule(15), ['D' = d], [diamond(r, a, b, c, d)]).
step(preservedUnderReflexiveClosure(diamondProperty, true),
     rule(16),
     [],
     [diamond(re, a, b, c, d)]).
