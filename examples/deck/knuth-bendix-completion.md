# Knuth–Bendix completion

## Does every way of simplifying a term lead to the same result?

A **rewrite system** simplifies terms by applying oriented rules such as
"`append(nil, X)` becomes `X`". It is trustworthy when every term reaches the
same final form, its **normal form**, whichever rule is applied first. The
Knuth–Bendix procedure checks this by examining the places where rules
overlap. This example runs a small, bounded version of that check.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=knuth-bendix-completion) ·
[Source](../knuth-bendix-completion.pl)

---

# The question

For three rules about an `append` operation with identity `nil`, do the
selected overlapping cases (**critical pairs**) simplify to the same normal
form, and what is the normal form of a sample term?

Full completion may have to invent new rules and need not terminate. Here the
rules are fixed, and only a small catalog of overlaps is checked.

---

# Rules and one-step rewriting

```prolog
oriented_rule(left_identity, append(nil, X), X).
oriented_rule(right_identity, append(X, nil), X).
oriented_rule(associate_right, append(append(X, Y), Z), append(X, append(Y, Z))).

rewrite_once(In, Out, Rule) :- oriented_rule(Rule, In, Out).
rewrite_once(append(A, B), append(New_a, B), Rule) :- rewrite_once(A, New_a, Rule).
rewrite_once(append(A, B), append(A, New_b), Rule) :- rewrite_once(B, New_b, Rule).
```

Rules are facts. A rewrite step applies a rule at the root of the term or
anywhere inside it. Orienting associativity to the right is what makes
rewriting stop.

---

# Normal forms and joinability

```prolog
normal_form(Term, Term) :- \+ rewrite_once(Term, _, _).
normal_form(Term, Normal) :- rewrite_once(Term, Next, _), normal_form(Next, Normal).

joined_pair(Name) :-
  critical_pair(Name, Left, Right),
  normal_form(Left, Normal),
  normal_form(Right, Normal).
```

A term is in normal form when no rule applies, which is negation as failure
over `rewrite_once/3`. A critical pair **joins** when both sides reach the
same `Normal`: the shared variable demands it.

---

# The answer

```sh
eyeprolog examples/knuth-bendix-completion.pl
```

```text
kbAnswer(sample_normal_form, append(a, append(b, c))).
kbAnswer(joined_critical_pair, left_identity_assoc).
kbAnswer(joined_critical_pair, right_identity_assoc).
kbAnswer(joined_critical_pair, nested_assoc).
kbAnswer(oriented_rule_count, 3).
kbAnswer(joined_critical_pair_count, 3).
kbAnswer(note, "a bounded completion check proves the selected critical pairs join").
```

All three critical pairs join, and the sample term loses its `nil`s and
re-associates to `append(a, append(b, c))`.

---

# The reason

```sh
eyeprolog --proof examples/knuth-bendix-completion.pl
```

```text
step(joined_pair(nested_assoc),
     rule(12),
     ['Name' = nested_assoc,
      'Left' = append(append(a, append(b, c)), d),
      'Right' = append(append(a, b), append(c, d)),
      'Normal' = append(a, append(b, append(c, d)))],
```

The two sides of the nested overlap look different, but both normalize to the
fully right-associated `append(a, append(b, append(c, d)))`. The proof records
each rewrite chain that gets there.

---

# The check

```text
condition('C1', resolution, ok, 47).
obligation(absent, theory_scoped, \+ rewrite_once(append(a, append(b, append(c, d))), A, B)).
obligation(builtin, theory_scoped, countall(joined_pair(A), 3)).
verdict(checked_with_obligations).
```

47 rewrite and rule steps replay against the program. The claims "no rule
applies here", made at each normal form, are **absent** obligations: a proof
can show that something holds, not that nothing does. The checker also tries
to refute them using the program's own facts. The two counts are trusted
library aggregates.

---

# Try it

- Normalize `append(append(a, b), append(nil, c))`. It also ends in
  `append(a, append(b, c))`.
- Count how many rewrite paths lead from the sample term to its normal form
  with `countall/2`. There are 9 paths to the same result, which is
  confluence made visible.
- Add the unoriented rule `append(X, Y) → append(Y, X)` (commutativity). What
  happens to `normal_form/2`, and why does Knuth–Bendix completion struggle
  with commutative rules?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 22.
