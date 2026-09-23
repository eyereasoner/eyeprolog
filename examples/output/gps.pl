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
