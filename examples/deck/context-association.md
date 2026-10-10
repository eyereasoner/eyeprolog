# Context association

## Which named graph holds the data, which holds its signature, and which holds the signature's metadata?

A signed credential is three layers of statements: the data, a proof over the
data, and a proof over that proof. Each layer is kept as a quoted context, a
term that is named but not asserted. EyeProlog reads inside the contexts to
work out how they are linked, without making any of their contents true.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=context-association) ·
[Source](../context-association.pl)

---

# The question

Verifiable credentials and RDF named graphs both put statements *about*
statements in separate graphs. A verifier has to tell the layers apart: the
claim ("Bob's name is Bob"), the data-integrity proof that signs that claim,
and a second proof that signs the first.

Which graph plays which role? And can we answer that without believing the
claims inside those graphs?

---

# Three quoted contexts

```prolog
log_nameOf(skolem_g0, foaf_name(bob, "Bob")).

log_nameOf(skolem_g1, (
  sec_proof(skolem_g0, dataSignature),
  type(signature1, sec_DataIntegrityProof),
  sec_cryptosuite(signature1, "ecdsa-proof-2019"),
  ...
)).

log_nameOf(g3, (
  sec_proof(skolem_g1, signature2),
  type(signature2, sec_DataIntegrityProof),
  ...
)).
```

`log_nameOf(Name, Context)` names a graph. The second argument is a comma term
holding several statements, but it is **data**: `foaf_name(bob, "Bob")` is not
a fact of the program. Graph `skolem_g1` refers to `skolem_g0`, and `g3` refers
to `skolem_g1`, which is how the layers chain together.

---

# Looking inside without asserting

```prolog
context_member((Left, _right), Member) :- context_member(Left, Member).
context_member((_left, Right), Member) :- context_member(Right, Member).
context_member(Member, Member) :- Member \= (_left, _right).

context_statement(Contextname, Subject, Predicate, Object) :-
  log_nameOf(Contextname, Context),
  context_member(Context, Statement),
  (Statement =.. [Predicate, Subject, Object]).

dataGraph(association, skolem_g0) :-
  context_statement(skolem_g0, bob, foaf_name, "Bob").
```

`context_member/2` walks the comma term, and `=..` splits each member into its
predicate and arguments. `context_statement/4` therefore reads a quoted triple
as data. The three role rules (`dataGraph`, `signatureGraph`, `metadataGraph`)
each look for the statement that identifies one layer.

---

# The answer

```sh
eyeprolog examples/context-association.pl
```

```text
dataGraph(association, skolem_g0).
signatureGraph(association, skolem_g1).
metadataGraph(association, g3).
```

One graph per role. `skolem_g0` carries the data, `skolem_g1` signs it, and
`g3` signs the signature.

---

# The reason

```sh
eyeprolog --proof examples/context-association.pl
```

```text
step(dataGraph(association, skolem_g0),
     rule(8),
     [],
     [context_statement(skolem_g0, bob, foaf_name, "Bob")]).
step(log_nameOf(skolem_g0, foaf_name(bob, "Bob")), fact(1), [], []).
```

`skolem_g0` is the data graph because the quoted statement
`foaf_name(bob, "Bob")` is found inside it, and that context comes straight
from fact 1. In between (omitted here), a step records the `=..` decomposition
that turned the quoted statement into predicate, subject and object.

---

# The check

```sh
eyeprolog --proof examples/context-association.pl > context-association.why.pl
eyeprolog --check-proof context-association.why.pl examples/context-association.pl
```

```text
condition('C1', resolution, ok, 14).
condition('C5', re_decision, ok, 6).
condition('C7', relevance, ok, 23).
recomputed(6).
trusted(0).
verdict(checked).
```

Of the 20 steps, 14 replay a program clause. The other 6 are built-in calls
such as `=..` and `\=`, which the checker recomputes on its own. Nothing is
taken on trust.

---

# Try it

- Ask `--goal 'foaf_name(bob, X)'`. The run stops with
  `existence_error(procedure)`: the claim lives only inside a quoted context, so
  the program has no `foaf_name/2` predicate at all.
- List everything the first signature says:
  `--goal 'context_statement(skolem_g1, signature1, P, O)'` gives nine
  statements, from its type to its validity window.
- Add a fourth context that signs `g3`, and a `metadataGraph`-style rule that
  finds it. How many layers can the same `context_statement/4` read?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 9.
