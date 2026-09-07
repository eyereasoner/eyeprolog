# ISO/IEC 13211-2 module amendment (2013) coverage

This ledger maps EyeProlog's normal module profile to the requirements clarified
by the attached 2013 ISO/IEC 13211-2 amendment draft (WG17 N251). It is narrowly
scoped to that amendment. It does **not** turn the broader ISO/IEC 13211-2:2000
base document into a release-facing certification claim; unchanged Part 2
facilities outside the amendment still need their own clause-by-clause review.

Executable evidence lives in `test/run-iso-part2-amendment.mjs` and is included
in both `npm test` and the conformance aggregate.

| Amendment clause | Required behavior | EyeProlog behavior / evidence |
| --- | --- | --- |
| 6.2.4.1 | A `module(Name, Exports)` directive identifies a named module and its public predicate indicators. | `Program.defineModule()` records the named module and export map. The focused suite checks that public predicates import and private predicates remain module-local. |
| 6.2.5 | A module body is a Prolog text beginning with its `module/2` directive and extending to the end of that text. | Files designated by `use_module/1-2` are accepted as module sources only when their first read term is `module/2`. A second `module/2` later in the same Prolog text is rejected rather than switching modules mid-text, while a distinct Prolog text may begin a distinct module body. |
| 6.2.5.5 | `use_module(F, L)` selectively imports the predicates in `L` from the exports of the module defined by `F`. | `Program.importModule()` validates requested indicators against the source module's export map and installs only those imports. The focused suite verifies selective import. |
| 6.2.5.6 | `use_module(F)` imports all exported predicates; the amendment also aligns the public-predicate effect of `ensure_loaded(F)` for a module source. | `use_module/1` imports the full export map. `ensure_loaded/1` now imports a module's public predicates while retaining idempotent source loading, including when the same module was already loaded for another caller. |
| 6.2.5.7 | `meta_predicate/1` marks context-sensitive arguments; `:` arguments carry the current source/calling module. | Normal parsing accepts the amendment spelling `:- meta_predicate p(:).`. Colon-mode arguments are represented as an observable `Module:Goal` term, including when the argument is a variable. Numeric closure modes remain a separate compatibility extension. |
| 6.4.4.3 | Imported metapredicates preserve the caller's module context for their meta-arguments. | The focused suite verifies both visible `Module:Goal` decomposition and execution of a caller-private predicate through a variable meta-argument. Explicit `Module:Goal` calls continue to set their stated module context. |

## Operator boundary

ISO/IEC 13211-2 adds `:` as the module-qualification operator relative to the
Part 1 initial operator table. EyeProlog therefore predeclares `:` only in its
normal module profile; `--iso-strict` no longer includes it in the Part 1
initial table. Normal mode also predeclares `meta_predicate` as a directive
operator so the amendment's source spelling is accepted, while the parenthesized
`meta_predicate(...)` compatibility spelling remains valid.

## Remaining Part 2 scope

The amendment coverage above is executable and release-gated. EyeProlog still
describes the overall Part 2 surface as a compatibility profile until the
unchanged portions of ISO/IEC 13211-2:2000 - including its broader module
interface and re-export model - have a complete processor/semantics ledger.
See `ISO-PART2-PART3-SCOPE.md` for that release boundary.
