# Deep taxonomy, depth 10000

## Can a reasoner follow ten thousand dependent steps without losing its way?

The deep-taxonomy benchmark at depth 10000: 30,000 chain rules, each step
depending on the one before. At this depth the recursion itself is the test:
the answer needs 10,000 nested subgoals. Siblings: [10](deep-taxonomy-10.md),
[100](deep-taxonomy-100.md), [1000](deep-taxonomy-1000.md),
[100000](deep-taxonomy-100000.md).

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=deep-taxonomy-10000) ·
[Source](../deep-taxonomy-10000.pl)

---

# The question

`ind` is in `n0`, each of 10,000 levels lifts it one class higher, and
`n10000` implies `a2`. Is `ind` in `a2`?

Proving `a(ind, a2)` asks for `a(ind, n10000)`, which asks for
`a(ind, n9999)`, and so on, ten thousand levels deep. An implementation that
used one native stack frame per level could overflow here.

---

# The rules

```prolog
a(ind, n0).

a(X, a2) :- a(X, n10000).

a(X, n1) :- a(X, n0).
a(X, i1) :- a(X, n0).
a(X, j1) :- a(X, n0).
```

---

# The answer

```sh
eyeprolog examples/deep-taxonomy-10000.pl
```

```text
a(ind, a2).
```

`eyeprolog --stats` reports a maximum depth of 10001. EyeProlog's solver is
iterative, so a deep chain costs memory, not native stack.

---

# The reason

```text
step(a(ind, a2), rule(4), ['X' = ind], [a(ind, n10000)]).
step(a(ind, n10000), rule(30002), ['X' = ind], [a(ind, n9999)]).
```

10,002 steps and 10,002 cited clauses. The proof file is about 1.2 MB, yet
every line is one small, independently checkable claim.

---

# The check

```text
condition('C1', resolution, ok, 10002).
condition('C2', well_founded, ok, 10002).
condition('C4', coverage, ok, 10002).
steps(10002).
trusted(0).
verdict(checked).
```

C2 (well-foundedness) matters at this depth: the checker confirms that the
10,002 steps form a chain that ends in a fact and never loops back on itself.

---

# Try it

- Run with `--stats` and compare `max_depth` with the depth-1000 version.
- Ask `--goal 'a(ind, n5000)'`. How many steps does its proof need?
- Time the run and the `--check-proof` of its proof. Which is faster, and why
  might checking be cheaper than finding?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 13 and 16.
