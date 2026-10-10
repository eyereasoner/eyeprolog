# The shoelace formula

## What is the area of this polygon?

Given the corners of a polygon in order, the shoelace formula computes its
area from cross products of neighbouring corners. Here it is a short
recursion over a list of points, and the proof shows every multiplication.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=shoelace-polygon-area) ·
[Source](../shoelace-polygon-area.pl)

---

# The question

A six-sided polygon is given by its corners. What is its area?

The shoelace formula adds `(x1·y2 − y1·x2) / 2` over every pair of adjacent
corners. The name comes from the criss-cross pattern of the products when the
coordinates are written in two columns.

---

# The polygon

```prolog
sample_polygon([[3, 2], [6, 2], [7, 6], [4, 6], [5, 5], [5, 3], [3, 2]]).
```

The last point repeats the first, so the list walks all the way round and
closes the shape.

---

# The rules

```prolog
area([_point], 0).
area([[A, B], [C, D]|Rest], Total) :-
  area([[C, D]|Rest], Subtotal),
  (Ad is A * D),
  (Bc is B * C),
  (Cross is Ad - Bc),
  (Half is Cross / 2.0),
  (Total is Half + Subtotal).
```

A single point encloses nothing. Otherwise, take the first two points,
compute their half cross product, and add the area of the rest of the walk.
The recursion consumes one point per step, so it ends.

---

# The answer

```sh
eyeprolog examples/shoelace-polygon-area.pl
```

```text
polygon_area(sample, 7.5).
```

The polygon has area 7.5 square units.

---

# The reason

```text
step(area([[3, 2], [6, 2], [7, 6], [4, 6], [5, 5], [5, 3], [3, 2]], 7.5),
     rule(3),
     ['A' = 3,
      'B' = 2,
      'C' = 6,
      'D' = 2,
      'Rest' = [[7, 6], [4, 6], [5, 5], [5, 3], [3, 2]],
      'Total' = 7.5,
      'Subtotal' = 10.5,
      'Ad' = 6,
      'Bc' = 12,
      'Cross' = -6,
      'Half' = -3.0],
     [area([[6, 2], [7, 6], [4, 6], [5, 5], [5, 3], [3, 2]], 10.5),
      6 is 3 * 2,
      12 is 2 * 6,
      -6 is 6 - 12,
      -3.0 is -6 / 2.0,
      7.5 is -3.0 + 10.5]).
```

The first edge, from (3, 2) to (6, 2), contributes −3; the rest of the walk
contributes 10.5. Individual terms can be negative; only the total is the
area.

---

# The check

```text
condition('C1', resolution, ok, 9).
condition('C5', re_decision, ok, 29).
verdict(checked).
```

The 9 rule steps replay against the program, and all 29 arithmetic steps are
recomputed by the checker. Nothing is trusted.

---

# Try it

- List the corners in the opposite direction. The result becomes `-7.5`:
  the shoelace formula gives a *signed* area, positive for counter-clockwise
  order. Add `abs/1` to report the plain area.
- Compute the area of the unit square `[[0,0],[1,0],[1,1],[0,1],[0,0]]`.
- Write a rule that checks that the first and last points are equal before
  computing.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 5 and 6.
