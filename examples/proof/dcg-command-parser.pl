dcg_example(parsed, set(light(kitchen), on)).
why(
  dcg_example(parsed, set(light(kitchen), on)),
  step(
    dcg_example(parsed, set(light(kitchen), on)),
    rule("dcg-command-parser.pl", clause(6)),
    ['Command' = set(light(kitchen), on)],
    [
      step(phrase(command(set(light(kitchen), on)), [set, kitchen, light, to, on]), builtin(phrase, 2), [], [])
    ]
  )
).

dcg_example(generated, [set, hall, light, to, off]).
why(
  dcg_example(generated, [set, hall, light, to, off]),
  step(
    dcg_example(generated, [set, hall, light, to, off]),
    rule("dcg-command-parser.pl", clause(7)),
    ['Tokens' = [set, hall, light, to, off]],
    [
      step(phrase(command(set(light(hall), off)), [set, hall, light, to, off]), builtin(phrase, 2), [], [])
    ]
  )
).

dcg_example(remainder, [then, wait]).
why(
  dcg_example(remainder, [then, wait]),
  step(
    dcg_example(remainder, [then, wait]),
    rule("dcg-command-parser.pl", clause(8)),
    ['Rest' = [then, wait]],
    [
      step(phrase(command(set(light(kitchen), on)), [set, kitchen, light, to, on, then, wait], [then, wait]), builtin(phrase, 3), [], [])
    ]
  )
).

dcg_example(rejected, invalid_command).
why(
  dcg_example(rejected, invalid_command),
  step(
    dcg_example(rejected, invalid_command),
    rule("dcg-command-parser.pl", clause(9)),
    [],
    [
      step('\\+'(phrase(command(__anon0), [set, garage, light, to, blinking])), builtin('\\+', 1), [], [])
    ]
  )
).

