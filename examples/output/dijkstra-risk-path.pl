% Prolog result format 4
query(1, route(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 5).
answer(1, ['X0' = pathB, 'X1' = [depotA, depotB, labD]]).
answer(1, ['X0' = pathC, 'X1' = [depotA, depotC, labD]]).
answer(1, ['X0' = pathRelay, 'X1' = [depotA, relay, labD]]).
answer(1, ['X0' = pathDirectC, 'X1' = [depotA, labD]]).
answer(1, ['X0' = pathViaC, 'X1' = [depotA, depotC, depotB, labD]]).
query(2, rawCost(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 5).
answer(2, ['X0' = pathB, 'X1' = 8.0]).
answer(2, ['X0' = pathC, 'X1' = 9.0]).
answer(2, ['X0' = pathRelay, 'X1' = 10.0]).
answer(2, ['X0' = pathDirectC, 'X1' = 14.0]).
answer(2, ['X0' = pathViaC, 'X1' = 7.5]).
query(3, riskSum(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 5).
answer(3, ['X0' = pathB, 'X1' = 0.5]).
answer(3, ['X0' = pathC, 'X1' = 1.2]).
answer(3, ['X0' = pathRelay, 'X1' = 0.4]).
answer(3, ['X0' = pathDirectC, 'X1' = 0.05]).
answer(3, ['X0' = pathViaC, 'X1' = 1.7000000000000002]).
query(4, score(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 5).
answer(4, ['X0' = pathB, 'X1' = 13.0]).
answer(4, ['X0' = pathC, 'X1' = 21.0]).
answer(4, ['X0' = pathRelay, 'X1' = 14.0]).
answer(4, ['X0' = pathDirectC, 'X1' = 14.5]).
answer(4, ['X0' = pathViaC, 'X1' = 24.5]).
query(5, edgeCount(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 5).
answer(5, ['X0' = pathB, 'X1' = 2]).
answer(5, ['X0' = pathC, 'X1' = 2]).
answer(5, ['X0' = pathRelay, 'X1' = 2]).
answer(5, ['X0' = pathDirectC, 'X1' = 1]).
answer(5, ['X0' = pathViaC, 'X1' = 3]).
query(6, selectedPath(_0, _1), ['X0' = _0, 'X1' = _1]).
result(6, complete, 1).
answer(6, ['X0' = case, 'X1' = pathB]).
query(7, trustGate(_0, _1), ['X0' = _0, 'X1' = _1]).
result(7, complete, 1).
answer(7, ['X0' = case, 'X1' = noEnumeratedPathIsLower]).
query(8, notes(_0, _1), ['X0' = _0, 'X1' = _1]).
result(8, complete, 1).
answer(8, ['X0' = case, 'X1' = riskCanOutweighRawCost]).
query(9, selects(_0, _1), ['X0' = _0, 'X1' = _1]).
result(9, complete, 1).
answer(9, ['X0' = dijkstraRiskPath, 'X1' = pathB]).
