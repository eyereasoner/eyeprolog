# Roads across France

## Which cities can you reach by one-way roads?

Ten one-way roads connect cities in France. Two rules compute every city
reachable from every other, and EyeProlog explains each route by the roads it
used.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=graph) ·
[Source](../graph.pl)

---

# The question

A road from Paris to Orléans and one from Orléans to Blois mean you can get
from Paris to Blois. Reachability is the **transitive closure** of the road
relation: one or more legs, always in the direction of travel.

---

# The roads

```prolog
oneway(paris, orleans).
oneway(paris, chartres).
oneway(paris, amiens).
oneway(orleans, blois).
oneway(orleans, bourges).
oneway(blois, tours).
oneway(chartres, lemans).
```

`oneway(A, B)` means there is a road from `A` to `B`, not back.

---

# The rules

```prolog
path(A, B) :-
    oneway(A, B).
path(A, C) :-
    oneway(A, B),
    path(B, C).
```

A path is a road, or a road followed by a path. The recursive rule takes a
concrete road first and only then asks the smaller question from the next
city. That order is what makes the search productive: written as
`path(A, B), path(B, C)`, the rule would start by asking the very question it
is trying to answer.

---

# The answer

```sh
eyeprolog examples/graph.pl
```

```text
path(paris, orleans).
path(paris, chartres).
path(paris, amiens).
path(orleans, blois).
path(orleans, bourges).
```

21 answers in total: the 10 direct roads, then the longer routes such as
`path(paris, nantes)` and `path(chartres, tours)`.

---

# The reason

```text
step(path(paris, tours),
     rule(12),
     ['A' = paris, 'C' = tours, 'B' = orleans],
     [oneway(paris, orleans), path(orleans, tours)]).
step(path(orleans, tours),
     rule(12),
     ['A' = orleans, 'C' = tours, 'B' = blois],
     [oneway(orleans, blois), path(blois, tours)]).
```

Paris reaches Tours through Orléans, Orléans reaches Tours through Blois, and
`path(blois, tours)` is a direct road. Read top-down, the steps spell out the
route Paris → Orléans → Blois → Tours.

---

# The check

```text
condition('C1', resolution, ok, 31).
condition('C4', coverage, ok, 53).
condition('C7', relevance, ok, 52).
verdict(checked).
```

All 31 steps replay against the clauses they cite, and all 21 claims are
covered. Nothing is trusted.

---

# Try it

- Add `oneway(nantes, paris).` The graph now has a cycle and the untabled
  search no longer finishes. Add `:- table path/2.` and it does.
- Ask only where you can go from Chartres: `--goal 'path(chartres, X)'`.
- Replace the recursive rule with the left-recursive
  `path(A, C) :- path(A, B), path(B, C).` What happens to the run?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 4 and 13.
