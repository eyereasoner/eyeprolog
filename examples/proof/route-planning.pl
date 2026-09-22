route_to_nantes(angers, go(angers, nantes, goal)).
why(
  route_to_nantes(angers, go(angers, nantes, goal)),
  step(
    route_to_nantes(angers, go(angers, nantes, goal)),
    rule("route-planning.pl", clause(13)),
    ['From' = angers, 'Plan' = go(angers, nantes, goal)],
    [
      step(
        path([angers, nantes], go(angers, nantes, goal)),
        rule("route-planning.pl", clause(11)),
        ['A' = angers, 'B' = nantes],
        [
          step(oneway(angers, nantes), fact("route-planning.pl", clause(10)), [], [])
        ]
      )
    ]
  )
).

route_to_nantes(paris, go(paris, chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal))))).
why(
  route_to_nantes(paris, go(paris, chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal))))),
  step(
    route_to_nantes(paris, go(paris, chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal))))),
    rule("route-planning.pl", clause(13)),
    ['From' = paris, 'Plan' = go(paris, chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal))))],
    [
      step(
        path([paris, nantes], go(paris, chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal))))),
        rule("route-planning.pl", clause(12)),
        ['A' = paris, 'C' = nantes, 'B' = chartres, 'Rest' = go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal)))],
        [
          step(oneway(paris, chartres), fact("route-planning.pl", clause(2)), [], []),
          step(
            path([chartres, nantes], go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal)))),
            rule("route-planning.pl", clause(12)),
            ['A' = chartres, 'C' = nantes, 'B' = lemans, 'Rest' = go(lemans, angers, go(angers, nantes, goal))],
            [
              step(oneway(chartres, lemans), fact("route-planning.pl", clause(7)), [], []),
              step(
                path([lemans, nantes], go(lemans, angers, go(angers, nantes, goal))),
                rule("route-planning.pl", clause(12)),
                ['A' = lemans, 'C' = nantes, 'B' = angers, 'Rest' = go(angers, nantes, goal)],
                [
                  step(oneway(lemans, angers), fact("route-planning.pl", clause(8)), [], []),
                  step(
                    path([angers, nantes], go(angers, nantes, goal)),
                    rule("route-planning.pl", clause(11)),
                    ['A' = angers, 'B' = nantes],
                    [
                      step(oneway(angers, nantes), fact("route-planning.pl", clause(10)), [], [])
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

route_to_nantes(chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal)))).
why(
  route_to_nantes(chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal)))),
  step(
    route_to_nantes(chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal)))),
    rule("route-planning.pl", clause(13)),
    ['From' = chartres, 'Plan' = go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal)))],
    [
      step(
        path([chartres, nantes], go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal)))),
        rule("route-planning.pl", clause(12)),
        ['A' = chartres, 'C' = nantes, 'B' = lemans, 'Rest' = go(lemans, angers, go(angers, nantes, goal))],
        [
          step(oneway(chartres, lemans), fact("route-planning.pl", clause(7)), [], []),
          step(
            path([lemans, nantes], go(lemans, angers, go(angers, nantes, goal))),
            rule("route-planning.pl", clause(12)),
            ['A' = lemans, 'C' = nantes, 'B' = angers, 'Rest' = go(angers, nantes, goal)],
            [
              step(oneway(lemans, angers), fact("route-planning.pl", clause(8)), [], []),
              step(
                path([angers, nantes], go(angers, nantes, goal)),
                rule("route-planning.pl", clause(11)),
                ['A' = angers, 'B' = nantes],
                [
                  step(oneway(angers, nantes), fact("route-planning.pl", clause(10)), [], [])
                ]
              )
            ]
          )
        ]
      )
    ]
  )
).

route_to_nantes(lemans, go(lemans, angers, go(angers, nantes, goal))).
why(
  route_to_nantes(lemans, go(lemans, angers, go(angers, nantes, goal))),
  step(
    route_to_nantes(lemans, go(lemans, angers, go(angers, nantes, goal))),
    rule("route-planning.pl", clause(13)),
    ['From' = lemans, 'Plan' = go(lemans, angers, go(angers, nantes, goal))],
    [
      step(
        path([lemans, nantes], go(lemans, angers, go(angers, nantes, goal))),
        rule("route-planning.pl", clause(12)),
        ['A' = lemans, 'C' = nantes, 'B' = angers, 'Rest' = go(angers, nantes, goal)],
        [
          step(oneway(lemans, angers), fact("route-planning.pl", clause(8)), [], []),
          step(
            path([angers, nantes], go(angers, nantes, goal)),
            rule("route-planning.pl", clause(11)),
            ['A' = angers, 'B' = nantes],
            [
              step(oneway(angers, nantes), fact("route-planning.pl", clause(10)), [], [])
            ]
          )
        ]
      )
    ]
  )
).

