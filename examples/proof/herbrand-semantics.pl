different(alice, bob).
different(ticket(alice), ticket(bob)).

clause(1, different(alice, bob), alice \= bob).
clause(2, different(ticket(alice), ticket(bob)), ticket(alice) \= ticket(bob)).

step(different(alice, bob), rule(1), [], [alice \= bob]).
step(alice \= bob, builtin, [], []).
step(different(ticket(alice), ticket(bob)), rule(2), [], [ticket(alice) \= ticket(bob)]).
step(ticket(alice) \= ticket(bob), builtin, [], []).
