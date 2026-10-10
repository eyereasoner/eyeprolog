# A rule that writes a rule

## Can one fact about two relations produce a new rule?

Knowing that `childOf` is the inverse of `parentOf` should be enough to turn
every parent statement into a child statement. In this example a rule derives
that backward rule as data, and the derived rule then feeds an ordinary one.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=derived-backward-rule) ·
[Source](../derived-backward-rule.pl)

---

# The question

In Notation3 (N3), a Semantic Web rule language, the example reads:

```text
parentOf invOf childOf.
alice parentOf bob.
{ P invOf Q. } => { { X Q Y. } <= { Y P X. }. }.
{ X childOf Y. } => { X hasParent Y. }.
```

The third line is a rule whose conclusion is itself a rule. Given that Alice
is Bob's parent, does it follow that Bob has a parent, and who?

---

# The facts

```prolog
invOf(parentOf, childOf).
parentOf(alice, bob).
```

`invOf(parentOf, childOf)` says that the two relations run in opposite
directions. `parentOf(alice, bob)` is the only family fact.

---

# The rules

```prolog
log_impliedBy(childOf(var(x), var(y)), parentOf(var(y), var(x))) :-
  invOf(parentOf, childOf).

childOf(X, Y) :-
  log_impliedBy(childOf(var(x), var(y)), parentOf(var(y), var(x))),
  parentOf(Y, X).

hasParent(X, Y) :- childOf(X, Y).
```

The first rule derives the backward rule as a **quoted formula**: `var(x)` and
`var(y)` are ordinary ground terms that name placeholders, not Prolog
variables. The second rule makes that derived rule executable: it fires only
once the quoted rule has been derived. The third is an ordinary rule.

---

# The answer

```sh
eyeprolog examples/derived-backward-rule.pl
```

```text
log_impliedBy(childOf(var(x), var(y)), parentOf(var(y), var(x))).
childOf(bob, alice).
hasParent(bob, alice).
```

First the derived rule itself, as data; then the child statement it licenses;
then the conclusion of the ordinary rule built on top.

---

# The reason

```sh
eyeprolog --proof examples/derived-backward-rule.pl
```

```text
step(childOf(bob, alice),
     rule(4),
     ['X' = bob, 'Y' = alice],
     [log_impliedBy(childOf(var(x), var(y)), parentOf(var(y), var(x))), parentOf(alice, bob)]).
step(hasParent(bob, alice), rule(5), ['X' = bob, 'Y' = alice], [childOf(bob, alice)]).
```

Bob is a child of Alice by clause 4, which used two things: the derived
backward rule and the fact that Alice is Bob's parent. `hasParent(bob, alice)`
then follows by clause 5. The proof shows that the derived rule really was a
premise, not a shortcut.

---

# The check

```sh
eyeprolog --proof examples/derived-backward-rule.pl > derived-backward-rule.why.pl
eyeprolog --check-proof derived-backward-rule.why.pl examples/derived-backward-rule.pl
```

```text
condition('C1', resolution, ok, 5).
condition('C4', coverage, ok, 7).
condition('C7', relevance, ok, 8).
verdict(checked).
```

All 5 steps replay against the clauses they cite, all 3 claims are covered,
and nothing is taken on trust.

---

# Try it

- Remove `invOf(parentOf, childOf).` and predict which of the three answers
  disappear.
- Add `parentOf(bob, carol).` How many `childOf/2` answers do you expect?
- Write the same idea for `employs` and `worksFor`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 3 (witnesses and terms that denote themselves).
