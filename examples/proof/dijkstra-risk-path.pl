route(pathB, [depotA, depotB, labD]).
route(pathC, [depotA, depotC, labD]).
route(pathRelay, [depotA, relay, labD]).
route(pathDirectC, [depotA, labD]).
route(pathViaC, [depotA, depotC, depotB, labD]).
rawCost(pathB, 8.0).
rawCost(pathC, 9.0).
rawCost(pathRelay, 10.0).
rawCost(pathDirectC, 14.0).
rawCost(pathViaC, 7.5).
riskSum(pathB, 0.5).
riskSum(pathC, 1.2).
riskSum(pathRelay, 0.4).
riskSum(pathDirectC, 0.05).
riskSum(pathViaC, 1.7000000000000002).
score(pathB, 13.0).
score(pathC, 21.0).
score(pathRelay, 14.0).
score(pathDirectC, 14.5).
score(pathViaC, 24.5).
edgeCount(pathB, 2).
edgeCount(pathC, 2).
edgeCount(pathRelay, 2).
edgeCount(pathDirectC, 1).
edgeCount(pathViaC, 3).
selectedPath(case, pathB).
trustGate(case, noEnumeratedPathIsLower).
notes(case, riskCanOutweighRawCost).
selects(dijkstraRiskPath, pathB).

clause(1,
       route_network(riskNetwork, (segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05)))),
       true).
clause(2,
       context_member((var('Left'), anonymous(1)), var('Member')),
       context_member(var('Left'), var('Member'))).
clause(3,
       context_member((anonymous(1), var('Right')), var('Member')),
       context_member(var('Right'), var('Member'))).
clause(4,
       context_member(var('Member'), var('Member')),
       var('Member') \= (anonymous(1), anonymous(2))).
clause(5,
       route_segment(var('From'), var('To'), var('Raw'), var('Risk')),
       (route_network(riskNetwork, var('Context')),
        context_member(var('Context'), segment(var('From'), segment(var('To'), var('Raw'), var('Risk')))))).
clause(6, candidate(pathB, [depotA, depotB, labD]), true).
clause(7, candidate(pathC, [depotA, depotC, labD]), true).
clause(8, candidate(pathRelay, [depotA, relay, labD]), true).
clause(9, candidate(pathDirectC, [depotA, labD]), true).
clause(10, candidate(pathViaC, [depotA, depotC, depotB, labD]), true).
clause(11, route_cost([anonymous(1)], 0.0, 0.0, 0), true).
clause(12,
       route_cost([var('From'), var('To') | var('Rest')], var('Raw'), var('Risk'), var('Edges')),
       (route_segment(var('From'), var('To'), var('Stepraw'), var('Steprisk')),
        route_cost([var('To') | var('Rest')], var('Restraw'), var('Restrisk'), var('Restedges')),
        var('Raw') is var('Stepraw') + var('Restraw'),
        var('Risk') is var('Steprisk') + var('Restrisk'),
        var('Edges') is 1 + var('Restedges'))).
clause(13,
       score(var('Raw'), var('Risk'), var('Score')),
       (var('Penalty') is var('Risk') * 10.0, var('Score') is var('Raw') + var('Penalty'))).
clause(14,
       path_metrics(var('Path'), var('Route'), var('Raw'), var('Risk'), var('Score'), var('Edges')),
       (candidate(var('Path'), var('Route')),
        route_cost(var('Route'), var('Raw'), var('Risk'), var('Edges')),
        score(var('Raw'), var('Risk'), var('Score')))).
clause(15,
       best_path(pathB),
       (path_metrics(pathB, anonymous(1), anonymous(2), anonymous(3), var('Bestscore'), anonymous(4)),
        path_metrics(pathC, anonymous(5), anonymous(6), anonymous(7), var('Cscore'), anonymous(8)),
        path_metrics(pathRelay, anonymous(9), anonymous(10), anonymous(11), var('Relayscore'), anonymous(12)),
        path_metrics(pathDirectC, anonymous(13), anonymous(14), anonymous(15), var('Directscore'), anonymous(16)),
        path_metrics(pathViaC, anonymous(17), anonymous(18), anonymous(19), var('Viascore'), anonymous(20)),
        var('Bestscore') < var('Cscore'),
        var('Bestscore') < var('Relayscore'),
        var('Bestscore') < var('Directscore'),
        var('Bestscore') < var('Viascore'))).
clause(16,
       risk_outweighs_raw_cost(true),
       (path_metrics(pathB, anonymous(1), var('Bestraw'), anonymous(2), var('Bestscore'), anonymous(3)),
        path_metrics(pathViaC, anonymous(4), var('Viaraw'), anonymous(5), var('Viascore'), anonymous(6)),
        var('Viaraw') < var('Bestraw'),
        var('Bestscore') < var('Viascore'))).
clause(17,
       route(var('Path'), var('Route')),
       path_metrics(var('Path'), var('Route'), anonymous(1), anonymous(2), anonymous(3), anonymous(4))).
clause(18,
       rawCost(var('Path'), var('Raw')),
       path_metrics(var('Path'), anonymous(1), var('Raw'), anonymous(2), anonymous(3), anonymous(4))).
clause(19,
       riskSum(var('Path'), var('Risk')),
       path_metrics(var('Path'), anonymous(1), anonymous(2), var('Risk'), anonymous(3), anonymous(4))).
clause(20,
       score(var('Path'), var('Score')),
       path_metrics(var('Path'), anonymous(1), anonymous(2), anonymous(3), var('Score'), anonymous(4))).
clause(21,
       edgeCount(var('Path'), var('Edges')),
       path_metrics(var('Path'), anonymous(1), anonymous(2), anonymous(3), anonymous(4), var('Edges'))).
clause(22, selectedPath(case, var('Path')), best_path(var('Path'))).
clause(23, trustGate(case, noEnumeratedPathIsLower), best_path(anonymous(1))).
clause(24, notes(case, riskCanOutweighRawCost), risk_outweighs_raw_cost(true)).
clause(25,
       selects(dijkstraRiskPath, var('Path')),
       (best_path(var('Path')), risk_outweighs_raw_cost(true))).

step(route(pathB, [depotA, depotB, labD]),
     rule(17),
     ['Path' = pathB, 'Route' = [depotA, depotB, labD]],
     [path_metrics(pathB, [depotA, depotB, labD], 8.0, 0.5, 13.0, 2)]).
step(path_metrics(pathB, [depotA, depotB, labD], 8.0, 0.5, 13.0, 2),
     rule(14),
     ['Path' = pathB,
      'Route' = [depotA, depotB, labD],
      'Raw' = 8.0,
      'Risk' = 0.5,
      'Score' = 13.0,
      'Edges' = 2],
     [candidate(pathB, [depotA, depotB, labD]),
      route_cost([depotA, depotB, labD], 8.0, 0.5, 2),
      score(8.0, 0.5, 13.0)]).
step(candidate(pathB, [depotA, depotB, labD]), fact(6), [], []).
step(route_cost([depotA, depotB, labD], 8.0, 0.5, 2),
     rule(12),
     ['From' = depotA,
      'To' = depotB,
      'Rest' = [labD],
      'Raw' = 8.0,
      'Risk' = 0.5,
      'Edges' = 2,
      'Stepraw' = 4.0,
      'Steprisk' = 0.2,
      'Restraw' = 4.0,
      'Restrisk' = 0.3,
      'Restedges' = 1],
     [route_segment(depotA, depotB, 4.0, 0.2),
      route_cost([depotB, labD], 4.0, 0.3, 1),
      8.0 is 4.0 + 4.0,
      0.5 is 0.2 + 0.3,
      2 is 1 + 1]).
step(route_segment(depotA, depotB, 4.0, 0.2),
     rule(5),
     ['From' = depotA,
      'To' = depotB,
      'Raw' = 4.0,
      'Risk' = 0.2,
      'Context' = (segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05)))],
     [route_network(riskNetwork, (segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05)))),
      context_member((segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(depotB, 4.0, 0.2)))]).
step(route_network(riskNetwork, (segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05)))),
     fact(1),
     [],
     []).
step(context_member((segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(depotB, 4.0, 0.2))),
     rule(2),
     ['Left' = segment(depotA, segment(depotB, 4.0, 0.2)),
      'Member' = segment(depotA, segment(depotB, 4.0, 0.2))],
     [context_member(segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotA, segment(depotB, 4.0, 0.2)))]).
step(context_member(segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotA, segment(depotB, 4.0, 0.2))),
     rule(4),
     ['Member' = segment(depotA, segment(depotB, 4.0, 0.2))],
     [segment(depotA, segment(depotB, 4.0, 0.2)) \= (_left, _right)]).
step(segment(depotA, segment(depotB, 4.0, 0.2)) \= (_left, _right), builtin, [], []).
step(route_cost([depotB, labD], 4.0, 0.3, 1),
     rule(12),
     ['From' = depotB,
      'To' = labD,
      'Rest' = [],
      'Raw' = 4.0,
      'Risk' = 0.3,
      'Edges' = 1,
      'Stepraw' = 4.0,
      'Steprisk' = 0.3,
      'Restraw' = 0.0,
      'Restrisk' = 0.0,
      'Restedges' = 0],
     [route_segment(depotB, labD, 4.0, 0.3),
      route_cost([labD], 0.0, 0.0, 0),
      4.0 is 4.0 + 0.0,
      0.3 is 0.3 + 0.0,
      1 is 1 + 0]).
step(route_segment(depotB, labD, 4.0, 0.3),
     rule(5),
     ['From' = depotB,
      'To' = labD,
      'Raw' = 4.0,
      'Risk' = 0.3,
      'Context' = (segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05)))],
     [route_network(riskNetwork, (segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05)))),
      context_member((segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotB, segment(labD, 4.0, 0.3)))]).
step(context_member((segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotB, segment(labD, 4.0, 0.3))),
     rule(3),
     ['Right' = (segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(depotB, segment(labD, 4.0, 0.3))],
     [context_member((segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotB, segment(labD, 4.0, 0.3)))]).
step(context_member((segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotB, segment(labD, 4.0, 0.3))),
     rule(2),
     ['Left' = segment(depotB, segment(labD, 4.0, 0.3)),
      'Member' = segment(depotB, segment(labD, 4.0, 0.3))],
     [context_member(segment(depotB, segment(labD, 4.0, 0.3)), segment(depotB, segment(labD, 4.0, 0.3)))]).
step(context_member(segment(depotB, segment(labD, 4.0, 0.3)), segment(depotB, segment(labD, 4.0, 0.3))),
     rule(4),
     ['Member' = segment(depotB, segment(labD, 4.0, 0.3))],
     [segment(depotB, segment(labD, 4.0, 0.3)) \= (_left, _right)]).
step(segment(depotB, segment(labD, 4.0, 0.3)) \= (_left, _right), builtin, [], []).
step(route_cost([labD], 0.0, 0.0, 0), fact(11), [], []).
step(4.0 is 4.0 + 0.0, builtin, [], []).
step(0.3 is 0.3 + 0.0, builtin, [], []).
step(1 is 1 + 0, builtin, [], []).
step(8.0 is 4.0 + 4.0, builtin, [], []).
step(0.5 is 0.2 + 0.3, builtin, [], []).
step(2 is 1 + 1, builtin, [], []).
step(score(8.0, 0.5, 13.0),
     rule(13),
     ['Raw' = 8.0, 'Risk' = 0.5, 'Score' = 13.0, 'Penalty' = 5.0],
     [5.0 is 0.5 * 10.0, 13.0 is 8.0 + 5.0]).
step(5.0 is 0.5 * 10.0, builtin, [], []).
step(13.0 is 8.0 + 5.0, builtin, [], []).
step(route(pathC, [depotA, depotC, labD]),
     rule(17),
     ['Path' = pathC, 'Route' = [depotA, depotC, labD]],
     [path_metrics(pathC, [depotA, depotC, labD], 9.0, 1.2, 21.0, 2)]).
step(path_metrics(pathC, [depotA, depotC, labD], 9.0, 1.2, 21.0, 2),
     rule(14),
     ['Path' = pathC,
      'Route' = [depotA, depotC, labD],
      'Raw' = 9.0,
      'Risk' = 1.2,
      'Score' = 21.0,
      'Edges' = 2],
     [candidate(pathC, [depotA, depotC, labD]),
      route_cost([depotA, depotC, labD], 9.0, 1.2, 2),
      score(9.0, 1.2, 21.0)]).
step(candidate(pathC, [depotA, depotC, labD]), fact(7), [], []).
step(route_cost([depotA, depotC, labD], 9.0, 1.2, 2),
     rule(12),
     ['From' = depotA,
      'To' = depotC,
      'Rest' = [labD],
      'Raw' = 9.0,
      'Risk' = 1.2,
      'Edges' = 2,
      'Stepraw' = 3.0,
      'Steprisk' = 0.9,
      'Restraw' = 6.0,
      'Restrisk' = 0.3,
      'Restedges' = 1],
     [route_segment(depotA, depotC, 3.0, 0.9),
      route_cost([depotC, labD], 6.0, 0.3, 1),
      9.0 is 3.0 + 6.0,
      1.2 is 0.9 + 0.3,
      2 is 1 + 1]).
step(route_segment(depotA, depotC, 3.0, 0.9),
     rule(5),
     ['From' = depotA,
      'To' = depotC,
      'Raw' = 3.0,
      'Risk' = 0.9,
      'Context' = (segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05)))],
     [route_network(riskNetwork, (segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05)))),
      context_member((segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(depotC, 3.0, 0.9)))]).
step(context_member((segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(depotC, 3.0, 0.9))),
     rule(3),
     ['Right' = (segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(depotA, segment(depotC, 3.0, 0.9))],
     [context_member((segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(depotC, 3.0, 0.9)))]).
step(context_member((segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(depotC, 3.0, 0.9))),
     rule(3),
     ['Right' = (segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(depotA, segment(depotC, 3.0, 0.9))],
     [context_member((segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(depotC, 3.0, 0.9)))]).
step(context_member((segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(depotC, 3.0, 0.9))),
     rule(2),
     ['Left' = segment(depotA, segment(depotC, 3.0, 0.9)),
      'Member' = segment(depotA, segment(depotC, 3.0, 0.9))],
     [context_member(segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotA, segment(depotC, 3.0, 0.9)))]).
step(context_member(segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotA, segment(depotC, 3.0, 0.9))),
     rule(4),
     ['Member' = segment(depotA, segment(depotC, 3.0, 0.9))],
     [segment(depotA, segment(depotC, 3.0, 0.9)) \= (_left, _right)]).
step(segment(depotA, segment(depotC, 3.0, 0.9)) \= (_left, _right), builtin, [], []).
step(route_cost([depotC, labD], 6.0, 0.3, 1),
     rule(12),
     ['From' = depotC,
      'To' = labD,
      'Rest' = [],
      'Raw' = 6.0,
      'Risk' = 0.3,
      'Edges' = 1,
      'Stepraw' = 6.0,
      'Steprisk' = 0.3,
      'Restraw' = 0.0,
      'Restrisk' = 0.0,
      'Restedges' = 0],
     [route_segment(depotC, labD, 6.0, 0.3),
      route_cost([labD], 0.0, 0.0, 0),
      6.0 is 6.0 + 0.0,
      0.3 is 0.3 + 0.0,
      1 is 1 + 0]).
step(route_segment(depotC, labD, 6.0, 0.3),
     rule(5),
     ['From' = depotC,
      'To' = labD,
      'Raw' = 6.0,
      'Risk' = 0.3,
      'Context' = (segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05)))],
     [route_network(riskNetwork, (segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05)))),
      context_member((segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotC, segment(labD, 6.0, 0.3)))]).
step(context_member((segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotC, segment(labD, 6.0, 0.3))),
     rule(3),
     ['Right' = (segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(depotC, segment(labD, 6.0, 0.3))],
     [context_member((segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotC, segment(labD, 6.0, 0.3)))]).
step(context_member((segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotC, segment(labD, 6.0, 0.3))),
     rule(3),
     ['Right' = (segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(depotC, segment(labD, 6.0, 0.3))],
     [context_member((segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotC, segment(labD, 6.0, 0.3)))]).
step(context_member((segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotC, segment(labD, 6.0, 0.3))),
     rule(3),
     ['Right' = (segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(depotC, segment(labD, 6.0, 0.3))],
     [context_member((segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotC, segment(labD, 6.0, 0.3)))]).
step(context_member((segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotC, segment(labD, 6.0, 0.3))),
     rule(2),
     ['Left' = segment(depotC, segment(labD, 6.0, 0.3)),
      'Member' = segment(depotC, segment(labD, 6.0, 0.3))],
     [context_member(segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(labD, 6.0, 0.3)))]).
step(context_member(segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(labD, 6.0, 0.3))),
     rule(4),
     ['Member' = segment(depotC, segment(labD, 6.0, 0.3))],
     [segment(depotC, segment(labD, 6.0, 0.3)) \= (_left, _right)]).
step(segment(depotC, segment(labD, 6.0, 0.3)) \= (_left, _right), builtin, [], []).
step(6.0 is 6.0 + 0.0, builtin, [], []).
step(9.0 is 3.0 + 6.0, builtin, [], []).
step(1.2 is 0.9 + 0.3, builtin, [], []).
step(score(9.0, 1.2, 21.0),
     rule(13),
     ['Raw' = 9.0, 'Risk' = 1.2, 'Score' = 21.0, 'Penalty' = 12.0],
     [12.0 is 1.2 * 10.0, 21.0 is 9.0 + 12.0]).
step(12.0 is 1.2 * 10.0, builtin, [], []).
step(21.0 is 9.0 + 12.0, builtin, [], []).
step(route(pathRelay, [depotA, relay, labD]),
     rule(17),
     ['Path' = pathRelay, 'Route' = [depotA, relay, labD]],
     [path_metrics(pathRelay, [depotA, relay, labD], 10.0, 0.4, 14.0, 2)]).
step(path_metrics(pathRelay, [depotA, relay, labD], 10.0, 0.4, 14.0, 2),
     rule(14),
     ['Path' = pathRelay,
      'Route' = [depotA, relay, labD],
      'Raw' = 10.0,
      'Risk' = 0.4,
      'Score' = 14.0,
      'Edges' = 2],
     [candidate(pathRelay, [depotA, relay, labD]),
      route_cost([depotA, relay, labD], 10.0, 0.4, 2),
      score(10.0, 0.4, 14.0)]).
step(candidate(pathRelay, [depotA, relay, labD]), fact(8), [], []).
step(route_cost([depotA, relay, labD], 10.0, 0.4, 2),
     rule(12),
     ['From' = depotA,
      'To' = relay,
      'Rest' = [labD],
      'Raw' = 10.0,
      'Risk' = 0.4,
      'Edges' = 2,
      'Stepraw' = 5.0,
      'Steprisk' = 0.2,
      'Restraw' = 5.0,
      'Restrisk' = 0.2,
      'Restedges' = 1],
     [route_segment(depotA, relay, 5.0, 0.2),
      route_cost([relay, labD], 5.0, 0.2, 1),
      10.0 is 5.0 + 5.0,
      0.4 is 0.2 + 0.2,
      2 is 1 + 1]).
step(route_segment(depotA, relay, 5.0, 0.2),
     rule(5),
     ['From' = depotA,
      'To' = relay,
      'Raw' = 5.0,
      'Risk' = 0.2,
      'Context' = (segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05)))],
     [route_network(riskNetwork, (segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05)))),
      context_member((segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(relay, 5.0, 0.2)))]).
step(context_member((segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(relay, 5.0, 0.2))),
     rule(3),
     ['Right' = (segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(depotA, segment(relay, 5.0, 0.2))],
     [context_member((segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(relay, 5.0, 0.2)))]).
step(context_member((segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(relay, 5.0, 0.2))),
     rule(3),
     ['Right' = (segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(depotA, segment(relay, 5.0, 0.2))],
     [context_member((segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(relay, 5.0, 0.2)))]).
step(context_member((segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(relay, 5.0, 0.2))),
     rule(3),
     ['Right' = (segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(depotA, segment(relay, 5.0, 0.2))],
     [context_member((segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(relay, 5.0, 0.2)))]).
step(context_member((segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(relay, 5.0, 0.2))),
     rule(3),
     ['Right' = (segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(depotA, segment(relay, 5.0, 0.2))],
     [context_member((segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(relay, 5.0, 0.2)))]).
step(context_member((segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(relay, 5.0, 0.2))),
     rule(3),
     ['Right' = (segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(depotA, segment(relay, 5.0, 0.2))],
     [context_member((segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(relay, 5.0, 0.2)))]).
step(context_member((segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(relay, 5.0, 0.2))),
     rule(3),
     ['Right' = (segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(depotA, segment(relay, 5.0, 0.2))],
     [context_member((segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(relay, 5.0, 0.2)))]).
step(context_member((segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(relay, 5.0, 0.2))),
     rule(2),
     ['Left' = segment(depotA, segment(relay, 5.0, 0.2)),
      'Member' = segment(depotA, segment(relay, 5.0, 0.2))],
     [context_member(segment(depotA, segment(relay, 5.0, 0.2)), segment(depotA, segment(relay, 5.0, 0.2)))]).
step(context_member(segment(depotA, segment(relay, 5.0, 0.2)), segment(depotA, segment(relay, 5.0, 0.2))),
     rule(4),
     ['Member' = segment(depotA, segment(relay, 5.0, 0.2))],
     [segment(depotA, segment(relay, 5.0, 0.2)) \= (_left, _right)]).
step(segment(depotA, segment(relay, 5.0, 0.2)) \= (_left, _right), builtin, [], []).
step(route_cost([relay, labD], 5.0, 0.2, 1),
     rule(12),
     ['From' = relay,
      'To' = labD,
      'Rest' = [],
      'Raw' = 5.0,
      'Risk' = 0.2,
      'Edges' = 1,
      'Stepraw' = 5.0,
      'Steprisk' = 0.2,
      'Restraw' = 0.0,
      'Restrisk' = 0.0,
      'Restedges' = 0],
     [route_segment(relay, labD, 5.0, 0.2),
      route_cost([labD], 0.0, 0.0, 0),
      5.0 is 5.0 + 0.0,
      0.2 is 0.2 + 0.0,
      1 is 1 + 0]).
step(route_segment(relay, labD, 5.0, 0.2),
     rule(5),
     ['From' = relay,
      'To' = labD,
      'Raw' = 5.0,
      'Risk' = 0.2,
      'Context' = (segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05)))],
     [route_network(riskNetwork, (segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05)))),
      context_member((segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(relay, segment(labD, 5.0, 0.2)))]).
step(context_member((segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(relay, segment(labD, 5.0, 0.2))),
     rule(3),
     ['Right' = (segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(relay, segment(labD, 5.0, 0.2))],
     [context_member((segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(relay, segment(labD, 5.0, 0.2)))]).
step(context_member((segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(relay, segment(labD, 5.0, 0.2))),
     rule(3),
     ['Right' = (segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(relay, segment(labD, 5.0, 0.2))],
     [context_member((segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(relay, segment(labD, 5.0, 0.2)))]).
step(context_member((segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(relay, segment(labD, 5.0, 0.2))),
     rule(3),
     ['Right' = (segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(relay, segment(labD, 5.0, 0.2))],
     [context_member((segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(relay, segment(labD, 5.0, 0.2)))]).
step(context_member((segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(relay, segment(labD, 5.0, 0.2))),
     rule(3),
     ['Right' = (segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(relay, segment(labD, 5.0, 0.2))],
     [context_member((segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(relay, segment(labD, 5.0, 0.2)))]).
step(context_member((segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(relay, segment(labD, 5.0, 0.2))),
     rule(3),
     ['Right' = (segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(relay, segment(labD, 5.0, 0.2))],
     [context_member((segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(relay, segment(labD, 5.0, 0.2)))]).
step(context_member((segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(relay, segment(labD, 5.0, 0.2))),
     rule(3),
     ['Right' = (segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(relay, segment(labD, 5.0, 0.2))],
     [context_member((segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(relay, segment(labD, 5.0, 0.2)))]).
step(context_member((segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(relay, segment(labD, 5.0, 0.2))),
     rule(3),
     ['Right' = (segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(relay, segment(labD, 5.0, 0.2))],
     [context_member((segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(relay, segment(labD, 5.0, 0.2)))]).
step(context_member((segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(relay, segment(labD, 5.0, 0.2))),
     rule(2),
     ['Left' = segment(relay, segment(labD, 5.0, 0.2)),
      'Member' = segment(relay, segment(labD, 5.0, 0.2))],
     [context_member(segment(relay, segment(labD, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)))]).
step(context_member(segment(relay, segment(labD, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2))),
     rule(4),
     ['Member' = segment(relay, segment(labD, 5.0, 0.2))],
     [segment(relay, segment(labD, 5.0, 0.2)) \= (_left, _right)]).
step(segment(relay, segment(labD, 5.0, 0.2)) \= (_left, _right), builtin, [], []).
step(5.0 is 5.0 + 0.0, builtin, [], []).
step(0.2 is 0.2 + 0.0, builtin, [], []).
step(10.0 is 5.0 + 5.0, builtin, [], []).
step(0.4 is 0.2 + 0.2, builtin, [], []).
step(score(10.0, 0.4, 14.0),
     rule(13),
     ['Raw' = 10.0, 'Risk' = 0.4, 'Score' = 14.0, 'Penalty' = 4.0],
     [4.0 is 0.4 * 10.0, 14.0 is 10.0 + 4.0]).
step(4.0 is 0.4 * 10.0, builtin, [], []).
step(14.0 is 10.0 + 4.0, builtin, [], []).
step(route(pathDirectC, [depotA, labD]),
     rule(17),
     ['Path' = pathDirectC, 'Route' = [depotA, labD]],
     [path_metrics(pathDirectC, [depotA, labD], 14.0, 0.05, 14.5, 1)]).
step(path_metrics(pathDirectC, [depotA, labD], 14.0, 0.05, 14.5, 1),
     rule(14),
     ['Path' = pathDirectC,
      'Route' = [depotA, labD],
      'Raw' = 14.0,
      'Risk' = 0.05,
      'Score' = 14.5,
      'Edges' = 1],
     [candidate(pathDirectC, [depotA, labD]),
      route_cost([depotA, labD], 14.0, 0.05, 1),
      score(14.0, 0.05, 14.5)]).
step(candidate(pathDirectC, [depotA, labD]), fact(9), [], []).
step(route_cost([depotA, labD], 14.0, 0.05, 1),
     rule(12),
     ['From' = depotA,
      'To' = labD,
      'Rest' = [],
      'Raw' = 14.0,
      'Risk' = 0.05,
      'Edges' = 1,
      'Stepraw' = 14.0,
      'Steprisk' = 0.05,
      'Restraw' = 0.0,
      'Restrisk' = 0.0,
      'Restedges' = 0],
     [route_segment(depotA, labD, 14.0, 0.05),
      route_cost([labD], 0.0, 0.0, 0),
      14.0 is 14.0 + 0.0,
      0.05 is 0.05 + 0.0,
      1 is 1 + 0]).
step(route_segment(depotA, labD, 14.0, 0.05),
     rule(5),
     ['From' = depotA,
      'To' = labD,
      'Raw' = 14.0,
      'Risk' = 0.05,
      'Context' = (segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05)))],
     [route_network(riskNetwork, (segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05)))),
      context_member((segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(labD, 14.0, 0.05)))]).
step(context_member((segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(labD, 14.0, 0.05))),
     rule(3),
     ['Right' = (segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(depotA, segment(labD, 14.0, 0.05))],
     [context_member((segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(labD, 14.0, 0.05)))]).
step(context_member((segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(labD, 14.0, 0.05))),
     rule(3),
     ['Right' = (segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(depotA, segment(labD, 14.0, 0.05))],
     [context_member((segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(labD, 14.0, 0.05)))]).
step(context_member((segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(labD, 14.0, 0.05))),
     rule(3),
     ['Right' = (segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(depotA, segment(labD, 14.0, 0.05))],
     [context_member((segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(labD, 14.0, 0.05)))]).
step(context_member((segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(labD, 14.0, 0.05))),
     rule(3),
     ['Right' = (segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(depotA, segment(labD, 14.0, 0.05))],
     [context_member((segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(labD, 14.0, 0.05)))]).
step(context_member((segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(labD, 14.0, 0.05))),
     rule(3),
     ['Right' = (segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(depotA, segment(labD, 14.0, 0.05))],
     [context_member((segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(labD, 14.0, 0.05)))]).
step(context_member((segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(labD, 14.0, 0.05))),
     rule(3),
     ['Right' = (segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(depotA, segment(labD, 14.0, 0.05))],
     [context_member((segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(labD, 14.0, 0.05)))]).
step(context_member((segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(labD, 14.0, 0.05))),
     rule(3),
     ['Right' = (segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(depotA, segment(labD, 14.0, 0.05))],
     [context_member((segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(labD, 14.0, 0.05)))]).
step(context_member((segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotA, segment(labD, 14.0, 0.05))),
     rule(3),
     ['Right' = segment(depotA, segment(labD, 14.0, 0.05)),
      'Member' = segment(depotA, segment(labD, 14.0, 0.05))],
     [context_member(segment(depotA, segment(labD, 14.0, 0.05)), segment(depotA, segment(labD, 14.0, 0.05)))]).
step(context_member(segment(depotA, segment(labD, 14.0, 0.05)), segment(depotA, segment(labD, 14.0, 0.05))),
     rule(4),
     ['Member' = segment(depotA, segment(labD, 14.0, 0.05))],
     [segment(depotA, segment(labD, 14.0, 0.05)) \= (_left, _right)]).
step(segment(depotA, segment(labD, 14.0, 0.05)) \= (_left, _right), builtin, [], []).
step(14.0 is 14.0 + 0.0, builtin, [], []).
step(0.05 is 0.05 + 0.0, builtin, [], []).
step(score(14.0, 0.05, 14.5),
     rule(13),
     ['Raw' = 14.0, 'Risk' = 0.05, 'Score' = 14.5, 'Penalty' = 0.5],
     [0.5 is 0.05 * 10.0, 14.5 is 14.0 + 0.5]).
step(0.5 is 0.05 * 10.0, builtin, [], []).
step(14.5 is 14.0 + 0.5, builtin, [], []).
step(route(pathViaC, [depotA, depotC, depotB, labD]),
     rule(17),
     ['Path' = pathViaC, 'Route' = [depotA, depotC, depotB, labD]],
     [path_metrics(pathViaC, [depotA, depotC, depotB, labD], 7.5, 1.7000000000000002, 24.5, 3)]).
step(path_metrics(pathViaC, [depotA, depotC, depotB, labD], 7.5, 1.7000000000000002, 24.5, 3),
     rule(14),
     ['Path' = pathViaC,
      'Route' = [depotA, depotC, depotB, labD],
      'Raw' = 7.5,
      'Risk' = 1.7000000000000002,
      'Score' = 24.5,
      'Edges' = 3],
     [candidate(pathViaC, [depotA, depotC, depotB, labD]),
      route_cost([depotA, depotC, depotB, labD], 7.5, 1.7000000000000002, 3),
      score(7.5, 1.7000000000000002, 24.5)]).
step(candidate(pathViaC, [depotA, depotC, depotB, labD]), fact(10), [], []).
step(route_cost([depotA, depotC, depotB, labD], 7.5, 1.7000000000000002, 3),
     rule(12),
     ['From' = depotA,
      'To' = depotC,
      'Rest' = [depotB, labD],
      'Raw' = 7.5,
      'Risk' = 1.7000000000000002,
      'Edges' = 3,
      'Stepraw' = 3.0,
      'Steprisk' = 0.9,
      'Restraw' = 4.5,
      'Restrisk' = 0.8,
      'Restedges' = 2],
     [route_segment(depotA, depotC, 3.0, 0.9),
      route_cost([depotC, depotB, labD], 4.5, 0.8, 2),
      7.5 is 3.0 + 4.5,
      1.7000000000000002 is 0.9 + 0.8,
      3 is 1 + 2]).
step(route_cost([depotC, depotB, labD], 4.5, 0.8, 2),
     rule(12),
     ['From' = depotC,
      'To' = depotB,
      'Rest' = [labD],
      'Raw' = 4.5,
      'Risk' = 0.8,
      'Edges' = 2,
      'Stepraw' = 0.5,
      'Steprisk' = 0.5,
      'Restraw' = 4.0,
      'Restrisk' = 0.3,
      'Restedges' = 1],
     [route_segment(depotC, depotB, 0.5, 0.5),
      route_cost([depotB, labD], 4.0, 0.3, 1),
      4.5 is 0.5 + 4.0,
      0.8 is 0.5 + 0.3,
      2 is 1 + 1]).
step(route_segment(depotC, depotB, 0.5, 0.5),
     rule(5),
     ['From' = depotC,
      'To' = depotB,
      'Raw' = 0.5,
      'Risk' = 0.5,
      'Context' = (segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05)))],
     [route_network(riskNetwork, (segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05)))),
      context_member((segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotC, segment(depotB, 0.5, 0.5)))]).
step(context_member((segment(depotA, segment(depotB, 4.0, 0.2)), segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotC, segment(depotB, 0.5, 0.5))),
     rule(3),
     ['Right' = (segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(depotC, segment(depotB, 0.5, 0.5))],
     [context_member((segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotC, segment(depotB, 0.5, 0.5)))]).
step(context_member((segment(depotB, segment(labD, 4.0, 0.3)), segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotC, segment(depotB, 0.5, 0.5))),
     rule(3),
     ['Right' = (segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(depotC, segment(depotB, 0.5, 0.5))],
     [context_member((segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotC, segment(depotB, 0.5, 0.5)))]).
step(context_member((segment(depotA, segment(depotC, 3.0, 0.9)), segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotC, segment(depotB, 0.5, 0.5))),
     rule(3),
     ['Right' = (segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(depotC, segment(depotB, 0.5, 0.5))],
     [context_member((segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotC, segment(depotB, 0.5, 0.5)))]).
step(context_member((segment(depotC, segment(labD, 6.0, 0.3)), segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotC, segment(depotB, 0.5, 0.5))),
     rule(3),
     ['Right' = (segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))),
      'Member' = segment(depotC, segment(depotB, 0.5, 0.5))],
     [context_member((segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotC, segment(depotB, 0.5, 0.5)))]).
step(context_member((segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotB, segment(depotC, 1.0, 0.5)), segment(depotA, segment(relay, 5.0, 0.2)), segment(relay, segment(labD, 5.0, 0.2)), segment(depotA, segment(labD, 14.0, 0.05))), segment(depotC, segment(depotB, 0.5, 0.5))),
     rule(2),
     ['Left' = segment(depotC, segment(depotB, 0.5, 0.5)),
      'Member' = segment(depotC, segment(depotB, 0.5, 0.5))],
     [context_member(segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotC, segment(depotB, 0.5, 0.5)))]).
step(context_member(segment(depotC, segment(depotB, 0.5, 0.5)), segment(depotC, segment(depotB, 0.5, 0.5))),
     rule(4),
     ['Member' = segment(depotC, segment(depotB, 0.5, 0.5))],
     [segment(depotC, segment(depotB, 0.5, 0.5)) \= (_left, _right)]).
step(segment(depotC, segment(depotB, 0.5, 0.5)) \= (_left, _right), builtin, [], []).
step(4.5 is 0.5 + 4.0, builtin, [], []).
step(0.8 is 0.5 + 0.3, builtin, [], []).
step(7.5 is 3.0 + 4.5, builtin, [], []).
step(1.7000000000000002 is 0.9 + 0.8, builtin, [], []).
step(3 is 1 + 2, builtin, [], []).
step(score(7.5, 1.7000000000000002, 24.5),
     rule(13),
     ['Raw' = 7.5, 'Risk' = 1.7000000000000002, 'Score' = 24.5, 'Penalty' = 17.0],
     [17.0 is 1.7000000000000002 * 10.0, 24.5 is 7.5 + 17.0]).
step(17.0 is 1.7000000000000002 * 10.0, builtin, [], []).
step(24.5 is 7.5 + 17.0, builtin, [], []).
step(rawCost(pathB, 8.0),
     rule(18),
     ['Path' = pathB, 'Raw' = 8.0],
     [path_metrics(pathB, [depotA, depotB, labD], 8.0, 0.5, 13.0, 2)]).
step(rawCost(pathC, 9.0),
     rule(18),
     ['Path' = pathC, 'Raw' = 9.0],
     [path_metrics(pathC, [depotA, depotC, labD], 9.0, 1.2, 21.0, 2)]).
step(rawCost(pathRelay, 10.0),
     rule(18),
     ['Path' = pathRelay, 'Raw' = 10.0],
     [path_metrics(pathRelay, [depotA, relay, labD], 10.0, 0.4, 14.0, 2)]).
step(rawCost(pathDirectC, 14.0),
     rule(18),
     ['Path' = pathDirectC, 'Raw' = 14.0],
     [path_metrics(pathDirectC, [depotA, labD], 14.0, 0.05, 14.5, 1)]).
step(rawCost(pathViaC, 7.5),
     rule(18),
     ['Path' = pathViaC, 'Raw' = 7.5],
     [path_metrics(pathViaC, [depotA, depotC, depotB, labD], 7.5, 1.7000000000000002, 24.5, 3)]).
step(riskSum(pathB, 0.5),
     rule(19),
     ['Path' = pathB, 'Risk' = 0.5],
     [path_metrics(pathB, [depotA, depotB, labD], 8.0, 0.5, 13.0, 2)]).
step(riskSum(pathC, 1.2),
     rule(19),
     ['Path' = pathC, 'Risk' = 1.2],
     [path_metrics(pathC, [depotA, depotC, labD], 9.0, 1.2, 21.0, 2)]).
step(riskSum(pathRelay, 0.4),
     rule(19),
     ['Path' = pathRelay, 'Risk' = 0.4],
     [path_metrics(pathRelay, [depotA, relay, labD], 10.0, 0.4, 14.0, 2)]).
step(riskSum(pathDirectC, 0.05),
     rule(19),
     ['Path' = pathDirectC, 'Risk' = 0.05],
     [path_metrics(pathDirectC, [depotA, labD], 14.0, 0.05, 14.5, 1)]).
step(riskSum(pathViaC, 1.7000000000000002),
     rule(19),
     ['Path' = pathViaC, 'Risk' = 1.7000000000000002],
     [path_metrics(pathViaC, [depotA, depotC, depotB, labD], 7.5, 1.7000000000000002, 24.5, 3)]).
step(score(pathB, 13.0),
     rule(20),
     ['Path' = pathB, 'Score' = 13.0],
     [path_metrics(pathB, [depotA, depotB, labD], 8.0, 0.5, 13.0, 2)]).
step(score(pathC, 21.0),
     rule(20),
     ['Path' = pathC, 'Score' = 21.0],
     [path_metrics(pathC, [depotA, depotC, labD], 9.0, 1.2, 21.0, 2)]).
step(score(pathRelay, 14.0),
     rule(20),
     ['Path' = pathRelay, 'Score' = 14.0],
     [path_metrics(pathRelay, [depotA, relay, labD], 10.0, 0.4, 14.0, 2)]).
step(score(pathDirectC, 14.5),
     rule(20),
     ['Path' = pathDirectC, 'Score' = 14.5],
     [path_metrics(pathDirectC, [depotA, labD], 14.0, 0.05, 14.5, 1)]).
step(score(pathViaC, 24.5),
     rule(20),
     ['Path' = pathViaC, 'Score' = 24.5],
     [path_metrics(pathViaC, [depotA, depotC, depotB, labD], 7.5, 1.7000000000000002, 24.5, 3)]).
step(edgeCount(pathB, 2),
     rule(21),
     ['Path' = pathB, 'Edges' = 2],
     [path_metrics(pathB, [depotA, depotB, labD], 8.0, 0.5, 13.0, 2)]).
step(edgeCount(pathC, 2),
     rule(21),
     ['Path' = pathC, 'Edges' = 2],
     [path_metrics(pathC, [depotA, depotC, labD], 9.0, 1.2, 21.0, 2)]).
step(edgeCount(pathRelay, 2),
     rule(21),
     ['Path' = pathRelay, 'Edges' = 2],
     [path_metrics(pathRelay, [depotA, relay, labD], 10.0, 0.4, 14.0, 2)]).
step(edgeCount(pathDirectC, 1),
     rule(21),
     ['Path' = pathDirectC, 'Edges' = 1],
     [path_metrics(pathDirectC, [depotA, labD], 14.0, 0.05, 14.5, 1)]).
step(edgeCount(pathViaC, 3),
     rule(21),
     ['Path' = pathViaC, 'Edges' = 3],
     [path_metrics(pathViaC, [depotA, depotC, depotB, labD], 7.5, 1.7000000000000002, 24.5, 3)]).
step(selectedPath(case, pathB), rule(22), ['Path' = pathB], [best_path(pathB)]).
step(best_path(pathB),
     rule(15),
     ['Bestscore' = 13.0,
      'Cscore' = 21.0,
      'Relayscore' = 14.0,
      'Directscore' = 14.5,
      'Viascore' = 24.5],
     [path_metrics(pathB, [depotA, depotB, labD], 8.0, 0.5, 13.0, 2),
      path_metrics(pathC, [depotA, depotC, labD], 9.0, 1.2, 21.0, 2),
      path_metrics(pathRelay, [depotA, relay, labD], 10.0, 0.4, 14.0, 2),
      path_metrics(pathDirectC, [depotA, labD], 14.0, 0.05, 14.5, 1),
      path_metrics(pathViaC, [depotA, depotC, depotB, labD], 7.5, 1.7000000000000002, 24.5, 3),
      13.0 < 21.0,
      13.0 < 14.0,
      13.0 < 14.5,
      13.0 < 24.5]).
step(13.0 < 21.0, builtin, [], []).
step(13.0 < 14.0, builtin, [], []).
step(13.0 < 14.5, builtin, [], []).
step(13.0 < 24.5, builtin, [], []).
step(trustGate(case, noEnumeratedPathIsLower), rule(23), [], [best_path(pathB)]).
step(notes(case, riskCanOutweighRawCost), rule(24), [], [risk_outweighs_raw_cost(true)]).
step(risk_outweighs_raw_cost(true),
     rule(16),
     ['Bestraw' = 8.0, 'Bestscore' = 13.0, 'Viaraw' = 7.5, 'Viascore' = 24.5],
     [path_metrics(pathB, [depotA, depotB, labD], 8.0, 0.5, 13.0, 2),
      path_metrics(pathViaC, [depotA, depotC, depotB, labD], 7.5, 1.7000000000000002, 24.5, 3),
      7.5 < 8.0,
      13.0 < 24.5]).
step(7.5 < 8.0, builtin, [], []).
step(selects(dijkstraRiskPath, pathB),
     rule(25),
     ['Path' = pathB],
     [best_path(pathB), risk_outweighs_raw_cost(true)]).
