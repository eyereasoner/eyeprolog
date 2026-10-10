# Vocabulary alignment

## Which local vehicle concepts roll up to the reference "car"?

Three data sources describe vehicles with their own concepts. A few asserted
links say which concepts are broader or narrower than others, and rules derive
the full hierarchy, so every source can be queried in terms of one reference
concept.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=alignment-demo) ·
[Source](../alignment-demo.pl)

---

# The question

A reference vocabulary has the concept `ref_car`. A telematics system talks
about `tel_car` and `tel_heavy_vehicle`; a number-plate camera (ANPR) talks about
`anpr_vehicle_with_plate` and `anpr_passenger_car`.

Which of these concepts **roll up** to `ref_car`, directly or through other
concepts?

---

# The asserted links

```prolog
assertedBroader(tel_car, ref_car).
assertedBroader(tel_heavy_vehicle, ref_car).
assertedBroader(anpr_vehicle_with_plate, ref_car).
assertedNarrower(anpr_vehicle_with_plate, anpr_passenger_car).
```

The links come in two directions, as they do in real mappings (SKOS uses
`broader` and `narrower` in the same way). Only one link mentions
`anpr_passenger_car`, and it does not mention `ref_car` at all.

---

# The rules

```prolog
broader(X, Y) :- assertedBroader(X, Y).
broader(X, Y) :- assertedNarrower(Y, X).

broaderTransitive(X, Y) :- broader(X, Y).
broaderTransitive(X, Z) :- broader(X, Y), broaderTransitive(Y, Z).

narrowerOrEqualOf(X, X) :- concept(X).
narrowerOrEqualOf(X, Y) :- broaderTransitive(X, Y).

rollsUpTo(X, ref_car) :-
  narrowerOrEqualOf(X, ref_car),
  (X \= ref_car).
```

First both directions are normalized to `broader/2`. The transitive closure
then follows chains of links, a reflexive version adds "or equal", and
`rollsUpTo/2` keeps the concepts below `ref_car` other than `ref_car` itself.

---

# The answer

```sh
eyeprolog examples/alignment-demo.pl
```

```text
broaderTransitive(anpr_passenger_car, anpr_vehicle_with_plate).
broaderTransitive(anpr_passenger_car, ref_car).
rollsUpTo(tel_car, ref_car).
rollsUpTo(tel_heavy_vehicle, ref_car).
rollsUpTo(anpr_vehicle_with_plate, ref_car).
rollsUpTo(anpr_passenger_car, ref_car).
```

These are 6 of the 32 answers, which also list the direct, inverse, and
reflexive relations. All four local concepts roll up to `ref_car`, including
`anpr_passenger_car`, which no link connects to it directly.

---

# The reason

```sh
eyeprolog --proof examples/alignment-demo.pl
```

```text
step(broader(anpr_passenger_car, anpr_vehicle_with_plate),
     rule(11),
     ['X' = anpr_passenger_car, 'Y' = anpr_vehicle_with_plate],
     [assertedNarrower(anpr_vehicle_with_plate, anpr_passenger_car)]).
```

The passenger car reaches the reference concept in two moves. First, rule 11
turns the asserted *narrower* link around into a *broader* one. Then the
transitive rule chains it with `anpr_vehicle_with_plate`'s link to `ref_car`.

---

# The check

```text
condition('C1', resolution, ok, 41).
condition('C5', re_decision, ok, 4).
condition('C7', relevance, ok, 77).
recomputed(4).
trusted(0).
claims(32).
verdict(checked).
```

All 41 rule and fact steps check. The 4 recomputed steps are the `X \= ref_car`
tests in `rollsUpTo/2`.

---

# Try it

- Add `concept(anpr_van).` and `assertedNarrower(anpr_vehicle_with_plate, anpr_van).`
  and predict the new `rollsUpTo/2` answer.
- Add a link that makes `ref_car` narrower than `tel_car`, creating a cycle.
  What happens to the transitive rules, and how would `:- table` help?
- Write `commonAncestor(X, Y, Z)` for two concepts that roll up to the same
  concept `Z`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 4.
