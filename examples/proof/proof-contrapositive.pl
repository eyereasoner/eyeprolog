refutes(proof1, raining).
method(proof1, contrapositive).
reason(proof1, "if rain implies wet ground and the ground is not wet, then it is not raining").

clause(1, implies(raining, wet_ground), true).
clause(2, false(wet_ground), true).
clause(3, false(var('A')), (implies(var('A'), var('B')), false(var('B')))).
clause(4, refutes(proof1, raining), false(raining)).
clause(5, method(proof1, contrapositive), false(raining)).
clause(6,
       reason(proof1, "if rain implies wet ground and the ground is not wet, then it is not raining"),
       false(raining)).

step(refutes(proof1, raining), rule(4), [], [false(raining)]).
step(false(raining),
     rule(3),
     ['A' = raining, 'B' = wet_ground],
     [implies(raining, wet_ground), false(wet_ground)]).
step(implies(raining, wet_ground), fact(1), [], []).
step(false(wet_ground), fact(2), [], []).
step(method(proof1, contrapositive), rule(5), [], [false(raining)]).
step(reason(proof1, "if rain implies wet ground and the ground is not wet, then it is not raining"),
     rule(6),
     [],
     [false(raining)]).
