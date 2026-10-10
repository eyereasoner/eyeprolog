# Basic monadic benchmark

## Which labelled ten-step cycles exist in a graph of 10,000 edges?

A benchmark from the rule-reasoning world: 10,000 labelled edges and one rule
that looks for walks of exactly ten edges, all with the same label, that return
to where they started. EyeProlog finds 1,518 of them, proves each one, and
checks every proof.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=basic-monadic) ·
[Source](../basic-monadic.pl)

---

# The question

The facts are triples `edge(From, Label, To)`. A cycle for label `R` is a
sequence of nodes `D0, D1, …, D9` where each consecutive pair is joined by an
`R`-edge and the last one leads back to `D0`.

The question is *monadic* because each answer is about a single relation label,
and it is a benchmark because the search must stay selective over a large,
random-looking graph.

---

# The facts

```prolog
edge(i30, i12, i33).
edge(i61, i29, i42).
edge(i57, i46, i87).
edge(i45, i35, i45).
edge(i6, i37, i6).
```

A few of the 10,000 edges. Some, like `edge(i45, i35, i45)`, are self-loops:
node `i45` points to itself under label `i35`.

---

# The rule

```prolog
cycle(R, [D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D0]) :-
  edge(D0, R, D1),
  edge(D1, R, D2),
  edge(D2, R, D3),
  edge(D3, R, D4),
  edge(D4, R, D5),
  edge(D5, R, D6),
  edge(D6, R, D7),
  edge(D7, R, D8),
  edge(D8, R, D9),
  edge(D9, R, D0).
```

The head repeats `D0` at both ends, which is how the rule says "closed". The
body runs left to right, so each edge lookup already knows its start node and
label, and the clause index keeps every step cheap.

---

# The answer

```sh
eyeprolog examples/basic-monadic.pl
```

```text
cycle(i35, [i45, i45, i45, i45, i45, i45, i45, i45, i45, i45, i45]).
cycle(i37, [i6, i6, i6, i6, i6, i6, i6, i6, i6, i6, i6]).
cycle(i62, [i81, i24, i81, i24, i81, i24, i81, i24, i81, i24, i81]).
cycle(i62, [i81, i24, i81, i24, i81, i24, i81, i24, i81, i81, i81]).
cycle(i62, [i81, i24, i81, i24, i81, i24, i81, i81, i24, i81, i81]).
```

1,518 cycles in all ([full output](../output/basic-monadic.pl)). A self-loop
gives a cycle that stays put; a small loop such as `i81 → i24 → i81` can be
combined with a self-loop on `i81` in many orders, which is why label `i62`
contributes so many answers.

---

# The reason

```sh
eyeprolog --proof examples/basic-monadic.pl
```

```text
step(cycle(i35, [i45, i45, i45, i45, i45, i45, i45, i45, i45, i45, i45]),
     rule(10001),
     ['R' = i35,
      'D0' = i45,
      'D1' = i45,
      'D2' = i45,
      'D3' = i45,
      'D4' = i45,
      'D5' = i45,
      'D6' = i45,
      'D7' = i45,
      'D8' = i45,
      'D9' = i45],
     [edge(i45, i35, i45),
      edge(i45, i35, i45),
```

Clause 10,001 is the cycle rule (the 10,000 edges come first). The first
answer uses the same self-loop ten times; the step lists all ten uses.

---

# The check

```text
condition('C1', resolution, ok, 1883).
condition('C4', coverage, ok, 16698).
condition('C7', relevance, ok, 3401).
verdict(checked).
```

The checker replays all 1,883 steps against the program and confirms that
every one of the 1,518 claims and their 16,698 uses is covered, without
searching the graph again. Nothing is trusted.

---

# Try it

- Ask for a single label: `--goal 'cycle(i37, Path)'`. How many cycles does it
  have, and why?
- Run with `--stats` and compare the number of solver calls with the number of
  edges. What keeps the search from trying all 10,000 edges at every step?
- Move the last body goal, `edge(D9, R, D0)`, to the front of the rule. Does
  the answer set change? Does the running time?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 13 and Chapter 21.
