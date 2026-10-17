# Dialogical reasoning

## Can this claim survive an opponent?

A proof can be read as one side of an argument. Here a proponent defends the
claim that a contract is valid, and an opponent challenges every step, grants
what it cannot refute, and brings its own evidence when it has some. A claim
holds when the proponent can answer every challenge.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=dialogical-reasoning) ·
[Source](../dialogical-reasoning.pl)

---

# The question

Bob sold something to Ann under contract `c17`, and Eve sold something to Dave
under contract `c18`. Is each contract valid?

The law of the example: a contract is valid when there was an offer, an
acceptance and consideration, and either **no party was a minor**, or the minor
**ratified the contract after coming of age**.

The question is played out in three rounds, with an opponent who knows more in
each one.

---

# The moves

| Move | Who | Meaning | In a proof |
|---|---|---|---|
| `claims(G)` | proponent | puts `G` forward | a claim |
| `why(G)` | opponent | challenges `G` | C4: every use needs a justification |
| `because(G, R, Ps)` | proponent | answers with rule `R` and premises `Ps` | `step(G, rule(N), …)` |
| `concedes(G)` | opponent | accepts common ground | `step(G, fact(N), …)` |
| `verifies(E)` | opponent | redoes a computation | C5: a builtin decided again |
| `grants(not(G))` | opponent | cannot show `G` | an `absent` obligation |
| `counters(not(G), Ev)` | opponent | shows `G` from evidence `Ev` | C6: an absence refuted |
| `retracts(G, R)` | proponent | drops a defence | — |
| `gives_up(G)` | proponent | has no defence left | — |

The opponent can do more than a proof checker. A checker can only list an
absence as an obligation; an opponent can bring the evidence that refutes it.

---

# The rules

```prolog
rule(r1, valid(C), [offer(C, _, B), accepted(C, B), consideration(C), not(minor_party(C))]).
rule(r2, valid(C), [offer(C, _, B), accepted(C, B), consideration(C), ratified_at_majority(C)]).
rule(r3, minor_party(C), [party(C, P), signed(C, Year), born(P, Born), test(Year - Born < 18)]).
rule(r4, ratified_at_majority(C), [ratified(C, P, Year), born(P, Born), test(Year - Born >= 18)]).
```

The rules are data that both sides argue by. The opponent's own argument uses
the same rules over the case file plus the evidence it holds. The proponent
may use that evidence too, once the opponent has put it forward: this is the
formal rule of Lorenzen's dialogue logic.

---

# The answer, round 1: won, with an obligation

```text
move(1, 3, proponent, because(valid(c17), r1, [offer(c17, bob, ann), accepted(c17, ann), consideration(c17), not(minor_party(c17))])).
move(1, 4, opponent, concedes(offer(c17, bob, ann))).
move(1, 7, opponent, grants(not(minor_party(c17)))).
outcome(1, valid(c17), won).
obligation(1, not(minor_party(c17))).
```

The opponent knows nothing about anyone's age, so it grants that no party was
a minor. The proponent wins, but only for lack of counter-evidence, and the
dialogue says so.

---

# The answer, round 2: countered, then won another way

```text
move(2, 7, opponent, counters(not(minor_party(c17)), [born(ann, 2009)])).
move(2, 8, proponent, retracts(valid(c17), r1)).
move(2, 9, proponent, because(valid(c17), r2, [..., ratified_at_majority(c17)])).
move(2, 14, proponent, because(ratified_at_majority(c17), r4, [ratified(c17, ann, 2028), born(ann, 2009), test(2028 - 2009 >= 18)])).
move(2, 16, opponent, concedes(born(ann, 2009))).
move(2, 17, opponent, verifies(2028 - 2009 >= 18)).
outcome(2, valid(c17), won).
```

Now the opponent shows that Ann was 16 when she signed. The proponent retracts
its first defence and wins with the second, built on the opponent's own
evidence: Ann ratified the contract at 19. No obligation is left.

---

# The answer, round 3: lost

```text
move(3, 7, opponent, counters(not(minor_party(c18)), [born(dave, 2010)])).
move(3, 14, proponent, because(ratified_at_majority(c18), r4, [ratified(c18, unknown(1), unknown(2)), ...])).
move(3, 15, opponent, why(ratified(c18, unknown(1), unknown(2)))).
move(3, 16, proponent, gives_up(ratified(c18, unknown(1), unknown(2)))).
move(3, 20, proponent, gives_up(valid(c18))).
outcome(3, valid(c18), lost).
```

Dave was 14 when he signed and never ratified. The proponent cannot even say
who ratified, or when, so every defence fails.

---

# The reason

```sh
eyeprolog --proof examples/dialogical-reasoning.pl
```

```text
step(\+ opponent_proves(minor_party(c17), 1, __anon7), absent, [], []).
step(opponent_proves(born(ann, 2009), 2, [born(ann, 2009)]),
     rule(53),
     ['Goal' = born(ann, 2009), 'Round' = 2],
     [assertion(born(ann, 2009)), evidence(2, born(ann, 2009))]).
```

The dialogues are themselves derived, so EyeProlog proves them like any other
answer. Round 1's grant is an `absent` step: the opponent searched and found
nothing. Round 2's counter is an ordinary derivation, resting on the evidence
the opponent held for that round.

---

# The check

```text
condition('C1', resolution, ok, 231).
condition('C5', re_decision, ok, 207).
condition('C6', boundary_consistency, ok, 5).
obligation(absent, theory_scoped, \+ opponent_proves(minor_party(c17), 1, A)).
verdict(checked_with_obligations).
```

Among the checker's obligations is exactly what the opponent granted in
round 1: the claim stands provided the opponent had no evidence of a minor.
The checker and the opponent agree on where the argument is open.

---

# Any program, any answer

The dialogue above is written out as a Prolog program. EyeProlog can play one
for any program, defending each answer with its proof against the checker as
opponent:

```sh
eyeprolog --evidence examples/dialogue/evidence.pl examples/dialogue/contract.pl
```

```text
move(1, 7, opponent, counters(\+ minor_party(c17), minor_party(c17), [born(ann, 2009)])).
move(1, 8, proponent, retracts(valid(c17), rule(15))).
outcome(1, valid(c17), won).
outcome(2, valid(c18), lost).
```

[`examples/dialogue/contract.pl`](../dialogue/contract.pl) is this case as a
plain program: `\+ minor_party(C)` instead of `not(...)`, and the evidence in
a file of its own.

---

# Try it

- Give the opponent `evidence(1, born(ann, 2009))`. Which round does round 1
  now look like?
- Add `case_fact(ratified(c18, dave, 2029))`. Who wins round 3?
- Add a rule that a contract for necessities is valid even with a minor, and
  play round 3 again.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 7.
