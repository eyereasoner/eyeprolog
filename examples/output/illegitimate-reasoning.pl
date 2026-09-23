fallacy(arg_affirming_consequent, affirming_consequent).
fallacy(arg_denying_antecedent, denying_antecedent).
fallacy(arg_hasty_generalization, hasty_generalization).
fallacy(arg_false_dilemma, false_dilemma).
type(arg_affirming_consequent, illegitimate_reasoning).
type(arg_denying_antecedent, illegitimate_reasoning).
type(arg_hasty_generalization, illegitimate_reasoning).
type(arg_false_dilemma, illegitimate_reasoning).
conclusion(arg_affirming_consequent, rain).
conclusion(arg_denying_antecedent, neg(door_opens)).
conclusion(arg_hasty_generalization, all(crows, black)).
conclusion(arg_false_dilemma, approve_now).
reason(arg_affirming_consequent, "observing the consequent does not prove the antecedent").
reason(arg_denying_antecedent, "denying the antecedent does not disprove the consequent").
reason(arg_hasty_generalization, "sample size is below the threshold for a universal conclusion").
reason(arg_false_dilemma, "a relevant alternative is omitted").
sampleSize(arg_hasty_generalization, 3).
requiredSampleSize(arg_hasty_generalization, 30).
omittedAlternative(arg_false_dilemma, revise_proposal).
