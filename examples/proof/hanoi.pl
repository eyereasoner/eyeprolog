answer(3, [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]]).
why(
  answer(3, [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]]),
  step(
    answer(3, [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]]),
    rule("hanoi.pl", clause(3)),
    ['Moves' = [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]]],
    [
      step(
        hanoi(3, left, right, center, [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]]),
        rule("hanoi.pl", clause(2)),
        ['N' = 3, 'From' = left, 'To' = right, 'Via' = center, 'Moves' = [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]], 'N1' = 2, 'Before' = [[left, right], [left, center], [right, center]], 'After' = [[center, left], [center, right], [left, right]]],
        [
          step(>(3, 0), builtin(>, 2), [], []),
          step(is(2, '-'(3, 1)), builtin(is, 2), [], []),
          step(
            hanoi(2, left, center, right, [[left, right], [left, center], [right, center]]),
            rule("hanoi.pl", clause(2)),
            ['N' = 2, 'From' = left, 'To' = center, 'Via' = right, 'Moves' = [[left, right], [left, center], [right, center]], 'N1' = 1, 'Before' = [[left, right]], 'After' = [[right, center]]],
            [
              step(>(2, 0), builtin(>, 2), [], []),
              step(is(1, '-'(2, 1)), builtin(is, 2), [], []),
              step(
                hanoi(1, left, right, center, [[left, right]]),
                rule("hanoi.pl", clause(2)),
                ['N' = 1, 'From' = left, 'To' = right, 'Via' = center, 'Moves' = [[left, right]], 'N1' = 0, 'Before' = [], 'After' = []],
                [
                  step(>(1, 0), builtin(>, 2), [], []),
                  step(is(0, '-'(1, 1)), builtin(is, 2), [], []),
                  step(hanoi(0, left, center, right, []), fact("hanoi.pl", clause(1)), ['_from' = left, '_to' = center, '_via' = right], []),
                  step(hanoi(0, center, right, left, []), fact("hanoi.pl", clause(1)), ['_from' = center, '_to' = right, '_via' = left], []),
                  step(append([], [[left, right]], [[left, right]]), library(append, 3), [], [])
                ]
              ),
              step(
                hanoi(1, right, center, left, [[right, center]]),
                rule("hanoi.pl", clause(2)),
                ['N' = 1, 'From' = right, 'To' = center, 'Via' = left, 'Moves' = [[right, center]], 'N1' = 0, 'Before' = [], 'After' = []],
                [
                  step(>(1, 0), builtin(>, 2), [], []),
                  step(is(0, '-'(1, 1)), builtin(is, 2), [], []),
                  step(hanoi(0, right, left, center, []), fact("hanoi.pl", clause(1)), ['_from' = right, '_to' = left, '_via' = center], []),
                  step(hanoi(0, left, center, right, []), fact("hanoi.pl", clause(1)), ['_from' = left, '_to' = center, '_via' = right], []),
                  step(append([], [[right, center]], [[right, center]]), library(append, 3), [], [])
                ]
              ),
              step(append([[left, right]], [[left, center], [right, center]], [[left, right], [left, center], [right, center]]), library(append, 3), [], [])
            ]
          ),
          step(
            hanoi(2, center, right, left, [[center, left], [center, right], [left, right]]),
            rule("hanoi.pl", clause(2)),
            ['N' = 2, 'From' = center, 'To' = right, 'Via' = left, 'Moves' = [[center, left], [center, right], [left, right]], 'N1' = 1, 'Before' = [[center, left]], 'After' = [[left, right]]],
            [
              step(>(2, 0), builtin(>, 2), [], []),
              step(is(1, '-'(2, 1)), builtin(is, 2), [], []),
              step(
                hanoi(1, center, left, right, [[center, left]]),
                rule("hanoi.pl", clause(2)),
                ['N' = 1, 'From' = center, 'To' = left, 'Via' = right, 'Moves' = [[center, left]], 'N1' = 0, 'Before' = [], 'After' = []],
                [
                  step(>(1, 0), builtin(>, 2), [], []),
                  step(is(0, '-'(1, 1)), builtin(is, 2), [], []),
                  step(hanoi(0, center, right, left, []), fact("hanoi.pl", clause(1)), ['_from' = center, '_to' = right, '_via' = left], []),
                  step(hanoi(0, right, left, center, []), fact("hanoi.pl", clause(1)), ['_from' = right, '_to' = left, '_via' = center], []),
                  step(append([], [[center, left]], [[center, left]]), library(append, 3), [], [])
                ]
              ),
              step(
                hanoi(1, left, right, center, [[left, right]]),
                rule("hanoi.pl", clause(2)),
                ['N' = 1, 'From' = left, 'To' = right, 'Via' = center, 'Moves' = [[left, right]], 'N1' = 0, 'Before' = [], 'After' = []],
                [
                  step(>(1, 0), builtin(>, 2), [], []),
                  step(is(0, '-'(1, 1)), builtin(is, 2), [], []),
                  step(hanoi(0, left, center, right, []), fact("hanoi.pl", clause(1)), ['_from' = left, '_to' = center, '_via' = right], []),
                  step(hanoi(0, center, right, left, []), fact("hanoi.pl", clause(1)), ['_from' = center, '_to' = right, '_via' = left], []),
                  step(append([], [[left, right]], [[left, right]]), library(append, 3), [], [])
                ]
              ),
              step(append([[center, left]], [[center, right], [left, right]], [[center, left], [center, right], [left, right]]), library(append, 3), [], [])
            ]
          ),
          step(append([[left, right], [left, center], [right, center]], [[left, right], [center, left], [center, right], [left, right]], [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]]), library(append, 3), [], [])
        ]
      )
    ]
  )
).

