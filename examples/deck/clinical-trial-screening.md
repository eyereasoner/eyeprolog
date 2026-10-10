# Clinical-trial screening

## Which patients can enter a diabetes trial, and why are the others turned away?

A trial protocol has inclusion criteria that every candidate must meet and
exclusion criteria that veto a candidate anyway. This example screens four
patients and produces both a status and a human-readable reason for each,
the audit trail a trial coordinator needs.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=clinical-trial-screening) ·
[Source](../clinical-trial-screening.pl)

---

# The question

The protocol admits adults with type 2 diabetes whose HbA1c (a three-month
average of blood sugar) lies between 7.0% and 10.5%. It excludes anyone whose
eGFR (a measure of kidney function) is below 45 mL/min, and anyone who is
pregnant.

Who is eligible, who fails screening, and for which reason?

---

# The patients

```prolog
age(p001, 54).
age(p002, 67).
age(p003, 31).
age(p004, 45).

lab(p001, hba1c_pct, 8.4).
lab(p002, hba1c_pct, 7.9).
lab(p003, hba1c_pct, 9.1).
lab(p004, hba1c_pct, 6.4).

lab(p001, egfr_ml_min, 83.0).
lab(p002, egfr_ml_min, 38.0).
lab(p003, egfr_ml_min, 91.0).
lab(p004, egfr_ml_min, 72.0).

condition(p003, pregnant).
```

All four have type 2 diabetes. Each lab value is a separate fact with its
unit in the name, so the rules never guess what a number means.

---

# The criteria

```prolog
inclusion_hba1c(Patient) :-
  lab(Patient, hba1c_pct, Hba1c),
  (Hba1c >= 7.0),
  (Hba1c =< 10.5).

exclusion_renal(Patient) :-
  lab(Patient, egfr_ml_min, Egfr),
  (Egfr < 45.0).

screen_eligible(Patient) :-
  inclusion_adult(Patient),
  inclusion_diagnosis(Patient),
  inclusion_hba1c(Patient),
  \+ exclusion_renal(Patient),
  \+ exclusion_pregnancy(Patient).
```

Each criterion is a named predicate, so it shows up by name in every proof.
Eligibility requires all inclusions and the *absence* of a proven exclusion.

---

# The answer

```sh
eyeprolog examples/clinical-trial-screening.pl
```

```text
type(p001, trial_candidate).
status(p001, eligible).
status(p002, screen_fail).
status(p003, screen_fail).
status(p004, screen_fail).
reason(p001, "meets inclusion criteria and no listed exclusion").
reason(p002, "eGFR below renal safety threshold").
reason(p003, "pregnancy exclusion applies").
reason(p004, "HbA1c is outside protocol range").
```

Only p001 qualifies. Each of the other three fails for a different reason,
and the reason facts say which.

---

# The reason

```sh
eyeprolog --proof examples/clinical-trial-screening.pl
```

```text
step(screen_eligible(p001),
     rule(27),
     ['Patient' = p001],
     [inclusion_adult(p001),
      inclusion_diagnosis(p001),
      inclusion_hba1c(p001),
      \+ exclusion_renal(p001),
      \+ exclusion_pregnancy(p001)]).
step(exclusion_renal(p002),
     rule(25),
     ['Patient' = p002, 'Egfr' = 38.0],
     [lab(p002, egfr_ml_min, 38.0), 38.0 < 45.0]).
```

p001 is eligible because all three inclusions hold and neither exclusion can
be proved. p002 fails because its eGFR of 38.0 is below 45.0, and the proof
points at the exact lab fact.

---

# The check

```text
condition('C1', resolution, ok, 25).
condition('C6', boundary_consistency, ok, 3).
obligation(absent, theory_scoped, \+ exclusion_renal(p001)).
obligation(absent, theory_scoped, \+ exclusion_pregnancy(p001)).
obligation(absent, theory_scoped, \+ inclusion_hba1c(p004)).
verdict(checked_with_obligations).
```

The rule steps replay exactly. Three conclusions rest on something *not*
being provable: that p001 has no renal or pregnancy exclusion, and that p004's
HbA1c is not in range. The checker cannot prove an absence in general, so it
lists these as **obligations**. Condition C6 tested all three against the
program's facts and found nothing that contradicts them.

---

# Try it

- Change p002's eGFR to 50.0. p002 becomes eligible.
- Add a patient with an eGFR of 30.0 and no HbA1c result. Screening now
  reports *two* reasons for the same failure. Is that what a coordinator wants?
- A missing HbA1c counts as "outside protocol range". Change the model so that
  a missing lab result gives its own reason instead.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 7 and Chapter 25.
