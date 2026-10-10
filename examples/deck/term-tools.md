# Term tools

## How does a program look inside a term?

Prolog data and Prolog goals are the same thing: terms. This example uses the
standard term-inspection built-ins to take a term apart, build a new one,
render one as text, and check a property of every edge, each as one small
`report/2` answer.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=term-tools) ·
[Source](../term-tools.pl)

---

# The question

Given a term such as `edge(a, b, 3)`, what is its name and arity? What is its
second argument? Can it be turned into a list and back? Can it be printed as
text?

These operations matter whenever a program treats terms as data: interpreters,
schema checkers, serializers, and code generators all need them.

---

# The data

```prolog
edge(a, b, 3).
edge(b, c, 4).
```

Two weighted edges. The reports inspect one of them, build a new one, and
validate both.

---

# The rules

```prolog
report(shape, shape(Name, Arity)) :-
  functor(edge(a, b, 3), Name, Arity).

report(parts, parts(Name, Args)) :-
  (edge(a, b, 3) =.. [Name | Args]).

report(rebuilt, Term) :-
  (Term =.. [edge | [c, d, 5]]).

report(all_weights_positive, yes) :-
  \+ nonpositive_edge.
nonpositive_edge :-
  edge(_from, _to, Weight),
  \+ (Weight > 0).
```

`functor/3` reads a term's name and arity. `=../2` ("univ") relates a term to
the list of its name and arguments, so it can both decompose and build.
The last report says "no edge has a non-positive weight", a universal claim
written as the absence of a counterexample.

---

# The answer

```sh
eyeprolog examples/term-tools.pl
```

```text
report(shape, shape(edge, 3)).
report(second_argument, b).
report(parts, parts(edge, [a, b, 3])).
report(rebuilt, edge(c, d, 5)).
report(rendered, 'edge(a, [b, c])').
report(all_weights_positive, yes).
```

Note that `rendered` is an atom: `term_string/2` turns the term into text.

---

# The reason

```text
step(report(parts, parts(edge, [a, b, 3])),
     rule(5),
     ['Name' = edge, 'Args' = [a, b, 3]],
     [edge(a, b, 3) =.. [edge, a, b, 3]]).
step(edge(a, b, 3) =.. [edge, a, b, 3], builtin, [], []).
```

The `parts` report holds by clause 5 because `=../2` relates `edge(a, b, 3)`
to the list `[edge, a, b, 3]`. That built-in step needs no clause of its own:
the checker can recompute it.

---

# The check

```text
condition('C1', resolution, ok, 6).
condition('C5', re_decision, ok, 5).
obligation(absent, theory_scoped, \+ nonpositive_edge).
trusted(1).
verdict(checked_with_obligations).
```

Six rule steps are replayed and five built-in steps are recomputed. The
absence `\+ nonpositive_edge` cannot be proved by listing steps, so the check
reports it as an **obligation**: the verdict holds provided no edge with a
non-positive weight exists in this program.

---

# Try it

- Add `edge(c, d, 0).` and predict which report disappears.
- Use `functor(T, point, 2)` to build a term with fresh arguments, then fill
  them with `arg/3` and `=/2`.
- Add a report that counts the arguments of every `edge/3` fact with
  `functor/3` and `findall/3`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 35.
