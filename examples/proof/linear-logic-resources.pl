linear_result(kitchen, [mill, mix, bake], [bread]).
linear_check(double_spend_rejected, yes).

clause(1, initial(kitchen, [wheat, yeast, heat]), true).
clause(2, initial(wallet, [coin]), true).
clause(3, linear_rule(mill, [wheat], [flour]), true).
clause(4, linear_rule(mix, [flour, yeast], [dough]), true).
clause(5, linear_rule(bake, [dough, heat], [bread]), true).
clause(8, consume_all([], var('State'), var('State')), true).
clause(9,
       consume_all([var('Need') | var('Needs')], var('State0'), var('State2')),
       (select(var('Need'), var('State0'), var('State1')),
        consume_all(var('Needs'), var('State1'), var('State2')))).
clause(10,
       linear_step(var('State0'), var('Rule'), var('State2')),
       (linear_rule(var('Rule'), var('Inputs'), var('Outputs')),
        consume_all(var('Inputs'), var('State0'), var('Rest')),
        append(var('Outputs'), var('Rest'), var('State2')))).
clause(11, run_linear(0, var('State'), [], var('State')), true).
clause(12,
       run_linear(var('Steps'), var('State0'), [var('Rule') | var('Plan')], var('State2')),
       (var('Steps') > 0,
        linear_step(var('State0'), var('Rule'), var('State1')),
        var('Remaining') is var('Steps') - 1,
        run_linear(var('Remaining'), var('State1'), var('Plan'), var('State2')))).
clause(13,
       linear_result(kitchen, var('Plan'), var('Finalstate')),
       (initial(kitchen, var('State')),
        run_linear(3, var('State'), var('Plan'), var('Finalstate')),
        var('Finalstate') = [bread])).
clause(14,
       linear_check(double_spend_rejected, yes),
       (initial(wallet, var('State')),
        \+ run_linear(2, var('State'), [buy_flour, buy_yeast], anonymous(1)))).

step(linear_result(kitchen, [mill, mix, bake], [bread]),
     rule(13),
     ['Plan' = [mill, mix, bake], 'Finalstate' = [bread], 'State' = [wheat, yeast, heat]],
     [initial(kitchen, [wheat, yeast, heat]),
      run_linear(3, [wheat, yeast, heat], [mill, mix, bake], [bread]),
      [bread] = [bread]]).
step(initial(kitchen, [wheat, yeast, heat]), fact(1), [], []).
step(run_linear(3, [wheat, yeast, heat], [mill, mix, bake], [bread]),
     rule(12),
     ['Steps' = 3,
      'State0' = [wheat, yeast, heat],
      'Rule' = mill,
      'Plan' = [mix, bake],
      'State2' = [bread],
      'State1' = [flour, yeast, heat],
      'Remaining' = 2],
     [3 > 0,
      linear_step([wheat, yeast, heat], mill, [flour, yeast, heat]),
      2 is 3 - 1,
      run_linear(2, [flour, yeast, heat], [mix, bake], [bread])]).
step(3 > 0, builtin, [], []).
step(linear_step([wheat, yeast, heat], mill, [flour, yeast, heat]),
     rule(10),
     ['State0' = [wheat, yeast, heat],
      'Rule' = mill,
      'State2' = [flour, yeast, heat],
      'Inputs' = [wheat],
      'Outputs' = [flour],
      'Rest' = [yeast, heat]],
     [linear_rule(mill, [wheat], [flour]),
      consume_all([wheat], [wheat, yeast, heat], [yeast, heat]),
      append([flour], [yeast, heat], [flour, yeast, heat])]).
step(linear_rule(mill, [wheat], [flour]), fact(3), [], []).
step(consume_all([wheat], [wheat, yeast, heat], [yeast, heat]),
     rule(9),
     ['Need' = wheat,
      'Needs' = [],
      'State0' = [wheat, yeast, heat],
      'State2' = [yeast, heat],
      'State1' = [yeast, heat]],
     [select(wheat, [wheat, yeast, heat], [yeast, heat]),
      consume_all([], [yeast, heat], [yeast, heat])]).
step(select(wheat, [wheat, yeast, heat], [yeast, heat]), builtin, [], []).
step(consume_all([], [yeast, heat], [yeast, heat]), fact(8), ['State' = [yeast, heat]], []).
step(append([flour], [yeast, heat], [flour, yeast, heat]), builtin, [], []).
step(2 is 3 - 1, builtin, [], []).
step(run_linear(2, [flour, yeast, heat], [mix, bake], [bread]),
     rule(12),
     ['Steps' = 2,
      'State0' = [flour, yeast, heat],
      'Rule' = mix,
      'Plan' = [bake],
      'State2' = [bread],
      'State1' = [dough, heat],
      'Remaining' = 1],
     [2 > 0,
      linear_step([flour, yeast, heat], mix, [dough, heat]),
      1 is 2 - 1,
      run_linear(1, [dough, heat], [bake], [bread])]).
step(2 > 0, builtin, [], []).
step(linear_step([flour, yeast, heat], mix, [dough, heat]),
     rule(10),
     ['State0' = [flour, yeast, heat],
      'Rule' = mix,
      'State2' = [dough, heat],
      'Inputs' = [flour, yeast],
      'Outputs' = [dough],
      'Rest' = [heat]],
     [linear_rule(mix, [flour, yeast], [dough]),
      consume_all([flour, yeast], [flour, yeast, heat], [heat]),
      append([dough], [heat], [dough, heat])]).
step(linear_rule(mix, [flour, yeast], [dough]), fact(4), [], []).
step(consume_all([flour, yeast], [flour, yeast, heat], [heat]),
     rule(9),
     ['Need' = flour,
      'Needs' = [yeast],
      'State0' = [flour, yeast, heat],
      'State2' = [heat],
      'State1' = [yeast, heat]],
     [select(flour, [flour, yeast, heat], [yeast, heat]),
      consume_all([yeast], [yeast, heat], [heat])]).
step(select(flour, [flour, yeast, heat], [yeast, heat]), builtin, [], []).
step(consume_all([yeast], [yeast, heat], [heat]),
     rule(9),
     ['Need' = yeast,
      'Needs' = [],
      'State0' = [yeast, heat],
      'State2' = [heat],
      'State1' = [heat]],
     [select(yeast, [yeast, heat], [heat]), consume_all([], [heat], [heat])]).
step(select(yeast, [yeast, heat], [heat]), builtin, [], []).
step(consume_all([], [heat], [heat]), fact(8), ['State' = [heat]], []).
step(append([dough], [heat], [dough, heat]), builtin, [], []).
step(1 is 2 - 1, builtin, [], []).
step(run_linear(1, [dough, heat], [bake], [bread]),
     rule(12),
     ['Steps' = 1,
      'State0' = [dough, heat],
      'Rule' = bake,
      'Plan' = [],
      'State2' = [bread],
      'State1' = [bread],
      'Remaining' = 0],
     [1 > 0,
      linear_step([dough, heat], bake, [bread]),
      0 is 1 - 1,
      run_linear(0, [bread], [], [bread])]).
step(1 > 0, builtin, [], []).
step(linear_step([dough, heat], bake, [bread]),
     rule(10),
     ['State0' = [dough, heat],
      'Rule' = bake,
      'State2' = [bread],
      'Inputs' = [dough, heat],
      'Outputs' = [bread],
      'Rest' = []],
     [linear_rule(bake, [dough, heat], [bread]),
      consume_all([dough, heat], [dough, heat], []),
      append([bread], [], [bread])]).
step(linear_rule(bake, [dough, heat], [bread]), fact(5), [], []).
step(consume_all([dough, heat], [dough, heat], []),
     rule(9),
     ['Need' = dough,
      'Needs' = [heat],
      'State0' = [dough, heat],
      'State2' = [],
      'State1' = [heat]],
     [select(dough, [dough, heat], [heat]), consume_all([heat], [heat], [])]).
step(select(dough, [dough, heat], [heat]), builtin, [], []).
step(consume_all([heat], [heat], []),
     rule(9),
     ['Need' = heat, 'Needs' = [], 'State0' = [heat], 'State2' = [], 'State1' = []],
     [select(heat, [heat], []), consume_all([], [], [])]).
step(select(heat, [heat], []), builtin, [], []).
step(consume_all([], [], []), fact(8), ['State' = []], []).
step(append([bread], [], [bread]), builtin, [], []).
step(0 is 1 - 1, builtin, [], []).
step(run_linear(0, [bread], [], [bread]), fact(11), ['State' = [bread]], []).
step([bread] = [bread], builtin, [], []).
step(linear_check(double_spend_rejected, yes),
     rule(14),
     ['State' = [coin]],
     [initial(wallet, [coin]), \+ run_linear(2, [coin], [buy_flour, buy_yeast], _finalstate)]).
step(initial(wallet, [coin]), fact(2), [], []).
step(\+ run_linear(2, [coin], [buy_flour, buy_yeast], _finalstate), absent, [], []).
