# Expression evaluator

## What is (2 × 3) + (10 − 4), and how was it computed?

The expression is stored as a tree of facts. A four-clause evaluator folds the
tree into a number, and the proof mirrors the tree: every node's value rests on
the values of its children.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=expression-eval) ·
[Source](../expression-eval.pl)

---

# The question

Evaluating an arithmetic expression is a recursion over its syntax tree: a leaf
is its own value, and an operator node combines its children's values. Writing
the evaluator as rules makes that recursion explicit, so the explanation of the
result follows the shape of the expression.

---

# The tree

```prolog
number(n2, 2).
number(n3, 3).
number(n10, 10).
number(n4, 4).

expr(eMul, mul, n2, n3).
expr(eSub, sub, n10, n4).
expr(eAdd, add, eMul, eSub).
root(eAdd).
```

Leaves carry numbers; each `expr/4` fact names an operator and its two
children. The root is the addition.

---

# The evaluator

```prolog
value(Node, Value) :-
  number(Node, Value).

value(Node, Value) :-
  expr(Node, add, Left, Right),
  value(Left, Leftvalue),
  value(Right, Rightvalue),
  (Value is Leftvalue + Rightvalue).

value(Node, Value) :-
  expr(Node, mul, Left, Right),
  value(Left, Leftvalue),
  value(Right, Rightvalue),
  (Value is Leftvalue * Rightvalue).
```

One clause per kind of node (the `sub` clause is the same shape). Each
recursive call is on a child, so evaluation always ends at the leaves.

---

# The answer

```sh
eyeprolog examples/expression-eval.pl
```

```text
result(root, 12).
```

---

# The reason

```text
step(value(eMul, 6),
     rule(12),
     ['Node' = eMul, 'Value' = 6, 'Left' = n2, 'Right' = n3, 'Leftvalue' = 2, 'Rightvalue' = 3],
     [expr(eMul, mul, n2, n3), value(n2, 2), value(n3, 3), 6 is 2 * 3]).
step(value(n2, 2), rule(9), ['Node' = n2, 'Value' = 2], [number(n2, 2)]).
step(6 is 2 * 3, builtin, [], []).
```

The multiplication node is worth 6 because its children are worth 2 and 3, and
`6 is 2 * 3`. The proof contains one such step for every node of the tree.

---

# The check

```text
condition('C1', resolution, ok, 16).
condition('C5', re_decision, ok, 3).
condition('C7', relevance, ok, 20).
verdict(checked).
```

The checker replays 16 rule steps and recomputes the three arithmetic steps
(one per operator node). Nothing is trusted.

---

# Try it

- Change the root to a new node `expr(eTop, mul, eAdd, n4)` and predict the
  result.
- Add a `div` operator. What should happen when the right child is worth 0?
- How many `value/2` steps does the proof contain for this tree, and how does
  that number relate to the number of nodes?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 22.
