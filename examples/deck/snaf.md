# Scoped negation as failure

## Is there a person Alice does not hate?

A three-line puzzle about what "not" means in logic programming. Alice loves
Bob, nothing says she hates him, and from that absence the program concludes
that she hates *nobody*, in a precise, limited sense.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=snaf) ·
[Source](../snaf.pl)

---

# The question

Prolog's `\+ Goal` succeeds when `Goal` cannot be proved. That is not the same
as "Goal is false": it means "false *as far as this program knows*". This
example uses that kind of negation and makes its scope visible.

---

# The program

```prolog
loves(alice, bob).
person(bob).

hates(alice, nobody) :-
    person(X),
    \+ hates(alice, X).
```

Read the rule as: Alice hates `nobody` if there is some person she cannot be
shown to hate. The only person is Bob, and no clause concludes
`hates(alice, bob)`.

---

# The answer

```sh
eyeprolog examples/snaf.pl
```

```text
hates(alice, nobody).
```

---

# The reason

```text
step(hates(alice, nobody), rule(3), ['X' = bob], [person(bob), \+ hates(alice, bob)]).
step(person(bob), fact(2), [], []).
step(\+ hates(alice, bob), absent, [], []).
```

The conclusion rests on a person (Bob, fact 2) and an **absence**: the program
does not derive `hates(alice, bob)`. The proof marks that step `absent`
rather than pretending it is a positive fact.

---

# The check

```text
condition('C1', resolution, ok, 2).
obligation(absent, theory_scoped, \+ hates(alice, bob)).
verdict(checked_with_obligations).
```

The rule and the fact are verified. The absence cannot be: no proof can show
that something is unprovable. The checker therefore lists it as an
**obligation**, scoped to this theory. The verdict means: valid, provided this
program really is the whole story about whom Alice hates.

---

# Try it

- Add `hates(alice, bob).` Now Bob is hated, and the run prints nothing.
- Run with `--warnings`. EyeProlog reports `hates/2 depends negatively on
  hates/2`: the predicate refers to its own negation. Why does it still give
  a sensible answer here?
- Add `person(carol).` Does the answer change? Does the proof?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 7.
