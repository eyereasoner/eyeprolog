# Herbrand semantics

## Can two different names mean the same thing?

In ordinary logic, `alice` and `bob` might name the same person unless an
axiom says otherwise. In EyeProlog every ground term denotes itself, so
different spellings are different things. This small example makes that
property visible, and EyeProlog proves both claims and checks the proof.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=herbrand-semantics) ·
[Source](../herbrand-semantics.pl)

---

# The question

Are `alice` and `bob` different? Are `ticket(alice)` and `ticket(bob)`
different?

Under general (Tarskian) semantics the answer is "not necessarily": two names
may denote one object, and a function such as `ticket` need not give different
results for different arguments. Under Herbrand semantics the answer is "yes",
because terms are their own meaning.

---

# The rules

```prolog
different(alice, bob) :-
  (alice \= bob).

different(ticket(alice), ticket(bob)) :-
  (ticket(alice) \= ticket(bob)).
```

`\=` succeeds when two terms cannot be unified. Distinct atoms never unify,
and compound terms unify only when their functor and every argument agree.
So no extra "unique names" or "free constructor" axioms are needed.

---

# The answer

```sh
eyeprolog examples/herbrand-semantics.pl
```

```text
different(alice, bob).
different(ticket(alice), ticket(bob)).
```

Both claims hold, purely from the syntax of the terms.

---

# The reason

```sh
eyeprolog --proof examples/herbrand-semantics.pl
```

```text
step(different(alice, bob), rule(1), [], [alice \= bob]).
step(alice \= bob, builtin, [], []).
```

The first claim follows from rule 1, which uses one subgoal, `alice \= bob`.
That subgoal is a built-in test, so its step cites `builtin` instead of a
clause.

---

# The check

```text
condition('C1', resolution, ok, 2).
condition('C5', re_decision, ok, 2).
condition('C7', relevance, ok, 6).
verdict(checked).
```

The checker replays the two rule steps against their clauses (C1) and
recomputes the two built-in tests itself, in a program that contains none of
the example's clauses (C5). Both agree, so nothing is left on trust.

---

# Try it

- Add `different(robert, bob) :- (robert \= bob).` It succeeds even if Robert
  and Bob are the same person: the logic only sees two different atoms. To
  say they are the same, add a domain relation such as `same_as(robert, bob)`.
- Try `different(alice, alice) :- (alice \= alice).` and predict the output.
- Compare with [`herbrand-witnesses`](herbrand-witnesses.md), which uses the
  same property to build distinct witness terms.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 3.
