# Deep taxonomy, depth 10

## Does one individual, climbing ten levels of a class hierarchy, reach the top?

The deep-taxonomy benchmark is a long chain of subclass rules. This is its
smallest version: ten levels, small enough to read the whole proof. Its
siblings run the same chain at depths
[100](deep-taxonomy-100.md), [1000](deep-taxonomy-1000.md),
[10000](deep-taxonomy-10000.md), and [100000](deep-taxonomy-100000.md).

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=deep-taxonomy-10) ·
[Source](../deep-taxonomy-10.pl)

---

# The question

An individual `ind` belongs to class `n0`. Every member of `n0` is also a
member of `n1`, every member of `n1` of `n2`, and so on up to `n10`; every
member of `n10` belongs to `a2`. Is `ind` in `a2`?

The benchmark comes from the Semantic Web, where such chains are written as
N3 rules; here each rule is one Prolog clause.

---

# The facts and rules

```prolog
a(ind, n0).

a(X, a2) :- a(X, n10).

a(X, n1) :- a(X, n0).
a(X, i1) :- a(X, n0).
a(X, j1) :- a(X, n0).
a(X, n2) :- a(X, n1).
a(X, i2) :- a(X, n1).
a(X, j2) :- a(X, n1).
```

`a(X, C)` reads "X is a member of class C". Each level has three rules: one
climbs to the next `n` class, and two add side labels `i` and `j` that lead
nowhere. The side labels are there to tempt a reasoner into extra work.

---

# The answer

```sh
eyeprolog examples/deep-taxonomy-10.pl
```

```text
a(ind, a2).
```

Yes: `ind` reaches the top class.

---

# The reason

```sh
eyeprolog --proof examples/deep-taxonomy-10.pl
```

```text
step(a(ind, a2), rule(4), ['X' = ind], [a(ind, n10)]).
step(a(ind, n10), rule(32), ['X' = ind], [a(ind, n9)]).
step(a(ind, n9), rule(29), ['X' = ind], [a(ind, n8)]).
```

At this depth the whole proof fits on a slide: 12 steps, from `a2` down
through `n10`, `n9`, … to the fact `a(ind, n0)`. No `i` or `j` label appears.
EyeProlog works backwards from the question, so it never derives the side
labels at all.

---

# The check

```text
condition('C1', resolution, ok, 12).
condition('C4', coverage, ok, 12).
condition('C7', relevance, ok, 13).
steps(12).
trusted(0).
verdict(checked).
```

The checker replays all 12 steps against the cited clauses. Every step is
needed for the claim, and nothing is taken on trust.

---

# Try it

- Ask for every class `ind` belongs to: `--goal 'a(ind, X)'`. There are 31
  answers: `n1`–`n10`, `i1`–`i10`, `j1`–`j10`, and `a2`.
- Ask `--goal 'a(ind, j10)'` and compare its proof with the one above.
- Save the proof, delete the step for `a(ind, n5)`, and run `--check-proof`
  on the result. Which conditions fail, and why does a gap in the middle of a
  chain break more than one link?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 4 and 11.
