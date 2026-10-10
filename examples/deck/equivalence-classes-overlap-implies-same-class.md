# Overlapping equivalence classes

## If two classes share a member, are they the same class?

For an equivalence relation, yes: classes either coincide or are disjoint.
This example derives "same class" conclusions and names the shared member that
witnesses each one, so the proof shows *why* two elements belong together.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=equivalence-classes-overlap-implies-same-class) ·
[Source](../equivalence-classes-overlap-implies-same-class.pl)

---

# The question

An **equivalence relation** is reflexive, symmetric, and transitive. It splits
a set into **classes**, and a standard lemma says two classes that share one
member are the same class. Here the class is already computed:
`class_abc` contains `a`, `b`, and `c`. The question is which pairs of distinct
elements are in the same class, and which member explains it.

---

# The model

```prolog
classMember(class_abc, a).
classMember(class_abc, b).
classMember(class_abc, c).

inClassOf(U, X) :-
  classMember(Class, U),
  classMember(Class, X).

sameClassBecauseOfSharedMember(X, Y, Z) :-
  inClassOf(Z, X),
  inClassOf(Z, Y),
  sameClass(X, Y),
  (X \= Y).
```

`inClassOf(Z, X)` says `Z` and `X` sit in a common class. The conclusion
carries the witness `Z`: both `X` and `Y` share a class with it.

---

# The answer

```sh
eyeprolog examples/equivalence-classes-overlap-implies-same-class.pl
```

```text
sameClassBecauseOfSharedMember(a, b, a).
sameClassBecauseOfSharedMember(a, c, a).
sameClassBecauseOfSharedMember(b, a, a).
sameClassBecauseOfSharedMember(b, c, a).
sameClassBecauseOfSharedMember(c, a, a).
sameClassBecauseOfSharedMember(c, b, a).
```

These are the first 6 of 18 answers: every ordered pair of distinct elements
(6 pairs), each with every member of the class (3 witnesses) as its
explanation.

---

# The reason

```text
step(sameClassBecauseOfSharedMember(a, b, a),
     rule(6),
     ['X' = a, 'Y' = b, 'Z' = a],
     [inClassOf(a, a), inClassOf(a, b), sameClass(a, b), a \= b]).
step(inClassOf(a, b),
     rule(4),
     ['U' = a, 'X' = b, 'Class' = class_abc],
     [classMember(class_abc, a), classMember(class_abc, b)]).
```

`a` and `b` are in the same class because both share `class_abc` with the
witness `a`. The last use, `a \= b`, is a built-in test.

---

# The check

```text
condition('C1', resolution, ok, 36).
condition('C4', coverage, ok, 120).
condition('C5', re_decision, ok, 6).
condition('C7', relevance, ok, 60).
verdict(checked).
```

The checker replays 36 rule steps and recomputes the 6 `\=` tests itself
(C5). Nothing is taken on trust.

---

# Try it

- Add a second class `classMember(class_de, d).` and
  `classMember(class_de, e).`. Which new answers appear, and does any pair
  cross the two classes?
- Also add `classMember(class_de, a).`, so the classes overlap in `a`. No
  answer relates `d` to `b`, because the `sameClass(X, Y)` goal demands one
  common class. Delete that goal and run again: `d` and `b` now come out
  related through `a`. Which property of equivalence classes does the
  overlapping fact violate?
- Change the rule to report each pair once, with the smallest witness.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 28.
