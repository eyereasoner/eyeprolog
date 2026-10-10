# A dog licence rule

## Who has so many dogs that they need a licence?

A municipal rule says that anyone with more than four dogs needs a dog
licence. Applying it means counting, which is an aggregate over all of a
person's dogs, not a property of any single dog. This tiny example shows the
counting pattern and how a proof treats a count.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=dog) ·
[Source](../dog.pl)

---

# The question

Alice has five registered dogs and Bob has two. Who must hold a dog licence?

---

# The facts

```prolog
hasDog(alice, dog1).
hasDog(alice, dog2).
hasDog(alice, dog3).
hasDog(alice, dog4).
hasDog(alice, dog5).
hasDog(bob, dog6).
hasDog(bob, dog7).
```

One fact per dog. Nothing records how many dogs a person has; that has to be
computed.

---

# The rules

```prolog
dogCount(Subject, Count) :-
  hasDog(Subject, _any),
  countall(hasDog(Subject, _dog), Count).

mustHave(Subject, dogLicense) :-
  dogCount(Subject, Count),
  (Count > 4).
```

The first goal of `dogCount/2` picks a dog owner, so the count is taken per
person. `countall/2` counts every solution of `hasDog(Subject, _dog)`. The
licence rule compares the count with the threshold.

---

# The answer

```sh
eyeprolog examples/dog.pl
```

```text
mustHave(alice, dogLicense).
```

Alice has five dogs, which is more than four. Bob, with two, does not need a
licence.

---

# The reason

```sh
eyeprolog --proof examples/dog.pl
```

```text
step(dogCount(alice, 5),
     rule(8),
     ['Subject' = alice, 'Count' = 5],
     [hasDog(alice, dog1), countall(hasDog(alice, _dog), 5)]).
step(countall(hasDog(alice, _dog), 5), builtin, [], []).
step(5 > 4, builtin, [], []).
```

Alice's count of 5 rests on one of her dogs (to select her) and on the
built-in count. Then `5 > 4` gives the licence obligation.

---

# The check

```sh
eyeprolog --proof examples/dog.pl > dog.why.pl
eyeprolog --check-proof dog.why.pl examples/dog.pl
```

```text
condition('C1', resolution, ok, 3).
condition('C4', coverage, ok, 5).
condition('C7', relevance, ok, 6).
obligation(builtin, theory_scoped, countall(hasDog(alice, A), 5)).
verdict(checked_with_obligations).
```

The rule steps replay and `5 > 4` is recomputed. The count itself is an
**obligation**: it depends on the program's own `hasDog/2` facts, so the
checker cannot recompute it in isolation and lists it as an assumption instead.

---

# Try it

- Give Bob three more dogs. Who needs a licence now?
- Change the threshold so that owners of exactly four dogs also need one.
- Remove the first goal, `hasDog(Subject, _any)`, from `dogCount/2` and ask
  `--goal 'mustHave(Who, L)'`. What goes wrong when `Subject` is unbound?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 8 (collecting and choosing answers).
