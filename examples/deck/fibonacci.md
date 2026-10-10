# Fibonacci by fast doubling

## How do you compute the 10,000th Fibonacci number without computing all the ones before it?

The textbook Fibonacci rule needs every earlier number. Fast doubling jumps
from F(n) straight to F(2n), so the 10,000th number takes about fourteen steps
instead of ten thousand. EyeProlog's unbounded integers handle the 2,090-digit
result exactly.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=fibonacci) ·
[Source](../fibonacci.pl)

---

# The question

The Fibonacci numbers start 0, 1, 1, 2, 3, 5, 8, …, each the sum of the two
before. What are F(0), F(1), F(10), F(100), F(1000) and F(10000)?

The interesting part is not the definition but the method: can a small
relational program compute huge cases quickly and still explain every step?

---

# The doubling identities

```prolog
fib_pair(0, 0, 1).
fib_pair(N, F, G) :-
  (N > 0),
  (Half is N // 2),
  fib_pair(Half, A, B),
  (Twob is B * 2),
  (Twobminusa is Twob - A),
  (C is A * Twobminusa),
  (Aa is A * A),
  (Bb is B * B),
  (D is Aa + Bb),
  (0 is N mod 2),
  (F = C),
  (G = D).
```

`fib_pair(N, F, G)` holds when F = F(N) and G = F(N+1). With A = F(k) and
B = F(k+1), two identities give the next pair: F(2k) = A·(2B − A) and
F(2k+1) = A² + B². This clause covers even N; a second clause, identical except
for its last lines, covers odd N. Each call halves N, so the recursion depth is
about log₂ N.

---

# Bounding the question

```prolog
:- table fib_pair/3.

fib_case(0).
fib_case(1).
fib_case(10).
fib_case(100).
fib_case(1000).
fib_case(10000).

fibonacci(N, Value) :-
  fib_case(N),
  fib(N, Value).
```

`fib_case/1` lists the cases to report, so the query is finite. Tabling lets
the large cases share their half-size subproblems instead of recomputing them.

---

# The answer

```sh
eyeprolog examples/fibonacci.pl
```

```text
fibonacci(0, 0).
fibonacci(1, 1).
fibonacci(10, 55).
fibonacci(100, 354224848179261915075).
fibonacci(1000, 43466557686937456435688527675040625802564660517371780402481729089536555417949051890403879840079255169295922593080322634775209689623239873322471161642996440906533187938298969649928516003704476137795166849228875).
```

The sixth answer, F(10000), has 2,090 digits; see
[the golden output](../output/fibonacci.pl). All arithmetic is exact.

---

# The reason

```sh
eyeprolog --proof examples/fibonacci.pl
```

```text
step(fib_pair(10, 55, 89),
     rule(10),
     ['N' = 10,
      'F' = 55,
      'G' = 89,
      'Half' = 5,
      'A' = 5,
      'B' = 8,
      'Twob' = 16,
      'Twobminusa' = 11,
      'C' = 55,
      'Aa' = 25,
      'Bb' = 64,
      'D' = 89],
```

F(10) comes from the pair for 5: A = F(5) = 5 and B = F(6) = 8. Then
F(10) = 5 · (2·8 − 5) = 55 and F(11) = 5² + 8² = 89. The proof is the
calculation, line by line.

---

# The check

```sh
eyeprolog --proof examples/fibonacci.pl > fibonacci.why.pl
eyeprolog --check-proof fibonacci.why.pl examples/fibonacci.pl
```

```text
condition('C1', resolution, ok, 49).
condition('C5', re_decision, ok, 304).
steps(353).
verified(49).
recomputed(304).
trusted(0).
verdict(checked).
```

The checker replays 49 clause steps and independently recomputes 304
arithmetic steps, including multiplications of numbers with more than a
thousand digits. Nothing is taken on trust.

---

# Try it

- Ask `--goal 'fib(20, V)'` and `--goal 'fib(50, V)'`, and compare with
  6765 and 12586269025.
- Add `fib_case(100000).` after the other cases. F(100,000) has 20,899 digits
  and still takes well under a second.
- Write the naive two-clause Fibonacci and compare how far you can get. Where
  does it stop being practical, with and without `:- table`?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 13 and 27.
