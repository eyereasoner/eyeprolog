% Prolog result format 4
query(1, result(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = root, 'X1' = 12]).
why(1, ['X0' = root, 'X1' = 12], [result(root, 12)]).

clause(1, number(n2, 2), true).
clause(2, number(n3, 3), true).
clause(3, number(n10, 10), true).
clause(4, number(n4, 4), true).
clause(5, expr(eMul, mul, n2, n3), true).
clause(6, expr(eSub, sub, n10, n4), true).
clause(7, expr(eAdd, add, eMul, eSub), true).
clause(8, root(eAdd), true).
clause(9, value(var('Node'), var('Value')), number(var('Node'), var('Value'))).
clause(10,
       value(var('Node'), var('Value')),
       (expr(var('Node'), add, var('Left'), var('Right')),
        value(var('Left'), var('Leftvalue')),
        value(var('Right'), var('Rightvalue')),
        var('Value') is var('Leftvalue') + var('Rightvalue'))).
clause(11,
       value(var('Node'), var('Value')),
       (expr(var('Node'), sub, var('Left'), var('Right')),
        value(var('Left'), var('Leftvalue')),
        value(var('Right'), var('Rightvalue')),
        var('Value') is var('Leftvalue') - var('Rightvalue'))).
clause(12,
       value(var('Node'), var('Value')),
       (expr(var('Node'), mul, var('Left'), var('Right')),
        value(var('Left'), var('Leftvalue')),
        value(var('Right'), var('Rightvalue')),
        var('Value') is var('Leftvalue') * var('Rightvalue'))).
clause(13, result(root, var('Value')), (root(var('Node')), value(var('Node'), var('Value')))).

step(result(root, 12), rule(13), ['Value' = 12, 'Node' = eAdd], [root(eAdd), value(eAdd, 12)]).
step(root(eAdd), fact(8), [], []).
step(value(eAdd, 12),
     rule(10),
     ['Node' = eAdd,
      'Value' = 12,
      'Left' = eMul,
      'Right' = eSub,
      'Leftvalue' = 6,
      'Rightvalue' = 6],
     [expr(eAdd, add, eMul, eSub), value(eMul, 6), value(eSub, 6), 12 is 6 + 6]).
step(expr(eAdd, add, eMul, eSub), fact(7), [], []).
step(value(eMul, 6),
     rule(12),
     ['Node' = eMul, 'Value' = 6, 'Left' = n2, 'Right' = n3, 'Leftvalue' = 2, 'Rightvalue' = 3],
     [expr(eMul, mul, n2, n3), value(n2, 2), value(n3, 3), 6 is 2 * 3]).
step(expr(eMul, mul, n2, n3), fact(5), [], []).
step(value(n2, 2), rule(9), ['Node' = n2, 'Value' = 2], [number(n2, 2)]).
step(number(n2, 2), fact(1), [], []).
step(value(n3, 3), rule(9), ['Node' = n3, 'Value' = 3], [number(n3, 3)]).
step(number(n3, 3), fact(2), [], []).
step(6 is 2 * 3, builtin, [], []).
step(value(eSub, 6),
     rule(11),
     ['Node' = eSub,
      'Value' = 6,
      'Left' = n10,
      'Right' = n4,
      'Leftvalue' = 10,
      'Rightvalue' = 4],
     [expr(eSub, sub, n10, n4), value(n10, 10), value(n4, 4), 6 is 10 - 4]).
step(expr(eSub, sub, n10, n4), fact(6), [], []).
step(value(n10, 10), rule(9), ['Node' = n10, 'Value' = 10], [number(n10, 10)]).
step(number(n10, 10), fact(3), [], []).
step(value(n4, 4), rule(9), ['Node' = n4, 'Value' = 4], [number(n4, 4)]).
step(number(n4, 4), fact(4), [], []).
step(6 is 10 - 4, builtin, [], []).
step(12 is 6 + 6, builtin, [], []).
