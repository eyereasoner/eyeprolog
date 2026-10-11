# Dependency depth: 10,000 predicates

## Can dependency analysis follow a deep chain without exhausting the JavaScript stack?

A dependency graph can be deep even when its clauses are simple. This
example has 10,000 distinct predicates and 9,999 edges in one chain.
Dependency analysis uses an explicit traversal stack, so the graph's depth
does not consume one JavaScript call frame per predicate.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=dependency-depth-10000) ·
[Source](../dependency-depth-10000.pl) ·
[Answer](../output/dependency-depth-10000.pl) ·
[Proof](../proof/dependency-depth-10000.pl) ·
[Check](../check/dependency-depth-10000.pl)

---

# The question

Can the engine prepare and analyze the whole chain, including propagation
of a cut from its final predicate back to every caller?
The declared query asks `chain9998(ready)` to keep the resulting proof small.

---

# The rules

```prolog
chain0(X) :- chain1(X).
chain1(X) :- chain2(X).
% ... one clause per predicate ...
chain9998(X) :- chain9999(X).
chain9999(ready) :- !.
```

There are no cycles. Each predicate can reach the terminal cut, including
`chain0/1`, which is 9,999 edges away. The graph is also stratified: there is
no negative cycle.

---

# The answer

Run from the repository root:

```sh
node bin/eyeprolog.js examples/dependency-depth-10000.pl
```

```text
chain9998(ready).
```

---

# The reason

```text
step(chain9998(ready), rule(9999), ['X' = ready], [chain9999(ready)]).
step(chain9999(ready), rule(10000), [], "!").
step(!, builtin, [], []).
```

Two rule applications and the cut establish the answer. This short proof
keeps the example inexpensive to prove and check during `npm test`.

---

# The check

```sh
node bin/eyeprolog.js --check-proof examples/proof/dependency-depth-10000.pl examples/dependency-depth-10000.pl
```

The packaged report records `steps(3)`, `verified(2)`, `recomputed(1)`,
`trusted(0)`, and `verdict(checked)`. It checks the query's derivation.
The white-box regression checks the complete dependency graph separately.

---

# Analyze the full graph

Run this from the repository root with the ordinary Node stack setting:

```sh
node --input-type=module <<'JS'
import assert from 'node:assert/strict';
import fs from 'node:fs';
import { Program } from './src/index.js';
const source = fs.readFileSync('examples/dependency-depth-10000.pl', 'utf8');
const program = Program.parse(source);
assert.equal(program.groups.size, 10000);
assert.equal(program.isStratifiedNegation(), true);
assert.equal(program.negationDependencies.length, 9999);
for (let i = 0; i < 10000; i++) {
  const group = program.findGroup(`chain${i}`, 1);
  assert.equal(group.recursive, false);
  assert.equal(group.cutReachable, true);
}
console.log('10,000 predicates analyzed; terminal cut reaches every caller.');
JS
```

This exercises preparation and negation analysis across the full depth.
The result establishes graph-analysis depth, rather than a bound on the
depth of arbitrary Prolog execution. For preparation timing, see
[the 5,000-predicate example](dependency-preparation-5000.md).
