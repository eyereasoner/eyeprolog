# Illegitimate reasoning

## Can a program spot a bad argument?

"If it rained, the street is wet. The street is wet. So it rained." That
sounds reasonable and is wrong. This example describes arguments as data,
recognizes four classic fallacies by their shape, and reports each one with
its conclusion and a short reason, while leaving a valid argument alone.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=illegitimate-reasoning) ·
[Source](../illegitimate-reasoning.pl)

---

# The question

Which of these arguments are illegitimate, which fallacy does each commit,
and why?

- **Affirming the consequent:** from "if A then B" and "B", conclude "A".
- **Denying the antecedent:** from "if A then B" and "not A", conclude "not B".
- **Hasty generalization:** a universal claim from too small a sample.
- **False dilemma:** only two options presented when a third exists.

A fifth argument uses modus ponens ("if A then B", "A", so "B"), which is
valid and must not be flagged.

---

# Arguments as data

```prolog
argument(arg_affirming_consequent).
implication(arg_affirming_consequent, rain, street_wet).
observed(arg_affirming_consequent, street_wet).
concludes(arg_affirming_consequent, rain).

argument(arg_modus_ponens).
implication(arg_modus_ponens, subscription_paid, access_allowed).
observed(arg_modus_ponens, subscription_paid).
concludes(arg_modus_ponens, access_allowed).
```

Each argument is described by its parts: the implication it relies on, what
was observed, and what it concludes. The program reasons *about* arguments;
it does not reason *with* them.

---

# The rules

```prolog
fallacy(A, affirming_consequent) :-
  argument(A),
  implication(A, Antecedent, Consequent),
  observed(A, Consequent),
  concludes(A, Antecedent).

fallacy(A, hasty_generalization) :-
  argument(A),
  sample_size(A, N),
  required_sample_size(A, Min),
  (N < Min),
  concludes(A, all(_, _)).
```

Each fallacy is a pattern over the parts. The modus ponens argument observes
the antecedent and concludes the consequent, so it matches no pattern.

---

# The answer

```sh
eyeprolog examples/illegitimate-reasoning.pl
```

```text
fallacy(arg_affirming_consequent, affirming_consequent).
fallacy(arg_denying_antecedent, denying_antecedent).
fallacy(arg_hasty_generalization, hasty_generalization).
fallacy(arg_false_dilemma, false_dilemma).
type(arg_affirming_consequent, illegitimate_reasoning).
...
```

19 answers in all: four fallacies, their types, conclusions and reasons, plus
the sample sizes and the omitted alternative. `arg_modus_ponens` appears
nowhere.

---

# The reason

```sh
eyeprolog --proof examples/illegitimate-reasoning.pl
```

```text
step(fallacy(arg_affirming_consequent, affirming_consequent),
     rule(26),
     ['A' = arg_affirming_consequent, 'Antecedent' = rain, 'Consequent' = street_wet],
     [argument(arg_affirming_consequent),
      implication(arg_affirming_consequent, rain, street_wet),
      observed(arg_affirming_consequent, street_wet),
      concludes(arg_affirming_consequent, rain)]).
```

The diagnosis cites the exact rule and the four facts that match it: rain
implies a wet street, the street was observed wet, and the argument concluded
rain. A reader can verify the judgement from the evidence alone.

---

# The check

```text
condition('C1', resolution, ok, 39).
condition('C5', re_decision, ok, 1).
condition('C7', relevance, ok, 59).
verdict(checked).
```

39 steps replay against their clauses, and the one built-in comparison
(`3 < 30` for the sample size) is recomputed. Nothing is trusted.

---

# Try it

- Set the required sample size of `arg_hasty_generalization` to 3. The hasty
  generalization disappears from the output, because `3 < 3` fails.
- Add a false-dilemma-shaped argument with no `omitted_alternative/2` fact
  and predict whether it is flagged.
- Add a pattern for *circular reasoning*: an argument that concludes one of
  its own premises.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 14.
