% Prolog result format 4
query(1, route_to_nantes(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = angers, 'X1' = go(angers, nantes, goal)]).
answer(1,
       ['X0' = paris,
        'X1' = go(paris, chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal))))]).
answer(1,
       ['X0' = chartres,
        'X1' = go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal)))]).
answer(1, ['X0' = lemans, 'X1' = go(lemans, angers, go(angers, nantes, goal))]).
