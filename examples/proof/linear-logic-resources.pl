linear_result(kitchen, [mill, mix, bake], [bread]).
why(
  linear_result(kitchen, [mill, mix, bake], [bread]),
  step(
    linear_result(kitchen, [mill, mix, bake], [bread]),
    rule("linear-logic-resources.pl", clause(13)),
    ['Plan' = [mill, mix, bake], 'Finalstate' = [bread], 'State' = [wheat, yeast, heat]],
    [
      step(initial(kitchen, [wheat, yeast, heat]), fact("linear-logic-resources.pl", clause(1)), [], []),
      step(
        run_linear(3, [wheat, yeast, heat], [mill, mix, bake], [bread]),
        rule("linear-logic-resources.pl", clause(12)),
        ['Steps' = 3, 'State0' = [wheat, yeast, heat], 'Rule' = mill, 'Plan' = [mix, bake], 'State2' = [bread], 'State1' = [flour, yeast, heat], 'Remaining' = 2],
        [
          step(>(3, 0), builtin(>, 2), [], []),
          step(
            linear_step([wheat, yeast, heat], mill, [flour, yeast, heat]),
            rule("linear-logic-resources.pl", clause(10)),
            ['State0' = [wheat, yeast, heat], 'Rule' = mill, 'State2' = [flour, yeast, heat], 'Inputs' = [wheat], 'Outputs' = [flour], 'Rest' = [yeast, heat]],
            [
              step(linear_rule(mill, [wheat], [flour]), fact("linear-logic-resources.pl", clause(3)), [], []),
              step(
                consume_all([wheat], [wheat, yeast, heat], [yeast, heat]),
                rule("linear-logic-resources.pl", clause(9)),
                ['Need' = wheat, 'Needs' = [], 'State0' = [wheat, yeast, heat], 'State2' = [yeast, heat], 'State1' = [yeast, heat]],
                [
                  step(select(wheat, [wheat, yeast, heat], [yeast, heat]), library(select, 3), [], []),
                  step(consume_all([], [yeast, heat], [yeast, heat]), fact("linear-logic-resources.pl", clause(8)), ['State' = [yeast, heat]], [])
                ]
              ),
              step(append([flour], [yeast, heat], [flour, yeast, heat]), library(append, 3), [], [])
            ]
          ),
          step(is(2, '-'(3, 1)), builtin(is, 2), [], []),
          step(
            run_linear(2, [flour, yeast, heat], [mix, bake], [bread]),
            rule("linear-logic-resources.pl", clause(12)),
            ['Steps' = 2, 'State0' = [flour, yeast, heat], 'Rule' = mix, 'Plan' = [bake], 'State2' = [bread], 'State1' = [dough, heat], 'Remaining' = 1],
            [
              step(>(2, 0), builtin(>, 2), [], []),
              step(
                linear_step([flour, yeast, heat], mix, [dough, heat]),
                rule("linear-logic-resources.pl", clause(10)),
                ['State0' = [flour, yeast, heat], 'Rule' = mix, 'State2' = [dough, heat], 'Inputs' = [flour, yeast], 'Outputs' = [dough], 'Rest' = [heat]],
                [
                  step(linear_rule(mix, [flour, yeast], [dough]), fact("linear-logic-resources.pl", clause(4)), [], []),
                  step(
                    consume_all([flour, yeast], [flour, yeast, heat], [heat]),
                    rule("linear-logic-resources.pl", clause(9)),
                    ['Need' = flour, 'Needs' = [yeast], 'State0' = [flour, yeast, heat], 'State2' = [heat], 'State1' = [yeast, heat]],
                    [
                      step(select(flour, [flour, yeast, heat], [yeast, heat]), library(select, 3), [], []),
                      step(
                        consume_all([yeast], [yeast, heat], [heat]),
                        rule("linear-logic-resources.pl", clause(9)),
                        ['Need' = yeast, 'Needs' = [], 'State0' = [yeast, heat], 'State2' = [heat], 'State1' = [heat]],
                        [
                          step(select(yeast, [yeast, heat], [heat]), library(select, 3), [], []),
                          step(consume_all([], [heat], [heat]), fact("linear-logic-resources.pl", clause(8)), ['State' = [heat]], [])
                        ]
                      )
                    ]
                  ),
                  step(append([dough], [heat], [dough, heat]), library(append, 3), [], [])
                ]
              ),
              step(is(1, '-'(2, 1)), builtin(is, 2), [], []),
              step(
                run_linear(1, [dough, heat], [bake], [bread]),
                rule("linear-logic-resources.pl", clause(12)),
                ['Steps' = 1, 'State0' = [dough, heat], 'Rule' = bake, 'Plan' = [], 'State2' = [bread], 'State1' = [bread], 'Remaining' = 0],
                [
                  step(>(1, 0), builtin(>, 2), [], []),
                  step(
                    linear_step([dough, heat], bake, [bread]),
                    rule("linear-logic-resources.pl", clause(10)),
                    ['State0' = [dough, heat], 'Rule' = bake, 'State2' = [bread], 'Inputs' = [dough, heat], 'Outputs' = [bread], 'Rest' = []],
                    [
                      step(linear_rule(bake, [dough, heat], [bread]), fact("linear-logic-resources.pl", clause(5)), [], []),
                      step(
                        consume_all([dough, heat], [dough, heat], []),
                        rule("linear-logic-resources.pl", clause(9)),
                        ['Need' = dough, 'Needs' = [heat], 'State0' = [dough, heat], 'State2' = [], 'State1' = [heat]],
                        [
                          step(select(dough, [dough, heat], [heat]), library(select, 3), [], []),
                          step(
                            consume_all([heat], [heat], []),
                            rule("linear-logic-resources.pl", clause(9)),
                            ['Need' = heat, 'Needs' = [], 'State0' = [heat], 'State2' = [], 'State1' = []],
                            [
                              step(select(heat, [heat], []), library(select, 3), [], []),
                              step(consume_all([], [], []), fact("linear-logic-resources.pl", clause(8)), ['State' = []], [])
                            ]
                          )
                        ]
                      ),
                      step(append([bread], [], [bread]), library(append, 3), [], [])
                    ]
                  ),
                  step(is(0, '-'(1, 1)), builtin(is, 2), [], []),
                  step(run_linear(0, [bread], [], [bread]), fact("linear-logic-resources.pl", clause(11)), ['State' = [bread]], [])
                ]
              )
            ]
          )
        ]
      ),
      step(=([bread], [bread]), builtin(=, 2), [], [])
    ]
  )
).

linear_check(double_spend_rejected, yes).
why(
  linear_check(double_spend_rejected, yes),
  step(
    linear_check(double_spend_rejected, yes),
    rule("linear-logic-resources.pl", clause(14)),
    ['State' = [coin]],
    [
      step(initial(wallet, [coin]), fact("linear-logic-resources.pl", clause(2)), [], []),
      step('\\+'(run_linear(2, [coin], [buy_flour, buy_yeast], _finalstate)), builtin('\\+', 1), [], [])
    ]
  )
).

