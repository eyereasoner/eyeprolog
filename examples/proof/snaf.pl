hates(alice, nobody).

clause(2, person(bob), true).
clause(3, hates(alice, nobody), (person(var('X')), \+ hates(alice, var('X')))).

step(hates(alice, nobody), rule(3), ['X' = bob], [person(bob), \+ hates(alice, bob)]).
step(person(bob), fact(2), [], []).
step(\+ hates(alice, bob), absent, [], []).
