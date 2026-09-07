# ISO Part 1 Prolog-text, database, and execution matrix

This matrix closes the remaining row-level review for ISO/IEC 13211-1:1995
Clauses 7.4-7.8 against the published Part 1 baseline plus Technical
Corrigenda 1-3. It complements the built-in mode/error matrix: these rows are
processor semantics above individual predicate definitions.

`covered` means the strict profile has an explicit implementation decision and
executable evidence. Where Part 1 leaves a choice implementation-defined, the
chosen behavior is also indexed by `ISO-IMPLEMENTATION-DEFINED.md`.

## 7.4 - Prolog text and preparation

| Row | Status | EyeProlog disposition / executable evidence |
| --- | --- | --- |
| 7.4.1 preparation model | covered | A `Program` is prepared before goal execution. Source units share preparation state where Part 1 permits it; the implementation-defined cross-text choices are recorded in the 5.4 decision index. |
| 7.4.2.1 `dynamic/1` | covered | Strict preparation validates predicate indicators, declaration ordering, protected procedures, and creates an empty dynamic/public procedure even with no clauses. |
| 7.4.2.2 `multifile/1` | covered | Declarations can span source texts and preserve the prepared clause group; declaration/order checks are exercised by the strict/conformance suites. |
| 7.4.2.3 `discontiguous/1` | covered | Strict preparation permits separated clause groups only when declared and preserves their source order. |
| 7.4.2.4 `op/3` | covered | Operator changes affect subsequent text, including later text after an included source; invalid arguments use the same strict validation as the built-in. Earlier text is not reparsed. |
| 7.4.2.5 `char_conversion/2` | covered | With the flag enabled, conversion affects subsequent unquoted source characters; quoted text is unchanged and disabling the flag stops conversion. The mapping can carry into later source units according to the documented implementation-defined choice. |
| 7.4.2.6 `initialization/1` | covered | Goals are retained in preparation order and run after preparation. Reusing the same prepared `Program` does not run them again accidentally. |
| 7.4.2.7 `include/1` | covered | The included text is prepared at the directive position and shares operator/character/flag preparation state with its parent. |
| 7.4.2.8 `ensure_loaded/1` | covered | A source is prepared at most once in the current load graph, including repeated references and self/top-level references. |
| 7.4.2.9 `set_prolog_flag/2` | covered | Preparation-time flag changes affect subsequent text and are replayed into execution state; strict flag names/values/changeability remain governed by the closed 7.11 review. |
| 7.4.3 source clauses | covered | Source heads/bodies are validated like program clauses, standardized static/control procedures are protected, declarations can create empty procedures, and body conversion follows 7.6.2 while preserving head/body variable identity. The built-in restriction applies in every execution mode, so consulting a clause for a built-in predicate or control construct reports the same `permission_error(modify, static_procedure)` as `assert`ing one; EyeProlog's own library and extension predicates are not standard built-ins, so ISO does not protect them. They stay redefinable when they reach the program implicitly, through autoloading or a whole-module `use_module(library(L))`, but the redefinition is reported as a shadowing warning because it replaces the library predicate for all user code in the program. Naming a predicate in an explicit import list, `use_module(library(L), [Name/Arity])`, and then supplying clauses for it is a contradiction and reports `permission_error(modify, static_procedure)`. Bundled library modules keep resolving their own internal calls, so a user redefinition never changes library behaviour. Corpus: `error/iso/consult_redefines_builtin`. |

The strict release test `closes ISO 7.4 Prolog-text preparation and directive
rows` exercises the cross-text operator/character/flag state, include and
ensure-loaded lifetime, initialization order, and one-shot initialization
behavior together. Existing focused tests retain the individual declaration
and preparation error cases.

## 7.5 - database model

| Row | Status | EyeProlog disposition / executable evidence |
| --- | --- | --- |
| 7.5.1 initial database and clause order | covered | Prepared clauses retain textual preparation order. The implementation-defined initial database/standard-procedure choices are documented separately. |
| 7.5.2 static and dynamic procedures | covered | Source procedures are static unless declared dynamic; asserting a previously absent predicate creates a dynamic procedure; modification of protected/static procedures is rejected. |
| 7.5.3 private and public procedures | covered | User static procedures are private to `clause/2` in every execution mode, not only under `--iso-strict`; dynamic procedures are public; standardized built-ins/control forms remain static/private. The NOTE's suggested `public/1` directive is provided as an extension in normal mode, together with a `default_procedure_access` flag that declares every user-defined procedure public; both grant read access only and leave the procedures static. Corpus: `iso/clause_static_and_dynamic_access`, `iso/public_procedure_access`, `error/iso/clause_static_user_procedure`. |
| 7.5.4 database update visibility | covered | Dynamic calls use the logical-update view: an activation continues over the clause set visible when it began, while later activations see successful assertions/retractions. `retractall/1` retains an empty dynamic procedure and `abolish/1` removes it. |

The strict test `closes ISO 7.5-7.7 database, conversion, and execution rows`
pins source order, logical-update behavior, dynamic/public creation, and the
required distinction between an empty declared procedure and an unknown one.
The complete 8.8-8.9 database built-in modes/errors remain covered by
`ISO-BUILTIN-MODE-ERROR-MATRIX.md`.

## 7.6 - conversion between terms and clauses/goals

| Row | Status | EyeProlog disposition / executable evidence |
| --- | --- | --- |
| 7.6.1 term-to-goal/body boundary | covered | Callable terms enter execution as goals; variables are deferred through `call/1`; non-callable numeric/body terms are rejected rather than silently coerced. |
| 7.6.2 term-to-body conversion | covered | Variables become `call/1`; conjunction, disjunction, and if-then bodies are converted recursively; non-control callable terms retain their predication; variable identity is preserved across the converted clause. The conversion runs in every execution mode, for clauses prepared from a Prolog text as well as for `assert`ed clauses, so both paths yield the same body term. Corpus: `iso/clause_body_conversion`. |
| 7.6.3 clause-to-term observation | covered | `clause/2` returns fresh renamed clause observations with the required sharing between head and body. |
| 7.6.4 update conversion | covered | `asserta/1`, `assertz/1`, `retract/1`, and prepared source clauses use the same strict body-conversion rules and reject malformed bodies before database mutation. |

Corrigendum 3's explicit `call/1` term-to-body wording is covered by the source,
asserted-body, and meta-call conversion regressions. In particular, `call/1`
converts an initially unbound variable goal to `call(Var)` before execution; if
an earlier goal later binds that variable to `!`, the resulting `call(!)` keeps
its own opaque cut boundary instead of becoming a textual cut in the enclosing
converted body.

## 7.7 - execution and backtracking

| Row family | Status | EyeProlog disposition / executable evidence |
| --- | --- | --- |
| goal execution / procedure selection | covered | Strict mode uses ordinary clause selection and depth-first backtracking; the normal-profile explicit `table` declaration, `tnot/1`, and recursive numeric shortcuts are unavailable. |
| clause order and re-execution | covered | Clauses are tried in prepared/database order; re-executable predicates expose subsequent solutions on backtracking. |
| empty versus unknown procedure | covered | A defined procedure with zero clauses fails normally. A missing procedure follows the `unknown` flag (`error` by default in the strict profile). |
| side effects and database changes | covered | Standard side effects occur at their execution point; successful dynamic changes become visible to later activations while preserving the logical-update view of active calls. |
| built-in/control delegation | covered | Standardized built-ins dispatch through the strict registry and control constructs through the strict execution path; implementation-specific predicates/shortcuts are excluded by the 5.5 boundary review. |

## 7.8 - control constructs and exceptions

| Row | Status | EyeProlog disposition / executable evidence |
| --- | --- | --- |
| 7.8.1 `true/0` | covered | succeeds once |
| 7.8.2 `fail/0` | covered | fails |
| 7.8.3 `call/1` | covered | executes the converted goal; variables that are unbound at meta-call entry become `call(Var)` before execution, so a later binding to `!` remains an opaque `call(!)`; variables already bound at entry are dereferenced during conversion |
| 7.8.4 cut | covered | cut commits within its defined invocation scope; callee-local cuts and cuts reached through a converted variable goal do not incorrectly prune alternatives outside that invocation |
| 7.8.5 conjunction | covered | left-to-right execution and backtracking; nested malformed converted goals retain the whole control-term culprit |
| 7.8.6 disjunction | covered | left branch is tried before the right and failure backtracks into the right branch |
| 7.8.7 if-then | covered | successful condition commits to the selected condition solution before the then branch |
| 7.8.8 if-then-else | covered | condition success selects the then branch; condition failure selects the else branch with the standard commit boundary |
| 7.8.9 `catch/3` | covered | The protected goal executes inside the catch boundary. Corrigendum 2 behavior is pinned so callability errors arising from that protected goal can be caught. |
| 7.8.10 `throw/1` | covered | Throws propagate until a matching catch and use a renamed/fresh term for exception matching. |

The strict test `closes ISO 7.8 general control-construct and exception rows`
keeps the general semantics visible in addition to the 8.15 built-in review.

## Review result

Clauses **7.4-7.8 are covered at row level** for the declared strict Part 1
profile. Remaining Clause 7 exit work is therefore no longer general
preparation/database/control semantics; it is concentrated in the higher-level
7.10 stream model and residual processor-level 7.12 error requirements.
