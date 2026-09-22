uuid_example(true).
why(
  uuid_example(true),
  step(
    uuid_example(true),
    rule("uuid.pl", clause(1)),
    ['UUID' = '08b72882-8bb9-484f-addc-f8c1a3867f4d', '__anon0' = 1745479741, 'Variant' = a],
    [
      step(uuid(20260807, '08b72882-8bb9-484f-addc-f8c1a3867f4d', 1745479741), library(uuid, 3), [], []),
      step(atom('08b72882-8bb9-484f-addc-f8c1a3867f4d'), builtin(atom, 1), [], []),
      step(atom_length('08b72882-8bb9-484f-addc-f8c1a3867f4d', 36), builtin(atom_length, 2), [], []),
      step(sub_atom('08b72882-8bb9-484f-addc-f8c1a3867f4d', 8, 1, 27, '-'), builtin(sub_atom, 5), [], []),
      step(sub_atom('08b72882-8bb9-484f-addc-f8c1a3867f4d', 13, 1, 22, '-'), builtin(sub_atom, 5), [], []),
      step(sub_atom('08b72882-8bb9-484f-addc-f8c1a3867f4d', 14, 1, 21, '4'), builtin(sub_atom, 5), [], []),
      step(sub_atom('08b72882-8bb9-484f-addc-f8c1a3867f4d', 18, 1, 17, '-'), builtin(sub_atom, 5), [], []),
      step(sub_atom('08b72882-8bb9-484f-addc-f8c1a3867f4d', 19, 1, 16, a), builtin(sub_atom, 5), [], []),
      step(member(a, "89ab"), library(member, 2), [], []),
      step(sub_atom('08b72882-8bb9-484f-addc-f8c1a3867f4d', 23, 1, 12, '-'), builtin(sub_atom, 5), [], [])
    ]
  )
).

