# Ancestors

## Who descends from whom?

Three parent facts form a family chain. Two rules turn that chain into the
complete ancestor relation, and EyeProlog derives every pair, says why each
holds, and checks its own reasons.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=ancestor) ·
[Source](../ancestor.pl)

---

# The question

Given who is a parent of whom, which people are ancestors of which others?

A parent is an ancestor, and so is a parent of an ancestor. That sentence is
the whole program. Nothing in it says how to search; the search follows from
the clauses.

---

# The facts

```prolog
parent(pat, jan).
parent(jan, lies).
parent(lies, emma).
```

Each fact is one sentence: `parent(pat, jan)` says that Pat is a parent of
Jan. Four generations, three facts.

---

# The rules

```prolog
ancestor(X, Y) :-
  parent(X, Y).

ancestor(X, Z) :-
  parent(X, Y),
  ancestor(Y, Z).
```

The first clause is the **base case**: every parent is an ancestor. The second
is the **recursive case**: take one parent step, then ask the same question one
generation down. Every recursive call moves one step along a finite chain, so
the search ends.

---

# The answer

```sh
eyeprolog examples/ancestor.pl
```

```text
ancestor(pat, jan).
ancestor(jan, lies).
ancestor(lies, emma).
ancestor(pat, lies).
ancestor(pat, emma).
ancestor(jan, emma).
```

Three direct ancestors and three indirect ones. The `parent/2` facts are
asked about too, but the output leaves out answers that only repeat a source
fact.

---

# The reason

```sh
eyeprolog --proof examples/ancestor.pl
```

```text
step(ancestor(pat, lies),
     rule(5),
     ['X' = pat, 'Z' = lies, 'Y' = jan],
     [parent(pat, jan), ancestor(jan, lies)]).
step(ancestor(jan, lies), rule(4), ['X' = jan, 'Y' = lies], [parent(jan, lies)]).
```

Pat is an ancestor of Lies by the recursive rule (clause 5) with `Y = jan`: Pat
is Jan's parent, and Jan is an ancestor of Lies by the base rule (clause 4).
Each conclusion gets exactly one step, and each step names the clause it used.

---

# The check

```sh
eyeprolog --proof examples/ancestor.pl > ancestor.why.pl
eyeprolog --check-proof ancestor.why.pl examples/ancestor.pl
```

```text
condition('C1', resolution, ok, 9).
condition('C4', coverage, ok, 15).
condition('C7', relevance, ok, 15).
verdict(checked).
```

A separate checker replays all 9 steps against the program without searching.
Every claim is covered, every step resolves against the clause it cites, and
nothing in the proof is taken on trust.

---

# Try it

- Add `parent(emma, noor).` and predict how many new ancestor pairs appear.
- Ask only for Emma's ancestors: `--goal 'ancestor(Who, emma)'`.
- Swap the two goals in the recursive rule and run it again. The meaning is
  unchanged, yet the search never ends: the recursive call now comes before
  anything binds `Y`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 4.
