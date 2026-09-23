reachable(reachability_case, path(a, f)).
reachable(reachability_case, path(c, g)).
not_reachable(reachability_case, path(b, e)).

clause(1, edge(a, b), true).
clause(3, edge(b, d), true).
clause(4, edge(c, e), true).
clause(5, edge(d, f), true).
clause(6, edge(e, f), true).
clause(7, edge(f, g), true).
clause(8, reachable_via(var('Node'), var('Node'), anonymous(1)), true).
clause(9,
       reachable_via(var('Start'), var('Goal'), var('Visited')),
       (edge(var('Start'), var('Next')),
        \+ member(var('Next'), var('Visited')),
        reachable_via(var('Next'), var('Goal'), [var('Next') | var('Visited')]))).
clause(10,
       is_reachable(var('Start'), var('Goal')),
       reachable_via(var('Start'), var('Goal'), [var('Start')])).
clause(11, reachable(reachability_case, path(a, f)), is_reachable(a, f)).
clause(12, reachable(reachability_case, path(c, g)), is_reachable(c, g)).
clause(13, not_reachable(reachability_case, path(b, e)), \+ is_reachable(b, e)).

step(reachable(reachability_case, path(a, f)), rule(11), [], [is_reachable(a, f)]).
step(is_reachable(a, f), rule(10), ['Start' = a, 'Goal' = f], [reachable_via(a, f, "a")]).
step(reachable_via(a, f, "a"),
     rule(9),
     ['Start' = a, 'Goal' = f, 'Visited' = "a", 'Next' = b],
     [edge(a, b), \+ member(b, "a"), reachable_via(b, f, "ba")]).
step(edge(a, b), fact(1), [], []).
step(\+ member(b, "a"), absent, [], []).
step(reachable_via(b, f, "ba"),
     rule(9),
     ['Start' = b, 'Goal' = f, 'Visited' = "ba", 'Next' = d],
     [edge(b, d), \+ member(d, "ba"), reachable_via(d, f, "dba")]).
step(edge(b, d), fact(3), [], []).
step(\+ member(d, "ba"), absent, [], []).
step(reachable_via(d, f, "dba"),
     rule(9),
     ['Start' = d, 'Goal' = f, 'Visited' = "dba", 'Next' = f],
     [edge(d, f), \+ member(f, "dba"), reachable_via(f, f, "fdba")]).
step(edge(d, f), fact(5), [], []).
step(\+ member(f, "dba"), absent, [], []).
step(reachable_via(f, f, "fdba"), fact(8), ['Node' = f], []).
step(reachable(reachability_case, path(c, g)), rule(12), [], [is_reachable(c, g)]).
step(is_reachable(c, g), rule(10), ['Start' = c, 'Goal' = g], [reachable_via(c, g, "c")]).
step(reachable_via(c, g, "c"),
     rule(9),
     ['Start' = c, 'Goal' = g, 'Visited' = "c", 'Next' = e],
     [edge(c, e), \+ member(e, "c"), reachable_via(e, g, "ec")]).
step(edge(c, e), fact(4), [], []).
step(\+ member(e, "c"), absent, [], []).
step(reachable_via(e, g, "ec"),
     rule(9),
     ['Start' = e, 'Goal' = g, 'Visited' = "ec", 'Next' = f],
     [edge(e, f), \+ member(f, "ec"), reachable_via(f, g, "fec")]).
step(edge(e, f), fact(6), [], []).
step(\+ member(f, "ec"), absent, [], []).
step(reachable_via(f, g, "fec"),
     rule(9),
     ['Start' = f, 'Goal' = g, 'Visited' = "fec", 'Next' = g],
     [edge(f, g), \+ member(g, "fec"), reachable_via(g, g, "gfec")]).
step(edge(f, g), fact(7), [], []).
step(\+ member(g, "fec"), absent, [], []).
step(reachable_via(g, g, "gfec"), fact(8), ['Node' = g], []).
step(not_reachable(reachability_case, path(b, e)), rule(13), [], [\+ is_reachable(b, e)]).
step(\+ is_reachable(b, e), absent, [], []).
