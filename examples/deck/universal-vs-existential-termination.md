# Universal and existential termination

## Does "it terminates" mean the first answer, or all of them?

A Prolog query can find its first answer quickly and still never finish
listing all of them. This example uses `append/3` to show the two kinds of
termination coming apart for the very same predicate, depending only on how it
is called.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=universal-vs-existential-termination) ·
[Source](../universal-vs-existential-termination.pl)

---

# The question

A query **terminates existentially** if it finds one answer, or fails, in
finite time. It **terminates universally** if it finishes after producing
every answer. Which does `append/3` do?

It depends on the call. Splitting a known list has finitely many answers.
Appending with every argument unknown has infinitely many: the result can be a
list of any length.

---

# The program

```prolog
answer(AllSplitsOfBoundList, SplitCount, FoundFirstSplitOfUnboundList) :-
    findall(X - Y, append(X, Y, [a, b, c]), AllSplitsOfBoundList),
    length(AllSplitsOfBoundList, SplitCount),
    once((append(X2, _Y2, _Z2), X2 == [])),
    FoundFirstSplitOfUnboundList = true.
```

`findall/3` asks for all splits of `[a, b, c]`, which is safe because the call
terminates universally. For the fully open call, `once/1` asks for just the
first answer, which is all existential termination promises. Replacing that
`once/1` with `findall/3` would never return.

---

# The answer

```sh
eyeprolog examples/universal-vs-existential-termination.pl
```

```text
answer([[] - "abc", "a" - "bc", "ab" - "c", "abc" - []], 4, true).
```

The bound list has exactly 4 splits. The lists of characters are printed in
double-quoted notation: `"abc"` is the list `[a, b, c]`. The open call found
its first answer, `X2 = []`, and stopped there.

---

# The reason

```text
step(once((append([], Ys, Ys), [] == [])), control, [], [append([], Ys, Ys), [] == []]).
step(append([], Ys, Ys), builtin, [], []).
```

The first answer of the open `append/3` call binds only the first list to `[]`;
the other two stay unbound but equal. The proof records that honestly: `Ys`
remains a variable.

---

# The check

```text
condition('C5', re_decision, ok, 5).
obligation(collected, theory_scoped, findall(A - B, append(A, B, "abc"), [[] - "abc", "a" - "bc", "ab" - "c", "abc" - []])).
trusted(1).
verdict(checked_with_obligations).
```

Four built-in steps are recomputed and the `once/1` step is composed from its
parts. The `findall/3` result is a **collection** the checker cannot rebuild
step by step, so it is reported as an obligation: the verdict holds provided
those really are all the splits.

---

# Try it

- Ask for all splits of a five-element list and predict how many there are.
- Run `findall(X-Y, append(X, Y, Z), L)` with a timeout and watch it not
  return.
- Call `length(L, N)` with both arguments unbound inside `once/1`. Does it
  terminate existentially, universally, or both?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 19.
