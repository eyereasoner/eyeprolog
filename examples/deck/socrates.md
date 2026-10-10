# Socrates is mortal

## The oldest syllogism, as a program

All men are mortal. Socrates is a man. Therefore Socrates is mortal. One fact,
one rule, one conclusion, and the smallest complete tour of what EyeProlog
does: answer, reason, check.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=socrates) ·
[Source](../socrates.pl)

---

# The question

Is Socrates mortal, and can the program show why?

---

# The program

```prolog
type(socrates, man).

type(X, mortal) :-
  type(X, man).

holds_result(test, true) :-
  type(socrates, mortal).
```

The fact says Socrates is a man. The rule says that anything that is a man is
mortal: `X` stands for any individual. The last clause turns the conclusion
into a test result.

---

# The answer

```sh
eyeprolog examples/socrates.pl
```

```text
type(socrates, mortal).
holds_result(test, true).
```

The answers are themselves Prolog facts, so they can be saved and loaded into
another program. `type(socrates, man)` is not printed: it was given, not
derived.

---

# The reason

```sh
eyeprolog --proof examples/socrates.pl
```

```text
step(type(socrates, mortal), rule(2), ['X' = socrates], [type(socrates, man)]).
step(type(socrates, man), fact(1), [], []).
step(holds_result(test, true), rule(3), [], [type(socrates, mortal)]).
```

Socrates is mortal by rule 2 with `X = socrates`, using the fact that he is a
man (fact 1). Each conclusion gets exactly one step, naming the clause and
the bindings that justify it.

---

# The check

```sh
eyeprolog --proof examples/socrates.pl > socrates.why.pl
eyeprolog --check-proof socrates.why.pl examples/socrates.pl
```

```text
condition('C1', resolution, ok, 3).
condition('C2', well_founded, ok, 3).
condition('C4', coverage, ok, 4).
verdict(checked).
```

A separate checker replays all 3 steps against the program without searching
for anything. It confirms that each step follows from the clause it cites
(C1), that nothing rests on itself (C2), and that every claim is covered (C4).

---

# Try it

- Add `type(plato, man).` and predict the new answer.
- Edit `socrates.why.pl` so the first step binds `'X'` to `plato`, then check
  it again. Which condition fails?
- Add `type(X, philosopher) :- type(X, man), teaches(X, _).` and a `teaches/2`
  fact.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 1 and 11.
