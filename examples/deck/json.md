# JSON

## Can one grammar both read and write JSON?

`library(json)` describes JSON as a definite clause grammar, a set of rules
that relate characters to a Prolog term. Because a grammar is a relation, the
same rules parse JSON text into a term and generate JSON text from a term.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=json) ·
[Source](../json.pl)

---

# The question

How does a JSON document look as a Prolog term, and can that term be turned
back into JSON text? The example parses a small object, including an emoji
written as a pair of UTF-16 escapes, and generates a second object.

---

# The representation

JSON values map to tagged Prolog terms:

- objects are `pairs([Key-Value, ...])`;
- arrays are `list([...])`;
- strings are `string(Chars)` and numbers are `number(N)`;
- booleans are `boolean(true)` or `boolean(false)`, and null is `null`.

The tags keep JSON's types visible. A JSON string and a JSON number never get
confused, even when they print alike.

---

# Two directions, one grammar

```prolog
json_example(parsed, JSON) :-
    phrase(json_chars(JSON), "{\"name\":\"Ada\",\"active\":true,\"scores\":[3,5,8],\"emoji\":\"\\uD83D\\uDE00\"}").

json_example(generated, Chars) :-
    once(phrase(json_chars(pairs([
        string("project")-string("EyeProlog"),
        string("ok")-boolean(true)
    ])), Chars)).
```

`phrase/2` runs a grammar over a character list. The first clause supplies
the text and asks for the term; the second supplies the term and asks for the
text. `once/1` keeps the first rendering, since a grammar may allow several
spellings of the same value.

---

# The answer

```sh
eyeprolog examples/json.pl
```

```text
json_example(parsed, pairs([string("name") - string("Ada"), string("active") - boolean(true), string("scores") - list([number(3), number(5), number(8)]), string("emoji") - string("😀")])).
json_example(generated, "{\"project\":\"EyeProlog\",\"ok\":true}").
```

The surrogate pair `😀` is combined into the single character 😀,
and the generated object comes out as compact JSON text.

---

# The reason

```sh
eyeprolog --proof examples/json.pl
```

```text
step(once(phrase(json_chars(pairs([string("project") - string("EyeProlog"), string("ok") - boolean(true)])), "{\"project\":\"EyeProlog\",\"ok\":true}")),
     control,
     [],
     [phrase(json_chars(pairs([string("project") - string("EyeProlog"), string("ok") - boolean(true)])), "{\"project\":\"EyeProlog\",\"ok\":true}")]).
```

The generated answer rests on `once/1`, recorded as a **control** step whose
only use is the grammar call it committed to, with the text already filled in.

---

# The check

```text
condition('C1', resolution, ok, 2).
condition('C5', re_decision, ok, 1).
obligation(builtin, theory_scoped, phrase(json_chars(pairs([string("project") - string("EyeProlog"), string("ok") - boolean(true)])), "{\"project\":\"EyeProlog\",\"ok\":true}")).
verdict(checked_with_obligations).
```

The two `json_example/2` rules replay, and the `once/1` step is confirmed to
use one of its allowed alternatives. The two grammar calls are recorded as
**theory-scoped** obligations: they depend on the bundled JSON library rather
than on this program's clauses, so the checker names them as trusted premises.

---

# Try it

- Parse `[1, "two", null]` and predict the term before running it.
- Generate JSON from `list([number(1), boolean(false)])`.
- Parse the same object with its keys in a different order. Is the resulting
  term equal to the first one? What does that say about JSON object equality?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 39.
