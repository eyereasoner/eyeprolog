status(test1, policy_passed).
reason(test1, "all required claims are present, one allowed claim is present, and no forbidden claim is present").

clause(1, policy_request(test1, policy_x), true).
clause(4, has(test1, claim_c), true).
clause(5, policy(policy_x), true).
clause(8, anyOf(policy_x, claim_c), true).
clause(10,
       passes_all_of(var('Request'), var('Policy')),
       (policy_request(var('Request'), var('Policy')),
        policy(var('Policy')),
        \+ (allOf(var('Policy'), var('Claim')), \+ has(var('Request'), var('Claim'))))).
clause(11,
       passes_any_of(var('Request'), var('Policy')),
       (policy_request(var('Request'), var('Policy')),
        policy(var('Policy')),
        anyOf(var('Policy'), var('Claim')),
        has(var('Request'), var('Claim')))).
clause(12,
       passes_none_of(var('Request'), var('Policy')),
       (policy_request(var('Request'), var('Policy')),
        policy(var('Policy')),
        \+ (noneOf(var('Policy'), var('Claim')), has(var('Request'), var('Claim'))))).
clause(13,
       passes_policy(var('Request'), var('Policy')),
       (passes_all_of(var('Request'), var('Policy')),
        passes_any_of(var('Request'), var('Policy')),
        passes_none_of(var('Request'), var('Policy')))).
clause(15, status(test1, policy_passed), passes_policy(test1, policy_x)).
clause(16,
       reason(test1, "all required claims are present, one allowed claim is present, and no forbidden claim is present"),
       passes_policy(test1, policy_x)).

step(status(test1, policy_passed), rule(15), [], [passes_policy(test1, policy_x)]).
step(passes_policy(test1, policy_x),
     rule(13),
     ['Request' = test1, 'Policy' = policy_x],
     [passes_all_of(test1, policy_x),
      passes_any_of(test1, policy_x),
      passes_none_of(test1, policy_x)]).
step(passes_all_of(test1, policy_x),
     rule(10),
     ['Request' = test1, 'Policy' = policy_x],
     [policy_request(test1, policy_x),
      policy(policy_x),
      \+ (allOf(policy_x, Claim), \+ has(test1, Claim))]).
step(policy_request(test1, policy_x), fact(1), [], []).
step(policy(policy_x), fact(5), [], []).
step(\+ (allOf(policy_x, Claim), \+ has(test1, Claim)), absent, [], []).
step(passes_any_of(test1, policy_x),
     rule(11),
     ['Request' = test1, 'Policy' = policy_x, 'Claim' = claim_c],
     [policy_request(test1, policy_x),
      policy(policy_x),
      anyOf(policy_x, claim_c),
      has(test1, claim_c)]).
step(anyOf(policy_x, claim_c), fact(8), [], []).
step(has(test1, claim_c), fact(4), [], []).
step(passes_none_of(test1, policy_x),
     rule(12),
     ['Request' = test1, 'Policy' = policy_x],
     [policy_request(test1, policy_x),
      policy(policy_x),
      \+ (noneOf(policy_x, Claim), has(test1, Claim))]).
step(\+ (noneOf(policy_x, Claim), has(test1, Claim)), absent, [], []).
step(reason(test1, "all required claims are present, one allowed claim is present, and no forbidden claim is present"),
     rule(16),
     [],
     [passes_policy(test1, policy_x)]).
