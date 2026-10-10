# Inverses in a group are unique

## If two elements both undo `x`, are they really different?

In a group every element has an inverse, and only one. This example gives `x`
two candidate inverses, `i` and `j`, checks that one works on the left and the
other on the right, and concludes that they name the same element.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=group-inverse-uniqueness) ·
[Source](../group-inverse-uniqueness.pl)

---

# The question

A **group** is a set with an operation, an identity element `e`, and inverses:
combining an element with its inverse gives `e`. A standard first theorem says
inverses are unique. If `i·x = e` and `x·j = e`, then
`i = i·(x·j) = (i·x)·j = j`.

---

# The group table

```prolog
group_op(e, X, X) :- element(X).
group_op(X, e, X) :- element(X).
group_op(i, x, e).
group_op(x, j, e).
group_op(j, x, e).
group_op(x, i, e).
```

`group_op(A, B, C)` means `A·B = C`. The identity rules say `e` changes
nothing; the four facts make both `i` and `j` inverses of `x`.

---

# The rules

```prolog
leftInverse(A, B) :- group_op(B, A, e).
rightInverse(A, B) :- group_op(A, B, e).

sameInverse(A, B, C) :-
  leftInverse(A, B),
  rightInverse(A, C),
  sameTerm(B, C),
  (B \= C).
```

`sameTerm/2` holds the conclusion of the algebraic argument above, stated as
facts: `sameTerm(i, j)` and `sameTerm(j, i)`. The rule reports pairs of
*different names* for the same inverse.

---

# The answer

```sh
eyeprolog examples/group-inverse-uniqueness.pl
```

```text
sameInverse(x, i, j).
sameInverse(x, j, i).
```

---

# The reason

```text
step(sameInverse(x, i, j),
     rule(16),
     ['A' = x, 'B' = i, 'C' = j],
     [leftInverse(x, i), rightInverse(x, j), sameTerm(i, j), i \= j]).
step(leftInverse(x, i), rule(14), ['A' = x, 'B' = i], [group_op(i, x, e)]).
step(rightInverse(x, j), rule(15), ['A' = x, 'B' = j], [group_op(x, j, e)]).
```

`i` is a left inverse of `x` because `i·x = e`, `j` is a right inverse because
`x·j = e`, and the identity of the two is the fact `sameTerm(i, j)`.

---

# The check

```text
condition('C1', resolution, ok, 12).
condition('C5', re_decision, ok, 2).
verdict(checked).
```

All 12 rule and fact steps replay, and the two `\=` tests were recomputed and
agreed. Nothing is trusted. Note what the check does and does not establish:
the derivation is valid, but the algebra that justifies `sameTerm(i, j)` lives
in a fact, not in the proof.

---

# Try it

- Remove the two `sameTerm(i, j)` and `sameTerm(j, i)` facts. The program now
  prints nothing: the conclusion depended on them.
- Derive `sameTerm/2` from the group laws instead of stating it. Which
  associativity facts would `group_op/3` need?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 28.
