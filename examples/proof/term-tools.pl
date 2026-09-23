report(shape, shape(edge, 3)).
report(second_argument, b).
report(parts, parts(edge, [a, b, 3])).
report(rebuilt, edge(c, d, 5)).
report(rendered, 'edge(a, [b, c])').
report(all_weights_positive, yes).

clause(3,
       report(shape, shape(var('Name'), var('Arity'))),
       functor(edge(a, b, 3), var('Name'), var('Arity'))).
clause(4, report(second_argument, var('Node')), arg(2, edge(a, b, 3), var('Node'))).
clause(5,
       report(parts, parts(var('Name'), var('Args'))),
       edge(a, b, 3) =.. [var('Name') | var('Args')]).
clause(6, report(rebuilt, var('Term')), var('Term') =.. [edge, c, d, 5]).
clause(7, report(rendered, var('Text')), term_string(edge(a, "bc"), var('Text'))).
clause(8, report(all_weights_positive, yes), \+ nonpositive_edge).

step(report(shape, shape(edge, 3)),
     rule(3),
     ['Name' = edge, 'Arity' = 3],
     [functor(edge(a, b, 3), edge, 3)]).
step(functor(edge(a, b, 3), edge, 3), builtin, [], []).
step(report(second_argument, b), rule(4), ['Node' = b], [arg(2, edge(a, b, 3), b)]).
step(arg(2, edge(a, b, 3), b), builtin, [], []).
step(report(parts, parts(edge, [a, b, 3])),
     rule(5),
     ['Name' = edge, 'Args' = [a, b, 3]],
     [edge(a, b, 3) =.. [edge, a, b, 3]]).
step(edge(a, b, 3) =.. [edge, a, b, 3], builtin, [], []).
step(report(rebuilt, edge(c, d, 5)),
     rule(6),
     ['Term' = edge(c, d, 5)],
     [edge(c, d, 5) =.. [edge, c, d, 5]]).
step(edge(c, d, 5) =.. [edge, c, d, 5], builtin, [], []).
step(report(rendered, 'edge(a, [b, c])'),
     rule(7),
     ['Text' = 'edge(a, [b, c])'],
     [term_string(edge(a, "bc"), 'edge(a, [b, c])')]).
step(term_string(edge(a, "bc"), 'edge(a, [b, c])'), builtin, [], []).
step(report(all_weights_positive, yes), rule(8), [], [\+ nonpositive_edge]).
step(\+ nonpositive_edge, absent, [], []).
