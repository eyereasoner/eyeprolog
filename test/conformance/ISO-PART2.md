# ISO/IEC 13211-2:2000 (Modules) — implementation status

This document records, predicate by predicate and directive by directive, what
EyeProlog implements of Prolog Part 2 (Modules). It is a status ledger, not a
conformance claim.

**EyeProlog does not claim Part 2 conformance.** What normal mode provides is a
procedure-oriented module *compatibility layer* built around the widespread
Quintus-style syntax. The ISO interface/body directive surface is not
implemented. `--iso-strict` targets Part 1 + Corrigenda 1-3 only and excludes
module directives and the `:` operator entirely.

## Interface and body directives (ISO form)

Part 2 separates a module *interface* from one or more module *bodies*. None of
this surface is implemented; EyeProlog accepts only the compatibility syntax in
the next section.

| Directive | Part 2 role | Status |
| --- | --- | --- |
| `module/1` | begin the interface for a named module | **not implemented** |
| `export/1` | export locally defined procedures | **not implemented** |
| `reexport/2` | selectively import from another module and export again | **not implemented** |
| `reexport/1` | re-export the exports of named modules | **not implemented** |
| `metapredicate/1` | declare and export context-sensitive procedures (ISO spelling, no underscore) | **not implemented** |
| `op/3` in an interface | initial operators for this module's bodies only | **not implemented** — operator state is global |
| `char_conversion/2` in an interface | initial character conversions for this module's bodies only | **not implemented** — conversion state is global |
| `set_prolog_flag/2` in an interface | initial flag values for this module's bodies only | **not implemented** — flag state is global |
| `end_module/1` | end the interface | **not implemented** |
| `body/1` | begin a body of an already interfaced module | **not implemented** |
| `import/2` | selectively import exported procedures | **not implemented** |
| `import/1` | import all exports of named modules | **not implemented** |
| `end_body/1` | end the module body | **not implemented** |

## Compatibility directives (what EyeProlog actually accepts)

| Directive | Status | Notes |
| --- | --- | --- |
| `module/2` | **implemented** | `:- module(Name, Exports).` Records the named module and its export map. Non-terminal indicators `A//N` are accepted in the export list. |
| `use_module/1` | **implemented** | Imports the full export map of the source module. |
| `use_module/2` | **implemented** | Selective import, validated against the source module's exports. |
| `meta_predicate/1` | **implemented** | Both `:- meta_predicate p(:).` and the parenthesized spelling. Numeric closure modes are a further EyeProlog extension. |
| `ensure_loaded/1` | **implemented** | Imports a module's public predicates while keeping source loading idempotent. |

Only one module body is supported per Prolog text: a second `module/2` in the
same text is rejected rather than switching modules mid-text. Part 2 allows a
module to have several non-contiguous bodies.

## Built-in predicates

| Predicate | Part 2 requirement | Status |
| --- | --- | --- |
| `current_module/1` | enumerate existing modules and test a supplied name; `user` must exist | **not implemented** — raises `existence_error(procedure, current_module/1)` |
| `predicate_property/2` | module-aware predicate-property model | **not implemented** — raises `existence_error(procedure, predicate_property/2)` |
| `clause/2` | module-aware redefinition | **partial** — qualification is resolved, but against the compatibility model rather than Part 2 lookup/defining-module rules |
| `current_predicate/1` | module-aware redefinition | **partial** — as above |
| `asserta/1` | module-aware redefinition | **partial** — as above |
| `assertz/1` | module-aware redefinition | **partial** — as above |
| `retract/1` | module-aware redefinition | **partial** — as above |
| `abolish/1` | module-aware redefinition | **partial** — as above |

The six *partial* rows share one cause: EyeProlog resolves `Module:Goal` and
tracks a single module per goal, whereas Part 2 distinguishes defining module,
lookup module, qualifying module, and calling context. Ordinary calls make
these coincide, so the difference shows up in meta-calls and nested
qualification rather than in everyday use.

## Operators and flags

| Item | Part 2 requirement | Status |
| --- | --- | --- |
| `:` operator | added to the initial operator table as `op(600, xfy, :)` | **implemented** in normal mode (`current_op(600, xfy, ':')`); deliberately absent from the Part 1 strict initial table |
| `colon_sets_calling_context` | a Boolean flag governing whether explicit qualification establishes calling context | **not implemented** — `current_prolog_flag/2` raises `domain_error(prolog_flag, colon_sets_calling_context)` |

## 2013 amendment (WG17 N251) coverage

The requirements clarified by the 2013 amendment draft have executable evidence
in `test/run-iso-part2-amendment.mjs`, which is part of `npm test` and the
conformance aggregate. This is the one part of the Part 2 surface that is
release-gated.

| Amendment clause | Required behaviour | EyeProlog behaviour / evidence |
| --- | --- | --- |
| 6.2.4.1 | A `module(Name, Exports)` directive identifies a named module and its public predicate indicators. | `Program.defineModule()` records the named module and export map. The focused suite checks that public predicates import and private predicates stay module-local. |
| 6.2.5 | A module body is a Prolog text beginning with its `module/2` directive and extending to the end of that text. | Files named by `use_module/1-2` are accepted as module sources only when their first read term is `module/2`. A second `module/2` in the same text is rejected; a distinct text may begin a distinct module body. |
| 6.2.5.5 | `use_module(F, L)` selectively imports the predicates in `L` from the exports of the module defined by `F`. | `Program.importModule()` validates requested indicators against the source module's export map and installs only those imports. |
| 6.2.5.6 | `use_module(F)` imports all exported predicates; the amendment also aligns the public-predicate effect of `ensure_loaded(F)` for a module source. | `use_module/1` imports the full export map. `ensure_loaded/1` imports a module's public predicates while retaining idempotent source loading, including when the module was already loaded for another caller. |
| 6.2.5.7 | `meta_predicate/1` marks context-sensitive arguments; `:` arguments carry the current source/calling module. | Normal parsing accepts `:- meta_predicate p(:).`. Colon-mode arguments are represented as an observable `Module:Goal` term, including when the argument is a variable. |
| 6.4.4.3 | Imported metapredicates preserve the caller's module context for their meta-arguments. | The focused suite verifies both visible `Module:Goal` decomposition and execution of a caller-private predicate through a variable meta-argument. Explicit `Module:Goal` calls set their stated module context. |

## Known gaps

Beyond the *not implemented* rows above, four structural gaps stand between the
current compatibility layer and a Part 2 claim.

1. **Module-local reader/writer state.** Part 2 makes a calling context include
   the operator table, character-conversion mapping, and relevant flag values,
   not just a set of visible procedures. EyeProlog keeps operators, conversions,
   and flags in one global program state, so interface-local environment
   settings cannot be expressed. This is the largest single item.
2. **Four separate module notions.** Defining, lookup, qualifying, and calling
   context are collapsed into one module field per goal.
3. **Re-export and visibility conflicts.** There is no re-export model, and no
   preparation-time rejection of a second import that would make a *different*
   procedure visible under the same unqualified indicator.
4. **Introspection.** `current_module/1` and `predicate_property/2` are absent,
   so the module structure is not observable from within a program.

Interoperability with Scryer, Trealla, or Logtalk is not treated as evidence of
Part 2 coverage.

## See also

- `ISO-PART3.md` — Part 3 (definite clause grammar rules) status
- `ISO-COMPLIANCE.md` — the Part 1 review that carries the release-facing claim
- `ISO-IMPLEMENTATION-DEFINED.md` — implementation-defined choices, including
  the module-qualification error choice
