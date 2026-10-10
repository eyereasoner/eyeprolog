# GDPR-style compliance

## Is this processing of personal data allowed, and if not, why not?

Two data-processing cases are tested against five requirements inspired by the
EU General Data Protection Regulation. One passes. The other fails, and the
program lists every reason, each with its own proof.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=gdpr-compliance) ·
[Source](../gdpr-compliance.pl)

---

# The question

Processing personal data needs a **legal basis** (such as consent), should use
no more data than necessary (**minimisation**), needs extra **safeguards** for
special categories such as health data, and may send data to a non-EU country
only with an **adequacy decision**.

A useful checker answers "compliant" or "not compliant", and for the second
says exactly which requirement failed.

---

# The cases

```prolog
purpose(case_alpha, care_coordination).
purpose(case_beta, marketing).

legal_basis(case_alpha, explicit_consent).
% case_beta intentionally has no legal basis.

minimized(case_alpha).
not_minimized(case_beta).

special_category(case_alpha, health_data).
special_category(case_beta, health_data).

safeguard(case_alpha, encryption).
safeguard(case_alpha, access_logging).
safeguard(case_beta, encryption).

third_country_transfer(case_beta).
adequacy_decision(case_alpha).
```

---

# The rules

```prolog
compliant(Case) :-
  processing(Case),
  has_required_basis(Case),
  minimized(Case),
  has_health_safeguards(Case),
  transfer_ok(Case).

noncompliance_reason(Case, missing_legal_basis) :-
  processing(Case),
  \+ has_required_basis(Case).

noncompliance_reason(Case, transfer_without_adequacy) :-
  third_country_transfer(Case),
  \+ adequacy_decision(Case).
```

Compliance is the conjunction of all checks. Non-compliance has one rule per
failed requirement, so each reason is derived separately rather than
inferred from the absence of a "yes".

---

# The answer

```sh
eyeprolog examples/gdpr-compliance.pl
```

```text
status(case_alpha, gdpr_compliant).
status(case_beta, gdpr_noncompliant).
reason(case_beta, missing_legal_basis).
reason(case_beta, not_minimized).
reason(case_beta, missing_access_logging).
reason(case_beta, transfer_without_adequacy).
```

---

# The reason

```text
step(noncompliance_reason(case_beta, missing_legal_basis),
     rule(21),
     ['Case' = case_beta],
     [processing(case_beta), \+ has_required_basis(case_beta)]).
step(\+ has_required_basis(case_beta), absent, [], []).
```

`case_beta` lacks a legal basis because it is a processing case and no
legal-basis rule succeeds for it. The second line is an `absent` step: the
record that the search for a legal basis finished and found none.

---

# The check

```text
condition('C1', resolution, ok, 24).
condition('C6', boundary_consistency, ok, 4).
obligation(absent, theory_scoped, \+ has_required_basis(case_beta)).
obligation(absent, theory_scoped, \+ adequacy_decision(case_beta)).
verdict(checked_with_obligations).
```

The 24 rule and fact steps replay. The four "absent" conclusions (no legal
basis, no access logging, no adequacy decision for `case_beta`, no transfer
for `case_alpha`) are obligations. They are right only if the facts are
complete: if a legal basis exists but was not recorded, the verdict changes.
That is the closed-world assumption made visible.

---

# Try it

- Add `legal_basis(case_beta, medical_care).` The `missing_legal_basis`
  reason disappears, but `case_beta` stays non-compliant for its other three
  reasons.
- Add `safeguard(case_beta, access_logging).` Which reasons remain?
- `purpose/2` is recorded but never checked. Write a rule that flags
  marketing as incompatible with health data.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 7 and 25.
