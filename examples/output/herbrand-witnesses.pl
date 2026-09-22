% Prolog result format 4
query(1, has_parent(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 2).
answer(1, ['X0' = alice, 'X1' = parent_of(alice)]).
answer(1, ['X0' = bob, 'X1' = parent_of(bob)]).
query(2, registration(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(2, complete, 3).
answer(2, ['X0' = alice, 'X1' = logic, 'X2' = registration_of(alice, logic)]).
answer(2, ['X0' = alice, 'X1' = math, 'X2' = registration_of(alice, math)]).
answer(2, ['X0' = bob, 'X1' = logic, 'X2' = registration_of(bob, logic)]).
query(3, same_witness(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = parent_of_alice, 'X1' = true]).
query(4, distinct_witnesses(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = alice_logic_vs_alice_math, 'X1' = true]).
