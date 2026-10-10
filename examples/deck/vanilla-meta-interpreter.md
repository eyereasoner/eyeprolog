# A vanilla meta-interpreter

## Can Prolog describe how Prolog runs?

A meta-interpreter is a Prolog program that executes other Prolog programs.
The "vanilla" version takes three clauses and mirrors ordinary resolution
exactly. It is the classic starting point for tracers, proof recorders, and
alternative search strategies.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=vanilla-meta-interpreter) ·
[Source](../vanilla-meta-interpreter.pl)

---

# The question

Who are Tom's grandchildren and great-grandchildren, when the question is
answered not by Prolog directly but by a Prolog program interpreting the family
rules?

If the meta-interpreter gives the same answers as Prolog, then "how Prolog
executes a goal" is itself an ordinary relation, not a hidden mechanism.

---

# The interpreter

```prolog
solve(true) :- !.
solve((A, B)) :- !, solve(A), solve(B).
solve(Goal) :-
    clause(Goal, Body),
    solve(Body).
```

`true` is solved immediately. A conjunction is solved left to right. Any other
goal is solved by fetching a matching clause with `clause/2` and solving its
body. That is resolution, written down.

---

# The object program

```prolog
:- dynamic(parent/2).
:- dynamic(grandparent/2).
:- dynamic(great_grandparent/2).

parent(tom, bob).
parent(bob, ann).
parent(bob, pat).
parent(pat, jim).

grandparent(X, Z) :- parent(X, Y), parent(Y, Z).
great_grandparent(X, Z) :- parent(X, Y), grandparent(Y, Z).
```

ISO Prolog lets `clause/2` read only dynamic procedures, hence the
declarations.

---

# The answer

```sh
eyeprolog examples/vanilla-meta-interpreter.pl
```

```text
answer([ann, pat], [jim]).
```

Through the interpreter, Tom's grandchildren are Ann and Pat and his
great-grandchild is Jim, exactly what Prolog itself would answer.

---

# The reason

```text
step(answer([ann, pat], [jim]),
     rule(13),
     ['Grandchildren' = [ann, pat], 'GreatGrandchildren' = [jim]],
     [findall(X, solve(grandparent(tom, X)), [ann, pat]),
      findall(X, solve(great_grandparent(tom, X)), [jim])]).
step(findall(X, solve(grandparent(tom, X)), [ann, pat]), collected, [], []).
```

The answer rests on two collections. Each `findall/3` gathered every solution
of a `solve/1` call. The proof records each collection as a whole rather than
the interpreter's internal steps.

---

# The check

```text
condition('C1', resolution, ok, 1).
obligation(collected, theory_scoped, findall(A, solve(grandparent(tom, A)), [ann, pat])).
obligation(collected, theory_scoped, findall(A, solve(great_grandparent(tom, A)), [jim])).
trusted(2).
verdict(checked_with_obligations).
```

The top-level rule step is replayed. The two collections are **obligations**:
the checker does not re-run the search, so the verdict holds provided those
lists contain every solution.

---

# Try it

- Add a fourth clause to `solve/1` that counts the steps, as
  `solve(Goal, Depth)`, and report the depth of each answer.
- Extend `solve/1` to return a proof tree, as in `solve(Goal, Proof)`.
- Remove one `:- dynamic` declaration and predict the error.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 23.
