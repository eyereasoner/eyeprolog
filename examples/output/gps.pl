% Prolog result format 4
query(1, outcome(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = decision, 'X1' = "Take the direct route via Brugge."]).
query(2, recommendedRoute(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = decision, 'X1' = routeDirect]).
query(3, statement(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(3, complete, 5).
answer(3, ['X0' = check, 'X1' = c1, 'X2' = true]).
answer(3, ['X0' = check, 'X1' = c2, 'X2' = true]).
answer(3, ['X0' = check, 'X1' = c3, 'X2' = true]).
answer(3, ['X0' = check, 'X1' = c4, 'X2' = true]).
answer(3, ['X0' = check, 'X1' = c5, 'X2' = true]).
query(4, label(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 2).
answer(4, ['X0' = routeDirect, 'X1' = "Gent -> Brugge -> Oostende"]).
answer(4, ['X0' = routeViaKortrijk, 'X1' = "Gent -> Kortrijk -> Brugge -> Oostende"]).
query(5, actionSequence(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 2).
answer(5, ['X0' = routeDirect, 'X1' = [drive_gent_brugge, drive_brugge_oostende]]).
answer(5,
       ['X0' = routeViaKortrijk,
        'X1' = [drive_gent_kortrijk, drive_kortrijk_brugge, drive_brugge_oostende]]).
query(6, durationSeconds(_0, _1), ['X0' = _0, 'X1' = _1]).
result(6, complete, 2).
answer(6, ['X0' = routeDirect, 'X1' = 2400.0]).
answer(6, ['X0' = routeViaKortrijk, 'X1' = 4100.0]).
query(7, cost(_0, _1), ['X0' = _0, 'X1' = _1]).
result(7, complete, 2).
answer(7, ['X0' = routeDirect, 'X1' = 0.01]).
answer(7, ['X0' = routeViaKortrijk, 'X1' = 0.018]).
query(8, belief(_0, _1), ['X0' = _0, 'X1' = _1]).
result(8, complete, 2).
answer(8, ['X0' = routeDirect, 'X1' = 0.9408]).
answer(8, ['X0' = routeViaKortrijk, 'X1' = 0.903168]).
query(9, comfort(_0, _1), ['X0' = _0, 'X1' = _1]).
result(9, complete, 2).
answer(9, ['X0' = routeDirect, 'X1' = 0.99]).
answer(9, ['X0' = routeViaKortrijk, 'X1' = 0.9801]).
query(10, selectedRoute(_0, _1), ['X0' = _0, 'X1' = _1]).
result(10, complete, 1).
answer(10,
       ['X0' = report,
        'X1' = route(routeDirect, [drive_gent_brugge, drive_brugge_oostende], 2400.0, 0.01, 0.9408, 0.99)]).
query(11, comparison(_0, _1), ['X0' = _0, 'X1' = _1]).
result(11, complete, 1).
answer(11, ['X0' = report, 'X1' = dominates(routeDirect, routeViaKortrijk)]).
