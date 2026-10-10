# A backward rule

## Is 5 more interesting than 3?

The smallest possible rule-based argument: a conclusion that holds because a
rule says so, and the rule holds because a numeric comparison succeeds. The
proof has three steps, and the checker recomputes the arithmetic itself.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=backward) ·
[Source](../backward.pl)

---

# The question

Call one number "more interesting" than another when it is larger. Is 5 indeed
more interesting than 3?

The point is not the numbers. It is to see how a conclusion is justified
**backward**: to prove the goal, the solver looks for a rule whose head
matches it and then proves that rule's body.

---

# The program

```prolog
moreInterestingThan(X, Y) :- (X > Y).

isIndeedMoreInterestingThan(5, 3) :- moreInterestingThan(5, 3).
```

Two rules. The first defines the relation by a comparison. The second asks
about one particular pair.

---

# The answer

```sh
eyeprolog examples/backward.pl
```

```text
isIndeedMoreInterestingThan(5, 3).
```

---

# The reason

```sh
eyeprolog --proof examples/backward.pl
```

```text
step(isIndeedMoreInterestingThan(5, 3), rule(2), [], [moreInterestingThan(5, 3)]).
step(moreInterestingThan(5, 3), rule(1), ['X' = 5, 'Y' = 3], [5 > 3]).
step(5 > 3, builtin, [], []).
```

Read it top down: the conclusion holds by rule 2, which needs
`moreInterestingThan(5, 3)`; that holds by rule 1 with `X = 5` and `Y = 3`,
which needs `5 > 3`; and `5 > 3` is a built-in fact of arithmetic.

---

# The check

```text
condition('C1', resolution, ok, 2).
condition('C5', re_decision, ok, 1).
recomputed(1).
trusted(0).
claims(1).
verdict(checked).
```

The two rule steps resolve against their clauses. The comparison step cites no
clause, so the checker **recomputes** `5 > 3` in a program that contains none
of the example's rules. It agrees.

---

# Try it

- Change the second rule to ask about `(3, 5)`. What is printed, and why is
  nothing printed rather than an error?
- Generalize the second rule to `isIndeedMoreInterestingThan(X, Y) :-
  moreInterestingThan(X, Y).` and ask `--goal 'isIndeedMoreInterestingThan(5, Y)'`.
  What goes wrong, and why?
- Add facts `score(a, 5).` and `score(b, 3).` and a rule that compares items by
  score.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 3.
