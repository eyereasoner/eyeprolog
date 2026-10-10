# Combinations with findall and sort

## What are all the ways to choose 3 items out of 5?

A simple generator produces each 3-item subset many times, in every order it
can be picked. `findall/3` collects everything it finds, and `sort/2` turns the
collection into the 10 distinct combinations.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=combinatorics-findall-sort) ·
[Source](../combinatorics-findall-sort.pl)

---

# The question

From the items 1 to 5, how many different groups of three are there, and
which are they? Order inside a group does not matter: {1, 2, 3} and {3, 1, 2}
are the same group. Mathematics writes the count as "5 choose 3".

---

# Generating combinations

```prolog
select_item(Item, [Item | Rest], Rest).
select_item(Item, [Head | Tail], [Head | Rest]) :-
  select_item(Item, Tail, Rest).

combination(0, _items, []).
combination(I, Items, Combination) :-
  (I > 0),
  select_item(Item, Items, Remaining),
  (J is I - 1),
  combination(J, Remaining, Partial),
  sort([Item | Partial], Combination).
```

`select_item/3` removes any one item from a list. A combination of size `I`
picks one item, then a combination of size `I - 1` from the rest. Sorting each
result puts it in a standard order, but the same group is still found once for
every order in which its items could be picked.

---

# Collecting and canonicalizing

```prolog
unique_combinations(K, Items, Unique) :-
  findall(C, combination(K, Items, C), All),
  sort(All, Unique).
```

`findall/3` gathers every generated combination into one list, duplicates
included. ISO `sort/2` orders that list and removes duplicates, leaving one
entry per group.

---

# The answer

```sh
eyeprolog examples/combinatorics-findall-sort.pl
```

```text
combinations(combinations_5_choose_3, [[1, 2, 3], [1, 2, 4], [1, 2, 5], [1, 3, 4], [1, 3, 5], [1, 4, 5], [2, 3, 4], [2, 3, 5], [2, 4, 5], [3, 4, 5]]).
count(combinations_5_choose_3, 10).
```

Ten combinations, as the formula 5! / (3! × 2!) predicts. The `reason/2`
query has no line of its own because its answer is a fact in the source, and
the output leaves out answers that only repeat source facts.

---

# The reason

```text
step(unique_combinations(3, [1, 2, 3, 4, 5], [[1, 2, 3], [1, 2, 4], …, [3, 4, 5]]),
     rule(5),
     ['K' = 3,
      'Items' = [1, 2, 3, 4, 5],
      …],
     [findall(C, combination(3, [1, 2, 3, 4, 5], C), [[1, 2, 3], [1, 2, 4], …]),
      sort([[1, 2, 3], [1, 2, 4], …], [[1, 2, 3], [1, 2, 4], …])]).
```

The ten groups follow from the `unique_combinations/3` rule. The proof records
the full collected list, duplicates and all, and the sorted result.

---

# The check

```text
condition('C1', resolution, ok, 3).
obligation(collected, theory_scoped, findall(A, combination(3, [1, 2, 3, 4, 5], A), [[1, 2, 3], [1, 2, 4], …])).
trusted(1).
verdict(checked_with_obligations).
```

Rule steps and the `sort/2` and `length/2` steps are verified. The `findall/3`
step is different: it claims that *these* were all the solutions, and
"all" cannot be shown by listing some of them. The checker records it as an
**obligation**, a claim of completeness that rests on the run's search.

---

# Try it

- Count the raw candidates before sorting: `findall/3` collects 60 lists for
  10 groups. Why 60?
- Ask `--goal 'unique_combinations(2, [1, 2, 3, 4], U)'`: six pairs.
- Rewrite `combination/3` so it only picks items in increasing order. Then
  every group is generated once and `sort/2` becomes unnecessary.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 8.
