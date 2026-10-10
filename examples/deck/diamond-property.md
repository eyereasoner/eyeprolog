# The diamond property

## When two paths split, can they meet again?

A relation has the **diamond property** when any two steps out of the same
point can be completed to a common point. The idea underlies confluence
results in rewriting and the lambda calculus. This example checks it on a
four-node graph and shows that it survives adding reflexive steps.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=diamond-property) ·
[Source](../diamond-property.pl)

---

# The question

From `a` you can step to `b` or to `c`. Is there a `d` reachable in one step
from both? And if every node is also allowed to step to itself (the
**reflexive closure**), does the diamond still close?

---

# The graph

```prolog
node(a).
node(b).
node(c).
node(d).

r(a, b).
r(a, c).
r(b, d).
r(c, d).
```

Four nodes and four edges: the shape of a diamond.

---

# The rules

```prolog
re(X, X) :- node(X).
re(X, Y) :- r(X, Y).

diamond(Rel, A, B, C, D) :-
  step(Rel, A, B),
  step(Rel, A, C),
  step(Rel, B, D),
  step(Rel, C, D).

step(r, X, Y) :- r(X, Y).
step(re, X, Y) :- re(X, Y).
```

`re/2` is the reflexive closure of `r/2`. `diamond/5` states the property
directly: two steps out of `A`, and both continuations meeting at `D`.
`step/3` lets one definition work for either relation.

---

# The answer

```sh
eyeprolog examples/diamond-property.pl
```

```text
holdsFor(diamondProperty, r).
holdsFor(diamondProperty, re).
commonSuccessor(diamondProperty, d).
preservedUnderReflexiveClosure(diamondProperty, true).
```

The diamond closes for `r` and for its reflexive closure, and the common
successor is `d`.

---

# The reason

```sh
eyeprolog --proof examples/diamond-property.pl
```

```text
step(diamond(re, a, b, c, d),
     rule(11),
     ['Rel' = re, 'A' = a, 'B' = b, 'C' = c, 'D' = d],
     [step(re, a, b), step(re, a, c), step(re, b, d), step(re, c, d)]).
step(re(a, b), rule(10), ['X' = a, 'Y' = b], [r(a, b)]).
```

The diamond for `re` rests on four `re` steps, and each of those comes from an
original `r` edge by clause 10. The reflexive steps are available but were not
needed.

---

# The check

```sh
eyeprolog --proof examples/diamond-property.pl > diamond-property.why.pl
eyeprolog --check-proof diamond-property.why.pl examples/diamond-property.pl
```

```text
condition('C1', resolution, ok, 22).
condition('C4', coverage, ok, 28).
condition('C7', relevance, ok, 26).
verdict(checked).
```

All 22 steps replay against their clauses, all 4 claims are covered, and
nothing is taken on trust.

---

# Try it

- Remove `r(c, d).` Which answers disappear?
- Ask `--goal 'diamond(r, a, B, C, D)'` to see every way the diamond closes,
  including the degenerate ones where `B` and `C` coincide.
- Write `diamond_from(Rel, A)` that holds when *every* pair of steps out of
  `A` can be joined, using `\+` over a counterexample relation.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 28 (algebra, symmetry, and representation).
