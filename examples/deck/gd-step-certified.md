# Certified gradient-descent bounds

## What can interval arithmetic certify about ten gradient-descent steps?

Gradient descent on `(x − 1)²` is run not on one number but on an interval of
possible starting points. Every bound is a ground fact with a proof, so the run
is certified, and the certificate shows the guaranteed interval shrinking
toward the minimum.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=gd-step-certified) ·
[Source](../gd-step-certified.pl)

---

# The question

Minimize `f(x) = (x − 1)²` with step size `η = 0.2`, starting from anywhere in
the interval `[0, 2]`. After each step, which interval is the current point
guaranteed to lie in, and does that interval shrink?

Instead of trusting floating-point output, each step is derived from the
previous one by explicit rules, so a proof can show why each bound holds.

---

# The model

```prolog
max_k(10).
target(1.0).
eta(Eta) :- (Eta is 1.0 / 5).
x_bounds(0, 0.0, 2.0).
```

The gradient of `(x − 1)²` is `2(x − 1)`. Its bounds at step `K` follow from
the bounds on `x`:

```prolog
g_bounds(K, Gl, Gu) :-
  target(A),
  x_bounds(K, L, U),
  (Dl is L - A),
  (Du is U - A),
  (Gl is 2 * Dl),
  (Gu is 2 * Du).
```

---

# The update rule

```prolog
x_bounds(K1, L1, U1) :-
  previous(K1, K),
  x_bounds(K, L, U),
  eta_le_half(true),
  target(A),
  eta(Eta),
  (Dl is L - A),
  (Du is U - A),
  (L1 is L - Eta * 2 * Dl),
  (U1 is U - Eta * 2 * Du).
```

The update `x' = x − 2η(x − 1)` is applied to each endpoint on its own. That is
sound only because, for `η ≤ 1/2`, the update is increasing in `x`: a larger
starting point always lands at a larger next point, so the image of `[L, U]`
is exactly `[L1, U1]`. The rule checks `eta_le_half(true)` before using it.

---

# The answer

```sh
eyeprolog examples/gd-step-certified.pl
```

```text
xBounds(result, bounds(0, 0.0, 2.0)).
xBounds(result, bounds(1, 0.4, 1.6)).
xBounds(result, bounds(2, 0.64, 1.36)).
xBounds(result, bounds(3, 0.784, 1.216)).
```

```text
width(0, 2.0).
width(1, 1.2000000000000002).
width(2, 0.7200000000000001).
...
width(10, 0.012093235200000052).
```

The midpoint stays at `1.0`, the true minimum, and the certified interval
shrinks by the factor `1 − 2η = 0.6` per step, from width 2 to about 0.012
after ten steps. `widthContractsAt/2` holds at every step from 1 to 10, and the
run prints 89 facts in all.

---

# Why not subtract the step interval?

A naive interval update computes the interval of possible steps, `η·f'(x)` over
`[L, U]`, and subtracts it from `[L, U]`. That treats the `x` in the update and
the `x` inside the gradient as two independent unknowns, so the worst cases add
up and the width *grows* by `1 + 2η` per step: from 2 to about 58 after ten
steps. This is the classic *dependency problem* of interval arithmetic.

Updating each endpoint with itself avoids it, and the monotonicity condition
`η ≤ 1/2` is what makes that sound. The step bounds are still reported, as
`stepBounds/2`, but only as information.

---

# The reason

```sh
eyeprolog --proof examples/gd-step-certified.pl
```

```text
step(stepBounds(result, step(0, -0.4, 0.4)),
     rule(50),
     ['K' = 0, 'Pl' = -0.4, 'Pu' = 0.4],
     [index(0), p_bounds(0, -0.4, 0.4)]).
```

```text
step(width_contracts_at(1, true),
     rule(34),
     ['K1' = 1, 'K' = 0, 'W' = 2.0, 'W1' = 1.2000000000000002],
     [eta_le_half(true),
```

The first step's bounds `[-0.4, 0.4]` come from rule 50 applied to
`p_bounds/3`. The contraction at step 1 rests on `eta_le_half(true)` and the
two widths, 2.0 and about 1.2. The step for `x_bounds(1, 0.4, 1.6)` uses the
update rule with `'Eta' = 0.2`, resting on `x_bounds(0, 0.0, 2.0)`, so every
bound traces back to the starting interval.

---

# The check

```text
condition('C1', resolution, ok, 211).
condition('C5', re_decision, ok, 187).
steps(398).
verified(211).
recomputed(187).
trusted(0).
claims(89).
verdict(checked).
```

211 steps were replayed against program clauses, and 187 arithmetic steps were
recomputed independently by the checker. Nothing is trusted: every number in
the certificate is re-derived.

---

# Try it

- Change `eta` to `1.0 / 2`. The width drops to `0.0` after one step: for a
  quadratic, that step size jumps straight to the minimum.
- Change `eta` to `3.0 / 5`. Only `x_bounds(0, …)` remains, because
  `eta_le_half` fails and the update rule refuses to run. Why would updating
  the endpoints separately be wrong once the update is decreasing in `x`?
- Replace the update rule with the naive one, `L1 is L - Pu` and
  `U1 is U - Pl` from `p_bounds/3`, and watch the width grow instead.
- Add `:- table x_bounds/3.` and compare `--stats` before and after.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 29.
