type(msg1, local_observation).
type(probe7, temperature_probe).
type(msg1, sosa_observation).
type(probe7, sosa_sensor).
target_fact(msg1, sosa_madeBySensor, probe7).
target_fact(msg1, sosa_resultTime, "2026-06-17T12:34:56Z").
target_fact(msg1, sosa_hasSimpleResult, 18.6).
target_fact(msg1, fpv_hasFlowStep, ingest_step).
target_fact(msg1, sosa_hasFeatureOfInterest, platform_b).
runtime_rule(observed_by, copy_to_target).
runtime_rule(observed_at, copy_to_target).
runtime_rule(temperature_celsius, copy_to_target).
runtime_rule(in_flow, copy_to_target).
runtime_rule(observed_feature, copy_to_target).
target_predicate(observed_by, sosa_madeBySensor).
target_predicate(observed_at, sosa_resultTime).
target_predicate(temperature_celsius, sosa_hasSimpleResult).
target_predicate(in_flow, fpv_hasFlowStep).
target_predicate(observed_feature, sosa_hasFeatureOfInterest).
flow_emits(ingest_step, msg1).
trusted_by(ingest_step, probe7).

clause(1, sub_class(local_observation, sosa_observation), true).
clause(2, sub_class(temperature_probe, sosa_sensor), true).
clause(3, sub_property(observed_by, sosa_madeBySensor), true).
clause(4, sub_property(observed_at, sosa_resultTime), true).
clause(5, sub_property(temperature_celsius, sosa_hasSimpleResult), true).
clause(6, sub_property(in_flow, fpv_hasFlowStep), true).
clause(7, equivalent_property(observed_feature, sosa_hasFeatureOfInterest), true).
clause(8, base_type(msg1, local_observation), true).
clause(9, base_type(probe7, temperature_probe), true).
clause(10, triple(msg1, observed_by, probe7), true).
clause(11, triple(msg1, observed_at, "2026-06-17T12:34:56Z"), true).
clause(12, triple(msg1, temperature_celsius, 18.6), true).
clause(13, triple(msg1, observed_feature, platform_b), true).
clause(14, triple(msg1, in_flow, ingest_step), true).
clause(15, type(var('Thing'), var('Class')), base_type(var('Thing'), var('Class'))).
clause(16,
       type(var('Thing'), var('Super')),
       (base_type(var('Thing'), var('Class')), sub_class_of(var('Class'), var('Super')))).
clause(17, sub_class_of(var('Class'), var('Super')), sub_class(var('Class'), var('Super'))).
clause(19,
       target_fact(var('Subject'), var('Superpredicate'), var('Object')),
       (triple(var('Subject'), var('Predicate'), var('Object')),
        sub_property(var('Predicate'), var('Superpredicate')))).
clause(20,
       target_fact(var('Subject'), var('Targetpredicate'), var('Object')),
       (triple(var('Subject'), var('Predicate'), var('Object')),
        equivalent_property(var('Predicate'), var('Targetpredicate')))).
clause(22,
       runtime_rule(var('Sourcepredicate'), copy_to_target),
       sub_property(var('Sourcepredicate'), anonymous(1))).
clause(23,
       runtime_rule(var('Sourcepredicate'), copy_to_target),
       equivalent_property(var('Sourcepredicate'), anonymous(1))).
clause(24,
       target_predicate(var('Sourcepredicate'), var('Targetpredicate')),
       sub_property(var('Sourcepredicate'), var('Targetpredicate'))).
clause(25,
       target_predicate(var('Sourcepredicate'), var('Targetpredicate')),
       equivalent_property(var('Sourcepredicate'), var('Targetpredicate'))).
clause(26,
       flow_emits(var('Step'), var('Message')),
       (type(var('Message'), sosa_observation),
        target_fact(var('Message'), fpv_hasFlowStep, var('Step')),
        target_fact(var('Message'), sosa_madeBySensor, anonymous(1)))).
clause(27,
       trusted_by(var('Step'), var('Sensor')),
       (type(var('Message'), sosa_observation),
        target_fact(var('Message'), fpv_hasFlowStep, var('Step')),
        target_fact(var('Message'), sosa_madeBySensor, var('Sensor')))).

step(type(msg1, local_observation),
     rule(15),
     ['Thing' = msg1, 'Class' = local_observation],
     [base_type(msg1, local_observation)]).
step(base_type(msg1, local_observation), fact(8), [], []).
step(type(probe7, temperature_probe),
     rule(15),
     ['Thing' = probe7, 'Class' = temperature_probe],
     [base_type(probe7, temperature_probe)]).
step(base_type(probe7, temperature_probe), fact(9), [], []).
step(type(msg1, sosa_observation),
     rule(16),
     ['Thing' = msg1, 'Super' = sosa_observation, 'Class' = local_observation],
     [base_type(msg1, local_observation), sub_class_of(local_observation, sosa_observation)]).
step(sub_class_of(local_observation, sosa_observation),
     rule(17),
     ['Class' = local_observation, 'Super' = sosa_observation],
     [sub_class(local_observation, sosa_observation)]).
step(sub_class(local_observation, sosa_observation), fact(1), [], []).
step(type(probe7, sosa_sensor),
     rule(16),
     ['Thing' = probe7, 'Super' = sosa_sensor, 'Class' = temperature_probe],
     [base_type(probe7, temperature_probe), sub_class_of(temperature_probe, sosa_sensor)]).
step(sub_class_of(temperature_probe, sosa_sensor),
     rule(17),
     ['Class' = temperature_probe, 'Super' = sosa_sensor],
     [sub_class(temperature_probe, sosa_sensor)]).
step(sub_class(temperature_probe, sosa_sensor), fact(2), [], []).
step(target_fact(msg1, sosa_madeBySensor, probe7),
     rule(19),
     ['Subject' = msg1,
      'Superpredicate' = sosa_madeBySensor,
      'Object' = probe7,
      'Predicate' = observed_by],
     [triple(msg1, observed_by, probe7), sub_property(observed_by, sosa_madeBySensor)]).
step(triple(msg1, observed_by, probe7), fact(10), [], []).
step(sub_property(observed_by, sosa_madeBySensor), fact(3), [], []).
step(target_fact(msg1, sosa_resultTime, "2026-06-17T12:34:56Z"),
     rule(19),
     ['Subject' = msg1,
      'Superpredicate' = sosa_resultTime,
      'Object' = "2026-06-17T12:34:56Z",
      'Predicate' = observed_at],
     [triple(msg1, observed_at, "2026-06-17T12:34:56Z"),
      sub_property(observed_at, sosa_resultTime)]).
step(triple(msg1, observed_at, "2026-06-17T12:34:56Z"), fact(11), [], []).
step(sub_property(observed_at, sosa_resultTime), fact(4), [], []).
step(target_fact(msg1, sosa_hasSimpleResult, 18.6),
     rule(19),
     ['Subject' = msg1,
      'Superpredicate' = sosa_hasSimpleResult,
      'Object' = 18.6,
      'Predicate' = temperature_celsius],
     [triple(msg1, temperature_celsius, 18.6),
      sub_property(temperature_celsius, sosa_hasSimpleResult)]).
step(triple(msg1, temperature_celsius, 18.6), fact(12), [], []).
step(sub_property(temperature_celsius, sosa_hasSimpleResult), fact(5), [], []).
step(target_fact(msg1, fpv_hasFlowStep, ingest_step),
     rule(19),
     ['Subject' = msg1,
      'Superpredicate' = fpv_hasFlowStep,
      'Object' = ingest_step,
      'Predicate' = in_flow],
     [triple(msg1, in_flow, ingest_step), sub_property(in_flow, fpv_hasFlowStep)]).
step(triple(msg1, in_flow, ingest_step), fact(14), [], []).
step(sub_property(in_flow, fpv_hasFlowStep), fact(6), [], []).
step(target_fact(msg1, sosa_hasFeatureOfInterest, platform_b),
     rule(20),
     ['Subject' = msg1,
      'Targetpredicate' = sosa_hasFeatureOfInterest,
      'Object' = platform_b,
      'Predicate' = observed_feature],
     [triple(msg1, observed_feature, platform_b),
      equivalent_property(observed_feature, sosa_hasFeatureOfInterest)]).
step(triple(msg1, observed_feature, platform_b), fact(13), [], []).
step(equivalent_property(observed_feature, sosa_hasFeatureOfInterest), fact(7), [], []).
step(runtime_rule(observed_by, copy_to_target),
     rule(22),
     ['Sourcepredicate' = observed_by],
     [sub_property(observed_by, sosa_madeBySensor)]).
step(runtime_rule(observed_at, copy_to_target),
     rule(22),
     ['Sourcepredicate' = observed_at],
     [sub_property(observed_at, sosa_resultTime)]).
step(runtime_rule(temperature_celsius, copy_to_target),
     rule(22),
     ['Sourcepredicate' = temperature_celsius],
     [sub_property(temperature_celsius, sosa_hasSimpleResult)]).
step(runtime_rule(in_flow, copy_to_target),
     rule(22),
     ['Sourcepredicate' = in_flow],
     [sub_property(in_flow, fpv_hasFlowStep)]).
step(runtime_rule(observed_feature, copy_to_target),
     rule(23),
     ['Sourcepredicate' = observed_feature],
     [equivalent_property(observed_feature, sosa_hasFeatureOfInterest)]).
step(target_predicate(observed_by, sosa_madeBySensor),
     rule(24),
     ['Sourcepredicate' = observed_by, 'Targetpredicate' = sosa_madeBySensor],
     [sub_property(observed_by, sosa_madeBySensor)]).
step(target_predicate(observed_at, sosa_resultTime),
     rule(24),
     ['Sourcepredicate' = observed_at, 'Targetpredicate' = sosa_resultTime],
     [sub_property(observed_at, sosa_resultTime)]).
step(target_predicate(temperature_celsius, sosa_hasSimpleResult),
     rule(24),
     ['Sourcepredicate' = temperature_celsius, 'Targetpredicate' = sosa_hasSimpleResult],
     [sub_property(temperature_celsius, sosa_hasSimpleResult)]).
step(target_predicate(in_flow, fpv_hasFlowStep),
     rule(24),
     ['Sourcepredicate' = in_flow, 'Targetpredicate' = fpv_hasFlowStep],
     [sub_property(in_flow, fpv_hasFlowStep)]).
step(target_predicate(observed_feature, sosa_hasFeatureOfInterest),
     rule(25),
     ['Sourcepredicate' = observed_feature, 'Targetpredicate' = sosa_hasFeatureOfInterest],
     [equivalent_property(observed_feature, sosa_hasFeatureOfInterest)]).
step(flow_emits(ingest_step, msg1),
     rule(26),
     ['Step' = ingest_step, 'Message' = msg1],
     [type(msg1, sosa_observation),
      target_fact(msg1, fpv_hasFlowStep, ingest_step),
      target_fact(msg1, sosa_madeBySensor, probe7)]).
step(trusted_by(ingest_step, probe7),
     rule(27),
     ['Step' = ingest_step, 'Sensor' = probe7, 'Message' = msg1],
     [type(msg1, sosa_observation),
      target_fact(msg1, fpv_hasFlowStep, ingest_step),
      target_fact(msg1, sosa_madeBySensor, probe7)]).
