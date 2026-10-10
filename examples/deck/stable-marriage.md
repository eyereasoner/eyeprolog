# Stable marriage

## Can everyone be paired so that no two people would rather run off together?

Four men and four women each rank the other group. A pairing is *stable* if
no man and woman both prefer each other to the partners they were given. The
program searches all pairings and rejects each one that has such a
*blocking pair*.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=stable-marriage) ·
[Source](../stable-marriage.pl)

---

# The question

The stable marriage problem, studied by Gale and Shapley in 1962, models any
two-sided matching: students and schools, doctors and hospitals. Which
complete pairings are stable, and how many are there?

---

# The preferences

```prolog
rank_man(adam, bea, 1).
rank_man(adam, amy, 2).
rank_man(adam, dana, 3).
rank_man(adam, cora, 4).

rank_woman(amy, cole, 1).
rank_woman(amy, adam, 2).
rank_woman(amy, brian, 3).
rank_woman(amy, drew, 4).
```

Sixteen rankings on each side; 1 is the first choice.

---

# Instability as a relation

```prolog
blocking_pair(Matching, Man, Woman) :-
  assigned(Matching, Man, Currentwoman),
  woman(Woman),
  (Woman \= Currentwoman),
  prefers_man(Man, Woman, Currentwoman),
  assigned(Matching, Currentman, Woman),
  prefers_woman(Woman, Man, Currentman).

stable_matching(Matching) :-
  matching(Matching),
  \+ blocking_pair(Matching, _man, _woman).
```

A blocking pair is a man and a woman who each prefer the other to their
current partner. A matching is stable when no blocking pair exists. The
program states the definition directly and lets `matching/1` enumerate all 24
pairings.

---

# The answer

```sh
eyeprolog examples/stable-marriage.pl
```

```text
stable_marriage_answer(first_stable_matching, [pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)]).
stable_marriage_answer(stable_matching_count, 1).
```

Exactly one of the 24 pairings is stable. Adam gets his first choice, Bea;
Cole and Drew get theirs too, and Brian, whose first choice Amy prefers Cole,
is paired with Dana, who ranks him first.

---

# The reason

```text
step(stable_matching([pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)]),
     rule(48),
     ['Matching' = [pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)]],
     [matching([pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)]),
      \+ blocking_pair([pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)], _man, _woman)]).
```

The matching is stable because it is a valid pairing and the search for a
blocking pair in it comes back empty.

---

# The check

```text
obligation(absent, theory_scoped, \+ blocking_pair([pair(adam, bea), pair(brian, dana), pair(cole, amy), pair(drew, cora)], A, B)).
obligation(builtin, theory_scoped, countall(stable_matching(A), 1)).
verdict(checked_with_obligations).
```

The pairing itself is fully verified. Two claims are not about steps but
about everything the program could derive: "there is no blocking pair" and
"there is exactly one stable matching". The checker never searches, so it
records both as **obligations**. Each is a finite claim you could confirm by
inspecting the 16 possible (man, woman) pairs or the 24 matchings.

---

# Try it

- Swap Amy's first two preferences (`adam` first, `cole` second). Predict the
  new count before running.
- Write `blocking_pairs(Matching, Pairs)` with `findall/3` and list every
  blocking pair of the matching `adam–amy, brian–bea, cole–cora, drew–dana`.
- Why does `stable_marriage_answer(first_stable_matching, …)` use `once/1`?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 7 and 10.
