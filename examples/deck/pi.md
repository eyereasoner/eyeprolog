# Computing π

## How close does the Nilakantha series get to π?

The fifteenth-century Indian mathematician Nilakantha found a series for π
that converges much faster than the better-known Leibniz series. This example
sums it with a ten-thousand-level recursion, and the proof records every
term.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=pi) ·
[Source](../pi.pl)

---

# The question

The Nilakantha series is

π = 3 + 4/(2·3·4) − 4/(4·5·6) + 4/(6·7·8) − …

Summed term by term, how close does it get to π, and can every one of those
thousands of steps be checked?

---

# The program

```prolog
pi(A, B) :-
    pi(1, A, 0, C, 1),
    B is 3+4*C.

pi(A, A, B, B, _) :-
    !.
pi(A, B, C, D, E) :-
    F is A+1,
    L is C+E/(2*A*(2*A+1)*(2*A+2)),
    M is -E,
    pi(F, B, L, D, M).
```

`pi/5` carries a counter, the limit, the running sum, the result, and the
sign. Each recursive call adds one term and flips the sign. When the counter
reaches the limit, the first clause returns the sum, and `pi/2` multiplies it
by 4 and adds 3.

---

# The answer

```sh
eyeprolog examples/pi.pl
```

```text
pi(10000, 3.141592653590042).
```

The true value of π begins 3.141592653589793, so the result is correct to
about twelve decimal places.

---

# The reason

```sh
eyeprolog --proof examples/pi.pl
```

```text
step(pi(10000, 3.141592653590042),
     rule(1),
     ['A' = 10000, 'B' = 3.141592653590042, 'C' = 0.03539816339751046],
     [pi(1, 10000, 0, 0.03539816339751046, 1), 3.141592653590042 is 3 + 4 * 0.03539816339751046]).
```

The answer is 3 + 4 × 0.0353981…, where that sum comes from the recursion.
The next step down adds the first term, 1/(2·3·4) = 0.041666…, and the proof
continues like this through all ten thousand levels.

---

# The check

```text
condition('C1', resolution, ok, 10001).
condition('C5', re_decision, ok, 20002).
steps(30003).
trusted(0).
verdict(checked).
```

The proof has 30,003 steps: 10,001 uses of the program's clauses and 20,002
arithmetic steps, every one recomputed by the checker. A derivation ten
thousand levels deep is replayed in full, with nothing taken on trust.

---

# Try it

- Ask for `pi(10, X)` and `pi(100, X)`. (EyeProlog gives 3.141839618929402
  and 3.1415929035585526.) How many correct digits does each step of ten
  add?
- Write the Leibniz series π/4 = 1 − 1/3 + 1/5 − … in the same style, and
  compare the two at the same number of terms.
- The first clause uses a cut. Is it needed for the answer, or only to stop
  the search from looking further?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 6 and 26.
