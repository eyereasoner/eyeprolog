# Deep taxonomy, depth 100000

## Does the whole pipeline (answer, proof, and check) hold up at 300,000 rules?

The largest deep-taxonomy example and a deliberate stress case. The program is
a 300,000-rule chain, its proof is about 12 MB, and the checker replays
100,002 steps. Smaller siblings: [10](deep-taxonomy-10.md),
[100](deep-taxonomy-100.md), [1000](deep-taxonomy-1000.md),
[10000](deep-taxonomy-10000.md).

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=deep-taxonomy-100000) ·
[Source](../deep-taxonomy-100000.pl)

---

# The question

`ind` is in `n0`, each of 100,000 levels lifts it one class higher, and
`n100000` implies `a2`. Is `ind` in `a2`?

The logic is the same as at depth 10. The test is whether parsing, solving,
proof writing, and proof checking all scale linearly.

---

# The rules

```prolog
a(ind, n0).

a(X, a2) :- a(X, n100000).

a(X, n1) :- a(X, n0).
a(X, i1) :- a(X, n0).
a(X, j1) :- a(X, n0).
```

Unlike its smaller siblings, this file has no `holds_result/2` rule and no
`discontiguous` directive, so its clause numbers start one earlier: the top
rule is clause 2, not 4.

---

# The answer

```sh
eyeprolog examples/deep-taxonomy-100000.pl
```

```text
a(ind, a2).
```

`--stats` reports a maximum depth of 100001: one level per class.

---

# The reason

```text
step(a(ind, a2), rule(2), ['X' = ind], [a(ind, n100000)]).
step(a(ind, n100000), rule(300000), ['X' = ind], [a(ind, n99999)]).
step(a(ind, n1), rule(3), ['X' = ind], [a(ind, n0)]).
```

The first step cites the top rule, the second cites clause 300,000 (the
program's last `n` rule), and step 100,001 reaches the bottom of the chain.
Only the `n` rules appear: the 200,000 side-label rules are never touched.

---

# The check

```text
condition('C1', resolution, ok, 100002).
condition('C2', well_founded, ok, 100002).
condition('C4', coverage, ok, 100002).
condition('C7', relevance, ok, 100003).
steps(100002).
trusted(0).
verdict(checked).
```

Every one of the 100,002 steps is replayed against the clause it cites. At
this scale an independent check is the only practical way to trust a proof:
no person will read it.

---

# Try it

- Compare run time and memory with the depth-10000 version. Do they grow by
  about ten times?
- Ask `--goal 'a(ind, n50000)'` and confirm the proof stops halfway.
- Run `npm test` and find where this example's proof is checked.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 11 and 40.
