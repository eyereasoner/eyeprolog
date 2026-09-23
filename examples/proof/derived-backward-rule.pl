log_impliedBy(childOf(var(x), var(y)), parentOf(var(y), var(x))).
childOf(bob, alice).
hasParent(bob, alice).

clause(1, invOf(parentOf, childOf), true).
clause(2, parentOf(alice, bob), true).
clause(3,
       log_impliedBy(childOf(var(x), var(y)), parentOf(var(y), var(x))),
       invOf(parentOf, childOf)).
clause(4,
       childOf(var('X'), var('Y')),
       (log_impliedBy(childOf(var(x), var(y)), parentOf(var(y), var(x))),
        parentOf(var('Y'), var('X')))).
clause(5, hasParent(var('X'), var('Y')), childOf(var('X'), var('Y'))).

step(log_impliedBy(childOf(var(x), var(y)), parentOf(var(y), var(x))),
     rule(3),
     [],
     [invOf(parentOf, childOf)]).
step(invOf(parentOf, childOf), fact(1), [], []).
step(childOf(bob, alice),
     rule(4),
     ['X' = bob, 'Y' = alice],
     [log_impliedBy(childOf(var(x), var(y)), parentOf(var(y), var(x))), parentOf(alice, bob)]).
step(parentOf(alice, bob), fact(2), [], []).
step(hasParent(bob, alice), rule(5), ['X' = bob, 'Y' = alice], [childOf(bob, alice)]).
