% Prolog result format 4
query(1, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = no_mandate, 'X1' = insufficient_control]).
why(1,
    ['X0' = no_mandate, 'X1' = insufficient_control],
    [status(no_mandate, insufficient_control)]).
answer(1, ['X0' = vaccination_campaign, 'X1' = insufficient_control]).
why(1,
    ['X0' = vaccination_campaign, 'X1' = insufficient_control],
    [status(vaccination_campaign, insufficient_control)]).
answer(1, ['X0' = indoor_masks, 'X1' = insufficient_control]).
why(1,
    ['X0' = indoor_masks, 'X1' = insufficient_control],
    [status(indoor_masks, insufficient_control)]).
answer(1, ['X0' = vaccination_and_masks, 'X1' = acceptable_control]).
why(1,
    ['X0' = vaccination_and_masks, 'X1' = acceptable_control],
    [status(vaccination_and_masks, acceptable_control)]).
query(2, riskScore(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 4).
answer(2, ['X0' = no_mandate, 'X1' = 1.4]).
why(2, ['X0' = no_mandate, 'X1' = 1.4], [riskScore(no_mandate, 1.4)]).
answer(2, ['X0' = vaccination_campaign, 'X1' = 0.77]).
why(2, ['X0' = vaccination_campaign, 'X1' = 0.77], [riskScore(vaccination_campaign, 0.77)]).
answer(2, ['X0' = indoor_masks, 'X1' = 0.9099999999999999]).
why(2,
    ['X0' = indoor_masks, 'X1' = 0.9099999999999999],
    [riskScore(indoor_masks, 0.9099999999999999)]).
answer(2, ['X0' = vaccination_and_masks, 'X1' = 0.5005000000000001]).
why(2,
    ['X0' = vaccination_and_masks, 'X1' = 0.5005000000000001],
    [riskScore(vaccination_and_masks, 0.5005000000000001)]).
query(3, cost(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 4).
answer(3, ['X0' = no_mandate, 'X1' = 0]).
why(3, ['X0' = no_mandate, 'X1' = 0], [cost(no_mandate, 0)]).
answer(3, ['X0' = vaccination_campaign, 'X1' = 3]).
why(3, ['X0' = vaccination_campaign, 'X1' = 3], [cost(vaccination_campaign, 3)]).
answer(3, ['X0' = indoor_masks, 'X1' = 2]).
why(3, ['X0' = indoor_masks, 'X1' = 2], [cost(indoor_masks, 2)]).
answer(3, ['X0' = vaccination_and_masks, 'X1' = 5]).
why(3, ['X0' = vaccination_and_masks, 'X1' = 5], [cost(vaccination_and_masks, 5)]).
query(4, recommendedPolicy(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = epidemic_policy, 'X1' = vaccination_and_masks]).
why(4,
    ['X0' = epidemic_policy, 'X1' = vaccination_and_masks],
    [recommendedPolicy(epidemic_policy, vaccination_and_masks)]).
query(5, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5,
       ['X0' = epidemic_policy,
        'X1' = "combined vaccination and indoor masks are the only policy below the outbreak threshold"]).
why(5,
    ['X0' = epidemic_policy,
     'X1' = "combined vaccination and indoor masks are the only policy below the outbreak threshold"],
    [reason(epidemic_policy, "combined vaccination and indoor masks are the only policy below the outbreak threshold")]).

clause(1, policy(no_mandate), true).
clause(2, policy(vaccination_campaign), true).
clause(3, policy(indoor_masks), true).
clause(5, base_risk(1.4), true).
clause(6, vaccination_factor(no_mandate, 1.0), true).
clause(7, vaccination_factor(vaccination_campaign, 0.55), true).
clause(8, vaccination_factor(indoor_masks, 1.0), true).
clause(9, vaccination_factor(vaccination_and_masks, 0.55), true).
clause(10, mask_factor(no_mandate, 1.0), true).
clause(11, mask_factor(vaccination_campaign, 1.0), true).
clause(12, mask_factor(indoor_masks, 0.65), true).
clause(13, mask_factor(vaccination_and_masks, 0.65), true).
clause(14, policy_cost(no_mandate, 0), true).
clause(15, policy_cost(vaccination_campaign, 3), true).
clause(16, policy_cost(indoor_masks, 2), true).
clause(17, policy_cost(vaccination_and_masks, 5), true).
clause(18,
       risk_score(var('P'), var('R')),
       (base_risk(var('Base')),
        vaccination_factor(var('P'), var('Vf')),
        mask_factor(var('P'), var('Mf')),
        var('A') is var('Base') * var('Vf'),
        var('R') is var('A') * var('Mf'))).
clause(19, acceptable(var('P')), (risk_score(var('P'), var('R')), var('R') =< 0.75)).
clause(20,
       status(var('P'), insufficient_control),
       (policy(var('P')), risk_score(var('P'), var('R')), var('R') > 0.75)).
clause(21, status(var('P'), acceptable_control), acceptable(var('P'))).
clause(22,
       recommended(vaccination_and_masks),
       (acceptable(vaccination_and_masks),
        status(no_mandate, insufficient_control),
        status(vaccination_campaign, insufficient_control),
        status(indoor_masks, insufficient_control))).
clause(23, riskScore(var('P'), var('R')), risk_score(var('P'), var('R'))).
clause(24, cost(var('P'), var('C')), policy_cost(var('P'), var('C'))).
clause(25, recommendedPolicy(epidemic_policy, var('P')), recommended(var('P'))).
clause(26,
       reason(epidemic_policy, "combined vaccination and indoor masks are the only policy below the outbreak threshold"),
       recommended(vaccination_and_masks)).

step(status(no_mandate, insufficient_control),
     rule(20),
     ['P' = no_mandate, 'R' = 1.4],
     [policy(no_mandate), risk_score(no_mandate, 1.4), 1.4 > 0.75]).
step(policy(no_mandate), fact(1), [], []).
step(risk_score(no_mandate, 1.4),
     rule(18),
     ['P' = no_mandate, 'R' = 1.4, 'Base' = 1.4, 'Vf' = 1.0, 'Mf' = 1.0, 'A' = 1.4],
     [base_risk(1.4),
      vaccination_factor(no_mandate, 1.0),
      mask_factor(no_mandate, 1.0),
      1.4 is 1.4 * 1.0,
      1.4 is 1.4 * 1.0]).
step(base_risk(1.4), fact(5), [], []).
step(vaccination_factor(no_mandate, 1.0), fact(6), [], []).
step(mask_factor(no_mandate, 1.0), fact(10), [], []).
step(1.4 is 1.4 * 1.0, builtin, [], []).
step(1.4 > 0.75, builtin, [], []).
step(status(vaccination_campaign, insufficient_control),
     rule(20),
     ['P' = vaccination_campaign, 'R' = 0.77],
     [policy(vaccination_campaign), risk_score(vaccination_campaign, 0.77), 0.77 > 0.75]).
step(policy(vaccination_campaign), fact(2), [], []).
step(risk_score(vaccination_campaign, 0.77),
     rule(18),
     ['P' = vaccination_campaign, 'R' = 0.77, 'Base' = 1.4, 'Vf' = 0.55, 'Mf' = 1.0, 'A' = 0.77],
     [base_risk(1.4),
      vaccination_factor(vaccination_campaign, 0.55),
      mask_factor(vaccination_campaign, 1.0),
      0.77 is 1.4 * 0.55,
      0.77 is 0.77 * 1.0]).
step(vaccination_factor(vaccination_campaign, 0.55), fact(7), [], []).
step(mask_factor(vaccination_campaign, 1.0), fact(11), [], []).
step(0.77 is 1.4 * 0.55, builtin, [], []).
step(0.77 is 0.77 * 1.0, builtin, [], []).
step(0.77 > 0.75, builtin, [], []).
step(status(indoor_masks, insufficient_control),
     rule(20),
     ['P' = indoor_masks, 'R' = 0.9099999999999999],
     [policy(indoor_masks),
      risk_score(indoor_masks, 0.9099999999999999),
      0.9099999999999999 > 0.75]).
step(policy(indoor_masks), fact(3), [], []).
step(risk_score(indoor_masks, 0.9099999999999999),
     rule(18),
     ['P' = indoor_masks,
      'R' = 0.9099999999999999,
      'Base' = 1.4,
      'Vf' = 1.0,
      'Mf' = 0.65,
      'A' = 1.4],
     [base_risk(1.4),
      vaccination_factor(indoor_masks, 1.0),
      mask_factor(indoor_masks, 0.65),
      1.4 is 1.4 * 1.0,
      0.9099999999999999 is 1.4 * 0.65]).
step(vaccination_factor(indoor_masks, 1.0), fact(8), [], []).
step(mask_factor(indoor_masks, 0.65), fact(12), [], []).
step(0.9099999999999999 is 1.4 * 0.65, builtin, [], []).
step(0.9099999999999999 > 0.75, builtin, [], []).
step(status(vaccination_and_masks, acceptable_control),
     rule(21),
     ['P' = vaccination_and_masks],
     [acceptable(vaccination_and_masks)]).
step(acceptable(vaccination_and_masks),
     rule(19),
     ['P' = vaccination_and_masks, 'R' = 0.5005000000000001],
     [risk_score(vaccination_and_masks, 0.5005000000000001), 0.5005000000000001 =< 0.75]).
step(risk_score(vaccination_and_masks, 0.5005000000000001),
     rule(18),
     ['P' = vaccination_and_masks,
      'R' = 0.5005000000000001,
      'Base' = 1.4,
      'Vf' = 0.55,
      'Mf' = 0.65,
      'A' = 0.77],
     [base_risk(1.4),
      vaccination_factor(vaccination_and_masks, 0.55),
      mask_factor(vaccination_and_masks, 0.65),
      0.77 is 1.4 * 0.55,
      0.5005000000000001 is 0.77 * 0.65]).
step(vaccination_factor(vaccination_and_masks, 0.55), fact(9), [], []).
step(mask_factor(vaccination_and_masks, 0.65), fact(13), [], []).
step(0.5005000000000001 is 0.77 * 0.65, builtin, [], []).
step(0.5005000000000001 =< 0.75, builtin, [], []).
step(riskScore(no_mandate, 1.4),
     rule(23),
     ['P' = no_mandate, 'R' = 1.4],
     [risk_score(no_mandate, 1.4)]).
step(riskScore(vaccination_campaign, 0.77),
     rule(23),
     ['P' = vaccination_campaign, 'R' = 0.77],
     [risk_score(vaccination_campaign, 0.77)]).
step(riskScore(indoor_masks, 0.9099999999999999),
     rule(23),
     ['P' = indoor_masks, 'R' = 0.9099999999999999],
     [risk_score(indoor_masks, 0.9099999999999999)]).
step(riskScore(vaccination_and_masks, 0.5005000000000001),
     rule(23),
     ['P' = vaccination_and_masks, 'R' = 0.5005000000000001],
     [risk_score(vaccination_and_masks, 0.5005000000000001)]).
step(cost(no_mandate, 0), rule(24), ['P' = no_mandate, 'C' = 0], [policy_cost(no_mandate, 0)]).
step(policy_cost(no_mandate, 0), fact(14), [], []).
step(cost(vaccination_campaign, 3),
     rule(24),
     ['P' = vaccination_campaign, 'C' = 3],
     [policy_cost(vaccination_campaign, 3)]).
step(policy_cost(vaccination_campaign, 3), fact(15), [], []).
step(cost(indoor_masks, 2),
     rule(24),
     ['P' = indoor_masks, 'C' = 2],
     [policy_cost(indoor_masks, 2)]).
step(policy_cost(indoor_masks, 2), fact(16), [], []).
step(cost(vaccination_and_masks, 5),
     rule(24),
     ['P' = vaccination_and_masks, 'C' = 5],
     [policy_cost(vaccination_and_masks, 5)]).
step(policy_cost(vaccination_and_masks, 5), fact(17), [], []).
step(recommendedPolicy(epidemic_policy, vaccination_and_masks),
     rule(25),
     ['P' = vaccination_and_masks],
     [recommended(vaccination_and_masks)]).
step(recommended(vaccination_and_masks),
     rule(22),
     [],
     [acceptable(vaccination_and_masks),
      status(no_mandate, insufficient_control),
      status(vaccination_campaign, insufficient_control),
      status(indoor_masks, insufficient_control)]).
step(reason(epidemic_policy, "combined vaccination and indoor masks are the only policy below the outbreak threshold"),
     rule(26),
     [],
     [recommended(vaccination_and_masks)]).
