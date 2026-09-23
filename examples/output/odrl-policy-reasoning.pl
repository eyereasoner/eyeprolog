actionQuestion(exact, use, use, exact).
actionQuestion(broader, use, print, broader).
actionQuestion(narrower, print, use, narrower).
actionQuestion(required, read, aggregate, required).
actionQuestion(requiring, aggregate, read, requiring).
actionQuestion(unrelated, display, delete, no_match).
ruleQuestion(unconditional, open_use, q_print, permission).
ruleQuestion(duty_satisfied, share_report, q_share_done, permission).
ruleQuestion(duty_missing, share_report, q_share_missing, inactive(duty(attribute_source))).
ruleQuestion(constraint_true, research_use, q_research, permission).
ruleQuestion(constraint_false, research_use, q_commercial, inactive(constraint(purpose))).
ruleQuestion(scope_miss, research_use, q_unrelated, not_applicable).
ruleQuestion(prohibition, open_no_print, q_print, prohibition).
enforcementQuestion(permission_overrides, open_printing, q_print, closed, permission, permit).
enforcementQuestion(prohibition_overrides, strict_printing, q_print, closed, prohibition, deny).
enforcementQuestion(conflict_invalidates, invalid_printing, q_print, closed, invalid, invalid).
enforcementQuestion(duty_satisfied, duty_policy, q_share_done, closed, permission, permit).
enforcementQuestion(duty_missing, duty_policy, q_share_missing, closed, inactive, deny).
enforcementQuestion(constraint_false, context_policy, q_commercial, closed, inactive, deny).
enforcementQuestion(no_match_closed, context_policy, q_unrelated, closed, not_applicable, deny).
enforcementQuestion(no_match_open, context_policy, q_unrelated, open, not_applicable, permit).
enforcementQuestion(no_match_default, context_policy, q_unrelated, default, not_applicable, deny).
conflictQuestion(exact, analysis_policy, exact_permit, exact_prohibit, exact).
conflictQuestion(subsumption, analysis_policy, broad_permit, narrow_prohibit, subsumption).
conflictQuestion(dependency, analysis_policy, aggregate_permit, read_prohibit, dependency).
subsumptionQuestion(action_yes, use, display, yes).
subsumptionQuestion(action_no, display, use, no).
subsumptionQuestion(rule_yes, general_use, specific_display, yes).
subsumptionQuestion(rule_no, specific_display, general_use, no).
subsumptionQuestion(policy_yes, general_policy, specific_policy, yes).
subsumptionQuestion(policy_no, specific_policy, general_policy, no).
wfsQuestion(clear_permission, true).
wfsQuestion(absent_permission, false).
wfsQuestion(negative_cycle, undefined).
