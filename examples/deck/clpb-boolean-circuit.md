# A Boolean circuit

## Does this gate network really compute XOR?

An exclusive-or built from NOT, AND and OR gates is checked two ways: by
listing its whole truth table, and by asking the CLP(B) Boolean constraint
solver to prove that it equals the XOR specification for every input at once.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=clpb-boolean-circuit) ·
[Source](../clpb-boolean-circuit.pl)

---

# The question

XOR is true when exactly one of its two inputs is true. The circuit computes
`(X and not Y) or (not X and Y)`. Is that the same function?

Testing four rows answers it for two inputs. A tautology check answers it
symbolically, which is the method that scales to circuits too big to tabulate.

---

# The circuit as a constraint

```prolog
:- use_module(library(clpb)).

xor_circuit(X, Y, Z) :-
  sat(Z =:= ((X * ~Y) + (~X * Y))).
```

In `library(clpb)`, `*` is AND, `+` is OR, `~` is NOT and `=:=` is equality
between Boolean formulas. `sat/1` posts the formula as a constraint on the
variables instead of evaluating it, so the relation works in every direction.

---

# Two questions

```prolog
xor_row(row(X, Y, Z)) :-
  xor_circuit(X, Y, Z),
  labeling([X, Y, Z]).

xor_circuit_verified(T) :-
  taut((x#y) =:= ((x * ~y) + (~x * y)), T).
```

`labeling/1` enumerates the 0/1 assignments that satisfy the constraint, one
truth-table row each. `taut/2` asks whether a formula is always true (`T = 1`)
or always false (`T = 0`). The lowercase atoms `x` and `y` stand for
universally quantified inputs, and `#` is the built-in XOR.

---

# The answer

```sh
eyeprolog examples/clpb-boolean-circuit.pl
```

```text
xor_row(row(0, 0, 0)).
xor_row(row(1, 1, 0)).
xor_row(row(0, 1, 1)).
xor_row(row(1, 0, 1)).
xor_circuit_verified(1).
```

The output is 1 exactly when the inputs differ, and the tautology check
returns `1`: the circuit and the specification agree for all inputs.

---

# The reason

```sh
eyeprolog --proof examples/clpb-boolean-circuit.pl
```

```text
step(xor_row(row(1, 0, 1)),
     rule(2),
     ['X' = 1, 'Y' = 0, 'Z' = 1],
     [xor_circuit(1, 0, 1), labeling([1, 0, 1])]).
step(xor_circuit(1, 0, 1), rule(1), ['X' = 1, 'Y' = 0, 'Z' = 1], [sat(1 =:= 1 * ~ 0 + ~ 1 * 0)]).
step(taut(x # y =:= x * ~ y + ~ x * y, 1), builtin, [], []).
```

The row `1, 0, 1` holds because the circuit constraint is satisfied with those
values. The tautology result is a `builtin` step: it rests on the Boolean
solver's answer.

---

# The check

```text
condition('C1', resolution, ok, 9).
condition('C5', re_decision, ok, 4).
obligation(builtin, stateful, sat(1 =:= 1 * ~ 0 + ~ 1 * 0)).
obligation(builtin, stateful, taut(x # y =:= x * ~ y + ~ x * y, 1)).
verdict(checked_with_obligations).
```

The 9 rule steps replay exactly, and 4 built-in steps are recomputed. The
`sat/1` and `taut/2` steps depend on the constraint solver's internal state, so
the checker cannot simply rerun them; it lists them as **obligations**, five in
all, that the proof rests on. The verdict says so: checked, with obligations.

---

# Try it

- Replace the circuit in `xor_circuit_verified/1` by `(x * y) + (~x * ~y)` (that
  is XNOR). The check now returns `0`: the formulas disagree on every input.
- Ask `xor_circuit(X, Y, 1)` with labeling and confirm only the two
  differing-input rows remain.
- Build a half adder (sum and carry) and verify both outputs with `taut/2`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 39 (`library(clpb)`) and Chapter 29.
