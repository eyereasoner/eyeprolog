# Four colours for Europe

## Does this colouring of the EU map keep every pair of neighbours apart?

Twenty-seven countries, their shared borders, and a proposed colour for each.
EyeProlog checks that every country is coloured from a four-colour palette and
that no border joins two countries of the same colour, and only then reports
the colouring as valid.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=four-color-map) ·
[Source](../four-color-map.pl)

---

# The question

The four colour theorem says any flat map can be coloured with four colours so
that neighbours differ. This example does not search for a colouring; it is
given one and has to **validate** it.

A validation is only convincing if it looks at every country and every border.
So the program counts what it checked and compares the counts with the size of
the map.

---

# The map and the proposal

```prolog
border(belgium, france). border(belgium, netherlands). border(belgium, luxemburg). border(belgium, germany).
border(netherlands, germany).

color(red). color(green). color(blue). color(yellow).

assigned(belgium, yellow).
assigned(netherlands, green).
assigned(france, blue).
assigned(germany, red).
```

Each border is stated once, in one direction. Each country gets one colour
from the palette.

---

# The rules

```prolog
border_colours_differ(A, B) :-
  border(A, B),
  assigned(A, Coloura),
  assigned(B, Colourb),
  (Coloura \= Colourb).

all_borders_checked(map_eu) :-
  findall([A, B], border_colours_differ(A, B), Borders),
  sort(Borders, Uniqueborders),
  length(Uniqueborders, Count),
  border_count(Count).

map_valid(map_eu) :-
  all_countries_coloured(map_eu),
  all_borders_checked(map_eu).
```

A border passes when its two countries have different colours. The map is
valid only when the number of passing borders equals the number of borders
(36), and every one of the 27 countries has a palette colour.

---

# The answer

```sh
eyeprolog examples/four-color-map.pl
```

```text
status(map_eu, valid_four_colour_assignment).
reason(map_eu, "no neighbouring countries share a colour").
```

The output also contains `color(map_eu, Colours)` with the full list of 27
country–colour pairs, three answers in total.

---

# The reason

```sh
eyeprolog --proof examples/four-color-map.pl
```

```text
step(map_valid(map_eu),
     rule(104),
     [],
     [all_countries_coloured(map_eu), all_borders_checked(map_eu)]).
step(status(map_eu, valid_four_colour_assignment), rule(107), [], [map_valid(map_eu)]).
```

The status rests on `map_valid/1`, which rests on two counts: every country
coloured, every border checked. The `findall/3` calls behind those counts
appear in the proof as `collected` steps, and `sort/2` and `length/2` as
`builtin` steps.

---

# The check

```text
condition('C1', resolution, ok, 9).
condition('C5', re_decision, ok, 4).
condition('C6', boundary_consistency, ok, 1).
trusted(2).
verdict(checked_with_obligations).
```

All seven conditions hold. The four built-in steps were recomputed and agreed.
The verdict is *checked with obligations*: the two completed `findall/3`
collections cannot be re-proved step by step, so the check records them as
trusted boundaries. Where it could, it looked for evidence that a collection
missed something, and found none.

---

# Try it

- Change `assigned(austria, yellow)` to `assigned(austria, red)`. Germany and
  Italy are red too, so fewer borders pass and the program prints nothing.
- Write `bad_border(A, B, Colour)` as a goal to list the offending borders
  instead of just losing the status.
- The border list states Austria–Slovakia twice, once in each direction. How
  does that affect the count of 36?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 8 and 12.
