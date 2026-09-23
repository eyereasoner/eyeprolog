supporting_study(marker_reduction, study_a).
supporting_study(marker_reduction, study_b).
supporting_study(survival_benefit, study_d).
counterevidence(marker_reduction, study_c, low_quality).
counterevidence(survival_benefit, study_e, high_quality).
evidence_state(marker_reduction, supported).
evidence_state(survival_benefit, contested).
evidence_reason(marker_reduction, "Two independent randomized studies with sample size >= 100 support the claim; the contradictory observational study is retained as lower-quality counterevidence.").
evidence_reason(survival_benefit, "High-quality randomized evidence exists on both sides, so the claim remains contested instead of being collapsed to a single truth value.").
