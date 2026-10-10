# Dining philosophers

## Who eats when, and with which forks?

Five philosophers share five forks around a table; each needs both neighbouring
forks to eat. The Chandy–Misra solution passes forks on request and marks them
clean or dirty so that nobody starves. This example derives, from a recorded
trace, every request, every fork hand-over, and every meal.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=dining-philosophers) ·
[Source](../dining-philosophers.pl)

---

# The question

Given who is hungry in each step of a trace and who holds which fork, which
fork requests are sent, which forks change hands, and which philosopher eats
in which slot using which forks?

The example does not search for a schedule. It reasons over a fixed trace and
derives what the protocol says must happen in it.

---

# The table and the trace

```prolog
left_fork(dp_P3, dp_F23). right_fork(dp_P3, dp_F34).

slot(dp_C0, dp_s1, 1). after_sends(dp_C0, dp_C1). after_eat(dp_C1, dp_C2).

hungry(dp_C0, dp_P1). hungry(dp_C0, dp_P3).

start_state(dp_C0, dp_F23, dp_P2, dp_Dirty).
```

Philosopher P3 sits between forks F23 and F34. In configuration C0, P1 and P3
are hungry, and fork F23 starts with P2, dirty.

---

# The rules

```prolog
request(C, P, Q, F) :-
  hungry(C, P), left_fork(P, F), start_state(C, F, Q, _cleanliness), (Q \= P).

send_fork(C, Q, P, F) :-
  request(C, P, Q, F), start_state(C, F, Q, dp_Dirty).

meal(M, P, N, S) :-
  after_sends(C, Cs), slot(C, S, N), hungry(C, P), meal_handle(P, N, M),
  left_fork(P, Lf), right_fork(P, Rf),
  after_send_state(Cs, Lf, P, _leftcleanliness),
  after_send_state(Cs, Rf, P, _rightcleanliness).
```

A hungry philosopher requests a fork someone else holds. The holder sends it
if the fork is **dirty**, meaning it has been used since it was received. A
meal happens when, after the sends, the philosopher holds both forks.

---

# The answer

```sh
eyeprolog examples/dining-philosophers.pl
```

```text
dp_type(dp_mP3_1, dp_Meal).
dp_philosopher(dp_mP3_1, dp_P3).
dp_mealNo(dp_mP3_1, 1).
dp_inSlot(dp_mP3_1, dp_s1).
dp_usesFork(dp_mP3_1, dp_F23).
dp_usesFork(dp_mP3_1, dp_F34).
```

P3's first meal is in slot s1, with forks F23 and F34. The full output has 350
answers: 26 requests, 26 fork sends, and 15 meals (three for each philosopher),
each described by several facts.

---

# The reason

```sh
eyeprolog --proof examples/dining-philosophers.pl
```

```text
step(after_send_state(dp_C1, dp_F23, dp_P3, dp_Clean),
     rule(135),
     ['Cs' = dp_C1, 'F' = dp_F23, 'P' = dp_P3, 'C' = dp_C0],
     [after_sends(dp_C0, dp_C1), send_fork(dp_C0, dp_P2, dp_P3, dp_F23)]).
```

P3 holds F23 after the sends, clean, because P2 sent it in C0. That hand-over
is one of the premises of P3's first meal, together with the slot, the hunger
fact, and P3 already holding F34.

---

# The check

```sh
eyeprolog --proof examples/dining-philosophers.pl > dining-philosophers.why.pl
eyeprolog --check-proof dining-philosophers.why.pl examples/dining-philosophers.pl
```

```text
condition('C1', resolution, ok, 539).
condition('C4', coverage, ok, 1070).
condition('C7', relevance, ok, 899).
verdict(checked).
```

All 539 rule steps replay against the program and the 10 built-in `\=` tests
are recomputed. Every one of the 350 claims is covered, and nothing is taken
on trust.

---

# Try it

- Remove `hungry(dp_C0, dp_P3).` Which requests, sends, and meals disappear?
- Change the starting state of F23 in C0 from `dp_Dirty` to `dp_Clean`. Is
  the fork still sent?
- Ask `--goal 'dp_philosopher(M, dp_P5)'` to list P5's meals.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 14 (knowledge engineering).
