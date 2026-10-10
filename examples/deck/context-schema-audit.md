# Context schema audit

## Which fields in a message do not fit the schema?

Two sensor messages each carry a bundle of fields with different shapes. One
generic rule takes every field apart, measures its name and number of
arguments, and compares that shape with an allowed schema. It never needs to
know the field names in advance.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=context-schema-audit) ·
[Source](../context-schema-audit.pl)

---

# The question

Incoming data is often heterogeneous: a heartbeat with no arguments, a source
with one, a temperature with two, a GPS fix with three. A validator should
catch a field with the wrong shape, such as a GPS fix missing its longitude, or
a field that should not be there at all.

Can one rule audit every field, whatever its name or size?

---

# Two messages and a schema

```prolog
message_context(msg_bad, (
  heartbeat,
  source(sensor18),
  temperature(sensor18, 99),
  gps(sensor18, 51),
  tampered(sensor18)
)).

allowed_shape(heartbeat, 0).
allowed_shape(source, 1).
allowed_shape(temperature, 2).
allowed_shape(gps, 3).
allowed_shape(signature, 4).
```

`msg_bad` has two problems: `gps` has two arguments instead of three, and
`tampered` is not in the schema. (`msg_ok` carries five well-formed fields.)

---

# One generic rule

```prolog
context_shape(Message, Name, Arity) :-
  message_context(Message, Context),
  context_member(Context, Statement),
  (Statement =.. [Name | Args]),
  length(Args, Arity).

schema_violation(Message, Name, Arity) :-
  context_shape(Message, Name, Arity),
  \+ allowed_shape(Name, Arity).
```

`=..` turns `gps(sensor18, 51)` into the list `[gps, sensor18, 51]`. The head of
the list is the name, and the length of the rest is the arity. A violation is a
shape the schema does not allow.

---

# The answer

```sh
eyeprolog examples/context-schema-audit.pl
```

```text
context_shape(msg_bad, gps, 2).
context_shape(msg_bad, tampered, 1).
schema_violation(msg_bad, gps, 2).
schema_violation(msg_bad, tampered, 1).
```

That is an excerpt of 12 answers: ten `context_shape/3` facts (five per
message) and two violations, both in `msg_bad`. `msg_ok` passes cleanly.

---

# The reason

```sh
eyeprolog --proof examples/context-schema-audit.pl
```

```text
step(schema_violation(msg_bad, gps, 2),
     rule(12),
     ['Message' = msg_bad, 'Name' = gps, 'Arity' = 2],
     [context_shape(msg_bad, gps, 2), \+ allowed_shape(gps, 2)]).
step(\+ allowed_shape(gps, 2), absent, [], []).
```

The violation rests on two things: the measured shape `gps/2`, and the
**absence** of an `allowed_shape(gps, 2)` fact. That second step is marked
`absent`, because "no such fact" is not something a clause can prove.

---

# The check

```sh
eyeprolog --proof examples/context-schema-audit.pl > context-schema-audit.why.pl
eyeprolog --check-proof context-schema-audit.why.pl examples/context-schema-audit.pl
```

```text
condition('C6', boundary_consistency, ok, 2).
obligation(absent, theory_scoped, \+ allowed_shape(gps, 2)).
obligation(absent, theory_scoped, \+ allowed_shape(tampered, 1)).
trusted(2).
verdict(checked_with_obligations).
```

Everything else replays, but the two absences are **obligations**: the proof
is valid on condition that the schema is complete. C6 confirms that nothing in
the program contradicts them. If someone forgot to list a legitimate shape,
the audit would still pass the check, and the obligation lines say exactly
where that assumption sits.

---

# Try it

- Add `allowed_shape(gps, 2).` and run again. Only the `tampered` violation
  remains, and its obligation is the only one left.
- Add a third message whose context is the single field `heartbeat` and
  predict its shapes. Does `context_member/2` still work when there is no
  comma at all?
- Change the schema so that `gps` may have either 2 or 3 arguments. Which
  closed-world assumption have you just relaxed?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 9 and 12.
