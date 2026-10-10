# Burn the witch

## How far can a chain of silly rules go?

Monty Python's witch trial is a chain of reasoning: a duck floats, things of
the same weight float alike, floating things are made of wood, wood burns, and
a woman who burns is a witch. EyeProlog runs that chain, and its proof shows
every link the verdict hangs on.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=witch) ·
[Source](../witch.pl)

---

# The question

Is the girl a witch?

Every rule in this example is absurd, but the inference is valid: if you accept
the premises, the conclusion follows. That is exactly what a logic program can
show, and exactly what it cannot settle. A proof checks the steps, not the
premises.

---

# The facts

```prolog
woman(girl).

floats(duck).

sameWeight(duck, girl).
```

Three observations: the girl is a woman, a duck floats, and the girl weighs the
same as the duck.

---

# The rules

```prolog
witch(X) :-
  burns(X),
  woman(X).

burns(X) :-
  madeOfWood(X).

madeOfWood(X) :-
  floats(X).

floats(Y) :-
  sameWeight(X, Y),
  floats(X).
```

Each rule is one link in the chain. The last one is recursive: something
floats if it weighs the same as something that floats. That rule is what
carries the duck's buoyancy over to the girl.

---

# The answer

```sh
eyeprolog examples/witch.pl
```

```text
witch(girl).
burns(duck).
burns(girl).
madeOfWood(duck).
madeOfWood(girl).
floats(girl).
holds_result(witchExample, true).
```

The duck also burns and is made of wood, but it is not a witch: the `witch/1`
rule also needs `woman/1`. `floats(duck)` is not printed because it only
repeats a source fact.

---

# The reason

```sh
eyeprolog --proof examples/witch.pl
```

```text
step(witch(girl), rule(1), ['X' = girl], [burns(girl), woman(girl)]).
step(madeOfWood(girl), rule(4), ['X' = girl], [floats(girl)]).
step(floats(girl), rule(6), ['Y' = girl, 'X' = duck], [sameWeight(duck, girl), floats(duck)]).
```

The girl is a witch by rule 1 because she burns and is a woman. Following the
`burns` link down, she is made of wood because she floats, and she floats by
rule 6 with `X = duck`: she weighs the same as the duck, and the duck floats.
Every verdict in the trial rests on that one weighing.

---

# The check

```sh
eyeprolog --proof examples/witch.pl > witch.why.pl
eyeprolog --check-proof witch.why.pl examples/witch.pl
```

```text
condition('C1', resolution, ok, 10).
condition('C4', coverage, ok, 16).
condition('C7', relevance, ok, 17).
verdict(checked).
```

The checker replays all 10 steps against the program without searching. All
seven claims are covered and nothing is taken on trust, so the verdict is
`checked`: the conclusion really does follow from these premises. Whether the
premises deserve belief is a different question, and no proof checker can
answer it.

---

# Try it

- Add `sameWeight(girl, newt).` and run it again. The newt now floats, is made
  of wood, and burns, but it is still not a witch. Which missing fact stops it?
- Delete the `sameWeight(duck, girl).` fact. The run now stops with
  `existence_error(procedure)`: with no `sameWeight/2` clauses left, the
  predicate is unknown, and EyeProlog reports that instead of silently failing.
- Change the weighing to `sameWeight(duck, goose).` Now the goose floats and
  burns, the girl is no longer a witch, and `holds_result(witchExample, true)`
  disappears from the output.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 3.
