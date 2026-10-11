chain9998(ready).

clause(9999, chain9998(var('X')), chain9999(var('X'))).
clause(10000, chain9999(ready), !).

step(chain9998(ready), rule(9999), ['X' = ready], [chain9999(ready)]).
step(chain9999(ready), rule(10000), [], "!").
step(!, builtin, [], []).
