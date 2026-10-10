# Radioactive decay

## How much activity is left after 16 hours?

An iodine sample starts at 80 becquerel and has a half-life of 8 hours. The
program works out how many half-lives have passed, how much activity remains,
and whether the sample has dropped below a safety threshold.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=radioactive-decay) ·
[Source](../radioactive-decay.pl)

---

# The question

How active is the sample now, and is it low enough to handle as low-activity?

Activity halves once per **half-life**: after t hours it is
initial × 0.5^(t / half-life). Activity is measured in **becquerel (Bq)**,
radioactive decays per second.

---

# The facts

```prolog
sample(iodine_sample, initial_activity_bq, 80.0).
sample(iodine_sample, half_life_h, 8.0).
sample(iodine_sample, elapsed_h, 16.0).
threshold(iodine_sample, low_activity_bq, 25.0).
```

Measurements and the policy threshold are separate facts, so either can change
without touching the physics.

---

# The rules

```prolog
half_lives(Sample, Count) :-
  sample(Sample, elapsed_h, Elapsed),
  sample(Sample, half_life_h, Halflife),
  (Count is Elapsed / Halflife).

remaining_fraction(Sample, Fraction) :-
  half_lives(Sample, Count),
  (Fraction is 0.5 ** Count).

low_activity(Sample) :-
  remaining_activity(Sample, Remaining),
  threshold(Sample, low_activity_bq, Limit),
  (Remaining < Limit).
```

The formula is built from named steps (half-lives, remaining fraction,
remaining activity) and the threshold test sits in its own rule.

---

# The answer

```sh
eyeprolog examples/radioactive-decay.pl
```

```text
halfLivesElapsed(iodine_sample, 2.0).
remainingActivity_Bq(iodine_sample, 20.0).
decayedActivity_Bq(iodine_sample, 60.0).
status(iodine_sample, low_activity).
reason(iodine_sample, "two half-lives leave one quarter of the initial activity").
```

Two half-lives leave a quarter: 20 Bq remain, below the 25 Bq threshold.

---

# The reason

```text
step(remaining_activity(iodine_sample, 20.0),
     rule(7),
     ['Sample' = iodine_sample, 'Remaining' = 20.0, 'Initial' = 80.0, 'Fraction' = 0.25],
     [sample(iodine_sample, initial_activity_bq, 80.0),
      remaining_fraction(iodine_sample, 0.25),
      20.0 is 80.0 * 0.25]).
step(remaining_fraction(iodine_sample, 0.25),
     rule(6),
     ['Sample' = iodine_sample, 'Fraction' = 0.25, 'Count' = 2.0],
     [half_lives(iodine_sample, 2.0), 0.25 is 0.5 ** 2.0]).
```

20 Bq is 80 Bq times a remaining fraction of 0.25, and 0.25 is 0.5 to the
power of two half-lives. The calculation is visible at every step.

---

# The check

```text
condition('C1', resolution, ok, 14).
condition('C5', re_decision, ok, 5).
condition('C7', relevance, ok, 24).
trusted(0).
verdict(checked).
```

14 steps replay against their clauses and the 5 arithmetic steps are
recomputed by the checker.

---

# Try it

- Change the elapsed time to 8.0 hours. One half-life leaves 40 Bq, and no
  `status/2` answer appears, because 40 is not below 25.
- Notice that the `reason/2` text always says "two half-lives". Rewrite it so
  the explanation is computed from the actual count.
- Add a second isotope with a different half-life and predict its status.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 14.
