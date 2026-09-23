report(first_destination, ghent).
report(cut_destination, ghent).
report(existing_route, connected).
report(missing_route, disconnected).
report(recovered_exception, rejected).

clause(1, route(antwerp, ghent), true).
clause(3, first_destination(var('From'), var('To')), once(route(var('From'), var('To')))).
clause(4, preferred_destination(var('From'), var('To')), (route(var('From'), var('To')), !)).
clause(5,
       travel_status(var('From'), var('To'), var('Status')),
       (call(route(var('From'), var('To'))) -> var('Status') = connected ; var('Status') = disconnected)).
clause(7,
       checked_route(var('From'), var('To'), var('Result')),
       catch((require_route(var('From'), var('To')), var('Result') = accepted), no_route(var('From'), var('To')), var('Result') = rejected)).
clause(8, report(first_destination, var('To')), first_destination(antwerp, var('To'))).
clause(9, report(cut_destination, var('To')), preferred_destination(antwerp, var('To'))).
clause(10, report(existing_route, var('Status')), travel_status(antwerp, ghent, var('Status'))).
clause(11, report(missing_route, var('Status')), travel_status(antwerp, paris, var('Status'))).
clause(12,
       report(recovered_exception, var('Result')),
       checked_route(antwerp, paris, var('Result'))).

step(report(first_destination, ghent),
     rule(8),
     ['To' = ghent],
     [first_destination(antwerp, ghent)]).
step(first_destination(antwerp, ghent),
     rule(3),
     ['From' = antwerp, 'To' = ghent],
     [once(route(antwerp, ghent))]).
step(once(route(antwerp, ghent)), builtin, [], [route(antwerp, ghent)]).
step(route(antwerp, ghent), fact(1), [], []).
step(report(cut_destination, ghent),
     rule(9),
     ['To' = ghent],
     [preferred_destination(antwerp, ghent)]).
step(preferred_destination(antwerp, ghent),
     rule(4),
     ['From' = antwerp, 'To' = ghent],
     [route(antwerp, ghent), !]).
step(!, builtin, [], []).
step(report(existing_route, connected),
     rule(10),
     ['Status' = connected],
     [travel_status(antwerp, ghent, connected)]).
step(travel_status(antwerp, ghent, connected),
     rule(5),
     ['From' = antwerp, 'To' = ghent, 'Status' = connected],
     [(call(route(antwerp, ghent)) -> connected = connected ; connected = disconnected)]).
step((call(route(antwerp, ghent)) -> connected = connected ; connected = disconnected),
     builtin,
     [],
     []).
step(report(missing_route, disconnected),
     rule(11),
     ['Status' = disconnected],
     [travel_status(antwerp, paris, disconnected)]).
step(travel_status(antwerp, paris, disconnected),
     rule(5),
     ['From' = antwerp, 'To' = paris, 'Status' = disconnected],
     [(call(route(antwerp, paris)) -> disconnected = connected ; disconnected = disconnected)]).
step((call(route(antwerp, paris)) -> disconnected = connected ; disconnected = disconnected),
     builtin,
     [],
     []).
step(report(recovered_exception, rejected),
     rule(12),
     ['Result' = rejected],
     [checked_route(antwerp, paris, rejected)]).
step(checked_route(antwerp, paris, rejected),
     rule(7),
     ['From' = antwerp, 'To' = paris, 'Result' = rejected],
     [catch((require_route(antwerp, paris), rejected = accepted), no_route(antwerp, paris), rejected = rejected)]).
step(catch((require_route(antwerp, paris), rejected = accepted), no_route(antwerp, paris), rejected = rejected),
     builtin,
     [],
     []).
