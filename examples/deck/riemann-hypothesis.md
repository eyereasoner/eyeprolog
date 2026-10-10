# The Riemann hypothesis, as a finite check

## Do the zeros in this catalogue lie on the critical line?

The Riemann hypothesis says that every non-trivial zero of the zeta function
has real part ½. It is one of the great open problems in mathematics. This
example does **not** prove it: it checks a small, explicit catalogue of zeros
and says precisely what that check does and does not establish.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=riemann-hypothesis) ·
[Source](../riemann-hypothesis.pl)

---

# The question

The zeta function has *trivial* zeros at −2, −4, −6, … and infinitely many
*non-trivial* zeros in the critical strip, where the real part lies strictly
between 0 and 1. The hypothesis claims all of the non-trivial ones sit exactly
on the line with real part 0.5.

A program can only look at finitely many zeros. So the honest question is:
does this catalogue contain a counterexample?

---

# The catalogue

```prolog
zeta_zero(z1).
real_part(z1, 0.5).
imaginary_part(z1, 14.134725).

zeta_zero(t1).
trivial_zero(t1).
real_part(t1, -2).
imaginary_part(t1, 0).
```

Three non-trivial zeros (`z1`–`z3`, the first three known ones) and one trivial
zero, `t1`, included to show that the rules exclude it.

---

# The rules

```prolog
non_trivial_zero(Zero) :-
  zeta_zero(Zero),
  in_critical_strip(Zero),
  \+ trivial_zero(Zero).

off_critical_line(Zero) :-
  non_trivial_zero(Zero),
  real_part(Zero, Real),
  (Real \= 0.5).

finite_catalog_supports_rh(yes) :-
  catalog_has(non_trivial_zero),
  \+ counterexample_found(yes).
```

A counterexample would be a catalogued non-trivial zero off the line. The
catalogue "supports" the hypothesis only if it has at least one non-trivial
zero and no counterexample. The output says the same in its own words:
`finite_catalog_only`, and "not a proof of RH".

---

# The answer

```sh
eyeprolog examples/riemann-hypothesis.pl
```

```text
rh(scope, finite_catalog_only).
rh(caveat, "finite catalogue evidence only; this is not a proof of RH").
rh(status, no_counterexample_in_catalog).
zero_check(z1, real_part, 0.5).
zero_check(z1, classification, on_critical_line).
```

Twelve answers in all: the three summary rows, and the real part, imaginary
part, and classification of each of the three non-trivial zeros. The trivial
zero `t1` never appears.

---

# The reason

```text
step(finite_catalog_supports_rh(yes),
     rule(28),
     [],
     [catalog_has(non_trivial_zero), \+ counterexample_found(yes)]).
step(non_trivial_zero(z1),
     rule(23),
     ['Zero' = z1],
     [zeta_zero(z1), in_critical_strip(z1), \+ trivial_zero(z1)]).
```

The status rests on two things: the catalogue has a non-trivial zero (`z1`),
and no counterexample could be found. That second premise is an *absence*,
and the check treats it as such.

---

# The check

```text
condition('C6', boundary_consistency, ok, 3).
obligation(absent, theory_scoped, \+ trivial_zero(z1)).
obligation(absent, theory_scoped, \+ counterexample_found(yes)).
trusted(4).
verdict(checked_with_obligations).
```

Every rule step is verified, but four steps are absences ("`z1` is not marked
trivial", "no counterexample was found"). A finite proof cannot show that
something does not exist; it can only show that nothing in *this* program says
otherwise. The verdict `checked_with_obligations` names exactly those
assumptions. That is the gap between a finite check and a theorem, made
explicit.

---

# Try it

- Add `zeta_zero(z4). real_part(z4, 0.4). imaginary_part(z4, 30.0).` The status
  becomes `rh(status, counterexample_in_catalog)`. Would that refute the real
  hypothesis, or only expose a bad catalogue entry?
- Remove `trivial_zero(t1).` Why is `t1` still excluded?
- Add more zeros from a published table. What does the answer establish now,
  and what does it still not establish?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 29 and 30.
