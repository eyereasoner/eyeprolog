# Family cousins

## Who are cousins in this family tree?

Cousins sit in the same generation of a family but descend from different
children of the common ancestor. This example derives generations and branch
labels from parent links, then combines them into the cousin relation.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=family-cousins) ·
[Source](../family-cousins.pl)

---

# The question

Adam has two children, Bob and Carol, and the family grows from there. Two
people are cousins here when they are in the same generation counted from
Adam, and one belongs to Bob's branch while the other belongs to Carol's. The
program has to work out both the generation and the branch for everyone.

---

# The family as data

```prolog
family_graph(familyGraph, (
  parent(adam, bob),
  parent(adam, carol),
  parent(bob, dave),
  parent(bob, eve),
  parent(carol, frank),
  parent(carol, grace),
  parent(dave, heidi),
  parent(eve, ivan),
  parent(frank, judy),
  seedBranch(dave, b),
  seedBranch(eve, b),
  seedBranch(frank, c),
  seedBranch(grace, c)
)).
```

The whole tree is one term, a bundle of statements, rather than global facts.
`family_statement/3` walks the bundle and projects out the `parent` and
`seedBranch` statements the rules need.

---

# The rules

```prolog
generation(adam, 0).
generation(Child, Next) :-
  parent(Parent, Child),
  generation(Parent, Gen),
  (Next is Gen + 1).

branch(Child, Branch) :-
  parent(Parent, Child),
  branch(Parent, Branch).

cousin(X, Y) :-
  generation(X, Gen),
  generation(Y, Gen),
  branch(X, Bx),
  branch(Y, By),
  different(Bx, By).
```

Generations count down from Adam; branch labels flow from the seeded
grandchildren to their descendants. A cousin pair joins the two: the same
`Gen`, different branches.

---

# The answer

```sh
eyeprolog examples/family-cousins.pl
```

```text
cousin(dave, frank).
cousin(dave, grace).
cousin(eve, frank).
cousin(eve, grace).
cousin(heidi, judy).
cousin(ivan, judy).
```

The full output has 28 answers: 7 branch labels, 9 generations, and 12 cousin
pairs (each pair appears in both orders). Heidi and Ivan are both in Bob's
branch, so they are not cousins of each other in this model.

---

# The reason

```text
step(cousin(heidi, judy),
     rule(15),
     ['X' = heidi, 'Y' = judy, 'Gen' = 3, 'Bx' = b, 'By' = c],
     [generation(heidi, 3),
      generation(judy, 3),
      branch(heidi, b),
      branch(judy, c),
      different(b, c)]).
step(generation(heidi, 3),
     rule(12),
     ['Child' = heidi, 'Next' = 3, 'Parent' = dave, 'Gen' = 2],
     [parent(dave, heidi), generation(dave, 2), 3 is 2 + 1]).
```

Heidi and Judy are cousins because both are in generation 3, Heidi in branch
`b` and Judy in branch `c`. Heidi's generation in turn comes from her parent
Dave's.

---

# The check

```text
condition('C1', resolution, ok, 157).
condition('C5', re_decision, ok, 29).
condition('C7', relevance, ok, 214).
verdict(checked).
```

The checker replays 157 rule steps and recomputes 29 arithmetic and comparison
steps. Nothing is trusted.

---

# Try it

- Add `parent(grace, ken)` to the family graph. Who are Ken's cousins?
- Heidi and Ivan are grandchildren of Bob through different children. Write a
  `second_branch` rule that would make them cousins too.
- Why does the program need `different/2` facts instead of `Bx \= By`, and
  would `\=` work here?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 4 and 9.
