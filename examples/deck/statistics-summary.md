# Statistics summary

## What are the mean, variance, and standard deviation of a small sample?

Descriptive statistics are usually a single library call. Here they are a
few recursive rules, so each number in the result comes with a derivation you
can read: the sum, the mean, every squared deviation, and the final square
root.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=statistics-summary) ·
[Source](../statistics-summary.pl)

---

# The question

For the textbook sample `2, 4, 4, 4, 5, 5, 7, 9`, compute:

- the **count** of values;
- the **mean**, the sum divided by the count;
- the **population variance**, the average squared distance from the mean;
- the **population standard deviation**, the square root of the variance.

The expected answers are 8, 5, 4, and 2, which makes the sample a favorite
for checking statistics code.

---

# The data and the folds

```prolog
sample(scores, [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0]).

sum([], 0.0).
sum([X|Xs], Total) :-
  sum(Xs, Rest),
  (Total is X + Rest).

squared_error_sum([], _mean, 0.0).
squared_error_sum([X|Xs], Mean, Total) :-
  (Delta is X - Mean),
  (Squared is Delta ** 2.0),
  squared_error_sum(Xs, Mean, Rest),
  (Total is Squared + Rest).
```

Both are **folds**: walk the list, combine each element with the result for
the rest.

---

# The statistics

```prolog
population_variance(Name, Variance) :-
  sample(Name, Values),
  mean(Name, Mean),
  squared_error_sum(Values, Mean, Sumsquarederrors),
  length(Values, Count),
  (Variance is Sumsquarederrors / Count).

population_stddev(Name, Stddev) :-
  population_variance(Name, Variance),
  (Stddev is Variance ** 0.5).
```

"Population" means dividing by `n`, not `n − 1`: the sample is treated as the
whole population.

---

# The answer

```sh
eyeprolog examples/statistics-summary.pl
```

```text
mean(scores, 5.0).
count(scores, 8).
populationVariance(scores, 4.0).
populationStddev(scores, 2.0).
```

The four expected values, computed in floating point.

---

# The reason

```sh
eyeprolog --proof examples/statistics-summary.pl
```

```text
step(population_variance(scores, 4.0),
     rule(7),
     ['Name' = scores,
      'Variance' = 4.0,
      'Values' = [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0],
      'Mean' = 5.0,
      'Sumsquarederrors' = 32.0,
      'Count' = 8],
     [sample(scores, [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0]),
      mean(scores, 5.0),
      squared_error_sum([2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0], 5.0, 32.0),
      length([2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0], 8),
      4.0 is 32.0 / 8]).
```

The variance is 4 because the squared deviations add up to 32 and there are 8
values. Each intermediate result has its own step further down the proof.

---

# The check

```text
condition('C1', resolution, ok, 25).
condition('C5', re_decision, ok, 29).
steps(54).
verified(25).
recomputed(29).
trusted(0).
verdict(checked).
```

The checker replays the 25 rule steps and independently recomputes the 29
arithmetic steps, from each `is/2` addition to the final `** 0.5`. Nothing
is trusted.

---

# Try it

- Add a ninth value `5.0` to the sample. The mean stays 5.0; predict whether
  the variance goes up or down. (It drops to about 3.56.)
- Add `sample_variance/2`, which divides by `Count - 1`, and compare it with
  the population variance.
- Replace the floats with integers such as `2` and `4`. Which results stay
  integers, and which become floats?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 6 (arithmetic) and 29 (numerical models).
