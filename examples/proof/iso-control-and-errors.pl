report(first_destination, ghent).
why(
  report(first_destination, ghent),
  proof(
    goal(report(first_destination, ghent)),
    by(rule("iso-control-and-errors.pl", clause(8))),
    bindings([binding("To", ghent)]),
    uses([
      proof(
        goal(first_destination(antwerp, ghent)),
        by(rule("iso-control-and-errors.pl", clause(3))),
        bindings([binding("From", antwerp), binding("To", ghent)]),
        uses([
          proof(
            goal(once(route(antwerp, ghent))),
            by(builtin(once, 1)),
            uses([
              proof(
                goal(route(antwerp, ghent)),
                by(fact("iso-control-and-errors.pl", clause(1)))
              )
            ])
          )
        ])
      )
    ])
  )
).

report(cut_destination, ghent).
why(
  report(cut_destination, ghent),
  proof(
    goal(report(cut_destination, ghent)),
    by(rule("iso-control-and-errors.pl", clause(9))),
    bindings([binding("To", ghent)]),
    uses([
      proof(
        goal(preferred_destination(antwerp, ghent)),
        by(rule("iso-control-and-errors.pl", clause(4))),
        bindings([binding("From", antwerp), binding("To", ghent)]),
        uses([
          proof(
            goal(route(antwerp, ghent)),
            by(fact("iso-control-and-errors.pl", clause(1)))
          ),
          proof(
            goal(!),
            by(builtin(goal, 0))
          )
        ])
      )
    ])
  )
).

report(existing_route, connected).
why(
  report(existing_route, connected),
  proof(
    goal(report(existing_route, connected)),
    by(rule("iso-control-and-errors.pl", clause(10))),
    bindings([binding("Status", connected)]),
    uses([
      proof(
        goal(travel_status(antwerp, ghent, connected)),
        by(rule("iso-control-and-errors.pl", clause(5))),
        bindings([binding("From", antwerp), binding("To", ghent), binding("Status", connected)]),
        uses([
          proof(
            goal(';'(->(call(route(antwerp, ghent)), =(connected, connected)), =(connected, disconnected))),
            by(builtin(';', 2))
          )
        ])
      )
    ])
  )
).

report(missing_route, disconnected).
why(
  report(missing_route, disconnected),
  proof(
    goal(report(missing_route, disconnected)),
    by(rule("iso-control-and-errors.pl", clause(11))),
    bindings([binding("Status", disconnected)]),
    uses([
      proof(
        goal(travel_status(antwerp, paris, disconnected)),
        by(rule("iso-control-and-errors.pl", clause(5))),
        bindings([binding("From", antwerp), binding("To", paris), binding("Status", disconnected)]),
        uses([
          proof(
            goal(';'(->(call(route(antwerp, paris)), =(disconnected, connected)), =(disconnected, disconnected))),
            by(builtin(';', 2))
          )
        ])
      )
    ])
  )
).

report(recovered_exception, rejected).
why(
  report(recovered_exception, rejected),
  proof(
    goal(report(recovered_exception, rejected)),
    by(rule("iso-control-and-errors.pl", clause(12))),
    bindings([binding("Result", rejected)]),
    uses([
      proof(
        goal(checked_route(antwerp, paris, rejected)),
        by(rule("iso-control-and-errors.pl", clause(7))),
        bindings([binding("From", antwerp), binding("To", paris), binding("Result", rejected)]),
        uses([
          proof(
            goal(catch((require_route(antwerp, paris), =(rejected, accepted)), no_route(antwerp, paris), =(rejected, rejected))),
            by(builtin(catch, 3))
          )
        ])
      )
    ])
  )
).

