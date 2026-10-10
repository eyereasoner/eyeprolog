# Term input and output

## Can a program write Prolog terms to a file and read them back intact?

Prolog terms are data that can travel through text. This example writes two
terms to a temporary file, then reopens it to read them back in order, recover
variable names and singletons, and detect the end of the stream.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=iso-term-io) ·
[Source](../iso-term-io.pl)

---

# The question

What does ISO term I/O guarantee when a term makes the round trip through a
text file? Does the term come back the same? Do shared variables stay shared?
Can the reader report which variable names it saw?

The example writes its file under `/tmp`, so run it from the command line.

---

# Writing the fixture

```prolog
:- initialization(write_fixture).

write_fixture :-
  fixture_path(Path),
  open(Path, write, Stream, [type(text)]),
  write_canonical(Stream, event(sensor_7, online)),
  put_char(Stream, '.'),
  nl(Stream),
  write(Stream, rule(X, X, _Y)),
  put_char(Stream, '.'),
  nl(Stream),
  close(Stream).
```

The initialization goal runs once before any query. Output predicates do not
add the final full stop themselves, so the program writes `.` and a newline
after each term to make it readable again.

---

# Reading it back

```prolog
report(variable_metadata, checked) :-
  fixture_path(Path),
  open(Path, read, Stream, []),
  read(Stream, _),
  read_term(Stream, rule(A, A, B), [
    variables([A, B]),
    variable_names([NameA=A, NameB=B]),
    singletons([NameB=B])
  ]),
  atom(NameA),
  atom(NameB),
  NameA \== NameB,
  close(Stream).
```

`read_term/3` returns the term together with its metadata. The pattern
`rule(A, A, B)` requires the first two arguments to come back as one shared
variable. The options report the two distinct variables, their source names,
and the one that occurs only once.

---

# The answer

```sh
eyeprolog examples/iso-term-io.pl
```

```text
report(first_term, event(sensor_7, online)).
report(variable_metadata, checked).
report(reached_end, yes).
```

The first term comes back unchanged. The second keeps its variable sharing and
its singleton. With `eof_action(eof_code)`, a read after the last term returns
`end_of_file`.

---

# The reason

```sh
eyeprolog --proof examples/iso-term-io.pl
```

```text
step(fixture_path('/tmp/eyeprolog-iso-term-io-example.pl'), fact(2), [], []).
step(open('/tmp/eyeprolog-iso-term-io-example.pl', read, '$stream'(1), []), builtin, [], []).
step(read('$stream'(1), event(sensor_7, online)), builtin, [], []).
```

The first report rests on the path fact and three stream operations. Each
operation is recorded with the stream handle and the term it returned.

---

# The check

```text
condition('C1', resolution, ok, 4).
condition('C5', re_decision, ok, 3).
obligation(builtin, stateful, read('$stream'(1), event(sensor_7, online))).
verdict(checked_with_obligations).
```

The rule steps replay against the program. The stream operations cannot: what
`read/2` returns depends on a file and a stream position that existed only
during the run. The checker lists each of those 13 steps as a **stateful**
obligation. The proof is valid on the condition that the file really held
those terms.

---

# Try it

- Replace `write_canonical/2` with `writeq/2` for the first term. Does the
  round trip still work?
- Write a term containing an operator, such as `a :- b`, with `write/2`, and
  read it back.
- Remove the `put_char(Stream, '.')` after the second term. What does the
  reader do with a term that has no full stop?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 37.
