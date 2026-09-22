% Prolog result format 4
query(1, defaultSupports(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 2).
answer(1, ['X0' = nixon, 'X1' = pacifist]).
why(1, ['X0' = nixon, 'X1' = pacifist], [defaultSupports(nixon, pacifist)]).
answer(1, ['X0' = nixon, 'X1' = hawk]).
why(1, ['X0' = nixon, 'X1' = hawk], [defaultSupports(nixon, hawk)]).
query(2, conflict(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 2).
answer(2, ['X0' = nixon, 'X1' = conflict(pacifist, hawk)]).
why(2,
    ['X0' = nixon, 'X1' = conflict(pacifist, hawk)],
    [conflict(nixon, conflict(pacifist, hawk))]).
answer(2, ['X0' = nixon, 'X1' = conflict(hawk, pacifist)]).
why(2,
    ['X0' = nixon, 'X1' = conflict(hawk, pacifist)],
    [conflict(nixon, conflict(hawk, pacifist))]).
query(3, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = nixon, 'X1' = conflicted_default_case]).
why(3, ['X0' = nixon, 'X1' = conflicted_default_case], [status(nixon, conflicted_default_case)]).

clause(1, kind(nixon, quaker), true).
clause(2, kind(nixon, republican), true).
clause(3, supports_default(var('Person'), pacifist), kind(var('Person'), quaker)).
clause(4, supports_default(var('Person'), hawk), kind(var('Person'), republican)).
clause(5, contrary(pacifist, hawk), true).
clause(6, contrary(hawk, pacifist), true).
clause(7,
       conflicted(var('Person'), var('A'), var('B')),
       (supports_default(var('Person'), var('A')),
        supports_default(var('Person'), var('B')),
        contrary(var('A'), var('B')))).
clause(8,
       defaultSupports(var('Person'), var('Conclusion')),
       supports_default(var('Person'), var('Conclusion'))).
clause(9,
       conflict(var('Person'), conflict(var('A'), var('B'))),
       conflicted(var('Person'), var('A'), var('B'))).
clause(10,
       status(var('Person'), conflicted_default_case),
       conflicted(var('Person'), anonymous(1), anonymous(2))).

step(defaultSupports(nixon, pacifist),
     rule(8),
     ['Person' = nixon, 'Conclusion' = pacifist],
     [supports_default(nixon, pacifist)]).
step(supports_default(nixon, pacifist), rule(3), ['Person' = nixon], [kind(nixon, quaker)]).
step(kind(nixon, quaker), fact(1), [], []).
step(defaultSupports(nixon, hawk),
     rule(8),
     ['Person' = nixon, 'Conclusion' = hawk],
     [supports_default(nixon, hawk)]).
step(supports_default(nixon, hawk), rule(4), ['Person' = nixon], [kind(nixon, republican)]).
step(kind(nixon, republican), fact(2), [], []).
step(conflict(nixon, conflict(pacifist, hawk)),
     rule(9),
     ['Person' = nixon, 'A' = pacifist, 'B' = hawk],
     [conflicted(nixon, pacifist, hawk)]).
step(conflicted(nixon, pacifist, hawk),
     rule(7),
     ['Person' = nixon, 'A' = pacifist, 'B' = hawk],
     [supports_default(nixon, pacifist),
      supports_default(nixon, hawk),
      contrary(pacifist, hawk)]).
step(contrary(pacifist, hawk), fact(5), [], []).
step(conflict(nixon, conflict(hawk, pacifist)),
     rule(9),
     ['Person' = nixon, 'A' = hawk, 'B' = pacifist],
     [conflicted(nixon, hawk, pacifist)]).
step(conflicted(nixon, hawk, pacifist),
     rule(7),
     ['Person' = nixon, 'A' = hawk, 'B' = pacifist],
     [supports_default(nixon, hawk),
      supports_default(nixon, pacifist),
      contrary(hawk, pacifist)]).
step(contrary(hawk, pacifist), fact(6), [], []).
step(status(nixon, conflicted_default_case),
     rule(10),
     ['Person' = nixon],
     [conflicted(nixon, pacifist, hawk)]).
