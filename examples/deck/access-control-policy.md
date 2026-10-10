# Access control policy

## Does this request satisfy the policy?

A policy demands some claims, accepts any one of a few others, and forbids a
third kind. This example checks a request against all three conditions with
plain rules, and its proof shows exactly where it had to rely on the absence of
a claim.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=access-control-policy) ·
[Source](../access-control-policy.pl)

---

# The question

Request `test1` presents claims `claim_a`, `claim_b`, and `claim_c`. Policy
`policy_x` says:

- **all of** `claim_a` and `claim_b` must be present;
- **any of** `claim_c` must be present;
- **none of** `claim_d` may be present.

Does the request pass?

---

# The facts

```prolog
policy_request(test1, policy_x).
has(test1, claim_a).
has(test1, claim_b).
has(test1, claim_c).

policy(policy_x).
allOf(policy_x, claim_a).
allOf(policy_x, claim_b).
anyOf(policy_x, claim_c).
noneOf(policy_x, claim_d).
```

The request and the policy are both ordinary facts, so a new policy is new
data, not new code.

---

# The rules

```prolog
passes_all_of(Request, Policy) :-
  policy_request(Request, Policy),
  policy(Policy),
  \+ (allOf(Policy, Claim), \+ has(Request, Claim)).

passes_any_of(Request, Policy) :-
  policy_request(Request, Policy),
  policy(Policy),
  anyOf(Policy, Claim),
  has(Request, Claim).

passes_none_of(Request, Policy) :-
  policy_request(Request, Policy),
  policy(Policy),
  \+ (noneOf(Policy, Claim), has(Request, Claim)).
```

"All of" is written as *there is no required claim that is missing*: a double
negation over a finite list. "Any of" is a plain join. "None of" says *there is
no forbidden claim that is present*. No collection with `findall/3` is needed.

---

# The answer

```sh
eyeprolog examples/access-control-policy.pl
```

```text
status(test1, policy_passed).
reason(test1, "all required claims are present, one allowed claim is present, and no forbidden claim is present").
```

The request passes, and the reason restates the three conditions in domain
language.

---

# The reason

```sh
eyeprolog --proof examples/access-control-policy.pl
```

```text
step(status(test1, policy_passed), rule(15), [], [passes_policy(test1, policy_x)]).
step(anyOf(policy_x, claim_c), fact(8), [], []).
step(\+ (noneOf(policy_x, Claim), has(test1, Claim)), absent, [], []).
```

The status rests on `passes_policy/2`. The "any of" part is proved positively,
from the facts that `claim_c` is allowed and present. The two negated
conditions are justified as `absent`: the search for a counterexample finished
and found none.

---

# The check

```text
condition('C1', resolution, ok, 10).
condition('C4', coverage, ok, 17).
condition('C6', boundary_consistency, ok, 0).
obligation(absent, theory_scoped, \+ (allOf(policy_x, A), \+ has(test1, A))).
obligation(absent, theory_scoped, \+ (noneOf(policy_x, A), has(test1, A))).
trusted(2).
verdict(checked_with_obligations).
```

The 10 positive steps are verified. The two absences cannot be re-proved from a
proof document, so the checker lists them as **obligations**: the verdict holds
provided the facts about `allOf`, `noneOf`, and `has` are complete. That is the
closed-world assumption, made explicit.

---

# Try it

- Add `has(test1, claim_d).` and predict which condition fails.
- Remove `has(test1, claim_b).` Which rule now fails, and does the output still
  contain a `reason/2`?
- Add a second request `test2` and generalize `status/2` and `reason/2` so they
  no longer name `test1`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 7.
