route_to_nantes(angers, go(angers, nantes, goal)).
why(
  route_to_nantes(angers, go(angers, nantes, goal)),
  proof(
    goal(route_to_nantes(angers, go(angers, nantes, goal))),
    by(rule("route-planning.pl", clause(13))),
    bindings([binding("From", angers), binding("Plan", go(angers, nantes, goal))]),
    uses([
      proof(
        goal(path([angers, nantes], go(angers, nantes, goal))),
        by(rule("route-planning.pl", clause(11))),
        bindings([binding("A", angers), binding("B", nantes)]),
        uses([
          proof(
            goal(oneway(angers, nantes)),
            by(fact("route-planning.pl", clause(10)))
          )
        ])
      )
    ])
  )
).

route_to_nantes(paris, go(paris, chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal))))).
why(
  route_to_nantes(paris, go(paris, chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal))))),
  proof(
    goal(route_to_nantes(paris, go(paris, chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal)))))),
    by(rule("route-planning.pl", clause(13))),
    bindings([binding("From", paris), binding("Plan", go(paris, chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal)))))]),
    uses([
      proof(
        goal(path([paris, nantes], go(paris, chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal)))))),
        by(rule("route-planning.pl", clause(12))),
        bindings([binding("A", paris), binding("C", nantes), binding("B", chartres), binding("Rest", go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal))))]),
        uses([
          proof(
            goal(oneway(paris, chartres)),
            by(fact("route-planning.pl", clause(2)))
          ),
          proof(
            goal(path([chartres, nantes], go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal))))),
            by(rule("route-planning.pl", clause(12))),
            bindings([binding("A", chartres), binding("C", nantes), binding("B", lemans), binding("Rest", go(lemans, angers, go(angers, nantes, goal)))]),
            uses([
              proof(
                goal(oneway(chartres, lemans)),
                by(fact("route-planning.pl", clause(7)))
              ),
              proof(
                goal(path([lemans, nantes], go(lemans, angers, go(angers, nantes, goal)))),
                by(rule("route-planning.pl", clause(12))),
                bindings([binding("A", lemans), binding("C", nantes), binding("B", angers), binding("Rest", go(angers, nantes, goal))]),
                uses([
                  proof(
                    goal(oneway(lemans, angers)),
                    by(fact("route-planning.pl", clause(8)))
                  ),
                  proof(
                    goal(path([angers, nantes], go(angers, nantes, goal))),
                    by(rule("route-planning.pl", clause(11))),
                    bindings([binding("A", angers), binding("B", nantes)]),
                    uses([
                      proof(
                        goal(oneway(angers, nantes)),
                        by(fact("route-planning.pl", clause(10)))
                      )
                    ])
                  )
                ])
              )
            ])
          )
        ])
      )
    ])
  )
).

route_to_nantes(chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal)))).
why(
  route_to_nantes(chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal)))),
  proof(
    goal(route_to_nantes(chartres, go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal))))),
    by(rule("route-planning.pl", clause(13))),
    bindings([binding("From", chartres), binding("Plan", go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal))))]),
    uses([
      proof(
        goal(path([chartres, nantes], go(chartres, lemans, go(lemans, angers, go(angers, nantes, goal))))),
        by(rule("route-planning.pl", clause(12))),
        bindings([binding("A", chartres), binding("C", nantes), binding("B", lemans), binding("Rest", go(lemans, angers, go(angers, nantes, goal)))]),
        uses([
          proof(
            goal(oneway(chartres, lemans)),
            by(fact("route-planning.pl", clause(7)))
          ),
          proof(
            goal(path([lemans, nantes], go(lemans, angers, go(angers, nantes, goal)))),
            by(rule("route-planning.pl", clause(12))),
            bindings([binding("A", lemans), binding("C", nantes), binding("B", angers), binding("Rest", go(angers, nantes, goal))]),
            uses([
              proof(
                goal(oneway(lemans, angers)),
                by(fact("route-planning.pl", clause(8)))
              ),
              proof(
                goal(path([angers, nantes], go(angers, nantes, goal))),
                by(rule("route-planning.pl", clause(11))),
                bindings([binding("A", angers), binding("B", nantes)]),
                uses([
                  proof(
                    goal(oneway(angers, nantes)),
                    by(fact("route-planning.pl", clause(10)))
                  )
                ])
              )
            ])
          )
        ])
      )
    ])
  )
).

route_to_nantes(lemans, go(lemans, angers, go(angers, nantes, goal))).
why(
  route_to_nantes(lemans, go(lemans, angers, go(angers, nantes, goal))),
  proof(
    goal(route_to_nantes(lemans, go(lemans, angers, go(angers, nantes, goal)))),
    by(rule("route-planning.pl", clause(13))),
    bindings([binding("From", lemans), binding("Plan", go(lemans, angers, go(angers, nantes, goal)))]),
    uses([
      proof(
        goal(path([lemans, nantes], go(lemans, angers, go(angers, nantes, goal)))),
        by(rule("route-planning.pl", clause(12))),
        bindings([binding("A", lemans), binding("C", nantes), binding("B", angers), binding("Rest", go(angers, nantes, goal))]),
        uses([
          proof(
            goal(oneway(lemans, angers)),
            by(fact("route-planning.pl", clause(8)))
          ),
          proof(
            goal(path([angers, nantes], go(angers, nantes, goal))),
            by(rule("route-planning.pl", clause(11))),
            bindings([binding("A", angers), binding("B", nantes)]),
            uses([
              proof(
                goal(oneway(angers, nantes)),
                by(fact("route-planning.pl", clause(10)))
              )
            ])
          )
        ])
      )
    ])
  )
).

