# Newton–Raphson root finding

## Where does a function cross zero?

Newton's method guesses a root, follows the tangent line to a better guess,
and repeats until the function value is tiny. This example finds √2, *e*, and
π as roots of three functions, and the proof records every iteration.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=newton-raphson) ·
[Source](../newton-raphson.pl)

---

# The question

For a function *f* with derivative *f′*, the update

*x* := *x* − *f*(*x*) / *f′*(*x*)

usually converges fast to a nearby root. Starting from a given point, where
does it end up for x² − 2, ln(x) − 1, and sin(x)?

---

# The functions

```prolog
want_root([1, 1.0, 1.0e-15]).
want_root([2, 2.0, 1.0e-15]).
want_root([3, 3.0, 1.0e-15]).

f(1, X, Y) :-
  (Xx is X * X),
  (Y is Xx - 2).
f(2, X, Y) :-
  (Lx is log(X)),
  (Y is Lx - 1).
f(3, X, Y) :-
  (Y is sin(X)).

fd(1, X, Y) :-
  (Y is 2 * X).
fd(2, X, Y) :-
  (Y is 1 / X).
fd(3, X, Y) :-
  (Y is cos(X)).
```

Each case names a function, a starting point, and a tolerance of 10⁻¹⁵.

---

# The rules

```prolog
find_root([N, X, Tolerance], X) :-
  f(N, X, Fx),
  (Afx is abs(Fx)),
  (Afx < Tolerance).
find_root([N, X, Tolerance], Root) :-
  f(N, X, Fx),
  (Afx is abs(Fx)),
  (Afx >= Tolerance),
  fd(N, X, Fdx),
  (Step is Fx / Fdx),
  (Newx is X - Step),
  find_root([N, Newx, Tolerance], Root).
```

Stop when |f(x)| is below the tolerance; otherwise take one Newton step and
recurse.

---

# The answer

```sh
eyeprolog examples/newton-raphson.pl
```

```text
findRoot([1, 1.0, 1.0e-15], 1.4142135623730951).
findRoot([2, 2.0, 1.0e-15], 2.718281828459045).
findRoot([3, 3.0, 1.0e-15], 3.141592653589793).
```

√2, *e*, and π, each to full double precision.

---

# The reason

```text
step(find_root([1, 1.0, 1.0e-15], 1.4142135623730951),
     rule(12),
     ['N' = 1,
      'X' = 1.0,
      'Tolerance' = 1.0e-15,
      'Root' = 1.4142135623730951,
      'Fx' = -1.0,
      'Afx' = 1.0,
      'Fdx' = 2.0,
      'Step' = -0.5,
      'Newx' = 1.5],
     [f(1, 1.0, -1.0),
      1.0 is abs(-1.0),
      1.0 >= 1.0e-15,
      fd(1, 1.0, 2.0),
      -0.5 is -1.0 / 2.0,
      1.5 is 1.0 - -0.5,
      find_root([1, 1.5, 1.0e-15], 1.4142135623730951)]).
```

The first iteration for √2: at x = 1, f(x) = −1 and f′(x) = 2, so the next
guess is 1.5. The proof has one `find_root/2` step per guess, the last one
being the stopping test: 6 for √2, 6 for *e*, and 4 for π.

---

# The check

```text
condition('C1', resolution, ok, 51).
condition('C5', re_decision, ok, 99).
steps(150).
verified(51).
recomputed(99).
trusted(0).
verdict(checked).
```

The checker recomputes all 99 floating-point evaluations and comparisons and
gets the same values. What it certifies is the computation, under IEEE
double-precision arithmetic, not that the result is the exact real root.

---

# Try it

- Start √2 from `0.0`. What goes wrong, and which guard would prevent it?
- Add `f(4, X, Y)` for x³ − x − 2 with its derivative, and find its real root.
- Loosen the tolerance to `1.0e-6` and count how many iterations disappear
  from the proof.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 29.
