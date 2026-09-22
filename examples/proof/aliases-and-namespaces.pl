value(nativeMath, 1.0).
why(
  value(nativeMath, 1.0),
  step(
    value(nativeMath, 1.0),
    rule("aliases-and-namespaces.pl", clause(1)),
    ['X' = 1.0],
    [
      step(is(1.0, '+'(0.125, 0.875)), builtin(is, 2), [], [])
    ]
  )
).

ok(nativeCompare, true).
why(
  ok(nativeCompare, true),
  step(
    ok(nativeCompare, true),
    rule("aliases-and-namespaces.pl", clause(2)),
    [],
    [
      step(<(2, 3), builtin(<, 2), [], [])
    ]
  )
).

ok(nativeString, true).
why(
  ok(nativeString, true),
  step(
    ok(nativeString, true),
    rule("aliases-and-namespaces.pl", clause(3)),
    [],
    [
      step(matches('scoped retail insight', 'retail|medical'), library(matches, 2), [], [])
    ]
  )
).

tail(nativeList, "bc").
why(
  tail(nativeList, "bc"),
  step(
    tail(nativeList, "bc"),
    rule("aliases-and-namespaces.pl", clause(4)),
    ['Tail' = "bc", '_head' = a],
    [
      step(=("abc", "abc"), builtin(=, 2), [], [])
    ]
  )
).

label(vocabularyExample, "vocabulary names are ordinary predicate names").
why(
  label(vocabularyExample, "vocabulary names are ordinary predicate names"),
  step(
    label(vocabularyExample, "vocabulary names are ordinary predicate names"),
    rule("aliases-and-namespaces.pl", clause(6)),
    ['Text' = "vocabulary names are ordinary predicate names"],
    [
      step(example_label(vocabularyExample, "vocabulary names are ordinary predicate names"), fact("aliases-and-namespaces.pl", clause(5)), [], [])
    ]
  )
).

