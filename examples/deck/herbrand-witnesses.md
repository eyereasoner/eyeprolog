# Herbrand witnesses

## How do you say "there exists" in a rule?

"Every person has a parent" asserts that some parent exists without naming
one. EyeProlog rule heads cannot introduce anonymous objects, so this example
names the witness with a term instead: `parent_of(alice)`. The witness is
ordinary data that you can print, query, and see in a proof.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=herbrand-witnesses) ·
[Source](../herbrand-witnesses.pl)

---

# The question

How can a rule conclude that *something* exists, such as a parent for every
person or a registration record for every student and course, when the
data does not name that something?

Many rule languages use blank nodes or existential variables. Here the answer
is a **Herbrand witness**: a compound term built from the inputs that the
existence depends on.

---

# The facts

```prolog
person(alice).
person(bob).

takes(alice, logic).
takes(alice, math).
takes(bob, logic).
```

Two people, and three student/course pairs.

---

# The rules

```prolog
has_parent(Child, parent_of(Child)) :-
  person(Child).

registration(Student, Course, registration_of(Student, Course)) :-
  takes(Student, Course).
```

`parent_of(Child)` depends on one input, so each person gets one parent
witness. `registration_of(Student, Course)` depends on two, so each pair gets
its own record. The same inputs always build the same witness, and different
inputs always build different ones.

---

# The answer

```sh
eyeprolog examples/herbrand-witnesses.pl
```

```text
has_parent(alice, parent_of(alice)).
has_parent(bob, parent_of(bob)).
registration(alice, logic, registration_of(alice, logic)).
registration(alice, math, registration_of(alice, math)).
registration(bob, logic, registration_of(bob, logic)).
same_witness(parent_of_alice, true).
distinct_witnesses(alice_logic_vs_alice_math, true).
```

The last two lines confirm the two properties: a witness is stable, and
witnesses for different inputs are distinct.

---

# The reason

```sh
eyeprolog --proof examples/herbrand-witnesses.pl
```

```text
step(has_parent(alice, parent_of(alice)), rule(6), ['Child' = alice], [person(alice)]).
step(person(alice), fact(1), [], []).
```

Alice has the parent witness `parent_of(alice)` by rule 6 with
`Child = alice`, because she is a person (fact 1). The witness appears in the
proof just like any other term.

---

# The check

```text
condition('C1', resolution, ok, 12).
condition('C5', re_decision, ok, 2).
condition('C7', relevance, ok, 21).
verdict(checked).
```

All 12 rule and fact steps replay against their clauses, and the two
built-in comparisons (`=` and `\=` on witness terms) are recomputed
independently. The verdict has no trusted boundaries.

---

# Try it

- Add `person(carol).` and `takes(carol, math).` and predict the two new
  answers about Carol.
- Write `has_mother/2` with a witness `mother_of(Child)`. Is
  `mother_of(alice)` different from `parent_of(alice)`?
- See [`herbrand-semantics`](herbrand-semantics.md) for why distinct terms
  are always distinct.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 3.
