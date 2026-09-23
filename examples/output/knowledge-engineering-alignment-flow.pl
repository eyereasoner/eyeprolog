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
