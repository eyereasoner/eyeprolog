overlap_example(overlap(booleans([1, 0]), union("abc"), reachable("abc"), filtered("aa"), awakened(yes), generated(shared1), uppercase("A"), transposed([[1, 4], [2, 5], [3, 6]]), tabled_paths("bc"))).

clause(6,
       overlap_example(overlap(booleans([var('X'), var('Y')]), union(var('Union')), reachable(var('Reachable')), filtered(var('Filtered')), awakened(var('Awakened')), generated(var('Generated')), uppercase(var('Uppercase')), transposed(var('Transposed')), tabled_paths(var('Paths')))),
       (sat(var('X') * ~ var('Y')),
        labeling([var('X'), var('Y')]),
        ord_union("ac", "bc", var('Union')),
        vertices_edges_to_ugraph("abc", [a - b, b - c], var('Graph')),
        reachable(a, var('Graph'), var('Reachable')),
        tfilter(=(a), "aba", var('Filtered')),
        when(nonvar(var('Wake')), var('Awakened') = yes),
        var('Wake') = now,
        reset_gensym(shared),
        gensym(shared, var('Generated')),
        char_type(a, upper(var('Uppercase'))),
        transpose([[1, 2, 3], [4, 5, 6]], var('Transposed')),
        findall(var('Node'), path(a, var('Node')), var('Paths')))).

step(overlap_example(overlap(booleans([1, 0]), union("abc"), reachable("abc"), filtered("aa"), awakened(yes), generated(shared1), uppercase("A"), transposed([[1, 4], [2, 5], [3, 6]]), tabled_paths("bc"))),
     rule(6),
     ['X' = 1,
      'Y' = 0,
      'Union' = "abc",
      'Reachable' = "abc",
      'Filtered' = "aa",
      'Awakened' = yes,
      'Generated' = shared1,
      'Uppercase' = "A",
      'Transposed' = [[1, 4], [2, 5], [3, 6]],
      'Paths' = "bc",
      'Graph' = [a - "b", b - "c", c - []],
      'Wake' = now],
     [sat(1 * ~ 0),
      labeling([1, 0]),
      ord_union("ac", "bc", "abc"),
      vertices_edges_to_ugraph("abc", [a - b, b - c], [a - "b", b - "c", c - []]),
      reachable(a, [a - "b", b - "c", c - []], "abc"),
      tfilter(=(a), "aba", "aa"),
      when(nonvar(now), yes = yes),
      now = now,
      reset_gensym(shared),
      gensym(shared, shared1),
      char_type(a, upper("A")),
      transpose([[1, 2, 3], [4, 5, 6]], [[1, 4], [2, 5], [3, 6]]),
      findall(Node, path(a, Node), "bc")]).
step(sat(1 * ~ 0), builtin, [], []).
step(labeling([1, 0]), builtin, [], []).
step(ord_union("ac", "bc", "abc"), builtin, [], []).
step(vertices_edges_to_ugraph("abc", [a - b, b - c], [a - "b", b - "c", c - []]),
     builtin,
     [],
     []).
step(reachable(a, [a - "b", b - "c", c - []], "abc"), builtin, [], []).
step(tfilter(=(a), "aba", "aa"), builtin, [], []).
step(when(nonvar(now), yes = yes), builtin, [], []).
step(now = now, builtin, [], []).
step(reset_gensym(shared), builtin, [], []).
step(gensym(shared, shared1), builtin, [], []).
step(char_type(a, upper("A")), builtin, [], []).
step(transpose([[1, 2, 3], [4, 5, 6]], [[1, 4], [2, 5], [3, 6]]), builtin, [], []).
step(findall(Node, path(a, Node), "bc"), collected, [], []).
