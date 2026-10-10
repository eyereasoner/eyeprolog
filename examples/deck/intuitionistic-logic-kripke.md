# Intuitionistic logic with a Kripke model

## When is "p or not p" not automatically true?

In classical logic every statement is true or false. In **intuitionistic**
logic a statement is true only once there is evidence for it, and evidence
can grow over time. This example builds a small Kripke model, a finite
picture of growing knowledge, and shows that excluded middle, "p or not p",
need not hold.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=intuitionistic-logic-kripke) ·
[Source](../intuitionistic-logic-kripke.pl)

---

# The question

Start with no information at a `root` world. Later, you may learn `p` (the
`left` world) or `q` (the `right` world), and eventually both. Which formulas
are already established at the root, and which are not?

---

# The model

```prolog
step(root, left).
step(root, right).
step(left, both).
step(right, both).

base(left, p).
base(right, q).

leq(World, World) :- world(World).
leq(From, To) :- step(From, Mid), leq(Mid, To).
```

`step/2` says how knowledge can grow, and `leq/2` is its reflexive,
transitive closure: "`To` is a possible future of `From`". At `left` we
learn `p`, at `right` we learn `q`.

---

# The rules

```prolog
forces(World, atom(Prop)) :-
  leq(Someworld, World),
  base(Someworld, Prop).

forces(World, implies(Left, Right)) :-
  world(World),
  \+ bad_implication(World, Left, Right).

bad_implication(World, Left, Right) :-
  leq(World, Future),
  forces(Future, Left),
  \+ forces(Future, Right).
```

A world **forces** an atom once the atom was learned there or earlier, so
knowledge persists. An implication holds when no future world has its
premise without its conclusion. `neg(F)` is "F implies `bottom`", and `or`
needs one side established now.

---

# The answer

```sh
eyeprolog examples/intuitionistic-logic-kripke.pl
```

```text
intuitionistic_truth(monotone_p_reaches_both, both, atom(p)).
intuitionistic_truth(constructive_case_analysis, root, implies(atom(p), or(atom(p), atom(q)))).
intuitionistic_truth(double_negated_branch_information, root, neg(neg(or(atom(p), atom(q))))).
intuitionistic_countermodel(root_does_not_decide_branch, root, or(atom(p), atom(q))).
intuitionistic_countermodel(excluded_middle_not_forced, root, or(atom(p), neg(atom(p)))).
```

At the root, "p or q" is not yet established, and neither is "p or not p":
`p` is unknown, yet it is not refuted either, because a future world learns
it. Still, "not not (p or q)" holds: it can never be refuted.

---

# The reason

```sh
eyeprolog --proof examples/intuitionistic-logic-kripke.pl
```

```text
step(intuitionistic_countermodel(excluded_middle_not_forced, root, or(atom(p), neg(atom(p)))),
     rule(24),
     [],
     [\+ forces(root, or(atom(p), neg(atom(p))))]).
step(\+ forces(root, or(atom(p), neg(atom(p)))), absent, [], []).
```

The countermodel claim rests on a failed search: no derivation of
"p or not p" at the root exists. Its step is marked `absent`, a completed
negation that a checker cannot replay as a clause.

---

# The check

```text
condition('C1', resolution, ok, 15).
condition('C6', boundary_consistency, ok, 0).
obligation(absent, theory_scoped, \+ forces(root, or(atom(p), neg(atom(p))))).
verdict(checked_with_obligations).
```

All 15 rule and fact steps replay. The four negations, two `\+ forces` and
two `\+ bad_implication`, are **obligations**: the checker records that the
result depends on these searches having found nothing, and leaves them as
trusted boundaries rather than claiming to have proved them.

---

# Try it

- Add `base(root, p).` so `p` is known from the start. Both countermodel
  answers disappear: with `p` at the root, "p or not p" and "p or q" hold.
- Add a world where `p` is learned later than `left` and predict which
  answers change.
- Check whether `implies(neg(neg(atom(p))), atom(p))` (double-negation
  elimination) is forced at the root.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 7.
