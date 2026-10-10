# Peano calculus

## Can arithmetic be built from nothing but zero and "the next number"?

Giuseppe Peano described the natural numbers with two ingredients: a zero and
a successor. This example writes `z` for zero and `s(N)` for "the number after
`N`", then defines addition, multiplication, and factorial as plain relations
over those terms.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=peano-calculus) ·
[Source](../peano-calculus.pl)

---

# The question

In Peano notation, three is `s(s(s(z)))`. There are no digits and no
built-in arithmetic, only terms.

Can ordinary clauses compute 2 + 3, 2 × 3, and 4!, and show *why* each answer
is right?

---

# Addition and multiplication

```prolog
padd(A, z, A).
padd(A, s(B), s(C)) :-
  padd(A, B, C).

pmul(_a, z, z).
pmul(A, s(B), C) :-
  pmul(A, B, D),
  padd(A, D, C).
```

These are the textbook definitions. `A + 0 = A`, and `A + (B + 1) = (A + B) + 1`.
Likewise `A × 0 = 0`, and `A × (B + 1) = A × B + A`. Each recursive call peels
one `s` off the second argument, so the computation follows the structure of
the number.

---

# Factorial with an accumulator

```prolog
pfact(N, Value) :-
  pfac(N, s(z), Value).

pfac(z, Acc, Acc).
pfac(s(N), Acc, Value) :-
  pmul(Acc, s(N), Next),
  pfac(N, Next, Value).
```

The accumulator starts at one and is multiplied by `N`, `N - 1`, and so on
down to zero.

---

# The answer

```sh
eyeprolog examples/peano-calculus.pl
```

```text
peano_answer(two_plus_three, s(s(s(s(s(z)))))).
peano_answer(two_times_three, s(s(s(s(s(s(z))))))).
peano_answer(factorial_four, s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))))))).
```

Five, six, and twenty-four `s` wrappers: 2 + 3 = 5, 2 × 3 = 6, and 4! = 24.

---

# The reason

```text
step(peano_answer(two_plus_three, s(s(s(s(s(z)))))),
     rule(8),
     ['N' = s(s(s(s(s(z)))))],
     [padd(s(s(z)), s(s(s(z))), s(s(s(s(s(z))))))]).
step(padd(s(s(z)), s(s(s(z))), s(s(s(s(s(z)))))),
     rule(2),
     ['A' = s(s(z)), 'B' = s(s(z)), 'C' = s(s(s(s(z))))],
     [padd(s(s(z)), s(s(z)), s(s(s(s(z)))))]).
```

2 + 3 = 5 because 2 + 2 = 4 (by the recursive addition rule), and so on down
to 2 + 0 = 2. The proof is an induction on the second argument, written out
step by step.

---

# The check

```text
condition('C1', resolution, ok, 59).
condition('C5', re_decision, ok, 0).
steps(59).
verified(59).
trusted(0).
claims(3).
verdict(checked).
```

All 59 steps are program clauses, replayed exactly. There is no built-in
arithmetic to recompute and nothing to trust: the proof is pure logic.

---

# Try it

- Run addition backwards: `--goal 'padd(X, Y, s(s(z)))'` gives all three ways
  to split two into two numbers.
- Ask `pmul(X, s(s(z)), s(s(s(s(z)))))`: which number times two is four?
- Define `pless/2` (less than) and `pdouble/2` in the same style.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 27.
