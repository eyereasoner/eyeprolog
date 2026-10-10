# A review quorum

## Which two reviewers satisfy every rule?

Choose exactly two reviewers from four people, under two side conditions.
Boolean constraints state the rules directly, and the solver both lists the
admissible teams and counts them without listing.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=clpb-cardinality) ·
[Source](../clpb-cardinality.pl)

---

# The question

The candidates are Alice, Bob, Carol and Dan. The rules:

- exactly two of them review;
- Alice only takes part if Carol does too;
- exactly one of Bob and Dan takes part.

Which selections are possible, and how many are there?

---

# The constraints

```prolog
review_constraints(Alice, Bob, Carol, Dan) :-
  sat(card([2], [Alice, Bob, Carol, Dan]) *
      (Alice =< Carol) *
      (Bob # Dan)).
```

Each person is a Boolean variable, 1 for "reviews". `card([2], List)` says
exactly two of the list are true. On Booleans, `Alice =< Carol` reads "if
Alice then Carol", and `Bob # Dan` is exclusive or. `*` joins the three rules
with AND.

---

# Listing and counting

```prolog
review_quorum(selection(
    alice(Alice), bob(Bob), carol(Carol), dan(Dan))) :-
  review_constraints(Alice, Bob, Carol, Dan),
  labeling([Alice, Bob, Carol, Dan]).

review_quorum_count(Count) :-
  sat_count(card([2], [Alice, Bob, Carol, Dan]) *
            (Alice =< Carol) *
            (Bob # Dan), Count).
```

`labeling/1` enumerates satisfying assignments. `sat_count/2` counts them
directly from the solver's internal representation, without enumerating.

---

# The answer

```sh
eyeprolog examples/clpb-cardinality.pl
```

```text
review_quorum(selection(alice(0), bob(0), carol(1), dan(1))).
review_quorum(selection(alice(0), bob(1), carol(1), dan(0))).
review_quorum_count(2).
```

Two teams: Carol with Dan, or Carol with Bob. Alice never makes it: with
Carol she would need one of Bob or Dan as well, which would make three.

---

# The reason

```sh
eyeprolog --proof examples/clpb-cardinality.pl
```

```text
step(review_quorum_count(2),
     rule(3),
     ['Count' = 2],
     [sat_count(card([2], [Alice, Bob, Carol, Dan]) * (Alice =< Carol) * (Bob # Dan), 2)]).
step(sat_count(card([2], [Alice, Bob, Carol, Dan]) * (Alice =< Carol) * (Bob # Dan), 2),
     builtin,
     [],
     []).
```

The count holds by rule 3, and the number itself comes from the constraint
solver, recorded as a `builtin` step.

---

# The check

```text
condition('C1', resolution, ok, 5).
condition('C5', re_decision, ok, 2).
obligation(builtin, stateful, sat(card([2], [0, 0, 1, 1]) * (0 =< 1) * (0 # 1))).
obligation(builtin, stateful, sat_count(card([2], [A, B, C, D]) * (A =< C) * (B # D), 2)).
verdict(checked_with_obligations).
```

The rule steps replay. The solver calls are listed as **obligations** (three
in all): they depend on constraint-solver state, so the checker records them as
what the proof rests on instead of recomputing them.

---

# Try it

- Change the quorum to `card([3], …)` in both places. Alice is now in both
  teams, and the count is still `2`.
- Drop `(Bob # Dan)` and predict how many teams the count reports.
- Use `card([2,3], …)` to allow two or three reviewers, and list the teams.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 39 (`library(clpb)`) and Chapter 24.
