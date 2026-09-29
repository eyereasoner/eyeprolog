edge("ba", 4).
edge("ca", 2).
edge("cb", 1).
edge("db", 5).
edge("dc", 8).
edge("ec", 10).
edge("ed", 2).
edge("fd", 6).
edge("fe", 3).
path("af", ["abdef", 14]).
path("af", ["abdf", 15]).
path("af", ["acdef", 15]).
path("af", ["acdf", 16]).
path("af", ["acef", 15]).
path("af", ["acbdef", 13]).
path("af", ["acbdf", 14]).

clause(1,
       weighted_graph(dijkstraGraph, (edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3)))),
       true).
clause(2,
       context_member((var('Left'), anonymous(1)), var('Member')),
       context_member(var('Left'), var('Member'))).
clause(3,
       context_member((anonymous(1), var('Right')), var('Member')),
       context_member(var('Right'), var('Member'))).
clause(4,
       context_member(var('Member'), var('Member')),
       var('Member') \= (anonymous(1), anonymous(2))).
clause(5,
       base_link(var('A'), var('B'), var('Cost')),
       (weighted_graph(dijkstraGraph, var('Context')),
        context_member(var('Context'), edge(var('A'), arc(var('B'), var('Cost')))))).
clause(6, link(var('A'), var('B'), var('Cost')), base_link(var('A'), var('B'), var('Cost'))).
clause(7, link(var('B'), var('A'), var('Cost')), base_link(var('A'), var('B'), var('Cost'))).
clause(8, path(var('Goal'), var('Goal'), anonymous(1), [var('Goal')], 0), true).
clause(9,
       path(var('Node'), var('Goal'), var('Visited'), [var('Node') | var('Path')], var('Cost')),
       (link(var('Node'), var('Next'), var('Stepcost')),
        \+ member(var('Next'), var('Visited')),
        path(var('Next'), var('Goal'), [var('Next') | var('Visited')], var('Path'), var('Restcost')),
        var('Cost') is var('Stepcost') + var('Restcost'))).
clause(10, edge([var('B'), var('A')], var('Cost')), base_link(var('A'), var('B'), var('Cost'))).
clause(11,
       path("af", [var('Path'), var('Cost')]),
       (path(a, f, "a", var('Path'), var('Cost')), var('Cost') =< 16)).

step(edge("ba", 4), rule(10), ['B' = b, 'A' = a, 'Cost' = 4], [base_link(a, b, 4)]).
step(base_link(a, b, 4),
     rule(5),
     ['A' = a,
      'B' = b,
      'Cost' = 4,
      'Context' = (edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3)))],
     [weighted_graph(dijkstraGraph, (edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3)))),
      context_member((edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(a, arc(b, 4)))]).
step(weighted_graph(dijkstraGraph, (edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3)))),
     fact(1),
     [],
     []).
step(context_member((edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(a, arc(b, 4))),
     rule(2),
     ['Left' = edge(a, arc(b, 4)), 'Member' = edge(a, arc(b, 4))],
     [context_member(edge(a, arc(b, 4)), edge(a, arc(b, 4)))]).
step(context_member(edge(a, arc(b, 4)), edge(a, arc(b, 4))),
     rule(4),
     ['Member' = edge(a, arc(b, 4))],
     [edge(a, arc(b, 4)) \= (_left, _right)]).
step(edge(a, arc(b, 4)) \= (_left, _right), builtin, [], []).
step(edge("ca", 2), rule(10), ['B' = c, 'A' = a, 'Cost' = 2], [base_link(a, c, 2)]).
step(base_link(a, c, 2),
     rule(5),
     ['A' = a,
      'B' = c,
      'Cost' = 2,
      'Context' = (edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3)))],
     [weighted_graph(dijkstraGraph, (edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3)))),
      context_member((edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(a, arc(c, 2)))]).
step(context_member((edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(a, arc(c, 2))),
     rule(3),
     ['Right' = (edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(a, arc(c, 2))],
     [context_member((edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(a, arc(c, 2)))]).
step(context_member((edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(a, arc(c, 2))),
     rule(2),
     ['Left' = edge(a, arc(c, 2)), 'Member' = edge(a, arc(c, 2))],
     [context_member(edge(a, arc(c, 2)), edge(a, arc(c, 2)))]).
step(context_member(edge(a, arc(c, 2)), edge(a, arc(c, 2))),
     rule(4),
     ['Member' = edge(a, arc(c, 2))],
     [edge(a, arc(c, 2)) \= (_left, _right)]).
step(edge(a, arc(c, 2)) \= (_left, _right), builtin, [], []).
step(edge("cb", 1), rule(10), ['B' = c, 'A' = b, 'Cost' = 1], [base_link(b, c, 1)]).
step(base_link(b, c, 1),
     rule(5),
     ['A' = b,
      'B' = c,
      'Cost' = 1,
      'Context' = (edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3)))],
     [weighted_graph(dijkstraGraph, (edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3)))),
      context_member((edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(b, arc(c, 1)))]).
step(context_member((edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(b, arc(c, 1))),
     rule(3),
     ['Right' = (edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(b, arc(c, 1))],
     [context_member((edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(b, arc(c, 1)))]).
step(context_member((edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(b, arc(c, 1))),
     rule(3),
     ['Right' = (edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(b, arc(c, 1))],
     [context_member((edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(b, arc(c, 1)))]).
step(context_member((edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(b, arc(c, 1))),
     rule(2),
     ['Left' = edge(b, arc(c, 1)), 'Member' = edge(b, arc(c, 1))],
     [context_member(edge(b, arc(c, 1)), edge(b, arc(c, 1)))]).
step(context_member(edge(b, arc(c, 1)), edge(b, arc(c, 1))),
     rule(4),
     ['Member' = edge(b, arc(c, 1))],
     [edge(b, arc(c, 1)) \= (_left, _right)]).
step(edge(b, arc(c, 1)) \= (_left, _right), builtin, [], []).
step(edge("db", 5), rule(10), ['B' = d, 'A' = b, 'Cost' = 5], [base_link(b, d, 5)]).
step(base_link(b, d, 5),
     rule(5),
     ['A' = b,
      'B' = d,
      'Cost' = 5,
      'Context' = (edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3)))],
     [weighted_graph(dijkstraGraph, (edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3)))),
      context_member((edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(b, arc(d, 5)))]).
step(context_member((edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(b, arc(d, 5))),
     rule(3),
     ['Right' = (edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(b, arc(d, 5))],
     [context_member((edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(b, arc(d, 5)))]).
step(context_member((edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(b, arc(d, 5))),
     rule(3),
     ['Right' = (edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(b, arc(d, 5))],
     [context_member((edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(b, arc(d, 5)))]).
step(context_member((edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(b, arc(d, 5))),
     rule(3),
     ['Right' = (edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(b, arc(d, 5))],
     [context_member((edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(b, arc(d, 5)))]).
step(context_member((edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(b, arc(d, 5))),
     rule(2),
     ['Left' = edge(b, arc(d, 5)), 'Member' = edge(b, arc(d, 5))],
     [context_member(edge(b, arc(d, 5)), edge(b, arc(d, 5)))]).
step(context_member(edge(b, arc(d, 5)), edge(b, arc(d, 5))),
     rule(4),
     ['Member' = edge(b, arc(d, 5))],
     [edge(b, arc(d, 5)) \= (_left, _right)]).
step(edge(b, arc(d, 5)) \= (_left, _right), builtin, [], []).
step(edge("dc", 8), rule(10), ['B' = d, 'A' = c, 'Cost' = 8], [base_link(c, d, 8)]).
step(base_link(c, d, 8),
     rule(5),
     ['A' = c,
      'B' = d,
      'Cost' = 8,
      'Context' = (edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3)))],
     [weighted_graph(dijkstraGraph, (edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3)))),
      context_member((edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(c, arc(d, 8)))]).
step(context_member((edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(c, arc(d, 8))),
     rule(3),
     ['Right' = (edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(c, arc(d, 8))],
     [context_member((edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(c, arc(d, 8)))]).
step(context_member((edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(c, arc(d, 8))),
     rule(3),
     ['Right' = (edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(c, arc(d, 8))],
     [context_member((edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(c, arc(d, 8)))]).
step(context_member((edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(c, arc(d, 8))),
     rule(3),
     ['Right' = (edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(c, arc(d, 8))],
     [context_member((edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(c, arc(d, 8)))]).
step(context_member((edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(c, arc(d, 8))),
     rule(3),
     ['Right' = (edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(c, arc(d, 8))],
     [context_member((edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(c, arc(d, 8)))]).
step(context_member((edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(c, arc(d, 8))),
     rule(2),
     ['Left' = edge(c, arc(d, 8)), 'Member' = edge(c, arc(d, 8))],
     [context_member(edge(c, arc(d, 8)), edge(c, arc(d, 8)))]).
step(context_member(edge(c, arc(d, 8)), edge(c, arc(d, 8))),
     rule(4),
     ['Member' = edge(c, arc(d, 8))],
     [edge(c, arc(d, 8)) \= (_left, _right)]).
step(edge(c, arc(d, 8)) \= (_left, _right), builtin, [], []).
step(edge("ec", 10), rule(10), ['B' = e, 'A' = c, 'Cost' = 10], [base_link(c, e, 10)]).
step(base_link(c, e, 10),
     rule(5),
     ['A' = c,
      'B' = e,
      'Cost' = 10,
      'Context' = (edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3)))],
     [weighted_graph(dijkstraGraph, (edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3)))),
      context_member((edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(c, arc(e, 10)))]).
step(context_member((edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(c, arc(e, 10))),
     rule(3),
     ['Right' = (edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(c, arc(e, 10))],
     [context_member((edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(c, arc(e, 10)))]).
step(context_member((edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(c, arc(e, 10))),
     rule(3),
     ['Right' = (edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(c, arc(e, 10))],
     [context_member((edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(c, arc(e, 10)))]).
step(context_member((edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(c, arc(e, 10))),
     rule(3),
     ['Right' = (edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(c, arc(e, 10))],
     [context_member((edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(c, arc(e, 10)))]).
step(context_member((edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(c, arc(e, 10))),
     rule(3),
     ['Right' = (edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(c, arc(e, 10))],
     [context_member((edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(c, arc(e, 10)))]).
step(context_member((edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(c, arc(e, 10))),
     rule(3),
     ['Right' = (edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(c, arc(e, 10))],
     [context_member((edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(c, arc(e, 10)))]).
step(context_member((edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(c, arc(e, 10))),
     rule(2),
     ['Left' = edge(c, arc(e, 10)), 'Member' = edge(c, arc(e, 10))],
     [context_member(edge(c, arc(e, 10)), edge(c, arc(e, 10)))]).
step(context_member(edge(c, arc(e, 10)), edge(c, arc(e, 10))),
     rule(4),
     ['Member' = edge(c, arc(e, 10))],
     [edge(c, arc(e, 10)) \= (_left, _right)]).
step(edge(c, arc(e, 10)) \= (_left, _right), builtin, [], []).
step(edge("ed", 2), rule(10), ['B' = e, 'A' = d, 'Cost' = 2], [base_link(d, e, 2)]).
step(base_link(d, e, 2),
     rule(5),
     ['A' = d,
      'B' = e,
      'Cost' = 2,
      'Context' = (edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3)))],
     [weighted_graph(dijkstraGraph, (edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3)))),
      context_member((edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(e, 2)))]).
step(context_member((edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(e, 2))),
     rule(3),
     ['Right' = (edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(d, arc(e, 2))],
     [context_member((edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(e, 2)))]).
step(context_member((edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(e, 2))),
     rule(3),
     ['Right' = (edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(d, arc(e, 2))],
     [context_member((edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(e, 2)))]).
step(context_member((edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(e, 2))),
     rule(3),
     ['Right' = (edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(d, arc(e, 2))],
     [context_member((edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(e, 2)))]).
step(context_member((edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(e, 2))),
     rule(3),
     ['Right' = (edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(d, arc(e, 2))],
     [context_member((edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(e, 2)))]).
step(context_member((edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(e, 2))),
     rule(3),
     ['Right' = (edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(d, arc(e, 2))],
     [context_member((edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(e, 2)))]).
step(context_member((edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(e, 2))),
     rule(3),
     ['Right' = (edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(d, arc(e, 2))],
     [context_member((edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(e, 2)))]).
step(context_member((edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(e, 2))),
     rule(2),
     ['Left' = edge(d, arc(e, 2)), 'Member' = edge(d, arc(e, 2))],
     [context_member(edge(d, arc(e, 2)), edge(d, arc(e, 2)))]).
step(context_member(edge(d, arc(e, 2)), edge(d, arc(e, 2))),
     rule(4),
     ['Member' = edge(d, arc(e, 2))],
     [edge(d, arc(e, 2)) \= (_left, _right)]).
step(edge(d, arc(e, 2)) \= (_left, _right), builtin, [], []).
step(edge("fd", 6), rule(10), ['B' = f, 'A' = d, 'Cost' = 6], [base_link(d, f, 6)]).
step(base_link(d, f, 6),
     rule(5),
     ['A' = d,
      'B' = f,
      'Cost' = 6,
      'Context' = (edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3)))],
     [weighted_graph(dijkstraGraph, (edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3)))),
      context_member((edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(f, 6)))]).
step(context_member((edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(f, 6))),
     rule(3),
     ['Right' = (edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(d, arc(f, 6))],
     [context_member((edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(f, 6)))]).
step(context_member((edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(f, 6))),
     rule(3),
     ['Right' = (edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(d, arc(f, 6))],
     [context_member((edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(f, 6)))]).
step(context_member((edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(f, 6))),
     rule(3),
     ['Right' = (edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(d, arc(f, 6))],
     [context_member((edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(f, 6)))]).
step(context_member((edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(f, 6))),
     rule(3),
     ['Right' = (edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(d, arc(f, 6))],
     [context_member((edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(f, 6)))]).
step(context_member((edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(f, 6))),
     rule(3),
     ['Right' = (edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(d, arc(f, 6))],
     [context_member((edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(f, 6)))]).
step(context_member((edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(f, 6))),
     rule(3),
     ['Right' = (edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(d, arc(f, 6))],
     [context_member((edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(f, 6)))]).
step(context_member((edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(f, 6))),
     rule(3),
     ['Right' = (edge(d, arc(f, 6)), edge(e, arc(f, 3))), 'Member' = edge(d, arc(f, 6))],
     [context_member((edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(f, 6)))]).
step(context_member((edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(d, arc(f, 6))),
     rule(2),
     ['Left' = edge(d, arc(f, 6)), 'Member' = edge(d, arc(f, 6))],
     [context_member(edge(d, arc(f, 6)), edge(d, arc(f, 6)))]).
step(context_member(edge(d, arc(f, 6)), edge(d, arc(f, 6))),
     rule(4),
     ['Member' = edge(d, arc(f, 6))],
     [edge(d, arc(f, 6)) \= (_left, _right)]).
step(edge(d, arc(f, 6)) \= (_left, _right), builtin, [], []).
step(edge("fe", 3), rule(10), ['B' = f, 'A' = e, 'Cost' = 3], [base_link(e, f, 3)]).
step(base_link(e, f, 3),
     rule(5),
     ['A' = e,
      'B' = f,
      'Cost' = 3,
      'Context' = (edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3)))],
     [weighted_graph(dijkstraGraph, (edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3)))),
      context_member((edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(e, arc(f, 3)))]).
step(context_member((edge(a, arc(b, 4)), edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(e, arc(f, 3))),
     rule(3),
     ['Right' = (edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(e, arc(f, 3))],
     [context_member((edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(e, arc(f, 3)))]).
step(context_member((edge(a, arc(c, 2)), edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(e, arc(f, 3))),
     rule(3),
     ['Right' = (edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(e, arc(f, 3))],
     [context_member((edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(e, arc(f, 3)))]).
step(context_member((edge(b, arc(c, 1)), edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(e, arc(f, 3))),
     rule(3),
     ['Right' = (edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(e, arc(f, 3))],
     [context_member((edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(e, arc(f, 3)))]).
step(context_member((edge(b, arc(d, 5)), edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(e, arc(f, 3))),
     rule(3),
     ['Right' = (edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(e, arc(f, 3))],
     [context_member((edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(e, arc(f, 3)))]).
step(context_member((edge(c, arc(d, 8)), edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(e, arc(f, 3))),
     rule(3),
     ['Right' = (edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(e, arc(f, 3))],
     [context_member((edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(e, arc(f, 3)))]).
step(context_member((edge(c, arc(e, 10)), edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(e, arc(f, 3))),
     rule(3),
     ['Right' = (edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))),
      'Member' = edge(e, arc(f, 3))],
     [context_member((edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(e, arc(f, 3)))]).
step(context_member((edge(d, arc(e, 2)), edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(e, arc(f, 3))),
     rule(3),
     ['Right' = (edge(d, arc(f, 6)), edge(e, arc(f, 3))), 'Member' = edge(e, arc(f, 3))],
     [context_member((edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(e, arc(f, 3)))]).
step(context_member((edge(d, arc(f, 6)), edge(e, arc(f, 3))), edge(e, arc(f, 3))),
     rule(3),
     ['Right' = edge(e, arc(f, 3)), 'Member' = edge(e, arc(f, 3))],
     [context_member(edge(e, arc(f, 3)), edge(e, arc(f, 3)))]).
step(context_member(edge(e, arc(f, 3)), edge(e, arc(f, 3))),
     rule(4),
     ['Member' = edge(e, arc(f, 3))],
     [edge(e, arc(f, 3)) \= (_left, _right)]).
step(edge(e, arc(f, 3)) \= (_left, _right), builtin, [], []).
step(path("af", ["abdef", 14]),
     rule(11),
     ['Path' = "abdef", 'Cost' = 14],
     [path(a, f, "a", "abdef", 14), 14 =< 16]).
step(path(a, f, "a", "abdef", 14),
     rule(9),
     ['Node' = a,
      'Goal' = f,
      'Visited' = "a",
      'Path' = "bdef",
      'Cost' = 14,
      'Next' = b,
      'Stepcost' = 4,
      'Restcost' = 10],
     [link(a, b, 4), \+ member(b, "a"), path(b, f, "ba", "bdef", 10), 14 is 4 + 10]).
step(link(a, b, 4), rule(6), ['A' = a, 'B' = b, 'Cost' = 4], [base_link(a, b, 4)]).
step(\+ member(b, "a"), absent, [], []).
step(path(b, f, "ba", "bdef", 10),
     rule(9),
     ['Node' = b,
      'Goal' = f,
      'Visited' = "ba",
      'Path' = "def",
      'Cost' = 10,
      'Next' = d,
      'Stepcost' = 5,
      'Restcost' = 5],
     [link(b, d, 5), \+ member(d, "ba"), path(d, f, "dba", "def", 5), 10 is 5 + 5]).
step(link(b, d, 5), rule(6), ['A' = b, 'B' = d, 'Cost' = 5], [base_link(b, d, 5)]).
step(\+ member(d, "ba"), absent, [], []).
step(path(d, f, "dba", "def", 5),
     rule(9),
     ['Node' = d,
      'Goal' = f,
      'Visited' = "dba",
      'Path' = "ef",
      'Cost' = 5,
      'Next' = e,
      'Stepcost' = 2,
      'Restcost' = 3],
     [link(d, e, 2), \+ member(e, "dba"), path(e, f, "edba", "ef", 3), 5 is 2 + 3]).
step(link(d, e, 2), rule(6), ['A' = d, 'B' = e, 'Cost' = 2], [base_link(d, e, 2)]).
step(\+ member(e, "dba"), absent, [], []).
step(path(e, f, "edba", "ef", 3),
     rule(9),
     ['Node' = e,
      'Goal' = f,
      'Visited' = "edba",
      'Path' = "f",
      'Cost' = 3,
      'Next' = f,
      'Stepcost' = 3,
      'Restcost' = 0],
     [link(e, f, 3), \+ member(f, "edba"), path(f, f, "fedba", "f", 0), 3 is 3 + 0]).
step(link(e, f, 3), rule(6), ['A' = e, 'B' = f, 'Cost' = 3], [base_link(e, f, 3)]).
step(\+ member(f, "edba"), absent, [], []).
step(path(f, f, "fedba", "f", 0), fact(8), ['Goal' = f], []).
step(3 is 3 + 0, builtin, [], []).
step(5 is 2 + 3, builtin, [], []).
step(10 is 5 + 5, builtin, [], []).
step(14 is 4 + 10, builtin, [], []).
step(14 =< 16, builtin, [], []).
step(path("af", ["abdf", 15]),
     rule(11),
     ['Path' = "abdf", 'Cost' = 15],
     [path(a, f, "a", "abdf", 15), 15 =< 16]).
step(path(a, f, "a", "abdf", 15),
     rule(9),
     ['Node' = a,
      'Goal' = f,
      'Visited' = "a",
      'Path' = "bdf",
      'Cost' = 15,
      'Next' = b,
      'Stepcost' = 4,
      'Restcost' = 11],
     [link(a, b, 4), \+ member(b, "a"), path(b, f, "ba", "bdf", 11), 15 is 4 + 11]).
step(path(b, f, "ba", "bdf", 11),
     rule(9),
     ['Node' = b,
      'Goal' = f,
      'Visited' = "ba",
      'Path' = "df",
      'Cost' = 11,
      'Next' = d,
      'Stepcost' = 5,
      'Restcost' = 6],
     [link(b, d, 5), \+ member(d, "ba"), path(d, f, "dba", "df", 6), 11 is 5 + 6]).
step(path(d, f, "dba", "df", 6),
     rule(9),
     ['Node' = d,
      'Goal' = f,
      'Visited' = "dba",
      'Path' = "f",
      'Cost' = 6,
      'Next' = f,
      'Stepcost' = 6,
      'Restcost' = 0],
     [link(d, f, 6), \+ member(f, "dba"), path(f, f, "fdba", "f", 0), 6 is 6 + 0]).
step(link(d, f, 6), rule(6), ['A' = d, 'B' = f, 'Cost' = 6], [base_link(d, f, 6)]).
step(\+ member(f, "dba"), absent, [], []).
step(path(f, f, "fdba", "f", 0), fact(8), ['Goal' = f], []).
step(6 is 6 + 0, builtin, [], []).
step(11 is 5 + 6, builtin, [], []).
step(15 is 4 + 11, builtin, [], []).
step(15 =< 16, builtin, [], []).
step(path("af", ["acdef", 15]),
     rule(11),
     ['Path' = "acdef", 'Cost' = 15],
     [path(a, f, "a", "acdef", 15), 15 =< 16]).
step(path(a, f, "a", "acdef", 15),
     rule(9),
     ['Node' = a,
      'Goal' = f,
      'Visited' = "a",
      'Path' = "cdef",
      'Cost' = 15,
      'Next' = c,
      'Stepcost' = 2,
      'Restcost' = 13],
     [link(a, c, 2), \+ member(c, "a"), path(c, f, "ca", "cdef", 13), 15 is 2 + 13]).
step(link(a, c, 2), rule(6), ['A' = a, 'B' = c, 'Cost' = 2], [base_link(a, c, 2)]).
step(\+ member(c, "a"), absent, [], []).
step(path(c, f, "ca", "cdef", 13),
     rule(9),
     ['Node' = c,
      'Goal' = f,
      'Visited' = "ca",
      'Path' = "def",
      'Cost' = 13,
      'Next' = d,
      'Stepcost' = 8,
      'Restcost' = 5],
     [link(c, d, 8), \+ member(d, "ca"), path(d, f, "dca", "def", 5), 13 is 8 + 5]).
step(link(c, d, 8), rule(6), ['A' = c, 'B' = d, 'Cost' = 8], [base_link(c, d, 8)]).
step(\+ member(d, "ca"), absent, [], []).
step(path(d, f, "dca", "def", 5),
     rule(9),
     ['Node' = d,
      'Goal' = f,
      'Visited' = "dca",
      'Path' = "ef",
      'Cost' = 5,
      'Next' = e,
      'Stepcost' = 2,
      'Restcost' = 3],
     [link(d, e, 2), \+ member(e, "dca"), path(e, f, "edca", "ef", 3), 5 is 2 + 3]).
step(\+ member(e, "dca"), absent, [], []).
step(path(e, f, "edca", "ef", 3),
     rule(9),
     ['Node' = e,
      'Goal' = f,
      'Visited' = "edca",
      'Path' = "f",
      'Cost' = 3,
      'Next' = f,
      'Stepcost' = 3,
      'Restcost' = 0],
     [link(e, f, 3), \+ member(f, "edca"), path(f, f, "fedca", "f", 0), 3 is 3 + 0]).
step(\+ member(f, "edca"), absent, [], []).
step(path(f, f, "fedca", "f", 0), fact(8), ['Goal' = f], []).
step(13 is 8 + 5, builtin, [], []).
step(15 is 2 + 13, builtin, [], []).
step(path("af", ["acdf", 16]),
     rule(11),
     ['Path' = "acdf", 'Cost' = 16],
     [path(a, f, "a", "acdf", 16), 16 =< 16]).
step(path(a, f, "a", "acdf", 16),
     rule(9),
     ['Node' = a,
      'Goal' = f,
      'Visited' = "a",
      'Path' = "cdf",
      'Cost' = 16,
      'Next' = c,
      'Stepcost' = 2,
      'Restcost' = 14],
     [link(a, c, 2), \+ member(c, "a"), path(c, f, "ca", "cdf", 14), 16 is 2 + 14]).
step(path(c, f, "ca", "cdf", 14),
     rule(9),
     ['Node' = c,
      'Goal' = f,
      'Visited' = "ca",
      'Path' = "df",
      'Cost' = 14,
      'Next' = d,
      'Stepcost' = 8,
      'Restcost' = 6],
     [link(c, d, 8), \+ member(d, "ca"), path(d, f, "dca", "df", 6), 14 is 8 + 6]).
step(path(d, f, "dca", "df", 6),
     rule(9),
     ['Node' = d,
      'Goal' = f,
      'Visited' = "dca",
      'Path' = "f",
      'Cost' = 6,
      'Next' = f,
      'Stepcost' = 6,
      'Restcost' = 0],
     [link(d, f, 6), \+ member(f, "dca"), path(f, f, "fdca", "f", 0), 6 is 6 + 0]).
step(\+ member(f, "dca"), absent, [], []).
step(path(f, f, "fdca", "f", 0), fact(8), ['Goal' = f], []).
step(14 is 8 + 6, builtin, [], []).
step(16 is 2 + 14, builtin, [], []).
step(16 =< 16, builtin, [], []).
step(path("af", ["acef", 15]),
     rule(11),
     ['Path' = "acef", 'Cost' = 15],
     [path(a, f, "a", "acef", 15), 15 =< 16]).
step(path(a, f, "a", "acef", 15),
     rule(9),
     ['Node' = a,
      'Goal' = f,
      'Visited' = "a",
      'Path' = "cef",
      'Cost' = 15,
      'Next' = c,
      'Stepcost' = 2,
      'Restcost' = 13],
     [link(a, c, 2), \+ member(c, "a"), path(c, f, "ca", "cef", 13), 15 is 2 + 13]).
step(path(c, f, "ca", "cef", 13),
     rule(9),
     ['Node' = c,
      'Goal' = f,
      'Visited' = "ca",
      'Path' = "ef",
      'Cost' = 13,
      'Next' = e,
      'Stepcost' = 10,
      'Restcost' = 3],
     [link(c, e, 10), \+ member(e, "ca"), path(e, f, "eca", "ef", 3), 13 is 10 + 3]).
step(link(c, e, 10), rule(6), ['A' = c, 'B' = e, 'Cost' = 10], [base_link(c, e, 10)]).
step(\+ member(e, "ca"), absent, [], []).
step(path(e, f, "eca", "ef", 3),
     rule(9),
     ['Node' = e,
      'Goal' = f,
      'Visited' = "eca",
      'Path' = "f",
      'Cost' = 3,
      'Next' = f,
      'Stepcost' = 3,
      'Restcost' = 0],
     [link(e, f, 3), \+ member(f, "eca"), path(f, f, "feca", "f", 0), 3 is 3 + 0]).
step(\+ member(f, "eca"), absent, [], []).
step(path(f, f, "feca", "f", 0), fact(8), ['Goal' = f], []).
step(13 is 10 + 3, builtin, [], []).
step(path("af", ["acbdef", 13]),
     rule(11),
     ['Path' = "acbdef", 'Cost' = 13],
     [path(a, f, "a", "acbdef", 13), 13 =< 16]).
step(path(a, f, "a", "acbdef", 13),
     rule(9),
     ['Node' = a,
      'Goal' = f,
      'Visited' = "a",
      'Path' = "cbdef",
      'Cost' = 13,
      'Next' = c,
      'Stepcost' = 2,
      'Restcost' = 11],
     [link(a, c, 2), \+ member(c, "a"), path(c, f, "ca", "cbdef", 11), 13 is 2 + 11]).
step(path(c, f, "ca", "cbdef", 11),
     rule(9),
     ['Node' = c,
      'Goal' = f,
      'Visited' = "ca",
      'Path' = "bdef",
      'Cost' = 11,
      'Next' = b,
      'Stepcost' = 1,
      'Restcost' = 10],
     [link(c, b, 1), \+ member(b, "ca"), path(b, f, "bca", "bdef", 10), 11 is 1 + 10]).
step(link(c, b, 1), rule(7), ['B' = c, 'A' = b, 'Cost' = 1], [base_link(b, c, 1)]).
step(\+ member(b, "ca"), absent, [], []).
step(path(b, f, "bca", "bdef", 10),
     rule(9),
     ['Node' = b,
      'Goal' = f,
      'Visited' = "bca",
      'Path' = "def",
      'Cost' = 10,
      'Next' = d,
      'Stepcost' = 5,
      'Restcost' = 5],
     [link(b, d, 5), \+ member(d, "bca"), path(d, f, "dbca", "def", 5), 10 is 5 + 5]).
step(\+ member(d, "bca"), absent, [], []).
step(path(d, f, "dbca", "def", 5),
     rule(9),
     ['Node' = d,
      'Goal' = f,
      'Visited' = "dbca",
      'Path' = "ef",
      'Cost' = 5,
      'Next' = e,
      'Stepcost' = 2,
      'Restcost' = 3],
     [link(d, e, 2), \+ member(e, "dbca"), path(e, f, "edbca", "ef", 3), 5 is 2 + 3]).
step(\+ member(e, "dbca"), absent, [], []).
step(path(e, f, "edbca", "ef", 3),
     rule(9),
     ['Node' = e,
      'Goal' = f,
      'Visited' = "edbca",
      'Path' = "f",
      'Cost' = 3,
      'Next' = f,
      'Stepcost' = 3,
      'Restcost' = 0],
     [link(e, f, 3), \+ member(f, "edbca"), path(f, f, "fedbca", "f", 0), 3 is 3 + 0]).
step(\+ member(f, "edbca"), absent, [], []).
step(path(f, f, "fedbca", "f", 0), fact(8), ['Goal' = f], []).
step(11 is 1 + 10, builtin, [], []).
step(13 is 2 + 11, builtin, [], []).
step(13 =< 16, builtin, [], []).
step(path("af", ["acbdf", 14]),
     rule(11),
     ['Path' = "acbdf", 'Cost' = 14],
     [path(a, f, "a", "acbdf", 14), 14 =< 16]).
step(path(a, f, "a", "acbdf", 14),
     rule(9),
     ['Node' = a,
      'Goal' = f,
      'Visited' = "a",
      'Path' = "cbdf",
      'Cost' = 14,
      'Next' = c,
      'Stepcost' = 2,
      'Restcost' = 12],
     [link(a, c, 2), \+ member(c, "a"), path(c, f, "ca", "cbdf", 12), 14 is 2 + 12]).
step(path(c, f, "ca", "cbdf", 12),
     rule(9),
     ['Node' = c,
      'Goal' = f,
      'Visited' = "ca",
      'Path' = "bdf",
      'Cost' = 12,
      'Next' = b,
      'Stepcost' = 1,
      'Restcost' = 11],
     [link(c, b, 1), \+ member(b, "ca"), path(b, f, "bca", "bdf", 11), 12 is 1 + 11]).
step(path(b, f, "bca", "bdf", 11),
     rule(9),
     ['Node' = b,
      'Goal' = f,
      'Visited' = "bca",
      'Path' = "df",
      'Cost' = 11,
      'Next' = d,
      'Stepcost' = 5,
      'Restcost' = 6],
     [link(b, d, 5), \+ member(d, "bca"), path(d, f, "dbca", "df", 6), 11 is 5 + 6]).
step(path(d, f, "dbca", "df", 6),
     rule(9),
     ['Node' = d,
      'Goal' = f,
      'Visited' = "dbca",
      'Path' = "f",
      'Cost' = 6,
      'Next' = f,
      'Stepcost' = 6,
      'Restcost' = 0],
     [link(d, f, 6), \+ member(f, "dbca"), path(f, f, "fdbca", "f", 0), 6 is 6 + 0]).
step(\+ member(f, "dbca"), absent, [], []).
step(path(f, f, "fdbca", "f", 0), fact(8), ['Goal' = f], []).
step(12 is 1 + 11, builtin, [], []).
step(14 is 2 + 12, builtin, [], []).
