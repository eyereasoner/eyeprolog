# The subgroups of D3

## Which sets of triangle symmetries form a group of their own?

An equilateral triangle has six symmetries: three rotations (including doing
nothing) and three reflections. Together they form the group D3. EyeProlog
generates every subset of the six, keeps the ones closed under composition and
inverse, and finds exactly six subgroups.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=d3-group) ·
[Source](../d3-group.pl)

---

# The question

A *subgroup* is a subset that is a group in its own right. It contains the
identity, it is closed under composition (combining two members gives a
member), and it contains the inverse of each member.

D3 has 2⁶ = 64 subsets. Which of them pass all three tests?

---

# The group as data

```prolog
symmetry(identity).
symmetry(rotation_120).
symmetry(reflection_a).

compose_op(rotation_120, rotation_120, rotation_240).
compose_op(rotation_120, rotation_240, identity).
compose_op(reflection_a, reflection_b, rotation_240).

inverse(rotation_120, rotation_240).
inverse(reflection_a, reflection_a).
```

`compose_op/3` is the Cayley table: all 36 products of two symmetries, written
out as facts. `inverse/2` pairs each symmetry with the one that undoes it. (A
few rows of each are shown.)

---

# The rules

```prolog
closed_under_composition(Group) :-
  \+ (member(X, Group), member(Y, Group), compose_op(X, Y, Z), \+ member(Z, Group)).

valid_group(Group) :-
  all_symmetries(All),
  subsequence(All, Group),
  member(identity, Group),
  closed_under_composition(Group),
  closed_under_inverse(Group).

all_subgroups(Groups) :-
  findall(G, valid_group(G), Raw),
  sort(Raw, Groups).
```

"Closed" is written as the absence of a counterexample: there is no pair in
the group whose product falls outside it. `subsequence/2` generates the 64
candidates, the tests filter them, and `findall/3` with `sort/2` collects the
survivors in a canonical order.

---

# The answer

```sh
eyeprolog examples/d3-group.pl
```

```text
subgroups(d3_group, [[identity], [identity, reflection_a], [identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240]]).
subgroupCount(d3_group, 6).
```

The six subgroups are the trivial group, the whole of D3, the rotations, and
three two-element groups, each made of the identity and one reflection. The
sizes (1, 2, 3, 6) all divide 6, as Lagrange's theorem says they must.

---

# The reason

```text
step(findall(G, valid_group(G), [[identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_a], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240], [identity]]),
     collected,
     [],
     []).
```

The count rests on one collection: `findall/3` gathered every `valid_group/1`
answer. The proof records that collection as a completed search (`collected`)
rather than repeating all 64 candidate checks.

---

# The check

```text
condition('C1', resolution, ok, 3).
condition('C5', re_decision, ok, 2).
obligation(collected, theory_scoped, findall(A, valid_group(A), [[identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_a], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240], [identity]])).
steps(6).
trusted(1).
verdict(checked_with_obligations).
```

The checker verifies the three rule steps and recomputes `sort/2` and
`length/2`. The `findall/3` result stays an *obligation*: claiming that these
are *all* the subgroups needs the whole search, which the checker does not
redo. The verdict is honest about that: the proof holds, provided the
collection is complete.

---

# Try it

- Delete the `closed_under_inverse(Group)` test. The count stays at 6. Why does
  closure under composition already force inverses in a finite group?
- Delete `member(identity, Group)` instead. The count becomes 7. Which extra
  "subgroup" slips through?
- Write the Cayley table of the cyclic group of order 4 and count its
  subgroups.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 28 (algebra, symmetry, and representation).
