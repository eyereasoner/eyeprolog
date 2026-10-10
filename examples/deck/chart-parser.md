# A chart parser

## Is this sentence grammatical, and which phrases does it contain?

Parsing natural language with a recursive grammar can repeat the same work
many times, or loop on left-recursive rules such as "a noun phrase is a noun
phrase followed by a prepositional phrase". Declaring one predicate tabled
turns the recursive recognizer into a chart parser that records each phrase
once.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=chart-parser) ·
[Source](../chart-parser.pl)

---

# The question

Two sentences share one tiny grammar:

- *the robot moves the box*
- *the robot sees the box with the telescope*

The second is the textbook ambiguity: did the robot use the telescope, or does
the box have one? Does each sentence parse, how many parse trees does it have,
and how many noun phrases does it contain?

---

# The grammar

```prolog
rule(s, np, vp).
rule(np, det, noun).
rule(np, np, pp).
rule(vp, verb, np).
rule(vp, vp, pp).
rule(pp, prep, np).
```

Each rule says a category splits into two parts, such as a sentence into a
noun phrase and a verb phrase. `np → np pp` and `vp → vp pp` are
left-recursive, and they are what create the two readings of the second
sentence.

---

# The chart

```prolog
:- table span/4.

span(Sentence, Category, Start, End) :-
  word(Sentence, Start, Token),
  terminal(Category, Token),
  (End is Start + 1).
span(Sentence, Category, Start, End) :-
  rule(Category, Left, Right),
  span(Sentence, Left, Start, Middle),
  span(Sentence, Right, Middle, End).
```

`span(S, C, I, J)` says category `C` covers words `I` to `J`. A word gives a
one-word span; a rule joins two adjacent spans. Because `span/4` is tabled,
each span is computed once and reused, and the left-recursive rules terminate.

---

# Counting trees

```prolog
tree_count(Sentence, Category, Start, End, N) :-
  rule(Category, Left, Right),
  span(Sentence, Left, Start, Middle),
  span(Sentence, Right, Middle, End),
  parse_trees(Sentence, Left, Start, Middle, LeftCount),
  parse_trees(Sentence, Right, Middle, End, RightCount),
  (N is LeftCount * RightCount).
```

The chart stores each span once, however many ways it can be built, so it
cannot count readings by itself. `parse_trees/5` sums, over every rule and
split point that builds a span, the product of the tree counts of its two
parts. Each recursive call covers a strictly shorter interval, so the count
terminates without tabling.

---

# The answer

```sh
eyeprolog examples/chart-parser.pl
```

```text
chart_parser_answer(parsed, command).
chart_parser_answer(parsed, ambiguous_pp).
chart_parser_answer(parse_count, count(command, 1)).
chart_parser_answer(parse_count, count(ambiguous_pp, 2)).
chart_parser_answer(noun_phrase_count, count(command, 2)).
chart_parser_answer(noun_phrase_count, count(ambiguous_pp, 4)).
```

Both sentences parse. The first has one parse tree; the second has two, one for
each attachment of *with the telescope*. The second also has four noun
phrases: *the robot*, *the box*, *the telescope*, and *the box with the
telescope*.

---

# The reason

```sh
eyeprolog --proof examples/chart-parser.pl
```

```text
step(chart_parser_answer(parsed, ambiguous_pp),
     rule(35),
     ['Sentence' = ambiguous_pp, 'Length' = 8],
     [sentence(ambiguous_pp, 8), span(ambiguous_pp, s, 0, 8)]).
step(sentence(ambiguous_pp, 8), fact(3), [], []).
```

The sentence is parsed because a span of category `s` covers all 8 words. The
proof continues downward through the chart: which rule built that span, and
where it split.

---

# The check

```text
condition('C1', resolution, ok, 59).
condition('C5', re_decision, ok, 10).
obligation(builtin, theory_scoped, sumall(A, tree_count(ambiguous_pp, s, 0, 8, A), 2)).
obligation(builtin, theory_scoped, countall(span(ambiguous_pp, np, A, B), 4)).
verdict(checked_with_obligations).
```

The 59 rule steps replay and 10 built-in steps are recomputed. The two
`sumall/3` tree counts and the two `countall/2` noun-phrase counts are
**obligations**: a total says that no further solutions exist, which only a complete search over this program can establish,
so the checker records the claim instead of proving it.

---

# Try it

- Add a tree argument to `tree_count/5` (for example `tree(Category, L, R)`)
  and list the two trees for the second sentence instead of counting them.
- Remove `:- table span/4.` and run the example with a timeout. What happens,
  and which rule causes it?
- Add the word *quickly* and an adverb rule, and parse *the robot quickly
  moves the box*.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 13 and Chapter 22.
