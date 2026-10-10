# Deep taxonomy, depth 1000

## How does a proof grow when the chain gets ten times longer?

The deep-taxonomy benchmark at depth 1000: 3000 chain rules and one question.
At this size the interesting part is the proof, which stays exactly as long as
the chain and no longer. Siblings: [10](deep-taxonomy-10.md),
[100](deep-taxonomy-100.md), [10000](deep-taxonomy-10000.md),
[100000](deep-taxonomy-100000.md).

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=deep-taxonomy-1000) ·
[Source](../deep-taxonomy-1000.pl)

---

# The question

`ind` is in class `n0`; each of 1000 levels lifts it one class higher; class
`n1000` implies `a2`. Is `ind` in `a2`, and how much evidence does the answer
need?

---

# The rules

```prolog
a(ind, n0).

a(X, a2) :- a(X, n1000).

a(X, n1) :- a(X, n0).
a(X, i1) :- a(X, n0).
a(X, j1) :- a(X, n0).
```

The pattern is the same at every depth; only the number of levels changes.

---

# The answer

```sh
eyeprolog examples/deep-taxonomy-1000.pl
```

```text
a(ind, a2).
```

---

# The reason

```text
step(a(ind, a2), rule(4), ['X' = ind], [a(ind, n1000)]).
step(a(ind, n1000), rule(3002), ['X' = ind], [a(ind, n999)]).
```

| Depth | Proof steps |
| --- | --- |
| 10 | 12 |
| 100 | 102 |
| 1000 | 1002 |

The proof grows linearly: one step per level plus the top class and the
starting fact. Each conclusion is recorded once, so the proof follows the
length of the argument, not the size of the program or the search.

---

# The check

```text
condition('C1', resolution, ok, 1002).
condition('C4', coverage, ok, 1002).
condition('C7', relevance, ok, 1003).
steps(1002).
trusted(0).
verdict(checked).
```

The checker replays 1002 steps without searching.

---

# Try it

- Ask `--goal 'a(ind, i500)'` with `--proof`. The proof has 501 steps; which
  rule does the first one cite?
- Compare the size of `examples/proof/deep-taxonomy-1000.pl` with the depth-100
  proof. Is the ratio what the step count predicts?
- Add a second individual with `a(bob, n0).` and ask `--goal 'a(Who, a2)'`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 11.
