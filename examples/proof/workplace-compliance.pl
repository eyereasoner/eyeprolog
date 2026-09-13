status(bob, compliant).
why(
  status(bob, compliant),
  proof(
    goal(status(bob, compliant)),
    by(rule("workplace-compliance.pl", clause(10))),
    bindings([binding("Person", bob)]),
    uses([
      proof(
        goal(employee(bob)),
        by(fact("workplace-compliance.pl", clause(2)))
      ),
      proof(
        goal(does(bob, work_related_task)),
        by(fact("workplace-compliance.pl", clause(6)))
      ),
      proof(
        goal(does(bob, log_off_at_end_of_shift)),
        by(fact("workplace-compliance.pl", clause(7)))
      )
    ])
  )
).

status(alice, compliant).
why(
  status(alice, compliant),
  proof(
    goal(status(alice, compliant)),
    by(rule("workplace-compliance.pl", clause(11))),
    bindings([binding("Person", alice)]),
    uses([
      proof(
        goal(employee(alice)),
        by(fact("workplace-compliance.pl", clause(1)))
      ),
      proof(
        goal(does(alice, log_off_at_end_of_shift)),
        by(fact("workplace-compliance.pl", clause(5)))
      ),
      proof(
        goal('\\+'(does(alice, work_related_task))),
        by(builtin('\\+', 1))
      )
    ])
  )
).

status(dave, non_compliant).
why(
  status(dave, non_compliant),
  proof(
    goal(status(dave, non_compliant)),
    by(rule("workplace-compliance.pl", clause(12))),
    bindings([binding("Person", dave)]),
    uses([
      proof(
        goal(employee(dave)),
        by(fact("workplace-compliance.pl", clause(4)))
      ),
      proof(
        goal(does(dave, work_related_task)),
        by(fact("workplace-compliance.pl", clause(9)))
      ),
      proof(
        goal('\\+'(does(dave, log_off_at_end_of_shift))),
        by(builtin('\\+', 1))
      )
    ])
  )
).

status(carol, non_compliant).
why(
  status(carol, non_compliant),
  proof(
    goal(status(carol, non_compliant)),
    by(rule("workplace-compliance.pl", clause(13))),
    bindings([binding("Person", carol)]),
    uses([
      proof(
        goal(employee(carol)),
        by(fact("workplace-compliance.pl", clause(3)))
      ),
      proof(
        goal(does(carol, access_social_media)),
        by(fact("workplace-compliance.pl", clause(8)))
      )
    ])
  )
).

