% Prolog result format 4
query(1, oddVertices(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = eulerian_path_case, 'X1' = []]).
query(2, path(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = eulerian_path_case, 'X1' = [v1, v2, v3, v4, v5, v1, v3, v6, v2, v4, v6, v1]]).
query(3, edgeCount(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = eulerian_path_case, 'X1' = 11]).
query(4, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 0).
