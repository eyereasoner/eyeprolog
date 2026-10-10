# Delayed disequality with dif/2

## How do you say "these must differ" before you know what they are?

The ISO test `\=/2` asks whether two terms fail to unify *right now*. With
unbound variables it simply fails. `dif/2` instead records a constraint and
rechecks it as later goals bind the variables, so it can be stated first.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=dif-constraints) ·
[Source](../dif-constraints.pl)

---

# The question

Can a rule demand that `X` and `Y` differ before either is bound, and still
behave correctly once they are? And what happens when a later binding settles
the constraint early?

---

# The rules

```prolog
allowed_pair(X, Y) :-
    dif(X, Y),
    X = left,
    Y = right.

specialization(X, Y) :-
    dif(X-Y, 1-2),
    X = Y,
    Y = 1.
```

In `allowed_pair/2` the constraint comes first and is checked again after
each binding. In `specialization/2`, `X = Y` already makes `X-Y` impossible to
unify with `1-2`, so the constraint is **discharged** before `Y = 1`.

---

# The answer

```sh
eyeprolog examples/dif-constraints.pl
```

```text
allowed_pair(left, right).
specialization(1, 1).
```

With `\+ X = Y` in place of `dif(X, Y)`, the first rule would fail at once:
two unbound variables always unify.

---

# The reason

```sh
eyeprolog --proof examples/dif-constraints.pl
```

```text
step(allowed_pair(left, right),
     rule(1),
     ['X' = left, 'Y' = right],
     [dif(left, right), left = left, right = right]).
step(dif(left, right), builtin, [], []).
```

The proof records each goal with its final bindings: `dif(left, right)` is a
built-in step, and so are the two unifications.

---

# The check

```sh
eyeprolog --proof examples/dif-constraints.pl > dif-constraints.why.pl
eyeprolog --check-proof dif-constraints.why.pl examples/dif-constraints.pl
```

```text
condition('C1', resolution, ok, 2).
condition('C5', re_decision, ok, 5).
condition('C7', relevance, ok, 9).
verdict(checked).
```

The 2 rule steps replay against their clauses, and the 5 built-in steps are
**re-decided**: the checker runs `dif(left, right)`, `1 = 1` and the others
again, independently, and they agree. Nothing is taken on trust.

---

# Try it

- Change `Y = right` to `Y = left` in `allowed_pair/2`. What happens to the
  answer?
- Replace `dif(X, Y)` with `X \= Y` and run again. Why is the result
  different?
- At the interactive top level, ask `?- dif(X, a).` and look at the residual
  constraint in the answer.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 39 (specialized library notes on `dif/2`).
