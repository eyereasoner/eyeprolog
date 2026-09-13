answer([[] - "abc", "a" - "bc", "ab" - "c", "abc" - []], 4, true).
why(
  answer(['-'([], "abc"), '-'("a", "bc"), '-'("ab", "c"), '-'("abc", [])], 4, true),
  proof(
    goal(answer(['-'([], "abc"), '-'("a", "bc"), '-'("ab", "c"), '-'("abc", [])], 4, true)),
    by(rule("universal-vs-existential-termination.pl", clause(1))),
    bindings([binding("AllSplitsOfBoundList", ['-'([], "abc"), '-'("a", "bc"), '-'("ab", "c"), '-'("abc", [])]), binding("SplitCount", 4), binding("FoundFirstSplitOfUnboundList", true), binding("X2", [])]),
    uses([
      proof(
        goal(findall('-'(X, Y), append(X, Y, "abc"), ['-'([], "abc"), '-'("a", "bc"), '-'("ab", "c"), '-'("abc", [])])),
        by(builtin(findall, 3))
      ),
      proof(
        goal(length(['-'([], "abc"), '-'("a", "bc"), '-'("ab", "c"), '-'("abc", [])], 4)),
        by(library(length, 2))
      ),
      proof(
        goal(once((append([], Ys, Ys), ==([], [])))),
        by(builtin(once, 1)),
        uses([
          proof(
            goal((append([], Ys, Ys), ==([], []))),
            by(conjunction),
            uses([
              proof(
                goal(append([], Ys, Ys)),
                by(library(append, 3))
              ),
              proof(
                goal(==([], [])),
                by(builtin(==, 2))
              )
            ])
          )
        ])
      ),
      proof(
        goal(=(true, true)),
        by(builtin(=, 2))
      )
    ])
  )
).

