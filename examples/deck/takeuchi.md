# The Takeuchi function

## What does a tiny, wildly recursive function compute?

The Takeuchi function `tak` is a classic benchmark: three lines of recursion
that make an enormous number of calls. This example computes it with tabling,
so repeated calls are answered from a table, and keeps the arguments small
enough that the proof of the answer can be written out and checked.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=takeuchi) ·
[Source](../takeuchi.pl)

---

# The question

What is `tak(16, 11, 6)`?

Ikuo Takeuchi designed the function in 1978 to stress function calls. It
returns `Z` when `X ≤ Y`, and otherwise calls itself on three decremented,
rotated argument triples and then once more on their three results. Plain
recursion repeats the same subcalls again and again.

---

# The rules

```prolog
:- table tak/2.

tak([X, Y, Z], Z) :-
    X =< Y,
    !.
tak([X, Y, Z], A) :-
    X1 is X-1,
    tak([X1, Y, Z], A1),
    Y1 is Y-1,
    tak([Y1, Z, X], A2),
    Z1 is Z-1,
    tak([Z1, X, Y], A3),
    tak([A1, A2, A3], A).
```

The three arguments travel as one list, so a call is `tak([X, Y, Z], Result)`.
The `:- table tak/2.` declaration makes EyeProlog remember the answer of every
call pattern it has solved, so each distinct triple is computed once.

---

# The answer

```sh
eyeprolog examples/takeuchi.pl
```

```text
tak([16, 11, 6], 11).
```

According to the comment in the source, the tabled version answers in about
45 ms and the untabled one in about 250 ms. The gap grows quickly with the
arguments: `tak([34, 13, 8], _)` takes about 28 seconds without tabling.

---

# The reason

```text
step(tak([11, 11, 6], 6), rule(2), ['X' = 11, 'Y' = 11, 'Z' = 6], [11 =< 11, !]).
step(11 =< 11, builtin, [], []).
```

Each base case is one step: since `11 ≤ 11`, `tak` returns its third argument,
`6`. The top-level answer rests on a tree of 249 such steps, each citing
clause 2 (the base case) or clause 3 (the recursion). Every distinct call
appears once, however often the search reached it.

---

# The check

```text
condition('C1', resolution, ok, 198).
condition('C5', re_decision, ok, 51).
condition('C7', relevance, ok, 250).
steps(249).
verdict(checked).
```

The checker replays 198 rule steps and recomputes 51 built-in steps (the
subtractions, comparisons, and cuts) independently. The answer `11` is
checked, with nothing taken on trust.

---

# Try it

- Remove the `:- table tak/2.` line and time both versions.
- Ask for `tak([18, 12, 6], A)` and compare the size of its proof with the one
  for `[16, 11, 6]`.
- Collect `tak/2` for every triple with arguments between 0 and 6 using
  `findall/3`. When does the result equal `Y`, and when `Z`?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 13.
