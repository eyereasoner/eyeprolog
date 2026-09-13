path('<urn:example:a>', '<urn:example:b>').
why(
  path('<urn:example:a>', '<urn:example:b>'),
  proof(
    goal(path('<urn:example:a>', '<urn:example:b>')),
    by(rule("language.pl", clause(5))),
    bindings([binding("X", '<urn:example:a>'), binding("Y", '<urn:example:b>')]),
    uses([
      proof(
        goal(edge('<urn:example:a>', '<urn:example:b>')),
        by(fact("language.pl", clause(2)))
      )
    ])
  )
).

path('<urn:example:b>', '<urn:example:c>').
why(
  path('<urn:example:b>', '<urn:example:c>'),
  proof(
    goal(path('<urn:example:b>', '<urn:example:c>')),
    by(rule("language.pl", clause(5))),
    bindings([binding("X", '<urn:example:b>'), binding("Y", '<urn:example:c>')]),
    uses([
      proof(
        goal(edge('<urn:example:b>', '<urn:example:c>')),
        by(fact("language.pl", clause(3)))
      )
    ])
  )
).

path('<urn:example:c>', '<urn:example:d>').
why(
  path('<urn:example:c>', '<urn:example:d>'),
  proof(
    goal(path('<urn:example:c>', '<urn:example:d>')),
    by(rule("language.pl", clause(5))),
    bindings([binding("X", '<urn:example:c>'), binding("Y", '<urn:example:d>')]),
    uses([
      proof(
        goal(edge('<urn:example:c>', '<urn:example:d>')),
        by(fact("language.pl", clause(4)))
      )
    ])
  )
).

path('<urn:example:a>', '<urn:example:c>').
why(
  path('<urn:example:a>', '<urn:example:c>'),
  proof(
    goal(path('<urn:example:a>', '<urn:example:c>')),
    by(rule("language.pl", clause(6))),
    bindings([binding("X", '<urn:example:a>'), binding("Z", '<urn:example:c>'), binding("Y", '<urn:example:b>')]),
    uses([
      proof(
        goal(edge('<urn:example:a>', '<urn:example:b>')),
        by(fact("language.pl", clause(2)))
      ),
      proof(
        goal(path('<urn:example:b>', '<urn:example:c>')),
        by(rule("language.pl", clause(5))),
        bindings([binding("X", '<urn:example:b>'), binding("Y", '<urn:example:c>')]),
        uses([
          proof(
            goal(edge('<urn:example:b>', '<urn:example:c>')),
            by(fact("language.pl", clause(3)))
          )
        ])
      )
    ])
  )
).

path('<urn:example:a>', '<urn:example:d>').
why(
  path('<urn:example:a>', '<urn:example:d>'),
  proof(
    goal(path('<urn:example:a>', '<urn:example:d>')),
    by(rule("language.pl", clause(6))),
    bindings([binding("X", '<urn:example:a>'), binding("Z", '<urn:example:d>'), binding("Y", '<urn:example:b>')]),
    uses([
      proof(
        goal(edge('<urn:example:a>', '<urn:example:b>')),
        by(fact("language.pl", clause(2)))
      ),
      proof(
        goal(path('<urn:example:b>', '<urn:example:d>')),
        by(rule("language.pl", clause(6))),
        bindings([binding("X", '<urn:example:b>'), binding("Z", '<urn:example:d>'), binding("Y", '<urn:example:c>')]),
        uses([
          proof(
            goal(edge('<urn:example:b>', '<urn:example:c>')),
            by(fact("language.pl", clause(3)))
          ),
          proof(
            goal(path('<urn:example:c>', '<urn:example:d>')),
            by(rule("language.pl", clause(5))),
            bindings([binding("X", '<urn:example:c>'), binding("Y", '<urn:example:d>')]),
            uses([
              proof(
                goal(edge('<urn:example:c>', '<urn:example:d>')),
                by(fact("language.pl", clause(4)))
              )
            ])
          )
        ])
      )
    ])
  )
).

path('<urn:example:b>', '<urn:example:d>').
why(
  path('<urn:example:b>', '<urn:example:d>'),
  proof(
    goal(path('<urn:example:b>', '<urn:example:d>')),
    by(rule("language.pl", clause(6))),
    bindings([binding("X", '<urn:example:b>'), binding("Z", '<urn:example:d>'), binding("Y", '<urn:example:c>')]),
    uses([
      proof(
        goal(edge('<urn:example:b>', '<urn:example:c>')),
        by(fact("language.pl", clause(3)))
      ),
      proof(
        goal(path('<urn:example:c>', '<urn:example:d>')),
        by(rule("language.pl", clause(5))),
        bindings([binding("X", '<urn:example:c>'), binding("Y", '<urn:example:d>')]),
        uses([
          proof(
            goal(edge('<urn:example:c>', '<urn:example:d>')),
            by(fact("language.pl", clause(4)))
          )
        ])
      )
    ])
  )
).

