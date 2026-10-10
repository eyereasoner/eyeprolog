# DONALD + GERALD = ROBERT

## Which digit does each letter stand for?

In this classic cryptarithm, ten letters stand for the ten decimal digits,
each digit used once. Trying every assignment means 3,628,800 permutations.
The example instead solves the sum column by column, from right to left, and
finds the unique answer with very little search.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=donald-gerald-robert) ·
[Source](../donald-gerald-robert.pl)

---

# The question

```text
  D O N A L D
+ G E R A L D
= R O B E R T
```

Find distinct digits for D, O, N, A, L, G, E, R, B, T so that the sum holds,
with no leading zero. How many solutions are there?

---

# Column by column

```prolog
pandigital_cryptarithm(solution(D, O, N, A, L, G, E, R, B, T)) :-
  all_digits(Digits),
  % Units: D + D = T, with carry C1.
  select(D, Digits, D0),
  D \= 0,
  UnitsSum is D + D,
  T is UnitsSum mod 10,
  C1 is UnitsSum // 10,
  select(T, D0, D1),
  % Tens: L + L + C1 = R, with carry C2.
  select(L, D1, D2),
  TensSum is L + L + C1,
  R is TensSum mod 10,
  C2 is TensSum // 10,
  R \= 0,
  select(R, D2, D3),
  ...
```

Each column chooses one new digit with `select/3`, which also removes it from
the remaining pool, and then **computes** the result digit and carry instead
of guessing them. Choosing D fixes T; choosing L fixes R.

---

# The shortcuts

```prolog
  % Ten-thousands: O cancels, so E + C4 must be exactly 10 * C5.
  CarrySum is E + C4,
  0 is CarrySum mod 10,
  C5 is CarrySum // 10,
  % Hundred-thousands: D + G + C5 = R, which derives G directly.
  G is R - D - C5,
  G > 0,
  select(G, D7, D8),
  % The sole remaining digit is O; it is also a leading digit.
  select(O, D8, []),
  O \= 0.
```

Two columns need no search at all. O appears on both sides of its column, so
it cancels; G follows by subtraction; and O is whatever single digit is left.

---

# The answer

```sh
eyeprolog examples/donald-gerald-robert.pl
```

```text
pandigital_cryptarithm_answer(naive_search_space, permutations(10, 3628800)).
pandigital_cryptarithm_answer(assignments, solution(5, 2, 6, 4, 8, 1, 9, 7, 3, 0)).
pandigital_cryptarithm_answer(equation, equation(526485, 197485, 723970)).
pandigital_cryptarithm_answer(digit_usage, [5, 2, 6, 4, 8, 1, 9, 7, 3, 0]).
pandigital_cryptarithm_answer(solution_count, 1).
```

526485 + 197485 = 723970, and it is the only solution.

---

# The reason

```sh
eyeprolog --proof examples/donald-gerald-robert.pl
```

```text
step(pandigital_cryptarithm_answer(assignments, solution(5, 2, 6, 4, 8, 1, 9, 7, 3, 0)),
     rule(5),
     ['D' = 5, 'O' = 2, 'N' = 6, 'A' = 4, 'L' = 8, 'G' = 1, 'E' = 9, 'R' = 7, 'B' = 3, 'T' = 0],
     [pandigital_cryptarithm(solution(5, 2, 6, 4, 8, 1, 9, 7, 3, 0))]).
```

The assignment rests on one successful run of the column-by-column solver. Its
proof records every `select/3`, every `mod` and `//` computation, and every
digit test along the way.

---

# The check

```sh
eyeprolog --proof examples/donald-gerald-robert.pl > donald-gerald-robert.why.pl
eyeprolog --check-proof donald-gerald-robert.why.pl examples/donald-gerald-robert.pl
```

```text
condition('C1', resolution, ok, 10).
condition('C4', coverage, ok, 75).
condition('C7', relevance, ok, 72).
obligation(builtin, theory_scoped, countall(pandigital_cryptarithm(A), 1)).
verdict(checked_with_obligations).
```

The 10 rule steps replay and 56 arithmetic and list steps are recomputed. The
claim that there is exactly **one** solution is an obligation: it counts over
the program's own search, so the checker records it as an assumption rather
than proving it.

---

# Try it

- Remove the line `O \= 0`. Does the solution count change?
- Solve SEND + MORE = MONEY the same way, and compare with
  [send-more-money](../send-more-money.pl).
- Estimate how many `select/3` choices the solver makes, compared with the
  3,628,800 permutations of the naive approach.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 24 (designing finite search).
