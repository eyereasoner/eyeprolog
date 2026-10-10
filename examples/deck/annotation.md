# Annotation

## Who said what, and when?

A statement often comes with metadata: who stated it and when it was recorded.
This example keeps the statement and its annotations together as one piece of
data and uses ordinary rules to project the parts it wants to report.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=annotation) ·
[Source](../annotation.pl)

---

# The question

Bob stated, on 7 July 2021, that `a` is named "Alice". How do we record the
claim and its provenance without asserting everything as global facts?

---

# The annotation as data

```prolog
annotation(t, (
  name(a, "Alice"),
  statedBy(t, bob),
  recorded(t, "2021-07-07")
)).
```

The second argument is a **comma term**: one data value that bundles three
members. Nothing inside it is a fact of the program yet. `t` names the
annotated statement so its metadata can refer to it.

---

# Walking the bundle

```prolog
context_member((Left, _right), Member) :- context_member(Left, Member).
context_member((_left, Right), Member) :- context_member(Right, Member).
context_member(Member, Member) :- Member \= (_left, _right).

name(S, O) :-
  annotation(_t, Context),
  context_member(Context, name(S, O)).

log_nameOf(T, name(S, O)) :-
  annotation(T, Context),
  context_member(Context, name(S, O)).
```

`context_member/2` walks the comma term like a tree. Each projection rule then
decides explicitly which member becomes a visible relation. `log_nameOf/2` keeps
the link between the annotation `t` and the claim it carries.

---

# The answer

```sh
eyeprolog examples/annotation.pl
```

```text
name(a, "Alice").
log_nameOf(t, name(a, "Alice")).
statedBy(t, bob).
recorded(t, "2021-07-07").
```

The claim, its link to annotation `t`, who stated it, and when it was
recorded.

---

# The reason

```sh
eyeprolog --proof examples/annotation.pl
```

```text
step(context_member(name(a, "Alice"), name(a, "Alice")),
     rule(4),
     ['Member' = name(a, "Alice")],
     [name(a, "Alice") \= (_left, _right)]).
step(name(a, "Alice") \= (_left, _right), builtin, [], []).
```

The proof shows how the claim was found inside the bundle: the walk took the
left branch of the comma term, reached `name(a, "Alice")`, and confirmed with a
built-in test that this member is not itself a further conjunction.

---

# The check

```text
condition('C1', resolution, ok, 13).
condition('C5', re_decision, ok, 3).
recomputed(3).
trusted(0).
claims(4).
verdict(checked).
```

All 13 rule and fact steps check, and the 3 `\=` tests are recomputed by the
checker.

---

# Try it

- Add a second annotation `u` in which Carol states that `b` is named "Bob",
  and predict the new answers.
- Remove the `name/2` rule. Is the claim still visible through
  `log_nameOf/2`? Why might you prefer that?
- Add `confidence(t, 0.9)` to the bundle and a projection rule for it.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 9.
