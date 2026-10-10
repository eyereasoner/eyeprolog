# A derived rule

## If there is a cat, does a dog make the test true?

A rule can conclude another rule. Here the presence of a cat derives the rule
"if something is a dog, the test is true", and the presence of a dog then
fires it. The derived rule is kept as data, so it can be printed and cited.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=derived-rule) ·
[Source](../derived-rule.pl)

---

# The question

In Notation3 (N3), a Semantic Web rule language:

```text
minka a cat.
charly a dog.
{ X a cat. } => { { Y a dog. } => { test is true. }. }.
```

The rule's conclusion is itself a rule. Does the test come out true?

---

# The facts

```prolog
type(minka, cat).
type(charly, dog).
```

Minka is a cat and Charly is a dog.

---

# The rules

```prolog
log_implies(type(var(y), dog), holds_result(test, true)) :-
  type(_x, cat).

holds_result(test, true) :-
  log_implies(type(var(y), dog), holds_result(test, true)),
  type(_y, dog).
```

The first rule derives the inner implication as a **quoted formula**:
`var(y)` is a ground term naming a placeholder, not a Prolog variable. The
second rule applies that derived implication: it needs both the implication
and some dog.

---

# The answer

```sh
eyeprolog examples/derived-rule.pl
```

```text
log_implies(type(var(y), dog), holds_result(test, true)).
holds_result(test, true).
```

The derived rule is itself an answer, followed by the test result it produces.

---

# The reason

```sh
eyeprolog --proof examples/derived-rule.pl
```

```text
step(log_implies(type(var(y), dog), holds_result(test, true)), rule(3), [], [type(minka, cat)]).
step(holds_result(test, true),
     rule(4),
     [],
     [log_implies(type(var(y), dog), holds_result(test, true)), type(charly, dog)]).
```

The implication exists because Minka is a cat (clause 3). The test is true by
clause 4, which used the derived implication and the fact that Charly is a dog.

---

# The check

```sh
eyeprolog --proof examples/derived-rule.pl > derived-rule.why.pl
eyeprolog --check-proof derived-rule.why.pl examples/derived-rule.pl
```

```text
condition('C1', resolution, ok, 4).
condition('C4', coverage, ok, 5).
condition('C7', relevance, ok, 6).
verdict(checked).
```

All 4 steps replay against their clauses, both claims are covered, and nothing
is taken on trust.

---

# Try it

- Remove `type(minka, cat).` Which answers remain?
- Remove `type(charly, dog).` instead. Is the derived rule still printed?
- Compare with the [derived backward rule](derived-backward-rule.md) deck,
  where the derived rule runs in the opposite direction.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 3.
