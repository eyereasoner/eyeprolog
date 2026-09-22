type(joe, human).
why(
  type(joe, human),
  step(
    type(joe, human),
    rule("animal.pl", clause(4)),
    [],
    [
      step(human(joe), fact("animal.pl", clause(1)), [], [])
    ]
  )
).

type(joe, animal).
why(
  type(joe, animal),
  step(
    type(joe, animal),
    rule("animal.pl", clause(5)),
    [],
    [
      step(
        animal(joe),
        rule("animal.pl", clause(3)),
        ['X' = joe],
        [
          step(human(joe), fact("animal.pl", clause(1)), [], [])
        ]
      )
    ]
  )
).

subclassOf(human, animal).
why(
  subclassOf(human, animal),
  step(
    subclassOf(human, animal),
    rule("animal.pl", clause(6)),
    [],
    [
      step(animal(human), fact("animal.pl", clause(2)), [], [])
    ]
  )
).

succeeds(animalExample, true).
why(
  succeeds(animalExample, true),
  step(
    succeeds(animalExample, true),
    rule("animal.pl", clause(7)),
    ['__anon0' = human],
    [
      step(animal(human), fact("animal.pl", clause(2)), [], [])
    ]
  )
).

