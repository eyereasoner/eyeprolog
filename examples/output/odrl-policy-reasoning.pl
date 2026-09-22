% Prolog result format 4
query(1, actionQuestion(_0, _1, _2, _3), ['X0' = _0, 'X1' = _1, 'X2' = _2, 'X3' = _3]).
result(1, complete, 6).
answer(1, ['X0' = exact, 'X1' = use, 'X2' = use, 'X3' = exact]).
answer(1, ['X0' = broader, 'X1' = use, 'X2' = print, 'X3' = broader]).
answer(1, ['X0' = narrower, 'X1' = print, 'X2' = use, 'X3' = narrower]).
answer(1, ['X0' = required, 'X1' = read, 'X2' = aggregate, 'X3' = required]).
answer(1, ['X0' = requiring, 'X1' = aggregate, 'X2' = read, 'X3' = requiring]).
answer(1, ['X0' = unrelated, 'X1' = display, 'X2' = delete, 'X3' = no_match]).
query(2, ruleQuestion(_0, _1, _2, _3), ['X0' = _0, 'X1' = _1, 'X2' = _2, 'X3' = _3]).
result(2, complete, 7).
answer(2, ['X0' = unconditional, 'X1' = open_use, 'X2' = q_print, 'X3' = permission]).
answer(2, ['X0' = duty_satisfied, 'X1' = share_report, 'X2' = q_share_done, 'X3' = permission]).
answer(2,
       ['X0' = duty_missing,
        'X1' = share_report,
        'X2' = q_share_missing,
        'X3' = inactive(duty(attribute_source))]).
answer(2, ['X0' = constraint_true, 'X1' = research_use, 'X2' = q_research, 'X3' = permission]).
answer(2,
       ['X0' = constraint_false,
        'X1' = research_use,
        'X2' = q_commercial,
        'X3' = inactive(constraint(purpose))]).
answer(2, ['X0' = scope_miss, 'X1' = research_use, 'X2' = q_unrelated, 'X3' = not_applicable]).
answer(2, ['X0' = prohibition, 'X1' = open_no_print, 'X2' = q_print, 'X3' = prohibition]).
query(3,
      enforcementQuestion(_0, _1, _2, _3, _4, _5),
      ['X0' = _0, 'X1' = _1, 'X2' = _2, 'X3' = _3, 'X4' = _4, 'X5' = _5]).
result(3, complete, 9).
answer(3,
       ['X0' = permission_overrides,
        'X1' = open_printing,
        'X2' = q_print,
        'X3' = closed,
        'X4' = permission,
        'X5' = permit]).
answer(3,
       ['X0' = prohibition_overrides,
        'X1' = strict_printing,
        'X2' = q_print,
        'X3' = closed,
        'X4' = prohibition,
        'X5' = deny]).
answer(3,
       ['X0' = conflict_invalidates,
        'X1' = invalid_printing,
        'X2' = q_print,
        'X3' = closed,
        'X4' = invalid,
        'X5' = invalid]).
answer(3,
       ['X0' = duty_satisfied,
        'X1' = duty_policy,
        'X2' = q_share_done,
        'X3' = closed,
        'X4' = permission,
        'X5' = permit]).
answer(3,
       ['X0' = duty_missing,
        'X1' = duty_policy,
        'X2' = q_share_missing,
        'X3' = closed,
        'X4' = inactive,
        'X5' = deny]).
answer(3,
       ['X0' = constraint_false,
        'X1' = context_policy,
        'X2' = q_commercial,
        'X3' = closed,
        'X4' = inactive,
        'X5' = deny]).
answer(3,
       ['X0' = no_match_closed,
        'X1' = context_policy,
        'X2' = q_unrelated,
        'X3' = closed,
        'X4' = not_applicable,
        'X5' = deny]).
answer(3,
       ['X0' = no_match_open,
        'X1' = context_policy,
        'X2' = q_unrelated,
        'X3' = open,
        'X4' = not_applicable,
        'X5' = permit]).
answer(3,
       ['X0' = no_match_default,
        'X1' = context_policy,
        'X2' = q_unrelated,
        'X3' = default,
        'X4' = not_applicable,
        'X5' = deny]).
query(4,
      conflictQuestion(_0, _1, _2, _3, _4),
      ['X0' = _0, 'X1' = _1, 'X2' = _2, 'X3' = _3, 'X4' = _4]).
result(4, complete, 3).
answer(4,
       ['X0' = exact,
        'X1' = analysis_policy,
        'X2' = exact_permit,
        'X3' = exact_prohibit,
        'X4' = exact]).
answer(4,
       ['X0' = subsumption,
        'X1' = analysis_policy,
        'X2' = broad_permit,
        'X3' = narrow_prohibit,
        'X4' = subsumption]).
answer(4,
       ['X0' = dependency,
        'X1' = analysis_policy,
        'X2' = aggregate_permit,
        'X3' = read_prohibit,
        'X4' = dependency]).
query(5, subsumptionQuestion(_0, _1, _2, _3), ['X0' = _0, 'X1' = _1, 'X2' = _2, 'X3' = _3]).
result(5, complete, 6).
answer(5, ['X0' = action_yes, 'X1' = use, 'X2' = display, 'X3' = yes]).
answer(5, ['X0' = action_no, 'X1' = display, 'X2' = use, 'X3' = no]).
answer(5, ['X0' = rule_yes, 'X1' = general_use, 'X2' = specific_display, 'X3' = yes]).
answer(5, ['X0' = rule_no, 'X1' = specific_display, 'X2' = general_use, 'X3' = no]).
answer(5, ['X0' = policy_yes, 'X1' = general_policy, 'X2' = specific_policy, 'X3' = yes]).
answer(5, ['X0' = policy_no, 'X1' = specific_policy, 'X2' = general_policy, 'X3' = no]).
query(6, wfsQuestion(_0, _1), ['X0' = _0, 'X1' = _1]).
result(6, complete, 3).
answer(6, ['X0' = clear_permission, 'X1' = true]).
answer(6, ['X0' = absent_permission, 'X1' = false]).
answer(6, ['X0' = negative_cycle, 'X1' = undefined]).
