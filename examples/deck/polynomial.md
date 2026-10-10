# Polynomial roots

## Which complex integers are roots of these quartic polynomials?

Two degree-4 polynomials, one with real roots and one with complex roots, are
evaluated at every point of a small grid of complex integers. EyeProlog keeps
the points where the polynomial vanishes, then multiplies the roots back
together to confirm they rebuild the original coefficients.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=polynomial) ·
[Source](../polynomial.pl)

---

# The question

A **quartic** is a polynomial of degree 4, so it has four roots counted with
multiplicity. Finding them in general takes numerical methods, but if we
suspect they are small **Gaussian integers** (complex numbers `a + bi` with
integer parts), we can simply search: evaluate the polynomial at each
candidate and keep the zeros. A second, independent computation then checks
the result by expanding `(x − r₁)(x − r₂)(x − r₃)(x − r₄)`.

---

# The model

```prolog
polynomial(real_quartic, [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]).
polynomial(complex_quartic, [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]).

real_domain(complex_quartic, 0, 5).
imag_domain(complex_quartic, 0, 2).
```

A complex number is a pair `[Real, Imaginary]`, and a polynomial is its list
of coefficients from the highest power down. The real quartic is
`x⁴ − 10x³ + 35x² − 50x + 24`. The domain facts bound the search grid.

---

# The rules

```prolog
poly_eval([Coeff|Rest], X, Value) :-
  poly_eval_acc(Rest, X, Coeff, Value).

poly_eval_acc([], _x, Acc, Acc).
poly_eval_acc([Coeff|Rest], X, Acc, Value) :-
  c_mul(Acc, X, Product),
  c_add(Product, Coeff, Next),
  poly_eval_acc(Rest, X, Next, Value).

root(Case, Root) :-
  polynomial(Case, Coeffs),
  candidate(Case, Root),
  poly_eval(Coeffs, Root, Value),
  c_zero(Value).
```

`poly_eval/3` is **Horner's rule**: multiply the running value by `x` and add
the next coefficient. `root/2` is generate-and-test: every grid point is a
candidate, and only exact zeros survive.

---

# The answer

```sh
eyeprolog examples/polynomial.pl
```

```text
root(real_quartic, [1, 0]).
root(real_quartic, [2, 0]).
root(real_quartic, [3, 0]).
root(real_quartic, [4, 0]).
root(complex_quartic, [0, 1]).
root(complex_quartic, [1, 1]).
root(complex_quartic, [3, 2]).
root(complex_quartic, [5, 1]).
reconstructedPolynomial(real_quartic, [[1, 0], [-10, 0], [35, 0], [-50, 0], [24, 0]]).
reconstructedPolynomial(complex_quartic, [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]).
reconstructionMatches(real_quartic, true).
reconstructionMatches(complex_quartic, true).
allRootsVerified(real_quartic, true).
allRootsVerified(complex_quartic, true).
```

The real quartic has roots 1, 2, 3, 4; the complex one has `i`, `1 + i`,
`3 + 2i`, and `5 + i`. Expanding the four linear factors gives back exactly
the stated coefficients, so the search found all four roots of each.

---

# The reason

```sh
eyeprolog --proof examples/polynomial.pl
```

```text
step(root(complex_quartic, [3, 2]),
     rule(20),
     ['Case' = complex_quartic,
      'Root' = [3, 2],
      'Coeffs' = [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]],
      'Value' = [0, 0]],
     [polynomial(complex_quartic, [[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]]),
      candidate(complex_quartic, [3, 2]),
      poly_eval([[1, 0], [-9, -5], [14, 33], [24, -44], [-26, 0]], [3, 2], [0, 0]),
      c_zero([0, 0])]).
```

`3 + 2i` is a root because it lies in the grid and Horner evaluation at that
point gives exactly `[0, 0]`. The `poly_eval` use has its own steps, one per
Horner iteration, down to the individual multiplications.

---

# The check

```text
condition('C1', resolution, ok, 273).
condition('C5', re_decision, ok, 241).
condition('C7', relevance, ok, 528).
steps(514).
verified(273).
recomputed(241).
trusted(0).
verdict(checked).
```

The proof has 514 steps. The checker replays the 273 clause steps and
recomputes the 241 arithmetic steps (`is/2`, comparisons, `between/3`)
independently, so every complex multiplication in the argument is redone.
Nothing is taken on trust.

---

# Try it

- Widen `imag_domain(complex_quartic, 0, 2)` to `-2, 2`. Do any new roots
  appear, and why can't there be more than four?
- Add a third case, the polynomial `x² + 1` as `[[1, 0], [0, 0], [1, 0]]`,
  with a grid that includes `i` and `−i`.
- Change one coefficient of `complex_quartic` by 1. How many roots survive,
  and what does `reconstructionMatches/2` report?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 26 (witnesses) and 28 (representation).
