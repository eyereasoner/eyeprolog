path(paris, orleans).
path(paris, chartres).
path(paris, amiens).
path(orleans, blois).
path(orleans, bourges).
path(blois, tours).
path(chartres, lemans).
path(lemans, angers).
path(lemans, tours).
path(angers, nantes).
path(paris, blois).
path(paris, bourges).
path(paris, tours).
path(paris, lemans).
path(paris, angers).
path(paris, nantes).
path(orleans, tours).
path(chartres, angers).
path(chartres, tours).
path(chartres, nantes).
path(lemans, nantes).

clause(1, oneway(paris, orleans), true).
clause(2, oneway(paris, chartres), true).
clause(3, oneway(paris, amiens), true).
clause(4, oneway(orleans, blois), true).
clause(5, oneway(orleans, bourges), true).
clause(6, oneway(blois, tours), true).
clause(7, oneway(chartres, lemans), true).
clause(8, oneway(lemans, angers), true).
clause(9, oneway(lemans, tours), true).
clause(10, oneway(angers, nantes), true).
clause(11, path(var('A'), var('B')), oneway(var('A'), var('B'))).
clause(12, path(var('A'), var('C')), (oneway(var('A'), var('B')), path(var('B'), var('C')))).

step(path(paris, orleans), rule(11), ['A' = paris, 'B' = orleans], [oneway(paris, orleans)]).
step(oneway(paris, orleans), fact(1), [], []).
step(path(paris, chartres), rule(11), ['A' = paris, 'B' = chartres], [oneway(paris, chartres)]).
step(oneway(paris, chartres), fact(2), [], []).
step(path(paris, amiens), rule(11), ['A' = paris, 'B' = amiens], [oneway(paris, amiens)]).
step(oneway(paris, amiens), fact(3), [], []).
step(path(orleans, blois), rule(11), ['A' = orleans, 'B' = blois], [oneway(orleans, blois)]).
step(oneway(orleans, blois), fact(4), [], []).
step(path(orleans, bourges),
     rule(11),
     ['A' = orleans, 'B' = bourges],
     [oneway(orleans, bourges)]).
step(oneway(orleans, bourges), fact(5), [], []).
step(path(blois, tours), rule(11), ['A' = blois, 'B' = tours], [oneway(blois, tours)]).
step(oneway(blois, tours), fact(6), [], []).
step(path(chartres, lemans),
     rule(11),
     ['A' = chartres, 'B' = lemans],
     [oneway(chartres, lemans)]).
step(oneway(chartres, lemans), fact(7), [], []).
step(path(lemans, angers), rule(11), ['A' = lemans, 'B' = angers], [oneway(lemans, angers)]).
step(oneway(lemans, angers), fact(8), [], []).
step(path(lemans, tours), rule(11), ['A' = lemans, 'B' = tours], [oneway(lemans, tours)]).
step(oneway(lemans, tours), fact(9), [], []).
step(path(angers, nantes), rule(11), ['A' = angers, 'B' = nantes], [oneway(angers, nantes)]).
step(oneway(angers, nantes), fact(10), [], []).
step(path(paris, blois),
     rule(12),
     ['A' = paris, 'C' = blois, 'B' = orleans],
     [oneway(paris, orleans), path(orleans, blois)]).
step(path(paris, bourges),
     rule(12),
     ['A' = paris, 'C' = bourges, 'B' = orleans],
     [oneway(paris, orleans), path(orleans, bourges)]).
step(path(paris, tours),
     rule(12),
     ['A' = paris, 'C' = tours, 'B' = orleans],
     [oneway(paris, orleans), path(orleans, tours)]).
step(path(orleans, tours),
     rule(12),
     ['A' = orleans, 'C' = tours, 'B' = blois],
     [oneway(orleans, blois), path(blois, tours)]).
step(path(paris, lemans),
     rule(12),
     ['A' = paris, 'C' = lemans, 'B' = chartres],
     [oneway(paris, chartres), path(chartres, lemans)]).
step(path(paris, angers),
     rule(12),
     ['A' = paris, 'C' = angers, 'B' = chartres],
     [oneway(paris, chartres), path(chartres, angers)]).
step(path(chartres, angers),
     rule(12),
     ['A' = chartres, 'C' = angers, 'B' = lemans],
     [oneway(chartres, lemans), path(lemans, angers)]).
step(path(paris, nantes),
     rule(12),
     ['A' = paris, 'C' = nantes, 'B' = chartres],
     [oneway(paris, chartres), path(chartres, nantes)]).
step(path(chartres, nantes),
     rule(12),
     ['A' = chartres, 'C' = nantes, 'B' = lemans],
     [oneway(chartres, lemans), path(lemans, nantes)]).
step(path(lemans, nantes),
     rule(12),
     ['A' = lemans, 'C' = nantes, 'B' = angers],
     [oneway(lemans, angers), path(angers, nantes)]).
step(path(chartres, tours),
     rule(12),
     ['A' = chartres, 'C' = tours, 'B' = lemans],
     [oneway(chartres, lemans), path(lemans, tours)]).
