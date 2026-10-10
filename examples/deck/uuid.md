# Reproducible UUIDs

## Can a random identifier be reproducible?

A version 4 UUID is a 128-bit identifier made mostly of random bits. This
example generates one from an explicit random seed, so the same seed always
gives the same UUID, and then checks that the result has the shape the UUID
standard requires.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=uuid) ·
[Source](../uuid.pl)

---

# The question

Does `uuid/3`, seeded with `20260807`, produce a well-formed version 4 UUID?

A UUID is written as 36 characters: 32 hexadecimal digits in groups of 8, 4,
4, 4, and 12, separated by hyphens. In version 4, the first digit of the third
group is `4`, and the first digit of the fourth group is `8`, `9`, `a`, or `b`.

---

# The program

```prolog
uuid_example(true) :-
  uuid(20260807, UUID, _),
  atom(UUID),
  atom_length(UUID, 36),
  sub_atom(UUID, 8, 1, 27, '-'),
  sub_atom(UUID, 13, 1, 22, '-'),
  sub_atom(UUID, 14, 1, 21, '4'),
  sub_atom(UUID, 18, 1, 17, '-'),
  sub_atom(UUID, 19, 1, 16, Variant),
  member(Variant, ['8', '9', a, b]),
  sub_atom(UUID, 23, 1, 12, '-').
```

`uuid/3` takes a seed and returns a UUID and the next seed, so randomness is
threaded explicitly instead of hidden in global state. `sub_atom/5` checks one
character at a time: the hyphens, the version digit, and the variant digit.

---

# The answer

```sh
eyeprolog examples/uuid.pl
```

```text
uuid_example(true).
```

Every structural check passed.

---

# The reason

```text
step(uuid(20260807, '08b72882-8bb9-484f-addc-f8c1a3867f4d', 1745479741), builtin, [], []).
step(sub_atom('08b72882-8bb9-484f-addc-f8c1a3867f4d', 14, 1, 21, '4'), builtin, [], []).
```

The proof shows the actual UUID, `08b72882-8bb9-484f-addc-f8c1a3867f4d`, and the
next seed, `1745479741`. Position 14 holds the version digit `4`, and position
19 holds the variant digit `a`.

---

# The check

```text
condition('C1', resolution, ok, 1).
condition('C5', re_decision, ok, 10).
recomputed(10).
verdict(checked).
```

The checker recomputes all 10 built-in steps, including `uuid/3` itself.
Because the generator is seeded, it gets the same UUID again, so even the
"random" step is checked.

---

# Try it

- Pass the returned seed `1745479741` into a second `uuid/3` call and check
  that the second UUID differs from the first.
- Change the seed and confirm that the shape checks still pass.
- Write a relation that generates five UUIDs from one seed and checks that
  they are all distinct.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 35.
