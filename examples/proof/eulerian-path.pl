oddVertices(eulerian_path_case, []).
path(eulerian_path_case, [v1, v2, v3, v4, v5, v1, v3, v6, v2, v4, v6, v1]).
edgeCount(eulerian_path_case, 11).

clause(1, edge(e12, v1, v2), true).
clause(2, edge(e13, v1, v3), true).
clause(3, edge(e15, v1, v5), true).
clause(4, edge(e16, v1, v6), true).
clause(5, edge(e23, v2, v3), true).
clause(6, edge(e24, v2, v4), true).
clause(7, edge(e26, v2, v6), true).
clause(8, edge(e34, v3, v4), true).
clause(9, edge(e36, v3, v6), true).
clause(10, edge(e45, v4, v5), true).
clause(11, edge(e46, v4, v6), true).
clause(16, adjacent_by_edge(var('V'), var('U'), var('E')), edge(var('E'), var('V'), var('U'))).
clause(17, adjacent_by_edge(var('V'), var('U'), var('E')), edge(var('E'), var('U'), var('V'))).
clause(18, select_item(var('Item'), [var('Item') | var('Rest')], var('Rest')), true).
clause(19,
       select_item(var('Item'), [var('Head') | var('Tail')], [var('Head') | var('Rest')]),
       select_item(var('Item'), var('Tail'), var('Rest'))).
clause(21,
       odd_vertices(var('Odds')),
       (findall(var('V'), odd_degree(var('V')), var('Raw')), sort(var('Raw'), var('Odds')))).
clause(22,
       all_edges(var('Edges')),
       (findall(var('E'), edge(var('E'), anonymous(1), anonymous(2)), var('Raw')),
        sort(var('Raw'), var('Edges')))).
clause(23,
       vertices(var('Vertices')),
       (findall(var('V'), vertex(var('V')), var('Raw')), sort(var('Raw'), var('Vertices')))).
clause(25,
       eulerian_start(var('Start')),
       (odd_vertices([]), vertices([var('Start') | anonymous(1)]))).
clause(26,
       eulerian_path(var('Path')),
       (eulerian_start(var('Start')),
        all_edges(var('Edges')),
        dfs_euler(var('Start'), [var('Start')], var('Edges'), var('Reversedpath')),
        reverse(var('Reversedpath'), var('Path')))).
clause(27, dfs_euler(anonymous(1), var('Path'), [], var('Path')), true).
clause(28,
       dfs_euler(var('Current'), var('Visited'), var('Remaining'), var('Path')),
       (adjacent_by_edge(var('Current'), var('Next'), var('Edge')),
        select_item(var('Edge'), var('Remaining'), var('Newremaining')),
        dfs_euler(var('Next'), [var('Next') | var('Visited')], var('Newremaining'), var('Path')))).
clause(29, oddVertices(eulerian_path_case, var('Odds')), odd_vertices(var('Odds'))).
clause(30, path(eulerian_path_case, var('Path')), once(eulerian_path(var('Path')))).
clause(31,
       edgeCount(eulerian_path_case, var('Count')),
       (all_edges(var('Edges')), length(var('Edges'), var('Count')))).

step(oddVertices(eulerian_path_case, []), rule(29), ['Odds' = []], [odd_vertices([])]).
step(odd_vertices([]),
     rule(21),
     ['Odds' = [], 'Raw' = []],
     [findall(V, odd_degree(V), []), sort([], [])]).
step(findall(V, odd_degree(V), []), collected, [], []).
step(sort([], []), builtin, [], []).
step(path(eulerian_path_case, [v1, v2, v3, v4, v5, v1, v3, v6, v2, v4, v6, v1]),
     rule(30),
     ['Path' = [v1, v2, v3, v4, v5, v1, v3, v6, v2, v4, v6, v1]],
     [once(eulerian_path([v1, v2, v3, v4, v5, v1, v3, v6, v2, v4, v6, v1]))]).
step(once(eulerian_path([v1, v2, v3, v4, v5, v1, v3, v6, v2, v4, v6, v1])),
     builtin,
     [],
     [eulerian_path([v1, v2, v3, v4, v5, v1, v3, v6, v2, v4, v6, v1])]).
step(eulerian_path([v1, v2, v3, v4, v5, v1, v3, v6, v2, v4, v6, v1]),
     rule(26),
     ['Path' = [v1, v2, v3, v4, v5, v1, v3, v6, v2, v4, v6, v1],
      'Start' = v1,
      'Edges' = [e12, e13, e15, e16, e23, e24, e26, e34, e36, e45, e46],
      'Reversedpath' = [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1]],
     [eulerian_start(v1),
      all_edges([e12, e13, e15, e16, e23, e24, e26, e34, e36, e45, e46]),
      dfs_euler(v1, [v1], [e12, e13, e15, e16, e23, e24, e26, e34, e36, e45, e46], [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1]),
      reverse([v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1], [v1, v2, v3, v4, v5, v1, v3, v6, v2, v4, v6, v1])]).
step(eulerian_start(v1),
     rule(25),
     ['Start' = v1],
     [odd_vertices([]), vertices([v1, v2, v3, v4, v5, v6])]).
step(vertices([v1, v2, v3, v4, v5, v6]),
     rule(23),
     ['Vertices' = [v1, v2, v3, v4, v5, v6],
      'Raw' = [v1, v1, v1, v1, v2, v2, v2, v3, v3, v4, v4, v2, v3, v5, v6, v3, v4, v6, v4, v6, v5, v6]],
     [findall(V, vertex(V), [v1, v1, v1, v1, v2, v2, v2, v3, v3, v4, v4, v2, v3, v5, v6, v3, v4, v6, v4, v6, v5, v6]),
      sort([v1, v1, v1, v1, v2, v2, v2, v3, v3, v4, v4, v2, v3, v5, v6, v3, v4, v6, v4, v6, v5, v6], [v1, v2, v3, v4, v5, v6])]).
step(findall(V, vertex(V), [v1, v1, v1, v1, v2, v2, v2, v3, v3, v4, v4, v2, v3, v5, v6, v3, v4, v6, v4, v6, v5, v6]),
     collected,
     [],
     []).
step(sort([v1, v1, v1, v1, v2, v2, v2, v3, v3, v4, v4, v2, v3, v5, v6, v3, v4, v6, v4, v6, v5, v6], [v1, v2, v3, v4, v5, v6]),
     builtin,
     [],
     []).
step(all_edges([e12, e13, e15, e16, e23, e24, e26, e34, e36, e45, e46]),
     rule(22),
     ['Edges' = [e12, e13, e15, e16, e23, e24, e26, e34, e36, e45, e46],
      'Raw' = [e12, e13, e15, e16, e23, e24, e26, e34, e36, e45, e46]],
     [findall(E, edge(E, _a, _b), [e12, e13, e15, e16, e23, e24, e26, e34, e36, e45, e46]),
      sort([e12, e13, e15, e16, e23, e24, e26, e34, e36, e45, e46], [e12, e13, e15, e16, e23, e24, e26, e34, e36, e45, e46])]).
step(findall(E, edge(E, _a, _b), [e12, e13, e15, e16, e23, e24, e26, e34, e36, e45, e46]),
     collected,
     [],
     []).
step(sort([e12, e13, e15, e16, e23, e24, e26, e34, e36, e45, e46], [e12, e13, e15, e16, e23, e24, e26, e34, e36, e45, e46]),
     builtin,
     [],
     []).
step(dfs_euler(v1, [v1], [e12, e13, e15, e16, e23, e24, e26, e34, e36, e45, e46], [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1]),
     rule(28),
     ['Current' = v1,
      'Visited' = [v1],
      'Remaining' = [e12, e13, e15, e16, e23, e24, e26, e34, e36, e45, e46],
      'Path' = [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1],
      'Next' = v2,
      'Edge' = e12,
      'Newremaining' = [e13, e15, e16, e23, e24, e26, e34, e36, e45, e46]],
     [adjacent_by_edge(v1, v2, e12),
      select_item(e12, [e12, e13, e15, e16, e23, e24, e26, e34, e36, e45, e46], [e13, e15, e16, e23, e24, e26, e34, e36, e45, e46]),
      dfs_euler(v2, [v2, v1], [e13, e15, e16, e23, e24, e26, e34, e36, e45, e46], [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1])]).
step(adjacent_by_edge(v1, v2, e12),
     rule(16),
     ['V' = v1, 'U' = v2, 'E' = e12],
     [edge(e12, v1, v2)]).
step(edge(e12, v1, v2), fact(1), [], []).
step(select_item(e12, [e12, e13, e15, e16, e23, e24, e26, e34, e36, e45, e46], [e13, e15, e16, e23, e24, e26, e34, e36, e45, e46]),
     fact(18),
     ['Item' = e12, 'Rest' = [e13, e15, e16, e23, e24, e26, e34, e36, e45, e46]],
     []).
step(dfs_euler(v2, [v2, v1], [e13, e15, e16, e23, e24, e26, e34, e36, e45, e46], [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1]),
     rule(28),
     ['Current' = v2,
      'Visited' = [v2, v1],
      'Remaining' = [e13, e15, e16, e23, e24, e26, e34, e36, e45, e46],
      'Path' = [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1],
      'Next' = v3,
      'Edge' = e23,
      'Newremaining' = [e13, e15, e16, e24, e26, e34, e36, e45, e46]],
     [adjacent_by_edge(v2, v3, e23),
      select_item(e23, [e13, e15, e16, e23, e24, e26, e34, e36, e45, e46], [e13, e15, e16, e24, e26, e34, e36, e45, e46]),
      dfs_euler(v3, [v3, v2, v1], [e13, e15, e16, e24, e26, e34, e36, e45, e46], [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1])]).
step(adjacent_by_edge(v2, v3, e23),
     rule(16),
     ['V' = v2, 'U' = v3, 'E' = e23],
     [edge(e23, v2, v3)]).
step(edge(e23, v2, v3), fact(5), [], []).
step(select_item(e23, [e13, e15, e16, e23, e24, e26, e34, e36, e45, e46], [e13, e15, e16, e24, e26, e34, e36, e45, e46]),
     rule(19),
     ['Item' = e23,
      'Head' = e13,
      'Tail' = [e15, e16, e23, e24, e26, e34, e36, e45, e46],
      'Rest' = [e15, e16, e24, e26, e34, e36, e45, e46]],
     [select_item(e23, [e15, e16, e23, e24, e26, e34, e36, e45, e46], [e15, e16, e24, e26, e34, e36, e45, e46])]).
step(select_item(e23, [e15, e16, e23, e24, e26, e34, e36, e45, e46], [e15, e16, e24, e26, e34, e36, e45, e46]),
     rule(19),
     ['Item' = e23,
      'Head' = e15,
      'Tail' = [e16, e23, e24, e26, e34, e36, e45, e46],
      'Rest' = [e16, e24, e26, e34, e36, e45, e46]],
     [select_item(e23, [e16, e23, e24, e26, e34, e36, e45, e46], [e16, e24, e26, e34, e36, e45, e46])]).
step(select_item(e23, [e16, e23, e24, e26, e34, e36, e45, e46], [e16, e24, e26, e34, e36, e45, e46]),
     rule(19),
     ['Item' = e23,
      'Head' = e16,
      'Tail' = [e23, e24, e26, e34, e36, e45, e46],
      'Rest' = [e24, e26, e34, e36, e45, e46]],
     [select_item(e23, [e23, e24, e26, e34, e36, e45, e46], [e24, e26, e34, e36, e45, e46])]).
step(select_item(e23, [e23, e24, e26, e34, e36, e45, e46], [e24, e26, e34, e36, e45, e46]),
     fact(18),
     ['Item' = e23, 'Rest' = [e24, e26, e34, e36, e45, e46]],
     []).
step(dfs_euler(v3, [v3, v2, v1], [e13, e15, e16, e24, e26, e34, e36, e45, e46], [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1]),
     rule(28),
     ['Current' = v3,
      'Visited' = [v3, v2, v1],
      'Remaining' = [e13, e15, e16, e24, e26, e34, e36, e45, e46],
      'Path' = [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1],
      'Next' = v4,
      'Edge' = e34,
      'Newremaining' = [e13, e15, e16, e24, e26, e36, e45, e46]],
     [adjacent_by_edge(v3, v4, e34),
      select_item(e34, [e13, e15, e16, e24, e26, e34, e36, e45, e46], [e13, e15, e16, e24, e26, e36, e45, e46]),
      dfs_euler(v4, [v4, v3, v2, v1], [e13, e15, e16, e24, e26, e36, e45, e46], [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1])]).
step(adjacent_by_edge(v3, v4, e34),
     rule(16),
     ['V' = v3, 'U' = v4, 'E' = e34],
     [edge(e34, v3, v4)]).
step(edge(e34, v3, v4), fact(8), [], []).
step(select_item(e34, [e13, e15, e16, e24, e26, e34, e36, e45, e46], [e13, e15, e16, e24, e26, e36, e45, e46]),
     rule(19),
     ['Item' = e34,
      'Head' = e13,
      'Tail' = [e15, e16, e24, e26, e34, e36, e45, e46],
      'Rest' = [e15, e16, e24, e26, e36, e45, e46]],
     [select_item(e34, [e15, e16, e24, e26, e34, e36, e45, e46], [e15, e16, e24, e26, e36, e45, e46])]).
step(select_item(e34, [e15, e16, e24, e26, e34, e36, e45, e46], [e15, e16, e24, e26, e36, e45, e46]),
     rule(19),
     ['Item' = e34,
      'Head' = e15,
      'Tail' = [e16, e24, e26, e34, e36, e45, e46],
      'Rest' = [e16, e24, e26, e36, e45, e46]],
     [select_item(e34, [e16, e24, e26, e34, e36, e45, e46], [e16, e24, e26, e36, e45, e46])]).
step(select_item(e34, [e16, e24, e26, e34, e36, e45, e46], [e16, e24, e26, e36, e45, e46]),
     rule(19),
     ['Item' = e34,
      'Head' = e16,
      'Tail' = [e24, e26, e34, e36, e45, e46],
      'Rest' = [e24, e26, e36, e45, e46]],
     [select_item(e34, [e24, e26, e34, e36, e45, e46], [e24, e26, e36, e45, e46])]).
step(select_item(e34, [e24, e26, e34, e36, e45, e46], [e24, e26, e36, e45, e46]),
     rule(19),
     ['Item' = e34,
      'Head' = e24,
      'Tail' = [e26, e34, e36, e45, e46],
      'Rest' = [e26, e36, e45, e46]],
     [select_item(e34, [e26, e34, e36, e45, e46], [e26, e36, e45, e46])]).
step(select_item(e34, [e26, e34, e36, e45, e46], [e26, e36, e45, e46]),
     rule(19),
     ['Item' = e34, 'Head' = e26, 'Tail' = [e34, e36, e45, e46], 'Rest' = [e36, e45, e46]],
     [select_item(e34, [e34, e36, e45, e46], [e36, e45, e46])]).
step(select_item(e34, [e34, e36, e45, e46], [e36, e45, e46]),
     fact(18),
     ['Item' = e34, 'Rest' = [e36, e45, e46]],
     []).
step(dfs_euler(v4, [v4, v3, v2, v1], [e13, e15, e16, e24, e26, e36, e45, e46], [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1]),
     rule(28),
     ['Current' = v4,
      'Visited' = [v4, v3, v2, v1],
      'Remaining' = [e13, e15, e16, e24, e26, e36, e45, e46],
      'Path' = [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1],
      'Next' = v5,
      'Edge' = e45,
      'Newremaining' = [e13, e15, e16, e24, e26, e36, e46]],
     [adjacent_by_edge(v4, v5, e45),
      select_item(e45, [e13, e15, e16, e24, e26, e36, e45, e46], [e13, e15, e16, e24, e26, e36, e46]),
      dfs_euler(v5, [v5, v4, v3, v2, v1], [e13, e15, e16, e24, e26, e36, e46], [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1])]).
step(adjacent_by_edge(v4, v5, e45),
     rule(16),
     ['V' = v4, 'U' = v5, 'E' = e45],
     [edge(e45, v4, v5)]).
step(edge(e45, v4, v5), fact(10), [], []).
step(select_item(e45, [e13, e15, e16, e24, e26, e36, e45, e46], [e13, e15, e16, e24, e26, e36, e46]),
     rule(19),
     ['Item' = e45,
      'Head' = e13,
      'Tail' = [e15, e16, e24, e26, e36, e45, e46],
      'Rest' = [e15, e16, e24, e26, e36, e46]],
     [select_item(e45, [e15, e16, e24, e26, e36, e45, e46], [e15, e16, e24, e26, e36, e46])]).
step(select_item(e45, [e15, e16, e24, e26, e36, e45, e46], [e15, e16, e24, e26, e36, e46]),
     rule(19),
     ['Item' = e45,
      'Head' = e15,
      'Tail' = [e16, e24, e26, e36, e45, e46],
      'Rest' = [e16, e24, e26, e36, e46]],
     [select_item(e45, [e16, e24, e26, e36, e45, e46], [e16, e24, e26, e36, e46])]).
step(select_item(e45, [e16, e24, e26, e36, e45, e46], [e16, e24, e26, e36, e46]),
     rule(19),
     ['Item' = e45,
      'Head' = e16,
      'Tail' = [e24, e26, e36, e45, e46],
      'Rest' = [e24, e26, e36, e46]],
     [select_item(e45, [e24, e26, e36, e45, e46], [e24, e26, e36, e46])]).
step(select_item(e45, [e24, e26, e36, e45, e46], [e24, e26, e36, e46]),
     rule(19),
     ['Item' = e45, 'Head' = e24, 'Tail' = [e26, e36, e45, e46], 'Rest' = [e26, e36, e46]],
     [select_item(e45, [e26, e36, e45, e46], [e26, e36, e46])]).
step(select_item(e45, [e26, e36, e45, e46], [e26, e36, e46]),
     rule(19),
     ['Item' = e45, 'Head' = e26, 'Tail' = [e36, e45, e46], 'Rest' = [e36, e46]],
     [select_item(e45, [e36, e45, e46], [e36, e46])]).
step(select_item(e45, [e36, e45, e46], [e36, e46]),
     rule(19),
     ['Item' = e45, 'Head' = e36, 'Tail' = [e45, e46], 'Rest' = [e46]],
     [select_item(e45, [e45, e46], [e46])]).
step(select_item(e45, [e45, e46], [e46]), fact(18), ['Item' = e45, 'Rest' = [e46]], []).
step(dfs_euler(v5, [v5, v4, v3, v2, v1], [e13, e15, e16, e24, e26, e36, e46], [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1]),
     rule(28),
     ['Current' = v5,
      'Visited' = [v5, v4, v3, v2, v1],
      'Remaining' = [e13, e15, e16, e24, e26, e36, e46],
      'Path' = [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1],
      'Next' = v1,
      'Edge' = e15,
      'Newremaining' = [e13, e16, e24, e26, e36, e46]],
     [adjacent_by_edge(v5, v1, e15),
      select_item(e15, [e13, e15, e16, e24, e26, e36, e46], [e13, e16, e24, e26, e36, e46]),
      dfs_euler(v1, [v1, v5, v4, v3, v2, v1], [e13, e16, e24, e26, e36, e46], [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1])]).
step(adjacent_by_edge(v5, v1, e15),
     rule(17),
     ['V' = v5, 'U' = v1, 'E' = e15],
     [edge(e15, v1, v5)]).
step(edge(e15, v1, v5), fact(3), [], []).
step(select_item(e15, [e13, e15, e16, e24, e26, e36, e46], [e13, e16, e24, e26, e36, e46]),
     rule(19),
     ['Item' = e15,
      'Head' = e13,
      'Tail' = [e15, e16, e24, e26, e36, e46],
      'Rest' = [e16, e24, e26, e36, e46]],
     [select_item(e15, [e15, e16, e24, e26, e36, e46], [e16, e24, e26, e36, e46])]).
step(select_item(e15, [e15, e16, e24, e26, e36, e46], [e16, e24, e26, e36, e46]),
     fact(18),
     ['Item' = e15, 'Rest' = [e16, e24, e26, e36, e46]],
     []).
step(dfs_euler(v1, [v1, v5, v4, v3, v2, v1], [e13, e16, e24, e26, e36, e46], [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1]),
     rule(28),
     ['Current' = v1,
      'Visited' = [v1, v5, v4, v3, v2, v1],
      'Remaining' = [e13, e16, e24, e26, e36, e46],
      'Path' = [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1],
      'Next' = v3,
      'Edge' = e13,
      'Newremaining' = [e16, e24, e26, e36, e46]],
     [adjacent_by_edge(v1, v3, e13),
      select_item(e13, [e13, e16, e24, e26, e36, e46], [e16, e24, e26, e36, e46]),
      dfs_euler(v3, [v3, v1, v5, v4, v3, v2, v1], [e16, e24, e26, e36, e46], [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1])]).
step(adjacent_by_edge(v1, v3, e13),
     rule(16),
     ['V' = v1, 'U' = v3, 'E' = e13],
     [edge(e13, v1, v3)]).
step(edge(e13, v1, v3), fact(2), [], []).
step(select_item(e13, [e13, e16, e24, e26, e36, e46], [e16, e24, e26, e36, e46]),
     fact(18),
     ['Item' = e13, 'Rest' = [e16, e24, e26, e36, e46]],
     []).
step(dfs_euler(v3, [v3, v1, v5, v4, v3, v2, v1], [e16, e24, e26, e36, e46], [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1]),
     rule(28),
     ['Current' = v3,
      'Visited' = [v3, v1, v5, v4, v3, v2, v1],
      'Remaining' = [e16, e24, e26, e36, e46],
      'Path' = [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1],
      'Next' = v6,
      'Edge' = e36,
      'Newremaining' = [e16, e24, e26, e46]],
     [adjacent_by_edge(v3, v6, e36),
      select_item(e36, [e16, e24, e26, e36, e46], [e16, e24, e26, e46]),
      dfs_euler(v6, [v6, v3, v1, v5, v4, v3, v2, v1], [e16, e24, e26, e46], [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1])]).
step(adjacent_by_edge(v3, v6, e36),
     rule(16),
     ['V' = v3, 'U' = v6, 'E' = e36],
     [edge(e36, v3, v6)]).
step(edge(e36, v3, v6), fact(9), [], []).
step(select_item(e36, [e16, e24, e26, e36, e46], [e16, e24, e26, e46]),
     rule(19),
     ['Item' = e36, 'Head' = e16, 'Tail' = [e24, e26, e36, e46], 'Rest' = [e24, e26, e46]],
     [select_item(e36, [e24, e26, e36, e46], [e24, e26, e46])]).
step(select_item(e36, [e24, e26, e36, e46], [e24, e26, e46]),
     rule(19),
     ['Item' = e36, 'Head' = e24, 'Tail' = [e26, e36, e46], 'Rest' = [e26, e46]],
     [select_item(e36, [e26, e36, e46], [e26, e46])]).
step(select_item(e36, [e26, e36, e46], [e26, e46]),
     rule(19),
     ['Item' = e36, 'Head' = e26, 'Tail' = [e36, e46], 'Rest' = [e46]],
     [select_item(e36, [e36, e46], [e46])]).
step(select_item(e36, [e36, e46], [e46]), fact(18), ['Item' = e36, 'Rest' = [e46]], []).
step(dfs_euler(v6, [v6, v3, v1, v5, v4, v3, v2, v1], [e16, e24, e26, e46], [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1]),
     rule(28),
     ['Current' = v6,
      'Visited' = [v6, v3, v1, v5, v4, v3, v2, v1],
      'Remaining' = [e16, e24, e26, e46],
      'Path' = [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1],
      'Next' = v2,
      'Edge' = e26,
      'Newremaining' = [e16, e24, e46]],
     [adjacent_by_edge(v6, v2, e26),
      select_item(e26, [e16, e24, e26, e46], [e16, e24, e46]),
      dfs_euler(v2, [v2, v6, v3, v1, v5, v4, v3, v2, v1], [e16, e24, e46], [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1])]).
step(adjacent_by_edge(v6, v2, e26),
     rule(17),
     ['V' = v6, 'U' = v2, 'E' = e26],
     [edge(e26, v2, v6)]).
step(edge(e26, v2, v6), fact(7), [], []).
step(select_item(e26, [e16, e24, e26, e46], [e16, e24, e46]),
     rule(19),
     ['Item' = e26, 'Head' = e16, 'Tail' = [e24, e26, e46], 'Rest' = [e24, e46]],
     [select_item(e26, [e24, e26, e46], [e24, e46])]).
step(select_item(e26, [e24, e26, e46], [e24, e46]),
     rule(19),
     ['Item' = e26, 'Head' = e24, 'Tail' = [e26, e46], 'Rest' = [e46]],
     [select_item(e26, [e26, e46], [e46])]).
step(select_item(e26, [e26, e46], [e46]), fact(18), ['Item' = e26, 'Rest' = [e46]], []).
step(dfs_euler(v2, [v2, v6, v3, v1, v5, v4, v3, v2, v1], [e16, e24, e46], [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1]),
     rule(28),
     ['Current' = v2,
      'Visited' = [v2, v6, v3, v1, v5, v4, v3, v2, v1],
      'Remaining' = [e16, e24, e46],
      'Path' = [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1],
      'Next' = v4,
      'Edge' = e24,
      'Newremaining' = [e16, e46]],
     [adjacent_by_edge(v2, v4, e24),
      select_item(e24, [e16, e24, e46], [e16, e46]),
      dfs_euler(v4, [v4, v2, v6, v3, v1, v5, v4, v3, v2, v1], [e16, e46], [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1])]).
step(adjacent_by_edge(v2, v4, e24),
     rule(16),
     ['V' = v2, 'U' = v4, 'E' = e24],
     [edge(e24, v2, v4)]).
step(edge(e24, v2, v4), fact(6), [], []).
step(select_item(e24, [e16, e24, e46], [e16, e46]),
     rule(19),
     ['Item' = e24, 'Head' = e16, 'Tail' = [e24, e46], 'Rest' = [e46]],
     [select_item(e24, [e24, e46], [e46])]).
step(select_item(e24, [e24, e46], [e46]), fact(18), ['Item' = e24, 'Rest' = [e46]], []).
step(dfs_euler(v4, [v4, v2, v6, v3, v1, v5, v4, v3, v2, v1], [e16, e46], [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1]),
     rule(28),
     ['Current' = v4,
      'Visited' = [v4, v2, v6, v3, v1, v5, v4, v3, v2, v1],
      'Remaining' = [e16, e46],
      'Path' = [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1],
      'Next' = v6,
      'Edge' = e46,
      'Newremaining' = [e16]],
     [adjacent_by_edge(v4, v6, e46),
      select_item(e46, [e16, e46], [e16]),
      dfs_euler(v6, [v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1], [e16], [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1])]).
step(adjacent_by_edge(v4, v6, e46),
     rule(16),
     ['V' = v4, 'U' = v6, 'E' = e46],
     [edge(e46, v4, v6)]).
step(edge(e46, v4, v6), fact(11), [], []).
step(select_item(e46, [e16, e46], [e16]),
     rule(19),
     ['Item' = e46, 'Head' = e16, 'Tail' = [e46], 'Rest' = []],
     [select_item(e46, [e46], [])]).
step(select_item(e46, [e46], []), fact(18), ['Item' = e46, 'Rest' = []], []).
step(dfs_euler(v6, [v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1], [e16], [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1]),
     rule(28),
     ['Current' = v6,
      'Visited' = [v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1],
      'Remaining' = [e16],
      'Path' = [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1],
      'Next' = v1,
      'Edge' = e16,
      'Newremaining' = []],
     [adjacent_by_edge(v6, v1, e16),
      select_item(e16, [e16], []),
      dfs_euler(v1, [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1], [], [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1])]).
step(adjacent_by_edge(v6, v1, e16),
     rule(17),
     ['V' = v6, 'U' = v1, 'E' = e16],
     [edge(e16, v1, v6)]).
step(edge(e16, v1, v6), fact(4), [], []).
step(select_item(e16, [e16], []), fact(18), ['Item' = e16, 'Rest' = []], []).
step(dfs_euler(v1, [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1], [], [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1]),
     fact(27),
     ['Path' = [v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1]],
     []).
step(reverse([v1, v6, v4, v2, v6, v3, v1, v5, v4, v3, v2, v1], [v1, v2, v3, v4, v5, v1, v3, v6, v2, v4, v6, v1]),
     builtin,
     [],
     []).
step(edgeCount(eulerian_path_case, 11),
     rule(31),
     ['Count' = 11, 'Edges' = [e12, e13, e15, e16, e23, e24, e26, e34, e36, e45, e46]],
     [all_edges([e12, e13, e15, e16, e23, e24, e26, e34, e36, e45, e46]),
      length([e12, e13, e15, e16, e23, e24, e26, e34, e36, e45, e46], 11)]).
step(length([e12, e13, e15, e16, e23, e24, e26, e34, e36, e45, e46], 11), builtin, [], []).
