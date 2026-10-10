# An expression language

## Parse arithmetic, evaluate it, and print it back with the right parentheses

A grammar turns token lists such as `2 + 3 * (4 - 1)` into syntax trees that
respect precedence and left associativity. An evaluator computes their values,
and a second grammar prints a tree back out with only the parentheses it
needs. Parsing what was printed gives back the same tree.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=dcg-expression-language) ·
[Source](../dcg-expression-language.pl)

---

# The question

`*` binds tighter than `+`, and `20 - 5 - 3` means `(20 - 5) - 3`, not
`20 - (5 - 3)`. A parser must get both right. A printer must then put back
exactly the parentheses that make a tree mean what it means: no fewer, and
ideally no more.

---

# Precedence without left recursion

```prolog
expression(AST) -->
  term(First),
  additive_tail(First, AST).

additive_tail(Left, AST) -->
  ['+'],
  term(Right),
  { Next = add(Left, Right) },
  additive_tail(Next, AST).
additive_tail(AST, AST) --> [].
```

An expression is a term followed by a tail of `+ term` or `- term` pieces.
The tail carries the tree built so far (`Left`) and wraps it with each new
operator, so `20 - 5 - 3` nests to the left. Terms handle `*` and `/` the same
way one level down, which gives them higher precedence.

---

# Printing with minimal parentheses

```prolog
emit_node(sub(Left, Right)) -->
  emit(Left, 10), ['-'], emit(Right, 11).

parenthesize(Precedence, Minimum, yes) :- Precedence < Minimum.
parenthesize(Precedence, Minimum, no) :- Precedence >= Minimum.
```

Each operator has a precedence (10 for `+` and `-`, 20 for `*` and `/`). A
subtree gets parentheses only when its precedence is below the minimum its
position demands. The right operand of `-` demands 11, one more than the left,
which is exactly what left associativity requires.

---

# The answer

```sh
eyeprolog examples/dcg-expression-language.pl
```

```text
dcg_expression_example(parsed, add(lit(2), mul(lit(3), sub(lit(4), lit(1))))).
dcg_expression_example(evaluated, 19).
dcg_expression_example(round_trip, [20, -, '(', 5, -, 3, ')']).
dcg_expression_example(remainder, [then, stop]).
dcg_expression_example(rejected, malformed_parentheses).
```

The parse puts the multiplication inside the addition. `x * (y + 2) - z` with
`x = 4, y = 3, z = 1` evaluates to 19. The right-nested subtraction prints as
`20 - (5 - 3)`, keeping the one pair of parentheses it cannot do without, and
parses back to the same tree. An unclosed parenthesis is rejected.

---

# The reason

```text
step(dcg_expression_example(evaluated, 19),
     rule(47),
     ['Value' = 19, 'AST' = sub(mul(var(x), add(var(y), lit(2))), var(z))],
     [phrase(expression(sub(mul(var(x), add(var(y), lit(2))), var(z))), [x, *, '(', y, +, 2|")-z"]),
      evaluate(sub(mul(var(x), add(var(y), lit(2))), var(z)), [x - 4, y - 3, z - 1], 19)]).
```

The value 19 rests on two things: the parse that produced the tree, and the
evaluation of that tree in the environment `[x - 4, y - 3, z - 1]`. The token
list is printed in a compact form: `2|")-z"` means the remaining tokens are
the characters `)`, `-`, and `z`.

---

# The check

```text
condition('C1', resolution, ok, 18).
condition('C5', re_decision, ok, 4).
obligation(builtin, theory_scoped, phrase(expression(mul(var(x), lit(2))), [x, *, 2, then, stop], [then, stop])).
obligation(absent, theory_scoped, \+ phrase(expression(A), [2, *, '(', 3, +, 4])).
steps(28).
trusted(6).
verdict(checked_with_obligations).
```

The 18 rule and fact steps are verified and 4 arithmetic steps recomputed. The six
grammar calls (five parses and one failed parse) are listed as obligations: a
`phrase/2` call runs this program's own grammar, which the checker does not
re-run. The verdict says the proof holds provided those parses hold.

---

# Try it

- Evaluate `2 + 3 * (4 - 1)` with an empty environment. (The answer is 11.)
- Print `add(lit(1), add(lit(2), lit(3)))`. Why does it keep its parentheses,
  `1 + (2 + 3)`, even though addition is associative?
- Add `^` for exponentiation, binding tighter than `*` and associating to the
  right.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 22 (trees, languages, and symbolic evaluation) and Chapter 38 (grammar
rules).
