% Prolog result format 4
query(1, different(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 2).
answer(1, ['X0' = alice, 'X1' = bob]).
why(1, ['X0' = alice, 'X1' = bob], [different(alice, bob)]).
answer(1, ['X0' = ticket(alice), 'X1' = ticket(bob)]).
why(1, ['X0' = ticket(alice), 'X1' = ticket(bob)], [different(ticket(alice), ticket(bob))]).

clause(1, different(alice, bob), alice \= bob).
clause(2, different(ticket(alice), ticket(bob)), ticket(alice) \= ticket(bob)).

step(different(alice, bob), rule(1), [], [alice \= bob]).
step(alice \= bob, builtin, [], []).
step(different(ticket(alice), ticket(bob)), rule(2), [], [ticket(alice) \= ticket(bob)]).
step(ticket(alice) \= ticket(bob), builtin, [], []).
