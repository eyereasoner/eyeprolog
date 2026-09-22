holds_result(socrates, human_witness(socrates)).
why(
  holds_result(socrates, human_witness(socrates)),
  step(
    holds_result(socrates, human_witness(socrates)),
    rule("existential-rule.pl", clause(3)),
    ['Person' = socrates],
    [
      step(type(socrates, human), fact("existential-rule.pl", clause(1)), [], [])
    ]
  )
).

holds_result(plato, human_witness(plato)).
why(
  holds_result(plato, human_witness(plato)),
  step(
    holds_result(plato, human_witness(plato)),
    rule("existential-rule.pl", clause(3)),
    ['Person' = plato],
    [
      step(type(plato, human), fact("existential-rule.pl", clause(2)), [], [])
    ]
  )
).

