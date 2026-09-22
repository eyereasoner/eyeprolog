type(sk_0, cat).
why(
  type(sk_0, cat),
  step(
    type(sk_0, cat),
    rule("cat-koko.pl", clause(4)),
    ['X' = sk_0],
    [
      step(animal(koko), fact("cat-koko.pl", clause(1)), [], []),
      step(witness(cat, sk_0), fact("cat-koko.pl", clause(2)), [], [])
    ]
  )
).

type(sk_1, british_short_hair).
why(
  type(sk_1, british_short_hair),
  step(
    type(sk_1, british_short_hair),
    rule("cat-koko.pl", clause(5)),
    ['X' = sk_1],
    [
      step(animal(koko), fact("cat-koko.pl", clause(1)), [], []),
      step(witness(british_short_hair, sk_1), fact("cat-koko.pl", clause(3)), [], [])
    ]
  )
).

holds_result(test, true).
why(
  holds_result(test, true),
  step(
    holds_result(test, true),
    rule("cat-koko.pl", clause(6)),
    ['X' = sk_0, 'Y' = sk_1],
    [
      step(
        type(sk_0, cat),
        rule("cat-koko.pl", clause(4)),
        ['X' = sk_0],
        [
          step(animal(koko), fact("cat-koko.pl", clause(1)), [], []),
          step(witness(cat, sk_0), fact("cat-koko.pl", clause(2)), [], [])
        ]
      ),
      step(
        type(sk_1, british_short_hair),
        rule("cat-koko.pl", clause(5)),
        ['X' = sk_1],
        [
          step(animal(koko), fact("cat-koko.pl", clause(1)), [], []),
          step(witness(british_short_hair, sk_1), fact("cat-koko.pl", clause(3)), [], [])
        ]
      ),
      step(\=(sk_0, sk_1), builtin(\=, 2), [], [])
    ]
  )
).

