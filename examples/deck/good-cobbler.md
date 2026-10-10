# The good cobbler

## Can a statement about a statement be an ordinary term?

"Joe is a good cobbler" is not the same as "Joe is good and Joe is a cobbler".
This tiny example keeps the adjective attached to the profession and returns
the whole assertion as a nested term, with a one-step proof.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=good-cobbler) ·
[Source](../good-cobbler.pl)

---

# The question

Logicians use the good cobbler to show that some adjectives do not split
apart: a good cobbler may be a bad person. The safe representation keeps
`good(cobbler)` together as one term.

The example then asks for that assertion back as data, a statement about a
statement.

---

# The fact and the rule

```prolog
assertedIs(joe, good(cobbler)).

holds_result(test, holds_result(X, good(Y))) :-
  assertedIs(X, good(Y)).
```

`good(cobbler)` is a compound term, not a predicate call. The rule's head
builds a nested `holds_result/2` term that quotes the assertion it found.

---

# The answer

```sh
eyeprolog examples/good-cobbler.pl
```

```text
holds_result(test, holds_result(joe, good(cobbler))).
```

One answer: the outer `holds_result/2` is the claim, and the inner one is the
quoted assertion.

---

# The reason

```text
step(holds_result(test, holds_result(joe, good(cobbler))),
     rule(2),
     ['X' = joe, 'Y' = cobbler],
     [assertedIs(joe, good(cobbler))]).
step(assertedIs(joe, good(cobbler)), fact(1), [], []).
```

The rule (clause 2) fires with `X = joe` and `Y = cobbler`, using the single
fact (clause 1). Unification matched `good(Y)` against `good(cobbler)`
structurally.

---

# The check

```text
condition('C1', resolution, ok, 2).
condition('C4', coverage, ok, 2).
condition('C7', relevance, ok, 3).
verdict(checked).
```

Both steps replay against their clauses, the claim is covered, and nothing is
trusted.

---

# Try it

- Add `assertedIs(joe, bad(person)).` Does it produce a second answer? Why
  not?
- Change the rule so it matches any adjective, `assertedIs(X, Adj)`, and
  compare the output.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 2.
