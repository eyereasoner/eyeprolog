uuid_example(true).
why(
  uuid_example(true),
  proof(
    goal(uuid_example(true)),
    by(rule("uuid.pl", clause(1))),
    bindings([binding("UUID", '08b72882-8bb9-484f-addc-f8c1a3867f4d'), binding("__anon0", 1745479741), binding("Variant", a)]),
    uses([
      proof(
        goal(uuid(20260807, '08b72882-8bb9-484f-addc-f8c1a3867f4d', 1745479741)),
        by(library(uuid, 3))
      ),
      proof(
        goal(atom('08b72882-8bb9-484f-addc-f8c1a3867f4d')),
        by(builtin(atom, 1))
      ),
      proof(
        goal(atom_length('08b72882-8bb9-484f-addc-f8c1a3867f4d', 36)),
        by(builtin(atom_length, 2))
      ),
      proof(
        goal(sub_atom('08b72882-8bb9-484f-addc-f8c1a3867f4d', 8, 1, 27, '-')),
        by(builtin(sub_atom, 5))
      ),
      proof(
        goal(sub_atom('08b72882-8bb9-484f-addc-f8c1a3867f4d', 13, 1, 22, '-')),
        by(builtin(sub_atom, 5))
      ),
      proof(
        goal(sub_atom('08b72882-8bb9-484f-addc-f8c1a3867f4d', 14, 1, 21, '4')),
        by(builtin(sub_atom, 5))
      ),
      proof(
        goal(sub_atom('08b72882-8bb9-484f-addc-f8c1a3867f4d', 18, 1, 17, '-')),
        by(builtin(sub_atom, 5))
      ),
      proof(
        goal(sub_atom('08b72882-8bb9-484f-addc-f8c1a3867f4d', 19, 1, 16, a)),
        by(builtin(sub_atom, 5))
      ),
      proof(
        goal(member(a, "89ab")),
        by(library(member, 2))
      ),
      proof(
        goal(sub_atom('08b72882-8bb9-484f-addc-f8c1a3867f4d', 23, 1, 12, '-')),
        by(builtin(sub_atom, 5))
      )
    ])
  )
).

