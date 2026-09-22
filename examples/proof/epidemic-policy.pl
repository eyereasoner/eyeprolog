status(no_mandate, insufficient_control).
why(
  status(no_mandate, insufficient_control),
  step(
    status(no_mandate, insufficient_control),
    rule("epidemic-policy.pl", clause(20)),
    ['P' = no_mandate, 'R' = 1.4],
    [
      step(policy(no_mandate), fact("epidemic-policy.pl", clause(1)), [], []),
      step(
        risk_score(no_mandate, 1.4),
        rule("epidemic-policy.pl", clause(18)),
        ['P' = no_mandate, 'R' = 1.4, 'Base' = 1.4, 'Vf' = 1.0, 'Mf' = 1.0, 'A' = 1.4],
        [
          step(base_risk(1.4), fact("epidemic-policy.pl", clause(5)), [], []),
          step(vaccination_factor(no_mandate, 1.0), fact("epidemic-policy.pl", clause(6)), [], []),
          step(mask_factor(no_mandate, 1.0), fact("epidemic-policy.pl", clause(10)), [], []),
          step(is(1.4, *(1.4, 1.0)), builtin(is, 2), [], []),
          step(is(1.4, *(1.4, 1.0)), builtin(is, 2), [], [])
        ]
      ),
      step(>(1.4, 0.75), builtin(>, 2), [], [])
    ]
  )
).

status(vaccination_campaign, insufficient_control).
why(
  status(vaccination_campaign, insufficient_control),
  step(
    status(vaccination_campaign, insufficient_control),
    rule("epidemic-policy.pl", clause(20)),
    ['P' = vaccination_campaign, 'R' = 0.77],
    [
      step(policy(vaccination_campaign), fact("epidemic-policy.pl", clause(2)), [], []),
      step(
        risk_score(vaccination_campaign, 0.77),
        rule("epidemic-policy.pl", clause(18)),
        ['P' = vaccination_campaign, 'R' = 0.77, 'Base' = 1.4, 'Vf' = 0.55, 'Mf' = 1.0, 'A' = 0.77],
        [
          step(base_risk(1.4), fact("epidemic-policy.pl", clause(5)), [], []),
          step(vaccination_factor(vaccination_campaign, 0.55), fact("epidemic-policy.pl", clause(7)), [], []),
          step(mask_factor(vaccination_campaign, 1.0), fact("epidemic-policy.pl", clause(11)), [], []),
          step(is(0.77, *(1.4, 0.55)), builtin(is, 2), [], []),
          step(is(0.77, *(0.77, 1.0)), builtin(is, 2), [], [])
        ]
      ),
      step(>(0.77, 0.75), builtin(>, 2), [], [])
    ]
  )
).

status(indoor_masks, insufficient_control).
why(
  status(indoor_masks, insufficient_control),
  step(
    status(indoor_masks, insufficient_control),
    rule("epidemic-policy.pl", clause(20)),
    ['P' = indoor_masks, 'R' = 0.9099999999999999],
    [
      step(policy(indoor_masks), fact("epidemic-policy.pl", clause(3)), [], []),
      step(
        risk_score(indoor_masks, 0.9099999999999999),
        rule("epidemic-policy.pl", clause(18)),
        ['P' = indoor_masks, 'R' = 0.9099999999999999, 'Base' = 1.4, 'Vf' = 1.0, 'Mf' = 0.65, 'A' = 1.4],
        [
          step(base_risk(1.4), fact("epidemic-policy.pl", clause(5)), [], []),
          step(vaccination_factor(indoor_masks, 1.0), fact("epidemic-policy.pl", clause(8)), [], []),
          step(mask_factor(indoor_masks, 0.65), fact("epidemic-policy.pl", clause(12)), [], []),
          step(is(1.4, *(1.4, 1.0)), builtin(is, 2), [], []),
          step(is(0.9099999999999999, *(1.4, 0.65)), builtin(is, 2), [], [])
        ]
      ),
      step(>(0.9099999999999999, 0.75), builtin(>, 2), [], [])
    ]
  )
).

status(vaccination_and_masks, acceptable_control).
why(
  status(vaccination_and_masks, acceptable_control),
  step(
    status(vaccination_and_masks, acceptable_control),
    rule("epidemic-policy.pl", clause(21)),
    ['P' = vaccination_and_masks],
    [
      step(
        acceptable(vaccination_and_masks),
        rule("epidemic-policy.pl", clause(19)),
        ['P' = vaccination_and_masks, 'R' = 0.5005000000000001],
        [
          step(
            risk_score(vaccination_and_masks, 0.5005000000000001),
            rule("epidemic-policy.pl", clause(18)),
            ['P' = vaccination_and_masks, 'R' = 0.5005000000000001, 'Base' = 1.4, 'Vf' = 0.55, 'Mf' = 0.65, 'A' = 0.77],
            [
              step(base_risk(1.4), fact("epidemic-policy.pl", clause(5)), [], []),
              step(vaccination_factor(vaccination_and_masks, 0.55), fact("epidemic-policy.pl", clause(9)), [], []),
              step(mask_factor(vaccination_and_masks, 0.65), fact("epidemic-policy.pl", clause(13)), [], []),
              step(is(0.77, *(1.4, 0.55)), builtin(is, 2), [], []),
              step(is(0.5005000000000001, *(0.77, 0.65)), builtin(is, 2), [], [])
            ]
          ),
          step(=<(0.5005000000000001, 0.75), builtin(=<, 2), [], [])
        ]
      )
    ]
  )
).

riskScore(no_mandate, 1.4).
why(
  riskScore(no_mandate, 1.4),
  step(
    riskScore(no_mandate, 1.4),
    rule("epidemic-policy.pl", clause(23)),
    ['P' = no_mandate, 'R' = 1.4],
    [
      step(
        risk_score(no_mandate, 1.4),
        rule("epidemic-policy.pl", clause(18)),
        ['P' = no_mandate, 'R' = 1.4, 'Base' = 1.4, 'Vf' = 1.0, 'Mf' = 1.0, 'A' = 1.4],
        [
          step(base_risk(1.4), fact("epidemic-policy.pl", clause(5)), [], []),
          step(vaccination_factor(no_mandate, 1.0), fact("epidemic-policy.pl", clause(6)), [], []),
          step(mask_factor(no_mandate, 1.0), fact("epidemic-policy.pl", clause(10)), [], []),
          step(is(1.4, *(1.4, 1.0)), builtin(is, 2), [], []),
          step(is(1.4, *(1.4, 1.0)), builtin(is, 2), [], [])
        ]
      )
    ]
  )
).

riskScore(vaccination_campaign, 0.77).
why(
  riskScore(vaccination_campaign, 0.77),
  step(
    riskScore(vaccination_campaign, 0.77),
    rule("epidemic-policy.pl", clause(23)),
    ['P' = vaccination_campaign, 'R' = 0.77],
    [
      step(
        risk_score(vaccination_campaign, 0.77),
        rule("epidemic-policy.pl", clause(18)),
        ['P' = vaccination_campaign, 'R' = 0.77, 'Base' = 1.4, 'Vf' = 0.55, 'Mf' = 1.0, 'A' = 0.77],
        [
          step(base_risk(1.4), fact("epidemic-policy.pl", clause(5)), [], []),
          step(vaccination_factor(vaccination_campaign, 0.55), fact("epidemic-policy.pl", clause(7)), [], []),
          step(mask_factor(vaccination_campaign, 1.0), fact("epidemic-policy.pl", clause(11)), [], []),
          step(is(0.77, *(1.4, 0.55)), builtin(is, 2), [], []),
          step(is(0.77, *(0.77, 1.0)), builtin(is, 2), [], [])
        ]
      )
    ]
  )
).

riskScore(indoor_masks, 0.9099999999999999).
why(
  riskScore(indoor_masks, 0.9099999999999999),
  step(
    riskScore(indoor_masks, 0.9099999999999999),
    rule("epidemic-policy.pl", clause(23)),
    ['P' = indoor_masks, 'R' = 0.9099999999999999],
    [
      step(
        risk_score(indoor_masks, 0.9099999999999999),
        rule("epidemic-policy.pl", clause(18)),
        ['P' = indoor_masks, 'R' = 0.9099999999999999, 'Base' = 1.4, 'Vf' = 1.0, 'Mf' = 0.65, 'A' = 1.4],
        [
          step(base_risk(1.4), fact("epidemic-policy.pl", clause(5)), [], []),
          step(vaccination_factor(indoor_masks, 1.0), fact("epidemic-policy.pl", clause(8)), [], []),
          step(mask_factor(indoor_masks, 0.65), fact("epidemic-policy.pl", clause(12)), [], []),
          step(is(1.4, *(1.4, 1.0)), builtin(is, 2), [], []),
          step(is(0.9099999999999999, *(1.4, 0.65)), builtin(is, 2), [], [])
        ]
      )
    ]
  )
).

riskScore(vaccination_and_masks, 0.5005000000000001).
why(
  riskScore(vaccination_and_masks, 0.5005000000000001),
  step(
    riskScore(vaccination_and_masks, 0.5005000000000001),
    rule("epidemic-policy.pl", clause(23)),
    ['P' = vaccination_and_masks, 'R' = 0.5005000000000001],
    [
      step(
        risk_score(vaccination_and_masks, 0.5005000000000001),
        rule("epidemic-policy.pl", clause(18)),
        ['P' = vaccination_and_masks, 'R' = 0.5005000000000001, 'Base' = 1.4, 'Vf' = 0.55, 'Mf' = 0.65, 'A' = 0.77],
        [
          step(base_risk(1.4), fact("epidemic-policy.pl", clause(5)), [], []),
          step(vaccination_factor(vaccination_and_masks, 0.55), fact("epidemic-policy.pl", clause(9)), [], []),
          step(mask_factor(vaccination_and_masks, 0.65), fact("epidemic-policy.pl", clause(13)), [], []),
          step(is(0.77, *(1.4, 0.55)), builtin(is, 2), [], []),
          step(is(0.5005000000000001, *(0.77, 0.65)), builtin(is, 2), [], [])
        ]
      )
    ]
  )
).

cost(no_mandate, 0).
why(
  cost(no_mandate, 0),
  step(
    cost(no_mandate, 0),
    rule("epidemic-policy.pl", clause(24)),
    ['P' = no_mandate, 'C' = 0],
    [
      step(policy_cost(no_mandate, 0), fact("epidemic-policy.pl", clause(14)), [], [])
    ]
  )
).

cost(vaccination_campaign, 3).
why(
  cost(vaccination_campaign, 3),
  step(
    cost(vaccination_campaign, 3),
    rule("epidemic-policy.pl", clause(24)),
    ['P' = vaccination_campaign, 'C' = 3],
    [
      step(policy_cost(vaccination_campaign, 3), fact("epidemic-policy.pl", clause(15)), [], [])
    ]
  )
).

cost(indoor_masks, 2).
why(
  cost(indoor_masks, 2),
  step(
    cost(indoor_masks, 2),
    rule("epidemic-policy.pl", clause(24)),
    ['P' = indoor_masks, 'C' = 2],
    [
      step(policy_cost(indoor_masks, 2), fact("epidemic-policy.pl", clause(16)), [], [])
    ]
  )
).

cost(vaccination_and_masks, 5).
why(
  cost(vaccination_and_masks, 5),
  step(
    cost(vaccination_and_masks, 5),
    rule("epidemic-policy.pl", clause(24)),
    ['P' = vaccination_and_masks, 'C' = 5],
    [
      step(policy_cost(vaccination_and_masks, 5), fact("epidemic-policy.pl", clause(17)), [], [])
    ]
  )
).

recommendedPolicy(epidemic_policy, vaccination_and_masks).
why(
  recommendedPolicy(epidemic_policy, vaccination_and_masks),
  step(
    recommendedPolicy(epidemic_policy, vaccination_and_masks),
    rule("epidemic-policy.pl", clause(25)),
    ['P' = vaccination_and_masks],
    [
      step(
        recommended(vaccination_and_masks),
        rule("epidemic-policy.pl", clause(22)),
        [],
        [
          step(
            acceptable(vaccination_and_masks),
            rule("epidemic-policy.pl", clause(19)),
            ['P' = vaccination_and_masks, 'R' = 0.5005000000000001],
            [
              step(
                risk_score(vaccination_and_masks, 0.5005000000000001),
                rule("epidemic-policy.pl", clause(18)),
                ['P' = vaccination_and_masks, 'R' = 0.5005000000000001, 'Base' = 1.4, 'Vf' = 0.55, 'Mf' = 0.65, 'A' = 0.77],
                [
                  step(base_risk(1.4), fact("epidemic-policy.pl", clause(5)), [], []),
                  step(vaccination_factor(vaccination_and_masks, 0.55), fact("epidemic-policy.pl", clause(9)), [], []),
                  step(mask_factor(vaccination_and_masks, 0.65), fact("epidemic-policy.pl", clause(13)), [], []),
                  step(is(0.77, *(1.4, 0.55)), builtin(is, 2), [], []),
                  step(is(0.5005000000000001, *(0.77, 0.65)), builtin(is, 2), [], [])
                ]
              ),
              step(=<(0.5005000000000001, 0.75), builtin(=<, 2), [], [])
            ]
          ),
          step(
            status(no_mandate, insufficient_control),
            rule("epidemic-policy.pl", clause(20)),
            ['P' = no_mandate, 'R' = 1.4],
            [
              step(policy(no_mandate), fact("epidemic-policy.pl", clause(1)), [], []),
              step(
                risk_score(no_mandate, 1.4),
                rule("epidemic-policy.pl", clause(18)),
                ['P' = no_mandate, 'R' = 1.4, 'Base' = 1.4, 'Vf' = 1.0, 'Mf' = 1.0, 'A' = 1.4],
                [
                  step(base_risk(1.4), fact("epidemic-policy.pl", clause(5)), [], []),
                  step(vaccination_factor(no_mandate, 1.0), fact("epidemic-policy.pl", clause(6)), [], []),
                  step(mask_factor(no_mandate, 1.0), fact("epidemic-policy.pl", clause(10)), [], []),
                  step(is(1.4, *(1.4, 1.0)), builtin(is, 2), [], []),
                  step(is(1.4, *(1.4, 1.0)), builtin(is, 2), [], [])
                ]
              ),
              step(>(1.4, 0.75), builtin(>, 2), [], [])
            ]
          ),
          step(
            status(vaccination_campaign, insufficient_control),
            rule("epidemic-policy.pl", clause(20)),
            ['P' = vaccination_campaign, 'R' = 0.77],
            [
              step(policy(vaccination_campaign), fact("epidemic-policy.pl", clause(2)), [], []),
              step(
                risk_score(vaccination_campaign, 0.77),
                rule("epidemic-policy.pl", clause(18)),
                ['P' = vaccination_campaign, 'R' = 0.77, 'Base' = 1.4, 'Vf' = 0.55, 'Mf' = 1.0, 'A' = 0.77],
                [
                  step(base_risk(1.4), fact("epidemic-policy.pl", clause(5)), [], []),
                  step(vaccination_factor(vaccination_campaign, 0.55), fact("epidemic-policy.pl", clause(7)), [], []),
                  step(mask_factor(vaccination_campaign, 1.0), fact("epidemic-policy.pl", clause(11)), [], []),
                  step(is(0.77, *(1.4, 0.55)), builtin(is, 2), [], []),
                  step(is(0.77, *(0.77, 1.0)), builtin(is, 2), [], [])
                ]
              ),
              step(>(0.77, 0.75), builtin(>, 2), [], [])
            ]
          ),
          step(
            status(indoor_masks, insufficient_control),
            rule("epidemic-policy.pl", clause(20)),
            ['P' = indoor_masks, 'R' = 0.9099999999999999],
            [
              step(policy(indoor_masks), fact("epidemic-policy.pl", clause(3)), [], []),
              step(
                risk_score(indoor_masks, 0.9099999999999999),
                rule("epidemic-policy.pl", clause(18)),
                ['P' = indoor_masks, 'R' = 0.9099999999999999, 'Base' = 1.4, 'Vf' = 1.0, 'Mf' = 0.65, 'A' = 1.4],
                [
                  step(base_risk(1.4), fact("epidemic-policy.pl", clause(5)), [], []),
                  step(vaccination_factor(indoor_masks, 1.0), fact("epidemic-policy.pl", clause(8)), [], []),
                  step(mask_factor(indoor_masks, 0.65), fact("epidemic-policy.pl", clause(12)), [], []),
                  step(is(1.4, *(1.4, 1.0)), builtin(is, 2), [], []),
                  step(is(0.9099999999999999, *(1.4, 0.65)), builtin(is, 2), [], [])
                ]
              ),
              step(>(0.9099999999999999, 0.75), builtin(>, 2), [], [])
            ]
          )
        ]
      )
    ]
  )
).

reason(epidemic_policy, "combined vaccination and indoor masks are the only policy below the outbreak threshold").
why(
  reason(epidemic_policy, "combined vaccination and indoor masks are the only policy below the outbreak threshold"),
  step(
    reason(epidemic_policy, "combined vaccination and indoor masks are the only policy below the outbreak threshold"),
    rule("epidemic-policy.pl", clause(26)),
    [],
    [
      step(
        recommended(vaccination_and_masks),
        rule("epidemic-policy.pl", clause(22)),
        [],
        [
          step(
            acceptable(vaccination_and_masks),
            rule("epidemic-policy.pl", clause(19)),
            ['P' = vaccination_and_masks, 'R' = 0.5005000000000001],
            [
              step(
                risk_score(vaccination_and_masks, 0.5005000000000001),
                rule("epidemic-policy.pl", clause(18)),
                ['P' = vaccination_and_masks, 'R' = 0.5005000000000001, 'Base' = 1.4, 'Vf' = 0.55, 'Mf' = 0.65, 'A' = 0.77],
                [
                  step(base_risk(1.4), fact("epidemic-policy.pl", clause(5)), [], []),
                  step(vaccination_factor(vaccination_and_masks, 0.55), fact("epidemic-policy.pl", clause(9)), [], []),
                  step(mask_factor(vaccination_and_masks, 0.65), fact("epidemic-policy.pl", clause(13)), [], []),
                  step(is(0.77, *(1.4, 0.55)), builtin(is, 2), [], []),
                  step(is(0.5005000000000001, *(0.77, 0.65)), builtin(is, 2), [], [])
                ]
              ),
              step(=<(0.5005000000000001, 0.75), builtin(=<, 2), [], [])
            ]
          ),
          step(
            status(no_mandate, insufficient_control),
            rule("epidemic-policy.pl", clause(20)),
            ['P' = no_mandate, 'R' = 1.4],
            [
              step(policy(no_mandate), fact("epidemic-policy.pl", clause(1)), [], []),
              step(
                risk_score(no_mandate, 1.4),
                rule("epidemic-policy.pl", clause(18)),
                ['P' = no_mandate, 'R' = 1.4, 'Base' = 1.4, 'Vf' = 1.0, 'Mf' = 1.0, 'A' = 1.4],
                [
                  step(base_risk(1.4), fact("epidemic-policy.pl", clause(5)), [], []),
                  step(vaccination_factor(no_mandate, 1.0), fact("epidemic-policy.pl", clause(6)), [], []),
                  step(mask_factor(no_mandate, 1.0), fact("epidemic-policy.pl", clause(10)), [], []),
                  step(is(1.4, *(1.4, 1.0)), builtin(is, 2), [], []),
                  step(is(1.4, *(1.4, 1.0)), builtin(is, 2), [], [])
                ]
              ),
              step(>(1.4, 0.75), builtin(>, 2), [], [])
            ]
          ),
          step(
            status(vaccination_campaign, insufficient_control),
            rule("epidemic-policy.pl", clause(20)),
            ['P' = vaccination_campaign, 'R' = 0.77],
            [
              step(policy(vaccination_campaign), fact("epidemic-policy.pl", clause(2)), [], []),
              step(
                risk_score(vaccination_campaign, 0.77),
                rule("epidemic-policy.pl", clause(18)),
                ['P' = vaccination_campaign, 'R' = 0.77, 'Base' = 1.4, 'Vf' = 0.55, 'Mf' = 1.0, 'A' = 0.77],
                [
                  step(base_risk(1.4), fact("epidemic-policy.pl", clause(5)), [], []),
                  step(vaccination_factor(vaccination_campaign, 0.55), fact("epidemic-policy.pl", clause(7)), [], []),
                  step(mask_factor(vaccination_campaign, 1.0), fact("epidemic-policy.pl", clause(11)), [], []),
                  step(is(0.77, *(1.4, 0.55)), builtin(is, 2), [], []),
                  step(is(0.77, *(0.77, 1.0)), builtin(is, 2), [], [])
                ]
              ),
              step(>(0.77, 0.75), builtin(>, 2), [], [])
            ]
          ),
          step(
            status(indoor_masks, insufficient_control),
            rule("epidemic-policy.pl", clause(20)),
            ['P' = indoor_masks, 'R' = 0.9099999999999999],
            [
              step(policy(indoor_masks), fact("epidemic-policy.pl", clause(3)), [], []),
              step(
                risk_score(indoor_masks, 0.9099999999999999),
                rule("epidemic-policy.pl", clause(18)),
                ['P' = indoor_masks, 'R' = 0.9099999999999999, 'Base' = 1.4, 'Vf' = 1.0, 'Mf' = 0.65, 'A' = 1.4],
                [
                  step(base_risk(1.4), fact("epidemic-policy.pl", clause(5)), [], []),
                  step(vaccination_factor(indoor_masks, 1.0), fact("epidemic-policy.pl", clause(8)), [], []),
                  step(mask_factor(indoor_masks, 0.65), fact("epidemic-policy.pl", clause(12)), [], []),
                  step(is(1.4, *(1.4, 1.0)), builtin(is, 2), [], []),
                  step(is(0.9099999999999999, *(1.4, 0.65)), builtin(is, 2), [], [])
                ]
              ),
              step(>(0.9099999999999999, 0.75), builtin(>, 2), [], [])
            ]
          )
        ]
      )
    ]
  )
).

