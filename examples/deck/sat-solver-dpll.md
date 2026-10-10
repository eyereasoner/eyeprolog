# A DPLL SAT solver

## Can these five clauses all be true at once?

Boolean satisfiability (SAT) asks whether some assignment of true and false
to variables makes a formula true. This example writes the classic DPLL
search in a few dozen lines of Prolog: assign a variable, prune as soon as a
clause becomes impossible, and keep going.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=sat-solver-dpll) ·
[Source](../sat-solver-dpll.pl)

---

# The question

The formula is in conjunctive normal form (CNF): a list of clauses, each an
"or" of literals, all of which must hold.

```text
(a or b)  (not a or c)  (not b or c)  (not c or d)  (c or not d)
```

Four variables give 16 possible assignments. Which of them satisfy every
clause, and can the search avoid looking at all 16?

---

# The formula as data

```prolog
variable_order([a, b, c, d]).
cnf_clause(c1, [pos(a), pos(b)]).
cnf_clause(c2, [neg(a), pos(c)]).
cnf_clause(c3, [neg(b), pos(c)]).
cnf_clause(c4, [neg(c), pos(d)]).
cnf_clause(c5, [pos(c), neg(d)]).
```

A literal is `pos(Var)` or `neg(Var)`. A (partial) assignment is a list of
`bind(Name, Bool)` terms.

---

# The search

```prolog
clause_impossible(Assignment, Clause_name) :-
  cnf_clause(Clause_name, Literals),
  \+ nonfalse_literal(Literals, Assignment).

dpll([], Assignment, Assignment) :- complete_model(Assignment).
dpll([Var | Rest], Partial, Model) :-
  bool(Value),
  partial_consistent([bind(Var, Value) | Partial]),
  dpll(Rest, [bind(Var, Value) | Partial], Model).
```

A clause is *impossible* when every one of its literals is already false; an
unassigned literal keeps it alive. `dpll/3` tries `false`, then `true`, for
each variable and abandons a branch the moment some clause becomes impossible.
That early pruning is the heart of DPLL.

---

# The answer

```sh
eyeprolog examples/sat-solver-dpll.pl
```

```text
satModel([bind(d, true), bind(c, true), bind(b, true), bind(a, false)]).
satValue(d, true).
satValue(c, true).
satValue(b, true).
satValue(a, false).
satClauseStatus(c1, satisfied).
```

Eleven answers in all: the model, its four values, the status of all five
clauses, and a one-line conclusion. The formula has three models (`c` and `d`
must be true, and at least one of `a`, `b`); `aggregate_min/5` picks the one
with the smallest binary rank so the output is deterministic.

---

# The reason

```text
step(best_model([bind(d, true), bind(c, true), bind(b, true), bind(a, false)], 7),
     rule(28),
     ['Model' = [bind(d, true), bind(c, true), bind(b, true), bind(a, false)], 'Rank' = 7],
     [aggregate_min(Key, Value, (satisfying_model(Value), model_rank(Value, Key)), 7, [bind(d, true), bind(c, true), bind(b, true), bind(a, false)])]).
```

The chosen model has rank 7 (binary `0111` for `a`, `b`, `c`, `d`), and it is
the minimum over all satisfying models found by `satisfying_model/1`.

---

# The check

```text
condition('C1', resolution, ok, 36).
condition('C5', re_decision, ok, 5).
obligation(builtin, theory_scoped, aggregate_min(A, B, (satisfying_model(B), model_rank(B, A)), 7, [bind(d, true), bind(c, true), bind(b, true), bind(a, false)])).
verdict(checked_with_obligations).
```

36 steps replay against the program and 5 library calls are recomputed. One
step cannot be: "7 is the *minimum* rank" depends on every model the program
could produce, and the checker never searches. It records that claim as an
**obligation**, and the verdict says the proof holds given it.

---

# Try it

- Add `cnf_clause(c6, [neg(b)]).` The only model left is `a` true, `b` false,
  `c` and `d` true.
- Add `cnf_clause(c6, [neg(c)]).` instead. The formula becomes unsatisfiable,
  and the run prints nothing at all. Why is that the right outcome?
- Change `variable_order/1` to `[d, c, b, a]`. Does the answer change? Does the
  amount of search?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 24.
