% Prolog result format 4
query(1, shortestPath(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = dijkstra_findall_sort, 'X1' = "acbdef"]).
query(2, cost(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = dijkstra_findall_sort, 'X1' = 13]).
query(3, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 0).
