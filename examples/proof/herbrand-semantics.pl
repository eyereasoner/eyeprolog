different(alice, bob).
why(
  different(alice, bob),
  step(
    different(alice, bob),
    rule("herbrand-semantics.pl", clause(1)),
    [],
    [
      step(\=(alice, bob), builtin(\=, 2), [], [])
    ]
  )
).

different(ticket(alice), ticket(bob)).
why(
  different(ticket(alice), ticket(bob)),
  step(
    different(ticket(alice), ticket(bob)),
    rule("herbrand-semantics.pl", clause(2)),
    [],
    [
      step(\=(ticket(alice), ticket(bob)), builtin(\=, 2), [], [])
    ]
  )
).

