status(no_mandate, insufficient_control).
status(vaccination_campaign, insufficient_control).
status(indoor_masks, insufficient_control).
status(vaccination_and_masks, acceptable_control).
riskScore(no_mandate, 1.4).
riskScore(vaccination_campaign, 0.77).
riskScore(indoor_masks, 0.9099999999999999).
riskScore(vaccination_and_masks, 0.5005000000000001).
cost(no_mandate, 0).
cost(vaccination_campaign, 3).
cost(indoor_masks, 2).
cost(vaccination_and_masks, 5).
recommendedPolicy(epidemic_policy, vaccination_and_masks).
reason(epidemic_policy, "combined vaccination and indoor masks are the only policy below the outbreak threshold").
