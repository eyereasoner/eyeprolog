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
rewriting stop for these constructor terms. The supported input mode is a
finite ground term built from atoms and `append/2`. For a single rewrite,
the recursive calls descend to strict subterms, so this search is finite.
An open first argument can lead to unbounded search; this normalizer is not
a generator of terms.

---

# Normal forms and joinability

```prolog
normal_form(Term, Normal) :-
  ( rewrite_once(Term, Next, _) ->
      normal_form(Next, Normal)
  ; Normal = Term
  ).

joined_pair(Name) :-
  critical_pair(Name, Left, Right),
  normal_form(Left, Normal),
  normal_form(Right, Normal).
```

ISO Prolog's if-then-else (ISO/IEC 13211-1:1995, §7.8.8) tests for a rewrite
once and commits to the first success. If no rewrite exists, the search
finitely fails and the else branch unifies `Normal` with `Term`. If a rewrite
succeeds but the recursive call fails, the else branch is not tried.

The mode is `normal_form(+Term, ?Normal)`, with `Term` ground. The rewrite
condition does not use `Normal`, and the output is unified only in the chosen
branch. Thus supplying all or part of the expected result does not change
the selected path. This property, called **steadfastness**, matters for the
second call in `joined_pair/1`, which checks an already computed normal form.
The commitment has the same effect here as a rewrite followed by ISO cut
(`!`, §7.8.4) before recursion, with a fallback clause after it.

A critical pair **joins** when both sides reach the same `Normal`: the shared
variable demands it. The fixed rules terminate and are confluent on ground
terms, so choosing one path suffices here. Choosing a path does not itself
prove confluence, and checking this catalog does not check every critical pair
of an arbitrary rewrite system.

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
     rule(11),
     ['Name' = nested_assoc,
      'Left' = append(append(a, append(b, c)), d),
      'Right' = append(append(a, b), append(c, d)),
      'Normal' = append(a, append(b, append(c, d)))],
```

The two sides of the nested overlap look different, but both normalize to the
fully right-associated `append(a, append(b, append(c, d)))`. The proof records
the selected rewrite chains. Each if-then-else is a `control` step whose
`Uses` contains the goals of the branch taken. For the terminal else branch,
these include `\+ rewrite_once(Term, Next, Rule)` and `Normal = Term`.

Even with `Term` ground, the failed rewrite query has two unbound variables:
it asks whether **any** next term and rule exist. ISO `\+/1` (§8.15.1) accepts
callable terms without requiring ground arguments. Its success requires the
inner search to finitely fail; it does not mean that a single ground fact
was absent. Groundness requirements for restricted SLDNF or stratified
Datalog do not replace ISO Prolog's operational definition.

---

# The check

```text
condition('C1', resolution, ok, 47).
condition('C5', re_decision, ok, 15).
obligation(absent, theory_scoped, \+ rewrite_once(append(a, append(b, append(c, d))), A, B)).
obligation(builtin, theory_scoped, countall(joined_pair(A), 3)).
verdict(checked_with_obligations).
```

47 rewrite and rule steps replay against the program, 12 `control` steps
are composed from their uses, and 3 equality steps are recomputed.

The proof document labels the terminal finite-failure claims **absent** and
keeps them as trusted obligations. It does not contain the complete failed
search trees, so this check does not independently certify irreducibility.
The checker can reject a contradictory absence using the program's positive
evidence; that is weaker than checking a finite-failure tree. The two counts
are also trusted library aggregates, hence `checked_with_obligations`.

---

# Try it

- Normalize `append(append(a, b), append(nil, c))`. It also ends in
  `append(a, append(b, c))`.
- Collect the solutions of
  `normal_form(append(append(append(a,b),c),d), Normal)` with ISO `findall/3`.
  The list contains `append(a, append(b, append(c, d)))` once. Supply this
  result as the second argument: the check also succeeds once. Supply the
  original reducible term instead: it fails, without falling back to the
  else branch after a successful rewrite.
- Add the unoriented rule `append(X, Y) → append(Y, X)` (commutativity). What
  happens to `normal_form/2`, and why does Knuth–Bendix completion struggle
  with commutative rules?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 22.
