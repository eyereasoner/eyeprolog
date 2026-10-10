# Animal classification

## If Joe is a human, is Joe an animal?

One fact about Joe and one rule about humans are enough for a two-level
classification. The example is tiny, which makes it a good place to see every
step of a proof and one subtle modeling choice.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=animal) ·
[Source](../animal.pl)

---

# The question

Joe is a human, and every human is an animal. What types does Joe have, and
is `human` a subclass of `animal`?

---

# The facts and the rule

```prolog
human(joe).
animal(human).

animal(X) :- human(X).
```

`animal(X) :- human(X)` is the inheritance rule: whatever is a human is an
animal.

Look closely at `animal(human)`. It uses the *class* name `human` as if it were
an individual. Mixing classes and individuals in one predicate is called
**punning**; it is convenient but worth noticing.

---

# The derived relations

```prolog
type(joe, human) :- human(joe).
type(joe, animal) :- animal(joe).
subclassOf(human, animal) :- animal(human).
succeeds(animalExample, true) :- animal(_).
```

These rules turn the classification into the relations the example reports.

---

# The answer

```sh
eyeprolog examples/animal.pl
```

```text
type(joe, human).
type(joe, animal).
subclassOf(human, animal).
succeeds(animalExample, true).
```

---

# The reason

```sh
eyeprolog --proof examples/animal.pl
```

```text
step(type(joe, animal), rule(5), [], [animal(joe)]).
step(animal(joe), rule(3), ['X' = joe], [human(joe)]).
step(human(joe), fact(1), [], []).
```

Joe is an animal by the inheritance rule (clause 3) with `X = joe`, because
Joe is a human (fact 1). The subclass claim, by contrast, rests directly on the
fact `animal(human)`, not on any rule about classes.

---

# The check

```text
condition('C1', resolution, ok, 7).
condition('C4', coverage, ok, 9).
condition('C7', relevance, ok, 11).
trusted(0).
claims(4).
verdict(checked).
```

All 7 steps check, all 4 claims are covered, and nothing is trusted.

---

# Try it

- Add `human(ann).` and predict which new answers appear. (Only rules that
  mention `joe` produce output; which ones would you generalize?)
- Remove the fact `animal(human).` Which answers disappear, and which survive?
- Rewrite the example with separate `instance_of/2` and `subclass_of/2`
  relations and one rule that inherits along subclass links.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 1.
