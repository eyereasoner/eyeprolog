# Quine–McCluskey logic minimization

## What is the smallest sum-of-products formula for this Boolean function?

Digital circuits are cheaper when their Boolean formulas are shorter. The
Quine–McCluskey method finds a minimal formula systematically: combine
minterms into prime implicants, keep the essential ones, and search for the
smallest cover of what remains. This example runs the whole method and then
checks its own result five ways.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=quine-mccluskey) ·
[Source](../quine-mccluskey.pl)

---

# The question

The function `f(A, B, C, D)` must be 1 for inputs 1, 3, 7, 11, and 15, may be
anything for 0, 2, and 5 (**don't cares**), and must be 0 everywhere else.

A **minterm** is one input row where `f` is 1. An **implicant** is a product
term such as `CD` that covers several minterms at once; a **prime implicant**
cannot be enlarged further. The goal is the fewest prime implicants that
cover every minterm.

---

# The problem as facts

```prolog
minterm(1). minterm(3). minterm(7). minterm(11). minterm(15).
dont_care(0). dont_care(2). dont_care(5).
width(4).
vars(['A', 'B', 'C', 'D']).
```

Terms are bit patterns such as `"0xx1"`, where `x` means the variable is
absent from the product.

---

# The method

```prolog
solve_minimal_cover(Primes, MinimalCover) :-
    findall(M, minterm(M), Minterms),
    % 1. Essentials
    findall(M-Ps, (member(M, Minterms), findall(P, (member(P, Primes), covers_int(P, M)), Ps)), Chart),
    findall(P, member(_-[P], Chart), EssRaw),
    sort(EssRaw, Essentials),
    % 2. Remaining
    remaining_minterms(Minterms, Essentials, RemMts),
    subtract_list(Primes, Essentials, NonEss),
    (RemMts = [] -> BestRest = [] ; find_smallest_subset(NonEss, RemMts, BestRest)),
    append(Essentials, BestRest, Total),
    sort(Total, MinimalCover).
```

The **prime implicant chart** lists, for each minterm, the primes covering
it. A minterm covered by only one prime makes that prime **essential**. Any
minterms left over are covered by the smallest subset of the other primes.

The minimality check is stated as the absence of a counterexample:

```prolog
smaller_cover(Primes, Minterms, Limit, Combo) :-
    between_range(1, Limit, N),
    find_combination(N, Primes, Combo),
    covers_all(Combo, Minterms).

minimality_status(Primes, Minterms, Limit, true) :-
    \+ smaller_cover(Primes, Minterms, Limit, _).
```

---

# The answer

```sh
eyeprolog examples/quine-mccluskey.pl
```

```text
answer('PROBLEM INSTANCE\nMinterms: {1, 3, 7, 11, 15}\nDon''t Cares: {0, 2, 5}\n\nPRIME IMPLICANTS (Ordered):\n00xx, 0xx1, xx11\nMINIMAL COVER (Lexicographically First):\n00xx, xx11\nEQUATION:\n f = ~A~B + CD').
check(1, 'Functional Correctness (All minterms covered)', true).
check(2, 'Safety Check (No false positives outside DCs)', true).
check(3, 'Minimality (Cardinality) Proof', true).
check(4, 'Canonical Tie-Breaking (Lexicographical First)', true).
check(5, 'Consistency (Solution is subset of Primes)', true).
```

Seven answers in all (the `reason/1` text is the seventh). There are three
prime implicants, and two of them suffice: **f = ¬A¬B + CD**.

---

# The reason

```sh
eyeprolog --proof examples/quine-mccluskey.pl
```

```text
step(check(3, 'Minimality (Cardinality) Proof', true),
     rule(16),
     ['Status' = true,
      'Primes' = ["00xx", "0xx1", "xx11"],
      'Cover' = ["00xx", "xx11"],
      'Size' = 2,
      'Limit' = 1,
      'Minterms' = [1, 3, 7, 11, 15]],
     [get_results(["00xx", "0xx1", "xx11"], ["00xx", "xx11"]),
      length_list(["00xx", "xx11"], 2),
      1 is 2 - 1,
      findall(M, minterm(M), [1, 3, 7, 11, 15]),
      minimality_status(["00xx", "0xx1", "xx11"], [1, 3, 7, 11, 15], 1, true)]).
step(minimality_status(["00xx", "0xx1", "xx11"], [1, 3, 7, 11, 15], 1, true),
     rule(24),
     ['Primes' = ["00xx", "0xx1", "xx11"], 'Minterms' = [1, 3, 7, 11, 15], 'Limit' = 1],
     [\+ smaller_cover(["00xx", "0xx1", "xx11"], [1, 3, 7, 11, 15], 1, __anon7)]).
step(\+ smaller_cover(["00xx", "0xx1", "xx11"], [1, 3, 7, 11, 15], 1, __anon7), absent, [], []).
```

The cover has two primes, so minimality means that no cover of at most one
prime exists. That is exactly what the proof records: `minimality_status/4`
is `true` because `smaller_cover/4` has no answer with limit 1. A smaller
cover would be a counterexample, and the proof names the search for one.

---

# The check

```text
condition('C1', resolution, ok, 145).
condition('C5', re_decision, ok, 76).
condition('C6', boundary_consistency, ok, 1).
obligation(asserted, theory_scoped, solution_cache(["00xx", "0xx1", "xx11"], ["00xx", "xx11"])).
obligation(absent, theory_scoped, \+ covers_int("00xx", 4)).
obligation(absent, theory_scoped, \+ smaller_cover(["00xx", "0xx1", "xx11"], [1, 3, 7, 11, 15], 1, A)).
steps(243).
verified(145).
recomputed(76).
trusted(22).
verdict(checked_with_obligations).
```

145 clause steps are replayed and 76 built-in steps recomputed. Twenty-two
boundaries remain as obligations: the cached result the program `assertz`es,
the `findall/3` collections, the safety facts that a pattern does **not**
cover a zero row (such as `0100`, input 4), and the minimality claim itself,
that no one-prime cover exists. The checker lists every one.

---

# Try it

- Make input 13 a minterm instead of a zero. Which prime implicants change,
  and does the cover grow?
- Remove all don't cares. Is `~A~B` still a prime implicant?
- Ask `smaller_cover(["00xx", "0xx1", "xx11"], [1, 3, 7, 11, 15], 2, C)`
  directly. Which two-prime covers exist, and why does the tie-breaking check
  pick `["00xx", "xx11"]`?

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 24 (finite search) and 34 (control).
