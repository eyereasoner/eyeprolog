type(skolem_observation(alice, glucose), observation).
type(skolem_observation(alice, cholesterol), observation).
type(skolem_observation(bob, glucose), observation).
type(skolem_alert(alice, glucose), highGlucoseAlert).
patient(skolem_observation(alice, glucose), alice).
patient(skolem_observation(alice, cholesterol), alice).
patient(skolem_observation(bob, glucose), bob).
test(skolem_observation(alice, glucose), glucose).
test(skolem_observation(alice, cholesterol), cholesterol).
test(skolem_observation(bob, glucose), glucose).
value(skolem_observation(alice, glucose), 6.8).
value(skolem_observation(alice, cholesterol), 4.2).
value(skolem_observation(bob, glucose), 5.1).
about(skolem_alert(alice, glucose), skolem_observation(alice, glucose)).
sameInputsSameId(skolemDemo, true).
noObservationClash(skolemDemo, true).

clause(1, test_result(alice, glucose, 6.8), true).
clause(2, test_result(alice, cholesterol, 4.2), true).
clause(3, test_result(bob, glucose, 5.1), true).
clause(4,
       high_glucose(var('Patient')),
       (test_result(var('Patient'), glucose, var('Value')), var('Value') > 6.0)).
clause(6,
       type(skolem_observation(var('Patient'), var('Test')), observation),
       test_result(var('Patient'), var('Test'), anonymous(1))).
clause(7,
       patient(skolem_observation(var('Patient'), var('Test')), var('Patient')),
       test_result(var('Patient'), var('Test'), anonymous(1))).
clause(8,
       test(skolem_observation(var('Patient'), var('Test')), var('Test')),
       test_result(var('Patient'), var('Test'), anonymous(1))).
clause(9,
       value(skolem_observation(var('Patient'), var('Test')), var('Value')),
       test_result(var('Patient'), var('Test'), var('Value'))).
clause(10,
       type(skolem_alert(var('Patient'), glucose), highGlucoseAlert),
       high_glucose(var('Patient'))).
clause(11,
       about(skolem_alert(var('Patient'), glucose), skolem_observation(var('Patient'), glucose)),
       high_glucose(var('Patient'))).
clause(12,
       sameInputsSameId(skolemDemo, true),
       skolem_observation(alice, glucose) = skolem_observation(alice, glucose)).
clause(13,
       noObservationClash(skolemDemo, true),
       (skolem_observation(alice, glucose) \= skolem_observation(alice, cholesterol),
        skolem_observation(alice, glucose) \= skolem_observation(bob, glucose))).

step(type(skolem_observation(alice, glucose), observation),
     rule(6),
     ['Patient' = alice, 'Test' = glucose],
     [test_result(alice, glucose, 6.8)]).
step(test_result(alice, glucose, 6.8), fact(1), [], []).
step(type(skolem_observation(alice, cholesterol), observation),
     rule(6),
     ['Patient' = alice, 'Test' = cholesterol],
     [test_result(alice, cholesterol, 4.2)]).
step(test_result(alice, cholesterol, 4.2), fact(2), [], []).
step(type(skolem_observation(bob, glucose), observation),
     rule(6),
     ['Patient' = bob, 'Test' = glucose],
     [test_result(bob, glucose, 5.1)]).
step(test_result(bob, glucose, 5.1), fact(3), [], []).
step(type(skolem_alert(alice, glucose), highGlucoseAlert),
     rule(10),
     ['Patient' = alice],
     [high_glucose(alice)]).
step(high_glucose(alice),
     rule(4),
     ['Patient' = alice, 'Value' = 6.8],
     [test_result(alice, glucose, 6.8), 6.8 > 6.0]).
step(6.8 > 6.0, builtin, [], []).
step(patient(skolem_observation(alice, glucose), alice),
     rule(7),
     ['Patient' = alice, 'Test' = glucose],
     [test_result(alice, glucose, 6.8)]).
step(patient(skolem_observation(alice, cholesterol), alice),
     rule(7),
     ['Patient' = alice, 'Test' = cholesterol],
     [test_result(alice, cholesterol, 4.2)]).
step(patient(skolem_observation(bob, glucose), bob),
     rule(7),
     ['Patient' = bob, 'Test' = glucose],
     [test_result(bob, glucose, 5.1)]).
step(test(skolem_observation(alice, glucose), glucose),
     rule(8),
     ['Patient' = alice, 'Test' = glucose],
     [test_result(alice, glucose, 6.8)]).
step(test(skolem_observation(alice, cholesterol), cholesterol),
     rule(8),
     ['Patient' = alice, 'Test' = cholesterol],
     [test_result(alice, cholesterol, 4.2)]).
step(test(skolem_observation(bob, glucose), glucose),
     rule(8),
     ['Patient' = bob, 'Test' = glucose],
     [test_result(bob, glucose, 5.1)]).
step(value(skolem_observation(alice, glucose), 6.8),
     rule(9),
     ['Patient' = alice, 'Test' = glucose, 'Value' = 6.8],
     [test_result(alice, glucose, 6.8)]).
step(value(skolem_observation(alice, cholesterol), 4.2),
     rule(9),
     ['Patient' = alice, 'Test' = cholesterol, 'Value' = 4.2],
     [test_result(alice, cholesterol, 4.2)]).
step(value(skolem_observation(bob, glucose), 5.1),
     rule(9),
     ['Patient' = bob, 'Test' = glucose, 'Value' = 5.1],
     [test_result(bob, glucose, 5.1)]).
step(about(skolem_alert(alice, glucose), skolem_observation(alice, glucose)),
     rule(11),
     ['Patient' = alice],
     [high_glucose(alice)]).
step(sameInputsSameId(skolemDemo, true),
     rule(12),
     [],
     [skolem_observation(alice, glucose) = skolem_observation(alice, glucose)]).
step(skolem_observation(alice, glucose) = skolem_observation(alice, glucose), builtin, [], []).
step(noObservationClash(skolemDemo, true),
     rule(13),
     [],
     [skolem_observation(alice, glucose) \= skolem_observation(alice, cholesterol),
      skolem_observation(alice, glucose) \= skolem_observation(bob, glucose)]).
step(skolem_observation(alice, glucose) \= skolem_observation(alice, cholesterol),
     builtin,
     [],
     []).
step(skolem_observation(alice, glucose) \= skolem_observation(bob, glucose), builtin, [], []).
