% Prolog result format 4
query(1, refutes(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = proof1, 'X1' = raining]).
why(1, ['X0' = proof1, 'X1' = raining], [refutes(proof1, raining)]).
query(2, method(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = proof1, 'X1' = contrapositive]).
why(2, ['X0' = proof1, 'X1' = contrapositive], [method(proof1, contrapositive)]).
query(3, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3,
       ['X0' = proof1,
        'X1' = "if rain implies wet ground and the ground is not wet, then it is not raining"]).
why(3,
    ['X0' = proof1,
     'X1' = "if rain implies wet ground and the ground is not wet, then it is not raining"],
    [reason(proof1, "if rain implies wet ground and the ground is not wet, then it is not raining")]).

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
