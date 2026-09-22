reachable(reachability_case, path(a, f)).
why(
  reachable(reachability_case, path(a, f)),
  step(
    reachable(reachability_case, path(a, f)),
    rule("graph-reachability.pl", clause(11)),
    [],
    [
      step(
        is_reachable(a, f),
        rule("graph-reachability.pl", clause(10)),
        ['Start' = a, 'Goal' = f],
        [
          step(
            reachable_via(a, f, "a"),
            rule("graph-reachability.pl", clause(9)),
            ['Start' = a, 'Goal' = f, 'Visited' = "a", 'Next' = b],
            [
              step(edge(a, b), fact("graph-reachability.pl", clause(1)), [], []),
              step('\\+'(member(b, "a")), builtin('\\+', 1), [], []),
              step(
                reachable_via(b, f, "ba"),
                rule("graph-reachability.pl", clause(9)),
                ['Start' = b, 'Goal' = f, 'Visited' = "ba", 'Next' = d],
                [
                  step(edge(b, d), fact("graph-reachability.pl", clause(3)), [], []),
                  step('\\+'(member(d, "ba")), builtin('\\+', 1), [], []),
                  step(
                    reachable_via(d, f, "dba"),
                    rule("graph-reachability.pl", clause(9)),
                    ['Start' = d, 'Goal' = f, 'Visited' = "dba", 'Next' = f],
                    [
                      step(edge(d, f), fact("graph-reachability.pl", clause(5)), [], []),
                      step('\\+'(member(f, "dba")), builtin('\\+', 1), [], []),
                      step(reachable_via(f, f, "fdba"), fact("graph-reachability.pl", clause(8)), ['Node' = f, '_visited' = "fdba"], [])
                    ]
                  )
                ]
              )
            ]
          )
        ]
      )
    ]
  )
).

reachable(reachability_case, path(c, g)).
why(
  reachable(reachability_case, path(c, g)),
  step(
    reachable(reachability_case, path(c, g)),
    rule("graph-reachability.pl", clause(12)),
    [],
    [
      step(
        is_reachable(c, g),
        rule("graph-reachability.pl", clause(10)),
        ['Start' = c, 'Goal' = g],
        [
          step(
            reachable_via(c, g, "c"),
            rule("graph-reachability.pl", clause(9)),
            ['Start' = c, 'Goal' = g, 'Visited' = "c", 'Next' = e],
            [
              step(edge(c, e), fact("graph-reachability.pl", clause(4)), [], []),
              step('\\+'(member(e, "c")), builtin('\\+', 1), [], []),
              step(
                reachable_via(e, g, "ec"),
                rule("graph-reachability.pl", clause(9)),
                ['Start' = e, 'Goal' = g, 'Visited' = "ec", 'Next' = f],
                [
                  step(edge(e, f), fact("graph-reachability.pl", clause(6)), [], []),
                  step('\\+'(member(f, "ec")), builtin('\\+', 1), [], []),
                  step(
                    reachable_via(f, g, "fec"),
                    rule("graph-reachability.pl", clause(9)),
                    ['Start' = f, 'Goal' = g, 'Visited' = "fec", 'Next' = g],
                    [
                      step(edge(f, g), fact("graph-reachability.pl", clause(7)), [], []),
                      step('\\+'(member(g, "fec")), builtin('\\+', 1), [], []),
                      step(reachable_via(g, g, "gfec"), fact("graph-reachability.pl", clause(8)), ['Node' = g, '_visited' = "gfec"], [])
                    ]
                  )
                ]
              )
            ]
          )
        ]
      )
    ]
  )
).

not_reachable(reachability_case, path(b, e)).
why(
  not_reachable(reachability_case, path(b, e)),
  step(
    not_reachable(reachability_case, path(b, e)),
    rule("graph-reachability.pl", clause(13)),
    [],
    [
      step('\\+'(is_reachable(b, e)), builtin('\\+', 1), [], [])
    ]
  )
).

