% Prolog result format 4
query(1, mustHave(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = alice, 'X1' = dogLicense]).
why(1, ['X0' = alice, 'X1' = dogLicense], [mustHave(alice, dogLicense)]).

clause(1, hasDog(alice, dog1), true).
clause(8,
       dogCount(var('Subject'), var('Count')),
       (hasDog(var('Subject'), anonymous(1)),
        countall(hasDog(var('Subject'), anonymous(2)), var('Count')))).
clause(9,
       mustHave(var('Subject'), dogLicense),
       (dogCount(var('Subject'), var('Count')), var('Count') > 4)).

step(mustHave(alice, dogLicense),
     rule(9),
     ['Subject' = alice, 'Count' = 5],
     [dogCount(alice, 5), 5 > 4]).
step(dogCount(alice, 5),
     rule(8),
     ['Subject' = alice, 'Count' = 5],
     [hasDog(alice, dog1), countall(hasDog(alice, _dog), 5)]).
step(hasDog(alice, dog1), fact(1), [], []).
step(countall(hasDog(alice, _dog), 5), builtin, [], []).
step(5 > 4, builtin, [], []).
