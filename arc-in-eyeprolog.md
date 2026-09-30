# ARC in EyeProlog — answer, reason, check

> Ask the right question. Get the answer. Understand the reason. Run the check.

[ARC](https://josd.github.io/arc/) turns a precise question into a portable,
executable artifact that answers it, explains the derivation, and checks the
result through a route capable of finding errors. This page is that pattern
written in EyeProlog's own terms, where the artifact is an ordinary Prolog
program, the reason is ordinary Prolog data, and the check is a command.

## 01 — Motivation: why a reasoner should check itself

Answers are cheap. Trustworthy answers are not.

A rule engine that returns `true` has told you that some search succeeded. It
has not told you which rules fired, which facts they rested on, or whether the
arithmetic along the way was right. In most workflows verification is a manual
afterthought: read the output, redo the calculation by hand, ask whoever wrote
the rules.

EyeProlog moves that work into the artifact:

```text
typical workflow    program → answer → someone checks it by hand
EyeProlog           program → answer + proof → checked mechanically
```

This puts the valuable human work upstream — stating the question precisely,
choosing the facts, writing the rules honestly — and leaves the mechanical
work to something that can be run again tomorrow.

An answer does not become trustworthy by being emitted confidently. It becomes
trustworthy by being inspectable, repeatable, and able to be shown wrong.

## 02 — Pattern: how an EyeProlog arc works

Every arc starts from three explicit inputs, and in EyeProlog all three live in
one file:

- **Question** — what do we want to decide? Written as a goal: `%% ?- ageAbove(X0, X1).`
- **Data** — the facts: `birthDay(patH, '1944-08-21').`
- **Logic** — the rules: `ageAbove(S, A) :- birthDay(S, B), ..., F @> A.`

From those it produces three outputs:

```text
INPUT                          OUTPUT
Question ─┐                    ┌─ Answer   what follows
Data ─────┼─→ EyeProlog ───────┼─ Reason   why it follows
Logic ────┘                    └─ Check    whether that why holds
```

Run against [`examples/age.pl`](examples/age.pl), the three are three commands:

```sh
eyeprolog examples/age.pl                                 # Answer
eyeprolog --proof examples/age.pl                         # Reason
eyeprolog examples/age.pl --check-proof examples/proof/age.pl   # Check
```

```text
ageAbove(patH, 'P80Y').
condition('C5', re_decision, ok, 2).
verdict(checked).
```

All three outputs are Prolog. The answer is a term, the proof is a set of
`step/4` facts, and the check result is a set of `condition/4`, `failure/3`,
`obligation/3` and `verdict/1` facts — so each stage can be read by the next
one rather than only by a person.

The question is part of the specification, not a prompt. `%% ?- ageAbove(X0, X1).`
is precise enough to distinguish a right answer, a wrong answer, and a right
answer to a different question — and it stays in the file, so the artifact
carries what it was asked.

Nothing here is trapped in a session. The program is a text file, the proof is
a text file of ordinary Prolog facts, and the check is a process exit status.

## 03 — Trust: the check is the trust contract

An explanation is not verification. A convincing explanation can be produced
for a wrong result, so the check must be capable of **disagreeing** with the
answer.

A proof document is read as a claim, not believed. `--check-proof` tests five
conditions:

| | condition | what it establishes |
| --- | --- | --- |
| **C1** | Resolution | every checked step really is an instance of the clause it cites — and the clause is taken from the program, not from the document, so a proof cannot be made valid by restating the rule it used |
| **C2** | Well-founded | following what a step used never leads back to it; a proof that rested on itself would prove anything |
| **C3** | Justification | every step carries exactly one known justification |
| **C4** | Coverage | every claim has a step, and every use resolves to a step or to a statement the program gives |
| **C5** | Re-decision | a step the document only *asserts* is computed again, independently, and must agree |

C5 is the trust contract. The largest class of steps in a typical proof is the
primitive — arithmetic, comparison, string and date operations that no clause
derives. Reading a document cannot tell whether those are true, so they are run
again against a program holding the bundled libraries and **nothing else**. No
clause of the theory under proof is present, which means the recomputation
cannot be talked into agreeing by the very rules it is auditing.

This is ARC's "genuinely different route", made concrete: not a second
implementation of the same reasoning, but the same primitive decided by a
process that has been denied the theory.

The difference is not theoretical. A document can pass C1 through C4 completely
— every step a proper instance, every use accounted for, no cycles — and still
record a computed value that is simply false, provided it tells the same lie
throughout. Only recomputation catches that one. There is a regression test
that constructs exactly such a document and requires the checker to reject it,
with C5 as the only objecting condition.

A condition that cannot fail is not much of a check.

Not every step needs recomputing to be established. A control construct such as
`once(G)` records the goal it wraps among its uses, and that goal is itself a
step which C1 and C4 already check, so the conclusion is carried rather than
trusted — and the checker verifies that entailment actually holds instead of
assuming it. Constructs that claim something about the *absence* of further
solutions are excluded, because no recorded use can establish an absence.

## 04 — Composition: a checked answer is data

An arc need not stay isolated. Its output is the same kind of thing as its
input, which is what lets arcs compose.

A proof document is not a log; it is a set of ground Prolog facts — `step/4`,
`clause/3`, and the claims themselves. That means the checked answer of one
program can be loaded as the data of the next, and a program can reason *about*
a proof as readily as it reasons about anything else.

```text
program A ──→ answer + proof ──┐
program B ──→ answer + proof ──┼──→ program C ──→ answer + proof + check
facts     ────────────────────-┘
```

The same property connects EyeProlog to the wider data world. RDF quads convert
to ordinary `rdf/4` facts and back, so an arc can take RDF in, reason in
Prolog, and emit RDF out, with the proof of the middle step available for
inspection. The contract at each boundary is explicit, so a larger arc can
check not only its own result but whether the pieces compose into an answer to
the larger question.

## 05 — Scope: what this can and cannot guarantee

Checking makes trust testable. It does not make computation infallible, and
the checker says which is which rather than folding everything into an
undifferentiated success.

- A check is only as strong as its independence. C5's independence comes from
  excluding the theory under proof; that same exclusion is why some steps
  cannot be recomputed at all.
- **Reflective** goals — those reading the program's own database or operator
  table — are outside C5 by construction, since that is exactly what it
  excludes.
- **Stateful** goals — an attributed variable, a constraint store, an open
  stream — depend on state the original run accumulated. Re-running stream
  operations would also perform I/O, and a checker must not have side effects.
- These remain **obligations**: named individually in the checker, counted
  separately in the result, and reported as what the check rests on rather
  than what it establishes.
- A proof does not authenticate its source data. Correct reasoning over wrong
  facts gives a correctly derived wrong answer.
- Negation as failure means a goal did not succeed. It does not establish that
  the negated statement is false.
- Explicit rules can still encode the wrong policy. Being able to read the
  derivation is what makes that reviewable.

Human judgment stays essential, particularly in choosing the question and
deciding what evidence is enough.

## 06 — Applications: where this fits

Rule-driven work with explicit structure and testable correctness conditions:

- tracing a policy decision back to the facts and rules that produced it;
- recomputing an engineering or numeric result by an independent route;
- checking a derivation against invariants, bounds, or known identities;
- auditing a decision months later, from the proof alone, without rerunning
  the search that found it;
- carrying a checked result across a system boundary, where the recipient
  trusts neither the sender nor the sender's engine.

That last one is the case a proof is really for. The recipient does not have to
trust the engine that produced the answer — they can check the document against
the program themselves, with a different copy of the checker if they like.

## 07 — Practice: design principles

- **Question first** — state the goal in the file, not in a shell history.
- **Answer directly** — the answer is a term, not prose about a term.
- **Explain the derivation** — record the clause, the bindings, and what each
  step rested on.
- **Check independently** — recompute what the document merely asserts, from a
  position that cannot reuse the theory.
- **Fail visibly** — a proof that cannot be explained records the answer as
  `unproven` rather than omitting it.
- **Name what is trusted** — an obligation counted and labelled is honest; an
  obligation folded into a success is not.
- **Prefer executable verification** — checking runs in the test suite, not in
  someone's afternoon.
- **Keep artifacts self-contained** — program, answer, and proof are three
  files that can be read and rerun without the machine that made them.

## 08 — Catalogue: the corpus

The pattern is not aspirational here. Every one of the **236 examples** ships
with its answer, the proof of that answer, and the result of checking the
proof, and `npm test` re-checks all of them on every run:

| | |
| --- | ---: |
| examples | 236 |
| packaged proofs | 236 |
| packaged check results | 236 |
| recorded steps | 36432 |
| verified against a source clause | 20753 |
| recomputed independently | 14720 |
| carried by the goal they wrap | 76 |
| remaining obligations | 878 (2.4%) |

Each obligation names the conclusion it stands for, so the residue can be read
rather than only counted. Two thirds of it is one thing: a `\+` step claims a
goal has no proof, and no recorded use can establish an absence.

The proof directory is read from disk rather than from a list, so a document
cannot be added without being checked. An unverified proof is worse than none,
because it still looks like evidence.

Worth reading in order: [`examples/age.pl`](examples/age.pl) for the smallest
complete arc, [`examples/deontic-logic.pl`](examples/deontic-logic.pl) for a
policy decision traced to its rules, and
[`examples/clpz-n-queens.pl`](examples/clpz-n-queens.pl) for a proof of a
constrained search.

## References

- [ARC — answer, reason, check](https://josd.github.io/arc/), the pattern this
  page follows
- [Why EyeProlog?](why-eyeprolog.md), the same argument in the setting of an
  ISO Prolog implementation
- [The Art of EyeProlog](the-art-of-eyeprolog.md), the implementation reference
