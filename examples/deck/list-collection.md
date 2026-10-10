# List collections

## How do you work with a whole list as one value?

A list is an ordinary term, so a fact can hold a complete list. This small
example stores two lists and asks the basic questions: how long is it, what
is in it, what do you get by extending it, and what are its head and tail.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=list-collection) ·
[Source](../list-collection.pl)

---

# The question

Given a list of numbers and a list of letters: how many numbers are there,
which numbers are members, what does the letter list look like with `c`
added at the end, and what are its first element and its remaining elements?

---

# The facts

```prolog
collection(numbers, [1, 2, 3]).
collection(letters, [a, b]).
```

Each list is kept whole, as the second argument of one fact, instead of being
spread over separate item facts.

---

# The rules

```prolog
collectionLength(numbers, N) :-
  collection(numbers, List),
  length(List, N).

collectionMember(numbers, X) :-
  collection(numbers, List),
  member(X, List).

collectionAppend(letters, Extended) :-
  collection(letters, List),
  append(List, [c], Extended).

head(letters, Head) :-
  collection(letters, [Head|_tail]).

tail(letters, Tail) :-
  collection(letters, [_head|Tail]).
```

`length/2`, `member/2`, and `append/3` come from `library(lists)`. The last
two rules need no library at all: the pattern `[Head|Tail]` splits a list by
unification.

---

# The answer

```sh
eyeprolog examples/list-collection.pl
```

```text
collectionLength(numbers, 3).
collectionMember(numbers, 1).
collectionMember(numbers, 2).
collectionMember(numbers, 3).
collectionAppend(letters, "abc").
head(letters, a).
tail(letters, "b").
```

`member/2` gives one answer per element. A list of one-character atoms such
as `[a, b, c]` is printed in double-quote notation, `"abc"`: with the default
`double_quotes(chars)` flag that is the same term, written more compactly.

---

# The reason

```sh
eyeprolog --proof examples/list-collection.pl
```

```text
step(collectionAppend(letters, "abc"),
     rule(5),
     ['Extended' = "abc", 'List' = "ab"],
     [collection(letters, "ab"), append("ab", "c", "abc")]).
step(tail(letters, "b"), rule(7), ['Tail' = "b"], [collection(letters, "ab")]).
```

The extended list comes from rule 5: the stored letters `"ab"`, appended
with `"c"`. The tail needs only the stored fact, matched against
`[_head|Tail]`.

---

# The check

```text
condition('C1', resolution, ok, 9).
condition('C5', re_decision, ok, 5).
recomputed(5).
trusted(0).
verdict(checked).
```

Nine rule and fact steps replay against the program, and the five library
calls (`length/2`, three `member/2` calls, `append/3`) are recomputed by the
checker on its own. Nothing is taken on trust.

---

# Try it

- Change the numbers to the empty list `[]`. The length becomes 0 and the
  member answers disappear.
- Add `last(letters, X) :- collection(letters, L), last(L, X).` and run it.
- Use `append/3` the other way round to split `[a, b]` into every prefix and
  suffix.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 5.
