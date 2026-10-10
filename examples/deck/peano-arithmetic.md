# Peano arithmetic

## What is (1 × 2 + 3)! when numbers are only zero and successors?

This is the classic logic-programming benchmark: add, multiply, and factorial
over Peano numerals, where `0` is zero and `s(N)` is the next number. The query
computes 1 × 2 + 3 = 5 and then 5! = 120, entirely by unification and
recursion.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=peano-arithmetic) ·
[Source](../peano-arithmetic.pl)

---

# The question

How far can you get with no arithmetic at all? In this program, 120 is not a
number but a term: 120 nested `s(...)` wrappers around `0`.

Computing it exercises deep recursion and large terms, and every step is
still an ordinary clause that a proof can cite.

---

# The definitions

```prolog
peano_add(A, 0, A).
peano_add(A, s(B), s(C)) :-
  peano_add(A, B, C).

peano_multiply(_a, 0, 0).
peano_multiply(A, s(B), C) :-
  peano_multiply(A, B, D),
  peano_add(A, D, C).
```

Addition and multiplication recurse on their second argument, one successor at
a time. They are Peano's axioms, read as programs.

---

# Factorial and the query

```prolog
fac(0, A, A).
fac(s(A), B, C) :-
  peano_multiply(B, s(A), D),
  fac(A, D, C).

factorial(B, C) :-
  peano_multiply(s(0), s(s(0)), A),
  peano_add(A, s(s(s(0))), B),
  factorial_value(B, C).
```

`factorial/2` builds its own input, 1 × 2 + 3, and then computes the factorial
with an accumulator that starts at one.

---

# The answer

```sh
eyeprolog examples/peano-arithmetic.pl
```

```text
factorial(s(s(s(s(s(0))))), s(s(s(s(s(s(s(s(s(s( ... 0)))))))))).
```

The input is five, and the result is a term with 120 `s` wrappers, shown
shortened here. The full line is in [`output/peano-arithmetic.pl`](../output/peano-arithmetic.pl).

---

# The reason

```text
step(peano_add(s(s(0)), s(s(s(0))), s(s(s(s(s(0)))))),
     rule(2),
     ['A' = s(s(0)), 'B' = s(s(0)), 'C' = s(s(s(s(0))))],
     [peano_add(s(s(0)), s(s(0)), s(s(s(s(0)))))]).
```

This step is the "+ 3" part of the input: 2 + 3 = 5 because 2 + 2 = 4. The
proof continues down to `peano_add(A, 0, A)` and then up through every
multiplication of the factorial, one step per distinct conclusion.

---

# The check

```text
condition('C1', resolution, ok, 156).
condition('C4', coverage, ok, 167).
steps(156).
verified(156).
recomputed(0).
trusted(0).
verdict(checked).
```

156 steps, all program clauses, all replayed. Even with terms 120 levels deep,
the checker needs no built-ins and trusts nothing.

---

# Try it

- Change the `+ 3` to `+ 2` and predict the size of 4!.
- Compare with the [Peano calculus](peano-calculus.md) deck, which uses `z`
  for zero and runs the same relations backwards.
- Run with `--stats` and compare the work with a version that uses `is/2`
  arithmetic.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 27.
