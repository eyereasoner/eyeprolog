path('node a', 'node b').
path('node b', 'node c').
path('node c', 'node d').
path('node a', 'node c').
path('node a', 'node d').
path('node b', 'node d').

clause(2, edge('node a', 'node b'), true).
clause(3, edge('node b', 'node c'), true).
clause(4, edge('node c', 'node d'), true).
clause(5, path(var('X'), var('Y')), edge(var('X'), var('Y'))).
clause(6, path(var('X'), var('Z')), (edge(var('X'), var('Y')), path(var('Y'), var('Z')))).

step(path('node a', 'node b'),
     rule(5),
     ['X' = 'node a', 'Y' = 'node b'],
     [edge('node a', 'node b')]).
step(edge('node a', 'node b'), fact(2), [], []).
step(path('node b', 'node c'),
     rule(5),
     ['X' = 'node b', 'Y' = 'node c'],
     [edge('node b', 'node c')]).
step(edge('node b', 'node c'), fact(3), [], []).
step(path('node c', 'node d'),
     rule(5),
     ['X' = 'node c', 'Y' = 'node d'],
     [edge('node c', 'node d')]).
step(edge('node c', 'node d'), fact(4), [], []).
step(path('node a', 'node c'),
     rule(6),
     ['X' = 'node a', 'Z' = 'node c', 'Y' = 'node b'],
     [edge('node a', 'node b'), path('node b', 'node c')]).
step(path('node a', 'node d'),
     rule(6),
     ['X' = 'node a', 'Z' = 'node d', 'Y' = 'node b'],
     [edge('node a', 'node b'), path('node b', 'node d')]).
step(path('node b', 'node d'),
     rule(6),
     ['X' = 'node b', 'Z' = 'node d', 'Y' = 'node c'],
     [edge('node b', 'node c'), path('node c', 'node d')]).
