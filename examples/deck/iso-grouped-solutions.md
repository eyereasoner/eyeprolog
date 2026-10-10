# ISO grouped solutions

## How do you turn many answers into one list, or one list per group?

Four sales records, two regions, and a duplicate. Standard Prolog has three
ways to collect the answers of a goal: one flat list, one list per group, or
one sorted set per group. This example uses each, and also reads a clause
back from the program itself.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=iso-grouped-solutions) ·
[Source](../iso-grouped-solutions.pl)

---

# The question

What are all the sale amounts? What is the total per region? Which regions
have sales at all? And is the record `sale(north, ada, 7)` really part of the
program?

---

# The sales

```prolog
:- dynamic(sale/3).

sale(north, ada, 7).
sale(north, ada, 7).
sale(north, ben, 5).
sale(south, clara, 9).
```

Ada's sale is recorded twice: a duplicate is a fact in its own right, and
collections keep it. `sale/3` is declared dynamic so that `clause/2` may
inspect it.

---

# Three collectors

```prolog
regional_total(Region, Total) :-
  bagof(Amount, Seller^sale(Region, Seller, Amount), Amounts),
  sum_amounts(Amounts, Total).

report(all_amounts, Amounts) :-
  findall(Amount, sale(_, _, Amount), Amounts).

report(regions, Regions) :-
  setof(Region, Seller^Amount^sale(Region, Seller, Amount), Regions).
```

`findall/3` gives one list of every answer. `bagof/3` gives one list for each
binding of the variables that are free in the goal, here `Region`. `Seller^`
says "for some seller", so sellers do not split the groups. `setof/3` does the
same and then sorts and removes duplicates.

---

# The answer

```sh
eyeprolog examples/iso-grouped-solutions.pl
```

```text
report(all_amounts, [7, 7, 5, 9]).
report(regional_total(north), 19).
report(regional_total(south), 9).
report(regions, [north, south]).
report(source_clause, visible).
```

The flat list keeps both sevens. `bagof/3` answers once per region, and the
north total counts Ada's sale twice. `setof/3` lists each region once.

---

# The reason

```sh
eyeprolog --proof examples/iso-grouped-solutions.pl
```

```text
step(regional_total(north, 19),
     rule(6),
     ['Region' = north, 'Total' = 19, 'Amounts' = [7, 7, 5]],
     [bagof(Amount, Seller ^ sale(north, Seller, Amount), [7, 7, 5]),
      sum_amounts([7, 7, 5], 19)]).
```

The north total holds by rule 6: `bagof/3` produced `[7, 7, 5]` for the
north group, and the recursive `sum_amounts/2` added it up to 19, with each
addition recorded as its own step.

---

# The check

```text
condition('C1', resolution, ok, 12).
condition('C5', re_decision, ok, 4).
obligation(builtin, theory_scoped, bagof(A, B ^ sale(north, B, A), [7, 7, 5])).
obligation(builtin, reflective, clause(sale(north, ada, 7), true)).
trusted(5).
verdict(checked_with_obligations).
```

Twelve rule steps replay and four additions are recomputed. The collections
range over the program's own `sale/3` facts, and `clause/2` reads the
program's database, so the checker cannot redo them in isolation: they are
five named **obligations**, `theory_scoped` for the collectors and
`reflective` for `clause/2`.

---

# Try it

- Remove `Seller^` from `regional_total/2`. The north group splits by
  seller, and you get two north totals, 14 for Ada and 5 for Ben.
- Remove `Seller^Amount^` from the `setof/3` call and predict the
  `regions` answers.
- Add `sale(east, dan, 4).` and say which reports change.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 8 and 34.
