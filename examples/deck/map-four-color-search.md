# Four-colouring the European Union

## Can 27 countries be coloured with four colours so that no neighbours match?

The four colour theorem says every planar map can be coloured this way.
This example does not prove the theorem; it finds one concrete colouring for
the EU neighbour graph by finite search, and the proof shows every
neighbour test that the answer depends on.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=map-four-color-search) ·
[Source](../map-four-color-search.pl)

---

# The question

Give each EU country one of four colours so that countries sharing a border
never share a colour. Ireland, Cyprus, and Malta have no land neighbours in
the graph, so any colour will do for them; Germany borders eight countries.

---

# The facts

```prolog
color(red).
color(green).
color(blue).
color(yellow).

neighbours(belgium, [france, netherlands, luxemburg, germany]).
neighbours(netherlands, [belgium, germany]).
neighbours(germany, [netherlands, belgium, luxemburg, denmark, france, austria, poland, czech_republic]).
neighbours(ireland, []).
```

Four colours, and one `neighbours/2` fact per country (27 in all).

---

# The rules

```prolog
valid_color(Place, Color, Assigned) :-
  neighbours(Place, Neighbors),
  \+ (member([Neighbor, Color], Assigned), member(Neighbor, Neighbors)).

color_places([]).
color_places([[Place, Color]|Tail]) :-
  color_places(Tail),
  color(Color),
  valid_color(Place, Color, Tail).

four_color_answer(european_union, Coloring) :-
  place_order(Places),
  place_pairs(Places, Coloring),
  once(color_places(Coloring)).
```

The tail is coloured first, so each new choice is tested against countries
that already have a colour. A colour is valid when no neighbour already holds
it. `once/1` asks for one colouring, not all of them.

---

# The answer

```sh
eyeprolog examples/map-four-color-search.pl
```

```text
four_color_answer(european_union, [[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]).
```

One colouring that uses all four colours. Belgium needs the fourth colour
(yellow), because France, the Netherlands, and Germany around it already use
blue, green, and red.

---

# The reason

```text
step(color_places([[croatia, red]]),
     rule(37),
     ['Place' = croatia, 'Color' = red, 'Tail' = []],
     [color_places([]), color(red), valid_color(croatia, red, [])]).
```

The proof builds the colouring from the end of the list: Croatia, coloured
first, gets red because nothing is coloured yet. Each later step adds one
country and one `valid_color/3` test against the countries already coloured.

---

# The check

```text
condition('C1', resolution, ok, 116).
condition('C5', re_decision, ok, 1).
condition('C6', boundary_consistency, ok, 0).
steps(144).
verified(116).
trusted(27).
verdict(checked_with_obligations).
```

All 116 rule and fact steps replay correctly. The 27 trusted steps are the
`\+` neighbour tests, one per country: the checker cannot replay "no
neighbour has this colour" as a derivation, so it lists each as an
`obligation(absent, …)` that the answer rests on. Each is a finite membership
test you can confirm by reading the list it names.

---

# Try it

- Remove `yellow` from the colours. Does a three-colouring of this graph
  exist, and how long does the search take to decide?
- Change `place_order/1` to start with Germany. Does the answer change?
- Drop `once/1` and count how many colourings the search can find for a small
  part of the map, such as the Benelux countries.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 10.
