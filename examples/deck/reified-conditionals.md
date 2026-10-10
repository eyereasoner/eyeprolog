# Reified conditionals

## How can a condition become data that reusable control predicates act on?

Normally a test such as "is this even?" either succeeds or fails, and the
caller branches on that. A **reified** test instead returns `true` or
`false` as a value. Once conditions are values, filtering and partitioning
can be written once, in `library(reif)`, and reused with any condition.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=reified-conditionals) ·
[Source](../reified-conditionals.pl)

---

# The question

Split the numbers 1 to 8 into evens and odds, and classify 4 and 7, without
writing a separate filter or a separate if-then-else for each task.

"Reify" means to make something concrete: here the truth of a condition
becomes an ordinary term that another predicate can receive and dispatch on.

---

# The reified condition

```prolog
:- use_module(library(reif)).

even_t(N, true) :- 0 is N mod 2, !.
even_t(_, false).
```

By convention, a predicate ending in `_t` takes one extra argument, the truth
value. `even_t(4, T)` gives `T = true`, and `even_t(7, T)` gives `T = false`.

---

# Using it

```prolog
answer(Evens, Odds, First, Second) :-
    tfilter(even_t, [1, 2, 3, 4, 5, 6, 7, 8], Evens),
    tpartition(even_t, [1, 2, 3, 4, 5, 6, 7, 8], _, Odds),
    if_(even_t(4), First = even, First = odd),
    if_(even_t(7), Second = even, Second = odd).
```

`tfilter/3` keeps the elements whose condition is `true`; `tpartition/4`
splits a list into the true and false parts; `if_/3` chooses a branch from
the reified value. All three are generic: pass a different `_t` predicate and
they work unchanged.

---

# The answer

```sh
eyeprolog examples/reified-conditionals.pl
```

```text
answer([2, 4, 6, 8], [1, 3, 5, 7], even, odd).
```

The evens and odds come out in their original order, and the two
classifications agree with them.

---

# The reason

```sh
eyeprolog --proof examples/reified-conditionals.pl
```

```text
step(answer([2, 4, 6, 8], [1, 3, 5, 7], even, odd),
     rule(3),
     ['Evens' = [2, 4, 6, 8], 'Odds' = [1, 3, 5, 7], 'First' = even, 'Second' = odd],
     [tfilter(even_t, [1, 2, 3, 4, 5, 6, 7, 8], [2, 4, 6, 8]),
      tpartition(even_t, [1, 2, 3, 4, 5, 6, 7, 8], [2, 4, 6, 8], [1, 3, 5, 7]),
      if_(even_t(4), even = even, even = odd),
      if_(even_t(7), odd = even, odd = odd)]).
```

One rule, four uses. Each use is a call to a library predicate, and each is
recorded with its exact arguments and result.

---

# The check

```text
condition('C1', resolution, ok, 1).
condition('C4', coverage, ok, 5).
obligation(builtin, theory_scoped, tfilter(even_t, [1, 2, 3, 4, 5, 6, 7, 8], [2, 4, 6, 8])).
obligation(builtin, theory_scoped, if_(even_t(7), odd = even, odd = odd)).
trusted(4).
verdict(checked_with_obligations).
```

The rule step checks. The four library calls cannot be recomputed in a clean
library context, because they call back into this program's `even_t/2`. The
checker therefore lists them as **obligations**: correct if `even_t/2` means
what it says, which the program itself defines.

---

# Try it

- Write `greater_t(Limit, N, T)` and use `tfilter/3` to keep the numbers
  above 5, without touching `tfilter/3`.
- Replace `if_(even_t(4), …)` with the plain `( 0 is 4 mod 2 -> … ; … )`.
  What is lost when the condition is not a value?
- Use `tpartition/4` to split a list of words by whether they start with a
  vowel.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 17 (logic and control) and 34 (control).
