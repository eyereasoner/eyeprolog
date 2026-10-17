# Delfour: a privacy-preserving shopping insight

## Can a store scanner give diabetes-aware advice without ever learning about the diabetes?

A shopper's phone knows that someone in the household has diabetes. The store's
self-scanner should flag high-sugar products and suggest a lower-sugar one, but
should not learn the medical fact. The phone turns the condition into a neutral,
expiring, signed "insight" with a usage policy, and the scanner reasons only
from that.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=delfour) ·
[Source](../delfour.pl)

---

# The question

This is the **insight economy** idea: share a conclusion instead of the data
behind it. For the Delfour retailer the case asks:

- Is the scanner allowed to use the insight, for this purpose, at this time?
- Is the scanned product high in sugar, and what is a better alternative?
- Was the sensitive condition really stripped out of what was shared?
- Do the signature, hash, scope, expiry and "no marketing" policy all hold?

---

# Scoped data, not global facts

```prolog
insight_graph(delfourInsightGraph, (
  metric(insight, "sugar_g_per_serving"),
  thresholdTenths(insight, 100),
  ...
  scopeDevice(insight, "self-scanner"),
  scopeEvent(insight, "pick_up_scanner"),
  retailer(insight, "Delfour"),
  ...
)).

policy_graph(delfourPolicyGraph, (
  odrl_permission(policy, permission(odrl_use, insight, "shopping_assist")),
  odrl_prohibition(policy, prohibition(odrl_distribute, insight, "marketing")),
  odrl_duty(policy, duty(odrl_delete, "2025-10-05T22:33:48.907185+00:00"))
)).
```

The case, insight, policy, envelope and signature are each kept as a quoted
graph. Rules project only the fields they need, so one policy's permission
cannot accidentally contradict another policy elsewhere in the program. The
policy uses ODRL vocabulary: a permission, a prohibition, and a duty to delete.

---

# The key checks

```prolog
minimization_strips_sensitive_terms(check) :-
  serialized_lowercase(insight, Text),
  \+ matches(Text, 'diabetes|medical').

authorization_allowed(check) :-
  permission(policy, odrl_use, insight, "shopping_assist"),
  request_purpose(case, "shopping_assist"),
  scanner_auth_at(case, Authat),
  expires_at(insight, Expiresat),
  (Authat @=< Expiresat).
```

Minimization is checked by searching the shared text for sensitive words. Use
is authorized only for the permitted purpose and only before the insight
expires (ISO timestamps compare correctly as text).

---

# Choosing the alternative

```prolog
product_category(prod_BIS_001, biscuits).
product_category(prod_BIS_101, biscuits).
product_category(prod_CHOC_050, chocolate).
product_category(prod_CHOC_150, chocolate).

suggested_alternative(case, Candidate) :-
  scanned_product(scan, Scanned),
  product_category(Scanned, Category),
  sugar_tenths(Scanned, Scannedsugar),
  product_category(Candidate, Category),
  sugar_tenths(Candidate, Candidatesugar),
  (Scannedsugar > Candidatesugar),
  \+ better_lower_sugar(Category, Scannedsugar, Candidatesugar).
```

A candidate qualifies if it is on the same shelf as the scanned product, has
less sugar, and no other product in that category has even less. Sugar is
stored in tenths of a gram so the comparison is exact integer arithmetic.

---

# The answer

```sh
eyeprolog examples/delfour.pl
```

```text
outcome(decision, "Allowed").
scannedProduct(scan, "Classic Tea Biscuits").
suggestedAlternative(case, "Low-Sugar Tea Biscuits").
headline(banner, "Track sugar per serving while you scan").
note(banner, "High sugar").
allChecksPass(result, true).
minimizationStripsSensitiveTerms(check, true).
```

An excerpt of 31 answers. Use is allowed, the 12 g biscuits are flagged as high
sugar against the 10 g threshold, the 3 g biscuits are suggested, and all ten
checks pass.

---

# The reason

```sh
eyeprolog --proof examples/delfour.pl
```

```text
step(suggested_alternative(case, prod_BIS_101),
     rule(73),
     ['Candidate' = prod_BIS_101,
      'Scanned' = prod_BIS_001,
      'Category' = biscuits,
      'Scannedsugar' = 120,
      'Candidatesugar' = 30],
     [scanned_product(scan, prod_BIS_001),
      product_category(prod_BIS_001, biscuits),
      sugar_tenths(prod_BIS_001, 120),
      product_category(prod_BIS_101, biscuits),
      sugar_tenths(prod_BIS_101, 30),
      120 > 30,
      \+ better_lower_sugar(biscuits, 120, 30)]).
```

The suggestion rests on both products being biscuits, the two sugar values
(12.0 g and 3.0 g, in tenths), the comparison, and the absence of any biscuit
with even less sugar.

---

# The check

```sh
eyeprolog --proof examples/delfour.pl > delfour.why.pl
eyeprolog --check-proof delfour.why.pl examples/delfour.pl
```

```text
condition('C1', resolution, ok, 244).
condition('C5', re_decision, ok, 51).
condition('C6', boundary_consistency, ok, 1).
obligation(absent, theory_scoped, \+ better_lower_sugar(biscuits, 120, 30)).
verdict(checked_with_obligations).
```

All 296 steps check out. That the shared text contains no sensitive word is a
plain test on a string written out in the step, so the checker decides it again
itself. One conclusion still rests on absence and is left as an
**obligation**: that no biscuit beats the suggestion.

The signature check is named for what it does. `signature_accepted_as_trusted/1`
accepts the signature because the input marks its verification mode as
`trustedPrecomputedInput`; the HMAC is not recomputed here, so the check vouches
for that declaration, not for the bytes.

---

# Try it

- Scan `prod_CHOC_050` (Milk Chocolate, 15 g) instead. It is flagged, and the
  suggestion becomes the 85% Dark Chocolate, the lowest-sugar product on the
  chocolate shelf.
- Scan `prod_CHOC_150` (85% Dark Chocolate, 6 g). No banner appears, because it
  is under the threshold.
- Change the request purpose to `"marketing"`. The outcome and the "all checks
  pass" answer disappear, and 22 answers remain.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapters 9 and 25.
