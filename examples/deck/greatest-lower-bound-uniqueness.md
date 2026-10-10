# Greatest lower bounds are unique

## If two things are both the greatest lower bound of the same pair, are they the same?

A classic lemma of order theory, written as rules. Two names, `g1` and `g2`,
are both declared the greatest lower bound of `a` and `b`; the rules derive
that each lies below the other, and therefore that they denote the same
element.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=greatest-lower-bound-uniqueness) ·
[Source](../greatest-lower-bound-uniqueness.pl)

---

# The question

In an ordered set, a **lower bound** of `a` and `b` is anything below both. The
**greatest lower bound** (GLB) is the lower bound that every other lower bound
lies below. Mathematicians prove it is unique: two GLBs must each be below the
other, and in a partial order that makes them equal (antisymmetry).

The example runs that argument on concrete names.

---

# The facts and rules

```prolog
glbOf(g1, a, b).
glbOf(g2, a, b).

lowerBoundOf(M, A, B) :- glbOf(M, A, B).

leq(L, M) :-
  glbOf(M, A, B),
  lowerBoundOf(L, A, B).

sameTerm(M, N) :-
  leq(M, N),
  leq(N, M).
```

`leq/2` is the defining property of a GLB: any lower bound `L` is below the
GLB `M`. `sameTerm/2` is antisymmetry: below each other means the same.

---

# The conclusion

```prolog
sameGreatestLowerBound(A, B, M, N) :-
  glbOf(M, A, B),
  glbOf(N, A, B),
  sameTerm(M, N),
  (M \= N).
```

The `M \= N` test keeps only the interesting answers, where two *different
names* turn out to denote the same bound.

---

# The answer

```sh
eyeprolog examples/greatest-lower-bound-uniqueness.pl
```

```text
sameGreatestLowerBound(a, b, g1, g2).
sameGreatestLowerBound(a, b, g2, g1).
```

The relation is symmetric, so the conclusion appears once in each direction.

---

# The reason

```text
step(sameTerm(g1, g2), rule(5), ['M' = g1, 'N' = g2], [leq(g1, g2), leq(g2, g1)]).
step(leq(g1, g2),
     rule(4),
     ['L' = g1, 'M' = g2, 'A' = a, 'B' = b],
     [glbOf(g2, a, b), lowerBoundOf(g1, a, b)]).
```

`g1` and `g2` are the same because each is below the other. `g1` is below `g2`
because `g2` is a GLB of `a` and `b`, and `g1` is a lower bound of them. This is
the textbook proof, one step per line.

---

# The check

```text
condition('C1', resolution, ok, 10).
condition('C5', re_decision, ok, 2).
verdict(checked).
```

The 10 rule and fact steps replay against their clauses, and the two
`g1 \= g2` tests were recomputed and agreed. Nothing is trusted.

---

# Try it

- Add a third name, `glbOf(g3, a, b).` How many answers now? (Six: every
  ordered pair of distinct names.)
- Remove `lowerBoundOf/3` and say which step of the mathematical argument goes
  missing.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 28.
