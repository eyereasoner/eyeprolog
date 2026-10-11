# Dependency preparation: 5,000 predicates

## How quickly can the engine prepare thousands of distinct predicates?

Generated programs can contain thousands of predicate names. Before answering
any query, EyeProlog prepares their dependency graph and execution plans.
This example gives that work a reproducible input: 5,000 predicates connected
by 4,999 dependency edges.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=dependency-preparation-5000) ·
[Source](../dependency-preparation-5000.pl) ·
[Answer](../output/dependency-preparation-5000.pl) ·
[Proof](../proof/dependency-preparation-5000.pl) ·
[Check](../check/dependency-preparation-5000.pl)

---

# The question

How much preparation does a long chain of distinct predicates require?
The declared query asks only `chain4998(ready)`. Loading the source prepares
the entire graph; answering this query needs only its final edge.

---

# The rules

```prolog
chain0(X) :- chain1(X).
chain1(X) :- chain2(X).
% ... one clause per predicate ...
chain4998(X) :- chain4999(X).
chain4999(ready).
```

Each name introduces a separate graph vertex. The engine identifies the
components once and propagates planning properties over the graph. None of
these predicates is recursive, and none reaches a cut.

---

# The answer

Run from the repository root:

```sh
node bin/eyeprolog.js examples/dependency-preparation-5000.pl
```

```text
chain4998(ready).
```

---

# The reason

```text
step(chain4998(ready), rule(4999), ['X' = ready], [chain4999(ready)]).
step(chain4999(ready), fact(5000), [], []).
```

The proof has two steps. Keeping the query short lets this example exercise
preparation without adding a 5,000-step proof to every test run.

---

# The check

```sh
node bin/eyeprolog.js --check-proof examples/proof/dependency-preparation-5000.pl examples/dependency-preparation-5000.pl
```

The packaged report records `steps(2)`, `verified(2)`, `trusted(0)`, and
`verdict(checked)`. It checks the answer's two inferences. The white-box
regression separately checks all 5,000 predicate plans and all 4,999 graph
edges, including negation stratification.

---

# Time preparation

Run this from the repository root. Source reading and module startup happen
outside the timed region. Three warm-ups precede nine measured parses;
the printed value is their median. Use the same Node version and machine
when comparing releases. Timing is an observation, not a test threshold.

```sh
node --input-type=module <<'JS'
import fs from 'node:fs';
import { Program } from './src/index.js';
const source = fs.readFileSync('examples/dependency-preparation-5000.pl', 'utf8');
for (let i = 0; i < 3; i++) Program.parse(source);
const samples = [];
for (let i = 0; i < 9; i++) {
  const start = performance.now();
  const program = Program.parse(source);
  samples.push(performance.now() - start);
  if (program.groups.size !== 5000) throw new Error('wrong predicate count');
}
samples.sort((a, b) => a - b);
console.log(`Median preparation: ${samples[4].toFixed(1)} ms`);
JS
```

Continue with [the 10,000-predicate depth example](dependency-depth-10000.md).
