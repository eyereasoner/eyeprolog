answer(aggregate_min, 1, a).
why(
  answer(aggregate_min, 1, a),
  step(
    answer(aggregate_min, 1, a),
    rule("<stdin>", clause(3)),
    ['Key' = 1, 'Value' = a],
    [
      step(aggregate_min(Key, Value, score(Key, Value), 1, a), library(aggregate_min, 5), [], [])
    ]
  )
).

