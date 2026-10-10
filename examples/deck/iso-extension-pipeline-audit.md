# ISO extension pipeline audit

## Can one bounded report count, summarize, trace, and check a pipeline?

A five-stage data pipeline is audited in a single query. The report counts
stages and transitions, summarizes each stage, builds a trace, checks every
transition, and compares two pipeline shapes up to variable renaming. Every
relation exported by `library(iso_ext)` takes part.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=iso-extension-pipeline-audit) ·
[Source](../iso-extension-pipeline-audit.pl)

---

# The question

A pipeline receives, parses, validates, reasons, and publishes. Does every
stage hand over to the next, and does the whole thing have the shape we
expect? Rather than answering with a yes or no, the program returns one
`report/6` term that carries the evidence for each part of the answer.

---

# The pipeline

```prolog
stage(0, receive).
stage(1, parse).
stage(2, validate).
stage(3, reason).
stage(4, publish).

transition(Index, From, To) :-
  cfor(0, 3, Index),
  succ(Index, Next),
  stage(Index, From),
  stage(Next, To).
```

`cfor(0, 3, Index)` generates the integers 0 to 3, and `succ/2` relates each
to its successor. A transition joins stage `Index` to stage `Index + 1`.

---

# The audit

```prolog
  countall(stage(_, _), StageCount),
  countall(transition(_, _, _), TransitionCount),
  ...
  findall(
    step(Index, From, To),
    transition(Index, From, To),
    Trace,
    [complete]
  ),
  forall(
    transition(Index, From, To),
    transition_is_well_formed(Index, From, To)
  ),
```

`countall/2` counts solutions. `findall/4` collects into a list whose tail
is given, here `[complete]`. `forall/2` succeeds when every transition passes
the well-formedness test. Finally `variant/2` checks that two schemas are the
same term up to renaming of variables.

---

# The answer

```sh
eyeprolog examples/iso-extension-pipeline-audit.pl
```

```text
pipeline_audit(report(stages(5), transitions(4), summaries([stage(0, receive, outgoing(1)), stage(1, parse, outgoing(1)), stage(2, validate, outgoing(1)), stage(3, reason, outgoing(1)), stage(4, publish, outgoing(0))]), trace([step(0, receive, parse), step(1, parse, validate), step(2, validate, reason), step(3, reason, publish), complete]), invariant(true), schema_variant(true))).
```

Five stages, four transitions, one outgoing edge from every stage except the
last, a trace that ends in `complete`, and both checks true.

---

# The reason

```sh
eyeprolog --proof examples/iso-extension-pipeline-audit.pl
```

```text
step(countall(stage(__anon0, __anon1), 5), builtin, [], []).
step(countall(transition(__anon2, __anon3, __anon4), 4), builtin, [], []).
```

The report comes from rule 9. Its premises are the extension calls
themselves, each recorded as its own step: here, the two counts. The step
for the summaries is a `collected` step: a completed `findall/3` over the
program's own relations.

---

# The check

```text
condition('C1', resolution, ok, 2).
condition('C5', re_decision, ok, 1).
condition('C6', boundary_consistency, ok, 0).
obligation(builtin, theory_scoped, countall(stage(A, B), 5)).
obligation(builtin, theory_scoped, forall(transition(A, B, C), transition_is_well_formed(A, B, C))).
trusted(5).
verdict(checked_with_obligations).
```

The checker replays the rules and recomputes the one extension call that does
not depend on the program (the `variant/2` comparison). The counts, the
collections, and the `forall/2` all range over the program's own facts, so
they cannot be recomputed in isolation. They are listed as five
**obligations**: claims the verdict rests on, named rather than hidden.

---

# Try it

- Add `stage(5, archive).` The report says `stages(6)`, but still
  `transitions(4)` and five summaries: the bounds `cfor(0, 3, …)` and
  `cfor(0, 4, …)` are written into the rules. How would you derive them
  from the data instead?
- Change the second schema in `variant/2` to
  `pipeline(step(_Source, _A), step(_B, _Result))` and predict whether the
  report still appears.
- Replace `findall/4` by `findall/3` and append `[complete]` yourself with
  `append/3`. Which version builds less?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 8 and 39.
