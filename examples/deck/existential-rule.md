# Existential rules with witnesses

## How can a rule say "there exists something" without inventing anonymous objects?

"Every human has a witness of their humanity" is an existential statement.
EyeProlog has no blank nodes and no existential variables in rule heads, so
this example names the witness with a term built from the person it belongs
to.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=existential-rule) ·
[Source](../existential-rule.pl)

---

# The question

Semantic Web rule languages often allow a rule head to introduce a new,
unnamed thing: "for every human there is some witness". In logic this is an
**existential** consequence. The executable version used here is a
**Skolem term**: a function symbol applied to the variables the new thing
depends on, so the "something" gets a stable, printable name.

---

# The program

```prolog
type(socrates, human).
type(plato, human).

holds_result(Person, human_witness(Person)) :-
  type(Person, human).
```

`human_witness(Person)` is the witness. The same person always yields the same
witness, and different people yield different ones.

---

# The answer

```sh
eyeprolog examples/existential-rule.pl
```

```text
holds_result(socrates, human_witness(socrates)).
holds_result(plato, human_witness(plato)).
```

Each human gets exactly one witness, and you can see it, query it, and refer
to it in later rules.

---

# The reason

```text
step(holds_result(socrates, human_witness(socrates)),
     rule(3),
     ['Person' = socrates],
     [type(socrates, human)]).
step(type(socrates, human), fact(1), [], []).
```

The witness for Socrates exists because rule 3 applied with
`Person = socrates`, using the fact that Socrates is human.

---

# The check

```text
condition('C1', resolution, ok, 4).
condition('C4', coverage, ok, 4).
condition('C7', relevance, ok, 6).
verdict(checked).
```

All four steps replay against the program. Nothing is trusted, because the
witness is an ordinary term rather than a hidden object.

---

# Try it

- Add `type(aristotle, human).` and predict the new answer.
- Add a rule `teacher_witness(P, taught_by(P)) :- type(P, human).` Do the two
  kinds of witness for the same person ever collide?
- What would go wrong if the witness ignored the person, as in
  `holds_result(Person, a_witness)`?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 3.
