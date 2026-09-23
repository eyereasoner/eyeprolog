# OpenRuleBench Prolog pack: EyeProlog + Trealla + Scryer + SWI-Prolog

This archive is a multi-engine OpenRuleBench-to-Prolog adaptation. It contains
the same generated benchmark data in four source directories:

- `eyeprolog/` — EyeProlog-oriented files, including `%% ?-` goal comments.
- `trealla/` — Trealla-ready copies. Positive recursive programs declare `library(tabling)` when needed.
- `scryer/` — Scryer-ready copies with the same tabling declarations.
- `swipl/` — SWI-Prolog copies using native `table/1`; the WFS benchmarks use native `tnot/1`.

The data/provenance caveat from the original pack still applies: this is not a
byte-for-byte archival copy of the historical OpenRuleBench distribution. The
historical real-world corpora that could not be reliably retrieved are represented
by deterministic synthetic stand-ins. Do not compare those timings directly with
published OpenRuleBench timing tables.

## Dataset profiles

The files shipped in the four engine directories use the **portable** profile, tuned for
cross-engine comparisons without multi-gigabyte `findall/3` bags or million-answer
closures. The larger `orb-small` profile is still available from the generator.

| profile | join rows/relation | TC nodes / edges | SG nodes / EDB facts | WordNet synsets | purpose |
|---|---:|---:|---:|---:|---|
| `smoke` | 1,000 | 500 / 1,250 | 500 / 500 | 2,000 | quick correctness |
| `portable` | 3,500 | 500 / 12,500 | 500 / 1,500 | 10,000 | default four-engine benchmark |
| `orb-small` | 10,000 | 1,000 / 50,000 | 1,000 / 6,000 | 15,000 | larger stress profile |

Generate a base profile with:

```sh
node tools/generate.mjs --profile portable --output benchmarks-portable
node tools/generate.mjs --profile orb-small --output benchmarks-orb-small
```

Validate the four generated engine trees with:

```sh
node tools/check.mjs
```

All OpenRuleBench tooling in this repository is JavaScript/ESM.

The portable profile specifically addresses the two SWI 1 GB stack failures seen in
`join1` and `joindup`, and reduces the maximum transitive-closure answer space from
1,000,000 ordered pairs to 250,000. `wine` deliberately remains unchanged because its
961-rule / 225-IDB / 113-EDB / 654-fact shape is the point of that workload.

## Run

```sh
./run-eyeprolog.mjs
./run-trealla.mjs
./run-scryer.mjs
./run-swipl.mjs
./run-all.mjs
```

The runner prints TSV columns: `engine`, `benchmark`, `seconds`, `status`, and
captured output. It uses a 300-second per-benchmark timeout by default:

```sh
./run-swipl.mjs --timeout 900
./run-all.mjs --only tc,sg,modsg
```

Override executable locations with environment variables:

```sh
EYEPROLOG=/path/to/eyeprolog ./run-eyeprolog.mjs
TREALLA=/path/to/tpl ./run-trealla.mjs
SCRYER=/path/to/scryer-prolog ./run-scryer.mjs
SWIPL=/path/to/swipl ./run-swipl.mjs
```

## Tabling portability

The positive recursive workloads `tc`, `sg`, `modsg`, `wordnet`, and `wine`
need tabling for robust least-model execution on cyclic/recursive data.

Trealla and Scryer copies use:

```prolog
:- use_module(library(tabling)).
:- table predicate/arity.
```

The SWI-Prolog copies use its built-in tabling directive directly:

```prolog
:- table predicate/arity.
```

Current SWI-Prolog documents `table/1` as built-in SLG tabling. Current Trealla
`main` also contains `library(tabling)` and the same `table` directive. Since
older Trealla releases/builds may not contain that newer facility, `run.mjs`
probes it before running recursive workloads and reports `skipped-no-tabling`
when unavailable.

`wine.pl` has a large mutually recursive SCC, so its Trealla, Scryer, and SWI
copies table `wine/1` and `w001/1` through `w224/1`.

## Negation / WFS

`win_cycle.pl` and `magicset.pl` require well-founded negation for faithful
OpenRuleBench semantics.

EyeProlog and SWI-Prolog copies use explicit `tnot/1`. SWI also declares the
relevant predicates tabled; EyeProlog recognizes the finite, range-restricted,
function-free Datalog component and evaluates the `tnot/1` cycle with its WFS
evaluator. For example:

```prolog
win(X) :- move(X,Y), tnot(win(Y)).
```

For `magicset.pl`, the recursive negative calls likewise use `tnot(ab(X))`.
Both WFS benchmarks therefore run by default under EyeProlog and SWI-Prolog.
EyeProlog retains undefined WFS atoms internally but does not expose them as
successful goal solutions. For the portable cyclic win/not-win data,
`benchmark/1` therefore counts zero unconditional `win/1` answers.

Trealla's native tabling is least-model variant tabling without `tnot`/WFS, and
this pack does not assume a compatible WFS-negation interface for Scryer. Their
normal runners therefore skip `win_cycle` and `magicset`. You can deliberately
try them as capability experiments:

```sh
./run-trealla.mjs --unsafe-wfs --only win_cycle,magicset --timeout 10
./run-scryer.mjs --unsafe-wfs --only win_cycle,magicset --timeout 10
```

Those unsafe results are **not OpenRuleBench-equivalent WFS results** unless the
engine/configuration being tested provides compatible well-founded negation.

`win_tree.pl` is different: its generated move graph is acyclic, so ordinary
negation-as-failure terminates and is included in normal runs for all engines.

## Direct examples

SWI-Prolog:

```sh
swipl -q -f none -s swipl/tc.pl -g 'benchmark(Count),write(Count),nl' -t halt
```

Trealla:

```sh
tpl -q -f -g 'benchmark(Count),write(Count),nl,halt' trealla/tc.pl
```

Scryer:

```sh
scryer-prolog -f -g 'benchmark(Count),write(Count),nl,halt' scryer/tc.pl
```

EyeProlog:

```sh
eyeprolog --goal 'benchmark(Count)' eyeprolog/tc.pl
```

For Join1 the default goal is `benchmark_ff(Count)` rather than `benchmark(Count)`;
`run.mjs` reads each file's `%% ?-` line automatically.

## Expected portable-profile counts

The following answer counts are the correctness baseline for the generated
`portable` profile. Timings are intentionally omitted because they depend on
engine version, JavaScript/Prolog runtime, CPU, memory limits, and host load.

| benchmark | expected count |
|---|---:|
| `join1` | 524157 |
| `join2` | 2476099 |
| `joindup` | 2599605 |
| `lubm` | 48 |
| `mondial` | 120 |
| `dblp` | 20000 |
| `tc` | 250000 |
| `sg` | 88734 |
| `wordnet` | 454524 |
| `wine` | 400 |
| `modsg` | 21405 |
| `win_tree` | 6665 |
| `win_cycle` | 0 unconditional WFS answers |
| `magicset` | 0 |

## Benchmark classes

See `COMPATIBILITY.tsv` for every benchmark, default goal, and whether it is
plain ISO-style Prolog, positive recursion requiring tabling, or WFS-sensitive.

## Provenance

Primary historical references used by the original adaptation:

- OpenRuleBench home: https://www3.cs.stonybrook.edu/~pfodor/openrulebench_web/
- OpenRuleBench WWW 2009 paper: *OpenRuleBench: An Analysis of the Performance of Rule Engines*
- Surviving Halle data/benchmark mirror: https://users.informatik.uni-halle.de/~brass/push/cpp.html

Engine references:

- SWI-Prolog tabling: https://www.swi-prolog.org/pldoc/man?section=tabling
- SWI-Prolog WFS: https://www.swi-prolog.org/pldoc/man?section=WFS
- Scryer tabling: https://www.scryer.pl/tabling
- Trealla native tabling documentation is in the Trealla repository under `docs/README-native-tabling.md`.

The benchmark source files are deterministic outputs of the retained generator
in `tools/generate.mjs`; the engine-specific adaptations are intentionally small
wrappers/directives over those generated clauses and facts.

## EyeProlog requirements

The `eyeprolog/win_cycle.pl` and `eyeprolog/magicset.pl` variants require an
EyeProlog build that provides finite-Datalog WFS through explicit `tnot/1`.
Ordinary `\+/1` remains negation-as-failure. Positive recursive EyeProlog benchmark variants use explicit `table/1`
declarations, matching EyeProlog's ordinary-depth-first-by-default execution
policy and making the benchmark's memoization choice visible in source.
