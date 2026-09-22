% Prolog result format 4
query(1, type(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = skolem_observation(alice, glucose), 'X1' = observation]).
answer(1, ['X0' = skolem_observation(alice, cholesterol), 'X1' = observation]).
answer(1, ['X0' = skolem_observation(bob, glucose), 'X1' = observation]).
answer(1, ['X0' = skolem_alert(alice, glucose), 'X1' = highGlucoseAlert]).
query(2, patient(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 3).
answer(2, ['X0' = skolem_observation(alice, glucose), 'X1' = alice]).
answer(2, ['X0' = skolem_observation(alice, cholesterol), 'X1' = alice]).
answer(2, ['X0' = skolem_observation(bob, glucose), 'X1' = bob]).
query(3, test(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 3).
answer(3, ['X0' = skolem_observation(alice, glucose), 'X1' = glucose]).
answer(3, ['X0' = skolem_observation(alice, cholesterol), 'X1' = cholesterol]).
answer(3, ['X0' = skolem_observation(bob, glucose), 'X1' = glucose]).
query(4, value(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 3).
answer(4, ['X0' = skolem_observation(alice, glucose), 'X1' = 6.8]).
answer(4, ['X0' = skolem_observation(alice, cholesterol), 'X1' = 4.2]).
answer(4, ['X0' = skolem_observation(bob, glucose), 'X1' = 5.1]).
query(5, about(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5, ['X0' = skolem_alert(alice, glucose), 'X1' = skolem_observation(alice, glucose)]).
query(6, sameInputsSameId(_0, _1), ['X0' = _0, 'X1' = _1]).
result(6, complete, 1).
answer(6, ['X0' = skolemDemo, 'X1' = true]).
query(7, noObservationClash(_0, _1), ['X0' = _0, 'X1' = _1]).
result(7, complete, 1).
answer(7, ['X0' = skolemDemo, 'X1' = true]).
