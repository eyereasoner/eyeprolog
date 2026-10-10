# Paths through a cycle

## Which nodes can reach which, when the graph loops back on itself?

Four arcs form a directed cycle `a → b → c → d → a`. The classic two-clause
path relation would chase that cycle forever. With one table declaration,
EyeProlog derives all sixteen reachable pairs and stops.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=cyclic-path) ·
[Source](../cyclic-path.pl)

---

# The question

A path is an arc, or an arc followed by a path. On a graph without cycles,
that definition terminates because every step moves closer to a dead end. Here
every node leads back to itself, so a naive search can ask "is there a path
from `a`?" inside its own answer, again and again.

---

# The graph and the rules

```prolog
:- table path/2.

arc(a, b).
arc(b, c).
arc(c, d).
arc(d, a).

path(X, Y) :- arc(X, Y).
path(X, Z) :- arc(X, Y), path(Y, Z).
```

The rules are the textbook definition, unchanged. The only addition is
`:- table path/2.`: EyeProlog records the answers to each `path/2` question,
and when a question comes back around the cycle it reuses the recorded answers
instead of searching again. Once a round adds nothing new, the computation is
complete.

---

# The answer

```sh
eyeprolog examples/cyclic-path.pl
```

```text
path(a, b).
path(b, c).
path(c, d).
path(d, a).
path(a, c).
path(a, d).
path(a, a).
path(b, d).
```

Sixteen answers in all (eight shown): every node reaches every node, including
itself, because the cycle passes through all four.

---

# The reason

```text
step(path(a, a), rule(7), ['X' = a, 'Z' = a, 'Y' = b], [arc(a, b), path(b, a)]).
step(path(b, a), rule(7), ['X' = b, 'Z' = a, 'Y' = c], [arc(b, c), path(c, a)]).
step(path(c, a), rule(7), ['X' = c, 'Z' = a, 'Y' = d], [arc(c, d), path(d, a)]).
```

`a` reaches itself by going to `b`, and `b` reaches `a` via `c`, and `c` via
`d`, until `path(d, a)` holds by the direct arc. Although the search was
cyclic, the proof is not: no step depends on itself, and every chain ends at
an arc.

---

# The check

```text
condition('C1', resolution, ok, 20).
condition('C2', well_founded, ok, 20).
condition('C4', coverage, ok, 44).
condition('C7', relevance, ok, 36).
steps(20).
trusted(0).
verdict(checked).
```

All 20 steps are replayed against the clauses they cite. C2, *well-founded*,
is the interesting condition here: it confirms that no conclusion depends on
itself, so tabling found genuine derivations rather than circular ones.
Nothing is taken on trust.

---

# Try it

- Remove `:- table path/2.` and run again. The first answers still appear, but
  the search never finishes.
- Add `arc(d, e).` and predict the new answers. (There are four: every node now
  reaches `e`.)
- Ask from one node only: `--goal 'path(c, X)'`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 4 (cycles and tabling) and Chapter 13.
