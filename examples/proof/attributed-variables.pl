accepts_required_value(ok).
why(
  accepts_required_value(ok),
  step(
    accepts_required_value(ok),
    rule("attributed-variables.pl", clause(4)),
    ['X' = 7],
    [
      step(
        attach_required(Variable, 7),
        rule("attributed-variables.pl", clause(1)),
        ['Value' = 7],
        [
          step(put_atts(Variable, required(7)), builtin(put_atts, 2), [], [])
        ]
      ),
      step(=(7, 7), builtin(=, 2), [], [])
    ]
  )
).

alias_preserves_attribute(ok).
why(
  alias_preserves_attribute(ok),
  step(
    alias_preserves_attribute(ok),
    rule("attributed-variables.pl", clause(5)),
    ['X' = ready, 'Y' = ready],
    [
      step(
        attach_required(Variable, ready),
        rule("attributed-variables.pl", clause(1)),
        ['Value' = ready],
        [
          step(put_atts(Variable, required(ready)), builtin(put_atts, 2), [], [])
        ]
      ),
      step(=(Y, Y), builtin(=, 2), [], []),
      step(get_atts(Y, required(ready)), builtin(get_atts, 2), [], []),
      step(=(ready, ready), builtin(=, 2), [], [])
    ]
  )
).

