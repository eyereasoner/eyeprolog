status(bob, compliant).
why(
  status(bob, compliant),
  step(
    status(bob, compliant),
    rule("workplace-compliance.pl", clause(10)),
    ['Person' = bob],
    [
      step(employee(bob), fact("workplace-compliance.pl", clause(2)), [], []),
      step(does(bob, work_related_task), fact("workplace-compliance.pl", clause(6)), [], []),
      step(does(bob, log_off_at_end_of_shift), fact("workplace-compliance.pl", clause(7)), [], [])
    ]
  )
).

status(alice, compliant).
why(
  status(alice, compliant),
  step(
    status(alice, compliant),
    rule("workplace-compliance.pl", clause(11)),
    ['Person' = alice],
    [
      step(employee(alice), fact("workplace-compliance.pl", clause(1)), [], []),
      step(does(alice, log_off_at_end_of_shift), fact("workplace-compliance.pl", clause(5)), [], []),
      step('\\+'(does(alice, work_related_task)), builtin('\\+', 1), [], [])
    ]
  )
).

status(dave, non_compliant).
why(
  status(dave, non_compliant),
  step(
    status(dave, non_compliant),
    rule("workplace-compliance.pl", clause(12)),
    ['Person' = dave],
    [
      step(employee(dave), fact("workplace-compliance.pl", clause(4)), [], []),
      step(does(dave, work_related_task), fact("workplace-compliance.pl", clause(9)), [], []),
      step('\\+'(does(dave, log_off_at_end_of_shift)), builtin('\\+', 1), [], [])
    ]
  )
).

status(carol, non_compliant).
why(
  status(carol, non_compliant),
  step(
    status(carol, non_compliant),
    rule("workplace-compliance.pl", clause(13)),
    ['Person' = carol],
    [
      step(employee(carol), fact("workplace-compliance.pl", clause(3)), [], []),
      step(does(carol, access_social_media), fact("workplace-compliance.pl", clause(8)), [], [])
    ]
  )
).

