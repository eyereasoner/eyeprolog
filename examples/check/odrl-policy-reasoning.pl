condition('C1', resolution, ok, 205).
condition('C2', well_founded, ok, 248).
condition('C3', justification, ok, 248).
condition('C4', coverage, ok, 327).
condition('C5', re_decision, ok, 3).
condition('C6', boundary_consistency, ok, 5).
condition('C7', relevance, ok, 282).
obligation(absent, theory_scoped, \+ positive_action_match(display, delete, A)).
obligation(absent, theory_scoped, \+ (constraint(open_use, A, B), \+ evidence(q_print, A, B))).
obligation(absent, theory_scoped, \+ (duty(open_use, A), \+ duty_done(q_print, A))).
obligation(absent, theory_scoped, \+ (constraint(share_report, A, B), \+ evidence(q_share_done, A, B))).
obligation(absent, theory_scoped, \+ (duty(share_report, A), \+ duty_done(q_share_done, A))).
obligation(absent, theory_scoped, \+ (constraint(share_report, A, B), \+ evidence(q_share_missing, A, B))).
obligation(absent, theory_scoped, \+ duty_done(q_share_missing, attribute_source)).
obligation(absent, theory_scoped, \+ (constraint(research_use, A, B), \+ evidence(q_research, A, B))).
obligation(absent, theory_scoped, \+ (duty(research_use, A), \+ duty_done(q_research, A))).
obligation(absent, theory_scoped, \+ evidence(q_commercial, purpose, research)).
obligation(absent, theory_scoped, \+ rule_scope_matches(research_use, q_unrelated)).
obligation(absent, theory_scoped, \+ (constraint(open_no_print, A, B), \+ evidence(q_print, A, B))).
obligation(absent, theory_scoped, \+ (constraint(strict_use, A, B), \+ evidence(q_print, A, B))).
obligation(absent, theory_scoped, \+ (duty(strict_use, A), \+ duty_done(q_print, A))).
obligation(absent, theory_scoped, \+ (constraint(strict_no_print, A, B), \+ evidence(q_print, A, B))).
obligation(absent, theory_scoped, \+ (constraint(invalid_use, A, B), \+ evidence(q_print, A, B))).
obligation(absent, theory_scoped, \+ (duty(invalid_use, A), \+ duty_done(q_print, A))).
obligation(absent, theory_scoped, \+ (constraint(invalid_no_print, A, B), \+ evidence(q_print, A, B))).
obligation(absent, theory_scoped, \+ policy_prohibition(duty_policy, q_share_done)).
obligation(absent, theory_scoped, \+ policy_permission(duty_policy, q_share_missing)).
obligation(absent, theory_scoped, \+ policy_prohibition(duty_policy, q_share_missing)).
obligation(absent, theory_scoped, \+ policy_permission(context_policy, q_commercial)).
obligation(absent, theory_scoped, \+ policy_prohibition(context_policy, q_commercial)).
obligation(absent, theory_scoped, \+ policy_applicable(context_policy, q_unrelated)).
obligation(absent, theory_scoped, \+ (constraint(exact_permit, A, B), constraint(exact_prohibit, A, C), B \= C)).
obligation(absent, theory_scoped, \+ (constraint(broad_permit, A, B), constraint(narrow_prohibit, A, C), B \= C)).
obligation(builtin, theory_scoped, (action_subsumes(use, print) ; action_subsumes(print, use))).
obligation(absent, theory_scoped, \+ (constraint(aggregate_permit, A, B), constraint(read_prohibit, A, C), B \= C)).
obligation(absent, theory_scoped, \+ action_subsumes(aggregate, read)).
obligation(absent, theory_scoped, \+ action_subsumes(read, aggregate)).
obligation(builtin, theory_scoped, (action_requires(aggregate, read) ; action_requires(read, aggregate))).
obligation(absent, theory_scoped, \+ action_subsumes(display, use)).
obligation(absent, theory_scoped, \+ (constraint(general_use, A, B), \+ constraint(specific_display, A, B))).
obligation(absent, theory_scoped, \+ (duty(general_use, A), \+ duty(specific_display, A))).
obligation(absent, theory_scoped, \+ rule_subsumes(specific_display, general_use)).
obligation(absent, theory_scoped, \+ (rule(A, specific_policy, B, C, D, E), \+ (rule(F, general_policy, G, H, I, J), rule_subsumes(F, A)))).
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
