# Common ISO extensions

## Which everyday extensions do mature Prolog systems share?

The ISO core leaves out a few relations that almost every Prolog system
offers anyway: checking that all solutions pass a test, generating an integer
range, counting solutions, and comparing terms up to variable renaming. This
example shows each from `library(iso_ext)` on three colors.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=iso-extensions) ·
[Source](../iso-extensions.pl)

---

# The question

Given the colors red, green, and blue: are all of them atoms? What are the
successors of 1 to 3? Can we collect the colors into a list that already has
a tail? Which terms have the same shape? How many colors are there?

---

# The examples

```prolog
extension_example(all_colors_are_atoms, true) :-
  forall(color(Color), atom(Color)).

extension_example(successors, Pairs) :-
  findall(N-S, (cfor(1, 3, N), succ(N, S)), Pairs).

extension_example(collection_with_tail, Colors) :-
  findall(Color, color(Color), Colors, [done]).

extension_example(repeated_variable_variant, true) :-
  variant(tree(X, X), tree(Y, Y)).

extension_example(color_count, Count) :-
  countall(color(_), Count).
```

`forall/2` is "no counterexample exists". `cfor/3` generates an inclusive
integer range. `findall/4` collects into a difference list. `variant/2` holds
when two terms are equal up to a consistent renaming of variables.

---

# The answer

```sh
eyeprolog examples/iso-extensions.pl
```

```text
extension_example(all_colors_are_atoms, true).
extension_example(successors, [1 - 2, 2 - 3, 3 - 4]).
extension_example(collection_with_tail, [red, green, blue, done]).
extension_example(repeated_variable_variant, true).
extension_example(different_variable_shape, true).
extension_example(color_count, 3).
```

`tree(X, X)` is a variant of `tree(Y, Y)` but not of `tree(_, _Y)`: the
repeated variable is part of the shape.

---

# The reason

```sh
eyeprolog --proof examples/iso-extensions.pl
```

```text
step(findall(N - S, (cfor(1, 3, N), succ(N, S)), [1 - 2, 2 - 3, 3 - 4]), collected, [], []).
step(\+ variant(tree(X, X), tree(__anon0, _Y)), absent, [], []).
```

Each answer has a rule step whose premise is the extension call. The
successor list is a `collected` step, a completed `findall/3`, and the
failing variant test is an `absent` step, a completed `\+`.

---

# The check

```text
condition('C1', resolution, ok, 6).
condition('C5', re_decision, ok, 1).
obligation(absent, theory_scoped, \+ variant(tree(A, A), tree(B, C))).
obligation(builtin, theory_scoped, countall(color(A), 3)).
trusted(5).
verdict(checked_with_obligations).
```

All six rule steps replay. The positive `variant/2` call is recomputed by the
checker. The other five extension steps are trusted boundaries, listed as
**obligations**: either they range over the program's own `color/1` facts or,
like the negated variant test, they are kinds of step the checker records
rather than re-runs.

---

# Try it

- Add `color(42).` Which answer disappears, and what happens to the count
  and the collected list?
- Ask for `cfor(3, 1, N)` and explain the result.
- Write `all_distinct_colors` with `forall/2` and `\==/2` over pairs of
  colors.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 8 and 39.
