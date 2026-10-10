# Relational cube lookup

## Can 2000 two-key lookups over 3375 facts stay fast and fully explained?

Data-heavy rule sets spend most of their time looking things up. This
example stores a 3375-row table and asks 2000 questions that each bind two of
its four columns, so it measures clause indexing as much as logic. The
answer is a single "passed", but its proof and check cover every lookup.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=relational-cube-lookup) ·
[Source](../relational-cube-lookup.pl)

---

# The question

A **relation** here is a table with four columns, `relation(A, B, C, Value)`.
A typical query knows the first and third columns and asks whether a matching
row exists. Answering 2000 such questions by scanning all 3375 rows each time
would mean millions of comparisons. Answering them with an index on the bound
arguments is nearly instant.

---

# The data

```prolog
relation(a0, b0, c0, v0_0).
relation(a0, b31, c1, v0_1).
relation(a0, b62, c2, v0_2).
relation(a0, b93, c3, v0_3).
```

These are the first 4 of 3375 generated facts: 225 values of `A`, each paired
with 15 values of `C`, so the table is a 225 × 15 cube with one row per
`(A, C)` pair.

---

# The rules

```prolog
relation_exists(A, C) :- relation(A, _, C, _).

lookupResult(case, passed) :-
  relation_exists(a0, c0),
  relation_exists(a44, c5),
  relation_exists(a88, c10),
  relation_exists(a132, c0),
```

`relation_exists/2` asks for a row with given first and third columns. The
`lookupResult/2` rule has 2000 such goals in its body (four are shown); it
holds only if every one succeeds.

---

# The answer

```sh
eyeprolog examples/relational-cube-lookup.pl
```

```text
lookupResult(case, passed).
reason(case, "2000 two-key lookups over 3375 facts").
```

All 2000 lookups succeed. On the CLI the whole run, including parsing 5388
lines of source, takes well under a second, because each call with `A` and
`C` bound goes straight to candidate rows through the argument indexes.

---

# The reason

```sh
eyeprolog --proof examples/relational-cube-lookup.pl
```

```text
step(relation_exists(a44, c5),
     rule(3376),
     ['A' = a44, 'C' = c5],
     [relation(a44, b903, c5, v44_5)]).
step(relation(a44, b903, c5, v44_5), fact(666), [], []).
```

Each lookup is justified by one fact, named by its position in the file:
`a44` with `c5` is row 666. The proof has one such pair of steps per lookup,
plus the two conclusions.

---

# The check

```text
condition('C1', resolution, ok, 4002).
condition('C4', coverage, ok, 4003).
condition('C7', relevance, ok, 4004).
steps(4002).
verified(4002).
trusted(0).
verdict(checked).
```

The checker replays all 4002 steps against the program. Every lookup is
verified against the exact row it cites, and nothing is trusted.

---

# Try it

- Run with `--stats` and compare the counters with a version where
  `relation_exists/2` binds only the third column.
- Delete one of the 3375 facts that a lookup uses. Which conclusion
  disappears, and what does the output show?
- Indexing changes running time, never answers. Which experiment would show
  that the answer set stays identical?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 13 (clause indexing).
