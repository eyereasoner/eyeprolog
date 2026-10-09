status(blocks_world, planned).
plan(blocks_world, [move(e, d, table), move(d, c, table), move(c, b, table), move(d, table, c), move(e, table, d)]).
finalState(blocks_world, [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]).
blockCount(blocks_world, 5).

clause(1, initial([on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]), true).
clause(2, goal([on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]), true).
clause(5, block(c), true).
clause(6, block(d), true).
clause(8, support(table, anonymous(1)), true).
clause(9,
       support(var('Block'), var('State')),
       (block(var('Block')), member(on(var('Block'), anonymous(1)), var('State')))).
clause(10,
       clear(var('Block'), var('State')),
       \+ member(on(anonymous(1), var('Block')), var('State'))).
clause(11, clear_support(table, anonymous(1)), true).
clause(12,
       clear_support(var('Block'), var('State')),
       (block(var('Block')), clear(var('Block'), var('State')))).
clause(13,
       move(var('State'), move(var('Block'), var('From'), var('To')), var('Newstate')),
       (member(on(var('Block'), var('From')), var('State')),
        clear(var('Block'), var('State')),
        support(var('To'), var('State')),
        clear_support(var('To'), var('State')),
        var('Block') \= var('To'),
        var('From') \= var('To'),
        select(on(var('Block'), var('From')), var('State'), var('Rest')),
        sort([on(var('Block'), var('To')) | var('Rest')], var('Newstate')))).
clause(14,
       plan(var('State'), var('Goal'), 0, anonymous(1), [], var('State')),
       var('State') = var('Goal')).
clause(15,
       plan(var('State'), var('Goal'), var('Depth'), var('Visited'), [var('Move') | var('Moves')], var('Final')),
       (var('Depth') > 0,
        move(var('State'), var('Move'), var('Next')),
        \+ member(var('Next'), var('Visited')),
        var('Restdepth') is var('Depth') - 1,
        plan(var('Next'), var('Goal'), var('Restdepth'), [var('Next') | var('Visited')], var('Moves'), var('Final')))).
clause(16,
       five_move_plan(var('Moves'), var('Final')),
       (initial(var('Start')),
        goal(var('Goal')),
        sort(var('Start'), var('Sortedstart')),
        sort(var('Goal'), var('Sortedgoal')),
        plan(var('Sortedstart'), var('Sortedgoal'), 5, [var('Sortedstart')], var('Moves'), var('Final')))).
clause(17, status(blocks_world, planned), once(five_move_plan(anonymous(1), anonymous(2)))).
clause(18, plan(blocks_world, var('Moves')), once(five_move_plan(var('Moves'), anonymous(1)))).
clause(19,
       finalState(blocks_world, var('Final')),
       once(five_move_plan(anonymous(1), var('Final')))).
clause(20,
       blockCount(blocks_world, var('Count')),
       (findall(var('Block'), block(var('Block')), var('Blocks')),
        length(var('Blocks'), var('Count')))).

step(status(blocks_world, planned),
     rule(17),
     [],
     [once(five_move_plan([move(e, d, table), move(d, c, table), move(c, b, table), move(d, table, c), move(e, table, d)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]))]).
step(once(five_move_plan([move(e, d, table), move(d, c, table), move(c, b, table), move(d, table, c), move(e, table, d)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)])),
     control,
     [],
     [five_move_plan([move(e, d, table), move(d, c, table), move(c, b, table), move(d, table, c), move(e, table, d)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)])]).
step(five_move_plan([move(e, d, table), move(d, c, table), move(c, b, table), move(d, table, c), move(e, table, d)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]),
     rule(16),
     ['Moves' = [move(e, d, table), move(d, c, table), move(c, b, table), move(d, table, c), move(e, table, d)],
      'Final' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)],
      'Start' = [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)],
      'Goal' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)],
      'Sortedstart' = [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)],
      'Sortedgoal' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]],
     [initial([on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]),
      goal([on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]),
      sort([on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]),
      sort([on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]),
      plan([on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)], 5, [[on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]], [move(e, d, table), move(d, c, table), move(c, b, table), move(d, table, c), move(e, table, d)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)])]).
step(initial([on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]), fact(1), [], []).
step(goal([on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]), fact(2), [], []).
step(sort([on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]),
     builtin,
     [],
     []).
step(sort([on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]),
     builtin,
     [],
     []).
step(plan([on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)], 5, [[on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]], [move(e, d, table), move(d, c, table), move(c, b, table), move(d, table, c), move(e, table, d)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]),
     rule(15),
     ['State' = [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)],
      'Goal' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)],
      'Depth' = 5,
      'Visited' = [[on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]],
      'Move' = move(e, d, table),
      'Moves' = [move(d, c, table), move(c, b, table), move(d, table, c), move(e, table, d)],
      'Final' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)],
      'Next' = [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)],
      'Restdepth' = 4],
     [5 > 0,
      move([on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)], move(e, d, table), [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)]),
      \+ member([on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [[on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]]),
      4 is 5 - 1,
      plan([on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)], 4, [[on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]], [move(d, c, table), move(c, b, table), move(d, table, c), move(e, table, d)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)])]).
step(5 > 0, builtin, [], []).
step(move([on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)], move(e, d, table), [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)]),
     rule(13),
     ['State' = [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)],
      'Block' = e,
      'From' = d,
      'To' = (table),
      'Newstate' = [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)],
      'Rest' = [on(a, table), on(b, a), on(c, b), on(d, c)]],
     [member(on(e, d), [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]),
      clear(e, [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]),
      support(table, [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]),
      clear_support(table, [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]),
      e \= (table),
      d \= (table),
      select(on(e, d), [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)], [on(a, table), on(b, a), on(c, b), on(d, c)]),
      sort([on(e, table), on(a, table), on(b, a), on(c, b), on(d, c)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)])]).
step(member(on(e, d), [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]), builtin, [], []).
step(clear(e, [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]),
     rule(10),
     ['Block' = e, 'State' = [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]],
     [\+ member(on(_other, e), [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)])]).
step(\+ member(on(_other, e), [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]),
     absent,
     [],
     []).
step(support(table, [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]), fact(8), [], []).
step(clear_support(table, [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]),
     fact(11),
     [],
     []).
step(e \= (table), builtin, [], []).
step(d \= (table), builtin, [], []).
step(select(on(e, d), [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)], [on(a, table), on(b, a), on(c, b), on(d, c)]),
     builtin,
     [],
     []).
step(sort([on(e, table), on(a, table), on(b, a), on(c, b), on(d, c)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)]),
     builtin,
     [],
     []).
step(\+ member([on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [[on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]]),
     absent,
     [],
     []).
step(4 is 5 - 1, builtin, [], []).
step(plan([on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)], 4, [[on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]], [move(d, c, table), move(c, b, table), move(d, table, c), move(e, table, d)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]),
     rule(15),
     ['State' = [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)],
      'Goal' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)],
      'Depth' = 4,
      'Visited' = [[on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]],
      'Move' = move(d, c, table),
      'Moves' = [move(c, b, table), move(d, table, c), move(e, table, d)],
      'Final' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)],
      'Next' = [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)],
      'Restdepth' = 3],
     [4 > 0,
      move([on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], move(d, c, table), [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)]),
      \+ member([on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [[on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]]),
      3 is 4 - 1,
      plan([on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)], 3, [[on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]], [move(c, b, table), move(d, table, c), move(e, table, d)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)])]).
step(4 > 0, builtin, [], []).
step(move([on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], move(d, c, table), [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)]),
     rule(13),
     ['State' = [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)],
      'Block' = d,
      'From' = c,
      'To' = (table),
      'Newstate' = [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)],
      'Rest' = [on(a, table), on(b, a), on(c, b), on(e, table)]],
     [member(on(d, c), [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)]),
      clear(d, [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)]),
      support(table, [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)]),
      clear_support(table, [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)]),
      d \= (table),
      c \= (table),
      select(on(d, c), [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(e, table)]),
      sort([on(d, table), on(a, table), on(b, a), on(c, b), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)])]).
step(member(on(d, c), [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)]),
     builtin,
     [],
     []).
step(clear(d, [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)]),
     rule(10),
     ['Block' = d, 'State' = [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)]],
     [\+ member(on(_other, d), [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)])]).
step(\+ member(on(_other, d), [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)]),
     absent,
     [],
     []).
step(support(table, [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)]),
     fact(8),
     [],
     []).
step(clear_support(table, [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)]),
     fact(11),
     [],
     []).
step(c \= (table), builtin, [], []).
step(select(on(d, c), [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(e, table)]),
     builtin,
     [],
     []).
step(sort([on(d, table), on(a, table), on(b, a), on(c, b), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)]),
     builtin,
     [],
     []).
step(\+ member([on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [[on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]]),
     absent,
     [],
     []).
step(3 is 4 - 1, builtin, [], []).
step(plan([on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)], 3, [[on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]], [move(c, b, table), move(d, table, c), move(e, table, d)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]),
     rule(15),
     ['State' = [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)],
      'Goal' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)],
      'Depth' = 3,
      'Visited' = [[on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]],
      'Move' = move(c, b, table),
      'Moves' = [move(d, table, c), move(e, table, d)],
      'Final' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)],
      'Next' = [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)],
      'Restdepth' = 2],
     [3 > 0,
      move([on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], move(c, b, table), [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)]),
      \+ member([on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)], [[on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]]),
      2 is 3 - 1,
      plan([on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)], 2, [[on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]], [move(d, table, c), move(e, table, d)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)])]).
step(3 > 0, builtin, [], []).
step(move([on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], move(c, b, table), [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)]),
     rule(13),
     ['State' = [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)],
      'Block' = c,
      'From' = b,
      'To' = (table),
      'Newstate' = [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)],
      'Rest' = [on(a, table), on(b, a), on(d, table), on(e, table)]],
     [member(on(c, b), [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)]),
      clear(c, [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)]),
      support(table, [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)]),
      clear_support(table, [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)]),
      c \= (table),
      b \= (table),
      select(on(c, b), [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [on(a, table), on(b, a), on(d, table), on(e, table)]),
      sort([on(c, table), on(a, table), on(b, a), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)])]).
step(member(on(c, b), [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)]),
     builtin,
     [],
     []).
step(clear(c, [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)]),
     rule(10),
     ['Block' = c, 'State' = [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)]],
     [\+ member(on(_other, c), [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)])]).
step(\+ member(on(_other, c), [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)]),
     absent,
     [],
     []).
step(support(table, [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)]),
     fact(8),
     [],
     []).
step(clear_support(table, [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)]),
     fact(11),
     [],
     []).
step(b \= (table), builtin, [], []).
step(select(on(c, b), [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [on(a, table), on(b, a), on(d, table), on(e, table)]),
     builtin,
     [],
     []).
step(sort([on(c, table), on(a, table), on(b, a), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)]),
     builtin,
     [],
     []).
step(\+ member([on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)], [[on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]]),
     absent,
     [],
     []).
step(2 is 3 - 1, builtin, [], []).
step(plan([on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)], 2, [[on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]], [move(d, table, c), move(e, table, d)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]),
     rule(15),
     ['State' = [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)],
      'Goal' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)],
      'Depth' = 2,
      'Visited' = [[on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]],
      'Move' = move(d, table, c),
      'Moves' = [move(e, table, d)],
      'Final' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)],
      'Next' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)],
      'Restdepth' = 1],
     [2 > 0,
      move([on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)], move(d, table, c), [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)]),
      \+ member([on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)], [[on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]]),
      1 is 2 - 1,
      plan([on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)], 1, [[on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]], [move(e, table, d)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)])]).
step(2 > 0, builtin, [], []).
step(move([on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)], move(d, table, c), [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)]),
     rule(13),
     ['State' = [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)],
      'Block' = d,
      'From' = (table),
      'To' = c,
      'Newstate' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)],
      'Rest' = [on(a, table), on(b, a), on(c, table), on(e, table)]],
     [member(on(d, table), [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)]),
      clear(d, [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)]),
      support(c, [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)]),
      clear_support(c, [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)]),
      d \= c,
      (table) \= c,
      select(on(d, table), [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, table), on(e, table)]),
      sort([on(d, c), on(a, table), on(b, a), on(c, table), on(e, table)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)])]).
step(member(on(d, table), [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)]),
     builtin,
     [],
     []).
step(clear(d, [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)]),
     rule(10),
     ['Block' = d, 'State' = [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)]],
     [\+ member(on(_other, d), [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)])]).
step(\+ member(on(_other, d), [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)]),
     absent,
     [],
     []).
step(support(c, [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)]),
     rule(9),
     ['Block' = c, 'State' = [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)]],
     [block(c),
      member(on(c, table), [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)])]).
step(block(c), fact(5), [], []).
step(member(on(c, table), [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)]),
     builtin,
     [],
     []).
step(clear_support(c, [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)]),
     rule(12),
     ['Block' = c, 'State' = [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)]],
     [block(c), clear(c, [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)])]).
step(clear(c, [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)]),
     rule(10),
     ['Block' = c, 'State' = [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)]],
     [\+ member(on(_other, c), [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)])]).
step(\+ member(on(_other, c), [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)]),
     absent,
     [],
     []).
step(d \= c, builtin, [], []).
step((table) \= c, builtin, [], []).
step(select(on(d, table), [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, table), on(e, table)]),
     builtin,
     [],
     []).
step(sort([on(d, c), on(a, table), on(b, a), on(c, table), on(e, table)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)]),
     builtin,
     [],
     []).
step(\+ member([on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)], [[on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]]),
     absent,
     [],
     []).
step(1 is 2 - 1, builtin, [], []).
step(plan([on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)], 1, [[on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]], [move(e, table, d)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]),
     rule(15),
     ['State' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)],
      'Goal' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)],
      'Depth' = 1,
      'Visited' = [[on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]],
      'Move' = move(e, table, d),
      'Moves' = [],
      'Final' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)],
      'Next' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)],
      'Restdepth' = 0],
     [1 > 0,
      move([on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)], move(e, table, d), [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]),
      \+ member([on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)], [[on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]]),
      0 is 1 - 1,
      plan([on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)], 0, [[on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]], [], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)])]).
step(1 > 0, builtin, [], []).
step(move([on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)], move(e, table, d), [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]),
     rule(13),
     ['State' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)],
      'Block' = e,
      'From' = (table),
      'To' = d,
      'Newstate' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)],
      'Rest' = [on(a, table), on(b, a), on(c, table), on(d, c)]],
     [member(on(e, table), [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)]),
      clear(e, [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)]),
      support(d, [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)]),
      clear_support(d, [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)]),
      e \= d,
      (table) \= d,
      select(on(e, table), [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, table), on(d, c)]),
      sort([on(e, d), on(a, table), on(b, a), on(c, table), on(d, c)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)])]).
step(member(on(e, table), [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)]),
     builtin,
     [],
     []).
step(clear(e, [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)]),
     rule(10),
     ['Block' = e, 'State' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)]],
     [\+ member(on(_other, e), [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)])]).
step(\+ member(on(_other, e), [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)]),
     absent,
     [],
     []).
step(support(d, [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)]),
     rule(9),
     ['Block' = d, 'State' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)]],
     [block(d),
      member(on(d, c), [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)])]).
step(block(d), fact(6), [], []).
step(member(on(d, c), [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)]),
     builtin,
     [],
     []).
step(clear_support(d, [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)]),
     rule(12),
     ['Block' = d, 'State' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)]],
     [block(d), clear(d, [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)])]).
step(clear(d, [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)]),
     rule(10),
     ['Block' = d, 'State' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)]],
     [\+ member(on(_other, d), [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)])]).
step(\+ member(on(_other, d), [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)]),
     absent,
     [],
     []).
step(e \= d, builtin, [], []).
step((table) \= d, builtin, [], []).
step(select(on(e, table), [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, table), on(d, c)]),
     builtin,
     [],
     []).
step(sort([on(e, d), on(a, table), on(b, a), on(c, table), on(d, c)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]),
     builtin,
     [],
     []).
step(\+ member([on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)], [[on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]]),
     absent,
     [],
     []).
step(0 is 1 - 1, builtin, [], []).
step(plan([on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)], 0, [[on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, table), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, table), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, table)], [on(a, table), on(b, a), on(c, b), on(d, c), on(e, d)]], [], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]),
     rule(14),
     ['State' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)],
      'Goal' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]],
     [[on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)] = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]]).
step([on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)] = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)],
     builtin,
     [],
     []).
step(plan(blocks_world, [move(e, d, table), move(d, c, table), move(c, b, table), move(d, table, c), move(e, table, d)]),
     rule(18),
     ['Moves' = [move(e, d, table), move(d, c, table), move(c, b, table), move(d, table, c), move(e, table, d)]],
     [once(five_move_plan([move(e, d, table), move(d, c, table), move(c, b, table), move(d, table, c), move(e, table, d)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]))]).
step(finalState(blocks_world, [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]),
     rule(19),
     ['Final' = [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]],
     [once(five_move_plan([move(e, d, table), move(d, c, table), move(c, b, table), move(d, table, c), move(e, table, d)], [on(a, table), on(b, a), on(c, table), on(d, c), on(e, d)]))]).
step(blockCount(blocks_world, 5),
     rule(20),
     ['Count' = 5, 'Blocks' = "abcde"],
     [findall(Block, block(Block), "abcde"), length("abcde", 5)]).
step(findall(Block, block(Block), "abcde"), collected, [], []).
step(length("abcde", 5), builtin, [], []).
