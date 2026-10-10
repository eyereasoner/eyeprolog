# Service impact

## When the payment service fails, what else goes down?

Modern systems are graphs of services that call each other, and those graphs
have cycles. This example propagates one failure through a dependency graph
with a feedback loop and still produces a finite, complete impact set.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=service-impact) ·
[Source](../service-impact.pl)

---

# The question

The payment service is down. Which services depend on it, directly or
indirectly, and which business functions are at risk?

The catch: payment calls fraud screening, fraud screening calls the risk
rules, and the risk rules call payment again. A naive recursive search would
go round that loop forever.

---

# The dependency graph

```prolog
depends_on(web_store, checkout_api).
depends_on(mobile_app, checkout_api).
depends_on(checkout_api, payment_service).
depends_on(checkout_api, inventory_service).
depends_on(payment_service, fraud_service).
depends_on(fraud_service, risk_rules).
depends_on(risk_rules, payment_service).

business_function(place_order, web_store).
business_function(collect_payment, payment_service).
business_function(show_stock, inventory_service).

failed(payment_service).
```

---

# The rules

```prolog
:- table impacted/2.

impacted(Service, Failed) :- depends_on(Service, Failed).
impacted(Service, Failed) :- depends_on(Service, Dependency), impacted(Dependency, Failed).

affected_function(Function) :- business_function(Function, Service), affected(Service).
```

A service is impacted if it depends on the failed one, or on something that
is impacted. The `table` declaration makes EyeProlog remember each
`impacted/2` question and its answers, so going round the cycle finds nothing
new and the search stops at a fixed point.

---

# The answer

```sh
eyeprolog examples/service-impact.pl
```

```text
impactedByFailureOf(checkout_api, payment_service).
impactedByFailureOf(risk_rules, payment_service).
impactedByFailureOf(web_store, payment_service).
impactedByFailureOf(mobile_app, payment_service).
impactedByFailureOf(payment_service, payment_service).
impactedByFailureOf(fraud_service, payment_service).
status(payment_service, failed).
businessFunctionAtRisk(place_order, true).
businessFunctionAtRisk(mobile_checkout, true).
businessFunctionAtRisk(collect_payment, true).
businessFunctionAtRisk(screen_fraud, true).
```

Six services are impacted, including payment itself, through its own loop.
Four business functions are at risk; `show_stock` is not, because inventory
does not depend on payment.

---

# The reason

```text
step(impacted(payment_service, payment_service),
     rule(18),
     ['Service' = payment_service, 'Failed' = payment_service, 'Dependency' = fraud_service],
     [depends_on(payment_service, fraud_service), impacted(fraud_service, payment_service)]).
step(impacted(risk_rules, payment_service),
     rule(17),
     ['Service' = risk_rules, 'Failed' = payment_service],
     [depends_on(risk_rules, payment_service)]).
```

Payment is impacted by its own failure because it depends on fraud
screening, which is impacted in turn. The cycle shows up in the proof as a
finite chain of steps that ends at the direct edge from `risk_rules`.

---

# The check

```text
condition('C1', resolution, ok, 36).
condition('C2', well_founded, ok, 36).
verdict(checked).
```

All 36 steps replay against the program. C2 (well-foundedness) confirms that
no conclusion depends on itself: the graph has a cycle, but the proof does
not.

---

# Try it

- Replace `failed(payment_service).` with `failed(stock_db).` Now
  `show_stock` is at risk, along with ordering and mobile checkout, but
  payment is not.
- Remove the `:- table impacted/2.` line and predict what happens before you
  run it.
- Add a `blast_radius(Failed, N)` relation that counts impacted services with
  `countall/2`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 13.
