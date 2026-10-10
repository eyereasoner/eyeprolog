# Trust flow with a provenance threshold

## Should a receiver accept this message?

A message passes through a publisher, a signature, and a transformation, and
each contributes some degree of trust. This example multiplies the three into
one confidence score and compares it with the receiver's threshold, so every
accept or quarantine decision can be traced back to its numbers.

[Run it in the playground](https://eyereasoner.github.io/eyeprolog/playground#example=trust-flow-provenance-threshold) ·
[Source](../trust-flow-provenance-threshold.pl)

---

# The question

Two messages reach the same application. Which one should it accept, and which
should it quarantine?

Provenance means where data came from and what happened to it on the way. Here
it has three parts: who published the message, how strong its signature is, and
how reliable the transformation that produced it was.

---

# The facts

```prolog
message(message_a, publisher_a, transform_a, signature_a, receiver_app).
message(message_b, publisher_b, transform_b, signature_b, receiver_app).

publisher_trust(publisher_a, 0.95).
publisher_trust(publisher_b, 0.70).
signature_strength(signature_a, 0.98).
signature_strength(signature_b, 0.75).
quality_score(transform_a, 0.96).
quality_score(transform_b, 0.80).
acceptance_threshold(receiver_app, 0.85).
```

Each factor is a score between 0 and 1. The receiver accepts messages whose
combined confidence is at least 0.85.

---

# The rules

```prolog
confidence(Message, Confidence) :-
  message(Message, Publisher, Transform, Signature, _receiver),
  publisher_trust(Publisher, Publishertrust),
  signature_strength(Signature, Signaturetrust),
  quality_score(Transform, Quality),
  (A is Publishertrust * Signaturetrust),
  (Confidence is A * Quality).

trust_flow_state(Message, fpv_quarantine) :-
  message(Message, _publisher, _transform, _signature, Receiver),
  confidence(Message, Confidence),
  acceptance_threshold(Receiver, Threshold),
  (Confidence < Threshold).
```

Confidence is the product of the three factors, so one weak link pulls the
whole score down. A matching rule with `>=` yields `fpv_accepted`.

---

# The answer

```sh
eyeprolog examples/trust-flow-provenance-threshold.pl
```

```text
confidence(message_a, 0.8937599999999999).
confidence(message_b, 0.41999999999999993).
trust_flow_state(message_a, fpv_accepted).
trust_flow_state(message_b, fpv_quarantine).
status(message_a, fpv_high_trust_flow).
risk(message_b, risk_low_trust_data_source).
```

Message A scores about 0.894 and is accepted; message B scores 0.42 and is
quarantined. The long decimals are ordinary floating-point rounding.

---

# The reason

```text
step(0.9309999999999999 is 0.95 * 0.98, builtin, [], []).
step(0.8937599999999999 is 0.9309999999999999 * 0.96, builtin, [], []).
```

The proof records each multiplication separately: publisher trust times
signature strength, then that product times the transformation quality. An
auditor can see exactly which factor contributed what.

---

# The check

```text
condition('C1', resolution, ok, 15).
condition('C5', re_decision, ok, 6).
condition('C7', relevance, ok, 27).
verdict(checked).
```

The checker replays the 15 rule and fact steps and recomputes all 6
arithmetic steps itself, so even the floating-point products are confirmed
independently.

---

# Try it

- Raise `signature_strength(signature_b, 0.75)` to `0.99`. Is message B
  accepted now?
- Lower the threshold to `0.40` and predict both decisions.
- Add a fourth factor, such as a freshness score, to `confidence/2`.

Learn more in [*The Art of EyeProlog*](https://eyereasoner.github.io/eyeprolog/the-art-of-eyeprolog),
Chapter 14.
