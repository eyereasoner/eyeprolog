# Symbolic derivatives

## Can calculus rules be written as clauses?

Differentiation is a set of rewrite rules: the derivative of a sum is the sum
of the derivatives, the product rule, the chain rule. Written as Prolog
clauses over expression terms, those rules compute derivatives symbolically,
and the proof shows which rule produced each part of the result.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=symbolic-derivative) ·
[Source](../symbolic-derivative.pl)

---

# The question

Given a formula in `x`, what is its derivative with respect to `x`?

A computer algebra system answers this by walking the formula's structure.
So does this example: an expression is an ordinary term such as
`mul(var(x), var(x))`, and each differentiation rule handles one kind of node.

---

# The expressions

```prolog
expr(square, mul(var(x), var(x))).
expr(linear_plus_const, add(var(x), const(3))).
expr(nested_log, log(log(var(x)))).
```

Expressions use explicit constructors (`add/2`, `mul/2`, `pow/2`, `log/1`)
instead of Prolog's arithmetic operators, so the data can never be mistaken for
a computation.

---

# The rules

```prolog
d(const(_c), _x, const(0)).
d(var(X), X, const(1)).
d(add(U, V), X, add(Du, Dv)) :-
  d(U, X, Du),
  d(V, X, Dv).
d(mul(U, V), X, add(mul(Du, V), mul(U, Dv))) :-
  d(U, X, Du),
  d(V, X, Dv).
d(log(U), X, divide(Du, U)) :-
  d(U, X, Du).
```

Each clause is one textbook rule: constants differentiate to 0, `x` to 1, sums
term by term, products by the product rule, and `log(U)` to `U'/U`, which is
the chain rule at work. Recursion follows the structure of the expression.

---

# The answer

```sh
eyeprolog examples/symbolic-derivative.pl
```

```text
derivative_result(square, add(mul(const(1), var(x)), mul(var(x), const(1)))).
derivative_result(linear_plus_const, add(const(1), const(0))).
derivative_result(nested_log, divide(divide(const(1), var(x)), log(var(x)))).
```

These are three of the four answers; the fourth is a long product. The results
are deliberately unsimplified: `1·x + x·1` is `2x`, but leaving it alone keeps
every rule application visible.

---

# The reason

```text
step(d(mul(var(x), var(x)), x, add(mul(const(1), var(x)), mul(var(x), const(1)))),
     rule(10),
     ['U' = var(x), 'V' = var(x), 'X' = x, 'Du' = const(1), 'Dv' = const(1)],
     [d(var(x), x, const(1)), d(var(x), x, const(1))]).
step(d(var(x), x, const(1)), fact(6), ['X' = x], []).
```

The derivative of `x · x` comes from the product rule (clause 10) with both
factors equal to `x`; each factor's derivative is 1 by the fact for `var(X)`.

---

# The check

```text
condition('C1', resolution, ok, 23).
condition('C5', re_decision, ok, 2).
condition('C7', relevance, ok, 29).
verdict(checked).
```

The checker replays 23 rule and fact steps and recomputes 2 built-in steps
(the two `is/2` subtractions made by the power rule) on its own. Nothing is taken on trust.

---

# Try it

- Add `expr(cube, pow(var(x), 3)).` and predict the result before running.
- Write a `simplify/2` relation that turns `mul(const(1), E)` into `E` and
  `add(E, const(0))` into `E`, and apply it to each derivative.
- Add a rule for `exp/1` and differentiate `exp(mul(const(2), var(x)))`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 22.
