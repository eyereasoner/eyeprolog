name(a, "Alice").
why(
  name(a, "Alice"),
  step(
    name(a, "Alice"),
    rule("annotation.pl", clause(5)),
    ['S' = a, 'O' = "Alice", '_t' = t, 'Context' = (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07"))],
    [
      step(annotation(t, (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07"))), fact("annotation.pl", clause(1)), [], []),
      step(
        context_member((name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")), name(a, "Alice")),
        rule("annotation.pl", clause(2)),
        ['Left' = name(a, "Alice"), '_right' = (statedBy(t, bob), recorded(t, "2021-07-07")), 'Member' = name(a, "Alice")],
        [
          step(
            context_member(name(a, "Alice"), name(a, "Alice")),
            rule("annotation.pl", clause(4)),
            ['Member' = name(a, "Alice")],
            [
              step(\=(name(a, "Alice"), (_left, _right)), builtin(\=, 2), [], [])
            ]
          )
        ]
      )
    ]
  )
).

log_nameOf(t, name(a, "Alice")).
why(
  log_nameOf(t, name(a, "Alice")),
  step(
    log_nameOf(t, name(a, "Alice")),
    rule("annotation.pl", clause(6)),
    ['T' = t, 'S' = a, 'O' = "Alice", 'Context' = (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07"))],
    [
      step(annotation(t, (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07"))), fact("annotation.pl", clause(1)), [], []),
      step(
        context_member((name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")), name(a, "Alice")),
        rule("annotation.pl", clause(2)),
        ['Left' = name(a, "Alice"), '_right' = (statedBy(t, bob), recorded(t, "2021-07-07")), 'Member' = name(a, "Alice")],
        [
          step(
            context_member(name(a, "Alice"), name(a, "Alice")),
            rule("annotation.pl", clause(4)),
            ['Member' = name(a, "Alice")],
            [
              step(\=(name(a, "Alice"), (_left, _right)), builtin(\=, 2), [], [])
            ]
          )
        ]
      )
    ]
  )
).

statedBy(t, bob).
why(
  statedBy(t, bob),
  step(
    statedBy(t, bob),
    rule("annotation.pl", clause(7)),
    ['S' = t, 'O' = bob, '_t' = t, 'Context' = (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07"))],
    [
      step(annotation(t, (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07"))), fact("annotation.pl", clause(1)), [], []),
      step(
        context_member((name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")), statedBy(t, bob)),
        rule("annotation.pl", clause(3)),
        ['_left' = name(a, "Alice"), 'Right' = (statedBy(t, bob), recorded(t, "2021-07-07")), 'Member' = statedBy(t, bob)],
        [
          step(
            context_member((statedBy(t, bob), recorded(t, "2021-07-07")), statedBy(t, bob)),
            rule("annotation.pl", clause(2)),
            ['Left' = statedBy(t, bob), '_right' = recorded(t, "2021-07-07"), 'Member' = statedBy(t, bob)],
            [
              step(
                context_member(statedBy(t, bob), statedBy(t, bob)),
                rule("annotation.pl", clause(4)),
                ['Member' = statedBy(t, bob)],
                [
                  step(\=(statedBy(t, bob), (_left, _right)), builtin(\=, 2), [], [])
                ]
              )
            ]
          )
        ]
      )
    ]
  )
).

recorded(t, "2021-07-07").
why(
  recorded(t, "2021-07-07"),
  step(
    recorded(t, "2021-07-07"),
    rule("annotation.pl", clause(8)),
    ['S' = t, 'O' = "2021-07-07", '_t' = t, 'Context' = (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07"))],
    [
      step(annotation(t, (name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07"))), fact("annotation.pl", clause(1)), [], []),
      step(
        context_member((name(a, "Alice"), statedBy(t, bob), recorded(t, "2021-07-07")), recorded(t, "2021-07-07")),
        rule("annotation.pl", clause(3)),
        ['_left' = name(a, "Alice"), 'Right' = (statedBy(t, bob), recorded(t, "2021-07-07")), 'Member' = recorded(t, "2021-07-07")],
        [
          step(
            context_member((statedBy(t, bob), recorded(t, "2021-07-07")), recorded(t, "2021-07-07")),
            rule("annotation.pl", clause(3)),
            ['_left' = statedBy(t, bob), 'Right' = recorded(t, "2021-07-07"), 'Member' = recorded(t, "2021-07-07")],
            [
              step(
                context_member(recorded(t, "2021-07-07"), recorded(t, "2021-07-07")),
                rule("annotation.pl", clause(4)),
                ['Member' = recorded(t, "2021-07-07")],
                [
                  step(\=(recorded(t, "2021-07-07"), (_left, _right)), builtin(\=, 2), [], [])
                ]
              )
            ]
          )
        ]
      )
    ]
  )
).

