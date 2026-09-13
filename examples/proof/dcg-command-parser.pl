dcg_example(parsed, set(light(kitchen), on)).
why(
  dcg_example(parsed, set(light(kitchen), on)),
  proof(
    goal(dcg_example(parsed, set(light(kitchen), on))),
    by(rule("dcg-command-parser.pl", clause(6))),
    bindings([binding("Command", set(light(kitchen), on))]),
    uses([
      proof(
        goal(phrase(command(set(light(kitchen), on)), [set, kitchen, light, to, on])),
        by(builtin(phrase, 2))
      )
    ])
  )
).

dcg_example(generated, [set, hall, light, to, off]).
why(
  dcg_example(generated, [set, hall, light, to, off]),
  proof(
    goal(dcg_example(generated, [set, hall, light, to, off])),
    by(rule("dcg-command-parser.pl", clause(7))),
    bindings([binding("Tokens", [set, hall, light, to, off])]),
    uses([
      proof(
        goal(phrase(command(set(light(hall), off)), [set, hall, light, to, off])),
        by(builtin(phrase, 2))
      )
    ])
  )
).

dcg_example(remainder, [then, wait]).
why(
  dcg_example(remainder, [then, wait]),
  proof(
    goal(dcg_example(remainder, [then, wait])),
    by(rule("dcg-command-parser.pl", clause(8))),
    bindings([binding("Rest", [then, wait])]),
    uses([
      proof(
        goal(phrase(command(set(light(kitchen), on)), [set, kitchen, light, to, on, then, wait], [then, wait])),
        by(builtin(phrase, 3))
      )
    ])
  )
).

dcg_example(rejected, invalid_command).
why(
  dcg_example(rejected, invalid_command),
  proof(
    goal(dcg_example(rejected, invalid_command)),
    by(rule("dcg-command-parser.pl", clause(9))),
    uses([
      proof(
        goal('\\+'(phrase(command(__anon0), [set, garage, light, to, blinking]))),
        by(builtin('\\+', 1))
      )
    ])
  )
).

