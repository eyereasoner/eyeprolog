ageAbove(patH, 'P80Y').
why(
  ageAbove(patH, 'P80Y'),
  step(
    ageAbove(patH, 'P80Y'),
    rule("age.pl", clause(4)),
    ['S' = patH, 'A' = 'P80Y', 'B' = '1944-08-21', 'D' = '2026-05-30', 'F' = 'P81Y9M9D'],
    [
      step(birthDay(patH, '1944-08-21'), fact("age.pl", clause(1)), [], []),
      step(duration(check, 'P80Y'), fact("age.pl", clause(2)), [], []),
      step(local_time('2026-05-30'), fact("age.pl", clause(3)), [], []),
      step(difference('2026-05-30', '1944-08-21', 'P81Y9M9D'), library(difference, 3), [], []),
      step(@>('P81Y9M9D', 'P80Y'), builtin(@>, 2), [], [])
    ]
  )
).

holds_result(test, true).
why(
  holds_result(test, true),
  step(
    holds_result(test, true),
    rule("age.pl", clause(5)),
    ['__anon0' = patH],
    [
      step(
        ageAbove(patH, 'P80Y'),
        rule("age.pl", clause(4)),
        ['S' = patH, 'A' = 'P80Y', 'B' = '1944-08-21', 'D' = '2026-05-30', 'F' = 'P81Y9M9D'],
        [
          step(birthDay(patH, '1944-08-21'), fact("age.pl", clause(1)), [], []),
          step(duration(check, 'P80Y'), fact("age.pl", clause(2)), [], []),
          step(local_time('2026-05-30'), fact("age.pl", clause(3)), [], []),
          step(difference('2026-05-30', '1944-08-21', 'P81Y9M9D'), library(difference, 3), [], []),
          step(@>('P81Y9M9D', 'P80Y'), builtin(@>, 2), [], [])
        ]
      )
    ]
  )
).

