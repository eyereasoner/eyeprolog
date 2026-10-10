# Deep taxonomy, depth 100

## What does a reasoner have to derive to answer one question?

The deep-taxonomy benchmark at depth 100: a chain of 100 subclass levels, each
with two side labels that no question needs. It shows the difference between
deriving *everything* and deriving *what the question needs*. Siblings:
[10](deep-taxonomy-10.md), [1000](deep-taxonomy-1000.md),
[10000](deep-taxonomy-10000.md), [100000](deep-taxonomy-100000.md).

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=deep-taxonomy-100) ·
[Source](../deep-taxonomy-100.pl)

---

# The question

`ind` starts in class `n0`. Rules lift it to `n1`, `n2`, … `n100`, and
membership of `n100` implies membership of `a2`. Is `ind` in `a2`?

A forward-chaining reasoner would compute every consequence: 300 class
memberships plus `a2`. A goal-directed one starts from the question and
follows only the rules that can answer it.

---

# The rules

```prolog
a(ind, n0).

a(X, a2) :- a(X, n100).

a(X, n1) :- a(X, n0).
a(X, i1) :- a(X, n0).
a(X, j1) :- a(X, n0).
```

The program has 300 chain rules: per level, one `n` rule and two side-label
rules (`i`, `j`).

---

# The answer

```sh
eyeprolog examples/deep-taxonomy-100.pl
```

```text
a(ind, a2).
```

---

# The reason

```text
step(a(ind, a2), rule(4), ['X' = ind], [a(ind, n100)]).
step(a(ind, n100), rule(302), ['X' = ind], [a(ind, n99)]).
```

The proof has 102 steps: `a2`, the hundred `n` levels, and the starting fact.
None of the 200 side labels appears, because EyeProlog never needed to derive
them. `eyeprolog --stats` shows a maximum search depth of 101: one level of
recursion per class in the chain.

---

# The check

```text
condition('C1', resolution, ok, 102).
condition('C4', coverage, ok, 102).
condition('C7', relevance, ok, 103).
steps(102).
trusted(0).
verdict(checked).
```

All 102 steps replay against their clauses, with nothing trusted.

---

# Try it

- Ask for everything: `--goal 'a(ind, X)'` returns 301 answers. Compare the
  `--stats` counters with the plain run.
- Ask only `--goal 'a(ind, n50)'` and count the proof steps.
- Remove the rule `a(X, n50) :- a(X, n49).` and predict the output.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 13 and 21.
