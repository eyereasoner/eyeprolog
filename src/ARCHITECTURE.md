# EyeProlog source architecture

The runtime is intentionally layered so semantic modules do not depend back on
higher-level frontends.

## Layers

1. **Kernel representation and syntax** — `term.js`, `number-value.js`,
   `syntax-scan.js`, `parser.js`, `write.js`, `errors.js`.
2. **Program preparation** — `program.js`, `source-expansion.js`, plus
   `program-analysis.js` and `program-indexing.js`. Static recursion/Datalog/WFS classification lives in
   `program-analysis.js`; compact clauses and candidate indexes live in
   `program-indexing.js`.
3. **Execution** — `solver.js`, `cleanup.js`, `io.js`, `datalog.js`, `wfs.js`.
   `cleanup.js` owns lifecycle-aware disposal of protected builtin
   iterators and registers the normal-profile cleanup controls without making
   `solver.js` depend back on the language registry.
4. **Language services** — `iso.js`, `iso-arithmetic.js`, `dcg.js`, `atts-host.js`,
   `standard-library.js`, the module-owned `src/<module>-host.js` adapters, and
   the public Prolog modules under `src/lib/`.
5. **Frontends/tools** — `execute.js`, `repl.js`, `cli.js`, `quads.js`,
   `explain.js`, and the playground worker.

`explain.js` owns both proof construction and proof-certificate verification.
Verification walks the supplied certificate and checks source-clause steps against
the parsed `Program`; it does not call the solver to rediscover the proof.
Built-in and abstract library nodes are explicit trust boundaries, while expanded
proofs expose bundled Prolog-library clauses as ordinary source steps.

`iso.js` and `program.js` remain facade modules for their existing exports, so
this refactor does not change the public JavaScript API.

## Dependency rule

Dependencies should point down or sideways within a layer, never back from a
kernel component into the ISO registry or a frontend.  In particular,
`errors.js` owns `PrologError` and `HaltSignal`; DCG expansion can therefore
report processor errors without importing `iso.js` and creating an
`iso.js <-> dcg.js` cycle.

`term.js` also owns the generic annotated-variable storage carried by `Env`.
Annotations are persistent across `Env.clone()` and therefore backtrack with the
substitution. Language services may attach immutable constraint descriptors,
but the unconstrained unification hot path only performs a null check; descriptor
validation and reindexing run only in environments that actually contain
annotations. Descriptors can optionally define logical subsumption so the
store retains only its strongest pending constraints. `dif/2` is the first
descriptor-based user of this mechanism.

`atts-host.js` layers Prolog-visible attributed variables over that same persistent
environment. Per-module attributes follow the current variable representative.
When an attributed variable is about to be bound, the solver runs that module's
`verify_attributes/3` against the still-unbound representative; only a successful
hook permits the binding, and any goals returned in the third argument are queued
immediately after it. Scryer's Prolog `library(clpz)` uses this pre-bind/post-bind
protocol directly for its domains and propagators.

`Env` also owns the small generic backtrackable blackboard used by Scryer-style
libraries. Blackboard maps are shared by clones and copied only on write, so
`bb_b_put/2` follows ordinary Prolog backtracking without any CLP(Z)-specific
state in the VM. Its private runtime bridge is owned by `iso_ext-host.js`, matching
Scryer's canonical `library(iso_ext)` ownership; `library(debug)` may re-export
that interface for EyeProlog compatibility without owning another implementation.

`source-expansion.js` is the explicit compile-time execution boundary. When an
already-loaded `term_expansion/2` or `goal_expansion/2` hook exists, program
preparation invokes it with a fresh bounded `Solver` against the partially built
program. `solver.js` therefore imports clause-selection primitives directly from
`program-indexing.js` rather than importing the `program.js` facade. This is the
one deliberate preparation-to-execution service edge and keeps the JavaScript
import graph acyclic while avoiding a second meta-interpreter solely for source
expansion. `expansion-builtins.js` provides the lower-level `expand_term/2` DCG
service without depending on `Solver`.

The JavaScript runtime stays flat directly under `src/`; `src/lib/` contains the
public Prolog library sources. Runtime-dependent library primitives follow a
one-module/one-host convention: a private `eyeprolog__*` adapter referenced by
`src/lib/foo.pl` must be registered from `src/foo-host.js`. Pure Prolog modules,
such as `library(freeze)`, intentionally have no host file. `standard-library.js`
registers these module hosts without owning their semantics. The architecture
test rejects JavaScript import cycles, verifies private adapter ownership, freezes
the current Scryer export surface for all 32 overlapping bundled modules, and
rejects the retired `library-host.js` and `scryer-compat.js` grab bags. Cleanup
lifecycle hooks are installed from the public API and CLI entry paths, so the
execution layer remains acyclic.

## Performance rule

Architecture changes must not add runtime strategy objects, callbacks, or
extra dispatch in solver hot paths.  Existing scalar/indexed solver paths stay
as direct function calls.  Candidate indexing is separated physically but
retains the same data structures and selection functions.

Large solver fast paths deliberately remain co-located in `solver.js` until a
split can demonstrate performance parity.  A cleaner file layout is not worth a
runtime regression.

Performance claims use `npm test`'s own elapsed time across the full corpus,
not predicate, inference, or host-call counts as a substitute for elapsed
time, and not a separate wall-clock benchmark harness.


## HTTP and JSON library ownership

`src/lib/json.pl` is a pure Prolog DCG adapted from the BSD-licensed Scryer/Trealla JSON library, with Unicode-scalar handling for JSON UTF-16 surrogate escapes. `src/lib/http.pl` owns HTTP option normalization, convenience predicates, request parsing, and the small server facade. Node HTTP/HTTPS client I/O is isolated in `src/http-host.js` and `src/http-worker.js`, following the same module-owned host-adapter convention as sockets, files, crypto, and other runtime-dependent libraries. The worker returns response metadata first and retains the response body behind a body id; the host stream pulls bounded chunks through the bridge on demand, so response size is no longer bounded by the RPC buffer and early `close/1` can discard the remaining transport body.
