# Bulk stream writing

## Does every character written to a file come back when it is read?

The program writes 5000 characters to a file one at a time, closes it, reopens
it, and counts the characters as it reads them back. The answer is a single
pair of numbers, but the proof records all 35,090 steps behind it.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=bulk-stream-write) ·
[Source](../bulk-stream-write.pl)

File streams need Node; in the browser playground the example cannot open its
file.

---

# The question

Serializers often emit output one character per call. ISO Prolog says each
`put_char/2` appends at the current position of the stream. If that holds, a
file written character by character reads back with exactly as many
characters as were written.

---

# Writing

```prolog
bulk_write_chars(_, 0) :- !.
bulk_write_chars(Stream, N) :-
  N > 0,
  Code is 0'a + (N mod 26),
  char_code(Char, Code),
  put_char(Stream, Char),
  N1 is N - 1,
  bulk_write_chars(Stream, N1).
```

Each call writes one letter from a repeating `a`–`z` cycle and counts down
until nothing is left to write.

---

# Reading back

```prolog
count_chars(Stream, Acc, Count) :-
  get_char(Stream, Char),
  count_chars_step(Char, Stream, Acc, Count).

count_chars_step(end_of_file, _, Count, Count) :- !.
count_chars_step(_, Stream, Acc, Count) :-
  Acc1 is Acc + 1,
  count_chars(Stream, Acc1, Count).

bulk_write_result(Requested, Counted) :-
  Requested = 5000,
  bulk_write_path(Path),
  open(Path, write, Out, [type(text)]),
  bulk_write_chars(Out, Requested),
  close(Out),
  open(Path, read, In, [type(text)]),
  count_chars(In, 0, Counted),
  close(In).
```

Reading stops at `end_of_file`. The file lives under `/tmp`, so the source
tree is never touched.

---

# The answer

```sh
eyeprolog examples/bulk-stream-write.pl
```

```text
bulk_write_result(5000, 5000).
```

5000 characters written, 5000 read back.

---

# The reason

```text
step(bulk_write_chars('$stream'(1), 5000),
     rule(2),
     ['Stream' = '$stream'(1), 'N' = 5000, 'Code' = 105, 'Char' = i, 'N1' = 4999],
     [5000 > 0,
      105 is 97 + 5000 mod 26,
      char_code(i, 105),
      put_char('$stream'(1), i),
      4999 is 5000 - 1,
      bulk_write_chars('$stream'(1), 4999)]).
step(put_char('$stream'(1), i), builtin, [], []).
```

The first write puts `i` on the stream (5000 mod 26 is 8, and `a` plus 8 is
`i`), then hands the remaining 4999 characters to the recursive call.

---

# The check

```text
condition('C1', resolution, ok, 15005).
condition('C5', re_decision, ok, 20028).
obligation(builtin, stateful, put_char('$stream'(1), i)).
obligation(builtin, stateful, get_char('$stream'(2), end_of_file)).
trusted(57).
verdict(checked_with_obligations).
```

The recursion and the arithmetic are replayed in full. Opening, writing,
reading and closing a file are **stateful**: their result depends on the file
system at run time, which a checker cannot recompute. Each distinct I/O step,
57 in all, is listed as an obligation the verdict rests on.

---

# Try it

- Set `Requested = 0`. The answer is `bulk_write_result(0, 0)`: an empty file
  reads back empty.
- Write the same data with a single `write/2` call instead. How does the proof
  change, and how many obligations remain?
- Why is `put_char/2` trusted while `char_code/2` is recomputed?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 37.
