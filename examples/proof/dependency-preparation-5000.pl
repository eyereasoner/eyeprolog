chain4998(ready).

clause(4999, chain4998(var('X')), chain4999(var('X'))).
clause(5000, chain4999(ready), true).

step(chain4998(ready), rule(4999), ['X' = ready], [chain4999(ready)]).
step(chain4999(ready), fact(5000), [], []).
