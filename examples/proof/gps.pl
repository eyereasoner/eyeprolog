outcome(decision, "Take the direct route via Brugge.").
recommendedRoute(decision, routeDirect).
statement(check, c1, true).
statement(check, c2, true).
statement(check, c3, true).
statement(check, c4, true).
statement(check, c5, true).
label(routeDirect, "Gent -> Brugge -> Oostende").
label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende").
actionSequence(routeDirect, [drive_gent_brugge, drive_brugge_oostende]).
actionSequence(routeViaKortrijk, [drive_gent_kortrijk, drive_kortrijk_brugge, drive_brugge_oostende]).
durationSeconds(routeDirect, 2400.0).
durationSeconds(routeViaKortrijk, 4100.0).
cost(routeDirect, 0.01).
cost(routeViaKortrijk, 0.018).
belief(routeDirect, 0.9408).
belief(routeViaKortrijk, 0.903168).
comfort(routeDirect, 0.99).
comfort(routeViaKortrijk, 0.9801).
selectedRoute(report, route(routeDirect, [drive_gent_brugge, drive_brugge_oostende], 2400.0, 0.01, 0.9408, 0.99)).
comparison(report, dominates(routeDirect, routeViaKortrijk)).

clause(1,
       case_graph(caseGraph, (location(i1, gent), text(question, "Which route should we take from Gent to Oostende?"), label(routeDirect, "Gent -> Brugge -> Oostende"), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende"))),
       true).
clause(2,
       map_graph(mapBE, (gps_description(mapBE, description(location(var('S'), gent), true, location(var('S'), brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)), gps_description(mapBE, description(location(var('S'), gent), true, location(var('S'), kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(var('S'), kortrijk), true, location(var('S'), brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(var('S'), brugge), true, location(var('S'), oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0)))),
       true).
clause(3,
       context_member((var('Left'), anonymous(1)), var('Member')),
       context_member(var('Left'), var('Member'))).
clause(4,
       context_member((anonymous(1), var('Right')), var('Member')),
       context_member(var('Right'), var('Member'))).
clause(5,
       context_member(var('Member'), var('Member')),
       var('Member') \= (anonymous(1), anonymous(2))).
clause(6,
       case_statement(var('S'), var('P'), var('O')),
       (case_graph(caseGraph, var('Context')),
        context_member(var('Context'), var('Statement')),
        var('Statement') =.. [var('P'), var('S'), var('O')])).
clause(7,
       map_description(var('From'), var('To'), var('Action'), var('Duration'), var('Cost'), var('Belief'), var('Comfort')),
       (map_graph(mapBE, var('Context')),
        context_member(var('Context'), gps_description(mapBE, description(var('From'), true, var('To'), var('Action'), var('Duration'), var('Cost'), var('Belief'), var('Comfort')))))).
clause(8,
       path(var('From'), var('To'), [var('Action')], var('Duration'), var('Cost'), var('Belief'), var('Comfort')),
       map_description(var('From'), var('To'), var('Action'), var('Duration'), var('Cost'), var('Belief'), var('Comfort'))).
clause(9,
       path(var('From'), var('To'), var('Actions'), var('Duration'), var('Cost'), var('Belief'), var('Comfort')),
       (map_description(var('From'), var('Mid'), var('Action'), var('D1'), var('C1'), var('B1'), var('F1')),
        path(var('Mid'), var('To'), var('Restactions'), var('D2'), var('C2'), var('B2'), var('F2')),
        append([var('Action')], var('Restactions'), var('Actions')),
        var('Duration') is var('D1') + var('D2'),
        var('Cost') is var('C1') + var('C2'),
        var('Belief') is var('B1') * var('B2'),
        var('Comfort') is var('F1') * var('F2'))).
clause(10, traveller_start(i1, location(i1, gent)), true).
clause(11, traveller_goal(i1, location(i1, oostende)), true).
clause(12,
       traveller_path(var('Traveller'), var('Actions'), var('Duration'), var('Cost'), var('Belief'), var('Comfort')),
       (traveller_start(var('Traveller'), var('From')),
        traveller_goal(var('Traveller'), var('To')),
        path(var('From'), var('To'), var('Actions'), var('Duration'), var('Cost'), var('Belief'), var('Comfort')))).
clause(13,
       route_metrics(routeDirect, var('Duration'), var('Cost'), var('Belief'), var('Comfort')),
       traveller_path(i1, [drive_gent_brugge, drive_brugge_oostende], var('Duration'), var('Cost'), var('Belief'), var('Comfort'))).
clause(14,
       route_metrics(routeViaKortrijk, var('Duration'), var('Cost'), var('Belief'), var('Comfort')),
       traveller_path(i1, [drive_gent_kortrijk, drive_kortrijk_brugge, drive_brugge_oostende], var('Duration'), var('Cost'), var('Belief'), var('Comfort'))).
clause(15,
       recommended_route(routeDirect),
       (route_metrics(routeDirect, var('Directduration'), var('Directcost'), var('Directbelief'), var('Directcomfort')),
        route_metrics(routeViaKortrijk, var('Viaduration'), var('Viacost'), var('Viabelief'), var('Viacomfort')),
        var('Directduration') < var('Viaduration'),
        var('Directcost') < var('Viacost'),
        var('Directbelief') > var('Viabelief'),
        var('Directcomfort') > var('Viacomfort'))).
clause(16, outcome(routeDirect, "Take the direct route via Brugge."), true).
clause(17,
       check(c1, true),
       traveller_path(i1, [drive_gent_brugge, drive_brugge_oostende], anonymous(1), anonymous(2), anonymous(3), anonymous(4))).
clause(18,
       check(c2, true),
       traveller_path(i1, [drive_gent_kortrijk, drive_kortrijk_brugge, drive_brugge_oostende], anonymous(1), anonymous(2), anonymous(3), anonymous(4))).
clause(19,
       check(c3, true),
       (route_metrics(routeDirect, var('D1'), anonymous(1), anonymous(2), anonymous(3)),
        route_metrics(routeViaKortrijk, var('D2'), anonymous(4), anonymous(5), anonymous(6)),
        var('D1') < var('D2'))).
clause(20,
       check(c4, true),
       (route_metrics(routeDirect, anonymous(1), var('C1'), anonymous(2), anonymous(3)),
        route_metrics(routeViaKortrijk, anonymous(4), var('C2'), anonymous(5), anonymous(6)),
        var('C1') < var('C2'))).
clause(21,
       check(c5, true),
       (route_metrics(routeDirect, anonymous(1), anonymous(2), var('B1'), var('F1')),
        route_metrics(routeViaKortrijk, anonymous(3), anonymous(4), var('B2'), var('F2')),
        var('B1') > var('B2'),
        var('F1') > var('F2'))).
clause(22, recommendedRoute(decision, var('Route')), recommended_route(var('Route'))).
clause(23,
       outcome(decision, var('Outcome')),
       (recommended_route(var('Route')), outcome(var('Route'), var('Outcome')))).
clause(24, statement(check, var('Check'), true), check(var('Check'), true)).
clause(25, route_actions(routeDirect, [drive_gent_brugge, drive_brugge_oostende]), true).
clause(26,
       route_actions(routeViaKortrijk, [drive_gent_kortrijk, drive_kortrijk_brugge, drive_brugge_oostende]),
       true).
clause(27,
       label(var('Route'), var('Label')),
       (case_statement(var('Route'), label, var('Label')),
        route_metrics(var('Route'), anonymous(1), anonymous(2), anonymous(3), anonymous(4)))).
clause(28,
       actionSequence(var('Route'), var('Actions')),
       (route_actions(var('Route'), var('Actions')),
        route_metrics(var('Route'), anonymous(1), anonymous(2), anonymous(3), anonymous(4)))).
clause(29,
       durationSeconds(var('Route'), var('Duration')),
       route_metrics(var('Route'), var('Duration'), anonymous(1), anonymous(2), anonymous(3))).
clause(30,
       cost(var('Route'), var('Cost')),
       route_metrics(var('Route'), anonymous(1), var('Cost'), anonymous(2), anonymous(3))).
clause(31,
       belief(var('Route'), var('Belief')),
       route_metrics(var('Route'), anonymous(1), anonymous(2), var('Belief'), anonymous(3))).
clause(32,
       comfort(var('Route'), var('Comfort')),
       route_metrics(var('Route'), anonymous(1), anonymous(2), anonymous(3), var('Comfort'))).
clause(33,
       selectedRoute(report, route(var('Route'), var('Actions'), var('Duration'), var('Cost'), var('Belief'), var('Comfort'))),
       (recommended_route(var('Route')),
        route_actions(var('Route'), var('Actions')),
        route_metrics(var('Route'), var('Duration'), var('Cost'), var('Belief'), var('Comfort')))).
clause(34,
       comparison(report, dominates(routeDirect, routeViaKortrijk)),
       (recommended_route(routeDirect), check(c3, true), check(c4, true), check(c5, true))).

step(outcome(decision, "Take the direct route via Brugge."),
     rule(23),
     ['Outcome' = "Take the direct route via Brugge.", 'Route' = routeDirect],
     [recommended_route(routeDirect), outcome(routeDirect, "Take the direct route via Brugge.")]).
step(recommended_route(routeDirect),
     rule(15),
     ['Directduration' = 2400.0,
      'Directcost' = 0.01,
      'Directbelief' = 0.9408,
      'Directcomfort' = 0.99,
      'Viaduration' = 4100.0,
      'Viacost' = 0.018,
      'Viabelief' = 0.903168,
      'Viacomfort' = 0.9801],
     [route_metrics(routeDirect, 2400.0, 0.01, 0.9408, 0.99),
      route_metrics(routeViaKortrijk, 4100.0, 0.018, 0.903168, 0.9801),
      2400.0 < 4100.0,
      0.01 < 0.018,
      0.9408 > 0.903168,
      0.99 > 0.9801]).
step(route_metrics(routeDirect, 2400.0, 0.01, 0.9408, 0.99),
     rule(13),
     ['Duration' = 2400.0, 'Cost' = 0.01, 'Belief' = 0.9408, 'Comfort' = 0.99],
     [traveller_path(i1, [drive_gent_brugge, drive_brugge_oostende], 2400.0, 0.01, 0.9408, 0.99)]).
step(traveller_path(i1, [drive_gent_brugge, drive_brugge_oostende], 2400.0, 0.01, 0.9408, 0.99),
     rule(12),
     ['Traveller' = i1,
      'Actions' = [drive_gent_brugge, drive_brugge_oostende],
      'Duration' = 2400.0,
      'Cost' = 0.01,
      'Belief' = 0.9408,
      'Comfort' = 0.99,
      'From' = location(i1, gent),
      'To' = location(i1, oostende)],
     [traveller_start(i1, location(i1, gent)),
      traveller_goal(i1, location(i1, oostende)),
      path(location(i1, gent), location(i1, oostende), [drive_gent_brugge, drive_brugge_oostende], 2400.0, 0.01, 0.9408, 0.99)]).
step(traveller_start(i1, location(i1, gent)), fact(10), [], []).
step(traveller_goal(i1, location(i1, oostende)), fact(11), [], []).
step(path(location(i1, gent), location(i1, oostende), [drive_gent_brugge, drive_brugge_oostende], 2400.0, 0.01, 0.9408, 0.99),
     rule(9),
     ['From' = location(i1, gent),
      'To' = location(i1, oostende),
      'Actions' = [drive_gent_brugge, drive_brugge_oostende],
      'Duration' = 2400.0,
      'Cost' = 0.01,
      'Belief' = 0.9408,
      'Comfort' = 0.99,
      'Mid' = location(i1, brugge),
      'Action' = drive_gent_brugge,
      'D1' = 1500.0,
      'C1' = 0.006,
      'B1' = 0.96,
      'F1' = 0.99,
      'Restactions' = [drive_brugge_oostende],
      'D2' = 900.0,
      'C2' = 0.004,
      'B2' = 0.98,
      'F2' = 1.0],
     [map_description(location(i1, gent), location(i1, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99),
      path(location(i1, brugge), location(i1, oostende), [drive_brugge_oostende], 900.0, 0.004, 0.98, 1.0),
      append([drive_gent_brugge], [drive_brugge_oostende], [drive_gent_brugge, drive_brugge_oostende]),
      2400.0 is 1500.0 + 900.0,
      0.01 is 0.006 + 0.004,
      0.9408 is 0.96 * 0.98,
      0.99 is 0.99 * 1.0]).
step(map_description(location(i1, gent), location(i1, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99),
     rule(7),
     ['From' = location(i1, gent),
      'To' = location(i1, brugge),
      'Action' = drive_gent_brugge,
      'Duration' = 1500.0,
      'Cost' = 0.006,
      'Belief' = 0.96,
      'Comfort' = 0.99,
      'Context' = (gps_description(mapBE, description(location(i1, gent), true, location(i1, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)), gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0)))],
     [map_graph(mapBE, (gps_description(mapBE, description(location(S, gent), true, location(S, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)), gps_description(mapBE, description(location(S, gent), true, location(S, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(S, kortrijk), true, location(S, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(S, brugge), true, location(S, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0)))),
      context_member((gps_description(mapBE, description(location(i1, gent), true, location(i1, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)), gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))), gps_description(mapBE, description(location(i1, gent), true, location(i1, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)))]).
step(map_graph(mapBE, (gps_description(mapBE, description(location(S, gent), true, location(S, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)), gps_description(mapBE, description(location(S, gent), true, location(S, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(S, kortrijk), true, location(S, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(S, brugge), true, location(S, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0)))),
     fact(2),
     [],
     []).
step(context_member((gps_description(mapBE, description(location(i1, gent), true, location(i1, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)), gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))), gps_description(mapBE, description(location(i1, gent), true, location(i1, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99))),
     rule(3),
     ['Left' = gps_description(mapBE, description(location(i1, gent), true, location(i1, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)),
      'Member' = gps_description(mapBE, description(location(i1, gent), true, location(i1, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99))],
     [context_member(gps_description(mapBE, description(location(i1, gent), true, location(i1, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)), gps_description(mapBE, description(location(i1, gent), true, location(i1, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)))]).
step(context_member(gps_description(mapBE, description(location(i1, gent), true, location(i1, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)), gps_description(mapBE, description(location(i1, gent), true, location(i1, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99))),
     rule(5),
     ['Member' = gps_description(mapBE, description(location(i1, gent), true, location(i1, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99))],
     [gps_description(mapBE, description(location(i1, gent), true, location(i1, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)) \= (_left, _right)]).
step(gps_description(mapBE, description(location(i1, gent), true, location(i1, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)) \= (_left, _right),
     builtin,
     [],
     []).
step(path(location(i1, brugge), location(i1, oostende), [drive_brugge_oostende], 900.0, 0.004, 0.98, 1.0),
     rule(8),
     ['From' = location(i1, brugge),
      'To' = location(i1, oostende),
      'Action' = drive_brugge_oostende,
      'Duration' = 900.0,
      'Cost' = 0.004,
      'Belief' = 0.98,
      'Comfort' = 1.0],
     [map_description(location(i1, brugge), location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0)]).
step(map_description(location(i1, brugge), location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0),
     rule(7),
     ['From' = location(i1, brugge),
      'To' = location(i1, oostende),
      'Action' = drive_brugge_oostende,
      'Duration' = 900.0,
      'Cost' = 0.004,
      'Belief' = 0.98,
      'Comfort' = 1.0,
      'Context' = (gps_description(mapBE, description(location(i1, gent), true, location(i1, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)), gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0)))],
     [map_graph(mapBE, (gps_description(mapBE, description(location(S, gent), true, location(S, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)), gps_description(mapBE, description(location(S, gent), true, location(S, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(S, kortrijk), true, location(S, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(S, brugge), true, location(S, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0)))),
      context_member((gps_description(mapBE, description(location(i1, gent), true, location(i1, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)), gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0)))]).
step(context_member((gps_description(mapBE, description(location(i1, gent), true, location(i1, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)), gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))),
     rule(4),
     ['Right' = (gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))),
      'Member' = gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))],
     [context_member((gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0)))]).
step(context_member((gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))),
     rule(4),
     ['Right' = (gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))),
      'Member' = gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))],
     [context_member((gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0)))]).
step(context_member((gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))),
     rule(4),
     ['Right' = gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0)),
      'Member' = gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))],
     [context_member(gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0)))]).
step(context_member(gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))),
     rule(5),
     ['Member' = gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))],
     [gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0)) \= (_left, _right)]).
step(gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0)) \= (_left, _right),
     builtin,
     [],
     []).
step(append([drive_gent_brugge], [drive_brugge_oostende], [drive_gent_brugge, drive_brugge_oostende]),
     builtin,
     [],
     []).
step(2400.0 is 1500.0 + 900.0, builtin, [], []).
step(0.01 is 0.006 + 0.004, builtin, [], []).
step(0.9408 is 0.96 * 0.98, builtin, [], []).
step(0.99 is 0.99 * 1.0, builtin, [], []).
step(route_metrics(routeViaKortrijk, 4100.0, 0.018, 0.903168, 0.9801),
     rule(14),
     ['Duration' = 4100.0, 'Cost' = 0.018, 'Belief' = 0.903168, 'Comfort' = 0.9801],
     [traveller_path(i1, [drive_gent_kortrijk, drive_kortrijk_brugge, drive_brugge_oostende], 4100.0, 0.018, 0.903168, 0.9801)]).
step(traveller_path(i1, [drive_gent_kortrijk, drive_kortrijk_brugge, drive_brugge_oostende], 4100.0, 0.018, 0.903168, 0.9801),
     rule(12),
     ['Traveller' = i1,
      'Actions' = [drive_gent_kortrijk, drive_kortrijk_brugge, drive_brugge_oostende],
      'Duration' = 4100.0,
      'Cost' = 0.018,
      'Belief' = 0.903168,
      'Comfort' = 0.9801,
      'From' = location(i1, gent),
      'To' = location(i1, oostende)],
     [traveller_start(i1, location(i1, gent)),
      traveller_goal(i1, location(i1, oostende)),
      path(location(i1, gent), location(i1, oostende), [drive_gent_kortrijk, drive_kortrijk_brugge, drive_brugge_oostende], 4100.0, 0.018, 0.903168, 0.9801)]).
step(path(location(i1, gent), location(i1, oostende), [drive_gent_kortrijk, drive_kortrijk_brugge, drive_brugge_oostende], 4100.0, 0.018, 0.903168, 0.9801),
     rule(9),
     ['From' = location(i1, gent),
      'To' = location(i1, oostende),
      'Actions' = [drive_gent_kortrijk, drive_kortrijk_brugge, drive_brugge_oostende],
      'Duration' = 4100.0,
      'Cost' = 0.018,
      'Belief' = 0.903168,
      'Comfort' = 0.9801,
      'Mid' = location(i1, kortrijk),
      'Action' = drive_gent_kortrijk,
      'D1' = 1600.0,
      'C1' = 0.007,
      'B1' = 0.96,
      'F1' = 0.99,
      'Restactions' = [drive_kortrijk_brugge, drive_brugge_oostende],
      'D2' = 2500.0,
      'C2' = 0.011,
      'B2' = 0.9408,
      'F2' = 0.99],
     [map_description(location(i1, gent), location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99),
      path(location(i1, kortrijk), location(i1, oostende), [drive_kortrijk_brugge, drive_brugge_oostende], 2500.0, 0.011, 0.9408, 0.99),
      append([drive_gent_kortrijk], [drive_kortrijk_brugge, drive_brugge_oostende], [drive_gent_kortrijk, drive_kortrijk_brugge, drive_brugge_oostende]),
      4100.0 is 1600.0 + 2500.0,
      0.018 is 0.007 + 0.011,
      0.903168 is 0.96 * 0.9408,
      0.9801 is 0.99 * 0.99]).
step(map_description(location(i1, gent), location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99),
     rule(7),
     ['From' = location(i1, gent),
      'To' = location(i1, kortrijk),
      'Action' = drive_gent_kortrijk,
      'Duration' = 1600.0,
      'Cost' = 0.007,
      'Belief' = 0.96,
      'Comfort' = 0.99,
      'Context' = (gps_description(mapBE, description(location(i1, gent), true, location(i1, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)), gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0)))],
     [map_graph(mapBE, (gps_description(mapBE, description(location(S, gent), true, location(S, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)), gps_description(mapBE, description(location(S, gent), true, location(S, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(S, kortrijk), true, location(S, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(S, brugge), true, location(S, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0)))),
      context_member((gps_description(mapBE, description(location(i1, gent), true, location(i1, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)), gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))), gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)))]).
step(context_member((gps_description(mapBE, description(location(i1, gent), true, location(i1, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)), gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))), gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99))),
     rule(4),
     ['Right' = (gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))),
      'Member' = gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99))],
     [context_member((gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))), gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)))]).
step(context_member((gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))), gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99))),
     rule(3),
     ['Left' = gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)),
      'Member' = gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99))],
     [context_member(gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)))]).
step(context_member(gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99))),
     rule(5),
     ['Member' = gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99))],
     [gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)) \= (_left, _right)]).
step(gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)) \= (_left, _right),
     builtin,
     [],
     []).
step(path(location(i1, kortrijk), location(i1, oostende), [drive_kortrijk_brugge, drive_brugge_oostende], 2500.0, 0.011, 0.9408, 0.99),
     rule(9),
     ['From' = location(i1, kortrijk),
      'To' = location(i1, oostende),
      'Actions' = [drive_kortrijk_brugge, drive_brugge_oostende],
      'Duration' = 2500.0,
      'Cost' = 0.011,
      'Belief' = 0.9408,
      'Comfort' = 0.99,
      'Mid' = location(i1, brugge),
      'Action' = drive_kortrijk_brugge,
      'D1' = 1600.0,
      'C1' = 0.007,
      'B1' = 0.96,
      'F1' = 0.99,
      'Restactions' = [drive_brugge_oostende],
      'D2' = 900.0,
      'C2' = 0.004,
      'B2' = 0.98,
      'F2' = 1.0],
     [map_description(location(i1, kortrijk), location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99),
      path(location(i1, brugge), location(i1, oostende), [drive_brugge_oostende], 900.0, 0.004, 0.98, 1.0),
      append([drive_kortrijk_brugge], [drive_brugge_oostende], [drive_kortrijk_brugge, drive_brugge_oostende]),
      2500.0 is 1600.0 + 900.0,
      0.011 is 0.007 + 0.004,
      0.9408 is 0.96 * 0.98,
      0.99 is 0.99 * 1.0]).
step(map_description(location(i1, kortrijk), location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99),
     rule(7),
     ['From' = location(i1, kortrijk),
      'To' = location(i1, brugge),
      'Action' = drive_kortrijk_brugge,
      'Duration' = 1600.0,
      'Cost' = 0.007,
      'Belief' = 0.96,
      'Comfort' = 0.99,
      'Context' = (gps_description(mapBE, description(location(i1, gent), true, location(i1, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)), gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0)))],
     [map_graph(mapBE, (gps_description(mapBE, description(location(S, gent), true, location(S, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)), gps_description(mapBE, description(location(S, gent), true, location(S, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(S, kortrijk), true, location(S, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(S, brugge), true, location(S, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0)))),
      context_member((gps_description(mapBE, description(location(i1, gent), true, location(i1, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)), gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)))]).
step(context_member((gps_description(mapBE, description(location(i1, gent), true, location(i1, brugge), drive_gent_brugge, 1500.0, 0.006, 0.96, 0.99)), gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99))),
     rule(4),
     ['Right' = (gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))),
      'Member' = gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99))],
     [context_member((gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)))]).
step(context_member((gps_description(mapBE, description(location(i1, gent), true, location(i1, kortrijk), drive_gent_kortrijk, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99))),
     rule(4),
     ['Right' = (gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))),
      'Member' = gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99))],
     [context_member((gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)))]).
step(context_member((gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, brugge), true, location(i1, oostende), drive_brugge_oostende, 900.0, 0.004, 0.98, 1.0))), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99))),
     rule(3),
     ['Left' = gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)),
      'Member' = gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99))],
     [context_member(gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)))]).
step(context_member(gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)), gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99))),
     rule(5),
     ['Member' = gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99))],
     [gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)) \= (_left, _right)]).
step(gps_description(mapBE, description(location(i1, kortrijk), true, location(i1, brugge), drive_kortrijk_brugge, 1600.0, 0.007, 0.96, 0.99)) \= (_left, _right),
     builtin,
     [],
     []).
step(append([drive_kortrijk_brugge], [drive_brugge_oostende], [drive_kortrijk_brugge, drive_brugge_oostende]),
     builtin,
     [],
     []).
step(2500.0 is 1600.0 + 900.0, builtin, [], []).
step(0.011 is 0.007 + 0.004, builtin, [], []).
step(append([drive_gent_kortrijk], [drive_kortrijk_brugge, drive_brugge_oostende], [drive_gent_kortrijk, drive_kortrijk_brugge, drive_brugge_oostende]),
     builtin,
     [],
     []).
step(4100.0 is 1600.0 + 2500.0, builtin, [], []).
step(0.018 is 0.007 + 0.011, builtin, [], []).
step(0.903168 is 0.96 * 0.9408, builtin, [], []).
step(0.9801 is 0.99 * 0.99, builtin, [], []).
step(2400.0 < 4100.0, builtin, [], []).
step(0.01 < 0.018, builtin, [], []).
step(0.9408 > 0.903168, builtin, [], []).
step(0.99 > 0.9801, builtin, [], []).
step(outcome(routeDirect, "Take the direct route via Brugge."), fact(16), [], []).
step(recommendedRoute(decision, routeDirect),
     rule(22),
     ['Route' = routeDirect],
     [recommended_route(routeDirect)]).
step(statement(check, c1, true), rule(24), ['Check' = c1], [check(c1, true)]).
step(check(c1, true),
     rule(17),
     [],
     [traveller_path(i1, [drive_gent_brugge, drive_brugge_oostende], 2400.0, 0.01, 0.9408, 0.99)]).
step(statement(check, c2, true), rule(24), ['Check' = c2], [check(c2, true)]).
step(check(c2, true),
     rule(18),
     [],
     [traveller_path(i1, [drive_gent_kortrijk, drive_kortrijk_brugge, drive_brugge_oostende], 4100.0, 0.018, 0.903168, 0.9801)]).
step(statement(check, c3, true), rule(24), ['Check' = c3], [check(c3, true)]).
step(check(c3, true),
     rule(19),
     ['D1' = 2400.0, 'D2' = 4100.0],
     [route_metrics(routeDirect, 2400.0, 0.01, 0.9408, 0.99),
      route_metrics(routeViaKortrijk, 4100.0, 0.018, 0.903168, 0.9801),
      2400.0 < 4100.0]).
step(statement(check, c4, true), rule(24), ['Check' = c4], [check(c4, true)]).
step(check(c4, true),
     rule(20),
     ['C1' = 0.01, 'C2' = 0.018],
     [route_metrics(routeDirect, 2400.0, 0.01, 0.9408, 0.99),
      route_metrics(routeViaKortrijk, 4100.0, 0.018, 0.903168, 0.9801),
      0.01 < 0.018]).
step(statement(check, c5, true), rule(24), ['Check' = c5], [check(c5, true)]).
step(check(c5, true),
     rule(21),
     ['B1' = 0.9408, 'F1' = 0.99, 'B2' = 0.903168, 'F2' = 0.9801],
     [route_metrics(routeDirect, 2400.0, 0.01, 0.9408, 0.99),
      route_metrics(routeViaKortrijk, 4100.0, 0.018, 0.903168, 0.9801),
      0.9408 > 0.903168,
      0.99 > 0.9801]).
step(label(routeDirect, "Gent -> Brugge -> Oostende"),
     rule(27),
     ['Route' = routeDirect, 'Label' = "Gent -> Brugge -> Oostende"],
     [case_statement(routeDirect, label, "Gent -> Brugge -> Oostende"),
      route_metrics(routeDirect, 2400.0, 0.01, 0.9408, 0.99)]).
step(case_statement(routeDirect, label, "Gent -> Brugge -> Oostende"),
     rule(6),
     ['S' = routeDirect,
      'P' = label,
      'O' = "Gent -> Brugge -> Oostende",
      'Context' = (location(i1, gent), text(question, "Which route should we take from Gent to Oostende?"), label(routeDirect, "Gent -> Brugge -> Oostende"), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")),
      'Statement' = label(routeDirect, "Gent -> Brugge -> Oostende")],
     [case_graph(caseGraph, (location(i1, gent), text(question, "Which route should we take from Gent to Oostende?"), label(routeDirect, "Gent -> Brugge -> Oostende"), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende"))),
      context_member((location(i1, gent), text(question, "Which route should we take from Gent to Oostende?"), label(routeDirect, "Gent -> Brugge -> Oostende"), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")), label(routeDirect, "Gent -> Brugge -> Oostende")),
      label(routeDirect, "Gent -> Brugge -> Oostende") =.. [label, routeDirect, "Gent -> Brugge -> Oostende"]]).
step(case_graph(caseGraph, (location(i1, gent), text(question, "Which route should we take from Gent to Oostende?"), label(routeDirect, "Gent -> Brugge -> Oostende"), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende"))),
     fact(1),
     [],
     []).
step(context_member((location(i1, gent), text(question, "Which route should we take from Gent to Oostende?"), label(routeDirect, "Gent -> Brugge -> Oostende"), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")), label(routeDirect, "Gent -> Brugge -> Oostende")),
     rule(4),
     ['Right' = (text(question, "Which route should we take from Gent to Oostende?"), label(routeDirect, "Gent -> Brugge -> Oostende"), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")),
      'Member' = label(routeDirect, "Gent -> Brugge -> Oostende")],
     [context_member((text(question, "Which route should we take from Gent to Oostende?"), label(routeDirect, "Gent -> Brugge -> Oostende"), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")), label(routeDirect, "Gent -> Brugge -> Oostende"))]).
step(context_member((text(question, "Which route should we take from Gent to Oostende?"), label(routeDirect, "Gent -> Brugge -> Oostende"), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")), label(routeDirect, "Gent -> Brugge -> Oostende")),
     rule(4),
     ['Right' = (label(routeDirect, "Gent -> Brugge -> Oostende"), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")),
      'Member' = label(routeDirect, "Gent -> Brugge -> Oostende")],
     [context_member((label(routeDirect, "Gent -> Brugge -> Oostende"), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")), label(routeDirect, "Gent -> Brugge -> Oostende"))]).
step(context_member((label(routeDirect, "Gent -> Brugge -> Oostende"), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")), label(routeDirect, "Gent -> Brugge -> Oostende")),
     rule(3),
     ['Left' = label(routeDirect, "Gent -> Brugge -> Oostende"),
      'Member' = label(routeDirect, "Gent -> Brugge -> Oostende")],
     [context_member(label(routeDirect, "Gent -> Brugge -> Oostende"), label(routeDirect, "Gent -> Brugge -> Oostende"))]).
step(context_member(label(routeDirect, "Gent -> Brugge -> Oostende"), label(routeDirect, "Gent -> Brugge -> Oostende")),
     rule(5),
     ['Member' = label(routeDirect, "Gent -> Brugge -> Oostende")],
     [label(routeDirect, "Gent -> Brugge -> Oostende") \= (_left, _right)]).
step(label(routeDirect, "Gent -> Brugge -> Oostende") \= (_left, _right), builtin, [], []).
step(label(routeDirect, "Gent -> Brugge -> Oostende") =.. [label, routeDirect, "Gent -> Brugge -> Oostende"],
     builtin,
     [],
     []).
step(label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende"),
     rule(27),
     ['Route' = routeViaKortrijk, 'Label' = "Gent -> Kortrijk -> Brugge -> Oostende"],
     [case_statement(routeViaKortrijk, label, "Gent -> Kortrijk -> Brugge -> Oostende"),
      route_metrics(routeViaKortrijk, 4100.0, 0.018, 0.903168, 0.9801)]).
step(case_statement(routeViaKortrijk, label, "Gent -> Kortrijk -> Brugge -> Oostende"),
     rule(6),
     ['S' = routeViaKortrijk,
      'P' = label,
      'O' = "Gent -> Kortrijk -> Brugge -> Oostende",
      'Context' = (location(i1, gent), text(question, "Which route should we take from Gent to Oostende?"), label(routeDirect, "Gent -> Brugge -> Oostende"), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")),
      'Statement' = label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")],
     [case_graph(caseGraph, (location(i1, gent), text(question, "Which route should we take from Gent to Oostende?"), label(routeDirect, "Gent -> Brugge -> Oostende"), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende"))),
      context_member((location(i1, gent), text(question, "Which route should we take from Gent to Oostende?"), label(routeDirect, "Gent -> Brugge -> Oostende"), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")),
      label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende") =.. [label, routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende"]]).
step(context_member((location(i1, gent), text(question, "Which route should we take from Gent to Oostende?"), label(routeDirect, "Gent -> Brugge -> Oostende"), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")),
     rule(4),
     ['Right' = (text(question, "Which route should we take from Gent to Oostende?"), label(routeDirect, "Gent -> Brugge -> Oostende"), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")),
      'Member' = label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")],
     [context_member((text(question, "Which route should we take from Gent to Oostende?"), label(routeDirect, "Gent -> Brugge -> Oostende"), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende"))]).
step(context_member((text(question, "Which route should we take from Gent to Oostende?"), label(routeDirect, "Gent -> Brugge -> Oostende"), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")),
     rule(4),
     ['Right' = (label(routeDirect, "Gent -> Brugge -> Oostende"), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")),
      'Member' = label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")],
     [context_member((label(routeDirect, "Gent -> Brugge -> Oostende"), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende"))]).
step(context_member((label(routeDirect, "Gent -> Brugge -> Oostende"), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")),
     rule(4),
     ['Right' = label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende"),
      'Member' = label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")],
     [context_member(label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende"), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende"))]).
step(context_member(label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende"), label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")),
     rule(5),
     ['Member' = label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende")],
     [label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende") \= (_left, _right)]).
step(label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende") \= (_left, _right),
     builtin,
     [],
     []).
step(label(routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende") =.. [label, routeViaKortrijk, "Gent -> Kortrijk -> Brugge -> Oostende"],
     builtin,
     [],
     []).
step(actionSequence(routeDirect, [drive_gent_brugge, drive_brugge_oostende]),
     rule(28),
     ['Route' = routeDirect, 'Actions' = [drive_gent_brugge, drive_brugge_oostende]],
     [route_actions(routeDirect, [drive_gent_brugge, drive_brugge_oostende]),
      route_metrics(routeDirect, 2400.0, 0.01, 0.9408, 0.99)]).
step(route_actions(routeDirect, [drive_gent_brugge, drive_brugge_oostende]), fact(25), [], []).
step(actionSequence(routeViaKortrijk, [drive_gent_kortrijk, drive_kortrijk_brugge, drive_brugge_oostende]),
     rule(28),
     ['Route' = routeViaKortrijk,
      'Actions' = [drive_gent_kortrijk, drive_kortrijk_brugge, drive_brugge_oostende]],
     [route_actions(routeViaKortrijk, [drive_gent_kortrijk, drive_kortrijk_brugge, drive_brugge_oostende]),
      route_metrics(routeViaKortrijk, 4100.0, 0.018, 0.903168, 0.9801)]).
step(route_actions(routeViaKortrijk, [drive_gent_kortrijk, drive_kortrijk_brugge, drive_brugge_oostende]),
     fact(26),
     [],
     []).
step(durationSeconds(routeDirect, 2400.0),
     rule(29),
     ['Route' = routeDirect, 'Duration' = 2400.0],
     [route_metrics(routeDirect, 2400.0, 0.01, 0.9408, 0.99)]).
step(durationSeconds(routeViaKortrijk, 4100.0),
     rule(29),
     ['Route' = routeViaKortrijk, 'Duration' = 4100.0],
     [route_metrics(routeViaKortrijk, 4100.0, 0.018, 0.903168, 0.9801)]).
step(cost(routeDirect, 0.01),
     rule(30),
     ['Route' = routeDirect, 'Cost' = 0.01],
     [route_metrics(routeDirect, 2400.0, 0.01, 0.9408, 0.99)]).
step(cost(routeViaKortrijk, 0.018),
     rule(30),
     ['Route' = routeViaKortrijk, 'Cost' = 0.018],
     [route_metrics(routeViaKortrijk, 4100.0, 0.018, 0.903168, 0.9801)]).
step(belief(routeDirect, 0.9408),
     rule(31),
     ['Route' = routeDirect, 'Belief' = 0.9408],
     [route_metrics(routeDirect, 2400.0, 0.01, 0.9408, 0.99)]).
step(belief(routeViaKortrijk, 0.903168),
     rule(31),
     ['Route' = routeViaKortrijk, 'Belief' = 0.903168],
     [route_metrics(routeViaKortrijk, 4100.0, 0.018, 0.903168, 0.9801)]).
step(comfort(routeDirect, 0.99),
     rule(32),
     ['Route' = routeDirect, 'Comfort' = 0.99],
     [route_metrics(routeDirect, 2400.0, 0.01, 0.9408, 0.99)]).
step(comfort(routeViaKortrijk, 0.9801),
     rule(32),
     ['Route' = routeViaKortrijk, 'Comfort' = 0.9801],
     [route_metrics(routeViaKortrijk, 4100.0, 0.018, 0.903168, 0.9801)]).
step(selectedRoute(report, route(routeDirect, [drive_gent_brugge, drive_brugge_oostende], 2400.0, 0.01, 0.9408, 0.99)),
     rule(33),
     ['Route' = routeDirect,
      'Actions' = [drive_gent_brugge, drive_brugge_oostende],
      'Duration' = 2400.0,
      'Cost' = 0.01,
      'Belief' = 0.9408,
      'Comfort' = 0.99],
     [recommended_route(routeDirect),
      route_actions(routeDirect, [drive_gent_brugge, drive_brugge_oostende]),
      route_metrics(routeDirect, 2400.0, 0.01, 0.9408, 0.99)]).
step(comparison(report, dominates(routeDirect, routeViaKortrijk)),
     rule(34),
     [],
     [recommended_route(routeDirect), check(c3, true), check(c4, true), check(c5, true)]).
