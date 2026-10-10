# Finding a bug by asking smaller questions

## Where is the fault in a list-maximum predicate that gives the wrong answer?

`buggy_list_max([1, 5, 3], M)` answers 1 instead of 5. Instead of tracing or
printing, ask the same predicate a smaller question that a correct version
would also have to get right. Repeat until a call is correct. The fault lies
in the step just above it.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=declarative-fault-localization) ·
[Source](../declarative-fault-localization.pl)

---

# The question

A recursive predicate builds its answer from answers to smaller calls. If a
smaller call is already wrong, the fault is at that depth or deeper. If it is
right, the fault is in how the clause combines that correct result with the
rest. You only need to know the *intended* answer of each call; you never need
to know how the program computes it.

This is declarative debugging: judge each call by what it should mean.

---

# The buggy predicate

```prolog
buggy_list_max([X], X).
buggy_list_max([X|Xs], Max) :-
    buggy_list_max(Xs, Max0),
    ( X > Max0 -> Max = Max0 ; Max = X ).

fixed_list_max([X], X).
fixed_list_max([X|Xs], Max) :-
    fixed_list_max(Xs, Max0),
    ( X > Max0 -> Max = X ; Max = Max0 ).
```

The two branches of the if-then-else are swapped. When the head element is
larger, the buggy version keeps the old maximum, and otherwise it takes the
head. The fixed version keeps the larger of the two.

---

# Shrinking the question

```prolog
answer(WholeListWrongAnswer, TwoElementSublistAlreadyWrong, BaseCaseIsCorrect, FixedAnswer) :-
    buggy_list_max([1, 5, 3], WholeListWrongAnswer),
    buggy_list_max([5, 3], TwoElementSublistAlreadyWrong),
    buggy_list_max([3], BaseCaseIsCorrect),
    fixed_list_max([1, 5, 3], FixedAnswer).
```

Three calls on ever shorter lists, plus the repaired version for comparison.

---

# The answer

```sh
eyeprolog examples/declarative-fault-localization.pl
```

```text
answer(1, 3, 3, 5).
```

`[1, 5, 3]` gives 1, which is wrong. `[5, 3]` gives 3, also wrong. `[3]`
gives 3, which is right. So the base clause is fine, and the first recursive
step on top of it already goes wrong: the fault is in the recursive clause
itself. The fixed version answers 5.

---

# The reason

```text
step(buggy_list_max([5, 3], 3),
     rule(2),
     ['X' = 5, 'Xs' = [3], 'Max' = 3, 'Max0' = 3],
     [buggy_list_max([3], 3), (5 > 3 -> 3 = 3 ; 3 = 5)]).
step(buggy_list_max([3], 3), fact(1), ['X' = 3], []).
```

The proof shows the exact faulty moment. The sub-result `buggy_list_max([3], 3)`
is correct, then the clause tests `5 > 3`, takes the *then* branch, and sets
`Max = 3`. A wrong answer built from a correct sub-answer pins the fault on this
clause.

---

# The check

```text
condition('C1', resolution, ok, 7).
condition('C5', re_decision, ok, 4).
condition('C7', relevance, ok, 12).
steps(11).
recomputed(4).
trusted(0).
verdict(checked).
```

All 11 steps check out, and the four if-then-else decisions are recomputed.
The proof is valid, and that is the point: a proof certifies that an answer
follows from the program, not that the program is correct. Locating the bug
needed the intended meaning, which only the programmer has.

---

# Try it

- Ask `buggy_list_max([2, 9, 4, 7], M)`. It answers 2: the swapped branches
  turn the maximum into the minimum.
- Write the same three-question localization for a buggy `list_sum/2`.
- Turn the method into a program: given a call, its wrong answer, and an
  oracle for intended answers, find the deepest wrong call.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 32 (debugging by meaning, search, and proof).
