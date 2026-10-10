# RDF 1.2 directional language tags

## Will Arabic text still read right to left after reasoning?

A page has a welcome label in Arabic and in English. RDF 1.2 can record not
only the language of a string but also its base direction. EyeProlog derives
display labels and carries that direction through untouched.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=rdf12-directional-language) ·
[Source](../rdf12-directional-language.pl)

---

# The question

Which display labels does the welcome page have, and in which writing
direction?

This is one of a family of RDF 1.2 examples. RDF data arrives as
`rdf(Subject, Predicate, Object, Graph)` facts, as produced by
[rdf-prolog-interchange](https://github.com/eyereasoner/rdf-prolog-interchange),
and results are printed in the same shape.

---

# The data

```prolog
rdf(iri('https://example.org/welcome'), iri('https://example.org/label'), literal('مرحبا', lang('ar', rtl)), default_graph).
rdf(iri('https://example.org/welcome'), iri('https://example.org/label'), literal('Welcome', lang('en', ltr)), default_graph).
```

A **directional language tag** pairs a language with a base direction:
`rtl` (right to left) for Arabic, `ltr` (left to right) for English. Without
it, an application must guess how to lay out mixed-direction text.

---

# The rule

```prolog
result_rdf(S, iri('https://example.org/displayLabel'), Label, G) :-
  rdf(S, iri('https://example.org/label'), Label, G).
```

The rule copies the whole literal term, text and tag together. Because the
direction is part of the term, it cannot be dropped by accident.

---

# The answer

```sh
eyeprolog examples/rdf12-directional-language.pl
```

```text
result_rdf(iri('https://example.org/welcome'), iri('https://example.org/displayLabel'), literal('مرحبا', lang(ar, rtl)), default_graph).
result_rdf(iri('https://example.org/welcome'), iri('https://example.org/displayLabel'), literal('Welcome', lang(en, ltr)), default_graph).
```

Both labels keep their direction.

---

# The reason

```text
step(result_rdf(iri('https://example.org/welcome'), iri('https://example.org/displayLabel'), literal('مرحبا', lang(ar, rtl)), default_graph),
     rule(3),
     ['S' = iri('https://example.org/welcome'),
      'Label' = literal('مرحبا', lang(ar, rtl)),
      'G' = default_graph],
     [rdf(iri('https://example.org/welcome'), iri('https://example.org/label'), literal('مرحبا', lang(ar, rtl)), default_graph)]).
```

The binding for `Label` shows the Arabic text and its `rtl` direction moving
from the source triple into the result.

---

# The check

```text
condition('C1', resolution, ok, 4).
condition('C4', coverage, ok, 4).
condition('C7', relevance, ok, 6).
trusted(0).
verdict(checked).
```

---

# Try it

- Restrict the rule to right-to-left labels by matching
  `literal(Text, lang(_, rtl))`.
- Add a Hebrew label and predict both outputs.
- Compare with the other RDF 1.2 decks, such as
  [triple terms](rdf12-triple-term.md) and [annotations](rdf12-annotation.md).

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 9.
