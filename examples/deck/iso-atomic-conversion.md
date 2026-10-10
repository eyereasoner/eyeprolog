# ISO atomic conversion

## How do atoms, characters, codes and numbers relate?

Standard Prolog has a small family of conversion predicates: join and split
atoms, turn an atom into characters or character codes, read a number from
characters, and find fragments inside an atom. Most of them work in more
than one direction. This example exercises each one and proves every result.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=iso-atomic-conversion) ·
[Source](../iso-atomic-conversion.pl)

---

# The question

Given the atom `eyeprolog`, what can the ISO conversion predicates tell us?
Which prefix joins with `prolog` to make it, what are the characters of
`eye`, which code is the letter λ, and which three-character pieces does
`eyeprolog` contain?

---

# The rules

```prolog
report(joined, Atom) :-
  atom_concat(eye, prolog, Atom).

report(prefix, Prefix) :-
  atom_concat(Prefix, prolog, eyeprolog).

report(decoded_character, Char) :-
  char_code(Char, 955).

report(fragment, fragment(Before, Part, After)) :-
  sub_atom(eyeprolog, Before, 3, After, Part).
```

`atom_concat/3` joins two atoms, or with the whole known, finds the missing
part. `char_code/2` relates a character to its Unicode code point.
`sub_atom/5` relates an atom to a fragment, with the number of characters
before and after it.

---

# The answer

```sh
eyeprolog examples/iso-atomic-conversion.pl
```

```text
report(joined, eyeprolog).
report(prefix, eye).
report(characters, "eye").
report(codes, [65, 90]).
report(decoded_character, 'λ').
report(number, 42).
report(fragment, fragment(0, eye, 6)).
...
report(fragment, fragment(6, log, 0)).
```

13 answers in all, including all seven three-character fragments of
`eyeprolog`. The character list `[e, y, e]` is printed as `"eye"`, the
double-quoted notation for the same list.

---

# The reason

```sh
eyeprolog --proof examples/iso-atomic-conversion.pl
```

```text
step(report(prefix, eye), rule(2), ['Prefix' = eye], [atom_concat(eye, prolog, eyeprolog)]).
step(report(decoded_character, 'λ'), rule(5), ['Char' = 'λ'], [char_code('λ', 955)]).
step(char_code('λ', 955), builtin, [], []).
```

Each report rests on one ISO built-in call, recorded with its result filled
in. The prefix `eye` is justified because `atom_concat(eye, prolog,
eyeprolog)` holds.

---

# The check

```text
condition('C1', resolution, ok, 13).
condition('C5', re_decision, ok, 12).
condition('C7', relevance, ok, 38).
verdict(checked).
```

The checker replays the 13 rule steps and independently recomputes the 12
built-in conversions. Every result is confirmed; nothing is trusted.

---

# Try it

- Add `report(float, F) :- number_chars(F, ['3', '.', '5']).` and check that
  it gives `3.5`.
- Add `report(split, Before-After) :- atom_concat(Before, After, ab).` It
  enumerates all three ways to split `ab`, including the empty atom `''`.
- Change the fragment length from 3 to 4 and predict the number of
  fragments.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 35.
