# A CDCL SAT step

## How does a SAT solver learn from a conflict?

Modern SAT solvers use conflict-driven clause learning (CDCL): when a guess
leads to a contradiction, they learn a new clause that rules the guess out.
This example replays one such episode on a three-clause formula as relations
over immutable terms, and proves that the final assignment satisfies every
clause.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=cdcl-sat-solver) ·
[Source](../cdcl-sat-solver.pl)

---

# The question

The formula has three clauses:

- `c1`: not *a*, or *c*
- `c2`: not *c*
- `c3`: *a*, or *b*

Guessing *a* = true forces *c* = true through `c1`, which contradicts `c2`.
What does the solver learn, and what assignment follows?

---

# Clauses and the trail

```prolog
sat_clause(c1, [neg(a), pos(c)]).
sat_clause(c2, [neg(c)]).
sat_clause(c3, [pos(a), pos(b)]).

initial_value(a, true, decision(level1)).
initial_value(c, true, implied_by(c1)).
```

A clause is a list of literals. The **trail** records each assignment with
its reason: a decision, or an implication by a clause.

---

# Detecting the conflict

```prolog
conflict(Trail, Clause) :-
  sat_clause(Clause, Literals),
  \+ nonfalse_literal(Trail, Literals).

nonfalse_literal(Trail, Literals) :-
  member(Literal, Literals),
  \+ lit_false(Literal, Trail).
```

A clause is in conflict when none of its literals can still be true. The
learned clause `not(a)`, obtained by resolving `c2` with `c1` on *c*, and the
final trail are stated as facts; the rules check that they are consistent.

---

# The answer

```sh
eyeprolog examples/cdcl-sat-solver.pl
```

```text
cdclAnswer(conflict_clause, c2).
cdclAnswer(learned_clause, [neg(a)]).
cdclAnswer(learned_from, resolve(c2, c1, pivot(c))).
cdclAnswer(final_value(a), false).
cdclAnswer(final_value(c), false).
cdclAnswer(final_value(b), true).
cdclAnswer(note, "one learned clause makes the final model satisfy all original clauses").
```

After learning `not(a)`, the solver sets *a* false, `c2` forces *c* false, and
`c3` forces *b* true.

---

# The reason

```text
step(conflict(initial, c2),
     rule(12),
     ['Trail' = initial, 'Clause' = c2, 'Literals' = [neg(c)]],
     [sat_clause(c2, [neg(c)]), \+ nonfalse_literal(initial, [neg(c)])]).
step(\+ nonfalse_literal(initial, [neg(c)]), absent, [], []).
```

`c2` is the conflict because its only literal, not *c*, is false on the
initial trail: the search for a literal that is not false came up empty.

---

# The check

```text
condition('C1', resolution, ok, 15).
condition('C4', coverage, ok, 20).
obligation(absent, theory_scoped, \+ nonfalse_literal(initial, [neg(c)])).
obligation(absent, theory_scoped, \+ unsatisfied_final_clause).
verdict(checked_with_obligations).
```

The rule steps are replayed. The two negations, "no literal of `c2` survives"
and "no clause is left unsatisfied", are **obligations**: a checker cannot
prove an absence from the proof alone, so it states what the verdict rests on.

---

# Try it

- Set the final value of *b* to false. The conflict and the learned clause
  remain, but the final values and the note disappear, because `c3` is no
  longer satisfied.
- Derive the learned clause by resolution instead of stating it as a fact.
- Add a clause `c4: not(b)`. Is the formula still satisfiable?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 7 and 24.
