# Symbolic Fast Fourier Transform

## What computation does an 8-point FFT actually perform?

Instead of computing numbers, this program builds the FFT as a circuit: a
shared network of additions and multiplications by roots of unity. The program
comes from Clocksin's *Clause and Effect* (Chapter 10).

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=fast-fourier-transform) ·
[Source](../fast-fourier-transform.pl)

---

# The question

The **discrete Fourier transform** evaluates a polynomial with coefficients
`a0 … a7` at the eight powers `w^0 … w^7` of a root of unity `w`. The **Fast
Fourier Transform** gets its speed from reuse: split the coefficients into
even and odd positions, solve both halves once, and share the results. This
program makes that sharing visible by generating the computation graph.

---

# Divide and conquer

```prolog
eval(p([I], _), a(I), _).
eval(p(L, V^P), A1+V^P*A2, N) :-
    alternate(L, L1, L2),
    P1 is (P*2) mod N,
    eval(p(L1, V^P1), A1, N),
    eval(p(L2, V^P1), A2, N).

alternate([], [], []).
alternate([A, B|T], [A|T1], [B|T2]) :-
    alternate(T, T1, T2).
```

`eval/3` writes `p(x) = p_even(x^2) + x * p_odd(x^2)` as a rule: split the
coefficients with `alternate/3`, square the point, and recurse on both halves.
The result is a symbolic expression, not a number.

---

# Sharing common subexpressions

```prolog
node(n(1, N), []-[n(1, N)]) :-
    !.
node(N, L-L) :-
    memberchk(N, L),
    !.
node(n(A1, N1), [n(A, N)|T]-[n(A1, N1), n(A, N)|T]) :-
    A1 is A+1.
```

`gen/3` flattens the eight expressions into numbered nodes, threading a
difference list. `node/2` reuses a node that already exists (`memberchk/2`) and
only otherwise allocates a new number. That reuse is exactly the saving the
FFT is known for.

---

# The answer

```sh
eyeprolog examples/fast-fourier-transform.pl
```

```text
fft([0, 1, 2, 3, 4, 5, 6, 7], [n(64, op(+, 49, 63)), n(63, op(*, 62, 52)), n(62, w ^ 7), …, n(3, a(4)), n(2, w ^ 0), n(1, a(0))]).
```

(Shortened; the output is one answer, a list of 64 nodes.) Leaves such as
`a(4)` are coefficients and `w ^ 7` is a power of the root of unity. Every
other node is an `op(+, …)` or `op(*, …)` over earlier node numbers, so the
whole transform is a 64-node shared circuit.

---

# The reason

```text
step(alternate([0, 1, 2, 3, 4, 5, 6, 7], [0, 2, 4, 6], [1, 3, 5, 7]),
     rule(5),
     ['A' = 0, 'B' = 1, 'T' = [2, 3, 4, 5, 6, 7], 'T1' = [2, 4, 6], 'T2' = [3, 5, 7]],
     [alternate([2, 3, 4, 5, 6, 7], [2, 4, 6], [3, 5, 7])]).
step(node(n(1, a(0)), [] - [n(1, a(0))]), rule(10), ['N' = a(0)], "!").
```

The first step splits the eight coefficients into even and odd positions. The
second allocates the very first node; its single use is the cut, which the
proof records like any other goal.

---

# The check

```text
condition('C1', resolution, ok, 485).
condition('C5', re_decision, ok, 224).
condition('C7', relevance, ok, 710).
verdict(checked).
```

All 709 steps check: 485 rule steps replay, and 224 built-in steps (the
arithmetic, `memberchk/2`, and cuts) are recomputed. Nothing is trusted, even
though the program uses cuts and difference lists.

---

# Try it

- Count how many nodes are `op(*, …)` and how many are `op(+, …)`. Compare
  with the 8 × 8 = 64 multiplications of the naive transform.
- Remove the `memberchk/2` clause of `node/2`. How much larger does the
  circuit become without sharing?
- Run it on 4 coefficients by changing `fft/2` to evaluate at `w^0 … w^3` with
  `N = 4`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 22 and 28.
