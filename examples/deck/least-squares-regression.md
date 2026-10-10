# Least-squares regression

## Which straight line best fits these points, and is the fit good enough?

**Linear regression** finds the line y = a + bx that minimizes the sum of
squared vertical distances to a set of points. This example computes the
slope, the intercept and R², the share of variation the line explains, and
accepts the fit only if R² clears a threshold.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=least-squares-regression) ·
[Source](../least-squares-regression.pl)

---

# The question

Four measurements lie roughly along a line. What are its slope and intercept,
how much does it explain, and does that meet the minimum of 0.60?

---

# The data

```prolog
dataset(regression1, [point(1.0, 2.0), point(2.0, 3.0), point(3.0, 5.0), point(4.0, 4.0)]).
threshold(regression1, minimum_r_squared, 0.60).
```

The points and the acceptance policy are separate facts, so either can change
without touching the formulas.

---

# Sufficient statistics

```prolog
stats([], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0).
stats([point(X, Y)|Rest], N, Sumx, Sumy, Sumxx, Sumxy, Sumyy) :-
  stats(Rest, N0, Sumx0, Sumy0, Sumxx0, Sumxy0, Sumyy0),
  (N is N0 + 1.0),
  (Sumx is Sumx0 + X),
  (Sumy is Sumy0 + Y),
  (Xx is X * X),
  (Sumxx is Sumxx0 + Xx),
  (Xy is X * Y),
  (Sumxy is Sumxy0 + Xy),
  (Yy is Y * Y),
  (Sumyy is Sumyy0 + Yy).
```

The whole fit depends on six numbers: the count and the sums of x, y, x², xy
and y². A recursive pass over the list folds the points into them.

---

# The formulas

```prolog
slope(Data, Slope) :-
  sufficient_statistics(Data, N, Sumx, Sumy, Sumxx, Sumxy, _sumyy),
  (Nsumxy is N * Sumxy),
  (Sumxsumy is Sumx * Sumy),
  (Numerator is Nsumxy - Sumxsumy),
  (Nsumxx is N * Sumxx),
  (Sumxsquared is Sumx * Sumx),
  (Denominator is Nsumxx - Sumxsquared),
  (Slope is Numerator / Denominator).

accepted_fit(Data) :-
  r_squared(Data, R2),
  threshold(Data, minimum_r_squared, Minimum),
  (R2 >= Minimum).
```

The slope is (nΣxy − ΣxΣy) / (nΣx² − (Σx)²). Each partial product gets a name,
so it shows up in the proof.

---

# The answer

```sh
eyeprolog examples/least-squares-regression.pl
```

```text
slope(regression1, 0.8).
intercept(regression1, 1.5).
rSquared(regression1, 0.64).
status(regression1, accepted_linear_fit).
reason(regression1, "R squared meets the minimum explanatory-power threshold").
```

The best line is y = 1.5 + 0.8x. It explains 64% of the variation, just above
the 60% threshold, so the fit is accepted.

---

# The reason

```sh
eyeprolog --proof examples/least-squares-regression.pl
```

```text
     [sufficient_statistics(regression1, 4.0, 10.0, 14.0, 30.0, 39.0, 54.0),
      156.0 is 4.0 * 39.0,
      140.0 is 10.0 * 14.0,
      16.0 is 156.0 - 140.0,
      120.0 is 4.0 * 30.0,
      100.0 is 10.0 * 10.0,
      20.0 is 120.0 - 100.0,
      0.8 is 16.0 / 20.0]).
```

These are the premises of the slope step: n = 4, Σx = 10, Σy = 14, Σx² = 30,
Σxy = 39, then 16 / 20 = 0.8. It reads like the hand calculation.

---

# The check

```text
condition('C1', resolution, ok, 15).
condition('C5', re_decision, ok, 46).
verdict(checked).
```

All 15 rule and fact steps replay against the program, and all 46 arithmetic
steps are recomputed independently and agree. The verdict holds under
floating-point arithmetic. Whether a straight line is the right model for the
data is a question the proof cannot answer.

---

# Try it

- Add an outlier, `point(5.0, 1.0)`. The slope turns to −0.1, R² drops to
  0.01, and the fit is no longer accepted.
- Raise the threshold to 0.70 and confirm that the current fit is rejected.
- Add a `residual(Data, X, R)` relation that reports each point's distance from
  the fitted line.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 29.
