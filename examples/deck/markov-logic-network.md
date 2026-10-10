# Markov logic, one world at a time

## Which possible world best fits soft, weighted rules?

A Markov Logic Network attaches weights to rules that are usually, not always,
true. This example shows the core of the most-probable-world (MAP) question
without probability machinery: list the candidate worlds, score each by the
weights of the rules it satisfies, and pick the best.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=markov-logic-network) ·
[Source](../markov-logic-network.pl)

---

# The question

Alice smokes, and Alice is Bob's friend. Three soft rules apply:

- friends of smokers tend to smoke (weight 2.0);
- smoking tends to cause cancer (weight 1.3);
- cancer is rare (weight 0.6).

Bob's smoking and cancer status are unknown. Of the four possible worlds,
which scores highest?

---

# The model

```prolog
candidate_world(w_bob_not_smokes_not_cancer, no, no).
candidate_world(w_bob_not_smokes_cancer, no, yes).
candidate_world(w_bob_smokes_not_cancer, yes, no).
candidate_world(w_bob_smokes_cancer, yes, yes).

formula_weight_tenths(friend_smoking, 20).
formula_weight_tenths(smoking_causes_cancer, 13).
formula_weight_tenths(cancer_is_rare, 6).
```

Weights are stored as integer tenths so the scores are exact, with no
floating-point noise.

---

# The rules

```prolog
world_score_tenths(World, Score) :-
  candidate_world(World, _, _),
  sumall(Weight, contribution_tenths(World, _Formula, Weight), Score).

map_world(World, Score) :-
  aggregate_max(Candidate_score, Candidate_world,
    world_score_tenths(Candidate_world, Candidate_score),
    Score, World).
```

A world's score is the sum of the weights of the soft formulas it satisfies.
The MAP world is the one with the maximum score.

---

# The answer

```sh
eyeprolog examples/markov-logic-network.pl
```

```text
mlnWorldScore(w_bob_not_smokes_not_cancer, log_weight_tenths(19)).
mlnWorldScore(w_bob_not_smokes_cancer, log_weight_tenths(13)).
mlnWorldScore(w_bob_smokes_not_cancer, log_weight_tenths(26)).
mlnWorldScore(w_bob_smokes_cancer, log_weight_tenths(33)).
mlnMapWorld(w_bob_smokes_cancer, log_weight_tenths(33)).
mlnConclusion(case, "MAP world predicts that Bob smokes and has cancer").
```

These are the last 6 of 32 answers; the others list the weights, the worlds,
and which formulas each world satisfies or violates. The world in which Bob
smokes and has cancer wins with 3.3: it satisfies the two heavier rules and
gives up only "cancer is rare".

---

# The reason

```text
step(map_world(w_bob_smokes_cancer, 33),
     rule(22),
     ['World' = w_bob_smokes_cancer, 'Score' = 33],
     [aggregate_max(Key, Value, world_score_tenths(Value, Key), 33, w_bob_smokes_cancer)]).
step(world_score_tenths(w_bob_smokes_cancer, 33),
     rule(21),
     ['World' = w_bob_smokes_cancer, 'Score' = 33],
     [candidate_world(w_bob_smokes_cancer, yes, yes),
      sumall(Expression, contribution_tenths(w_bob_smokes_cancer, _Formula, Expression), 33)]).
```

The winning world's score is a `sumall/3` over its satisfied formulas, and the
choice is an `aggregate_max/5` over all four world scores.

---

# The check

```text
condition('C1', resolution, ok, 70).
condition('C6', boundary_consistency, ok, 5).
condition('C7', relevance, ok, 112).
steps(80).
verified(70).
trusted(10).
verdict(checked_with_obligations).
```

70 steps replay exactly. Ten are trusted and listed as obligations: five
"this formula is not satisfied in this world" tests (`\+`), and five
aggregates (the four `sumall/3` scores and the `aggregate_max/5`). The checker
did test the five absences against the evidence it has and found none of them
contradicted (C6 decided all five).

---

# Try it

- Raise the weight of `cancer_is_rare` to 25. Which world wins now?
- Add a hard constraint, such as "Bob does not smoke", by deleting the worlds
  that violate it. How does the conclusion change?
- Add a third person, Carol, who is Bob's friend. How many candidate worlds do
  you need, and why does this explicit enumeration stop scaling?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 8.
