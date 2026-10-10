# Linear logic with resources

## Can a rule use each resource exactly once?

Ordinary logic lets a fact be used as often as you like. Linear logic treats
facts as resources that are consumed. This example models that inside Prolog:
it bakes bread from wheat, yeast and heat, and shows that one coin cannot pay
for two purchases.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=linear-logic-resources) ·
[Source](../linear-logic-resources.pl)

---

# The question

A kitchen holds wheat, yeast and heat. Can a three-step plan turn them into
exactly one loaf of bread? And can a wallet with one coin buy both flour and
yeast?

In classical logic the coin could be "used" twice. Linear logic forbids it, and
so must the model.

---

# Resources and rules

```prolog
initial(kitchen, [wheat, yeast, heat]).
initial(wallet, [coin]).

linear_rule(mill, [wheat], [flour]).
linear_rule(mix, [flour, yeast], [dough]).
linear_rule(bake, [dough, heat], [bread]).
linear_rule(buy_flour, [coin], [flour]).
linear_rule(buy_yeast, [coin], [yeast]).
```

A state is a list of resources. Each `linear_rule/3` is an encoded linear
implication: its inputs are used up and its outputs appear.

---

# Consuming resources

```prolog
consume_all([], State, State).
consume_all([Need | Needs], State0, State2) :-
  select(Need, State0, State1),
  consume_all(Needs, State1, State2).

linear_step(State0, Rule, State2) :-
  linear_rule(Rule, Inputs, Outputs),
  consume_all(Inputs, State0, Rest),
  append(Outputs, Rest, State2).
```

`select/3` removes one occurrence of a resource. If the resource is not there,
the step fails. That is the whole "use exactly once" discipline.

---

# The answer

```sh
eyeprolog examples/linear-logic-resources.pl
```

```text
linear_result(kitchen, [mill, mix, bake], [bread]).
linear_check(double_spend_rejected, yes).
```

Milling, mixing and baking leave exactly `[bread]`. And no two-step plan can
buy both flour and yeast with one coin.

---

# The reason

```sh
eyeprolog --proof examples/linear-logic-resources.pl
```

```text
step(linear_check(double_spend_rejected, yes),
     rule(14),
     ['State' = [coin]],
     [initial(wallet, [coin]), \+ run_linear(2, [coin], [buy_flour, buy_yeast], _finalstate)]).
```

The double-spend check holds because the wallet starts with `[coin]` and a
complete search for the plan `[buy_flour, buy_yeast]` found no way to run it.

---

# The check

```text
condition('C6', boundary_consistency, ok, 1).
steps(38).
verified(22).
recomputed(15).
trusted(1).
claims(2).
verdict(checked_with_obligations).
```

The bread plan is fully replayed. The double-spend result rests on one
negation, `\+ run_linear(2, [coin], ...)`, reported as an obligation: a proof
can show that something was derived, but "no plan exists" is the outcome of a
completed search. The checker found no evidence against it.

---

# Try it

- Put two coins in the wallet (`initial(wallet, [coin, coin])`). The
  double-spend check now gives no answer, because both purchases succeed.
- Add a rule `linear_rule(sell, [bread], [coin])` and plan from wheat to coin.
- How would you represent a resource that may be reused, like an oven, in the
  same model?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 24.
