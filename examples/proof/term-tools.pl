report(shape, shape(edge, 3)).
why(
  report(shape, shape(edge, 3)),
  step(
    report(shape, shape(edge, 3)),
    rule("term-tools.pl", clause(3)),
    ['Name' = edge, 'Arity' = 3],
    [
      step(functor(edge(a, b, 3), edge, 3), builtin(functor, 3), [], [])
    ]
  )
).

report(second_argument, b).
why(
  report(second_argument, b),
  step(
    report(second_argument, b),
    rule("term-tools.pl", clause(4)),
    ['Node' = b],
    [
      step(arg(2, edge(a, b, 3), b), builtin(arg, 3), [], [])
    ]
  )
).

report(parts, parts(edge, [a, b, 3])).
why(
  report(parts, parts(edge, [a, b, 3])),
  step(
    report(parts, parts(edge, [a, b, 3])),
    rule("term-tools.pl", clause(5)),
    ['Name' = edge, 'Args' = [a, b, 3]],
    [
      step('=..'(edge(a, b, 3), [edge, a, b, 3]), builtin('=..', 2), [], [])
    ]
  )
).

report(rebuilt, edge(c, d, 5)).
why(
  report(rebuilt, edge(c, d, 5)),
  step(
    report(rebuilt, edge(c, d, 5)),
    rule("term-tools.pl", clause(6)),
    ['Term' = edge(c, d, 5)],
    [
      step('=..'(edge(c, d, 5), [edge, c, d, 5]), builtin('=..', 2), [], [])
    ]
  )
).

report(rendered, 'edge(a, [b, c])').
why(
  report(rendered, 'edge(a, [b, c])'),
  step(
    report(rendered, 'edge(a, [b, c])'),
    rule("term-tools.pl", clause(7)),
    ['Text' = 'edge(a, [b, c])'],
    [
      step(term_string(edge(a, "bc"), 'edge(a, [b, c])'), library(term_string, 2), [], [])
    ]
  )
).

report(all_weights_positive, yes).
why(
  report(all_weights_positive, yes),
  step(
    report(all_weights_positive, yes),
    rule("term-tools.pl", clause(8)),
    [],
    [
      step('\\+'(nonpositive_edge), builtin('\\+', 1), [], [])
    ]
  )
).

