answer([[] - "abc", "a" - "bc", "ab" - "c", "abc" - []], 4, true).
why(
  answer(['-'([], "abc"), '-'("a", "bc"), '-'("ab", "c"), '-'("abc", [])], 4, true),
  step(
    answer(['-'([], "abc"), '-'("a", "bc"), '-'("ab", "c"), '-'("abc", [])], 4, true),
    rule("universal-vs-existential-termination.pl", clause(1)),
    ['AllSplitsOfBoundList' = ['-'([], "abc"), '-'("a", "bc"), '-'("ab", "c"), '-'("abc", [])], 'SplitCount' = 4, 'FoundFirstSplitOfUnboundList' = true, 'X2' = []],
    [
      step(findall('-'(X, Y), append(X, Y, "abc"), ['-'([], "abc"), '-'("a", "bc"), '-'("ab", "c"), '-'("abc", [])]), builtin(findall, 3), [], []),
      step(length(['-'([], "abc"), '-'("a", "bc"), '-'("ab", "c"), '-'("abc", [])], 4), library(length, 2), [], []),
      step(
        once((append([], Ys, Ys), ==([], []))),
        builtin(once, 1),
        [],
        [
          step(
            (append([], Ys, Ys), ==([], [])),
            conjunction,
            [],
            [
              step(append([], Ys, Ys), library(append, 3), [], []),
              step(==([], []), builtin(==, 2), [], [])
            ]
          )
        ]
      ),
      step(=(true, true), builtin(=, 2), [], [])
    ]
  )
).

