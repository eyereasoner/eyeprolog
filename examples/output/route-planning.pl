route_to_nantes(angers, go(angers, nantes, goal)).
route_to_nantes(paris, go(paris, chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal))))).
route_to_nantes(chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal)))).
route_to_nantes(lemans, go(lemans, angers, go(angers, nantes, goal))).
