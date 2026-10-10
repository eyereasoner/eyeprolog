# The zebra puzzle

## Who drinks water, and who owns the zebra?

Five houses in a row, each with a colour, an owner's nationality, a pet, a
drink and a brand of cigarettes. Fourteen clues pin everything down. EyeProlog
states the clues as constraints on one list of houses and lets unification and
search fill in the rest.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=zebra) ·
[Source](../zebra.pl)

---

# The question

Given clues such as "the Englishman lives in the red house" and "the Norwegian
lives next to the blue house", which nationality drinks water and which owns
the zebra?

Neither water nor the zebra is mentioned in any clue. The answer has to fall
out of everything else.

---

# The model

```prolog
zebra(Waterdrinker, Zebraowner) :-
  (Houses = [_, _, _, _, _]),
  first(Houses, house(_, norwegian, _, _, _)),
  third(Houses, house(_, _, _, milk, _)),
  adjacent(house(_, norwegian, _, _, _), house(blue, _, _, _, _), Houses),
  next_to(house(ivory, _, _, _, _), house(green, _, _, _, _), Houses),
  member(house(red, english, _, _, _), Houses),
  member(house(green, _, _, coffee, _), Houses),
  member(house(yellow, _, _, _, kools), Houses),
  member(house(_, spanish, dog, _, _), Houses),
  ...
  member(house(_, Waterdrinker, _, water, _), Houses),
  member(house(_, Zebraowner, zebra, _, _), Houses).
```

(The full rule has all fourteen clues.) Each house is a term
`house(Colour, Nationality, Pet, Drink, Cigarette)` with unknown parts left as
variables. Every clue either places a partly known house in the list or relates
two neighbouring houses.

---

# The helpers

```prolog
first([X|_], X).
third([_, _, X|_], X).

adjacent(A, B, List) :- next_to(A, B, List).
adjacent(A, B, List) :- next_to(B, A, List).

next_to(X, Y, [X, Y|_]).
next_to(X, Y, [_|Zs]) :- next_to(X, Y, Zs).
```

`next_to/3` means "immediately to the left of"; `adjacent/3` allows either
side. Each clue is a small relation, so the main rule reads like the puzzle
text.

---

# The answer

```sh
eyeprolog examples/zebra.pl
```

```text
waterDrinker(zebraPuzzle, norwegian).
zebraOwner(zebraPuzzle, japanese).
solved(zebraPuzzle, true).
```

The Norwegian drinks water and the Japanese owns the zebra. The search finds
exactly one consistent street.

---

# The reason

```sh
eyeprolog --proof examples/zebra.pl
```

```text
step(waterDrinker(zebraPuzzle, norwegian),
     rule(8),
     ['Waterdrinker' = norwegian],
     [zebra(norwegian, japanese)]).
```

The answer comes from rule 8 and rests on one solved `zebra/2` call. The next
step in the proof binds the whole street:

```text
      'Houses' = [house(yellow, norwegian, fox, water, kools), house(blue, ukrainian, horse, tea, chesterfields), house(red, english, snail, milk, old_gold), house(ivory, spanish, dog, orange_juice, lucky_strike), house(green, japanese, zebra, coffee, parliaments)]],
```

and then lists one use per clue, each showing that this street satisfies it.

---

# The check

```sh
eyeprolog --proof examples/zebra.pl > zebra.why.pl
eyeprolog --check-proof zebra.why.pl examples/zebra.pl
```

```text
condition('C1', resolution, ok, 13).
condition('C5', re_decision, ok, 6).
condition('C7', relevance, ok, 22).
verdict(checked).
```

Of 19 steps, 13 replay against program clauses and 6 built-in steps (the
`=/2` and library `member/2` calls) are recomputed independently. Nothing is
taken on trust, so the verdict is `checked`: the street in the proof really
satisfies every clue.

---

# Try it

- Ask for the whole street directly with `--goal 'zebra(W, Z)'`.
- Delete the clue `member(house(_, japanese, _, _, parliaments), Houses)`.
  Five different water-drinker/zebra-owner pairs now fit. Which clues would you
  need to add back to get a unique answer again?
- Move the two `member/2` goals that mention water and the zebra to the top of
  the rule. Do the answers change? Does the search get faster or slower?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 10.
