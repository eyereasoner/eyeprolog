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

clause(1, action(use), true).
clause(3, action(display), true).
clause(5, action(print), true).
clause(6, action(distribute), true).
clause(11, action(delete), true).
clause(12, broader(use, present), true).
clause(13, broader(present, display), true).
clause(15, broader(use, print), true).
clause(18, requires(aggregate, read), true).
clause(21,
       action_subsumes(var('Broader'), var('Narrower')),
       broader(var('Broader'), var('Narrower'))).
clause(22,
       action_subsumes(var('Broader'), var('Narrower')),
       (broader(var('Broader'), var('Middle')), action_subsumes(var('Middle'), var('Narrower')))).
clause(23,
       action_requires(var('Action'), var('Required')),
       requires(var('Action'), var('Required'))).
clause(25, positive_action_match(var('Action'), var('Action'), exact), action(var('Action'))).
clause(26,
       positive_action_match(var('RuleAction'), var('RequestAction'), broader),
       (var('RuleAction') \= var('RequestAction'),
        action_subsumes(var('RuleAction'), var('RequestAction')))).
clause(27,
       positive_action_match(var('RuleAction'), var('RequestAction'), narrower),
       (var('RuleAction') \= var('RequestAction'),
        action_subsumes(var('RequestAction'), var('RuleAction')))).
clause(28,
       positive_action_match(var('RuleAction'), var('RequestAction'), required),
       action_requires(var('RequestAction'), var('RuleAction'))).
clause(29,
       positive_action_match(var('RuleAction'), var('RequestAction'), requiring),
       action_requires(var('RuleAction'), var('RequestAction'))).
clause(30,
       action_match(var('RuleAction'), var('RequestAction'), var('Kind')),
       positive_action_match(var('RuleAction'), var('RequestAction'), var('Kind'))).
clause(31,
       action_match(var('RuleAction'), var('RequestAction'), no_match),
       (action(var('RuleAction')),
        action(var('RequestAction')),
        \+ positive_action_match(var('RuleAction'), var('RequestAction'), anonymous(1)))).
clause(32, party(alice), true).
clause(36, member_of(alice, analysts), true).
clause(38, party_subsumes(var('Party'), var('Party')), party(var('Party'))).
clause(39, party_subsumes(var('Group'), var('Person')), member_of(var('Person'), var('Group'))).
clause(41, asset(report_q1), true).
clause(44, asset(dataset_a), true).
clause(45, asset(dataset_b), true).
clause(46, asset(dataset_c), true).
clause(47, asset_member(report_q1, reports), true).
clause(49, asset_subsumes(var('Asset'), var('Asset')), asset(var('Asset'))).
clause(50,
       asset_subsumes(var('Collection'), var('Item')),
       asset_member(var('Item'), var('Collection'))).
clause(51, policy(open_printing, perm), true).
clause(52, policy(strict_printing, prohibit), true).
clause(53, policy(invalid_printing, invalid), true).
clause(55, policy(context_policy, invalid), true).
clause(57, policy(general_policy, invalid), true).
clause(58, policy(specific_policy, invalid), true).
clause(59, permission(open_printing, open_use, analysts, use, reports), true).
clause(60, prohibition(open_printing, open_no_print, alice, print, report_q1), true).
clause(61, permission(strict_printing, strict_use, analysts, use, reports), true).
clause(62, prohibition(strict_printing, strict_no_print, alice, print, report_q1), true).
clause(63, permission(invalid_printing, invalid_use, analysts, use, reports), true).
clause(64, prohibition(invalid_printing, invalid_no_print, alice, print, report_q1), true).
clause(65, permission(duty_policy, share_report, alice, distribute, report_q1), true).
clause(66, duty(share_report, attribute_source), true).
clause(67, permission(context_policy, research_use, analysts, use, reports), true).
clause(68, constraint(research_use, purpose, research), true).
clause(69, permission(analysis_policy, exact_permit, alice, display, dataset_a), true).
clause(70, prohibition(analysis_policy, exact_prohibit, alice, display, dataset_a), true).
clause(71, permission(analysis_policy, broad_permit, alice, use, dataset_b), true).
clause(72, prohibition(analysis_policy, narrow_prohibit, alice, print, dataset_b), true).
clause(73, permission(analysis_policy, aggregate_permit, alice, aggregate, dataset_c), true).
clause(74, prohibition(analysis_policy, read_prohibit, alice, read, dataset_c), true).
clause(75, permission(general_policy, general_use, analysts, use, reports), true).
clause(76, permission(specific_policy, specific_display, alice, display, report_q1), true).
clause(78, request(q_print, alice, print, report_q1), true).
clause(79, request(q_share_done, alice, distribute, report_q1), true).
clause(80, request(q_share_missing, alice, distribute, report_q1), true).
clause(81, request(q_research, alice, display, report_q1), true).
clause(82, request(q_commercial, alice, display, report_q1), true).
clause(87,
       rule(var('Rule'), var('Policy'), permission, var('Party'), var('Action'), var('Target')),
       permission(var('Policy'), var('Rule'), var('Party'), var('Action'), var('Target'))).
clause(88,
       rule(var('Rule'), var('Policy'), prohibition, var('Party'), var('Action'), var('Target')),
       prohibition(var('Policy'), var('Rule'), var('Party'), var('Action'), var('Target'))).
clause(89,
       rule_scope_matches(var('Rule'), var('Request')),
       (rule(var('Rule'), anonymous(1), anonymous(2), var('RuleParty'), var('RuleAction'), var('RuleTarget')),
        request(var('Request'), var('Party'), var('Action'), var('Target')),
        party_subsumes(var('RuleParty'), var('Party')),
        asset_subsumes(var('RuleTarget'), var('Target')),
        positive_action_match(var('RuleAction'), var('Action'), anonymous(3)))).
clause(90,
       constraints_hold(var('Rule'), var('Request')),
       \+ (constraint(var('Rule'), var('Key'), var('Value')), \+ evidence(var('Request'), var('Key'), var('Value')))).
clause(91,
       duties_hold(var('Rule'), var('Request')),
       \+ (duty(var('Rule'), var('Duty')), \+ duty_done(var('Request'), var('Duty')))).
clause(92,
       permission_result(var('Rule'), var('Request'), permission),
       (permission(anonymous(1), var('Rule'), anonymous(2), anonymous(3), anonymous(4)),
        rule_scope_matches(var('Rule'), var('Request')),
        constraints_hold(var('Rule'), var('Request')),
        duties_hold(var('Rule'), var('Request')))).
clause(93,
       permission_result(var('Rule'), var('Request'), inactive(constraint(var('Key')))),
       (permission(anonymous(1), var('Rule'), anonymous(2), anonymous(3), anonymous(4)),
        rule_scope_matches(var('Rule'), var('Request')),
        constraint(var('Rule'), var('Key'), var('Value')),
        \+ evidence(var('Request'), var('Key'), var('Value')))).
clause(94,
       permission_result(var('Rule'), var('Request'), inactive(duty(var('Duty')))),
       (permission(anonymous(1), var('Rule'), anonymous(2), anonymous(3), anonymous(4)),
        rule_scope_matches(var('Rule'), var('Request')),
        constraints_hold(var('Rule'), var('Request')),
        duty(var('Rule'), var('Duty')),
        \+ duty_done(var('Request'), var('Duty')))).
clause(95,
       permission_result(var('Rule'), var('Request'), not_applicable),
       (permission(anonymous(1), var('Rule'), anonymous(2), anonymous(3), anonymous(4)),
        \+ rule_scope_matches(var('Rule'), var('Request')))).
clause(96,
       prohibition_result(var('Rule'), var('Request'), prohibition),
       (prohibition(anonymous(1), var('Rule'), anonymous(2), anonymous(3), anonymous(4)),
        rule_scope_matches(var('Rule'), var('Request')),
        constraints_hold(var('Rule'), var('Request')))).
clause(99,
       rule_result(var('Rule'), var('Request'), var('Result')),
       permission_result(var('Rule'), var('Request'), var('Result'))).
clause(100,
       rule_result(var('Rule'), var('Request'), var('Result')),
       prohibition_result(var('Rule'), var('Request'), var('Result'))).
clause(101,
       policy_permission(var('Policy'), var('Request')),
       (permission(var('Policy'), var('Rule'), anonymous(1), anonymous(2), anonymous(3)),
        permission_result(var('Rule'), var('Request'), permission))).
clause(102,
       policy_prohibition(var('Policy'), var('Request')),
       (prohibition(var('Policy'), var('Rule'), anonymous(1), anonymous(2), anonymous(3)),
        prohibition_result(var('Rule'), var('Request'), prohibition))).
clause(103,
       policy_inactive(var('Policy'), var('Request')),
       (rule(var('Rule'), var('Policy'), anonymous(1), anonymous(2), anonymous(3), anonymous(4)),
        rule_result(var('Rule'), var('Request'), inactive(anonymous(5))))).
clause(105,
       policy_result(var('Policy'), var('Request'), permission),
       (policy_permission(var('Policy'), var('Request')),
        policy_prohibition(var('Policy'), var('Request')),
        policy(var('Policy'), perm))).
clause(106,
       policy_result(var('Policy'), var('Request'), prohibition),
       (policy_permission(var('Policy'), var('Request')),
        policy_prohibition(var('Policy'), var('Request')),
        policy(var('Policy'), prohibit))).
clause(107,
       policy_result(var('Policy'), var('Request'), invalid),
       (policy_permission(var('Policy'), var('Request')),
        policy_prohibition(var('Policy'), var('Request')),
        policy(var('Policy'), invalid))).
clause(108,
       policy_result(var('Policy'), var('Request'), permission),
       (policy_permission(var('Policy'), var('Request')),
        \+ policy_prohibition(var('Policy'), var('Request')))).
clause(110,
       policy_result(var('Policy'), var('Request'), inactive),
       (\+ policy_permission(var('Policy'), var('Request')),
        \+ policy_prohibition(var('Policy'), var('Request')),
        policy_inactive(var('Policy'), var('Request')))).
clause(111,
       policy_result(var('Policy'), var('Request'), not_applicable),
       (policy(var('Policy'), anonymous(1)),
        \+ policy_applicable(var('Policy'), var('Request')))).
clause(112,
       access_decision(var('Policy'), var('Request'), anonymous(1), permit),
       policy_result(var('Policy'), var('Request'), permission)).
clause(113,
       access_decision(var('Policy'), var('Request'), anonymous(1), deny),
       policy_result(var('Policy'), var('Request'), prohibition)).
clause(114,
       access_decision(var('Policy'), var('Request'), anonymous(1), invalid),
       policy_result(var('Policy'), var('Request'), invalid)).
clause(115,
       access_decision(var('Policy'), var('Request'), anonymous(1), deny),
       policy_result(var('Policy'), var('Request'), inactive)).
clause(116,
       access_decision(var('Policy'), var('Request'), open, permit),
       policy_result(var('Policy'), var('Request'), not_applicable)).
clause(117,
       access_decision(var('Policy'), var('Request'), closed, deny),
       policy_result(var('Policy'), var('Request'), not_applicable)).
clause(118,
       access_decision(var('Policy'), var('Request'), default, deny),
       policy_result(var('Policy'), var('Request'), not_applicable)).
clause(119, opposite(permission, prohibition), true).
clause(121, parties_overlap(var('A'), var('B')), party_subsumes(var('A'), var('B'))).
clause(123, assets_overlap(var('A'), var('B')), asset_subsumes(var('A'), var('B'))).
clause(125,
       constraints_compatible(var('RuleA'), var('RuleB')),
       \+ (constraint(var('RuleA'), var('Key'), var('A')), constraint(var('RuleB'), var('Key'), var('B')), var('A') \= var('B'))).
clause(126, conflicting_action(var('Action'), var('Action'), exact), action(var('Action'))).
clause(127,
       conflicting_action(var('ActionA'), var('ActionB'), subsumption),
       (var('ActionA') \= var('ActionB'),
        (action_subsumes(var('ActionA'), var('ActionB')) ; action_subsumes(var('ActionB'), var('ActionA'))))).
clause(128,
       conflicting_action(var('ActionA'), var('ActionB'), dependency),
       (\+ action_subsumes(var('ActionA'), var('ActionB')),
        \+ action_subsumes(var('ActionB'), var('ActionA')),
        (action_requires(var('ActionA'), var('ActionB')) ; action_requires(var('ActionB'), var('ActionA'))))).
clause(129,
       rule_conflict(var('RuleA'), var('RuleB'), var('Kind')),
       (rule(var('RuleA'), anonymous(1), var('EffectA'), var('PartyA'), var('ActionA'), var('TargetA')),
        rule(var('RuleB'), anonymous(2), var('EffectB'), var('PartyB'), var('ActionB'), var('TargetB')),
        opposite(var('EffectA'), var('EffectB')),
        parties_overlap(var('PartyA'), var('PartyB')),
        assets_overlap(var('TargetA'), var('TargetB')),
        constraints_compatible(var('RuleA'), var('RuleB')),
        conflicting_action(var('ActionA'), var('ActionB'), var('Kind')))).
clause(130,
       constraints_subsume(var('General'), var('Specific')),
       \+ (constraint(var('General'), var('Key'), var('Value')), \+ constraint(var('Specific'), var('Key'), var('Value')))).
clause(131,
       duties_subsume(var('General'), var('Specific')),
       \+ (duty(var('General'), var('Duty')), \+ duty(var('Specific'), var('Duty')))).
clause(132,
       rule_subsumes(var('General'), var('Specific')),
       (rule(var('General'), anonymous(1), var('Effect'), var('GeneralParty'), var('GeneralAction'), var('GeneralTarget')),
        rule(var('Specific'), anonymous(2), var('Effect'), var('SpecificParty'), var('SpecificAction'), var('SpecificTarget')),
        party_subsumes(var('GeneralParty'), var('SpecificParty')),
        action_subsumes(var('GeneralAction'), var('SpecificAction')),
        asset_subsumes(var('GeneralTarget'), var('SpecificTarget')),
        constraints_subsume(var('General'), var('Specific')),
        duties_subsume(var('General'), var('Specific')))).
clause(133,
       policy_subsumes(var('General'), var('Specific')),
       (policy(var('General'), anonymous(1)),
        policy(var('Specific'), anonymous(2)),
        \+ (rule(var('SpecificRule'), var('Specific'), anonymous(3), anonymous(4), anonymous(5), anonymous(6)), \+ (rule(var('GeneralRule'), var('General'), anonymous(7), anonymous(8), anonymous(9), anonymous(10)), rule_subsumes(var('GeneralRule'), var('SpecificRule')))))).
clause(142, actionQuestion(exact, use, use, var('Kind')), action_match(use, use, var('Kind'))).
clause(143,
       actionQuestion(broader, use, print, var('Kind')),
       action_match(use, print, var('Kind'))).
clause(144,
       actionQuestion(narrower, print, use, var('Kind')),
       action_match(print, use, var('Kind'))).
clause(145,
       actionQuestion(required, read, aggregate, var('Kind')),
       action_match(read, aggregate, var('Kind'))).
clause(146,
       actionQuestion(requiring, aggregate, read, var('Kind')),
       action_match(aggregate, read, var('Kind'))).
clause(147,
       actionQuestion(unrelated, display, delete, var('Kind')),
       action_match(display, delete, var('Kind'))).
clause(148,
       ruleQuestion(unconditional, open_use, q_print, var('Result')),
       rule_result(open_use, q_print, var('Result'))).
clause(149,
       ruleQuestion(duty_satisfied, share_report, q_share_done, var('Result')),
       rule_result(share_report, q_share_done, var('Result'))).
clause(150,
       ruleQuestion(duty_missing, share_report, q_share_missing, var('Result')),
       rule_result(share_report, q_share_missing, var('Result'))).
clause(151,
       ruleQuestion(constraint_true, research_use, q_research, var('Result')),
       rule_result(research_use, q_research, var('Result'))).
clause(152,
       ruleQuestion(constraint_false, research_use, q_commercial, var('Result')),
       rule_result(research_use, q_commercial, var('Result'))).
clause(153,
       ruleQuestion(scope_miss, research_use, q_unrelated, var('Result')),
       rule_result(research_use, q_unrelated, var('Result'))).
clause(154,
       ruleQuestion(prohibition, open_no_print, q_print, var('Result')),
       rule_result(open_no_print, q_print, var('Result'))).
clause(155,
       enforcementQuestion(permission_overrides, open_printing, q_print, closed, var('Result'), var('Decision')),
       (policy_result(open_printing, q_print, var('Result')),
        access_decision(open_printing, q_print, closed, var('Decision')))).
clause(156,
       enforcementQuestion(prohibition_overrides, strict_printing, q_print, closed, var('Result'), var('Decision')),
       (policy_result(strict_printing, q_print, var('Result')),
        access_decision(strict_printing, q_print, closed, var('Decision')))).
clause(157,
       enforcementQuestion(conflict_invalidates, invalid_printing, q_print, closed, var('Result'), var('Decision')),
       (policy_result(invalid_printing, q_print, var('Result')),
        access_decision(invalid_printing, q_print, closed, var('Decision')))).
clause(158,
       enforcementQuestion(duty_satisfied, duty_policy, q_share_done, closed, var('Result'), var('Decision')),
       (policy_result(duty_policy, q_share_done, var('Result')),
        access_decision(duty_policy, q_share_done, closed, var('Decision')))).
clause(159,
       enforcementQuestion(duty_missing, duty_policy, q_share_missing, closed, var('Result'), var('Decision')),
       (policy_result(duty_policy, q_share_missing, var('Result')),
        access_decision(duty_policy, q_share_missing, closed, var('Decision')))).
clause(160,
       enforcementQuestion(constraint_false, context_policy, q_commercial, closed, var('Result'), var('Decision')),
       (policy_result(context_policy, q_commercial, var('Result')),
        access_decision(context_policy, q_commercial, closed, var('Decision')))).
clause(161,
       enforcementQuestion(no_match_closed, context_policy, q_unrelated, closed, var('Result'), var('Decision')),
       (policy_result(context_policy, q_unrelated, var('Result')),
        access_decision(context_policy, q_unrelated, closed, var('Decision')))).
clause(162,
       enforcementQuestion(no_match_open, context_policy, q_unrelated, open, var('Result'), var('Decision')),
       (policy_result(context_policy, q_unrelated, var('Result')),
        access_decision(context_policy, q_unrelated, open, var('Decision')))).
clause(163,
       enforcementQuestion(no_match_default, context_policy, q_unrelated, default, var('Result'), var('Decision')),
       (policy_result(context_policy, q_unrelated, var('Result')),
        access_decision(context_policy, q_unrelated, default, var('Decision')))).
clause(164,
       conflictQuestion(exact, analysis_policy, exact_permit, exact_prohibit, var('Kind')),
       rule_conflict(exact_permit, exact_prohibit, var('Kind'))).
clause(165,
       conflictQuestion(subsumption, analysis_policy, broad_permit, narrow_prohibit, var('Kind')),
       rule_conflict(broad_permit, narrow_prohibit, var('Kind'))).
clause(166,
       conflictQuestion(dependency, analysis_policy, aggregate_permit, read_prohibit, var('Kind')),
       rule_conflict(aggregate_permit, read_prohibit, var('Kind'))).
clause(167, subsumptionQuestion(action_yes, use, display, yes), action_subsumes(use, display)).
clause(168, subsumptionQuestion(action_no, display, use, no), \+ action_subsumes(display, use)).
clause(169,
       subsumptionQuestion(rule_yes, general_use, specific_display, yes),
       rule_subsumes(general_use, specific_display)).
clause(170,
       subsumptionQuestion(rule_no, specific_display, general_use, no),
       \+ rule_subsumes(specific_display, general_use)).
clause(171,
       subsumptionQuestion(policy_yes, general_policy, specific_policy, yes),
       policy_subsumes(general_policy, specific_policy)).
clause(172,
       subsumptionQuestion(policy_no, specific_policy, general_policy, no),
       \+ policy_subsumes(specific_policy, general_policy)).
clause(173,
       wfsQuestion(clear_permission, var('State')),
       wfs_truth(profile_permission(clear), var('State'))).
clause(174,
       wfsQuestion(absent_permission, var('State')),
       wfs_truth(profile_permission(denied), var('State'))).
clause(175,
       wfsQuestion(negative_cycle, var('State')),
       wfs_truth(profile_permission(cycle), var('State'))).

step(actionQuestion(exact, use, use, exact),
     rule(142),
     ['Kind' = exact],
     [action_match(use, use, exact)]).
step(action_match(use, use, exact),
     rule(30),
     ['RuleAction' = use, 'RequestAction' = use, 'Kind' = exact],
     [positive_action_match(use, use, exact)]).
step(positive_action_match(use, use, exact), rule(25), ['Action' = use], [action(use)]).
step(action(use), fact(1), [], []).
step(actionQuestion(broader, use, print, broader),
     rule(143),
     ['Kind' = broader],
     [action_match(use, print, broader)]).
step(action_match(use, print, broader),
     rule(30),
     ['RuleAction' = use, 'RequestAction' = print, 'Kind' = broader],
     [positive_action_match(use, print, broader)]).
step(positive_action_match(use, print, broader),
     rule(26),
     ['RuleAction' = use, 'RequestAction' = print],
     [use \= print, action_subsumes(use, print)]).
step(use \= print, builtin, [], []).
step(action_subsumes(use, print),
     rule(21),
     ['Broader' = use, 'Narrower' = print],
     [broader(use, print)]).
step(broader(use, print), fact(15), [], []).
step(actionQuestion(narrower, print, use, narrower),
     rule(144),
     ['Kind' = narrower],
     [action_match(print, use, narrower)]).
step(action_match(print, use, narrower),
     rule(30),
     ['RuleAction' = print, 'RequestAction' = use, 'Kind' = narrower],
     [positive_action_match(print, use, narrower)]).
step(positive_action_match(print, use, narrower),
     rule(27),
     ['RuleAction' = print, 'RequestAction' = use],
     [print \= use, action_subsumes(use, print)]).
step(print \= use, builtin, [], []).
step(actionQuestion(required, read, aggregate, required),
     rule(145),
     ['Kind' = required],
     [action_match(read, aggregate, required)]).
step(action_match(read, aggregate, required),
     rule(30),
     ['RuleAction' = read, 'RequestAction' = aggregate, 'Kind' = required],
     [positive_action_match(read, aggregate, required)]).
step(positive_action_match(read, aggregate, required),
     rule(28),
     ['RuleAction' = read, 'RequestAction' = aggregate],
     [action_requires(aggregate, read)]).
step(action_requires(aggregate, read),
     rule(23),
     ['Action' = aggregate, 'Required' = read],
     [requires(aggregate, read)]).
step(requires(aggregate, read), fact(18), [], []).
step(actionQuestion(requiring, aggregate, read, requiring),
     rule(146),
     ['Kind' = requiring],
     [action_match(aggregate, read, requiring)]).
step(action_match(aggregate, read, requiring),
     rule(30),
     ['RuleAction' = aggregate, 'RequestAction' = read, 'Kind' = requiring],
     [positive_action_match(aggregate, read, requiring)]).
step(positive_action_match(aggregate, read, requiring),
     rule(29),
     ['RuleAction' = aggregate, 'RequestAction' = read],
     [action_requires(aggregate, read)]).
step(actionQuestion(unrelated, display, delete, no_match),
     rule(147),
     ['Kind' = no_match],
     [action_match(display, delete, no_match)]).
step(action_match(display, delete, no_match),
     rule(31),
     ['RuleAction' = display, 'RequestAction' = delete],
     [action(display), action(delete), \+ positive_action_match(display, delete, __anon0)]).
step(action(display), fact(3), [], []).
step(action(delete), fact(11), [], []).
step(\+ positive_action_match(display, delete, __anon0), absent, [], []).
step(ruleQuestion(unconditional, open_use, q_print, permission),
     rule(148),
     ['Result' = permission],
     [rule_result(open_use, q_print, permission)]).
step(rule_result(open_use, q_print, permission),
     rule(99),
     ['Rule' = open_use, 'Request' = q_print, 'Result' = permission],
     [permission_result(open_use, q_print, permission)]).
step(permission_result(open_use, q_print, permission),
     rule(92),
     ['Rule' = open_use, 'Request' = q_print],
     [permission(open_printing, open_use, analysts, use, reports),
      rule_scope_matches(open_use, q_print),
      constraints_hold(open_use, q_print),
      duties_hold(open_use, q_print)]).
step(permission(open_printing, open_use, analysts, use, reports), fact(59), [], []).
step(rule_scope_matches(open_use, q_print),
     rule(89),
     ['Rule' = open_use,
      'Request' = q_print,
      'RuleParty' = analysts,
      'RuleAction' = use,
      'RuleTarget' = reports,
      'Party' = alice,
      'Action' = print,
      'Target' = report_q1],
     [rule(open_use, open_printing, permission, analysts, use, reports),
      request(q_print, alice, print, report_q1),
      party_subsumes(analysts, alice),
      asset_subsumes(reports, report_q1),
      positive_action_match(use, print, broader)]).
step(rule(open_use, open_printing, permission, analysts, use, reports),
     rule(87),
     ['Rule' = open_use,
      'Policy' = open_printing,
      'Party' = analysts,
      'Action' = use,
      'Target' = reports],
     [permission(open_printing, open_use, analysts, use, reports)]).
step(request(q_print, alice, print, report_q1), fact(78), [], []).
step(party_subsumes(analysts, alice),
     rule(39),
     ['Group' = analysts, 'Person' = alice],
     [member_of(alice, analysts)]).
step(member_of(alice, analysts), fact(36), [], []).
step(asset_subsumes(reports, report_q1),
     rule(50),
     ['Collection' = reports, 'Item' = report_q1],
     [asset_member(report_q1, reports)]).
step(asset_member(report_q1, reports), fact(47), [], []).
step(constraints_hold(open_use, q_print),
     rule(90),
     ['Rule' = open_use, 'Request' = q_print],
     [\+ (constraint(open_use, Key, Value), \+ evidence(q_print, Key, Value))]).
step(\+ (constraint(open_use, Key, Value), \+ evidence(q_print, Key, Value)), absent, [], []).
step(duties_hold(open_use, q_print),
     rule(91),
     ['Rule' = open_use, 'Request' = q_print],
     [\+ (duty(open_use, Duty), \+ duty_done(q_print, Duty))]).
step(\+ (duty(open_use, Duty), \+ duty_done(q_print, Duty)), absent, [], []).
step(ruleQuestion(duty_satisfied, share_report, q_share_done, permission),
     rule(149),
     ['Result' = permission],
     [rule_result(share_report, q_share_done, permission)]).
step(rule_result(share_report, q_share_done, permission),
     rule(99),
     ['Rule' = share_report, 'Request' = q_share_done, 'Result' = permission],
     [permission_result(share_report, q_share_done, permission)]).
step(permission_result(share_report, q_share_done, permission),
     rule(92),
     ['Rule' = share_report, 'Request' = q_share_done],
     [permission(duty_policy, share_report, alice, distribute, report_q1),
      rule_scope_matches(share_report, q_share_done),
      constraints_hold(share_report, q_share_done),
      duties_hold(share_report, q_share_done)]).
step(permission(duty_policy, share_report, alice, distribute, report_q1), fact(65), [], []).
step(rule_scope_matches(share_report, q_share_done),
     rule(89),
     ['Rule' = share_report,
      'Request' = q_share_done,
      'RuleParty' = alice,
      'RuleAction' = distribute,
      'RuleTarget' = report_q1,
      'Party' = alice,
      'Action' = distribute,
      'Target' = report_q1],
     [rule(share_report, duty_policy, permission, alice, distribute, report_q1),
      request(q_share_done, alice, distribute, report_q1),
      party_subsumes(alice, alice),
      asset_subsumes(report_q1, report_q1),
      positive_action_match(distribute, distribute, exact)]).
step(rule(share_report, duty_policy, permission, alice, distribute, report_q1),
     rule(87),
     ['Rule' = share_report,
      'Policy' = duty_policy,
      'Party' = alice,
      'Action' = distribute,
      'Target' = report_q1],
     [permission(duty_policy, share_report, alice, distribute, report_q1)]).
step(request(q_share_done, alice, distribute, report_q1), fact(79), [], []).
step(party_subsumes(alice, alice), rule(38), ['Party' = alice], [party(alice)]).
step(party(alice), fact(32), [], []).
step(asset_subsumes(report_q1, report_q1), rule(49), ['Asset' = report_q1], [asset(report_q1)]).
step(asset(report_q1), fact(41), [], []).
step(positive_action_match(distribute, distribute, exact),
     rule(25),
     ['Action' = distribute],
     [action(distribute)]).
step(action(distribute), fact(6), [], []).
step(constraints_hold(share_report, q_share_done),
     rule(90),
     ['Rule' = share_report, 'Request' = q_share_done],
     [\+ (constraint(share_report, Key, Value), \+ evidence(q_share_done, Key, Value))]).
step(\+ (constraint(share_report, Key, Value), \+ evidence(q_share_done, Key, Value)),
     absent,
     [],
     []).
step(duties_hold(share_report, q_share_done),
     rule(91),
     ['Rule' = share_report, 'Request' = q_share_done],
     [\+ (duty(share_report, Duty), \+ duty_done(q_share_done, Duty))]).
step(\+ (duty(share_report, Duty), \+ duty_done(q_share_done, Duty)), absent, [], []).
step(ruleQuestion(duty_missing, share_report, q_share_missing, inactive(duty(attribute_source))),
     rule(150),
     ['Result' = inactive(duty(attribute_source))],
     [rule_result(share_report, q_share_missing, inactive(duty(attribute_source)))]).
step(rule_result(share_report, q_share_missing, inactive(duty(attribute_source))),
     rule(99),
     ['Rule' = share_report,
      'Request' = q_share_missing,
      'Result' = inactive(duty(attribute_source))],
     [permission_result(share_report, q_share_missing, inactive(duty(attribute_source)))]).
step(permission_result(share_report, q_share_missing, inactive(duty(attribute_source))),
     rule(94),
     ['Rule' = share_report, 'Request' = q_share_missing, 'Duty' = attribute_source],
     [permission(duty_policy, share_report, alice, distribute, report_q1),
      rule_scope_matches(share_report, q_share_missing),
      constraints_hold(share_report, q_share_missing),
      duty(share_report, attribute_source),
      \+ duty_done(q_share_missing, attribute_source)]).
step(rule_scope_matches(share_report, q_share_missing),
     rule(89),
     ['Rule' = share_report,
      'Request' = q_share_missing,
      'RuleParty' = alice,
      'RuleAction' = distribute,
      'RuleTarget' = report_q1,
      'Party' = alice,
      'Action' = distribute,
      'Target' = report_q1],
     [rule(share_report, duty_policy, permission, alice, distribute, report_q1),
      request(q_share_missing, alice, distribute, report_q1),
      party_subsumes(alice, alice),
      asset_subsumes(report_q1, report_q1),
      positive_action_match(distribute, distribute, exact)]).
step(request(q_share_missing, alice, distribute, report_q1), fact(80), [], []).
step(constraints_hold(share_report, q_share_missing),
     rule(90),
     ['Rule' = share_report, 'Request' = q_share_missing],
     [\+ (constraint(share_report, Key, Value), \+ evidence(q_share_missing, Key, Value))]).
step(\+ (constraint(share_report, Key, Value), \+ evidence(q_share_missing, Key, Value)),
     absent,
     [],
     []).
step(duty(share_report, attribute_source), fact(66), [], []).
step(\+ duty_done(q_share_missing, attribute_source), absent, [], []).
step(ruleQuestion(constraint_true, research_use, q_research, permission),
     rule(151),
     ['Result' = permission],
     [rule_result(research_use, q_research, permission)]).
step(rule_result(research_use, q_research, permission),
     rule(99),
     ['Rule' = research_use, 'Request' = q_research, 'Result' = permission],
     [permission_result(research_use, q_research, permission)]).
step(permission_result(research_use, q_research, permission),
     rule(92),
     ['Rule' = research_use, 'Request' = q_research],
     [permission(context_policy, research_use, analysts, use, reports),
      rule_scope_matches(research_use, q_research),
      constraints_hold(research_use, q_research),
      duties_hold(research_use, q_research)]).
step(permission(context_policy, research_use, analysts, use, reports), fact(67), [], []).
step(rule_scope_matches(research_use, q_research),
     rule(89),
     ['Rule' = research_use,
      'Request' = q_research,
      'RuleParty' = analysts,
      'RuleAction' = use,
      'RuleTarget' = reports,
      'Party' = alice,
      'Action' = display,
      'Target' = report_q1],
     [rule(research_use, context_policy, permission, analysts, use, reports),
      request(q_research, alice, display, report_q1),
      party_subsumes(analysts, alice),
      asset_subsumes(reports, report_q1),
      positive_action_match(use, display, broader)]).
step(rule(research_use, context_policy, permission, analysts, use, reports),
     rule(87),
     ['Rule' = research_use,
      'Policy' = context_policy,
      'Party' = analysts,
      'Action' = use,
      'Target' = reports],
     [permission(context_policy, research_use, analysts, use, reports)]).
step(request(q_research, alice, display, report_q1), fact(81), [], []).
step(positive_action_match(use, display, broader),
     rule(26),
     ['RuleAction' = use, 'RequestAction' = display],
     [use \= display, action_subsumes(use, display)]).
step(use \= display, builtin, [], []).
step(action_subsumes(use, display),
     rule(22),
     ['Broader' = use, 'Narrower' = display, 'Middle' = present],
     [broader(use, present), action_subsumes(present, display)]).
step(broader(use, present), fact(12), [], []).
step(action_subsumes(present, display),
     rule(21),
     ['Broader' = present, 'Narrower' = display],
     [broader(present, display)]).
step(broader(present, display), fact(13), [], []).
step(constraints_hold(research_use, q_research),
     rule(90),
     ['Rule' = research_use, 'Request' = q_research],
     [\+ (constraint(research_use, Key, Value), \+ evidence(q_research, Key, Value))]).
step(\+ (constraint(research_use, Key, Value), \+ evidence(q_research, Key, Value)),
     absent,
     [],
     []).
step(duties_hold(research_use, q_research),
     rule(91),
     ['Rule' = research_use, 'Request' = q_research],
     [\+ (duty(research_use, Duty), \+ duty_done(q_research, Duty))]).
step(\+ (duty(research_use, Duty), \+ duty_done(q_research, Duty)), absent, [], []).
step(ruleQuestion(constraint_false, research_use, q_commercial, inactive(constraint(purpose))),
     rule(152),
     ['Result' = inactive(constraint(purpose))],
     [rule_result(research_use, q_commercial, inactive(constraint(purpose)))]).
step(rule_result(research_use, q_commercial, inactive(constraint(purpose))),
     rule(99),
     ['Rule' = research_use, 'Request' = q_commercial, 'Result' = inactive(constraint(purpose))],
     [permission_result(research_use, q_commercial, inactive(constraint(purpose)))]).
step(permission_result(research_use, q_commercial, inactive(constraint(purpose))),
     rule(93),
     ['Rule' = research_use, 'Request' = q_commercial, 'Key' = purpose, 'Value' = research],
     [permission(context_policy, research_use, analysts, use, reports),
      rule_scope_matches(research_use, q_commercial),
      constraint(research_use, purpose, research),
      \+ evidence(q_commercial, purpose, research)]).
step(rule_scope_matches(research_use, q_commercial),
     rule(89),
     ['Rule' = research_use,
      'Request' = q_commercial,
      'RuleParty' = analysts,
      'RuleAction' = use,
      'RuleTarget' = reports,
      'Party' = alice,
      'Action' = display,
      'Target' = report_q1],
     [rule(research_use, context_policy, permission, analysts, use, reports),
      request(q_commercial, alice, display, report_q1),
      party_subsumes(analysts, alice),
      asset_subsumes(reports, report_q1),
      positive_action_match(use, display, broader)]).
step(request(q_commercial, alice, display, report_q1), fact(82), [], []).
step(constraint(research_use, purpose, research), fact(68), [], []).
step(\+ evidence(q_commercial, purpose, research), absent, [], []).
step(ruleQuestion(scope_miss, research_use, q_unrelated, not_applicable),
     rule(153),
     ['Result' = not_applicable],
     [rule_result(research_use, q_unrelated, not_applicable)]).
step(rule_result(research_use, q_unrelated, not_applicable),
     rule(99),
     ['Rule' = research_use, 'Request' = q_unrelated, 'Result' = not_applicable],
     [permission_result(research_use, q_unrelated, not_applicable)]).
step(permission_result(research_use, q_unrelated, not_applicable),
     rule(95),
     ['Rule' = research_use, 'Request' = q_unrelated],
     [permission(context_policy, research_use, analysts, use, reports),
      \+ rule_scope_matches(research_use, q_unrelated)]).
step(\+ rule_scope_matches(research_use, q_unrelated), absent, [], []).
step(ruleQuestion(prohibition, open_no_print, q_print, prohibition),
     rule(154),
     ['Result' = prohibition],
     [rule_result(open_no_print, q_print, prohibition)]).
step(rule_result(open_no_print, q_print, prohibition),
     rule(100),
     ['Rule' = open_no_print, 'Request' = q_print, 'Result' = prohibition],
     [prohibition_result(open_no_print, q_print, prohibition)]).
step(prohibition_result(open_no_print, q_print, prohibition),
     rule(96),
     ['Rule' = open_no_print, 'Request' = q_print],
     [prohibition(open_printing, open_no_print, alice, print, report_q1),
      rule_scope_matches(open_no_print, q_print),
      constraints_hold(open_no_print, q_print)]).
step(prohibition(open_printing, open_no_print, alice, print, report_q1), fact(60), [], []).
step(rule_scope_matches(open_no_print, q_print),
     rule(89),
     ['Rule' = open_no_print,
      'Request' = q_print,
      'RuleParty' = alice,
      'RuleAction' = print,
      'RuleTarget' = report_q1,
      'Party' = alice,
      'Action' = print,
      'Target' = report_q1],
     [rule(open_no_print, open_printing, prohibition, alice, print, report_q1),
      request(q_print, alice, print, report_q1),
      party_subsumes(alice, alice),
      asset_subsumes(report_q1, report_q1),
      positive_action_match(print, print, exact)]).
step(rule(open_no_print, open_printing, prohibition, alice, print, report_q1),
     rule(88),
     ['Rule' = open_no_print,
      'Policy' = open_printing,
      'Party' = alice,
      'Action' = print,
      'Target' = report_q1],
     [prohibition(open_printing, open_no_print, alice, print, report_q1)]).
step(positive_action_match(print, print, exact), rule(25), ['Action' = print], [action(print)]).
step(action(print), fact(5), [], []).
step(constraints_hold(open_no_print, q_print),
     rule(90),
     ['Rule' = open_no_print, 'Request' = q_print],
     [\+ (constraint(open_no_print, Key, Value), \+ evidence(q_print, Key, Value))]).
step(\+ (constraint(open_no_print, Key, Value), \+ evidence(q_print, Key, Value)),
     absent,
     [],
     []).
step(enforcementQuestion(permission_overrides, open_printing, q_print, closed, permission, permit),
     rule(155),
     ['Result' = permission, 'Decision' = permit],
     [policy_result(open_printing, q_print, permission),
      access_decision(open_printing, q_print, closed, permit)]).
step(policy_result(open_printing, q_print, permission),
     rule(105),
     ['Policy' = open_printing, 'Request' = q_print],
     [policy_permission(open_printing, q_print),
      policy_prohibition(open_printing, q_print),
      policy(open_printing, perm)]).
step(policy_permission(open_printing, q_print),
     rule(101),
     ['Policy' = open_printing, 'Request' = q_print, 'Rule' = open_use],
     [permission(open_printing, open_use, analysts, use, reports),
      permission_result(open_use, q_print, permission)]).
step(policy_prohibition(open_printing, q_print),
     rule(102),
     ['Policy' = open_printing, 'Request' = q_print, 'Rule' = open_no_print],
     [prohibition(open_printing, open_no_print, alice, print, report_q1),
      prohibition_result(open_no_print, q_print, prohibition)]).
step(policy(open_printing, perm), fact(51), [], []).
step(access_decision(open_printing, q_print, closed, permit),
     rule(112),
     ['Policy' = open_printing, 'Request' = q_print],
     [policy_result(open_printing, q_print, permission)]).
step(enforcementQuestion(prohibition_overrides, strict_printing, q_print, closed, prohibition, deny),
     rule(156),
     ['Result' = prohibition, 'Decision' = deny],
     [policy_result(strict_printing, q_print, prohibition),
      access_decision(strict_printing, q_print, closed, deny)]).
step(policy_result(strict_printing, q_print, prohibition),
     rule(106),
     ['Policy' = strict_printing, 'Request' = q_print],
     [policy_permission(strict_printing, q_print),
      policy_prohibition(strict_printing, q_print),
      policy(strict_printing, prohibit)]).
step(policy_permission(strict_printing, q_print),
     rule(101),
     ['Policy' = strict_printing, 'Request' = q_print, 'Rule' = strict_use],
     [permission(strict_printing, strict_use, analysts, use, reports),
      permission_result(strict_use, q_print, permission)]).
step(permission(strict_printing, strict_use, analysts, use, reports), fact(61), [], []).
step(permission_result(strict_use, q_print, permission),
     rule(92),
     ['Rule' = strict_use, 'Request' = q_print],
     [permission(strict_printing, strict_use, analysts, use, reports),
      rule_scope_matches(strict_use, q_print),
      constraints_hold(strict_use, q_print),
      duties_hold(strict_use, q_print)]).
step(rule_scope_matches(strict_use, q_print),
     rule(89),
     ['Rule' = strict_use,
      'Request' = q_print,
      'RuleParty' = analysts,
      'RuleAction' = use,
      'RuleTarget' = reports,
      'Party' = alice,
      'Action' = print,
      'Target' = report_q1],
     [rule(strict_use, strict_printing, permission, analysts, use, reports),
      request(q_print, alice, print, report_q1),
      party_subsumes(analysts, alice),
      asset_subsumes(reports, report_q1),
      positive_action_match(use, print, broader)]).
step(rule(strict_use, strict_printing, permission, analysts, use, reports),
     rule(87),
     ['Rule' = strict_use,
      'Policy' = strict_printing,
      'Party' = analysts,
      'Action' = use,
      'Target' = reports],
     [permission(strict_printing, strict_use, analysts, use, reports)]).
step(constraints_hold(strict_use, q_print),
     rule(90),
     ['Rule' = strict_use, 'Request' = q_print],
     [\+ (constraint(strict_use, Key, Value), \+ evidence(q_print, Key, Value))]).
step(\+ (constraint(strict_use, Key, Value), \+ evidence(q_print, Key, Value)), absent, [], []).
step(duties_hold(strict_use, q_print),
     rule(91),
     ['Rule' = strict_use, 'Request' = q_print],
     [\+ (duty(strict_use, Duty), \+ duty_done(q_print, Duty))]).
step(\+ (duty(strict_use, Duty), \+ duty_done(q_print, Duty)), absent, [], []).
step(policy_prohibition(strict_printing, q_print),
     rule(102),
     ['Policy' = strict_printing, 'Request' = q_print, 'Rule' = strict_no_print],
     [prohibition(strict_printing, strict_no_print, alice, print, report_q1),
      prohibition_result(strict_no_print, q_print, prohibition)]).
step(prohibition(strict_printing, strict_no_print, alice, print, report_q1), fact(62), [], []).
step(prohibition_result(strict_no_print, q_print, prohibition),
     rule(96),
     ['Rule' = strict_no_print, 'Request' = q_print],
     [prohibition(strict_printing, strict_no_print, alice, print, report_q1),
      rule_scope_matches(strict_no_print, q_print),
      constraints_hold(strict_no_print, q_print)]).
step(rule_scope_matches(strict_no_print, q_print),
     rule(89),
     ['Rule' = strict_no_print,
      'Request' = q_print,
      'RuleParty' = alice,
      'RuleAction' = print,
      'RuleTarget' = report_q1,
      'Party' = alice,
      'Action' = print,
      'Target' = report_q1],
     [rule(strict_no_print, strict_printing, prohibition, alice, print, report_q1),
      request(q_print, alice, print, report_q1),
      party_subsumes(alice, alice),
      asset_subsumes(report_q1, report_q1),
      positive_action_match(print, print, exact)]).
step(rule(strict_no_print, strict_printing, prohibition, alice, print, report_q1),
     rule(88),
     ['Rule' = strict_no_print,
      'Policy' = strict_printing,
      'Party' = alice,
      'Action' = print,
      'Target' = report_q1],
     [prohibition(strict_printing, strict_no_print, alice, print, report_q1)]).
step(constraints_hold(strict_no_print, q_print),
     rule(90),
     ['Rule' = strict_no_print, 'Request' = q_print],
     [\+ (constraint(strict_no_print, Key, Value), \+ evidence(q_print, Key, Value))]).
step(\+ (constraint(strict_no_print, Key, Value), \+ evidence(q_print, Key, Value)),
     absent,
     [],
     []).
step(policy(strict_printing, prohibit), fact(52), [], []).
step(access_decision(strict_printing, q_print, closed, deny),
     rule(113),
     ['Policy' = strict_printing, 'Request' = q_print],
     [policy_result(strict_printing, q_print, prohibition)]).
step(enforcementQuestion(conflict_invalidates, invalid_printing, q_print, closed, invalid, invalid),
     rule(157),
     ['Result' = invalid, 'Decision' = invalid],
     [policy_result(invalid_printing, q_print, invalid),
      access_decision(invalid_printing, q_print, closed, invalid)]).
step(policy_result(invalid_printing, q_print, invalid),
     rule(107),
     ['Policy' = invalid_printing, 'Request' = q_print],
     [policy_permission(invalid_printing, q_print),
      policy_prohibition(invalid_printing, q_print),
      policy(invalid_printing, invalid)]).
step(policy_permission(invalid_printing, q_print),
     rule(101),
     ['Policy' = invalid_printing, 'Request' = q_print, 'Rule' = invalid_use],
     [permission(invalid_printing, invalid_use, analysts, use, reports),
      permission_result(invalid_use, q_print, permission)]).
step(permission(invalid_printing, invalid_use, analysts, use, reports), fact(63), [], []).
step(permission_result(invalid_use, q_print, permission),
     rule(92),
     ['Rule' = invalid_use, 'Request' = q_print],
     [permission(invalid_printing, invalid_use, analysts, use, reports),
      rule_scope_matches(invalid_use, q_print),
      constraints_hold(invalid_use, q_print),
      duties_hold(invalid_use, q_print)]).
step(rule_scope_matches(invalid_use, q_print),
     rule(89),
     ['Rule' = invalid_use,
      'Request' = q_print,
      'RuleParty' = analysts,
      'RuleAction' = use,
      'RuleTarget' = reports,
      'Party' = alice,
      'Action' = print,
      'Target' = report_q1],
     [rule(invalid_use, invalid_printing, permission, analysts, use, reports),
      request(q_print, alice, print, report_q1),
      party_subsumes(analysts, alice),
      asset_subsumes(reports, report_q1),
      positive_action_match(use, print, broader)]).
step(rule(invalid_use, invalid_printing, permission, analysts, use, reports),
     rule(87),
     ['Rule' = invalid_use,
      'Policy' = invalid_printing,
      'Party' = analysts,
      'Action' = use,
      'Target' = reports],
     [permission(invalid_printing, invalid_use, analysts, use, reports)]).
step(constraints_hold(invalid_use, q_print),
     rule(90),
     ['Rule' = invalid_use, 'Request' = q_print],
     [\+ (constraint(invalid_use, Key, Value), \+ evidence(q_print, Key, Value))]).
step(\+ (constraint(invalid_use, Key, Value), \+ evidence(q_print, Key, Value)), absent, [], []).
step(duties_hold(invalid_use, q_print),
     rule(91),
     ['Rule' = invalid_use, 'Request' = q_print],
     [\+ (duty(invalid_use, Duty), \+ duty_done(q_print, Duty))]).
step(\+ (duty(invalid_use, Duty), \+ duty_done(q_print, Duty)), absent, [], []).
step(policy_prohibition(invalid_printing, q_print),
     rule(102),
     ['Policy' = invalid_printing, 'Request' = q_print, 'Rule' = invalid_no_print],
     [prohibition(invalid_printing, invalid_no_print, alice, print, report_q1),
      prohibition_result(invalid_no_print, q_print, prohibition)]).
step(prohibition(invalid_printing, invalid_no_print, alice, print, report_q1), fact(64), [], []).
step(prohibition_result(invalid_no_print, q_print, prohibition),
     rule(96),
     ['Rule' = invalid_no_print, 'Request' = q_print],
     [prohibition(invalid_printing, invalid_no_print, alice, print, report_q1),
      rule_scope_matches(invalid_no_print, q_print),
      constraints_hold(invalid_no_print, q_print)]).
step(rule_scope_matches(invalid_no_print, q_print),
     rule(89),
     ['Rule' = invalid_no_print,
      'Request' = q_print,
      'RuleParty' = alice,
      'RuleAction' = print,
      'RuleTarget' = report_q1,
      'Party' = alice,
      'Action' = print,
      'Target' = report_q1],
     [rule(invalid_no_print, invalid_printing, prohibition, alice, print, report_q1),
      request(q_print, alice, print, report_q1),
      party_subsumes(alice, alice),
      asset_subsumes(report_q1, report_q1),
      positive_action_match(print, print, exact)]).
step(rule(invalid_no_print, invalid_printing, prohibition, alice, print, report_q1),
     rule(88),
     ['Rule' = invalid_no_print,
      'Policy' = invalid_printing,
      'Party' = alice,
      'Action' = print,
      'Target' = report_q1],
     [prohibition(invalid_printing, invalid_no_print, alice, print, report_q1)]).
step(constraints_hold(invalid_no_print, q_print),
     rule(90),
     ['Rule' = invalid_no_print, 'Request' = q_print],
     [\+ (constraint(invalid_no_print, Key, Value), \+ evidence(q_print, Key, Value))]).
step(\+ (constraint(invalid_no_print, Key, Value), \+ evidence(q_print, Key, Value)),
     absent,
     [],
     []).
step(policy(invalid_printing, invalid), fact(53), [], []).
step(access_decision(invalid_printing, q_print, closed, invalid),
     rule(114),
     ['Policy' = invalid_printing, 'Request' = q_print],
     [policy_result(invalid_printing, q_print, invalid)]).
step(enforcementQuestion(duty_satisfied, duty_policy, q_share_done, closed, permission, permit),
     rule(158),
     ['Result' = permission, 'Decision' = permit],
     [policy_result(duty_policy, q_share_done, permission),
      access_decision(duty_policy, q_share_done, closed, permit)]).
step(policy_result(duty_policy, q_share_done, permission),
     rule(108),
     ['Policy' = duty_policy, 'Request' = q_share_done],
     [policy_permission(duty_policy, q_share_done),
      \+ policy_prohibition(duty_policy, q_share_done)]).
step(policy_permission(duty_policy, q_share_done),
     rule(101),
     ['Policy' = duty_policy, 'Request' = q_share_done, 'Rule' = share_report],
     [permission(duty_policy, share_report, alice, distribute, report_q1),
      permission_result(share_report, q_share_done, permission)]).
step(\+ policy_prohibition(duty_policy, q_share_done), absent, [], []).
step(access_decision(duty_policy, q_share_done, closed, permit),
     rule(112),
     ['Policy' = duty_policy, 'Request' = q_share_done],
     [policy_result(duty_policy, q_share_done, permission)]).
step(enforcementQuestion(duty_missing, duty_policy, q_share_missing, closed, inactive, deny),
     rule(159),
     ['Result' = inactive, 'Decision' = deny],
     [policy_result(duty_policy, q_share_missing, inactive),
      access_decision(duty_policy, q_share_missing, closed, deny)]).
step(policy_result(duty_policy, q_share_missing, inactive),
     rule(110),
     ['Policy' = duty_policy, 'Request' = q_share_missing],
     [\+ policy_permission(duty_policy, q_share_missing),
      \+ policy_prohibition(duty_policy, q_share_missing),
      policy_inactive(duty_policy, q_share_missing)]).
step(\+ policy_permission(duty_policy, q_share_missing), absent, [], []).
step(\+ policy_prohibition(duty_policy, q_share_missing), absent, [], []).
step(policy_inactive(duty_policy, q_share_missing),
     rule(103),
     ['Policy' = duty_policy, 'Request' = q_share_missing, 'Rule' = share_report],
     [rule(share_report, duty_policy, permission, alice, distribute, report_q1),
      rule_result(share_report, q_share_missing, inactive(duty(attribute_source)))]).
step(access_decision(duty_policy, q_share_missing, closed, deny),
     rule(115),
     ['Policy' = duty_policy, 'Request' = q_share_missing],
     [policy_result(duty_policy, q_share_missing, inactive)]).
step(enforcementQuestion(constraint_false, context_policy, q_commercial, closed, inactive, deny),
     rule(160),
     ['Result' = inactive, 'Decision' = deny],
     [policy_result(context_policy, q_commercial, inactive),
      access_decision(context_policy, q_commercial, closed, deny)]).
step(policy_result(context_policy, q_commercial, inactive),
     rule(110),
     ['Policy' = context_policy, 'Request' = q_commercial],
     [\+ policy_permission(context_policy, q_commercial),
      \+ policy_prohibition(context_policy, q_commercial),
      policy_inactive(context_policy, q_commercial)]).
step(\+ policy_permission(context_policy, q_commercial), absent, [], []).
step(\+ policy_prohibition(context_policy, q_commercial), absent, [], []).
step(policy_inactive(context_policy, q_commercial),
     rule(103),
     ['Policy' = context_policy, 'Request' = q_commercial, 'Rule' = research_use],
     [rule(research_use, context_policy, permission, analysts, use, reports),
      rule_result(research_use, q_commercial, inactive(constraint(purpose)))]).
step(access_decision(context_policy, q_commercial, closed, deny),
     rule(115),
     ['Policy' = context_policy, 'Request' = q_commercial],
     [policy_result(context_policy, q_commercial, inactive)]).
step(enforcementQuestion(no_match_closed, context_policy, q_unrelated, closed, not_applicable, deny),
     rule(161),
     ['Result' = not_applicable, 'Decision' = deny],
     [policy_result(context_policy, q_unrelated, not_applicable),
      access_decision(context_policy, q_unrelated, closed, deny)]).
step(policy_result(context_policy, q_unrelated, not_applicable),
     rule(111),
     ['Policy' = context_policy, 'Request' = q_unrelated],
     [policy(context_policy, invalid), \+ policy_applicable(context_policy, q_unrelated)]).
step(policy(context_policy, invalid), fact(55), [], []).
step(\+ policy_applicable(context_policy, q_unrelated), absent, [], []).
step(access_decision(context_policy, q_unrelated, closed, deny),
     rule(117),
     ['Policy' = context_policy, 'Request' = q_unrelated],
     [policy_result(context_policy, q_unrelated, not_applicable)]).
step(enforcementQuestion(no_match_open, context_policy, q_unrelated, open, not_applicable, permit),
     rule(162),
     ['Result' = not_applicable, 'Decision' = permit],
     [policy_result(context_policy, q_unrelated, not_applicable),
      access_decision(context_policy, q_unrelated, open, permit)]).
step(access_decision(context_policy, q_unrelated, open, permit),
     rule(116),
     ['Policy' = context_policy, 'Request' = q_unrelated],
     [policy_result(context_policy, q_unrelated, not_applicable)]).
step(enforcementQuestion(no_match_default, context_policy, q_unrelated, default, not_applicable, deny),
     rule(163),
     ['Result' = not_applicable, 'Decision' = deny],
     [policy_result(context_policy, q_unrelated, not_applicable),
      access_decision(context_policy, q_unrelated, default, deny)]).
step(access_decision(context_policy, q_unrelated, default, deny),
     rule(118),
     ['Policy' = context_policy, 'Request' = q_unrelated],
     [policy_result(context_policy, q_unrelated, not_applicable)]).
step(conflictQuestion(exact, analysis_policy, exact_permit, exact_prohibit, exact),
     rule(164),
     ['Kind' = exact],
     [rule_conflict(exact_permit, exact_prohibit, exact)]).
step(rule_conflict(exact_permit, exact_prohibit, exact),
     rule(129),
     ['RuleA' = exact_permit,
      'RuleB' = exact_prohibit,
      'Kind' = exact,
      'EffectA' = permission,
      'PartyA' = alice,
      'ActionA' = display,
      'TargetA' = dataset_a,
      'EffectB' = prohibition,
      'PartyB' = alice,
      'ActionB' = display,
      'TargetB' = dataset_a],
     [rule(exact_permit, analysis_policy, permission, alice, display, dataset_a),
      rule(exact_prohibit, analysis_policy, prohibition, alice, display, dataset_a),
      opposite(permission, prohibition),
      parties_overlap(alice, alice),
      assets_overlap(dataset_a, dataset_a),
      constraints_compatible(exact_permit, exact_prohibit),
      conflicting_action(display, display, exact)]).
step(rule(exact_permit, analysis_policy, permission, alice, display, dataset_a),
     rule(87),
     ['Rule' = exact_permit,
      'Policy' = analysis_policy,
      'Party' = alice,
      'Action' = display,
      'Target' = dataset_a],
     [permission(analysis_policy, exact_permit, alice, display, dataset_a)]).
step(permission(analysis_policy, exact_permit, alice, display, dataset_a), fact(69), [], []).
step(rule(exact_prohibit, analysis_policy, prohibition, alice, display, dataset_a),
     rule(88),
     ['Rule' = exact_prohibit,
      'Policy' = analysis_policy,
      'Party' = alice,
      'Action' = display,
      'Target' = dataset_a],
     [prohibition(analysis_policy, exact_prohibit, alice, display, dataset_a)]).
step(prohibition(analysis_policy, exact_prohibit, alice, display, dataset_a), fact(70), [], []).
step(opposite(permission, prohibition), fact(119), [], []).
step(parties_overlap(alice, alice),
     rule(121),
     ['A' = alice, 'B' = alice],
     [party_subsumes(alice, alice)]).
step(assets_overlap(dataset_a, dataset_a),
     rule(123),
     ['A' = dataset_a, 'B' = dataset_a],
     [asset_subsumes(dataset_a, dataset_a)]).
step(asset_subsumes(dataset_a, dataset_a), rule(49), ['Asset' = dataset_a], [asset(dataset_a)]).
step(asset(dataset_a), fact(44), [], []).
step(constraints_compatible(exact_permit, exact_prohibit),
     rule(125),
     ['RuleA' = exact_permit, 'RuleB' = exact_prohibit],
     [\+ (constraint(exact_permit, Key, A), constraint(exact_prohibit, Key, B), A \= B)]).
step(\+ (constraint(exact_permit, Key, A), constraint(exact_prohibit, Key, B), A \= B),
     absent,
     [],
     []).
step(conflicting_action(display, display, exact),
     rule(126),
     ['Action' = display],
     [action(display)]).
step(conflictQuestion(subsumption, analysis_policy, broad_permit, narrow_prohibit, subsumption),
     rule(165),
     ['Kind' = subsumption],
     [rule_conflict(broad_permit, narrow_prohibit, subsumption)]).
step(rule_conflict(broad_permit, narrow_prohibit, subsumption),
     rule(129),
     ['RuleA' = broad_permit,
      'RuleB' = narrow_prohibit,
      'Kind' = subsumption,
      'EffectA' = permission,
      'PartyA' = alice,
      'ActionA' = use,
      'TargetA' = dataset_b,
      'EffectB' = prohibition,
      'PartyB' = alice,
      'ActionB' = print,
      'TargetB' = dataset_b],
     [rule(broad_permit, analysis_policy, permission, alice, use, dataset_b),
      rule(narrow_prohibit, analysis_policy, prohibition, alice, print, dataset_b),
      opposite(permission, prohibition),
      parties_overlap(alice, alice),
      assets_overlap(dataset_b, dataset_b),
      constraints_compatible(broad_permit, narrow_prohibit),
      conflicting_action(use, print, subsumption)]).
step(rule(broad_permit, analysis_policy, permission, alice, use, dataset_b),
     rule(87),
     ['Rule' = broad_permit,
      'Policy' = analysis_policy,
      'Party' = alice,
      'Action' = use,
      'Target' = dataset_b],
     [permission(analysis_policy, broad_permit, alice, use, dataset_b)]).
step(permission(analysis_policy, broad_permit, alice, use, dataset_b), fact(71), [], []).
step(rule(narrow_prohibit, analysis_policy, prohibition, alice, print, dataset_b),
     rule(88),
     ['Rule' = narrow_prohibit,
      'Policy' = analysis_policy,
      'Party' = alice,
      'Action' = print,
      'Target' = dataset_b],
     [prohibition(analysis_policy, narrow_prohibit, alice, print, dataset_b)]).
step(prohibition(analysis_policy, narrow_prohibit, alice, print, dataset_b), fact(72), [], []).
step(assets_overlap(dataset_b, dataset_b),
     rule(123),
     ['A' = dataset_b, 'B' = dataset_b],
     [asset_subsumes(dataset_b, dataset_b)]).
step(asset_subsumes(dataset_b, dataset_b), rule(49), ['Asset' = dataset_b], [asset(dataset_b)]).
step(asset(dataset_b), fact(45), [], []).
step(constraints_compatible(broad_permit, narrow_prohibit),
     rule(125),
     ['RuleA' = broad_permit, 'RuleB' = narrow_prohibit],
     [\+ (constraint(broad_permit, Key, A), constraint(narrow_prohibit, Key, B), A \= B)]).
step(\+ (constraint(broad_permit, Key, A), constraint(narrow_prohibit, Key, B), A \= B),
     absent,
     [],
     []).
step(conflicting_action(use, print, subsumption),
     rule(127),
     ['ActionA' = use, 'ActionB' = print],
     [use \= print, (action_subsumes(use, print) ; action_subsumes(print, use))]).
step((action_subsumes(use, print) ; action_subsumes(print, use)), builtin, [], []).
step(conflictQuestion(dependency, analysis_policy, aggregate_permit, read_prohibit, dependency),
     rule(166),
     ['Kind' = dependency],
     [rule_conflict(aggregate_permit, read_prohibit, dependency)]).
step(rule_conflict(aggregate_permit, read_prohibit, dependency),
     rule(129),
     ['RuleA' = aggregate_permit,
      'RuleB' = read_prohibit,
      'Kind' = dependency,
      'EffectA' = permission,
      'PartyA' = alice,
      'ActionA' = aggregate,
      'TargetA' = dataset_c,
      'EffectB' = prohibition,
      'PartyB' = alice,
      'ActionB' = read,
      'TargetB' = dataset_c],
     [rule(aggregate_permit, analysis_policy, permission, alice, aggregate, dataset_c),
      rule(read_prohibit, analysis_policy, prohibition, alice, read, dataset_c),
      opposite(permission, prohibition),
      parties_overlap(alice, alice),
      assets_overlap(dataset_c, dataset_c),
      constraints_compatible(aggregate_permit, read_prohibit),
      conflicting_action(aggregate, read, dependency)]).
step(rule(aggregate_permit, analysis_policy, permission, alice, aggregate, dataset_c),
     rule(87),
     ['Rule' = aggregate_permit,
      'Policy' = analysis_policy,
      'Party' = alice,
      'Action' = aggregate,
      'Target' = dataset_c],
     [permission(analysis_policy, aggregate_permit, alice, aggregate, dataset_c)]).
step(permission(analysis_policy, aggregate_permit, alice, aggregate, dataset_c),
     fact(73),
     [],
     []).
step(rule(read_prohibit, analysis_policy, prohibition, alice, read, dataset_c),
     rule(88),
     ['Rule' = read_prohibit,
      'Policy' = analysis_policy,
      'Party' = alice,
      'Action' = read,
      'Target' = dataset_c],
     [prohibition(analysis_policy, read_prohibit, alice, read, dataset_c)]).
step(prohibition(analysis_policy, read_prohibit, alice, read, dataset_c), fact(74), [], []).
step(assets_overlap(dataset_c, dataset_c),
     rule(123),
     ['A' = dataset_c, 'B' = dataset_c],
     [asset_subsumes(dataset_c, dataset_c)]).
step(asset_subsumes(dataset_c, dataset_c), rule(49), ['Asset' = dataset_c], [asset(dataset_c)]).
step(asset(dataset_c), fact(46), [], []).
step(constraints_compatible(aggregate_permit, read_prohibit),
     rule(125),
     ['RuleA' = aggregate_permit, 'RuleB' = read_prohibit],
     [\+ (constraint(aggregate_permit, Key, A), constraint(read_prohibit, Key, B), A \= B)]).
step(\+ (constraint(aggregate_permit, Key, A), constraint(read_prohibit, Key, B), A \= B),
     absent,
     [],
     []).
step(conflicting_action(aggregate, read, dependency),
     rule(128),
     ['ActionA' = aggregate, 'ActionB' = read],
     [\+ action_subsumes(aggregate, read),
      \+ action_subsumes(read, aggregate),
      (action_requires(aggregate, read) ; action_requires(read, aggregate))]).
step(\+ action_subsumes(aggregate, read), absent, [], []).
step(\+ action_subsumes(read, aggregate), absent, [], []).
step((action_requires(aggregate, read) ; action_requires(read, aggregate)), builtin, [], []).
step(subsumptionQuestion(action_yes, use, display, yes),
     rule(167),
     [],
     [action_subsumes(use, display)]).
step(subsumptionQuestion(action_no, display, use, no),
     rule(168),
     [],
     [\+ action_subsumes(display, use)]).
step(\+ action_subsumes(display, use), absent, [], []).
step(subsumptionQuestion(rule_yes, general_use, specific_display, yes),
     rule(169),
     [],
     [rule_subsumes(general_use, specific_display)]).
step(rule_subsumes(general_use, specific_display),
     rule(132),
     ['General' = general_use,
      'Specific' = specific_display,
      'Effect' = permission,
      'GeneralParty' = analysts,
      'GeneralAction' = use,
      'GeneralTarget' = reports,
      'SpecificParty' = alice,
      'SpecificAction' = display,
      'SpecificTarget' = report_q1],
     [rule(general_use, general_policy, permission, analysts, use, reports),
      rule(specific_display, specific_policy, permission, alice, display, report_q1),
      party_subsumes(analysts, alice),
      action_subsumes(use, display),
      asset_subsumes(reports, report_q1),
      constraints_subsume(general_use, specific_display),
      duties_subsume(general_use, specific_display)]).
step(rule(general_use, general_policy, permission, analysts, use, reports),
     rule(87),
     ['Rule' = general_use,
      'Policy' = general_policy,
      'Party' = analysts,
      'Action' = use,
      'Target' = reports],
     [permission(general_policy, general_use, analysts, use, reports)]).
step(permission(general_policy, general_use, analysts, use, reports), fact(75), [], []).
step(rule(specific_display, specific_policy, permission, alice, display, report_q1),
     rule(87),
     ['Rule' = specific_display,
      'Policy' = specific_policy,
      'Party' = alice,
      'Action' = display,
      'Target' = report_q1],
     [permission(specific_policy, specific_display, alice, display, report_q1)]).
step(permission(specific_policy, specific_display, alice, display, report_q1), fact(76), [], []).
step(constraints_subsume(general_use, specific_display),
     rule(130),
     ['General' = general_use, 'Specific' = specific_display],
     [\+ (constraint(general_use, Key, Value), \+ constraint(specific_display, Key, Value))]).
step(\+ (constraint(general_use, Key, Value), \+ constraint(specific_display, Key, Value)),
     absent,
     [],
     []).
step(duties_subsume(general_use, specific_display),
     rule(131),
     ['General' = general_use, 'Specific' = specific_display],
     [\+ (duty(general_use, Duty), \+ duty(specific_display, Duty))]).
step(\+ (duty(general_use, Duty), \+ duty(specific_display, Duty)), absent, [], []).
step(subsumptionQuestion(rule_no, specific_display, general_use, no),
     rule(170),
     [],
     [\+ rule_subsumes(specific_display, general_use)]).
step(\+ rule_subsumes(specific_display, general_use), absent, [], []).
step(subsumptionQuestion(policy_yes, general_policy, specific_policy, yes),
     rule(171),
     [],
     [policy_subsumes(general_policy, specific_policy)]).
step(policy_subsumes(general_policy, specific_policy),
     rule(133),
     ['General' = general_policy, 'Specific' = specific_policy],
     [policy(general_policy, invalid),
      policy(specific_policy, invalid),
      \+ (rule(SpecificRule, specific_policy, __anon54, __anon55, __anon56, __anon57), \+ (rule(GeneralRule, general_policy, __anon58, __anon59, __anon60, __anon61), rule_subsumes(GeneralRule, SpecificRule)))]).
step(policy(general_policy, invalid), fact(57), [], []).
step(policy(specific_policy, invalid), fact(58), [], []).
step(\+ (rule(SpecificRule, specific_policy, __anon54, __anon55, __anon56, __anon57), \+ (rule(GeneralRule, general_policy, __anon58, __anon59, __anon60, __anon61), rule_subsumes(GeneralRule, SpecificRule))),
     absent,
     [],
     []).
step(subsumptionQuestion(policy_no, specific_policy, general_policy, no),
     rule(172),
     [],
     [\+ policy_subsumes(specific_policy, general_policy)]).
step(\+ policy_subsumes(specific_policy, general_policy), absent, [], []).
step(wfsQuestion(clear_permission, true),
     rule(173),
     ['State' = true],
     [wfs_truth(profile_permission(clear), true)]).
step(wfs_truth(profile_permission(clear), true), builtin, [], []).
step(wfsQuestion(absent_permission, false),
     rule(174),
     ['State' = false],
     [wfs_truth(profile_permission(denied), false)]).
step(wfs_truth(profile_permission(denied), false), builtin, [], []).
step(wfsQuestion(negative_cycle, undefined),
     rule(175),
     ['State' = undefined],
     [wfs_truth(profile_permission(cycle), undefined)]).
step(wfs_truth(profile_permission(cycle), undefined), builtin, [], []).
