% Prolog result format 4
query(1, has_parent(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 2).
answer(1, ['X0' = alice, 'X1' = parent_of(alice)]).
why(1, ['X0' = alice, 'X1' = parent_of(alice)], [has_parent(alice, parent_of(alice))]).
answer(1, ['X0' = bob, 'X1' = parent_of(bob)]).
why(1, ['X0' = bob, 'X1' = parent_of(bob)], [has_parent(bob, parent_of(bob))]).
query(2, registration(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(2, complete, 3).
answer(2, ['X0' = alice, 'X1' = logic, 'X2' = registration_of(alice, logic)]).
why(2,
    ['X0' = alice, 'X1' = logic, 'X2' = registration_of(alice, logic)],
    [registration(alice, logic, registration_of(alice, logic))]).
answer(2, ['X0' = alice, 'X1' = math, 'X2' = registration_of(alice, math)]).
why(2,
    ['X0' = alice, 'X1' = math, 'X2' = registration_of(alice, math)],
    [registration(alice, math, registration_of(alice, math))]).
answer(2, ['X0' = bob, 'X1' = logic, 'X2' = registration_of(bob, logic)]).
why(2,
    ['X0' = bob, 'X1' = logic, 'X2' = registration_of(bob, logic)],
    [registration(bob, logic, registration_of(bob, logic))]).
query(3, same_witness(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = parent_of_alice, 'X1' = true]).
why(3, ['X0' = parent_of_alice, 'X1' = true], [same_witness(parent_of_alice, true)]).
query(4, distinct_witnesses(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = alice_logic_vs_alice_math, 'X1' = true]).
why(4,
    ['X0' = alice_logic_vs_alice_math, 'X1' = true],
    [distinct_witnesses(alice_logic_vs_alice_math, true)]).

clause(1, person(alice), true).
clause(2, person(bob), true).
clause(3, takes(alice, logic), true).
clause(4, takes(alice, math), true).
clause(5, takes(bob, logic), true).
clause(6, has_parent(var('Child'), parent_of(var('Child'))), person(var('Child'))).
clause(7,
       registration(var('Student'), var('Course'), registration_of(var('Student'), var('Course'))),
       takes(var('Student'), var('Course'))).
clause(8, same_witness(parent_of_alice, true), parent_of(alice) = parent_of(alice)).
clause(9,
       distinct_witnesses(alice_logic_vs_alice_math, true),
       registration_of(alice, logic) \= registration_of(alice, math)).

step(has_parent(alice, parent_of(alice)), rule(6), ['Child' = alice], [person(alice)]).
step(person(alice), fact(1), [], []).
step(has_parent(bob, parent_of(bob)), rule(6), ['Child' = bob], [person(bob)]).
step(person(bob), fact(2), [], []).
step(registration(alice, logic, registration_of(alice, logic)),
     rule(7),
     ['Student' = alice, 'Course' = logic],
     [takes(alice, logic)]).
step(takes(alice, logic), fact(3), [], []).
step(registration(alice, math, registration_of(alice, math)),
     rule(7),
     ['Student' = alice, 'Course' = math],
     [takes(alice, math)]).
step(takes(alice, math), fact(4), [], []).
step(registration(bob, logic, registration_of(bob, logic)),
     rule(7),
     ['Student' = bob, 'Course' = logic],
     [takes(bob, logic)]).
step(takes(bob, logic), fact(5), [], []).
step(same_witness(parent_of_alice, true), rule(8), [], [parent_of(alice) = parent_of(alice)]).
step(parent_of(alice) = parent_of(alice), builtin, [], []).
step(distinct_witnesses(alice_logic_vs_alice_math, true),
     rule(9),
     [],
     [registration_of(alice, logic) \= registration_of(alice, math)]).
step(registration_of(alice, logic) \= registration_of(alice, math), builtin, [], []).
