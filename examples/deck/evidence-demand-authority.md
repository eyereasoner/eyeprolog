# A withdrawn evidence demand

## What follows when an authority asks for something it had no power to ask?

An authority demands evidence from a status holder, the deadline passes, and
the demand is withdrawn as one that was never permitted. The example separates
three questions that "never mind" does not settle, and gives each its own
derivation.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=evidence-demand-authority) ·
[Source](../evidence-demand-authority.pl)

---

# The question

Three things need an answer after the withdrawal:

- **Validity:** was the demand ever a real demand?
- **Consequence:** may the missed deadline count against the holder?
- **Evidence:** can a document handed over under the demand still be used?

The model also takes care over one distinction: *not proving* a breach is not
the same as *disproving* one. Ending the status needs a finding, not silence.

---

# The facts

```prolog
may_demand(authority, evidence_of(criminal_record)).
may_demand(authority, evidence_of(identity)).

demanded(authority, holder, evidence_of(continued_conditions), deadline(30)).
withdrawn(authority, evidence_of(continued_conditions), reason(not_permitted_to_ask)).

elapsed(deadline(30)).
produced(holder, document(tenancy_record), under(evidence_of(continued_conditions))).

:- dynamic(breached/2).
```

The authority's powers are listed explicitly. `breached/2` is declared but
empty: asking about a breach is a question with an answer, and the answer is
"none recorded".

---

# The rules

```prolog
demand_validity(Subject, invalid(outside_granted_power)) :-
  demanded(authority, _, Subject, _),
  \+ may_demand(authority, Subject).

termination_ground(missed_deadline(Subject), unavailable(demand_was_invalid)) :-
  demanded(authority, holder, Subject, Deadline),
  elapsed(Deadline),
  demand_validity(Subject, invalid(_)).

admissible(document(D), no(obtained_under_invalid_demand)) :-
  produced(holder, document(D), under(Subject)),
  demand_validity(Subject, invalid(_)).

holder_status(status, retained) :-
  \+ available_ground.
```

The defect is in the asking, so it reaches everything the asking produced. The
status stands unless some ground for ending it is actually available.

---

# The answer

```sh
eyeprolog examples/evidence-demand-authority.pl
```

```text
demand_validity(evidence_of(continued_conditions), invalid(outside_granted_power)).
termination_ground(missed_deadline(evidence_of(continued_conditions)), unavailable(demand_was_invalid)).
admissible(document(tenancy_record), no(obtained_under_invalid_demand)).
holder_status(status, retained).
```

The demand was never valid, so the missed deadline counts for nothing, the
tenancy record cannot be used, and the holder keeps their status.

---

# The reason

```text
step(demand_validity(evidence_of(continued_conditions), invalid(outside_granted_power)),
     rule(11),
     ['Subject' = evidence_of(continued_conditions)],
     [demanded(authority, holder, evidence_of(continued_conditions), deadline(30)),
      \+ may_demand(authority, evidence_of(continued_conditions))]).
step(\+ may_demand(authority, evidence_of(continued_conditions)), absent, [], []).
```

The demand is invalid because it was made and the authority's list of powers
has no matching entry. That absence is recorded as an `absent` step: the
search for a permitting power completed and found none.

---

# The check

```text
condition('C1', resolution, ok, 7).
condition('C6', boundary_consistency, ok, 1).
obligation(absent, theory_scoped, \+ may_demand(authority, evidence_of(continued_conditions))).
obligation(absent, theory_scoped, \+ available_ground).
verdict(checked_with_obligations).
```

The rule steps replay. The two negations cannot be proved by replay, so they
are listed as **obligations**: the conclusions hold *provided* the list of
powers is complete and no termination ground exists. Those are exactly the
assumptions a lawyer would want to see named.

---

# Try it

- Add `may_demand(authority, evidence_of(continued_conditions)).` The demand
  becomes valid, the missed deadline becomes an available ground, the document
  becomes admissible, and the status is terminated.
- Instead, add `breached(holder, lawful_residence).` The demand stays invalid,
  yet the status is still terminated, now on the ground of the breach.
- Why is `breached/2` declared dynamic rather than left undefined?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 7 and 25.
