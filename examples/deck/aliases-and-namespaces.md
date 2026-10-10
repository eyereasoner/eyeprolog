# Aliases and namespaces

## Which names are built in, and which are just your vocabulary?

Arithmetic, comparison, text matching, and list decomposition are each written
one native way. Everything else, including names that look like vocabulary
from another system, is an ordinary user predicate with no special meaning.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=aliases-and-namespaces) ·
[Source](../aliases-and-namespaces.pl)

---

# The question

Rule languages often grow many aliases for the same operation, such as
`math:sum`, `add/3`, or `string:matches`. EyeProlog keeps one spelling per
built-in and lets every other name belong to the program.

This example shows both sides in six short rules.

---

# Native built-ins

```prolog
value(nativeMath, X) :- (X is 0.125 + 0.875).
ok(nativeCompare, true) :- (2 < 3).
ok(nativeString, true) :- matches('scoped retail insight', 'retail|medical').
tail(nativeList, Tail) :- [_head|Tail] = [a, b, c].
```

- Arithmetic is ISO `is/2`, comparison is `</2`.
- `matches/2` comes from `library(strings)` and accepts `|`-separated
  alternatives.
- A list's tail comes from unification with `[Head|Tail]`; no `rest/2`
  helper is needed.

---

# Vocabulary is data

```prolog
example_label(vocabularyExample, "vocabulary names are ordinary predicate names").
label(vocabularyExample, Text) :- example_label(vocabularyExample, Text).
```

`label/2` might look like a reserved word from some vocabulary. Here it is
just a predicate defined by the program.

---

# The answer

```sh
eyeprolog examples/aliases-and-namespaces.pl
```

```text
value(nativeMath, 1.0).
ok(nativeCompare, true).
ok(nativeString, true).
tail(nativeList, "bc").
label(vocabularyExample, "vocabulary names are ordinary predicate names").
```

`0.125 + 0.875` is the float `1.0`. The tail `[b, c]` is printed as `"bc"`,
because a list of one-character atoms is written in double-quote notation.

---

# The reason

```sh
eyeprolog --proof examples/aliases-and-namespaces.pl
```

```text
step(ok(nativeString, true), rule(3), [], [matches('scoped retail insight', 'retail|medical')]).
step(matches('scoped retail insight', 'retail|medical'), builtin, [], []).
step(tail(nativeList, "bc"), rule(4), ['Tail' = "bc"], ["abc" = "abc"]).
```

Each conclusion rests on one rule and, below it, a `builtin` step for the
native operation. The text match succeeds because `retail` occurs in the
phrase.

---

# The check

```text
condition('C1', resolution, ok, 6).
condition('C5', re_decision, ok, 4).
recomputed(4).
trusted(0).
verdict(checked).
```

The 6 rule and fact steps are verified against the program, and the checker
recomputes all 4 built-in steps itself.

---

# Try it

- Change the pattern to `'medical|legal'` and predict whether
  `ok(nativeString, true)` is still derived.
- Write `tail/2` for the list `[x]`. What is printed for an empty tail?
- Define your own `sum/3` with `is/2` and use it in a rule. Does it behave any
  differently from a native built-in in the proof?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 39.
