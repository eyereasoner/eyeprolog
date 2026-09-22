% Prolog result format 4
query(1, uuid_example(_0), ['Result' = _0]).
result(1, complete, 1).
answer(1, ['Result' = true]).
why(1, ['Result' = true], [uuid_example(true)]).

clause(1,
       uuid_example(true),
       (uuid(20260807, var('UUID'), anonymous(1)),
        atom(var('UUID')),
        atom_length(var('UUID'), 36),
        sub_atom(var('UUID'), 8, 1, 27, -),
        sub_atom(var('UUID'), 13, 1, 22, -),
        sub_atom(var('UUID'), 14, 1, 21, '4'),
        sub_atom(var('UUID'), 18, 1, 17, -),
        sub_atom(var('UUID'), 19, 1, 16, var('Variant')),
        member(var('Variant'), "89ab"),
        sub_atom(var('UUID'), 23, 1, 12, -))).

step(uuid_example(true),
     rule(1),
     ['UUID' = '08b72882-8bb9-484f-addc-f8c1a3867f4d', 'Variant' = a],
     [uuid(20260807, '08b72882-8bb9-484f-addc-f8c1a3867f4d', 1745479741),
      atom('08b72882-8bb9-484f-addc-f8c1a3867f4d'),
      atom_length('08b72882-8bb9-484f-addc-f8c1a3867f4d', 36),
      sub_atom('08b72882-8bb9-484f-addc-f8c1a3867f4d', 8, 1, 27, -),
      sub_atom('08b72882-8bb9-484f-addc-f8c1a3867f4d', 13, 1, 22, -),
      sub_atom('08b72882-8bb9-484f-addc-f8c1a3867f4d', 14, 1, 21, '4'),
      sub_atom('08b72882-8bb9-484f-addc-f8c1a3867f4d', 18, 1, 17, -),
      sub_atom('08b72882-8bb9-484f-addc-f8c1a3867f4d', 19, 1, 16, a),
      member(a, "89ab"),
      sub_atom('08b72882-8bb9-484f-addc-f8c1a3867f4d', 23, 1, 12, -)]).
step(uuid(20260807, '08b72882-8bb9-484f-addc-f8c1a3867f4d', 1745479741), builtin, [], []).
step(atom('08b72882-8bb9-484f-addc-f8c1a3867f4d'), builtin, [], []).
step(atom_length('08b72882-8bb9-484f-addc-f8c1a3867f4d', 36), builtin, [], []).
step(sub_atom('08b72882-8bb9-484f-addc-f8c1a3867f4d', 8, 1, 27, -), builtin, [], []).
step(sub_atom('08b72882-8bb9-484f-addc-f8c1a3867f4d', 13, 1, 22, -), builtin, [], []).
step(sub_atom('08b72882-8bb9-484f-addc-f8c1a3867f4d', 14, 1, 21, '4'), builtin, [], []).
step(sub_atom('08b72882-8bb9-484f-addc-f8c1a3867f4d', 18, 1, 17, -), builtin, [], []).
step(sub_atom('08b72882-8bb9-484f-addc-f8c1a3867f4d', 19, 1, 16, a), builtin, [], []).
step(member(a, "89ab"), builtin, [], []).
step(sub_atom('08b72882-8bb9-484f-addc-f8c1a3867f4d', 23, 1, 12, -), builtin, [], []).
