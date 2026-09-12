# Regression fixtures

`phrase_quad.pl` is an unmodified snapshot of Ulrich Neumerkel's ISO Prolog
`phrase/2-3` quad corpus:

<https://www.complang.tuwien.ac.at/ulrich/iso-prolog/phrase_quad.pl>

Retrieved on 2026-08-11. It is vendored so the regression suite exercises all
58 quads without depending on network access or availability of the source
server.

`variable_names_quad.pl` is an unmodified snapshot of the 75 machine-readable
quads for the ISO read and write option `variable_names/1`:

<https://www.complang.tuwien.ac.at/ulrich/iso-prolog/variable_names_quad.pl>

Retrieved on 2026-08-25. It is vendored so all input, output, waiting, and
error cases remain release-gated.

There used to be a `prologue_quad.pl`/`prologue_quad_runner.pl` pair here: an
unmodified snapshot of the Prolog Prologue working draft's machine-readable
quads (<https://www.complang.tuwien.ac.at/ulrich/iso-prolog/prologue_quad.pl>),
plus a runner that loaded `library(prologue)` before including it. It was
retired (see git history) once its coverage became strictly redundant with
the *live* Prologue source the Neumerkel gate already fetches and checks on
every `npm test` run -- the same reason the WG17 syntax matrix has no
vendored snapshot of its own either (see
[NEUMERKEL-LIVE.md](../conformance/NEUMERKEL-LIVE.md) and
[conformance/README.md](../conformance/README.md)). Unlike `phrase_quad.pl`
and `variable_names_quad.pl` below, the vendored Prologue corpus also
included two open-ended STO/rational-tree generator quads
(`member(X,X)`, `select(E,Xs,Xs)`) that made checking it offline
disproportionately slow, with no coverage benefit over the live gate to
justify the cost.
