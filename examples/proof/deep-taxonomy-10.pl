a(ind, a2).

clause(2, a(ind, n0), true).
clause(4, a(var('X'), a2), a(var('X'), n10)).
clause(5, a(var('X'), n1), a(var('X'), n0)).
clause(8, a(var('X'), n2), a(var('X'), n1)).
clause(11, a(var('X'), n3), a(var('X'), n2)).
clause(14, a(var('X'), n4), a(var('X'), n3)).
clause(17, a(var('X'), n5), a(var('X'), n4)).
clause(20, a(var('X'), n6), a(var('X'), n5)).
clause(23, a(var('X'), n7), a(var('X'), n6)).
clause(26, a(var('X'), n8), a(var('X'), n7)).
clause(29, a(var('X'), n9), a(var('X'), n8)).
clause(32, a(var('X'), n10), a(var('X'), n9)).

step(a(ind, a2), rule(4), ['X' = ind], [a(ind, n10)]).
step(a(ind, n10), rule(32), ['X' = ind], [a(ind, n9)]).
step(a(ind, n9), rule(29), ['X' = ind], [a(ind, n8)]).
step(a(ind, n8), rule(26), ['X' = ind], [a(ind, n7)]).
step(a(ind, n7), rule(23), ['X' = ind], [a(ind, n6)]).
step(a(ind, n6), rule(20), ['X' = ind], [a(ind, n5)]).
step(a(ind, n5), rule(17), ['X' = ind], [a(ind, n4)]).
step(a(ind, n4), rule(14), ['X' = ind], [a(ind, n3)]).
step(a(ind, n3), rule(11), ['X' = ind], [a(ind, n2)]).
step(a(ind, n2), rule(8), ['X' = ind], [a(ind, n1)]).
step(a(ind, n1), rule(5), ['X' = ind], [a(ind, n0)]).
step(a(ind, n0), fact(2), [], []).
