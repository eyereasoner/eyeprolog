# Deontic logic

## Which duties were broken, which were repaired, and does someone need to review it?

Deontic logic is the logic of obligation and prohibition: what an actor *must*
do and *must not* do. This example keeps the norms separate from what actually
happened, derives the violations, recognizes a repair action, and decides
whether a human should review the case.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=deontic-logic) ·
[Source](../deontic-logic.pl)

---

# The question

Alice handles a personal data record. She was obliged to obtain consent and
prohibited from sharing the record. She shared it anyway, but then notified the
data protection officer (DPO), which the rules accept as compensation for that
breach.

Which violations occurred, which were compensated, and is Alice's case clear or
does it need review?

---

# Norms and observations

```prolog
obliged(alice, obtain_consent).
prohibited(alice, share_record).
compensates(share_record, notify_dpo).

performed(alice, share_record).
performed(alice, notify_dpo).
not_performed(alice, obtain_consent).
not_performed(alice, delete_unneeded_copy).
```

The norms (`obliged`, `prohibited`, `compensates`) and the observations
(`performed`, `not_performed`) are separate facts. Note that a missed action is
recorded positively, as `not_performed`, rather than inferred from silence.

---

# Violations and repairs

```prolog
violation(Actor, missed_obligation(Action)) :-
  obliged(Actor, Action),
  not_performed(Actor, Action).

violation(Actor, prohibited_action(Action)) :-
  prohibited(Actor, Action),
  performed(Actor, Action).

uncompensated_violation(Actor, prohibited_action(Action)) :-
  violation(Actor, prohibited_action(Action)),
  \+ compensated_violation(Actor, Action, _compensation).

status(Actor, requires_review) :-
  uncompensated_violation(Actor, _violation).
```

Two kinds of violation, one rule each. A prohibited action stops counting
against the actor once its configured compensation was performed. A missed
obligation has no compensation and always stays open.

---

# The answer

```sh
eyeprolog examples/deontic-logic.pl
```

```text
violation(alice, missed_obligation(obtain_consent)).
violation(alice, prohibited_action(share_record)).
compensation(alice, compensation(share_record, notify_dpo)).
status(alice, requires_review).
```

Two violations. The sharing was compensated by notifying the DPO, but the
missing consent was not, so the case requires review. `delete_unneeded_copy`
was not performed, but nothing obliged it, so it is no violation.

---

# The reason

```sh
eyeprolog --proof examples/deontic-logic.pl
```

```text
step(status(alice, requires_review),
     rule(17),
     ['Actor' = alice],
     [uncompensated_violation(alice, missed_obligation(obtain_consent))]).
step(uncompensated_violation(alice, missed_obligation(obtain_consent)),
     rule(14),
     ['Actor' = alice, 'Action' = obtain_consent],
     [violation(alice, missed_obligation(obtain_consent))]).
```

The proof shows *why* review is needed: the missing consent, not the sharing.
That matters to a reviewer, who can skip the already-repaired breach.

---

# The check

```sh
eyeprolog --proof examples/deontic-logic.pl > deontic.why.pl
eyeprolog --check-proof deontic.why.pl examples/deontic-logic.pl
```

```text
condition('C1', resolution, ok, 12).
condition('C4', coverage, ok, 15).
steps(12).
verified(12).
trusted(0).
verdict(checked).
```

All 12 steps replay against the program. The proof of `requires_review` goes
through the missed obligation, so it needs no negation at all, and nothing is
taken on trust.

---

# Try it

- Replace `not_performed(alice, obtain_consent).` with
  `performed(alice, obtain_consent).` Only the compensated sharing remains, and
  the `requires_review` status disappears.
- Remove `performed(alice, notify_dpo).` Both violations are now
  uncompensated; ask `--goal 'uncompensated_violation(A, V)'` to see them.
  Does the status line change?
- Add an obligation `obliged(alice, delete_unneeded_copy).` and predict the new
  violations before running.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 7 and 12.
