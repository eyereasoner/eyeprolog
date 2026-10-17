# A partial evaluator

## What is left of a program when some of its inputs are already known?

A partial evaluator runs the parts of a program whose inputs are known and
leaves the rest as smaller "residual" code. This example specializes a tiny
expression language: known variables are substituted, constant arithmetic is
folded, and branches with a known condition are chosen in advance.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=partial-evaluator) ·
[Source](../partial-evaluator.pl)

---

# The question

Suppose `x` is known to be 10 but `y` will only arrive at run time. Then
`x * y + (x + 3)` can already be simplified to `10 * y + 13`. A conditional
whose test is known can lose its other branch entirely.

Partial evaluation is the idea behind specializing interpreters into compilers.
Here it is shown at the smallest useful scale.

---

# Programs and static inputs

```prolog
program(poly_y,
  add(mul(var(x), var(y)), add(var(x), const(3))),
  [bind(x, const(10))]).
program(static_branch,
  if(bool(true), add(var(x), const(1)), mul(var(y), const(999))),
  [bind(x, const(10))]).
program(dynamic_branch,
  if(var(flag), add(var(x), const(1)), mul(var(y), const(2))),
  [bind(x, const(10))]).
```

Expressions are ordinary terms. The environment lists the variables whose
values are known; everything else is dynamic.

---

# The specializer

```prolog
pe(Env, var(Name), Value) :- known_var(Env, Name, Value).
pe(Env, var(Name), var(Name)) :- unknown_var(Env, Name).

pe(Env, add(Left, Right), const(Sum)) :-
  pe(Env, Left, const(A)),
  pe(Env, Right, const(B)),
  (Sum is A + B).

pe(Env, add(Left, Right), add(Left_residual, Right_residual)) :-
  pe(Env, Left, Left_residual),
  pe(Env, Right, Right_residual),
  \+ ((Left_residual = const(_A)), (Right_residual = const(_B))).
```

`pe(Env, Expr, Residual)` relates an expression to its specialized form. Fold
when both operands became constants; otherwise keep the operation as residual
code. The negated test makes the two cases exclusive, so each expression has
exactly one residual.

---

# The answer

```sh
eyeprolog examples/partial-evaluator.pl
```

```text
partialEvalAnswer(residual(poly_y), add(mul(const(10), var(y)), const(13))).
partialEvalAnswer(residual(static_branch), const(11)).
partialEvalAnswer(residual(dynamic_branch), if(var(flag), const(11), mul(var(y), const(2)))).
partialEvalAnswer(note, "static inputs are folded while dynamic variables remain as residual code").
```

`poly_y` becomes `10 * y + 13`. The static branch collapses to the constant
11, and the unused `999` branch disappears. The dynamic branch keeps its
conditional, but each branch is specialized.

---

# The reason

```text
step(pe([bind(x, const(10))], add(var(x), const(3)), const(13)),
     rule(12),
     ['Env' = [bind(x, const(10))],
      'Left' = var(x),
      'Right' = const(3),
      'Sum' = 13,
      'A' = 10,
      'B' = 3],
     [pe([bind(x, const(10))], var(x), const(10)),
      pe([bind(x, const(10))], const(3), const(3)),
      13 is 10 + 3]).
step(\+ known_var([bind(x, const(10))], y, __anon3), absent, [], []).
```

`x + 3` folds to 13 because `x` specializes to 10, the constant 3 stays 3, and
`13 is 10 + 3`. The second step records why `y` stays residual: it is **not** a
known variable. That is a negation, recorded as an `absent` step.

---

# The check

```text
condition('C1', resolution, ok, 28).
condition('C6', boundary_consistency, ok, 2).
obligation(absent, theory_scoped, \+ known_var([bind(x, const(10))], y, A)).
trusted(5).
claims(4).
verdict(checked_with_obligations).
```

28 steps replay against the program, and the checker decides two ground
negations again itself. Five negations remain: each says that some goal has
*no* proof, for any value of its open variables. They are listed as
obligations. The checker still tested two of them against the evidence it had
and found none contradicted (C6), so the verdict is valid given those
obligations.

---

# Try it

- Add `bind(y, const(2))` to the `poly_y` environment and predict the residual.
  It should fold all the way to a constant.
- Bind `flag` to `bool(false)` in `dynamic_branch` and check which branch
  survives.
- Add `sub/2` to the language with its own folding and residual clauses.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 23.
