# Integrity check

## Is the input itself consistent?

A stone is recorded as both black and white. Before trusting any conclusion
about it, a careful system should notice the contradiction. In EyeProlog an
integrity check is just an ordinary relation whose answers are defects, so
the host can ask for it first and decide what to do.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=integrity-check) ·
[Source](../integrity-check.pl)

---

# The question

Which records are invalid, and what status should each object get?

There is no special constraint syntax. An invalid state is a positive,
queryable fact about the data, with a reason attached, so the answer is a
diagnosis rather than a bare "no".

---

# The model

```prolog
color(stone, black).
color(stone, white).

invalid_state(X, conflicting_colors) :-
  color(X, black),
  color(X, white).
```

The forbidden combination is "black and white at once". Its answers name
the object and the reason.

---

# The decision

```prolog
status(X, invalid(Reason)) :- invalid_state(X, Reason).
status(X, consistent) :- color(X, _), \+ invalid_state(X, _).
```

An object with a defect gets `invalid(Reason)`. Any other object with a
color is `consistent`; the negation `\+` asks whether no defect can be found.

---

# The answer

```sh
eyeprolog examples/integrity-check.pl
```

```text
invalid_state(stone, conflicting_colors).
status(stone, invalid(conflicting_colors)).
```

The stone is flagged, and its status carries the reason.

---

# The reason

```sh
eyeprolog --proof examples/integrity-check.pl
```

```text
step(invalid_state(stone, conflicting_colors),
     rule(3),
     ['X' = stone],
     [color(stone, black), color(stone, white)]).
```

The defect rests on exactly two source facts, `color(stone, black)` and
`color(stone, white)`. A reviewer can see which records to fix.

---

# The check

```text
condition('C1', resolution, ok, 4).
condition('C4', coverage, ok, 5).
condition('C7', relevance, ok, 6).
verdict(checked).
```

All four steps replay against their clauses, every claim and use is covered,
and every step serves a claim. Nothing is trusted.

---

# Try it

- Remove `color(stone, white).` The defect disappears and the output becomes
  `status(stone, consistent).`
- Add `color(pebble, white).` and predict the extra status line.
- Add a second defect, such as an object with no color at all, and give it
  its own reason.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 12.
