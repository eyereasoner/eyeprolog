condition('C1', resolution, ok, 205).
condition('C2', well_founded, ok, 248).
condition('C3', justification, ok, 248).
condition('C4', coverage, ok, 327).
condition('C5', re_decision, ok, 3).
obligation(absent, theory_scoped, \+ positive_action_match(display, delete, __anon0)).
obligation(absent, theory_scoped, \+ (constraint(open_use, Key, Value), \+ evidence(q_print, Key, Value))).
obligation(absent, theory_scoped, \+ (duty(open_use, Duty), \+ duty_done(q_print, Duty))).
obligation(absent, theory_scoped, \+ (constraint(share_report, Key, Value), \+ evidence(q_share_done, Key, Value))).
obligation(absent, theory_scoped, \+ (duty(share_report, Duty), \+ duty_done(q_share_done, Duty))).
obligation(absent, theory_scoped, \+ (constraint(share_report, Key, Value), \+ evidence(q_share_missing, Key, Value))).
obligation(absent, theory_scoped, \+ duty_done(q_share_missing, attribute_source)).
obligation(absent, theory_scoped, \+ (constraint(research_use, Key, Value), \+ evidence(q_research, Key, Value))).
obligation(absent, theory_scoped, \+ (duty(research_use, Duty), \+ duty_done(q_research, Duty))).
obligation(absent, theory_scoped, \+ evidence(q_commercial, purpose, research)).
obligation(absent, theory_scoped, \+ rule_scope_matches(research_use, q_unrelated)).
obligation(absent, theory_scoped, \+ (constraint(open_no_print, Key, Value), \+ evidence(q_print, Key, Value))).
obligation(absent, theory_scoped, \+ (constraint(strict_use, Key, Value), \+ evidence(q_print, Key, Value))).
obligation(absent, theory_scoped, \+ (duty(strict_use, Duty), \+ duty_done(q_print, Duty))).
obligation(absent, theory_scoped, \+ (constraint(strict_no_print, Key, Value), \+ evidence(q_print, Key, Value))).
obligation(absent, theory_scoped, \+ (constraint(invalid_use, Key, Value), \+ evidence(q_print, Key, Value))).
obligation(absent, theory_scoped, \+ (duty(invalid_use, Duty), \+ duty_done(q_print, Duty))).
obligation(absent, theory_scoped, \+ (constraint(invalid_no_print, Key, Value), \+ evidence(q_print, Key, Value))).
obligation(absent, theory_scoped, \+ policy_prohibition(duty_policy, q_share_done)).
obligation(absent, theory_scoped, \+ policy_permission(duty_policy, q_share_missing)).
obligation(absent, theory_scoped, \+ policy_prohibition(duty_policy, q_share_missing)).
obligation(absent, theory_scoped, \+ policy_permission(context_policy, q_commercial)).
obligation(absent, theory_scoped, \+ policy_prohibition(context_policy, q_commercial)).
obligation(absent, theory_scoped, \+ policy_applicable(context_policy, q_unrelated)).
obligation(absent, theory_scoped, \+ (constraint(exact_permit, Key, A), constraint(exact_prohibit, Key, B), A \= B)).
obligation(absent, theory_scoped, \+ (constraint(broad_permit, Key, A), constraint(narrow_prohibit, Key, B), A \= B)).
obligation(builtin, theory_scoped, action_subsumes(use, print) ; action_subsumes(print, use)).
obligation(absent, theory_scoped, \+ (constraint(aggregate_permit, Key, A), constraint(read_prohibit, Key, B), A \= B)).
obligation(absent, theory_scoped, \+ action_subsumes(aggregate, read)).
obligation(absent, theory_scoped, \+ action_subsumes(read, aggregate)).
obligation(builtin, theory_scoped, action_requires(aggregate, read) ; action_requires(read, aggregate)).
obligation(absent, theory_scoped, \+ action_subsumes(display, use)).
obligation(absent, theory_scoped, \+ (constraint(general_use, Key, Value), \+ constraint(specific_display, Key, Value))).
obligation(absent, theory_scoped, \+ (duty(general_use, Duty), \+ duty(specific_display, Duty))).
obligation(absent, theory_scoped, \+ rule_subsumes(specific_display, general_use)).
obligation(absent, theory_scoped, \+ (rule(SpecificRule, specific_policy, __anon54, __anon55, __anon56, __anon57), \+ (rule(GeneralRule, general_policy, __anon58, __anon59, __anon60, __anon61), rule_subsumes(GeneralRule, SpecificRule)))).
obligation(absent, theory_scoped, \+ policy_subsumes(specific_policy, general_policy)).
obligation(builtin, theory_scoped, wfs_truth(profile_permission(clear), true)).
obligation(builtin, theory_scoped, wfs_truth(profile_permission(denied), false)).
obligation(builtin, theory_scoped, wfs_truth(profile_permission(cycle), undefined)).
steps(248).
verified(205).
recomputed(3).
composed(0).
trusted(40).
claims(34).
verdict(checked_with_obligations).
