% Prolog result format 4
query(1, confidence(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 2).
answer(1, ['X0' = message_a, 'X1' = 0.8937599999999999]).
why(1,
    ['X0' = message_a, 'X1' = 0.8937599999999999],
    [confidence(message_a, 0.8937599999999999)]).
answer(1, ['X0' = message_b, 'X1' = 0.41999999999999993]).
why(1,
    ['X0' = message_b, 'X1' = 0.41999999999999993],
    [confidence(message_b, 0.41999999999999993)]).
query(2, trust_flow_state(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 2).
answer(2, ['X0' = message_a, 'X1' = fpv_accepted]).
why(2, ['X0' = message_a, 'X1' = fpv_accepted], [trust_flow_state(message_a, fpv_accepted)]).
answer(2, ['X0' = message_b, 'X1' = fpv_quarantine]).
why(2, ['X0' = message_b, 'X1' = fpv_quarantine], [trust_flow_state(message_b, fpv_quarantine)]).
query(3, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = message_a, 'X1' = fpv_high_trust_flow]).
why(3, ['X0' = message_a, 'X1' = fpv_high_trust_flow], [status(message_a, fpv_high_trust_flow)]).
query(4, risk(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = message_b, 'X1' = risk_low_trust_data_source]).
why(4,
    ['X0' = message_b, 'X1' = risk_low_trust_data_source],
    [risk(message_b, risk_low_trust_data_source)]).

clause(1, message(message_a, publisher_a, transform_a, signature_a, receiver_app), true).
clause(2, message(message_b, publisher_b, transform_b, signature_b, receiver_app), true).
clause(3, publisher_trust(publisher_a, 0.95), true).
clause(4, publisher_trust(publisher_b, 0.7), true).
clause(5, signature_strength(signature_a, 0.98), true).
clause(6, signature_strength(signature_b, 0.75), true).
clause(7, quality_score(transform_a, 0.96), true).
clause(8, quality_score(transform_b, 0.8), true).
clause(9, acceptance_threshold(receiver_app, 0.85), true).
clause(10,
       confidence(var('Message'), var('Confidence')),
       (message(var('Message'), var('Publisher'), var('Transform'), var('Signature'), anonymous(1)),
        publisher_trust(var('Publisher'), var('Publishertrust')),
        signature_strength(var('Signature'), var('Signaturetrust')),
        quality_score(var('Transform'), var('Quality')),
        var('A') is var('Publishertrust') * var('Signaturetrust'),
        var('Confidence') is var('A') * var('Quality'))).
clause(11,
       trust_flow_state(var('Message'), fpv_accepted),
       (message(var('Message'), anonymous(1), anonymous(2), anonymous(3), var('Receiver')),
        confidence(var('Message'), var('Confidence')),
        acceptance_threshold(var('Receiver'), var('Threshold')),
        var('Confidence') >= var('Threshold'))).
clause(12,
       trust_flow_state(var('Message'), fpv_quarantine),
       (message(var('Message'), anonymous(1), anonymous(2), anonymous(3), var('Receiver')),
        confidence(var('Message'), var('Confidence')),
        acceptance_threshold(var('Receiver'), var('Threshold')),
        var('Confidence') < var('Threshold'))).
clause(13,
       status(var('Message'), fpv_high_trust_flow),
       trust_flow_state(var('Message'), fpv_accepted)).
clause(14,
       risk(var('Message'), risk_low_trust_data_source),
       trust_flow_state(var('Message'), fpv_quarantine)).

step(confidence(message_a, 0.8937599999999999),
     rule(10),
     ['Message' = message_a,
      'Confidence' = 0.8937599999999999,
      'Publisher' = publisher_a,
      'Transform' = transform_a,
      'Signature' = signature_a,
      'Publishertrust' = 0.95,
      'Signaturetrust' = 0.98,
      'Quality' = 0.96,
      'A' = 0.9309999999999999],
     [message(message_a, publisher_a, transform_a, signature_a, receiver_app),
      publisher_trust(publisher_a, 0.95),
      signature_strength(signature_a, 0.98),
      quality_score(transform_a, 0.96),
      0.9309999999999999 is 0.95 * 0.98,
      0.8937599999999999 is 0.9309999999999999 * 0.96]).
step(message(message_a, publisher_a, transform_a, signature_a, receiver_app), fact(1), [], []).
step(publisher_trust(publisher_a, 0.95), fact(3), [], []).
step(signature_strength(signature_a, 0.98), fact(5), [], []).
step(quality_score(transform_a, 0.96), fact(7), [], []).
step(0.9309999999999999 is 0.95 * 0.98, builtin, [], []).
step(0.8937599999999999 is 0.9309999999999999 * 0.96, builtin, [], []).
step(confidence(message_b, 0.41999999999999993),
     rule(10),
     ['Message' = message_b,
      'Confidence' = 0.41999999999999993,
      'Publisher' = publisher_b,
      'Transform' = transform_b,
      'Signature' = signature_b,
      'Publishertrust' = 0.7,
      'Signaturetrust' = 0.75,
      'Quality' = 0.8,
      'A' = 0.5249999999999999],
     [message(message_b, publisher_b, transform_b, signature_b, receiver_app),
      publisher_trust(publisher_b, 0.7),
      signature_strength(signature_b, 0.75),
      quality_score(transform_b, 0.8),
      0.5249999999999999 is 0.7 * 0.75,
      0.41999999999999993 is 0.5249999999999999 * 0.8]).
step(message(message_b, publisher_b, transform_b, signature_b, receiver_app), fact(2), [], []).
step(publisher_trust(publisher_b, 0.7), fact(4), [], []).
step(signature_strength(signature_b, 0.75), fact(6), [], []).
step(quality_score(transform_b, 0.8), fact(8), [], []).
step(0.5249999999999999 is 0.7 * 0.75, builtin, [], []).
step(0.41999999999999993 is 0.5249999999999999 * 0.8, builtin, [], []).
step(trust_flow_state(message_a, fpv_accepted),
     rule(11),
     ['Message' = message_a,
      'Receiver' = receiver_app,
      'Confidence' = 0.8937599999999999,
      'Threshold' = 0.85],
     [message(message_a, publisher_a, transform_a, signature_a, receiver_app),
      confidence(message_a, 0.8937599999999999),
      acceptance_threshold(receiver_app, 0.85),
      0.8937599999999999 >= 0.85]).
step(acceptance_threshold(receiver_app, 0.85), fact(9), [], []).
step(0.8937599999999999 >= 0.85, builtin, [], []).
step(trust_flow_state(message_b, fpv_quarantine),
     rule(12),
     ['Message' = message_b,
      'Receiver' = receiver_app,
      'Confidence' = 0.41999999999999993,
      'Threshold' = 0.85],
     [message(message_b, publisher_b, transform_b, signature_b, receiver_app),
      confidence(message_b, 0.41999999999999993),
      acceptance_threshold(receiver_app, 0.85),
      0.41999999999999993 < 0.85]).
step(0.41999999999999993 < 0.85, builtin, [], []).
step(status(message_a, fpv_high_trust_flow),
     rule(13),
     ['Message' = message_a],
     [trust_flow_state(message_a, fpv_accepted)]).
step(risk(message_b, risk_low_trust_data_source),
     rule(14),
     ['Message' = message_b],
     [trust_flow_state(message_b, fpv_quarantine)]).
