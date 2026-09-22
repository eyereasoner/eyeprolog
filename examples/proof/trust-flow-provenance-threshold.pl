confidence(message_a, 0.8937599999999999).
why(
  confidence(message_a, 0.8937599999999999),
  step(
    confidence(message_a, 0.8937599999999999),
    rule("trust-flow-provenance-threshold.pl", clause(10)),
    ['Message' = message_a, 'Confidence' = 0.8937599999999999, 'Publisher' = publisher_a, 'Transform' = transform_a, 'Signature' = signature_a, '_receiver' = receiver_app, 'Publishertrust' = 0.95, 'Signaturetrust' = 0.98, 'Quality' = 0.96, 'A' = 0.9309999999999999],
    [
      step(message(message_a, publisher_a, transform_a, signature_a, receiver_app), fact("trust-flow-provenance-threshold.pl", clause(1)), [], []),
      step(publisher_trust(publisher_a, 0.95), fact("trust-flow-provenance-threshold.pl", clause(3)), [], []),
      step(signature_strength(signature_a, 0.98), fact("trust-flow-provenance-threshold.pl", clause(5)), [], []),
      step(quality_score(transform_a, 0.96), fact("trust-flow-provenance-threshold.pl", clause(7)), [], []),
      step(is(0.9309999999999999, *(0.95, 0.98)), builtin(is, 2), [], []),
      step(is(0.8937599999999999, *(0.9309999999999999, 0.96)), builtin(is, 2), [], [])
    ]
  )
).

confidence(message_b, 0.41999999999999993).
why(
  confidence(message_b, 0.41999999999999993),
  step(
    confidence(message_b, 0.41999999999999993),
    rule("trust-flow-provenance-threshold.pl", clause(10)),
    ['Message' = message_b, 'Confidence' = 0.41999999999999993, 'Publisher' = publisher_b, 'Transform' = transform_b, 'Signature' = signature_b, '_receiver' = receiver_app, 'Publishertrust' = 0.7, 'Signaturetrust' = 0.75, 'Quality' = 0.8, 'A' = 0.5249999999999999],
    [
      step(message(message_b, publisher_b, transform_b, signature_b, receiver_app), fact("trust-flow-provenance-threshold.pl", clause(2)), [], []),
      step(publisher_trust(publisher_b, 0.7), fact("trust-flow-provenance-threshold.pl", clause(4)), [], []),
      step(signature_strength(signature_b, 0.75), fact("trust-flow-provenance-threshold.pl", clause(6)), [], []),
      step(quality_score(transform_b, 0.8), fact("trust-flow-provenance-threshold.pl", clause(8)), [], []),
      step(is(0.5249999999999999, *(0.7, 0.75)), builtin(is, 2), [], []),
      step(is(0.41999999999999993, *(0.5249999999999999, 0.8)), builtin(is, 2), [], [])
    ]
  )
).

trust_flow_state(message_a, fpv_accepted).
why(
  trust_flow_state(message_a, fpv_accepted),
  step(
    trust_flow_state(message_a, fpv_accepted),
    rule("trust-flow-provenance-threshold.pl", clause(11)),
    ['Message' = message_a, '_publisher' = publisher_a, '_transform' = transform_a, '_signature' = signature_a, 'Receiver' = receiver_app, 'Confidence' = 0.8937599999999999, 'Threshold' = 0.85],
    [
      step(message(message_a, publisher_a, transform_a, signature_a, receiver_app), fact("trust-flow-provenance-threshold.pl", clause(1)), [], []),
      step(
        confidence(message_a, 0.8937599999999999),
        rule("trust-flow-provenance-threshold.pl", clause(10)),
        ['Message' = message_a, 'Confidence' = 0.8937599999999999, 'Publisher' = publisher_a, 'Transform' = transform_a, 'Signature' = signature_a, '_receiver' = receiver_app, 'Publishertrust' = 0.95, 'Signaturetrust' = 0.98, 'Quality' = 0.96, 'A' = 0.9309999999999999],
        [
          step(message(message_a, publisher_a, transform_a, signature_a, receiver_app), fact("trust-flow-provenance-threshold.pl", clause(1)), [], []),
          step(publisher_trust(publisher_a, 0.95), fact("trust-flow-provenance-threshold.pl", clause(3)), [], []),
          step(signature_strength(signature_a, 0.98), fact("trust-flow-provenance-threshold.pl", clause(5)), [], []),
          step(quality_score(transform_a, 0.96), fact("trust-flow-provenance-threshold.pl", clause(7)), [], []),
          step(is(0.9309999999999999, *(0.95, 0.98)), builtin(is, 2), [], []),
          step(is(0.8937599999999999, *(0.9309999999999999, 0.96)), builtin(is, 2), [], [])
        ]
      ),
      step(acceptance_threshold(receiver_app, 0.85), fact("trust-flow-provenance-threshold.pl", clause(9)), [], []),
      step(>=(0.8937599999999999, 0.85), builtin(>=, 2), [], [])
    ]
  )
).

trust_flow_state(message_b, fpv_quarantine).
why(
  trust_flow_state(message_b, fpv_quarantine),
  step(
    trust_flow_state(message_b, fpv_quarantine),
    rule("trust-flow-provenance-threshold.pl", clause(12)),
    ['Message' = message_b, '_publisher' = publisher_b, '_transform' = transform_b, '_signature' = signature_b, 'Receiver' = receiver_app, 'Confidence' = 0.41999999999999993, 'Threshold' = 0.85],
    [
      step(message(message_b, publisher_b, transform_b, signature_b, receiver_app), fact("trust-flow-provenance-threshold.pl", clause(2)), [], []),
      step(
        confidence(message_b, 0.41999999999999993),
        rule("trust-flow-provenance-threshold.pl", clause(10)),
        ['Message' = message_b, 'Confidence' = 0.41999999999999993, 'Publisher' = publisher_b, 'Transform' = transform_b, 'Signature' = signature_b, '_receiver' = receiver_app, 'Publishertrust' = 0.7, 'Signaturetrust' = 0.75, 'Quality' = 0.8, 'A' = 0.5249999999999999],
        [
          step(message(message_b, publisher_b, transform_b, signature_b, receiver_app), fact("trust-flow-provenance-threshold.pl", clause(2)), [], []),
          step(publisher_trust(publisher_b, 0.7), fact("trust-flow-provenance-threshold.pl", clause(4)), [], []),
          step(signature_strength(signature_b, 0.75), fact("trust-flow-provenance-threshold.pl", clause(6)), [], []),
          step(quality_score(transform_b, 0.8), fact("trust-flow-provenance-threshold.pl", clause(8)), [], []),
          step(is(0.5249999999999999, *(0.7, 0.75)), builtin(is, 2), [], []),
          step(is(0.41999999999999993, *(0.5249999999999999, 0.8)), builtin(is, 2), [], [])
        ]
      ),
      step(acceptance_threshold(receiver_app, 0.85), fact("trust-flow-provenance-threshold.pl", clause(9)), [], []),
      step(<(0.41999999999999993, 0.85), builtin(<, 2), [], [])
    ]
  )
).

status(message_a, fpv_high_trust_flow).
why(
  status(message_a, fpv_high_trust_flow),
  step(
    status(message_a, fpv_high_trust_flow),
    rule("trust-flow-provenance-threshold.pl", clause(13)),
    ['Message' = message_a],
    [
      step(
        trust_flow_state(message_a, fpv_accepted),
        rule("trust-flow-provenance-threshold.pl", clause(11)),
        ['Message' = message_a, '_publisher' = publisher_a, '_transform' = transform_a, '_signature' = signature_a, 'Receiver' = receiver_app, 'Confidence' = 0.8937599999999999, 'Threshold' = 0.85],
        [
          step(message(message_a, publisher_a, transform_a, signature_a, receiver_app), fact("trust-flow-provenance-threshold.pl", clause(1)), [], []),
          step(
            confidence(message_a, 0.8937599999999999),
            rule("trust-flow-provenance-threshold.pl", clause(10)),
            ['Message' = message_a, 'Confidence' = 0.8937599999999999, 'Publisher' = publisher_a, 'Transform' = transform_a, 'Signature' = signature_a, '_receiver' = receiver_app, 'Publishertrust' = 0.95, 'Signaturetrust' = 0.98, 'Quality' = 0.96, 'A' = 0.9309999999999999],
            [
              step(message(message_a, publisher_a, transform_a, signature_a, receiver_app), fact("trust-flow-provenance-threshold.pl", clause(1)), [], []),
              step(publisher_trust(publisher_a, 0.95), fact("trust-flow-provenance-threshold.pl", clause(3)), [], []),
              step(signature_strength(signature_a, 0.98), fact("trust-flow-provenance-threshold.pl", clause(5)), [], []),
              step(quality_score(transform_a, 0.96), fact("trust-flow-provenance-threshold.pl", clause(7)), [], []),
              step(is(0.9309999999999999, *(0.95, 0.98)), builtin(is, 2), [], []),
              step(is(0.8937599999999999, *(0.9309999999999999, 0.96)), builtin(is, 2), [], [])
            ]
          ),
          step(acceptance_threshold(receiver_app, 0.85), fact("trust-flow-provenance-threshold.pl", clause(9)), [], []),
          step(>=(0.8937599999999999, 0.85), builtin(>=, 2), [], [])
        ]
      )
    ]
  )
).

risk(message_b, risk_low_trust_data_source).
why(
  risk(message_b, risk_low_trust_data_source),
  step(
    risk(message_b, risk_low_trust_data_source),
    rule("trust-flow-provenance-threshold.pl", clause(14)),
    ['Message' = message_b],
    [
      step(
        trust_flow_state(message_b, fpv_quarantine),
        rule("trust-flow-provenance-threshold.pl", clause(12)),
        ['Message' = message_b, '_publisher' = publisher_b, '_transform' = transform_b, '_signature' = signature_b, 'Receiver' = receiver_app, 'Confidence' = 0.41999999999999993, 'Threshold' = 0.85],
        [
          step(message(message_b, publisher_b, transform_b, signature_b, receiver_app), fact("trust-flow-provenance-threshold.pl", clause(2)), [], []),
          step(
            confidence(message_b, 0.41999999999999993),
            rule("trust-flow-provenance-threshold.pl", clause(10)),
            ['Message' = message_b, 'Confidence' = 0.41999999999999993, 'Publisher' = publisher_b, 'Transform' = transform_b, 'Signature' = signature_b, '_receiver' = receiver_app, 'Publishertrust' = 0.7, 'Signaturetrust' = 0.75, 'Quality' = 0.8, 'A' = 0.5249999999999999],
            [
              step(message(message_b, publisher_b, transform_b, signature_b, receiver_app), fact("trust-flow-provenance-threshold.pl", clause(2)), [], []),
              step(publisher_trust(publisher_b, 0.7), fact("trust-flow-provenance-threshold.pl", clause(4)), [], []),
              step(signature_strength(signature_b, 0.75), fact("trust-flow-provenance-threshold.pl", clause(6)), [], []),
              step(quality_score(transform_b, 0.8), fact("trust-flow-provenance-threshold.pl", clause(8)), [], []),
              step(is(0.5249999999999999, *(0.7, 0.75)), builtin(is, 2), [], []),
              step(is(0.41999999999999993, *(0.5249999999999999, 0.8)), builtin(is, 2), [], [])
            ]
          ),
          step(acceptance_threshold(receiver_app, 0.85), fact("trust-flow-provenance-threshold.pl", clause(9)), [], []),
          step(<(0.41999999999999993, 0.85), builtin(<, 2), [], [])
        ]
      )
    ]
  )
).

