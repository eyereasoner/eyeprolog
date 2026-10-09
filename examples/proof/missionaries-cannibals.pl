missionaries_cannibals_answer(first_solution, [state(3, 3, left), state(3, 1, right), state(3, 2, left), state(3, 0, right), state(3, 1, left), state(1, 1, right), state(2, 2, left), state(0, 2, right), state(0, 3, left), state(0, 1, right), state(1, 1, left), state(0, 0, right)]).
missionaries_cannibals_answer(state_count, 10).
missionaries_cannibals_answer(step_count, 11).

clause(1, move(1, 0), true).
clause(2, move(0, 1), true).
clause(3, move(2, 0), true).
clause(4, move(0, 2), true).
clause(5, move(1, 1), true).
clause(6, bank_safe(0, anonymous(1)), true).
clause(7, bank_safe(var('M'), var('C')), (var('M') > 0, var('M') >= var('C'))).
clause(8,
       state_safe(state(var('Mleft'), var('Cleft'), anonymous(1))),
       (between(0, 3, var('Mleft')),
        between(0, 3, var('Cleft')),
        var('Mright') is 3 - var('Mleft'),
        var('Cright') is 3 - var('Cleft'),
        bank_safe(var('Mleft'), var('Cleft')),
        bank_safe(var('Mright'), var('Cright')))).
clause(9,
       crossing(state(var('Mleft'), var('Cleft'), left), state(var('Nextm'), var('Nextc'), right), carry(var('Movem'), var('Movec'))),
       (move(var('Movem'), var('Movec')),
        var('Nextm') is var('Mleft') - var('Movem'),
        var('Nextc') is var('Cleft') - var('Movec'),
        state_safe(state(var('Nextm'), var('Nextc'), right)))).
clause(10,
       crossing(state(var('Mleft'), var('Cleft'), right), state(var('Nextm'), var('Nextc'), left), carry(var('Movem'), var('Movec'))),
       (move(var('Movem'), var('Movec')),
        var('Nextm') is var('Mleft') + var('Movem'),
        var('Nextc') is var('Cleft') + var('Movec'),
        state_safe(state(var('Nextm'), var('Nextc'), left)))).
clause(11, journey(var('Goal'), var('Goal'), var('Visited'), var('Visited')), true).
clause(12,
       journey(var('State'), var('Goal'), var('Visited'), var('Path')),
       (crossing(var('State'), var('Next'), anonymous(1)),
        \+ member(var('Next'), var('Visited')),
        journey(var('Next'), var('Goal'), [var('Next') | var('Visited')], var('Path')))).
clause(13,
       solution(var('Path')),
       (journey(state(3, 3, left), state(0, 0, right), [state(3, 3, left)], var('Reversepath')),
        reverse(var('Reversepath'), var('Path')))).
clause(14,
       missionaries_cannibals_answer(first_solution, var('Path')),
       once(solution(var('Path')))).
clause(15,
       missionaries_cannibals_answer(state_count, var('Count')),
       countall(state_safe(state(anonymous(1), anonymous(2), anonymous(3))), var('Count'))).
clause(16,
       missionaries_cannibals_answer(step_count, var('Steps')),
       (once(solution(var('Path'))),
        length(var('Path'), var('States')),
        var('Steps') is var('States') - 1)).

step(missionaries_cannibals_answer(first_solution, [state(3, 3, left), state(3, 1, right), state(3, 2, left), state(3, 0, right), state(3, 1, left), state(1, 1, right), state(2, 2, left), state(0, 2, right), state(0, 3, left), state(0, 1, right), state(1, 1, left), state(0, 0, right)]),
     rule(14),
     ['Path' = [state(3, 3, left), state(3, 1, right), state(3, 2, left), state(3, 0, right), state(3, 1, left), state(1, 1, right), state(2, 2, left), state(0, 2, right), state(0, 3, left), state(0, 1, right), state(1, 1, left), state(0, 0, right)]],
     [once(solution([state(3, 3, left), state(3, 1, right), state(3, 2, left), state(3, 0, right), state(3, 1, left), state(1, 1, right), state(2, 2, left), state(0, 2, right), state(0, 3, left), state(0, 1, right), state(1, 1, left), state(0, 0, right)]))]).
step(once(solution([state(3, 3, left), state(3, 1, right), state(3, 2, left), state(3, 0, right), state(3, 1, left), state(1, 1, right), state(2, 2, left), state(0, 2, right), state(0, 3, left), state(0, 1, right), state(1, 1, left), state(0, 0, right)])),
     control,
     [],
     [solution([state(3, 3, left), state(3, 1, right), state(3, 2, left), state(3, 0, right), state(3, 1, left), state(1, 1, right), state(2, 2, left), state(0, 2, right), state(0, 3, left), state(0, 1, right), state(1, 1, left), state(0, 0, right)])]).
step(solution([state(3, 3, left), state(3, 1, right), state(3, 2, left), state(3, 0, right), state(3, 1, left), state(1, 1, right), state(2, 2, left), state(0, 2, right), state(0, 3, left), state(0, 1, right), state(1, 1, left), state(0, 0, right)]),
     rule(13),
     ['Path' = [state(3, 3, left), state(3, 1, right), state(3, 2, left), state(3, 0, right), state(3, 1, left), state(1, 1, right), state(2, 2, left), state(0, 2, right), state(0, 3, left), state(0, 1, right), state(1, 1, left), state(0, 0, right)],
      'Reversepath' = [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]],
     [journey(state(3, 3, left), state(0, 0, right), [state(3, 3, left)], [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
      reverse([state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)], [state(3, 3, left), state(3, 1, right), state(3, 2, left), state(3, 0, right), state(3, 1, left), state(1, 1, right), state(2, 2, left), state(0, 2, right), state(0, 3, left), state(0, 1, right), state(1, 1, left), state(0, 0, right)])]).
step(journey(state(3, 3, left), state(0, 0, right), [state(3, 3, left)], [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
     rule(12),
     ['State' = state(3, 3, left),
      'Goal' = state(0, 0, right),
      'Visited' = [state(3, 3, left)],
      'Path' = [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)],
      'Next' = state(3, 1, right)],
     [crossing(state(3, 3, left), state(3, 1, right), carry(0, 2)),
      \+ member(state(3, 1, right), [state(3, 3, left)]),
      journey(state(3, 1, right), state(0, 0, right), [state(3, 1, right), state(3, 3, left)], [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)])]).
step(crossing(state(3, 3, left), state(3, 1, right), carry(0, 2)),
     rule(9),
     ['Mleft' = 3, 'Cleft' = 3, 'Nextm' = 3, 'Nextc' = 1, 'Movem' = 0, 'Movec' = 2],
     [move(0, 2), 3 is 3 - 0, 1 is 3 - 2, state_safe(state(3, 1, right))]).
step(move(0, 2), fact(4), [], []).
step(3 is 3 - 0, builtin, [], []).
step(1 is 3 - 2, builtin, [], []).
step(state_safe(state(3, 1, right)),
     rule(8),
     ['Mleft' = 3, 'Cleft' = 1, 'Mright' = 0, 'Cright' = 2],
     [between(0, 3, 3),
      between(0, 3, 1),
      0 is 3 - 3,
      2 is 3 - 1,
      bank_safe(3, 1),
      bank_safe(0, 2)]).
step(between(0, 3, 3), builtin, [], []).
step(between(0, 3, 1), builtin, [], []).
step(0 is 3 - 3, builtin, [], []).
step(2 is 3 - 1, builtin, [], []).
step(bank_safe(3, 1), rule(7), ['M' = 3, 'C' = 1], [3 > 0, 3 >= 1]).
step(3 > 0, builtin, [], []).
step(3 >= 1, builtin, [], []).
step(bank_safe(0, 2), fact(6), [], []).
step(\+ member(state(3, 1, right), [state(3, 3, left)]), absent, [], []).
step(journey(state(3, 1, right), state(0, 0, right), [state(3, 1, right), state(3, 3, left)], [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
     rule(12),
     ['State' = state(3, 1, right),
      'Goal' = state(0, 0, right),
      'Visited' = [state(3, 1, right), state(3, 3, left)],
      'Path' = [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)],
      'Next' = state(3, 2, left)],
     [crossing(state(3, 1, right), state(3, 2, left), carry(0, 1)),
      \+ member(state(3, 2, left), [state(3, 1, right), state(3, 3, left)]),
      journey(state(3, 2, left), state(0, 0, right), [state(3, 2, left), state(3, 1, right), state(3, 3, left)], [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)])]).
step(crossing(state(3, 1, right), state(3, 2, left), carry(0, 1)),
     rule(10),
     ['Mleft' = 3, 'Cleft' = 1, 'Nextm' = 3, 'Nextc' = 2, 'Movem' = 0, 'Movec' = 1],
     [move(0, 1), 3 is 3 + 0, 2 is 1 + 1, state_safe(state(3, 2, left))]).
step(move(0, 1), fact(2), [], []).
step(3 is 3 + 0, builtin, [], []).
step(2 is 1 + 1, builtin, [], []).
step(state_safe(state(3, 2, left)),
     rule(8),
     ['Mleft' = 3, 'Cleft' = 2, 'Mright' = 0, 'Cright' = 1],
     [between(0, 3, 3),
      between(0, 3, 2),
      0 is 3 - 3,
      1 is 3 - 2,
      bank_safe(3, 2),
      bank_safe(0, 1)]).
step(between(0, 3, 2), builtin, [], []).
step(bank_safe(3, 2), rule(7), ['M' = 3, 'C' = 2], [3 > 0, 3 >= 2]).
step(3 >= 2, builtin, [], []).
step(bank_safe(0, 1), fact(6), [], []).
step(\+ member(state(3, 2, left), [state(3, 1, right), state(3, 3, left)]), absent, [], []).
step(journey(state(3, 2, left), state(0, 0, right), [state(3, 2, left), state(3, 1, right), state(3, 3, left)], [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
     rule(12),
     ['State' = state(3, 2, left),
      'Goal' = state(0, 0, right),
      'Visited' = [state(3, 2, left), state(3, 1, right), state(3, 3, left)],
      'Path' = [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)],
      'Next' = state(3, 0, right)],
     [crossing(state(3, 2, left), state(3, 0, right), carry(0, 2)),
      \+ member(state(3, 0, right), [state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
      journey(state(3, 0, right), state(0, 0, right), [state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)], [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)])]).
step(crossing(state(3, 2, left), state(3, 0, right), carry(0, 2)),
     rule(9),
     ['Mleft' = 3, 'Cleft' = 2, 'Nextm' = 3, 'Nextc' = 0, 'Movem' = 0, 'Movec' = 2],
     [move(0, 2), 3 is 3 - 0, 0 is 2 - 2, state_safe(state(3, 0, right))]).
step(0 is 2 - 2, builtin, [], []).
step(state_safe(state(3, 0, right)),
     rule(8),
     ['Mleft' = 3, 'Cleft' = 0, 'Mright' = 0, 'Cright' = 3],
     [between(0, 3, 3),
      between(0, 3, 0),
      0 is 3 - 3,
      3 is 3 - 0,
      bank_safe(3, 0),
      bank_safe(0, 3)]).
step(between(0, 3, 0), builtin, [], []).
step(bank_safe(3, 0), rule(7), ['M' = 3, 'C' = 0], [3 > 0, 3 >= 0]).
step(3 >= 0, builtin, [], []).
step(bank_safe(0, 3), fact(6), [], []).
step(\+ member(state(3, 0, right), [state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
     absent,
     [],
     []).
step(journey(state(3, 0, right), state(0, 0, right), [state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)], [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
     rule(12),
     ['State' = state(3, 0, right),
      'Goal' = state(0, 0, right),
      'Visited' = [state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)],
      'Path' = [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)],
      'Next' = state(3, 1, left)],
     [crossing(state(3, 0, right), state(3, 1, left), carry(0, 1)),
      \+ member(state(3, 1, left), [state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
      journey(state(3, 1, left), state(0, 0, right), [state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)], [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)])]).
step(crossing(state(3, 0, right), state(3, 1, left), carry(0, 1)),
     rule(10),
     ['Mleft' = 3, 'Cleft' = 0, 'Nextm' = 3, 'Nextc' = 1, 'Movem' = 0, 'Movec' = 1],
     [move(0, 1), 3 is 3 + 0, 1 is 0 + 1, state_safe(state(3, 1, left))]).
step(1 is 0 + 1, builtin, [], []).
step(state_safe(state(3, 1, left)),
     rule(8),
     ['Mleft' = 3, 'Cleft' = 1, 'Mright' = 0, 'Cright' = 2],
     [between(0, 3, 3),
      between(0, 3, 1),
      0 is 3 - 3,
      2 is 3 - 1,
      bank_safe(3, 1),
      bank_safe(0, 2)]).
step(\+ member(state(3, 1, left), [state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
     absent,
     [],
     []).
step(journey(state(3, 1, left), state(0, 0, right), [state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)], [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
     rule(12),
     ['State' = state(3, 1, left),
      'Goal' = state(0, 0, right),
      'Visited' = [state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)],
      'Path' = [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)],
      'Next' = state(1, 1, right)],
     [crossing(state(3, 1, left), state(1, 1, right), carry(2, 0)),
      \+ member(state(1, 1, right), [state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
      journey(state(1, 1, right), state(0, 0, right), [state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)], [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)])]).
step(crossing(state(3, 1, left), state(1, 1, right), carry(2, 0)),
     rule(9),
     ['Mleft' = 3, 'Cleft' = 1, 'Nextm' = 1, 'Nextc' = 1, 'Movem' = 2, 'Movec' = 0],
     [move(2, 0), 1 is 3 - 2, 1 is 1 - 0, state_safe(state(1, 1, right))]).
step(move(2, 0), fact(3), [], []).
step(1 is 1 - 0, builtin, [], []).
step(state_safe(state(1, 1, right)),
     rule(8),
     ['Mleft' = 1, 'Cleft' = 1, 'Mright' = 2, 'Cright' = 2],
     [between(0, 3, 1),
      between(0, 3, 1),
      2 is 3 - 1,
      2 is 3 - 1,
      bank_safe(1, 1),
      bank_safe(2, 2)]).
step(bank_safe(1, 1), rule(7), ['M' = 1, 'C' = 1], [1 > 0, 1 >= 1]).
step(1 > 0, builtin, [], []).
step(1 >= 1, builtin, [], []).
step(bank_safe(2, 2), rule(7), ['M' = 2, 'C' = 2], [2 > 0, 2 >= 2]).
step(2 > 0, builtin, [], []).
step(2 >= 2, builtin, [], []).
step(\+ member(state(1, 1, right), [state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
     absent,
     [],
     []).
step(journey(state(1, 1, right), state(0, 0, right), [state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)], [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
     rule(12),
     ['State' = state(1, 1, right),
      'Goal' = state(0, 0, right),
      'Visited' = [state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)],
      'Path' = [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)],
      'Next' = state(2, 2, left)],
     [crossing(state(1, 1, right), state(2, 2, left), carry(1, 1)),
      \+ member(state(2, 2, left), [state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
      journey(state(2, 2, left), state(0, 0, right), [state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)], [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)])]).
step(crossing(state(1, 1, right), state(2, 2, left), carry(1, 1)),
     rule(10),
     ['Mleft' = 1, 'Cleft' = 1, 'Nextm' = 2, 'Nextc' = 2, 'Movem' = 1, 'Movec' = 1],
     [move(1, 1), 2 is 1 + 1, 2 is 1 + 1, state_safe(state(2, 2, left))]).
step(move(1, 1), fact(5), [], []).
step(state_safe(state(2, 2, left)),
     rule(8),
     ['Mleft' = 2, 'Cleft' = 2, 'Mright' = 1, 'Cright' = 1],
     [between(0, 3, 2),
      between(0, 3, 2),
      1 is 3 - 2,
      1 is 3 - 2,
      bank_safe(2, 2),
      bank_safe(1, 1)]).
step(\+ member(state(2, 2, left), [state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
     absent,
     [],
     []).
step(journey(state(2, 2, left), state(0, 0, right), [state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)], [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
     rule(12),
     ['State' = state(2, 2, left),
      'Goal' = state(0, 0, right),
      'Visited' = [state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)],
      'Path' = [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)],
      'Next' = state(0, 2, right)],
     [crossing(state(2, 2, left), state(0, 2, right), carry(2, 0)),
      \+ member(state(0, 2, right), [state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
      journey(state(0, 2, right), state(0, 0, right), [state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)], [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)])]).
step(crossing(state(2, 2, left), state(0, 2, right), carry(2, 0)),
     rule(9),
     ['Mleft' = 2, 'Cleft' = 2, 'Nextm' = 0, 'Nextc' = 2, 'Movem' = 2, 'Movec' = 0],
     [move(2, 0), 0 is 2 - 2, 2 is 2 - 0, state_safe(state(0, 2, right))]).
step(2 is 2 - 0, builtin, [], []).
step(state_safe(state(0, 2, right)),
     rule(8),
     ['Mleft' = 0, 'Cleft' = 2, 'Mright' = 3, 'Cright' = 1],
     [between(0, 3, 0),
      between(0, 3, 2),
      3 is 3 - 0,
      1 is 3 - 2,
      bank_safe(0, 2),
      bank_safe(3, 1)]).
step(\+ member(state(0, 2, right), [state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
     absent,
     [],
     []).
step(journey(state(0, 2, right), state(0, 0, right), [state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)], [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
     rule(12),
     ['State' = state(0, 2, right),
      'Goal' = state(0, 0, right),
      'Visited' = [state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)],
      'Path' = [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)],
      'Next' = state(0, 3, left)],
     [crossing(state(0, 2, right), state(0, 3, left), carry(0, 1)),
      \+ member(state(0, 3, left), [state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
      journey(state(0, 3, left), state(0, 0, right), [state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)], [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)])]).
step(crossing(state(0, 2, right), state(0, 3, left), carry(0, 1)),
     rule(10),
     ['Mleft' = 0, 'Cleft' = 2, 'Nextm' = 0, 'Nextc' = 3, 'Movem' = 0, 'Movec' = 1],
     [move(0, 1), 0 is 0 + 0, 3 is 2 + 1, state_safe(state(0, 3, left))]).
step(0 is 0 + 0, builtin, [], []).
step(3 is 2 + 1, builtin, [], []).
step(state_safe(state(0, 3, left)),
     rule(8),
     ['Mleft' = 0, 'Cleft' = 3, 'Mright' = 3, 'Cright' = 0],
     [between(0, 3, 0),
      between(0, 3, 3),
      3 is 3 - 0,
      0 is 3 - 3,
      bank_safe(0, 3),
      bank_safe(3, 0)]).
step(\+ member(state(0, 3, left), [state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
     absent,
     [],
     []).
step(journey(state(0, 3, left), state(0, 0, right), [state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)], [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
     rule(12),
     ['State' = state(0, 3, left),
      'Goal' = state(0, 0, right),
      'Visited' = [state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)],
      'Path' = [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)],
      'Next' = state(0, 1, right)],
     [crossing(state(0, 3, left), state(0, 1, right), carry(0, 2)),
      \+ member(state(0, 1, right), [state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
      journey(state(0, 1, right), state(0, 0, right), [state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)], [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)])]).
step(crossing(state(0, 3, left), state(0, 1, right), carry(0, 2)),
     rule(9),
     ['Mleft' = 0, 'Cleft' = 3, 'Nextm' = 0, 'Nextc' = 1, 'Movem' = 0, 'Movec' = 2],
     [move(0, 2), 0 is 0 - 0, 1 is 3 - 2, state_safe(state(0, 1, right))]).
step(0 is 0 - 0, builtin, [], []).
step(state_safe(state(0, 1, right)),
     rule(8),
     ['Mleft' = 0, 'Cleft' = 1, 'Mright' = 3, 'Cright' = 2],
     [between(0, 3, 0),
      between(0, 3, 1),
      3 is 3 - 0,
      2 is 3 - 1,
      bank_safe(0, 1),
      bank_safe(3, 2)]).
step(\+ member(state(0, 1, right), [state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
     absent,
     [],
     []).
step(journey(state(0, 1, right), state(0, 0, right), [state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)], [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
     rule(12),
     ['State' = state(0, 1, right),
      'Goal' = state(0, 0, right),
      'Visited' = [state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)],
      'Path' = [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)],
      'Next' = state(1, 1, left)],
     [crossing(state(0, 1, right), state(1, 1, left), carry(1, 0)),
      \+ member(state(1, 1, left), [state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
      journey(state(1, 1, left), state(0, 0, right), [state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)], [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)])]).
step(crossing(state(0, 1, right), state(1, 1, left), carry(1, 0)),
     rule(10),
     ['Mleft' = 0, 'Cleft' = 1, 'Nextm' = 1, 'Nextc' = 1, 'Movem' = 1, 'Movec' = 0],
     [move(1, 0), 1 is 0 + 1, 1 is 1 + 0, state_safe(state(1, 1, left))]).
step(move(1, 0), fact(1), [], []).
step(1 is 1 + 0, builtin, [], []).
step(state_safe(state(1, 1, left)),
     rule(8),
     ['Mleft' = 1, 'Cleft' = 1, 'Mright' = 2, 'Cright' = 2],
     [between(0, 3, 1),
      between(0, 3, 1),
      2 is 3 - 1,
      2 is 3 - 1,
      bank_safe(1, 1),
      bank_safe(2, 2)]).
step(\+ member(state(1, 1, left), [state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
     absent,
     [],
     []).
step(journey(state(1, 1, left), state(0, 0, right), [state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)], [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
     rule(12),
     ['State' = state(1, 1, left),
      'Goal' = state(0, 0, right),
      'Visited' = [state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)],
      'Path' = [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)],
      'Next' = state(0, 0, right)],
     [crossing(state(1, 1, left), state(0, 0, right), carry(1, 1)),
      \+ member(state(0, 0, right), [state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
      journey(state(0, 0, right), state(0, 0, right), [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)], [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)])]).
step(crossing(state(1, 1, left), state(0, 0, right), carry(1, 1)),
     rule(9),
     ['Mleft' = 1, 'Cleft' = 1, 'Nextm' = 0, 'Nextc' = 0, 'Movem' = 1, 'Movec' = 1],
     [move(1, 1), 0 is 1 - 1, 0 is 1 - 1, state_safe(state(0, 0, right))]).
step(0 is 1 - 1, builtin, [], []).
step(state_safe(state(0, 0, right)),
     rule(8),
     ['Mleft' = 0, 'Cleft' = 0, 'Mright' = 3, 'Cright' = 3],
     [between(0, 3, 0),
      between(0, 3, 0),
      3 is 3 - 0,
      3 is 3 - 0,
      bank_safe(0, 0),
      bank_safe(3, 3)]).
step(bank_safe(0, 0), fact(6), [], []).
step(bank_safe(3, 3), rule(7), ['M' = 3, 'C' = 3], [3 > 0, 3 >= 3]).
step(3 >= 3, builtin, [], []).
step(\+ member(state(0, 0, right), [state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
     absent,
     [],
     []).
step(journey(state(0, 0, right), state(0, 0, right), [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)], [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]),
     fact(11),
     ['Goal' = state(0, 0, right),
      'Visited' = [state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)]],
     []).
step(reverse([state(0, 0, right), state(1, 1, left), state(0, 1, right), state(0, 3, left), state(0, 2, right), state(2, 2, left), state(1, 1, right), state(3, 1, left), state(3, 0, right), state(3, 2, left), state(3, 1, right), state(3, 3, left)], [state(3, 3, left), state(3, 1, right), state(3, 2, left), state(3, 0, right), state(3, 1, left), state(1, 1, right), state(2, 2, left), state(0, 2, right), state(0, 3, left), state(0, 1, right), state(1, 1, left), state(0, 0, right)]),
     builtin,
     [],
     []).
step(missionaries_cannibals_answer(state_count, 10),
     rule(15),
     ['Count' = 10],
     [countall(state_safe(state(_m, _c, _boat)), 10)]).
step(countall(state_safe(state(_m, _c, _boat)), 10), builtin, [], []).
step(missionaries_cannibals_answer(step_count, 11),
     rule(16),
     ['Steps' = 11,
      'Path' = [state(3, 3, left), state(3, 1, right), state(3, 2, left), state(3, 0, right), state(3, 1, left), state(1, 1, right), state(2, 2, left), state(0, 2, right), state(0, 3, left), state(0, 1, right), state(1, 1, left), state(0, 0, right)],
      'States' = 12],
     [once(solution([state(3, 3, left), state(3, 1, right), state(3, 2, left), state(3, 0, right), state(3, 1, left), state(1, 1, right), state(2, 2, left), state(0, 2, right), state(0, 3, left), state(0, 1, right), state(1, 1, left), state(0, 0, right)])),
      length([state(3, 3, left), state(3, 1, right), state(3, 2, left), state(3, 0, right), state(3, 1, left), state(1, 1, right), state(2, 2, left), state(0, 2, right), state(0, 3, left), state(0, 1, right), state(1, 1, left), state(0, 0, right)], 12),
      11 is 12 - 1]).
step(length([state(3, 3, left), state(3, 1, right), state(3, 2, left), state(3, 0, right), state(3, 1, left), state(1, 1, right), state(2, 2, left), state(0, 2, right), state(0, 3, left), state(0, 1, right), state(1, 1, left), state(0, 0, right)], 12),
     builtin,
     [],
     []).
step(11 is 12 - 1, builtin, [], []).
