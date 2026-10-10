# Attributed variables

## Can a variable carry a promise about its future value?

An **attributed variable** is an unbound variable with extra information
attached. When something tries to bind it, a hook runs first and can accept,
reject, or pass the information on. This is the mechanism under constraint
libraries such as CLP(Z) and `dif/2`.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=attributed-variables) ·
[Source](../attributed-variables.pl)

---

# The question

Attach the requirement "must become 7" to a variable. Does binding it to 7
succeed? And if the variable is first aliased to another variable, does the
requirement travel with it?

---

# Attaching and verifying

```prolog
:- use_module(library(atts)).
:- attribute required/1.

attach_required(Variable, Value) :-
    put_atts(Variable, required(Value)).

verify_attributes(Variable, Other, Goals) :-
    ( get_atts(Variable, required(Value)) ->
        ( var(Other) ->
            put_atts(Other, required(Value)),
            Goals = []
        ; Goals = [required_value(Other, Value)] )
    ; Goals = [] ).

required_value(Value, Value).
```

`verify_attributes/3` runs *before* an attributed variable is bound. Bound to
another variable, it copies the requirement across. Bound to a value, it
returns a goal that checks the value, which runs right after the binding.

---

# The two tests

```prolog
accepts_required_value(ok) :-
    attach_required(X, 7),
    X = 7.

alias_preserves_attribute(ok) :-
    attach_required(X, ready),
    X = Y,
    get_atts(Y, required(ready)),
    Y = ready.
```

---

# The answer

```sh
eyeprolog examples/attributed-variables.pl
```

```text
accepts_required_value(ok).
alias_preserves_attribute(ok).
```

Both hold: the right value is accepted, and aliasing `X = Y` moves the
requirement to `Y`.

---

# The reason

```sh
eyeprolog --proof examples/attributed-variables.pl
```

```text
step(accepts_required_value(ok), rule(4), ['X' = 7], [attach_required(7, 7), 7 = 7]).
step(attach_required(7, 7), rule(1), ['Variable' = 7, 'Value' = 7], [put_atts(7, required(7))]).
step(put_atts(7, required(7)), builtin, [], []).
```

A proof records each goal with its **final** bindings applied. That is why the
attribute call appears as `put_atts(7, required(7))`, although at the time it
ran, `X` was still unbound.

---

# The check

```text
condition('C1', resolution, ok, 4).
condition('C5', re_decision, ok, 2).
obligation(builtin, stateful, put_atts(7, required(7))).
obligation(builtin, stateful, put_atts(ready, required(ready))).
obligation(builtin, stateful, get_atts(ready, required(ready))).
trusted(3).
verdict(checked_with_obligations).
```

The rules and the two unifications check. The attribute operations depend on
state built up during the run, so the checker cannot recompute them from the
proof alone. It lists them as **stateful obligations**: the verdict holds
provided those steps behaved as recorded.

---

# Try it

- Change the first test to `X = 8`. Which goal fails, and when does it run?
- Query `attach_required(X, 7)` at the interactive top level. How does
  `attribute_goals//1` show the pending requirement?
- Extend the hook so that two variables with different requirements cannot be
  aliased.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 39 (`library(atts)`).
