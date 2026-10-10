# Defeasible reasoning

## Which travel expenses get reimbursed, and what happens when two policies both claim one?

Expense policies are layered: a default, an exception, and sometimes an
exception to the exception. This example models those layers with ordinary
negation as failure, then turns to a harder case: two policies that both apply
and nothing says which one wins.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=defeasible-reasoning) ·
[Source](../defeasible-reasoning.pl)

---

# The question

A rule is **defeasible** when it holds by default but can be overridden by a
more specific rule. "Expenses are reimbursable" is a default; "except alcohol"
overrides it; "except alcohol preapproved for client entertainment" overrides
the override.

Four expenses come in: a taxi, a client dinner with wine, the same dinner with
manager preapproval, and a team offsite hotel that qualifies for two different
reimbursement schemes. What is decided for each?

---

# Default, exception, exception to the exception

```prolog
excluded(Expense) :-
  category(Expense, alcohol),
  \+ preapproved_entertainment(Expense).

reimbursable(Expense) :-
  submitted(Expense),
  \+ excluded(Expense).
```

Each rule negates only a layer that is already fully computed below it. That
is **stratified** negation, and plain ISO `\+/1` handles it: no special
machinery, and the answer is the same on any Prolog.

---

# A conflict with no winner

```prolog
covered_by_blanket(Expense) :-
  blanket_eligible(Expense),
  tnot(itemized(Expense)).
itemized(Expense) :-
  itemizable(Expense),
  tnot(covered_by_blanket(Expense)).

policy_conflict(Expense, blanket_allowance, itemized_reimbursement) :-
  blanket_eligible(Expense),
  itemizable(Expense).
```

The hotel is eligible for both a flat blanket allowance and itemized
reimbursement, and each scheme is written as "unless the other applies". With
`tnot/1`, EyeProlog evaluates this cycle under the **well-founded semantics**
and calls both sides *undefined*. `policy_conflict/3` takes the plainer route:
it simply names the conflict.

---

# The answer

```sh
eyeprolog examples/defeasible-reasoning.pl
```

```text
reimbursementQuestion(plain, taxi_receipt, true).
reimbursementQuestion(alcohol_excluded, client_dinner_wine, false).
reimbursementQuestion(alcohol_preapproved, client_dinner_wine_preapproved, true).
conflictQuestion(blanket_allowance, team_offsite_hotel, undefined).
conflictQuestion(itemized_reimbursement, team_offsite_hotel, undefined).
explicitConflictQuestion(team_offsite_hotel, blanket_allowance, itemized_reimbursement).
```

The taxi is paid, the wine is not, and the preapproved wine is. The hotel is
*undefined* under both schemes, honestly, because the policies do not settle
it. The explicit conflict says the same thing as an ordinary fact anyone can
query.

---

# The reason

```sh
eyeprolog --proof examples/defeasible-reasoning.pl
```

```text
step(wfs_truth(reimbursable(client_dinner_wine), false), builtin, [], []).
step(policy_conflict(team_offsite_hotel, blanket_allowance, itemized_reimbursement),
     rule(14),
     ['Expense' = team_offsite_hotel],
     [blanket_eligible(team_offsite_hotel), itemizable(team_offsite_hotel)]).
```

The verdicts come from `wfs_truth/2`, recorded as one built-in step each. The
explicit conflict, by contrast, has an ordinary proof: rule 14 and the two
eligibility facts.

---

# The check

```sh
eyeprolog --proof examples/defeasible-reasoning.pl > defeasible.why.pl
eyeprolog --check-proof defeasible.why.pl examples/defeasible-reasoning.pl
```

```text
condition('C1', resolution, ok, 9).
obligation(builtin, theory_scoped, wfs_truth(reimbursable(client_dinner_wine), false)).
obligation(builtin, theory_scoped, wfs_truth(covered_by_blanket(team_offsite_hotel), undefined)).
trusted(5).
verdict(checked_with_obligations).
```

All 9 clause steps replay. The 5 `wfs_truth/2` steps are **obligations**: they
ask about the truth of this program's own predicates, so the checker cannot
recompute them in isolation. Only the explicit conflict is fully checked
without such an assumption, which is one argument for writing conflicts that
way.

---

# Try it

- Delete the `preapproved_entertainment` fact. The run stops with
  `existence_error(procedure)` after the first answer, because
  `preapproved_entertainment/1` no longer exists at all. How would you declare
  an empty exception list instead?
- Replace both `tnot/1` calls with `\+` and run with `--warnings`. EyeProlog
  reports the unstratified negation cycle, prints the three ordinary verdicts,
  and then fails with `resource_error(stack)` on the circular pair.
- Add a company rule that itemized reimbursement wins. Which predicate should
  change, and does the conflict disappear?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 7.
