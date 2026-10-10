# Cat Koko

## How do you say "there is a cat" without naming the cat?

Koko is an animal, and the rules conclude that there is some cat and some
British Shorthair. Logic calls these existential claims. EyeProlog has no
anonymous objects, so the program names the two unknown individuals with
explicit witness terms and proves that they are different.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=cat-koko) ·
[Source](../cat-koko.pl)

---

# The question

The original rule says: if Koko is an animal, then *there exists* something
that is a cat and *there exists* something that is a British Shorthair. A rule
head cannot invent a fresh object, so where do those somethings come from?

The answer is to name them. The constants `sk_0` and `sk_1` are **Skolem
witnesses**: stand-ins for "the individual the claim is about".

---

# The program

```prolog
animal(koko).
witness(cat, sk_0).
witness(british_short_hair, sk_1).

type(X, cat) :- animal(koko), witness(cat, X).
type(X, british_short_hair) :- animal(koko), witness(british_short_hair, X).

holds_result(test, true) :-
  type(X, cat),
  type(Y, british_short_hair),
  (X \= Y).
```

The witnesses are ordinary facts, so they appear in answers and proofs. The
test checks that the two existentials were given distinct names.

---

# The answer

```sh
eyeprolog examples/cat-koko.pl
```

```text
type(sk_0, cat).
type(sk_1, british_short_hair).
holds_result(test, true).
```

---

# The reason

```text
step(type(sk_0, cat), rule(4), ['X' = sk_0], [animal(koko), witness(cat, sk_0)]).
step(holds_result(test, true),
     rule(6),
     ['X' = sk_0, 'Y' = sk_1],
     [type(sk_0, cat), type(sk_1, british_short_hair), sk_0 \= sk_1]).
step(sk_0 \= sk_1, builtin, [], []).
```

`sk_0` is a cat because Koko is an animal and `sk_0` is the cat witness. The
test holds because the two witnesses are different terms, and in Prolog
distinct constants never unify.

---

# The check

```text
condition('C1', resolution, ok, 6).
condition('C5', re_decision, ok, 1).
trusted(0).
verdict(checked).
```

Six rule steps replayed, one built-in comparison recomputed, nothing trusted.

---

# Try it

- Give both claims the same witness, `sk_0`. Both `type/2` answers remain, but
  `holds_result(test, true)` disappears: the cat and the British Shorthair are
  now the same individual.
- Replace the witness facts with function terms such as `cat_of(koko)`. What
  does that say that a bare constant does not?
- Why is `X \= Y` a safe test here, but not before `X` and `Y` are bound?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 3.
