# Type inference

## What type does this program have?

Languages such as Haskell and OCaml work out the types of expressions without
being told. This example does the same for a tiny lambda language, in about a
dozen clauses: each typing rule is a clause, and Prolog's unification solves
the type equations.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=type-inference) ·
[Source](../type-inference.pl)

---

# The question

Given an expression such as "a function that composes `f` and `g`", what is
its type?

A type checker has to match the type a function expects with the type of the
argument it gets. That matching is exactly unification, so Prolog gets the
core of Hindley–Milner-style inference almost for free.

---

# The programs

```prolog
program(id, lam(x, t0, var(x))).
program(const, lam(x, t0, lam(y, t1, var(x)))).
program(apply_id, app(lam(x, int, var(x)), int_lit(42))).
program(branch,
  if(bool_lit(true), add(int_lit(20), int_lit(22)), int_lit(0))).
```

Expressions are terms: `lam(Name, ArgType, Body)` is a function, `app/2`
applies one, and literals, `if/3`, `add/2`, and pairs complete the language.
`t0`, `t1`, `t2` stand for type variables.

---

# The typing rules

```prolog
type_expr(Env, var(Name), Type) :- lookup(Name, Env, Type).
type_expr(Env, lam(Name, Arg_type, Body), fun(Arg_type, Body_type)) :-
  type_expr([[Name, Arg_type] | Env], Body, Body_type).
type_expr(Env, app(Fn, Arg), Result_type) :-
  type_expr(Env, Fn, fun(Arg_type, Result_type)),
  type_expr(Env, Arg, Arg_type).
type_expr(Env, if(Cond, Then, Else), Type) :-
  type_expr(Env, Cond, bool),
  type_expr(Env, Then, Type),
  type_expr(Env, Else, Type).
```

A function has type `fun(Arg, Result)`. Applying it requires the argument to
have type `Arg`; both branches of an `if` must share one type. The shared
variables in each clause are the type equations.

---

# The answer

```sh
eyeprolog examples/type-inference.pl
```

```text
type_answer(id, fun(t0, t0)).
type_answer(const, fun(t0, fun(t1, t0))).
type_answer(apply_id, int).
type_answer(compose, fun(fun(t1, t2), fun(fun(t0, t1), fun(t0, t2)))).
type_answer(branch, int).
type_answer(first_of_pair, bool).
```

The identity function has type `t0 → t0`. Composition takes a `t1 → t2` and a
`t0 → t1` and returns a `t0 → t2`, which is the familiar type of `f ∘ g`. Two
`type_reason/2` facts follow in the full output.

---

# The reason

```text
step(type_expr([], lam(x, t0, var(x)), fun(t0, t0)),
     rule(12),
     ['Env' = [], 'Name' = x, 'Arg_type' = t0, 'Body' = var(x), 'Body_type' = t0],
     [type_expr([[x, t0]], var(x), t0)]).
step(lookup(x, [[x, t0]], t0), fact(7), ['Name' = x, 'Type' = t0], []).
```

The identity function gets `fun(t0, t0)` by the lambda rule (clause 12): its
body `x` is typed in an environment where `x` has type `t0`, and looking `x` up
there gives `t0`. The proof is a typing derivation, the kind a textbook draws
as a tree.

---

# The check

```text
condition('C1', resolution, ok, 49).
condition('C4', coverage, ok, 53).
condition('C7', relevance, ok, 57).
verdict(checked).
```

All 49 steps are rule or fact steps, so the checker replays every one of them
against the program. No built-in or boundary needs trust.

---

# Try it

- Add `program(bad, app(int_lit(1), int_lit(2))).` and predict why it has no
  type.
- Add `program(swap, lam(p, pair(t0, t1), pair(snd(var(p)), fst(var(p))))).`
  and predict its type.
- Write `if(int_lit(1), int_lit(2), int_lit(3))` as a program. Which rule
  rejects it?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 22.
