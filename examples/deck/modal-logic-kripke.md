# Modal logic on a Kripke frame

## What is necessarily true, and what is merely possible?

Modal logic adds two operators to ordinary logic: □ ("necessarily") and ◇
("possibly"). Kripke gave them a concrete meaning using worlds and an
accessibility relation. This example writes that meaning as a small
interpreter over a finite frame of four worlds.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=modal-logic-kripke) ·
[Source](../modal-logic-kripke.pl)

---

# The question

From world `w0`, which statements hold necessarily (in every accessible
world) and which hold possibly (in at least one)? In particular: is the system
necessarily clear, and is a repair possible, or even necessary?

---

# The frame

```prolog
accessible(w0, w1).
accessible(w0, w2).
accessible(w1, w1).
accessible(w1, w3).
accessible(w2, w2).
accessible(w3, w3).

true_at(w1, clear).
true_at(w2, clear).
true_at(w3, clear).
true_at(w2, repaired).
```

From `w0` you can reach `w1` and `w2`. Both are clear, but only `w2` is
repaired.

---

# The rules

```prolog
mforces(World, atom(Prop)) :- true_at(World, Prop).
mforces(World, and(Left, Right)) :- mforces(World, Left), mforces(World, Right).
mforces(World, diamond(Formula)) :- accessible(World, Next), mforces(Next, Formula).
mforces(World, box(Formula)) :-
  world(World),
  \+ box_counterexample(World, Formula).
box_counterexample(World, Formula) :-
  accessible(World, Next),
  \+ mforces(Next, Formula).
```

◇F holds when some accessible world forces F. □F holds when there is no
accessible world where F fails, so necessity is defined by the absence of a
counterexample.

---

# The answer

```sh
eyeprolog examples/modal-logic-kripke.pl
```

```text
modal_truth(all_accessible_worlds_clear, w0, box(atom(clear))).
modal_truth(repair_is_possible, w0, diamond(atom(repaired))).
modal_truth(nested_possibility, w1, diamond(and(atom(clear), atom(clear)))).
modal_countermodel(repair_not_necessary, w0).
```

At `w0`, "clear" is necessary and "repaired" is possible but not necessary:
`w1` is the countermodel.

---

# The reason

```text
step(mforces(w0, diamond(atom(repaired))),
     rule(18),
     ['World' = w0, 'Formula' = atom(repaired), 'Next' = w2],
     [accessible(w0, w2), mforces(w2, atom(repaired))]).
step(mforces(w0, box(atom(clear))),
     rule(19),
     ['World' = w0, 'Formula' = atom(clear)],
     [world(w0), \+ box_counterexample(w0, atom(clear))]).
```

Possibility has a positive witness: world `w2`. Necessity rests on an absence:
no accessible world fails to be clear.

---

# The check

```text
condition('C1', resolution, ok, 15).
condition('C6', boundary_consistency, ok, 0).
steps(17).
verified(15).
trusted(2).
verdict(checked_with_obligations).
```

15 steps replay. The two trusted steps are the absences that □ depends on:
`\+ box_counterexample(w0, atom(clear))` and
`\+ mforces(w0, box(atom(repaired)))`. They are listed as obligations, which is
exactly the closed-world assumption that this frame lists all accessible
worlds.

---

# Try it

- Add `true_at(w1, repaired).` Does `box(atom(repaired))` now hold at `w0`?
- Add an edge `accessible(w0, w4)` to a world where nothing is true. Which
  answers change?
- Make the frame reflexive and check whether □p → p holds at every world
  (the T axiom).

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 7.
