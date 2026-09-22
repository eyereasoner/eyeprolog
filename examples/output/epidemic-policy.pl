% Prolog result format 4
query(1, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = no_mandate, 'X1' = insufficient_control]).
answer(1, ['X0' = vaccination_campaign, 'X1' = insufficient_control]).
answer(1, ['X0' = indoor_masks, 'X1' = insufficient_control]).
answer(1, ['X0' = vaccination_and_masks, 'X1' = acceptable_control]).
query(2, riskScore(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 4).
answer(2, ['X0' = no_mandate, 'X1' = 1.4]).
answer(2, ['X0' = vaccination_campaign, 'X1' = 0.77]).
answer(2, ['X0' = indoor_masks, 'X1' = 0.9099999999999999]).
answer(2, ['X0' = vaccination_and_masks, 'X1' = 0.5005000000000001]).
query(3, cost(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 4).
answer(3, ['X0' = no_mandate, 'X1' = 0]).
answer(3, ['X0' = vaccination_campaign, 'X1' = 3]).
answer(3, ['X0' = indoor_masks, 'X1' = 2]).
answer(3, ['X0' = vaccination_and_masks, 'X1' = 5]).
query(4, recommendedPolicy(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = epidemic_policy, 'X1' = vaccination_and_masks]).
query(5, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5,
       ['X0' = epidemic_policy,
        'X1' = "combined vaccination and indoor masks are the only policy below the outbreak threshold"]).
