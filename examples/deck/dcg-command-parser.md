# A command parser

## One grammar that both reads and writes home-automation commands

A tiny language of commands like `set kitchen light to on` is described once,
as a definite clause grammar. The same grammar parses tokens into a structured
command, generates tokens from a command, hands unread input back to its
caller, and rejects sentences outside the language.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=dcg-command-parser) ·
[Source](../dcg-command-parser.pl)

---

# The question

An application wants a term such as `set(light(kitchen), on)`, but users type
words. Usually that takes a parser, plus a separate printer for the other
direction, and the two can drift apart.

A grammar written as a relation between token lists and terms needs neither:
the same rules serve both directions.

---

# The grammar

```prolog
command(set(light(Room), State)) -->
  [set], room(Room), [light, to], state(State).

room(kitchen) --> [kitchen].
room(hall) --> [hall].

state(on) --> [on].
state(off) --> [off].
```

Read `-->` as "is made of". A command is the word `set`, a room, the words
`light to`, and a state. The arguments on the left say which term each piece of
text stands for.

---

# Four uses of one grammar

```prolog
dcg_example(parsed, Command) :-
  phrase(command(Command), [set, kitchen, light, to, on]).
dcg_example(generated, Tokens) :-
  phrase(command(set(light(hall), off)), Tokens).
dcg_example(remainder, Rest) :-
  phrase(command(set(light(kitchen), on)),
         [set, kitchen, light, to, on, then, wait],
         Rest).
dcg_example(rejected, invalid_command) :-
  \+ phrase(command(_), [set, garage, light, to, blinking]).
```

`phrase/2` demands that the whole token list is consumed. `phrase/3` returns
what is left over, so a larger parser could continue from there.

---

# The answer

```sh
eyeprolog examples/dcg-command-parser.pl
```

```text
dcg_example(parsed, set(light(kitchen), on)).
dcg_example(generated, [set, hall, light, to, off]).
dcg_example(remainder, [then, wait]).
dcg_example(rejected, invalid_command).
```

Parsing gives the structured command, generation gives the words, the
remainder is `[then, wait]`, and `set garage light to blinking` is not a
sentence of the language: there is no garage and no blinking state.

---

# The reason

```text
step(dcg_example(remainder, [then, wait]),
     rule(8),
     ['Rest' = [then, wait]],
     [phrase(command(set(light(kitchen), on)), [set, kitchen, light, to, on, then, wait], [then, wait])]).
step(\+ phrase(command(__anon0), [set, garage, light, to, blinking]), absent, [], []).
```

Each answer rests on one `phrase/2` or `phrase/3` call. The rejection is
recorded as an `absent` step: the search for a parse finished without finding
one.

---

# The check

```text
condition('C1', resolution, ok, 4).
obligation(builtin, theory_scoped, phrase(command(set(light(kitchen), on)), [set, kitchen, light, to, on])).
obligation(absent, theory_scoped, \+ phrase(command(A), [set, garage, light, to, blinking])).
steps(8).
trusted(4).
verdict(checked_with_obligations).
```

The four rule steps are verified. The four grammar calls are obligations.
A `phrase/2` call runs this program's own grammar, so the checker cannot
recompute it in a clean library-only setting the way it does for arithmetic;
it lists the calls as conditions the proof depends on instead of silently
trusting them.

---

# Try it

- Add `room(garage) --> [garage].` and `state(blinking) --> [blinking].` The
  `rejected` answer disappears, because the sentence is now valid.
- Generate every command: `--goal 'phrase(command(C), Tokens)'`. How many are
  there?
- Extend the grammar with `turn kitchen light on` as a second way to say the
  same command.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 22 (trees, languages, and symbolic evaluation).
