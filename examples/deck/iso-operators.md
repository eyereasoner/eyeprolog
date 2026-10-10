# ISO operators

## Can a program read like a sentence and still be an ordinary term?

`op/3` declares new operators, so `sensor_7 reports temperature` becomes valid
Prolog. The declaration changes only how text is parsed: underneath, the
sentence is the compound term `reports(sensor_7, temperature)`, and every
relation treats it that way.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=iso-operators) ·
[Source](../iso-operators.pl)

---

# The question

How does a program declare its own infix vocabulary, and what does the parser
actually build from it?

The example declares two operators, writes facts with them, and then asks
three questions: what term a sentence parses to, which pairs of observations a
sensor reports, and which priority and type the `reports` operator has.

---

# The declarations and facts

```prolog
:- op(600, xfx, reports).
:- op(500, xfy, and).

sensor_7 reports temperature.
sensor_7 reports humidity.
```

An operator has a **priority** (lower binds tighter) and a **type**. `xfx`
means an infix operator whose two sides must bind tighter than itself, so
`a reports b reports c` is a syntax error. `xfy` means right-associative, so
`a and b and c` reads as `a and (b and c)`.

---

# The rules

```prolog
observations(Sensor, First and Second) :-
  Sensor reports First,
  Sensor reports Second,
  First @< Second.

report(parsed_as, Parts) :-
  ((sensor_7 reports temperature) =.. Parts).

report(operator, operator(Priority, Specifier)) :-
  current_op(Priority, Specifier, reports).
```

`=..` ("univ") takes a term apart into its name and arguments. `@<` compares
terms by standard order, so each unordered pair of observations is reported
once. `current_op/3` reads the operator table back.

---

# The answer

```sh
eyeprolog examples/iso-operators.pl
```

```text
report(parsed_as, [reports, sensor_7, temperature]).
report(observations, humidity and temperature).
report(operator, operator(600, xfx)).
```

The sentence is the term `reports(sensor_7, temperature)`. The pair is written
back with the same operator syntax, and the table reports exactly what was
declared.

---

# The reason

```sh
eyeprolog --proof examples/iso-operators.pl
```

```text
step(observations(sensor_7, humidity and temperature),
     rule(5),
     ['Sensor' = sensor_7, 'First' = humidity, 'Second' = temperature],
     [sensor_7 reports humidity, sensor_7 reports temperature, humidity @< temperature]).
step(sensor_7 reports humidity, fact(4), [], []).
step(humidity @< temperature, builtin, [], []).
```

The pair holds by the `observations/2` rule (clause 5): both facts were
reported, and `humidity` sorts before `temperature`. The comparison is a
built-in step that a checker can recompute on its own.

---

# The check

```text
condition('C1', resolution, ok, 6).
condition('C5', re_decision, ok, 2).
condition('C7', relevance, ok, 12).
obligation(builtin, reflective, current_op(600, xfx, reports)).
verdict(checked_with_obligations).
```

Six rule and fact steps replay against the program, and two built-ins (`=..`
and `@<`) are recomputed independently. `current_op/3` is **reflective**: its
answer depends on the operator table this program built, so the checker cannot
recompute it in isolation. It records that step as an obligation, a premise it
takes on trust and names explicitly.

---

# Try it

- Ask `current_op(P, S, and)`. It answers `P = 500, S = xfy`.
- Unpack `a and b and c` with `=..`. The result `[and, a, b and c]` shows the
  right associativity of `xfy`.
- Remove `First @< Second` from `observations/2`. You now get four pairs,
  including `humidity and humidity`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 36.
