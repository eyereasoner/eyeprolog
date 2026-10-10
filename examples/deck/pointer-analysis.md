# Pointer analysis

## Which objects can each pointer variable point to?

A compiler cannot run a program to learn where its pointers go, so it reasons
about every statement at once. This example does that the way Andersen-style
analyses do: a handful of inclusion rules computed to a fixed point, here over
a six-statement program.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=pointer-analysis) ·
[Source](../pointer-analysis.pl)

---

# The question

Take this small C-like program:

```text
x = &object_a
z = &object_b
y = x
*y = z
q = *x
r = q
```

Which variables may point to `object_b`? The answer is not visible in any one
line: `q` only gets `object_b` because `*y = z` wrote it through `y`, and `y`
is an alias of `x`.

---

# The program as facts

```prolog
addr(x, object_a).
addr(z, object_b).
assign(y, x).
store(y, z).
load(q, x).
assign(r, q).
```

Each statement becomes one fact: `addr` for taking an address, `assign` for
copying a pointer, `store` for writing through a pointer (`*y = z`), and
`load` for reading through one (`q = *x`).

---

# The rules

```prolog
points_to(Var, Object) :- addr(Var, Object).
points_to(To, Object) :- assign(To, From), points_to(From, Object).

field_points_to(Heap_object, Value_object) :-
  store(Pointer, Value),
  points_to(Pointer, Heap_object),
  points_to(Value, Value_object).
points_to(To, Value_object) :-
  load(To, Pointer),
  points_to(Pointer, Heap_object),
  field_points_to(Heap_object, Value_object).
```

Assignment copies points-to sets. A store makes the pointed-to object hold a
reference (`field_points_to`); a load reads it back out. The rules are
mutually recursive, and their least fixed point is the analysis result.

---

# The answer

```sh
eyeprolog examples/pointer-analysis.pl
```

```text
pointsTo(x, object_a).
pointsTo(z, object_b).
pointsTo(y, object_a).
pointsTo(r, object_b).
pointsTo(q, object_b).
heapField(object_a, object_b).
pointerFlow(load_q_from_x, object_b).
pointerConclusion(case, "the load q = *x recovers object_b through the store *y = z and y = x").
```

`y` aliases `x`, so the store through `y` puts `object_b` inside `object_a`,
and the load through `x` hands it to `q`, and from there to `r`.

---

# The reason

```sh
eyeprolog --proof examples/pointer-analysis.pl
```

```text
step(points_to(q, object_b),
     rule(12),
     ['To' = q, 'Value_object' = object_b, 'Pointer' = x, 'Heap_object' = object_a],
     [load(q, x), points_to(x, object_a), field_points_to(object_a, object_b)]).
step(field_points_to(object_a, object_b),
     rule(11),
     ['Heap_object' = object_a, 'Value_object' = object_b, 'Pointer' = y, 'Value' = z],
     [store(y, z), points_to(y, object_a), points_to(z, object_b)]).
```

The proof is exactly the argument a reviewer would want: `q` reads `object_b`
out of `object_a` (the load rule), because the store `*y = z` put it there
while `y` pointed to `object_a` (the store rule).

---

# The check

```text
condition('C1', resolution, ok, 20).
condition('C4', coverage, ok, 28).
condition('C7', relevance, ok, 28).
verified(20).
trusted(0).
verdict(checked).
```

All 20 steps resolve against the clauses they cite, and the analysis rests on
nothing but the six statement facts.

---

# Try it

- Add `assign(s, r).` and predict which object `s` may point to.
- Add a second store `store(x, x).` (that is, `*x = x`). Which new
  `heapField/2` and `pointsTo/2` answers appear?
- Andersen's analysis ignores statement order. Which line of the source
  program would a flow-sensitive analysis treat differently?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 13 (fixed points and tabling).
