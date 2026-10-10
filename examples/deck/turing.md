# A Turing machine

## Can a handful of clauses run a Turing machine?

A Turing machine reads and writes symbols on a tape according to a transition
table. This example implements a general machine interpreter in a few clauses
and runs one machine that adds 1 to a binary number.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=turing) ·
[Source](../turing.pl)

---

# The question

Given a binary number written on a tape, what is on the tape after the
machine halts?

The tape is a list of bits, with `#` as the blank symbol. The machine runs
right to the end of the number, then walks left, turning trailing 1s into 0s
until it can turn a 0 (or a blank) into a 1.

---

# The machine

```prolog
start(add1, 0).
t([0, 0, 0, r], 0).
t([0, 1, 1, r], 0).
t([0, #, #, l], 1).
t([1, 0, 1, s], halt).
t([1, 1, 0, l], 1).
t([1, #, 1, s], halt).
```

Each transition reads as `t([State, Read, Write, Move], Next)`. State 0 moves
right over the number; at the blank it turns back in state 1, which carries
the 1 leftwards. Moves are `l` (left), `r` (right), and `s` (stay).

---

# The interpreter

```prolog
find(State, Left, Cell, Right, Outtape) :-
  t([State, Cell, Write, Move], Next),
  move(Move, Left, Write, Right, A, B, C),
  continue(Next, A, B, C, Outtape).

move(l, [Head|Tail], Cell, Right, Tail, Head, [Cell|Right]).
move(r, Left, Cell, [Head|Tail], [Cell|Left], Head, Tail).
```

The tape is a **zipper**: the cells to the left (reversed), the current cell,
and the cells to the right. One `find/5` call performs one transition. More
`move/7` clauses extend the tape with blanks at either end.

---

# The answer

```sh
eyeprolog examples/turing.pl
```

```text
output(case1, [1, 0, 1, 0, 1, 0, #]).
output(case2, [1, 1, 0, 0, 0, 0, #]).
output(case3, [1, 0, 0, 0, 0, 0, 0, #]).
output(case4, [1, #]).
```

101001 + 1 = 101010, 101111 + 1 = 110000, 111111 + 1 = 1000000, and the empty
tape becomes 1. The trailing `#` is the blank cell the machine visited.
The full output also lists the inputs and an `addsOne/2` fact per case.

---

# The reason

```text
step(output(case4, [1, #]),
     rule(25),
     ['Case' = case4, 'Outtape' = [1, #], 'Intape' = []],
     [case(case4, []), compute([], [1, #])]).
step(compute([], [1, #]),
     rule(1),
     ['Outtape' = [1, #], 'I' = 0],
     [start(add1, 0), find(0, [], #, [], [1, #])]).
```

The empty input starts in state 0 on a blank cell; the proof continues with
one `find/5` step per transition until the machine halts.

---

# The check

```text
condition('C1', resolution, ok, 143).
condition('C5', re_decision, ok, 8).
claims(12).
verdict(checked).
```

The checker replays all 143 rule and fact steps of the four runs and
recomputes 8 `append/3` steps. Every transition the machine made is checked.

---

# Try it

- Add `case(case5, [1, 0, 1, 1]).` and predict the output tape.
- `addsOne/2` only checks that the machine halts. Write a version that also
  compares the output with the input plus one.
- Write a transition table that subtracts 1, and run it with the same
  interpreter.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 22.
