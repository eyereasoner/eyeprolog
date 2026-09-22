log_impliedBy(childOf(var(x), var(y)), parentOf(var(y), var(x))).
why(
  log_impliedBy(childOf(var(x), var(y)), parentOf(var(y), var(x))),
  step(
    log_impliedBy(childOf(var(x), var(y)), parentOf(var(y), var(x))),
    rule("derived-backward-rule.pl", clause(3)),
    [],
    [
      step(invOf(parentOf, childOf), fact("derived-backward-rule.pl", clause(1)), [], [])
    ]
  )
).

childOf(bob, alice).
why(
  childOf(bob, alice),
  step(
    childOf(bob, alice),
    rule("derived-backward-rule.pl", clause(4)),
    ['X' = bob, 'Y' = alice],
    [
      step(
        log_impliedBy(childOf(var(x), var(y)), parentOf(var(y), var(x))),
        rule("derived-backward-rule.pl", clause(3)),
        [],
        [
          step(invOf(parentOf, childOf), fact("derived-backward-rule.pl", clause(1)), [], [])
        ]
      ),
      step(parentOf(alice, bob), fact("derived-backward-rule.pl", clause(2)), [], [])
    ]
  )
).

hasParent(bob, alice).
why(
  hasParent(bob, alice),
  step(
    hasParent(bob, alice),
    rule("derived-backward-rule.pl", clause(5)),
    ['X' = bob, 'Y' = alice],
    [
      step(
        childOf(bob, alice),
        rule("derived-backward-rule.pl", clause(4)),
        ['X' = bob, 'Y' = alice],
        [
          step(
            log_impliedBy(childOf(var(x), var(y)), parentOf(var(y), var(x))),
            rule("derived-backward-rule.pl", clause(3)),
            [],
            [
              step(invOf(parentOf, childOf), fact("derived-backward-rule.pl", clause(1)), [], [])
            ]
          ),
          step(parentOf(alice, bob), fact("derived-backward-rule.pl", clause(2)), [], [])
        ]
      )
    ]
  )
).

