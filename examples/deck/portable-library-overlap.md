# Portable library overlap

## Can one program use nine libraries and still run on three Prolog systems?

EyeProlog keeps a set of library modules source-compatible with Scryer and
Trealla Prolog. This example exercises nine of them in a single goal (Boolean
constraints, ordered sets, graphs, reified filtering, delayed goals, generated
names, character types, matrix transposition, and tabling) and shows how
the proof and its check handle library calls whose results depend on state.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=portable-library-overlap) ·
[Source](../portable-library-overlap.pl)

---

# The question

Portability is easy to promise and hard to test. A program that imports
`library(clpb)`, `library(ugraphs)`, or `library(reif)` should find the same
predicates, with the same names and arguments, whichever system runs it. This
example is a compact smoke test of that overlap: if any import or call
diverges, the single answer changes.

---

# The imports

```prolog
:- use_module(library(charsio), [char_type/2]).
:- use_module(library(clpb), [sat/1, labeling/1]).
:- use_module(library(gensym), [gensym/2, reset_gensym/1]).
:- use_module(library(lists), [transpose/2]).
:- use_module(library(ordsets), [ord_union/3]).
:- use_module(library(reif), [tfilter/3, (=)/3]).
:- use_module(library(tabling)).
:- use_module(library(ugraphs), [vertices_edges_to_ugraph/3, reachable/3]).
:- use_module(library(when), [when/2]).
```

Each import names exactly the predicates it needs, the style that ports
cleanly between systems.

---

# The goal

```prolog
:- table path/2.

edge(a, b).
edge(b, c).

path(X, Y) :- path(X, Z), edge(Z, Y).
path(X, Y) :- edge(X, Y).
```

```prolog
    sat(X * ~Y),
    labeling([X,Y]),
    ord_union([a,c], [b,c], Union),
    vertices_edges_to_ugraph([a,b,c], [a-b,b-c], Graph),
    reachable(a, Graph, Reachable),
    tfilter(=(a), [a,b,a], Filtered),
    when(nonvar(Wake), Awakened = yes),
    Wake = now,
```

The body of `overlap_example/1` makes one call per library. `path/2` is
left-recursive, which would loop in plain Prolog; the `table` declaration
makes it terminate.

---

# The answer

```sh
eyeprolog examples/portable-library-overlap.pl
```

```text
overlap_example(overlap(booleans([1, 0]), union("abc"), reachable("abc"), filtered("aa"), awakened(yes), generated(shared1), uppercase("A"), transposed([[1, 4], [2, 5], [3, 6]]), tabled_paths("bc"))).
```

`X * ~Y` is satisfied only by `X = 1, Y = 0`; the union and reachable sets are
`[a,b,c]`; filtering keeps the two `a`s; the delayed goal fired when `Wake` was
bound; and the tabled paths from `a` are `b` and `c`. Lists of characters are
printed in double-quoted form, so `"abc"` is `[a,b,c]`.

---

# The reason

```sh
eyeprolog --proof examples/portable-library-overlap.pl
```

```text
step(sat(1 * ~ 0), builtin, [], []).
step(ord_union("ac", "bc", "abc"), builtin, [], []).
step(findall(Node, path(a, Node), "bc"), collected, [], []).
```

The program's one rule is justified by library calls. Each is recorded as a
`builtin` step that the checker can recompute in a clean copy of the
libraries, except the `findall/3` over the tabled `path/2`, which is recorded
as a completed collection.

---

# The check

```text
condition('C5', re_decision, ok, 9).
condition('C6', boundary_consistency, ok, 1).
obligation(builtin, stateful, sat(1 * ~ 0)).
obligation(builtin, stateful, reset_gensym(shared)).
obligation(builtin, stateful, gensym(shared, shared1)).
obligation(collected, theory_scoped, findall(A, path(a, A), "bc")).
trusted(4).
verdict(checked_with_obligations).
```

Nine library calls are recomputed and agree. Four cannot be: CLP(B)
constraints and generated names depend on run-time state, and a collection
can be refuted but not proved. The checker lists these as **obligations**, the
exact assumptions the verdict rests on, instead of silently accepting them.

---

# Try it

- Change `sat(X * ~Y)` to `sat(X + Y)` and predict how `labeling/1` picks the
  first solution.
- Call `gensym(shared, Generated)` twice before reading `Generated`. What does
  `reset_gensym/1` guarantee, and why is that state an obligation?
- Run the file under Scryer or Trealla Prolog. Which output format differs,
  and does the answer itself?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 39 (interoperability and autoloading).
