# Matrix-chain order

## In what order should six matrices be multiplied to do the least work?

Matrix multiplication is associative, so every bracketing gives the same
product, but the cost can differ enormously. This example finds the cheapest
bracketing with dynamic programming, written as a tabled relation over
intervals of the chain.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=matrix-chain-order) ·
[Source](../matrix-chain-order.pl)

---

# The question

Multiplying a p×q matrix by a q×r matrix takes p·q·r scalar multiplications.
For the chain A1 (30×35), A2 (35×15), A3 (15×5), A4 (5×10), A5 (10×20),
A6 (20×25), which bracketing minimizes the total?

---

# The facts

```prolog
dim(0, 30).
dim(1, 35).
dim(2, 15).
dim(3, 5).
dim(4, 10).
dim(5, 20).
dim(6, 25).

matrix_count(6).
```

Matrix *i* has dimensions `dim(i-1)` × `dim(i)`, so seven numbers describe six
matrices.

---

# The rules

```prolog
:- table cost/3.

cost(I, I, 0) :- matrix_count(N), between(1, N, I).
cost(I, J, Cost) :-
  (I < J),
  aggregate_min(Splitcost, K,
    (between(I, J, K),
     (K < J),
     cost(I, K, Left),
     (K1 is K + 1),
     cost(K1, J, Right),
     (I0 is I - 1),
     dim(I0, Rows),
     dim(K, Shared),
     dim(J, Cols),
     (First is Rows * Shared),
     (Multcost is First * Cols),
     (Partial is Left + Right),
     (Splitcost is Partial + Multcost)),
    Cost, _bestk).
```

The cheapest way to multiply matrices I..J is the best split K: multiply I..K,
multiply K+1..J, then combine the two results. `:- table cost/3.` stores each
interval's answer, turning an exponential recursion into 21 shared
subproblems.

---

# The answer

```sh
eyeprolog examples/matrix-chain-order.pl
```

```text
matrix_chain_answer(min_cost, 15125).
matrix_chain_answer(best_split_1_6, 3).
matrix_chain_answer(best_order, product(product(matrix(1), product(matrix(2), matrix(3))), product(product(matrix(4), matrix(5)), matrix(6)))).
matrix_chain_answer(subproblem_count, 21).
```

The best order is (A1(A2A3))((A4A5)A6), costing 15,125 multiplications, with
the top-level split after A3.

---

# The reason

```text
step(matrix_chain_answer(min_cost, 15125), rule(15), ['Cost' = 15125], [cost(1, 6, 15125)]).
step(cost(1, 6, 15125),
     rule(11),
     ['I' = 1, 'J' = 6, 'Cost' = 15125],
     [1 < 6,
      aggregate_min(Key, Value, (between(1, 6, Value), Value < 6, cost(1, Value, Left), K1 is Value + 1, cost(K1, 6, Right), I0 is 1 - 1, dim(I0, Rows), dim(Value, Shared), dim(6, Cols), First is Rows * Shared, Multcost is First * Cols, Partial is Left + Right, Key is Partial + Multcost), 15125, 3)]).
```

The minimum cost of the whole chain comes from the recursive rule: the
`aggregate_min/5` over all split points found 15,125 at split 3.

---

# The check

```text
condition('C1', resolution, ok, 21).
condition('C5', re_decision, ok, 10).
steps(38).
verified(21).
recomputed(10).
trusted(7).
verdict(checked_with_obligations).
```

21 rule steps replay and 10 arithmetic steps are recomputed. The 7 trusted
steps are aggregates: six `aggregate_min/5` choices of a best split and one
`countall/2`. They are listed as obligations because the checker does not
re-run a whole optimization; it records exactly which minimum each conclusion
relies on.

---

# Try it

- Change `dim(3, 5)` to `dim(3, 50)` and predict whether the best split moves.
- Remove `:- table cost/3.` and compare the run time. What does `--stats`
  show?
- Write `naive_cost/2` for the left-to-right order ((((A1A2)A3)A4)A5)A6 and
  compare it with 15,125.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 13.
