% Prolog result format 4
query(1, route_to_nantes(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = angers, 'X1' = go(angers, nantes, goal)]).
why(1,
    ['X0' = angers, 'X1' = go(angers, nantes, goal)],
    [route_to_nantes(angers, go(angers, nantes, goal))]).
answer(1,
       ['X0' = paris,
        'X1' = go(paris, chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal))))]).
why(1,
    ['X0' = paris,
     'X1' = go(paris, chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal))))],
    [route_to_nantes(paris, go(paris, chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal)))))]).
answer(1,
       ['X0' = chartres,
        'X1' = go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal)))]).
why(1,
    ['X0' = chartres, 'X1' = go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal)))],
    [route_to_nantes(chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal))))]).
answer(1, ['X0' = lemans, 'X1' = go(lemans, angers, go(angers, nantes, goal))]).
why(1,
    ['X0' = lemans, 'X1' = go(lemans, angers, go(angers, nantes, goal))],
    [route_to_nantes(lemans, go(lemans, angers, go(angers, nantes, goal)))]).

clause(2, oneway(paris, chartres), true).
clause(7, oneway(chartres, lemans), true).
clause(8, oneway(lemans, angers), true).
clause(10, oneway(angers, nantes), true).
clause(11, path([var('A'), var('B')], go(var('A'), var('B'), goal)), oneway(var('A'), var('B'))).
clause(12,
       path([var('A'), var('C')], go(var('A'), var('B'), var('Rest'))),
       (oneway(var('A'), var('B')), path([var('B'), var('C')], var('Rest')))).
clause(13, route_to_nantes(var('From'), var('Plan')), path([var('From'), nantes], var('Plan'))).

step(route_to_nantes(angers, go(angers, nantes, goal)),
     rule(13),
     ['From' = angers, 'Plan' = go(angers, nantes, goal)],
     [path([angers, nantes], go(angers, nantes, goal))]).
step(path([angers, nantes], go(angers, nantes, goal)),
     rule(11),
     ['A' = angers, 'B' = nantes],
     [oneway(angers, nantes)]).
step(oneway(angers, nantes), fact(10), [], []).
step(route_to_nantes(paris, go(paris, chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal))))),
     rule(13),
     ['From' = paris,
      'Plan' = go(paris, chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal))))],
     [path([paris, nantes], go(paris, chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal)))))]).
step(path([paris, nantes], go(paris, chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal))))),
     rule(12),
     ['A' = paris,
      'C' = nantes,
      'B' = chartres,
      'Rest' = go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal)))],
     [oneway(paris, chartres),
      path([chartres, nantes], go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal))))]).
step(oneway(paris, chartres), fact(2), [], []).
step(path([chartres, nantes], go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal)))),
     rule(12),
     ['A' = chartres,
      'C' = nantes,
      'B' = lemans,
      'Rest' = go(lemans, angers, go(angers, nantes, goal))],
     [oneway(chartres, lemans),
      path([lemans, nantes], go(lemans, angers, go(angers, nantes, goal)))]).
step(oneway(chartres, lemans), fact(7), [], []).
step(path([lemans, nantes], go(lemans, angers, go(angers, nantes, goal))),
     rule(12),
     ['A' = lemans, 'C' = nantes, 'B' = angers, 'Rest' = go(angers, nantes, goal)],
     [oneway(lemans, angers), path([angers, nantes], go(angers, nantes, goal))]).
step(oneway(lemans, angers), fact(8), [], []).
step(route_to_nantes(chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal)))),
     rule(13),
     ['From' = chartres,
      'Plan' = go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal)))],
     [path([chartres, nantes], go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal))))]).
step(route_to_nantes(lemans, go(lemans, angers, go(angers, nantes, goal))),
     rule(13),
     ['From' = lemans, 'Plan' = go(lemans, angers, go(angers, nantes, goal))],
     [path([lemans, nantes], go(lemans, angers, go(angers, nantes, goal)))]).
