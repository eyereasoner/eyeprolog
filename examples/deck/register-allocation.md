# Register allocation

## Which variables get a CPU register, and which must spill to memory?

A processor has few registers, and two values that are alive at the same time
cannot share one. Compilers solve this as graph coloring. This example
enumerates every assignment of four temporaries to two registers or memory,
rejects conflicts, and picks the cheapest spill plan.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=register-allocation) ·
[Source](../register-allocation.pl)

---

# The question

Temporaries `a`, `b`, `c`, and `d` each need a home: register `r1`, register
`r2`, or memory (a **spill**). Two temporaries **interfere** when they are
live at the same time, so they may not share a register. Spilling costs extra
loads and stores, and some temporaries are costlier to spill than others.

`a`, `b`, and `c` all interfere with each other: a triangle, which two
registers cannot color. Something must spill. Which choice is cheapest?

---

# The model

```prolog
register(r1).
register(r2).

place(Reg) :- register(Reg).
place(spill).

temporary(a, 10).
temporary(b, 1).
temporary(c, 10).
temporary(d, 2).

interferes(a, b).
interferes(b, c).
interferes(c, a).
interferes(c, d).
```

Each temporary has a spill cost: `b` is cheap to keep in memory, `a` and `c`
are expensive.

---

# The rules

```prolog
allocation_conflict(Allocation) :-
  interferes(Left, Right),
  assigned(Left, Allocation, Reg),
  assigned(Right, Allocation, Reg),
  register(Reg).

valid_allocation(Allocation) :-
  candidate_allocation(Allocation),
  \+ allocation_conflict(Allocation).

best_allocation(Allocation, Cost) :-
  aggregate_min([Candidate_cost, Candidate], Candidate,
    (valid_allocation(Candidate), allocation_cost(Candidate, Candidate_cost)),
    [Cost, Allocation], Allocation).
```

A conflict is two interfering temporaries in the same real register; spilled
ones never conflict. `aggregate_min/5` keeps the valid allocation with the
lowest cost, breaking ties by the allocation term itself.

---

# The answer

```sh
eyeprolog examples/register-allocation.pl
```

```text
registerAnswer(best_allocation, [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)]).
registerAnswer(spill_cost, 1).
registerAnswer(place(a), r1).
registerAnswer(place(b), spill).
registerAnswer(place(c), r2).
registerAnswer(place(d), r1).
registerAnswer(valid_allocation_count, 33).
registerAnswer(note, "the cheapest solution spills b to color the a-b-c triangle with two registers").
```

Of 81 candidate assignments, 33 are conflict-free. The cheapest spills only
`b`, at cost 1, and `d` can share `r1` with `a` because those two never
interfere.

---

# The reason

```sh
eyeprolog --proof examples/register-allocation.pl
```

```text
step(registerAnswer(spill_cost, 1),
     rule(24),
     ['Cost' = 1],
     [best_allocation([bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)], 1)]).
step(best_allocation([bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)], 1),
     rule(22),
     ['Allocation' = [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)], 'Cost' = 1],
     [aggregate_min([Candidate_cost, Value], Value, (valid_allocation(Value), allocation_cost(Value, Candidate_cost)), [1, [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)]], [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)])]).
```

The spill cost of 1 comes from the best allocation, which comes from one
`aggregate_min/5` over all valid candidates.

---

# The check

```text
condition('C1', resolution, ok, 19).
condition('C7', relevance, ok, 29).
obligation(builtin, theory_scoped, aggregate_min([A, B], B, (valid_allocation(B), allocation_cost(B, A)), [1, [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)]], [bind(a, r1), bind(b, spill), bind(c, r2), bind(d, r1)])).
obligation(builtin, theory_scoped, countall(valid_allocation(A), 33)).
trusted(2).
verdict(checked_with_obligations).
```

The rule steps all check. The minimum and the count are **obligations**:
"this is the cheapest" and "there are 33" are claims about the whole search
space, which a checker that never searches can accept only as stated
assumptions.

---

# Try it

- Make `b` expensive (`temporary(b, 20)`) and predict which temporary spills
  instead.
- Add a third register `r3`. What is the new minimum cost?
- Add `interferes(a, d).`. Can `d` still share a register with anyone?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 8 (choosing answers) and 24 (finite search).
