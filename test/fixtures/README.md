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

`prologue_quad.pl` is an unmodified snapshot of the 72 machine-readable quads
for the predicates proposed by the Prolog Prologue working draft:

<https://www.complang.tuwien.ac.at/ulrich/iso-prolog/prologue_quad.pl>

The corresponding working draft is at
<https://www.complang.tuwien.ac.at/ulrich/iso-prolog/prologue>.
The corpus snapshot was retrieved on 2026-09-12; it merges what used to be
tracked as a separate, narrower `call_nth` corpus (retired -- see git
history) and updates the `member/2`, `select/3`, `nth0/3`, and `max_integer`
quads to the working draft's current wording. The regression gate requires
the entire vendored corpus to pass outright, the same as the live Neumerkel
gate checks the current upstream bytes on every `npm test` run (see
[NEUMERKEL-LIVE.md](../conformance/NEUMERKEL-LIVE.md)).

`prologue_quad_runner.pl` loads EyeProlog's `library(prologue)` and includes
the unmodified corpus, mirroring the draft's requirement that a Prologue be
included before its examples are run.
