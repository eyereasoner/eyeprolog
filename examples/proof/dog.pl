mustHave(alice, dogLicense).
why(
  mustHave(alice, dogLicense),
  step(
    mustHave(alice, dogLicense),
    rule("dog.pl", clause(9)),
    ['Subject' = alice, 'Count' = 5],
    [
      step(
        dogCount(alice, 5),
        rule("dog.pl", clause(8)),
        ['Subject' = alice, 'Count' = 5, '_any' = dog1],
        [
          step(hasDog(alice, dog1), fact("dog.pl", clause(1)), [], []),
          step(countall(hasDog(alice, _dog), 5), library(countall, 2), [], [])
        ]
      ),
      step(>(5, 4), builtin(>, 2), [], [])
    ]
  )
).

