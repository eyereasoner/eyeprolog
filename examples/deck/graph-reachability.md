# Reachability with a visited list

## Can you get from one node to another, and can the program prove when you can't?

A small directed graph, a search that remembers where it has been, and three
questions: two routes that exist and one that does not. The negative answer is
as much a result as the positive ones, and the proof says what it rests on.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=graph-reachability) ·
[Source](../graph-reachability.pl)

---

# The question

Is `f` reachable from `a`? Is `g` reachable from `c`? Is `e` reachable from
`b`?

Answering "no" is harder than answering "yes". A "yes" needs one route; a "no"
needs a search that is guaranteed to finish and then finds nothing.

---

# The graph and the search

```prolog
edge(a, b).
edge(a, c).
edge(b, d).
edge(c, e).
edge(d, f).
edge(e, f).
edge(f, g).

reachable_via(Node, Node, _visited).
reachable_via(Start, Goal, Visited) :-
  edge(Start, Next),
  \+ member(Next, Visited),
  reachable_via(Next, Goal, [Next|Visited]).
```

The `Visited` list records every node on the current route, and
`\+ member(Next, Visited)` refuses to step onto one twice. That keeps every
route finite, even on a graph with cycles.

---

# The questions as rules

```prolog
reachable(reachability_case, path(a, f)) :-
  is_reachable(a, f).

not_reachable(reachability_case, path(b, e)) :-
  \+ is_reachable(b, e).
```

`not_reachable/2` uses negation as failure: it succeeds when the finite search
for a route from `b` to `e` comes back empty.

---

# The answer

```sh
eyeprolog examples/graph-reachability.pl
```

```text
reachable(reachability_case, path(a, f)).
reachable(reachability_case, path(c, g)).
not_reachable(reachability_case, path(b, e)).
```

---

# The reason

```text
step(reachable_via(f, f, "fdba"), fact(8), ['Node' = f], []).
step(not_reachable(reachability_case, path(b, e)), rule(13), [], [\+ is_reachable(b, e)]).
step(\+ is_reachable(b, e), absent, [], []).
```

The route from `a` ends when it reaches `f` with the visited list `"fdba"`
(the list `[f, d, b, a]`, printed in compact text form): the route was
a → b → d → f. The negative answer rests on an `absent` step, the record that
the search for a route from `b` to `e` finished without one.

---

# The check

```text
condition('C1', resolution, ok, 19).
condition('C6', boundary_consistency, ok, 6).
obligation(absent, theory_scoped, \+ is_reachable(b, e)).
trusted(7).
verdict(checked_with_obligations).
```

All 19 rule and fact steps replay. The seven `absent` steps (six "not visited
yet" tests and the one unreachable pair) cannot be re-proved step by step, so
the check lists them as obligations: they hold as long as the program's
`edge/2` facts are complete. For six of them it found evidence and nothing
contradicted them.

---

# Try it

- Add `edge(b, e).` The `not_reachable/2` answer disappears, while the two
  `reachable/2` answers stay.
- Add a cycle, `edge(g, a).` The search still finishes thanks to the visited
  list, and `not_reachable/2` disappears: `b` now reaches `e` by way of `g`
  and `a`.
- Add `reachable(reachability_case, path(a, g)) :- is_reachable(a, g).` and
  read its proof route.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 4 and 7.
