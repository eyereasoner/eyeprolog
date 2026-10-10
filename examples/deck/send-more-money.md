# SEND + MORE = MONEY

## Which digits make this sum work?

The most famous cryptarithm: replace each letter with a different digit so
that the addition holds. The solver checks each column, with its carry, as
soon as the column's letters are chosen, instead of trying all digit
assignments first.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=send-more-money) ·
[Source](../send-more-money.pl)

---

# The question

```text
    S E N D
  + M O R E
  ---------
  M O N E Y
```

Eight letters, ten digits, every letter a different digit, no leading zero.
How many solutions are there, and what are they?

---

# Choosing digits

```prolog
all_digits([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]).

send_more_money(solution(S, E, N, D, M, O, R, Y)) :-
  all_digits(Digits),
  (M = 1),
  (O = 0),
  select(M, Digits, D0),
  select(O, D0, D1),
  select(D, D1, D2),
  select(E, D2, D3),
  (Onessum is D + E),
  (Y is Onessum mod 10),
  (Carry1 is Onessum // 10),
  select(Y, D3, D4),
```

`select/3` takes one digit out of the remaining list, so letters automatically
get different digits. `M = 1` and `O = 0` are fixed up front: a carry out of a
four-digit sum can only be 1, and that forces `O` to 0.

---

# Column by column

The ones column is checked right after `D` and `E` are chosen: `Y` is the last
digit of `D + E`, and the carry moves on. The tens, hundreds, and thousands
columns follow the same pattern, each as early as possible. A wrong choice is
rejected after a few digits, not after all eight.

```prolog
  select(S, D6, _d7),
  (S \= 0),
  (Thousandspartial is S + M),
  (Thousandssum is Thousandspartial + Carry3),
  (O is Thousandssum mod 10),
  (M is Thousandssum // 10).
```

---

# The answer

```sh
eyeprolog examples/send-more-money.pl
```

```text
cryptarithm_answer(assignments, solution(9, 5, 6, 7, 1, 0, 8, 2)).
cryptarithm_answer(equation, equation(9567, 1085, 10652)).
cryptarithm_answer(solution_count, 1).
```

9567 + 1085 = 10652, and it is the only solution.

---

# The reason

```text
step(cryptarithm_answer(assignments, solution(9, 5, 6, 7, 1, 0, 8, 2)),
     rule(5),
     ['S' = 9, 'E' = 5, 'N' = 6, 'D' = 7, 'M' = 1, 'O' = 0, 'R' = 8, 'Y' = 2],
     [send_more_money(solution(9, 5, 6, 7, 1, 0, 8, 2))]).
step(select(1, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], [0, 2, 3, 4, 5, 6, 7, 8, 9]), builtin, [], []).
```

The proof records every digit selection and every column computation with
its actual values, so each step of the arithmetic can be read off directly.

---

# The check

```text
condition('C5', re_decision, ok, 46).
obligation(builtin, theory_scoped, countall(send_more_money(A), 1)).
verdict(checked_with_obligations).
```

All 46 arithmetic and selection steps are recomputed by the checker. One
claim cannot be checked step by step: that the count of solutions is exactly
1. That depends on the whole search space, so it is recorded as an
**obligation**. The solution itself is fully checked; its uniqueness is what
the verdict leaves conditional.

---

# Try it

- Delete the two lines `(M = 1),` and `(O = 0),`. The solution count jumps
  to 25. Which constraint of the puzzle went missing?
- Solve `TO + GO = OUT` with the same column-by-column pattern.
- Move every column check to the end, after all `select/3` calls. Same
  answer; how much slower?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 10 and 24.
