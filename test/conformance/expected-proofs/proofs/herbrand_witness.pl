has_parent(alice, parent_of(alice)).

clause(1, person(alice), true).
clause(2, has_parent(var('Child'), parent_of(var('Child'))), person(var('Child'))).

step(has_parent(alice, parent_of(alice)), rule(2), ['Child' = alice], [person(alice)]).
step(person(alice), fact(1), [], []).
