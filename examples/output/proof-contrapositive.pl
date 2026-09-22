% Prolog result format 4
query(1, refutes(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = proof1, 'X1' = raining]).
query(2, method(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = proof1, 'X1' = contrapositive]).
query(3, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3,
       ['X0' = proof1,
        'X1' = "if rain implies wet ground and the ground is not wet, then it is not raining"]).
