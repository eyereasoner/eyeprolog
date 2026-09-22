report(first_destination, ghent).
why(
  report(first_destination, ghent),
  step(
    report(first_destination, ghent),
    rule("iso-control-and-errors.pl", clause(8)),
    ['To' = ghent],
    [
      step(
        first_destination(antwerp, ghent),
        rule("iso-control-and-errors.pl", clause(3)),
        ['From' = antwerp, 'To' = ghent],
        [
          step(
            once(route(antwerp, ghent)),
            builtin(once, 1),
            [],
            [
              step(route(antwerp, ghent), fact("iso-control-and-errors.pl", clause(1)), [], [])
            ]
          )
        ]
      )
    ]
  )
).

report(cut_destination, ghent).
why(
  report(cut_destination, ghent),
  step(
    report(cut_destination, ghent),
    rule("iso-control-and-errors.pl", clause(9)),
    ['To' = ghent],
    [
      step(
        preferred_destination(antwerp, ghent),
        rule("iso-control-and-errors.pl", clause(4)),
        ['From' = antwerp, 'To' = ghent],
        [
          step(route(antwerp, ghent), fact("iso-control-and-errors.pl", clause(1)), [], []),
          step(!, builtin(goal, 0), [], [])
        ]
      )
    ]
  )
).

report(existing_route, connected).
why(
  report(existing_route, connected),
  step(
    report(existing_route, connected),
    rule("iso-control-and-errors.pl", clause(10)),
    ['Status' = connected],
    [
      step(
        travel_status(antwerp, ghent, connected),
        rule("iso-control-and-errors.pl", clause(5)),
        ['From' = antwerp, 'To' = ghent, 'Status' = connected],
        [
          step(';'(->(call(route(antwerp, ghent)), =(connected, connected)), =(connected, disconnected)), builtin(';', 2), [], [])
        ]
      )
    ]
  )
).

report(missing_route, disconnected).
why(
  report(missing_route, disconnected),
  step(
    report(missing_route, disconnected),
    rule("iso-control-and-errors.pl", clause(11)),
    ['Status' = disconnected],
    [
      step(
        travel_status(antwerp, paris, disconnected),
        rule("iso-control-and-errors.pl", clause(5)),
        ['From' = antwerp, 'To' = paris, 'Status' = disconnected],
        [
          step(';'(->(call(route(antwerp, paris)), =(disconnected, connected)), =(disconnected, disconnected)), builtin(';', 2), [], [])
        ]
      )
    ]
  )
).

report(recovered_exception, rejected).
why(
  report(recovered_exception, rejected),
  step(
    report(recovered_exception, rejected),
    rule("iso-control-and-errors.pl", clause(12)),
    ['Result' = rejected],
    [
      step(
        checked_route(antwerp, paris, rejected),
        rule("iso-control-and-errors.pl", clause(7)),
        ['From' = antwerp, 'To' = paris, 'Result' = rejected],
        [
          step(catch((require_route(antwerp, paris), =(rejected, accepted)), no_route(antwerp, paris), =(rejected, rejected)), builtin(catch, 3), [], [])
        ]
      )
    ]
  )
).

