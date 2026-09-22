status(test1, policy_passed).
why(
  status(test1, policy_passed),
  step(
    status(test1, policy_passed),
    rule("access-control-policy.pl", clause(15)),
    [],
    [
      step(
        passes_policy(test1, policy_x),
        rule("access-control-policy.pl", clause(13)),
        ['Request' = test1, 'Policy' = policy_x],
        [
          step(
            passes_all_of(test1, policy_x),
            rule("access-control-policy.pl", clause(10)),
            ['Request' = test1, 'Policy' = policy_x],
            [
              step(policy_request(test1, policy_x), fact("access-control-policy.pl", clause(1)), [], []),
              step(policy(policy_x), fact("access-control-policy.pl", clause(5)), [], []),
              step('\\+'((allOf(policy_x, Claim), '\\+'(has(test1, Claim)))), builtin('\\+', 1), [], [])
            ]
          ),
          step(
            passes_any_of(test1, policy_x),
            rule("access-control-policy.pl", clause(11)),
            ['Request' = test1, 'Policy' = policy_x, 'Claim' = claim_c],
            [
              step(policy_request(test1, policy_x), fact("access-control-policy.pl", clause(1)), [], []),
              step(policy(policy_x), fact("access-control-policy.pl", clause(5)), [], []),
              step(anyOf(policy_x, claim_c), fact("access-control-policy.pl", clause(8)), [], []),
              step(has(test1, claim_c), fact("access-control-policy.pl", clause(4)), [], [])
            ]
          ),
          step(
            passes_none_of(test1, policy_x),
            rule("access-control-policy.pl", clause(12)),
            ['Request' = test1, 'Policy' = policy_x],
            [
              step(policy_request(test1, policy_x), fact("access-control-policy.pl", clause(1)), [], []),
              step(policy(policy_x), fact("access-control-policy.pl", clause(5)), [], []),
              step('\\+'((noneOf(policy_x, Claim), has(test1, Claim))), builtin('\\+', 1), [], [])
            ]
          )
        ]
      )
    ]
  )
).

reason(test1, "all required claims are present, one allowed claim is present, and no forbidden claim is present").
why(
  reason(test1, "all required claims are present, one allowed claim is present, and no forbidden claim is present"),
  step(
    reason(test1, "all required claims are present, one allowed claim is present, and no forbidden claim is present"),
    rule("access-control-policy.pl", clause(16)),
    [],
    [
      step(
        passes_policy(test1, policy_x),
        rule("access-control-policy.pl", clause(13)),
        ['Request' = test1, 'Policy' = policy_x],
        [
          step(
            passes_all_of(test1, policy_x),
            rule("access-control-policy.pl", clause(10)),
            ['Request' = test1, 'Policy' = policy_x],
            [
              step(policy_request(test1, policy_x), fact("access-control-policy.pl", clause(1)), [], []),
              step(policy(policy_x), fact("access-control-policy.pl", clause(5)), [], []),
              step('\\+'((allOf(policy_x, Claim), '\\+'(has(test1, Claim)))), builtin('\\+', 1), [], [])
            ]
          ),
          step(
            passes_any_of(test1, policy_x),
            rule("access-control-policy.pl", clause(11)),
            ['Request' = test1, 'Policy' = policy_x, 'Claim' = claim_c],
            [
              step(policy_request(test1, policy_x), fact("access-control-policy.pl", clause(1)), [], []),
              step(policy(policy_x), fact("access-control-policy.pl", clause(5)), [], []),
              step(anyOf(policy_x, claim_c), fact("access-control-policy.pl", clause(8)), [], []),
              step(has(test1, claim_c), fact("access-control-policy.pl", clause(4)), [], [])
            ]
          ),
          step(
            passes_none_of(test1, policy_x),
            rule("access-control-policy.pl", clause(12)),
            ['Request' = test1, 'Policy' = policy_x],
            [
              step(policy_request(test1, policy_x), fact("access-control-policy.pl", clause(1)), [], []),
              step(policy(policy_x), fact("access-control-policy.pl", clause(5)), [], []),
              step('\\+'((noneOf(policy_x, Claim), has(test1, Claim))), builtin('\\+', 1), [], [])
            ]
          )
        ]
      )
    ]
  )
).

