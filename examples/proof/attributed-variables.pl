accepts_required_value(ok).
why(
  accepts_required_value(ok),
  proof(
    goal(accepts_required_value(ok)),
    by(rule("attributed-variables.pl", clause(4))),
    bindings([binding("X", 7)]),
    uses([
      proof(
        goal(attach_required(Variable, 7)),
        by(rule("attributed-variables.pl", clause(1))),
        bindings([binding("Value", 7)]),
        uses([
          proof(
            goal(put_atts(Variable, required(7))),
            by(builtin(put_atts, 2))
          )
        ])
      ),
      proof(
        goal(=(7, 7)),
        by(builtin(=, 2))
      )
    ])
  )
).

alias_preserves_attribute(ok).
why(
  alias_preserves_attribute(ok),
  proof(
    goal(alias_preserves_attribute(ok)),
    by(rule("attributed-variables.pl", clause(5))),
    bindings([binding("X", ready), binding("Y", ready)]),
    uses([
      proof(
        goal(attach_required(Variable, ready)),
        by(rule("attributed-variables.pl", clause(1))),
        bindings([binding("Value", ready)]),
        uses([
          proof(
            goal(put_atts(Variable, required(ready))),
            by(builtin(put_atts, 2))
          )
        ])
      ),
      proof(
        goal(=(Y, Y)),
        by(builtin(=, 2))
      ),
      proof(
        goal(get_atts(Y, required(ready))),
        by(builtin(get_atts, 2))
      ),
      proof(
        goal(=(ready, ready)),
        by(builtin(=, 2))
      )
    ])
  )
).

