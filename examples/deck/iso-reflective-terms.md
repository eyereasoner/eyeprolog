# Reflective terms

## How does a program look inside a term whose shape it does not know?

Programs that handle syntax trees, schemas or messages often receive terms
whose name and arguments are not written in the calling clause. ISO Prolog has
a small set of built-ins for exactly that: inspect a term, take it apart,
build a new one, copy it, and compare it with others.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=iso-reflective-terms) ·
[Source](../iso-reflective-terms.pl)

---

# The question

Given one sample event term, what is its name and arity, what is its second
argument, and what does it look like as a list? And how do term construction,
copying, variable collection and standard ordering behave?

---

# The sample

```prolog
sample(event(sensor_7, reading(temperature, 21))).
```

A single fact holds a nested term: an `event` with two arguments, the second
of which is itself a `reading` term. Each `report/2` rule asks one question
about it.

---

# Inspecting and building

```prolog
report(shape, shape(Name, Arity)) :-
  sample(Term),
  functor(Term, Name, Arity).

report(payload, Payload) :-
  sample(Term),
  arg(2, Term, Payload).

report(parts, Parts) :-
  sample(Term),
  (Term =.. Parts).

report(rebuilt, Term) :-
  (Term =.. [alert, sensor_7, high]).
```

`functor/3` gives the name and arity, and `arg/3` picks an argument, counting
from 1. `=..` (univ) works both ways: it turns a term into a list, and a list
back into a term.

---

# Copying and ordering

```prolog
report(copied_shape, same_but_fresh) :-
  copy_term(pair(X, X), pair(A, B)),
  A == B,
  X \== A.

report(order, Order) :-
  compare(Order, alpha, beta).
```

`copy_term/2` renames every variable but keeps the sharing: both arguments of
the copy are the same new variable, distinct from the original `X`.
`compare/3` orders any two terms, not just numbers.

---

# The answer

```sh
eyeprolog examples/iso-reflective-terms.pl
```

```text
report(shape, shape(event, 2)).
report(payload, reading(temperature, 21)).
report(parts, [event, sensor_7, reading(temperature, 21)]).
report(rebuilt, alert(sensor_7, high)).
report(variable_count, 3).
report(copied_shape, same_but_fresh).
report(order, <).
```

All seven reflective questions get one answer each. Note that `=..` exposes
only the top level: the nested `reading(temperature, 21)` stays a single
element.

---

# The reason

```sh
eyeprolog --proof examples/iso-reflective-terms.pl
```

```text
step(report(rebuilt, alert(sensor_7, high)),
     rule(5),
     ['Term' = alert(sensor_7, high)],
     [alert(sensor_7, high) =.. [alert, sensor_7, high]]).
step(alert(sensor_7, high) =.. [alert, sensor_7, high], builtin, [], []).
```

The rebuilt term holds by rule 5, and the only premise is a univ call recorded
with its result filled in. Because that goal is now ground, a checker can run
it again and confirm it.

---

# The check

```text
condition('C1', resolution, ok, 8).
condition('C5', re_decision, ok, 11).
condition('C7', relevance, ok, 26).
verdict(checked).
```

Eight rule and fact steps replay against their clauses, and all 11 built-in
steps (`functor`, `arg`, `=..`, `term_variables`, `copy_term`, `compare`, …)
are recomputed independently and agree. Nothing is taken on trust.

---

# Try it

- `compare(O, 1.0, 1)` gives `<`: in standard order a float comes before an
  integer of the same value. Where does `f(a)` stand relative to `b`?
- Use `functor(T, point, 3)` to build a term with three fresh arguments, then
  fill them in with `arg/3`.
- Write `subterm(Sub, Term)` with `=..` and `member/2` so that it enumerates
  every subterm of the sample.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 35.
