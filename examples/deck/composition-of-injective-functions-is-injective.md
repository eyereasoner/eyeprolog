# Composing injective functions

## If f and g are injective, is g ∘ f injective too?

A function is injective when different inputs always give different outputs.
The theorem says that composing two injective functions gives an injective
function. This example checks the theorem on a tiny finite model, and shows
with a second composite why the premise matters.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=composition-of-injective-functions-is-injective) ·
[Source](../composition-of-injective-functions-is-injective.pl)

---

# The question

`h` is `g` after `f`. If `h(X) = h(Y)`, injectivity of `g` gives
`f(X) = f(Y)`, and injectivity of `f` gives `X = Y`. So `h` is injective.

On a finite model, injectivity can be checked directly: look for a
**collision**, two distinct inputs with the same output. A function with no
collision is injective.

---

# The model

```prolog
app(f, a, c).
app(f, b, d).
app(g, c, e).
app(g, d, k).
app(g2, c, e).
app(g2, d, e).

compositeOf(h, g, f).
compositeOf(h2, g2, f).
```

`app(F, X, Y)` means F maps X to Y. `f` and `g` are injective. `g2` is not:
it sends both `c` and `d` to `e`. So `h = g ∘ f` should be injective and
`h2 = g2 ∘ f` should not.

---

# The rules

```prolog
app(H, X, Z) :-
  compositeOf(H, G, F),
  app(F, X, Y),
  app(G, Y, Z).

collision(F, X, Y) :-
  app(F, X, Z),
  app(F, Y, Z),
  (X \= Y).

injective(F) :-
  function(F),
  \+ collision(F, _, _).

compositeInjective(H, G, F) :-
  compositeOf(H, G, F),
  injective(G),
  injective(F),
  injective(H).
```

A collision is a witness *against* injectivity. Injectivity is the absence of
any collision, which is a finite check because the model is finite.

---

# The answer

```sh
eyeprolog examples/composition-of-injective-functions-is-injective.pl
```

```text
collision(g2, c, d).
collision(g2, d, c).
collision(h2, a, b).
collision(h2, b, a).
compositeInjective(h, g, f).
```

`h` is injective, as the theorem predicts. `h2` is not, and the output says
exactly why: `a` and `b` both reach `e`, because `g2` merges `c` and `d`.
Composing with an injective `f` cannot repair a non-injective `g2`.

---

# The reason

```sh
eyeprolog --proof examples/composition-of-injective-functions-is-injective.pl
```

```text
step(compositeInjective(h, g, f),
     rule(18),
     ['H' = h, 'G' = g, 'F' = f],
     [compositeOf(h, g, f), injective(g), injective(f), injective(h)]).
step(injective(h), rule(17), ['F' = h], [function(h), \+ collision(h, __anon0, __anon1)]).
step(collision(h2, a, b),
     rule(16),
     ['F' = h2, 'X' = a, 'Y' = b, 'Z' = e],
     [app(h2, a, e), app(h2, b, e), a \= b]).
```

The conclusion for `h` rests on three injectivity steps, each the absence of a
collision. The collision of `h2` is a positive witness: two inputs, one
output, and the check that the inputs differ.

---

# The check

```text
condition('C1', resolution, ok, 19).
condition('C6', boundary_consistency, ok, 0).
obligation(absent, theory_scoped, \+ collision(g, A, B)).
obligation(absent, theory_scoped, \+ collision(f, A, B)).
obligation(absent, theory_scoped, \+ collision(h, A, B)).
verdict(checked_with_obligations).
```

Every rule step replays. The three absences cannot be re-proved from the proof
alone, so they remain **obligations**: the conclusion holds provided `f`, `g`,
and `h` really have no collision in this finite model. That is precisely the
premise the theorem needs.

---

# Try it

- Change `app(g, d, k)` to `app(g, d, e)`. Which answer disappears, and which
  collisions appear for `g` and `h`?
- Add a third input `x3` with `app(f, x3, c)`. Now `f` is not injective. Is
  `h` still injective?
- Check the theorem the other way: if `g ∘ f` is injective, must `f` be
  injective? Must `g`? Build a small model for each answer.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 28 and Chapter 12.
