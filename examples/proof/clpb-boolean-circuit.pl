% Prolog result format 4
query(1, xor_row(_0), ['X0' = _0]).
result(1, complete, 4).
answer(1, ['X0' = row(0, 0, 0)]).
why(1, ['X0' = row(0, 0, 0)], [xor_row(row(0, 0, 0))]).
answer(1, ['X0' = row(1, 1, 0)]).
why(1, ['X0' = row(1, 1, 0)], [xor_row(row(1, 1, 0))]).
answer(1, ['X0' = row(0, 1, 1)]).
why(1, ['X0' = row(0, 1, 1)], [xor_row(row(0, 1, 1))]).
answer(1, ['X0' = row(1, 0, 1)]).
why(1, ['X0' = row(1, 0, 1)], [xor_row(row(1, 0, 1))]).
query(2, xor_circuit_verified(_0), ['X0' = _0]).
result(2, complete, 1).
answer(2, ['X0' = 1]).
why(2, ['X0' = 1], [xor_circuit_verified(1)]).

clause(1,
       xor_circuit(var('X'), var('Y'), var('Z')),
       sat(var('Z') =:= var('X') * ~ var('Y') + ~ var('X') * var('Y'))).
clause(2,
       xor_row(row(var('X'), var('Y'), var('Z'))),
       (xor_circuit(var('X'), var('Y'), var('Z')), labeling([var('X'), var('Y'), var('Z')]))).

step(xor_row(row(0, 0, 0)),
     rule(2),
     ['X' = 0, 'Y' = 0, 'Z' = 0],
     [xor_circuit(0, 0, 0), labeling([0, 0, 0])]).
step(xor_circuit(0, 0, 0), rule(1), ['X' = 0, 'Y' = 0, 'Z' = 0], [sat(0 =:= 0 * ~ 0 + ~ 0 * 0)]).
step(sat(0 =:= 0 * ~ 0 + ~ 0 * 0), builtin, [], []).
step(labeling([0, 0, 0]), builtin, [], []).
step(xor_row(row(1, 1, 0)),
     rule(2),
     ['X' = 1, 'Y' = 1, 'Z' = 0],
     [xor_circuit(1, 1, 0), labeling([1, 1, 0])]).
step(xor_circuit(1, 1, 0), rule(1), ['X' = 1, 'Y' = 1, 'Z' = 0], [sat(0 =:= 1 * ~ 1 + ~ 1 * 1)]).
step(sat(0 =:= 1 * ~ 1 + ~ 1 * 1), builtin, [], []).
step(labeling([1, 1, 0]), builtin, [], []).
step(xor_row(row(0, 1, 1)),
     rule(2),
     ['X' = 0, 'Y' = 1, 'Z' = 1],
     [xor_circuit(0, 1, 1), labeling([0, 1, 1])]).
step(xor_circuit(0, 1, 1), rule(1), ['X' = 0, 'Y' = 1, 'Z' = 1], [sat(1 =:= 0 * ~ 1 + ~ 0 * 1)]).
step(sat(1 =:= 0 * ~ 1 + ~ 0 * 1), builtin, [], []).
step(labeling([0, 1, 1]), builtin, [], []).
step(xor_row(row(1, 0, 1)),
     rule(2),
     ['X' = 1, 'Y' = 0, 'Z' = 1],
     [xor_circuit(1, 0, 1), labeling([1, 0, 1])]).
step(xor_circuit(1, 0, 1), rule(1), ['X' = 1, 'Y' = 0, 'Z' = 1], [sat(1 =:= 1 * ~ 0 + ~ 1 * 0)]).
step(sat(1 =:= 1 * ~ 0 + ~ 1 * 0), builtin, [], []).
step(labeling([1, 0, 1]), builtin, [], []).
step(xor_circuit_verified(1), unproven, [], []).
