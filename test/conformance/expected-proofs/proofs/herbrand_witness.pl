% Prolog result format 4
query(1, has_parent(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = alice, 'X1' = parent_of(alice)]).
why(1, ['X0' = alice, 'X1' = parent_of(alice)], [has_parent(alice, parent_of(alice))]).

clause(1, person(alice), true).
clause(2, has_parent(var('Child'), parent_of(var('Child'))), person(var('Child'))).

step(has_parent(alice, parent_of(alice)), rule(2), ['Child' = alice], [person(alice)]).
step(person(alice), fact(1), [], []).
