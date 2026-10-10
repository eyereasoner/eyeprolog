# Workplace compliance

## Which employees followed the end-of-shift policy?

A small policy classifies employees from what they were observed doing: work
tasks must be followed by logging off, and social media is not allowed. The
example shows how a policy that relies on *not* having seen something stays
honest about that assumption.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=workplace-compliance) ·
[Source](../workplace-compliance.pl)

---

# The question

For each employee, is their observed behaviour compliant or non-compliant?

Two of the four rules decide from an **absence**: an employee who logged off
but did no work task, or did a work task but did not log off. "Did not" here
means "was not observed doing", which is only as good as the observation log.

---

# The facts

```prolog
employee(alice).
employee(bob).
employee(carol).
employee(dave).

does(alice, log_off_at_end_of_shift).
does(bob, work_related_task).
does(bob, log_off_at_end_of_shift).
does(carol, access_social_media).
does(dave, work_related_task).
```

Each `does/2` fact records one observed action. The data is explicit, so the
same input always gives the same verdicts.

---

# The rules

```prolog
status(Person, compliant) :-
  employee(Person),
  does(Person, work_related_task),
  does(Person, log_off_at_end_of_shift).

status(Person, compliant) :-
  employee(Person),
  does(Person, log_off_at_end_of_shift),
  \+ does(Person, work_related_task).

status(Person, non_compliant) :-
  employee(Person),
  does(Person, work_related_task),
  \+ does(Person, log_off_at_end_of_shift).

status(Person, non_compliant) :-
  employee(Person),
  does(Person, access_social_media).
```

`\+ Goal` is **negation as failure**: it succeeds when `Goal` cannot be proved
from the facts. `employee(Person)` comes first so that `Person` is bound before
it is negated.

---

# The answer

```sh
eyeprolog examples/workplace-compliance.pl
```

```text
status(bob, compliant).
status(alice, compliant).
status(dave, non_compliant).
status(carol, non_compliant).
```

Bob worked and logged off. Alice logged off with no work task on record. Dave
worked but never logged off, and Carol used social media.

---

# The reason

```sh
eyeprolog --proof examples/workplace-compliance.pl
```

```text
step(status(dave, non_compliant),
     rule(12),
     ['Person' = dave],
     [employee(dave), does(dave, work_related_task), \+ does(dave, log_off_at_end_of_shift)]).
step(does(dave, work_related_task), fact(9), [], []).
step(\+ does(dave, log_off_at_end_of_shift), absent, [], []).
```

Dave is non-compliant by rule 12: he is an employee, a work task is on record
(fact 9), and no log-off is. That last step is marked `absent`: it records that
a finite search found nothing, not that a positive fact was used.

---

# The check

```sh
eyeprolog --proof examples/workplace-compliance.pl > wc.why.pl
eyeprolog --check-proof wc.why.pl examples/workplace-compliance.pl
```

```text
condition('C1', resolution, ok, 13).
condition('C6', boundary_consistency, ok, 2).
obligation(absent, theory_scoped, \+ does(alice, work_related_task)).
obligation(absent, theory_scoped, \+ does(dave, log_off_at_end_of_shift)).
verdict(checked_with_obligations).
```

Thirteen steps replay against their clauses. The two absences cannot be
replayed, so they become **obligations**: the verdicts for Alice and Dave hold
only if the observation log is complete. The checker compared each absence with
the `does/2` facts it could see and found no contradiction, so the verdict is
`checked_with_obligations`.

---

# Try it

- Add `does(dave, log_off_at_end_of_shift).` and run it again. Dave becomes
  compliant, and his obligation disappears from the check.
- Add `does(carol, log_off_at_end_of_shift).` instead. Carol is now reported as
  both `compliant` and `non_compliant`. Which rule would you change so that the
  social-media rule always wins?
- Add `employee(erin).` with no actions. Erin gets no status at all. Is that the
  right outcome for an employee nobody observed?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 7 and 12.
