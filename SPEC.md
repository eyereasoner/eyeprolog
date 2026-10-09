# The EyeProlog Answer, Proof and Check Format

```text
Title:      The EyeProlog Answer, Proof and Check Format
Version:    eyeprolog 1.6.33
Status:     Informational
Author:     Jos De Roo, KNoWS office of IDLab, Ghent University - imec
Repository: https://github.com/eyereasoner/eyeprolog
```

## Abstract

EyeProlog runs portable ISO Prolog programs and writes their answers together
with a proof whose documents a separate checker verifies against the program
that produced them. This document specifies the goals a run asks, the answers
it reports, the text in which answers, proofs and check reports are written
and read back, the proof document, the seven conditions (C1-C7) a proof
checker establishes, the check report, and the command line that ties them
together.

## Status of This Memo

This document is not an Internet Standards Track specification. It describes
the formats as implemented by eyeprolog 1.6.33, for readers who want to
produce or consume proofs and check reports, or to implement a compatible
reasoner or checker. The Prolog language itself is specified by ISO/IEC
13211-1 and its corrigenda, and EyeProlog's profile of it, its libraries and
its extensions are documented in [*The Art of EyeProlog*](the-art-of-eyeprolog.md).
Where this document and the implementation disagree, that is a defect in one
of them.

## Table of Contents

1. [Introduction](#1-introduction)
2. [Conventions and Terminology](#2-conventions-and-terminology)
3. [Programs and Clause Numbers](#3-programs-and-clause-numbers)
4. [Goals](#4-goals)
5. [Answers](#5-answers)
6. [Written Terms](#6-written-terms)
7. [Proof Recording](#7-proof-recording)
8. [Proof Documents](#8-proof-documents)
9. [Proof Checking](#9-proof-checking)
10. [Check Reports](#10-check-reports)
11. [Command Line](#11-command-line)
12. [Security Considerations](#12-security-considerations)
13. [Conformance](#13-conformance)
- [Appendix A. Document Grammar](#appendix-a-document-grammar)
- [Appendix B. Example](#appendix-b-example)
- [Appendix C. Implementation Notes](#appendix-c-implementation-notes)

---

## 1. Introduction

An EyeProlog run asks goals of a Prolog program and reports their ground
answers. Each answer can be accompanied by a proof: a document that names,
for each step, the program clause, built-in or control construct that
justifies it. A checker that never searches for a derivation verifies such a
document against the program and reports, condition by condition, what it
established and what it had to take on trust.

Answers, proofs and check reports are all ordinary Prolog facts, one term per
clause. Each is something a later program can load and reason over, and none
of them is ever executed when it is read.

The three outputs form an arc: the **answer** says what follows, the
**reason** (the proof) says why, and the **check** says whether that reason
holds. See [*ARC in EyeProlog*](arc-in-eyeprolog.md) for the motivation.

## 2. Conventions and Terminology

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY" and "OPTIONAL" in this document
are to be interpreted as described in BCP 14 (RFC 2119, RFC 8174) when, and
only when, they appear in all capitals.

- **Term**, **clause**, **goal**, **fact**, **rule**, **directive**: as in
  ISO/IEC 13211-1. A fact is a clause whose body is `true`.
- **Callable**: an atom or a compound term.
- **Key**: the name and arity of a callable term, written `name/arity`.
- **Instance**: a term obtained from another by applying a substitution.
- **Identical**: two terms are identical when they are equal in the standard
  order of terms (`==`); variables are identical only to themselves.
- **Variant**: two terms are variants when each is an instance of the other.
- **Ground**: containing no variable.
- **Conjunct**: a goal of a conjunction `(A, B)`, flattened left to right; a
  term that is not a conjunction is its own only conjunct.
- **Claim**: an answer a run reports (Section 5).
- **Document**: Prolog text holding a sequence of facts (Sections 8-10).
- **Reasoner**: an implementation of Sections 3-8, which writes answers and
  proofs, and checks its own proofs as Section 9 describes.
- **Checker**: an implementation of Sections 8-10, which does not depend on a
  reasoner.

## 3. Programs and Clause Numbers

A program is ISO Prolog text, read from one or more sources in the order they
are given. EyeProlog's language profile, its bundled libraries (which a
program MAY load explicitly or have autoloaded) and its extensions are
specified in *The Art of EyeProlog*; with `--iso-strict` the profile is
ISO/IEC 13211-1 with Corrigenda 1-3 only.

A proof cites a clause by its **clause number**. Numbers are given to the
program's own clauses and directives, not to those of a bundled library:

- within a source, the clauses and directives are numbered from 1 in the
  order they occur, except that a `module/2`, `use_module/1,2`,
  `meta_predicate/1` or `attribute/1` declaration takes no number;
- a program read from several sources lays their numbers end to end, in the
  order the sources first contribute a clause: the first clause of the second
  source is numbered one more than the last of the first.

A clause number therefore depends only on the source text, never on what
`assert/1` or `retract/1` do while the program runs.

## 4. Goals

A run asks a sequence of goals. They are, in order of precedence:

1. the goals given on the command line with `--goal` (Section 11) or to the
   embedding API;
2. otherwise, the **declared goals** of the sources: each comment line of the
   form `%% ?- Goal.`, whose goal MAY continue on following lines that begin
   with `%%`, in source order;
3. otherwise, the `?- Goal.` queries of the program, in source order.

A declared goal is a commented-out ISO query, so it reads exactly like the
`?- Goal.` a program may write directly, but it is inert to every other Prolog
processor. A goal is read with the program's operators and `double_quotes`
flag.

## 5. Answers

Each goal is solved in turn with ISO Prolog's execution model, after the
program's initialization goals have run. Every solution that leaves the goal
ground is an answer, the goal's instance under that solution. A solution that
leaves a variable unbound is not reported.

An answer is reported, as its written text (Section 6) followed by `.` and a
newline, unless:

- an answer with the same text was already reported in this run, by this goal
  or an earlier one; or
- its text is that of a fact of the program for the goal's key.

The answers of a run are its **claims**, in the order reported.

## 6. Written Terms

### 6.1 Writing

Answers, proofs and check reports write each term as `writeq/1` would, with
the program's operator table and its `double_quotes` flag in force:

- atoms are quoted where ISO requires it, `'Name'` included;
- operators are written as operators, with the priorities of the program's
  table, and operands parenthesized where needed;
- a list of characters, under `double_quotes(chars)` (the default), is written
  as a double-quoted string, and a list ending in such a list is written
  `[a, b|"cd"]`;
- a variable is written with its name: the name the program or document gave
  it, or a name the engine minted.

The written text of a term MUST read back, with the same operators and flags,
as a term identical to it up to the renaming of variables.

### 6.2 Reading

A document is read as a sequence of Prolog clauses, with the operators and
`double_quotes` flag of the program it is checked against. It is read as data:
a reader MUST NOT execute anything, a directive included. Within one clause a
variable name denotes one variable, and `_` a fresh one each time; variables
are never shared between clauses.

## 7. Proof Recording

When a proof is requested, each claim's derivation is reconstructed by
replaying its goal against the program until the first derivation of that
claim is found, and the derivation is resolved against the final substitution
of the whole derivation: each goal is recorded as it stands once the
derivation is complete, not as it stood when it was solved.

The replay records how each goal was justified: by a clause of the program,
by a built-in or a bundled library predicate, by a control construct and the
goals it wraps, by an absence (`\+`), by a collection (`findall/3`), or by a
clause `assert/1` added at run time.

The **proof detail** decides how far a derivation is explained:

- `abstract` (the default) stops at a bundled library predicate and records
  it as one `builtin` step;
- `expanded` explains through it, recording the library's own clauses as
  `builtin` steps, since they have no clause number.

A claim is replayed as the ground goal it is. When that finds no derivation
-- typically because the program insists on computing an argument itself, as
a counter, a generated name or a stream handle is computed -- the goal the
run asked is replayed instead, and the first derivation whose answer is the
claim is recorded.

A goal `Module:Goal` is replayed as `Goal` in `Module`, as the solver runs it:
in a bundled library under `abstract` detail as one `builtin` step for the
qualified goal, and otherwise as a `control` step whose use is `Goal`.

A derivation deeper than the replay's nesting budget continues as a **chain**:
each level commits to the first clause whose head matches the goal and whose
body, up to a final call of a program predicate, is proved, and that final
call is the next level. A chain finds the leftmost derivation -- the one
depth-first search finds first -- whenever that derivation needs no
backtracking into an earlier level, so a deterministic recursion of any depth
is explained without nesting.

A claim whose derivation the replay still cannot reproduce -- an answer that
depends on state the run changed, such as a counter kept in the database --
is recorded as `unproven` rather than left without a step. A document
containing such a step is not a valid proof (Section 9.4).

### 7.1 Self-check

A reasoner MUST check every proof it generates, as Section 9 describes and
against the goals the run asked, before writing it, and MUST fail with an
error rather than write a proof that does not pass. The answers a run has
already reported stay reported; only the proof is withheld. A run with
`unproven` steps therefore fails when a proof is asked of it. A run without
claims has a proof without claims, which is valid and certifies nothing.

A reasoner MAY check the structures its proof is written from rather than
reading the written document back, provided the report is the one reading
the document would give.

## 8. Proof Documents

### 8.1 Structure

A proof document is a document (Section 6.2) holding, in this order:

1. the claims of the run (Section 5), one per line;
2. an empty line;
3. one `clause(N, Head, Body)` per program clause the proof cites, by
   increasing `N`;
4. an empty line;
5. one `step(Goal, By, Bindings, Uses)` per justified goal.

A run without claims writes no proof. A checker MUST treat every fact that is
neither `clause/3` nor `step/4` as a claim, whatever its position.

### 8.2 Clause records

`clause(N, Head, Body)` restates clause `N` (Section 3). `Body` is `true` for
a fact, and the clause's body goals joined right-associatively with `,`
otherwise. So that the identity of a variable survives being written into a
separate fact, each variable of the clause is written as a term:

- a named variable `X` as `var('X')`;
- a variable whose name begins with `_` as `anonymous(I)`, numbered from 1 in
  order of first occurrence within the record;
- a variable the engine minted (a name such as `Var#17`, containing a number
  that counts across the whole run) as `var('Var#K')`, where `K` numbers the
  minted variables from 1 in order of first occurrence across the whole
  document.

Records are not authority: a checker MUST compare each with the program it
checks against (Section 9.2).

### 8.3 Steps

`Goal` is the justified goal as it stands once the whole derivation is found.
Steps appear in the order a depth-first, left-to-right walk from the claims
first meets each goal; each distinct goal (by written text) has one step, and
a conjunction contributes its conjuncts rather than a step of its own. `Uses`
is the list of the goals that justify `Goal`, in order. `By` is one of:

| `By` | Meaning | `Bindings` | `Uses` |
| --- | --- | --- | --- |
| `rule(N)` | `Goal` is an instance of the head of rule `N`, whose body instance is `Uses`. | the clause's variables | the body instance |
| `fact(N)` | `Goal` is an instance of fact `N`. | the clause's variables | empty |
| `builtin` | `Goal` is a built-in or bundled library goal that holds. | empty, or a library clause's variables under `expanded` | empty, or a library clause's body under `expanded` |
| `control` | `Goal` is `call/1`, `once/1`, `ignore/1`, `catch/3`, `M:G`, a disjunction or an if-then, solved by `Uses`. | empty | the goals that solved it |
| `absent` | `Goal` is a negation `\+ G` taken on trust. | empty | empty |
| `collected` | `Goal` is a `findall/3` taken on trust. | empty | empty |
| `asserted` | `Goal` was solved by a clause added at run time, which has no clause number. | empty | empty |
| `unproven` | The replay could not reproduce `Goal` (Section 7). | empty | empty |

`Bindings` is a list of `'Name' = Value` pairs, one per variable of the cited
clause that the derivation bound, named as the program wrote it, in order of
first occurrence in the head and then the body; variables whose names begin
with `_` are left out. A checker MUST accept any subset, since the goal and
uses determine the rest.

Minted variables and stream handles (`'$stream'(I)`) in steps are renumbered
in order of first occurrence across the document, as in Section 8.2, so that
the same program writes the same document on every run.

## 9. Proof Checking

A checker is given a program, a proof document and the goals the proof
answers (Section 4). It MUST NOT search for a derivation the document failed
to record and MUST NOT run the program; it MAY recompute built-ins in a
program that holds no clause of the program under check (Section 9.6). It
establishes seven conditions and records each failure with its condition, a
detail and, where there is one, the term concerned.

### 9.1 Reading the document

The document MUST read (Section 6.2); otherwise C3 fails and the document has
no claims and no steps. A rule or a directive fails C3 and is set aside. Each `step/4` MUST have bindings that form a proper list of
`'Name' = Value` pairs with `Name` an atom, and uses that form a proper list;
otherwise C3 fails and the step is set aside. No two steps MAY have identical
goals: a second step for a goal fails C3 and is set aside. Every other fact
that is not `clause/3` is a claim (Section 8.1).

### 9.2 C1 Resolution

Each `clause(N, Head, Body)` record MUST be the record of Section 8.2 for
program clause `N`, up to renumbering its minted variables in order of first
occurrence within the record.

For a `rule(N)` or `fact(N)` step, `N` MUST be a clause number of the program,
and for `fact(N)` the clause MUST be a fact. The clause, renamed apart, MUST
satisfy: each binding names a distinct variable of the clause and unifies it
with its value; the head unifies with `Goal`; and the body, of the same length
as `Uses`, unifies with `Uses` pairwise, such that afterwards the head is
identical to `Goal` and each body goal to its use. A step's own terms MUST NOT
need further instantiation to match: a clause `same(X, X)` cannot justify
`same(a, b)`, and a fact `goal(_, y)` justifies `goal(x, y)` only when the
document's `Goal` is `goal(x, y)` itself.

### 9.3 C2 Well-foundedness

No step MAY depend on itself through the conjuncts of the uses of steps.

### 9.4 C3 Justification

`By` MUST be one of the forms of Section 8.3, other than `unproven`, which
always fails C3. A `builtin` step MUST have a callable goal. An `absent` step
MUST have a goal `\+ G` and a `collected` step a goal `findall(T, G, L)`;
otherwise the justification is unknown. Neither MAY have bindings or uses.

### 9.5 C4 Coverage

Each conjunct of each claim MUST have a step. Each conjunct of each use MUST
have a step or be an instance of a fact of the program. A document without
claims is valid and certifies nothing.

### 9.6 C5 Re-decision

A `builtin` step is **re-decided**: its goal is solved, for its first
solution, against a program that holds the bundled libraries the document's
goals need (a goal qualified with a bundled library's module loads that
library) and no clause of the program under check, so a goal only the
program could satisfy cannot succeed. The step agrees when the goal succeeds
and is afterwards a variant of itself, that is, solving it bound nothing but
fresh variables. It fails C5 when the goal fails, binds something, or raises
an error other than an existence error for a procedure. When the goal raises
an existence error, the predicate is not one the libraries define, and the
step cannot be re-decided.

A `builtin` step whose goal is one of the following is never re-decided: a
**reflective** goal, which reads the program's own database or syntax
(`clause/2`, `current_predicate/1`, `current_op/3`), or a **stateful** goal,
which depends on attribute, constraint or stream state the run built up, or
would perform I/O (`get_atts/2`, `put_atts/2`, `open/3,4`, `close/1,2`,
`read/2`, `read_term/3`, `write/2`, `write_term/3`, `nl/1`, `set_input/1`,
`set_output/1`, `current_input/1`, `current_output/1`, `at_end_of_stream/1`,
`stream_property/2`, `put_char/2`, `put_code/2`, `put_byte/2`, `get_char/2`,
`get_code/2`, `get_byte/2`, `peek_char/2`, `peek_code/2`, `peek_byte/2`,
`writeq/2`, `print/2`, `write_canonical/2`, `format/3`, `flush_output/1`,
`set_stream_position/2`, `gensym/2`, `reset_gensym/0,1`, the CLP(B) `sat/1`,
`taut/2`, `sat_count/2` and `weighted_maximum/3`, and the CLP(Z) `fd_var/1`,
`fd_inf/2`, `fd_sup/2`, `fd_size/2`, `fd_dom/2` and `fd_degree/2`). Such a step, and one
that cannot be re-decided, is a trusted boundary of kind `builtin`, with the
reason `reflective`, `stateful` or `theory_scoped`.

A `control` step MUST have no bindings, and its uses MUST be identical, in
order, to one of the **alternatives** of its goal:

| Goal | Alternatives |
| --- | --- |
| `call(G)`, `once(G)`, `ignore(G)`, `catch(G, C, R)`, `M:G` | the conjuncts of `G` |
| `(C -> T)`, `(C *-> T)` | the conjuncts of `C`, then those of `T` |
| `(C -> T ; E)`, `(C *-> T ; E)` | the conjuncts of `C`, then those of `T`; or the conjuncts of `E` |
| `(A ; B)` | the conjuncts of `A`; or the conjuncts of `B` |

A `builtin` step with uses whose goal has alternatives and cannot be
re-decided is held to the same rule, as written by earlier versions.

`absent`, `collected` and `asserted` steps are trusted boundaries of their own
kind, with the reason `theory_scoped`. When trusted boundaries are forbidden
("strict"), each trusted boundary, of any kind, fails C5.

### 9.7 C6 Boundary consistency

A trusted absence or collection cannot be proved, but the evidence at hand
can refute it.

A predicate is **evidential** when it has clauses in the program, is not
declared dynamic, is not the target of an `assert/1`, `asserta/1`,
`assertz/1`, `retract/1`, `retractall/1` or `abolish/1` call written with a
callable argument (or a `Name/Arity` indicator) in any program clause, is not
the key of an `asserted` step, and every goal of every one of its clause
bodies is, through `,` and `;` but not `->` or `*->`, either a call of an
evidential predicate or one of `true/0`, `fail/0`, `false/0`, `=/2`, `is/2`,
the arithmetic comparisons, `member/2`, `append/3`, `select/3`, `between/3`,
`succ/2` and `plus/3`. When any program clause calls a database update with a
variable argument, no predicate is evidential. A recursive call is assumed
evidential while its predicate is being decided.

The **evidence** for a goal is:

- when the goal is a control construct (`,`, `;`, `->`, `*->`, `\+`,
  `call/1`, `once/1`, `ignore/1`, `catch/3`, `:/2`, `findall/3,4`, `forall/2`,
  `bagof/3`, `setof/3`, `aggregate_all/3,4`), none: the boundary is left
  undecided;
- when the goal's predicate has program clauses: if it is evidential, the
  heads of its facts and the goals of the document's steps with the same key;
  otherwise none;
- otherwise, when the goal is ground and may be re-decided (Section 9.6): the
  goal itself if re-deciding it agrees, no solution if the goal fails, and
  none if it cannot be re-decided or raises an error;
- otherwise none.

Then:

- An absence `\+ G` is decided when `G` is a single goal, or a ground
  conjunction, whose every conjunct has evidence. It fails C6 when every
  conjunct of `G` unifies with some of its evidence.
- A collection `findall(T, G, L)` fails C6 when `L` is not a proper list, and
  is decided when `G` is a single goal with evidence. It fails C6 when, for
  some evidence `E` of `G`, the instance of `T` under the unifier of `G` and
  `E` unifies with no element of `L`.

Evidential predicates are pure positive Horn clauses, so a call of one
finitely fails only when no instance of it is provable, and a completed
`findall/3` over one has enumerated all of its provable instances. That is
what makes the evidence able to refute a boundary. A boundary that is not
refuted remains an obligation (Section 10).

### 9.8 C7 Relevance

The **questions** are the goals the proof answers (Section 4). When there
are none and the program has forward rules (`Conclusion :+ Premise`, run to a
fixed point when no goal is asked), the questions are, for each forward rule,
each conjunct of its conclusion other than `false`, and, for a rule whose
conclusion is `true`, its premise. Each claim
MUST be an instance of a question: unifying a fresh copy of the question with
the claim must leave the claim identical to itself. Each step MUST be
reachable from a conjunct of a claim through the conjuncts of uses.

### 9.9 Counts and validity

| Condition | Covered |
| --- | --- |
| C1 resolution | `rule` and `fact` steps that passed C1 |
| C2 well_founded | steps |
| C3 justification | steps |
| C4 coverage | claims plus the uses of all steps |
| C5 re_decision | `builtin` steps that agreed plus `control` steps that composed |
| C6 boundary_consistency | boundaries decided |
| C7 relevance | claims plus steps |

Steps set aside while reading (Section 9.1) are not counted. A check also
counts the **steps**, the **claims**, the steps **verified** by C1, the
`builtin` steps **recomputed** by C5, the steps **composed** by C5, and the
**trusted** boundaries.

A proof is **valid** when no condition failed. A valid proof with trusted
boundaries is valid *conditional on* them.

### 9.10 What a valid proof establishes

A valid proof establishes that each of its claims follows from the program by
the recorded steps, given its trusted boundaries. It does not establish that
the claims are all the answers of the program, that the program terminates,
or that the program is the one intended: a proof MAY leave answers out, and a
run's own proof holds exactly its claims.

## 10. Check Reports

A check report is a document holding, in this order, one fact per line:

1. `condition(Id, Name, Outcome, Covered)` for C1 to C7, where `Name` is the
   name of Section 9.9, and `Outcome` is `ok` or `failed(N)`, `N` the number
   of that condition's failures;
2. `failure(Condition, Subject, Detail)` per failure, where `Subject` is the
   term concerned or `proof_document`, and `Detail` an atom;
3. `obligation(Kind, Reason, Goal)` per trusted boundary, in step order,
   where `Kind` is `builtin`, `absent`, `collected` or `asserted` and `Reason`
   is `theory_scoped`, `reflective` or `stateful`;
4. `steps(N)`, `verified(N)`, `recomputed(N)`, `composed(N)`, `trusted(N)`,
   `claims(N)`, the counts of Section 9.9;
5. `verdict(V)`, where `V` is `failed(N)` when `N` failures were recorded,
   otherwise `checked_with_obligations` when there are trusted boundaries,
   otherwise `checked`.

Terms are written as in Section 6.1, with the variables of each fact renamed
`A`, `B`, ..., `Z`, `A1`, ..., `Z1`, `A2`, ... in order of first occurrence.
A report is ordinary data: a program MAY load it as facts.

Failures are listed in the order they are found: those of reading the
document (Section 9.1), in document order; C1 for each clause record, in
record order; C3 for each duplicate step, in document order; C4 for each
claim, in claim order; then for each step, in document order, C4 for its uses
and the C1, C3 or C5 failure of its justification; C6 for each boundary, in
step order; C7 for each claim, then for each step; and C2.

`Detail` is a short human-readable text that names what failed, often with
the written text of a term; it is informative, and implementations MAY word
it differently. EyeProlog's details are, by condition:

| Condition | Details |
| --- | --- |
| C1 | `clause record differs from source`, `unknown clause ...`, `clause N has a body, so it is not a fact`, `not an instance of source clause N: ...` |
| C2 | `cyclic derivation at ...` |
| C3 | `the document does not read: ...`, `a proof document holds facts only`, `step bindings must be a list of 'Name' = Value pairs and uses a list`, `duplicate justification for ...`, `invalid builtin justification`, `trusted boundaries cannot have bindings or uses`, `recorded as unproven`, `unknown justification ...` |
| C4 | `unjustified claim ...`, `unjustified use ...` |
| C5 | `primitive disagrees: ...`, `primitive went wrong: ...`, `control step does not follow from its uses: ...`, `trusted boundary forbidden: Kind` |
| C6 | `absence contradicted by evidence: ...`, `collected result is not a proper list: ...`, `collection misses ...: ...` |
| C7 | `claim answers no goal: ...`, `step serves no claim: ...` |

The JSON form of a report is an object with `valid` (boolean), `steps`,
`claims`, `verified`, `redecided` (the count `recomputed`), `composed`,
`uses` (the number of uses of all steps, integers), `trusted` (a list of
`{kind, reason, conclusion}`), `failures` (a list of
`{condition, detail, conclusion?}`) and `conditions` (a list of
`{id, name, covered, failed}`), where `conclusion` is the written text of the
term concerned.

## 11. Command Line

```text
eyeprolog [OPTION ...] [FILE-OR-URL ... | -]
```

The options that concern this document are:

| Option | Meaning |
| --- | --- |
| (none) | Load the sources, or standard input, as one program and print its answers (Section 5). |
| `-p`, `--proof` | Print the proof document (Section 8) instead. |
| `--proof-detail abstract\|expanded` | Select the proof detail (Section 7); implies `--proof`. |
| `-g`, `--goal GOAL` | Ask `GOAL`; MAY be repeated (Section 4). With `--check-proof`, the goals the proof answers. |
| `--check-proof FILE` | Check the proof in `FILE` (`-` for standard input) against the program and print its report (Section 10). |
| `--strict-proof` | With `--check-proof`, forbid trusted boundaries. |
| `--json` | With `--check-proof`, print the report as JSON. |
| `--quiet` | With `--check-proof`, print only the `verdict/1` fact. |
| `--iso-strict`, `--no-autoload` | Select the language profile (Section 3). |
| `-h`, `--help`, `-v`, `--version` | Print the usage, or the version. |

`--check-proof` MUST NOT be combined with `--proof` or `--quads`, and `--json`
and `--strict-proof` need `--check-proof`. With `--check-proof -` the proof is
read from standard input, so the program MUST be named as a file:

```sh
eyeprolog --proof p.pl | eyeprolog --check-proof - p.pl
```

A program text with a line starting with `step(`, no line starting with `:-`
and no declared goal is a proof document; given one as a program without
goals, the command line MUST say how to check it instead.

| Exit code | Meaning |
| --- | --- |
| 0 | Success, including a check that found the proof valid. |
| 1 | An error, printed to standard error as `eyeprolog: message`, including a run whose proof does not check (Section 7.1). |
| 2 | A check that found the proof not valid; the report is printed as usual. |

A program MAY choose its own exit status with `halt/1`.

## 12. Security Considerations

A **program** is Prolog code and runs with the privileges of whoever runs it;
it MAY read and write files, open sockets and run initialization goals. Only
programs from trusted sources should be run.

A **document** (answers, proofs and check reports) is untrusted data. It MUST
NOT be executed: it is read as clauses (Section 6.2), so no directive in it
runs, and the checker consults it only by unification and comparison.
Checking a proof from a third party therefore runs none of the third party's
code. C5 runs built-in goals the document records, but in a program that
holds only the bundled libraries, and never a stream operation (Section 9.6);
a deployment that checks untrusted proofs SHOULD still bound document size,
nesting depth and running time, since a recorded goal MAY be expensive to
recompute.

A valid proof establishes that its claims follow from the program supplied
to the checker (Section 9.10). It does not establish that the program is
correct or that the claims are all its answers, and a proof with obligations
holds only conditional on them.

## 13. Conformance

A conforming **reasoner** implements Sections 3 to 8, produces answers and
proof documents in the written form of Section 6, and checks every proof it
produces as Section 7.1 requires. A conforming **checker**
implements Sections 8 to 10 and does not depend on a reasoner. For the same
program and goals, a conforming reasoner and checker MUST produce the same
answers, proof documents and reports as eyeprolog 1.6.33, byte for byte,
except for the `Detail` texts of failures (Section 10) and where the host's
floating-point library functions differ in the last digit.

The repository's examples, with their saved answers (`examples/output/`),
proofs (`examples/proof/`) and reports (`examples/check/`), test this on 236
programs, each with its proof; `npm test` regenerates and re-checks every one of them, as well as
the proof cases of the conformance suite in `test/conformance/proofs/`.

---

## Appendix A. Document Grammar

A document is Prolog text read with the operators and flags of the program it
belongs to (Section 6.2). Its clauses are facts of these forms, in the ABNF
style of RFC 5234, where `term` is an ISO Prolog term at priority 999 and
`claim` any other callable term:

```abnf
proof       = *( claim "." ) [ blank *( record "." ) ] [ blank *( step "." ) ]
record      = "clause(" integer "," template "," template ")"
template    = term                   ; variables written as var('X') or anonymous(I)
step        = "step(" term "," by "," bindings "," uses ")"
by          = "rule(" integer ")" / "fact(" integer ")" / "builtin" / "control"
            / "absent" / "collected" / "asserted" / "unproven"
bindings    = "[" [ binding *( "," binding ) ] "]"
binding     = quoted-atom "=" term
uses        = "[" [ term *( "," term ) ] "]"

report      = 7condition *failure *obligation counts verdict
condition   = "condition('" id "', " name ", " outcome ", " integer ")."
id          = "C1" / "C2" / "C3" / "C4" / "C5" / "C6" / "C7"
name        = "resolution" / "well_founded" / "justification" / "coverage"
            / "re_decision" / "boundary_consistency" / "relevance"
outcome     = "ok" / "failed(" integer ")"
failure     = "failure('" id "', " term ", " quoted-atom ")."
obligation  = "obligation(" kind ", " reason ", " term ")."
kind        = "builtin" / "absent" / "collected" / "asserted"
reason      = "theory_scoped" / "reflective" / "stateful"
counts      = "steps(" integer ")." "verified(" integer ")." "recomputed(" integer ")."
              "composed(" integer ")." "trusted(" integer ")." "claims(" integer ")."
verdict     = "verdict(" ( "checked" / "checked_with_obligations"
            / "failed(" integer ")" ) ")."
```

Line breaks and layout inside a term are free; the documents EyeProlog writes
put each claim and report fact on one line and MAY break a long clause record
or step across several.

## Appendix B. Example

The program `socrates.pl`:

```prolog
%% ?- mortal(X).

human(socrates).
human(plato).
god(zeus).
mortal(X) :- human(X), \+ god(X).
```

Its answers:

```prolog
mortal(socrates).
mortal(plato).
```

Its proof document (Section 8):

```prolog
mortal(socrates).
mortal(plato).

clause(1, human(socrates), true).
clause(2, human(plato), true).
clause(4, mortal(var('X')), (human(var('X')), \+ god(var('X')))).

step(mortal(socrates), rule(4), ['X' = socrates], [human(socrates), \+ god(socrates)]).
step(human(socrates), fact(1), [], []).
step(\+ god(socrates), absent, [], []).
step(mortal(plato), rule(4), ['X' = plato], [human(plato), \+ god(plato)]).
step(human(plato), fact(2), [], []).
step(\+ god(plato), absent, [], []).
```

Its check report (Section 10). Both absences are decided by C6, since `god/1`
is evidential and no fact or step shows `god(socrates)` or `god(plato)`, but a
decided boundary that is not refuted is still an obligation:

```prolog
condition('C1', resolution, ok, 4).
condition('C2', well_founded, ok, 6).
condition('C3', justification, ok, 6).
condition('C4', coverage, ok, 6).
condition('C5', re_decision, ok, 0).
condition('C6', boundary_consistency, ok, 2).
condition('C7', relevance, ok, 8).
obligation(absent, theory_scoped, \+ god(socrates)).
obligation(absent, theory_scoped, \+ god(plato)).
steps(6).
verified(4).
recomputed(0).
composed(0).
trusted(2).
claims(2).
verdict(checked_with_obligations).
```

Had the document claimed `mortal(zeus)` with the step
`step(\+ god(zeus), absent, [], [])`, C6 would have failed it: the fact
`god(zeus)` is evidence that the absence did not hold.

## Appendix C. Implementation Notes

This appendix is informative: it describes how this version of EyeProlog
implements this document, not requirements on other implementations.

| File | Responsibility |
| --- | --- |
| [src/execute.js](src/execute.js) | Solving goals and reporting answers (Section 5) |
| [src/goal-metadata.js](src/goal-metadata.js) | Declared `%% ?-` goals (Section 4) |
| [src/explain.js](src/explain.js) | The proof replay, clause numbering and the flat proof (Sections 3, 7, 8) |
| [src/result-format.js](src/result-format.js) | Writing answers, clause records and steps (Sections 6, 8) |
| [src/proof-document.js](src/proof-document.js) | Checking a run's own proof before it is written (Section 7.1) |
| [src/check-proof.js](src/check-proof.js) | Reading and checking proof documents and writing reports, with no search of the program (Sections 9, 10) |
| [src/cli.js](src/cli.js) | The command line (Section 11) |
| [test/run-proof-checking.mjs](test/run-proof-checking.mjs) | Re-checking every packaged proof against its saved report |

**The proof is a replay, not a trace.** The engine answers goals without
recording anything; when a proof is asked for, each answer is replayed against
the program until its first derivation is found. The replay resolves every
node of that derivation again once it is complete, so a goal solved early in a
derivation is recorded with the bindings later goals gave it.

**Deep derivations are replayed iteratively.** A ground goal that a chain of
single-goal clauses proves, each with exactly one matching clause, is followed
directly, so a taxonomy thousands of levels deep is proved without a host
call frame per level. Past its nesting budget the general replay continues as
a chain (Section 7), flattening its binding history as it goes, and the
derivation is resolved once at the end with every variable chain remembered,
so a recursion threading an output argument through ten thousand levels is
explained in time linear in its depth.

**A reasoner checks its own proofs in memory.** The proof a run builds is
checked as the claims, clause records and steps it is written from, which
gives the report reading the written document back would give, without
writing and reading it; `--check-proof` reads and checks the text. That the
two agree is what checking the packaged documents establishes.

**C5 is independent by construction.** The program a `builtin` step is
re-decided in is built once per document, from an empty source with the
libraries the recorded goals autoload. No clause of the program under check
is present, so the re-decision cannot be talked into agreeing by the rules it
audits.

**C6 asks only evidence it can trust.** Prolog's cuts, if-then-else, type
tests and negation make a call with fewer bindings able to answer differently
from one with more, so evidence about one call says nothing about another.
The checker therefore takes evidence only from predicates whose definitions
are static and pure positive Horn clauses all the way down (Section 9.7), and
leaves every other boundary undecided rather than guessing.

**A check is ordinary Prolog.** The report is written by the same writer as
the answers and proofs, with the program's operators, so `\+ G` in an
obligation reads exactly as it did in the proof.
