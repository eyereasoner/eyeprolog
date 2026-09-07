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

`prologue_quad.pl` is an unmodified snapshot of the 33 machine-readable quads
for the predicates proposed by the Prolog Prologue working draft:

<https://www.complang.tuwien.ac.at/ulrich/iso-prolog/prologue_quad.pl>

The corresponding working draft is at
<https://www.complang.tuwien.ac.at/ulrich/iso-prolog/prologue>.
The corpus snapshot was retrieved on 2026-08-11.

`prologue_quad_runner.pl` loads EyeProlog's `library(prologue)` and includes
the unmodified corpus, mirroring the draft's requirement that a Prologue be
included before its examples are run.

The upstream Prologue snapshot contains one `max_integer` quad that accepts an
implementation-specific `Max = unbounded` result. EyeProlog deliberately does
not patch that vendored fixture: with `bounded=false` it reports no value for
`max_integer`, so `current_prolog_flag(max_integer, _)` fails. Part 1 does not
mandate that outcome -- 7.11.1.1 defines the `bounded` flag and says nothing
about `current_prolog_flag/2` -- so this is an implementation choice, not a
standards requirement. The regression gate records the single divergence
explicitly while requiring the other 32 quads to pass.
