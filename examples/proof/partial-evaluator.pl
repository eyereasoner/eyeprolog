partialEvalAnswer(residual(poly_y), add(mul(const(10), var(y)), const(13))).
why(
  partialEvalAnswer(residual(poly_y), add(mul(const(10), var(y)), const(13))),
  step(
    partialEvalAnswer(residual(poly_y), add(mul(const(10), var(y)), const(13))),
    rule("partial-evaluator.pl", clause(20)),
    ['Name' = poly_y, 'Residual' = add(mul(const(10), var(y)), const(13))],
    [
      step(
        residual_program(poly_y, add(mul(const(10), var(y)), const(13))),
        rule("partial-evaluator.pl", clause(19)),
        ['Name' = poly_y, 'Residual' = add(mul(const(10), var(y)), const(13)), 'Expr' = add(mul(var(x), var(y)), add(var(x), const(3))), 'Env' = [bind(x, const(10))]],
        [
          step(program(poly_y, add(mul(var(x), var(y)), add(var(x), const(3))), [bind(x, const(10))]), fact("partial-evaluator.pl", clause(1)), [], []),
          step(
            pe([bind(x, const(10))], add(mul(var(x), var(y)), add(var(x), const(3))), add(mul(const(10), var(y)), const(13))),
            rule("partial-evaluator.pl", clause(14)),
            ['Env' = [bind(x, const(10))], 'Left' = mul(var(x), var(y)), 'Right' = add(var(x), const(3)), 'Left_residual' = mul(const(10), var(y)), 'Right_residual' = const(13)],
            [
              step(
                pe([bind(x, const(10))], mul(var(x), var(y)), mul(const(10), var(y))),
                rule("partial-evaluator.pl", clause(15)),
                ['Env' = [bind(x, const(10))], 'Left' = var(x), 'Right' = var(y), 'Left_residual' = const(10), 'Right_residual' = var(y)],
                [
                  step(
                    pe([bind(x, const(10))], var(x), const(10)),
                    rule("partial-evaluator.pl", clause(10)),
                    ['Env' = [bind(x, const(10))], 'Name' = x, 'Value' = const(10)],
                    [
                      step(
                        known_var([bind(x, const(10))], x, const(10)),
                        rule("partial-evaluator.pl", clause(6)),
                        ['Env' = [bind(x, const(10))], 'Name' = x, 'Value' = const(10)],
                        [
                          step(lookup(x, [bind(x, const(10))], const(10)), fact("partial-evaluator.pl", clause(4)), ['Name' = x, 'Value' = const(10), '__anon0' = []], [])
                        ]
                      )
                    ]
                  ),
                  step(
                    pe([bind(x, const(10))], var(y), var(y)),
                    rule("partial-evaluator.pl", clause(11)),
                    ['Env' = [bind(x, const(10))], 'Name' = y],
                    [
                      step(
                        unknown_var([bind(x, const(10))], y),
                        rule("partial-evaluator.pl", clause(7)),
                        ['Env' = [bind(x, const(10))], 'Name' = y],
                        [
                          step('\\+'(known_var([bind(x, const(10))], y, __anon3)), builtin('\\+', 1), [], [])
                        ]
                      )
                    ]
                  ),
                  step('\\+'((=(const(10), const(_A)), =(var(y), const(_B)))), builtin('\\+', 1), [], [])
                ]
              ),
              step(
                pe([bind(x, const(10))], add(var(x), const(3)), const(13)),
                rule("partial-evaluator.pl", clause(12)),
                ['Env' = [bind(x, const(10))], 'Left' = var(x), 'Right' = const(3), 'Sum' = 13, 'A' = 10, 'B' = 3],
                [
                  step(
                    pe([bind(x, const(10))], var(x), const(10)),
                    rule("partial-evaluator.pl", clause(10)),
                    ['Env' = [bind(x, const(10))], 'Name' = x, 'Value' = const(10)],
                    [
                      step(
                        known_var([bind(x, const(10))], x, const(10)),
                        rule("partial-evaluator.pl", clause(6)),
                        ['Env' = [bind(x, const(10))], 'Name' = x, 'Value' = const(10)],
                        [
                          step(lookup(x, [bind(x, const(10))], const(10)), fact("partial-evaluator.pl", clause(4)), ['Name' = x, 'Value' = const(10), '__anon0' = []], [])
                        ]
                      )
                    ]
                  ),
                  step(pe([bind(x, const(10))], const(3), const(3)), fact("partial-evaluator.pl", clause(8)), ['__anon4' = [bind(x, const(10))], 'N' = 3], []),
                  step(is(13, '+'(10, 3)), builtin(is, 2), [], [])
                ]
              ),
              step('\\+'((=(mul(const(10), var(y)), const(_A)), =(const(13), const(_B)))), builtin('\\+', 1), [], [])
            ]
          )
        ]
      )
    ]
  )
).

partialEvalAnswer(residual(static_branch), const(11)).
why(
  partialEvalAnswer(residual(static_branch), const(11)),
  step(
    partialEvalAnswer(residual(static_branch), const(11)),
    rule("partial-evaluator.pl", clause(20)),
    ['Name' = static_branch, 'Residual' = const(11)],
    [
      step(
        residual_program(static_branch, const(11)),
        rule("partial-evaluator.pl", clause(19)),
        ['Name' = static_branch, 'Residual' = const(11), 'Expr' = if(bool(true), add(var(x), const(1)), mul(var(y), const(999))), 'Env' = [bind(x, const(10))]],
        [
          step(program(static_branch, if(bool(true), add(var(x), const(1)), mul(var(y), const(999))), [bind(x, const(10))]), fact("partial-evaluator.pl", clause(2)), [], []),
          step(
            pe([bind(x, const(10))], if(bool(true), add(var(x), const(1)), mul(var(y), const(999))), const(11)),
            rule("partial-evaluator.pl", clause(16)),
            ['Env' = [bind(x, const(10))], 'Cond' = bool(true), 'Then' = add(var(x), const(1)), '_Else' = mul(var(y), const(999)), 'Residual' = const(11)],
            [
              step(pe([bind(x, const(10))], bool(true), bool(true)), fact("partial-evaluator.pl", clause(9)), ['__anon5' = [bind(x, const(10))], 'B' = true], []),
              step(
                pe([bind(x, const(10))], add(var(x), const(1)), const(11)),
                rule("partial-evaluator.pl", clause(12)),
                ['Env' = [bind(x, const(10))], 'Left' = var(x), 'Right' = const(1), 'Sum' = 11, 'A' = 10, 'B' = 1],
                [
                  step(
                    pe([bind(x, const(10))], var(x), const(10)),
                    rule("partial-evaluator.pl", clause(10)),
                    ['Env' = [bind(x, const(10))], 'Name' = x, 'Value' = const(10)],
                    [
                      step(
                        known_var([bind(x, const(10))], x, const(10)),
                        rule("partial-evaluator.pl", clause(6)),
                        ['Env' = [bind(x, const(10))], 'Name' = x, 'Value' = const(10)],
                        [
                          step(lookup(x, [bind(x, const(10))], const(10)), fact("partial-evaluator.pl", clause(4)), ['Name' = x, 'Value' = const(10), '__anon0' = []], [])
                        ]
                      )
                    ]
                  ),
                  step(pe([bind(x, const(10))], const(1), const(1)), fact("partial-evaluator.pl", clause(8)), ['__anon4' = [bind(x, const(10))], 'N' = 1], []),
                  step(is(11, '+'(10, 1)), builtin(is, 2), [], [])
                ]
              )
            ]
          )
        ]
      )
    ]
  )
).

partialEvalAnswer(residual(dynamic_branch), if(var(flag), const(11), mul(var(y), const(2)))).
why(
  partialEvalAnswer(residual(dynamic_branch), if(var(flag), const(11), mul(var(y), const(2)))),
  step(
    partialEvalAnswer(residual(dynamic_branch), if(var(flag), const(11), mul(var(y), const(2)))),
    rule("partial-evaluator.pl", clause(20)),
    ['Name' = dynamic_branch, 'Residual' = if(var(flag), const(11), mul(var(y), const(2)))],
    [
      step(
        residual_program(dynamic_branch, if(var(flag), const(11), mul(var(y), const(2)))),
        rule("partial-evaluator.pl", clause(19)),
        ['Name' = dynamic_branch, 'Residual' = if(var(flag), const(11), mul(var(y), const(2))), 'Expr' = if(var(flag), add(var(x), const(1)), mul(var(y), const(2))), 'Env' = [bind(x, const(10))]],
        [
          step(program(dynamic_branch, if(var(flag), add(var(x), const(1)), mul(var(y), const(2))), [bind(x, const(10))]), fact("partial-evaluator.pl", clause(3)), [], []),
          step(
            pe([bind(x, const(10))], if(var(flag), add(var(x), const(1)), mul(var(y), const(2))), if(var(flag), const(11), mul(var(y), const(2)))),
            rule("partial-evaluator.pl", clause(18)),
            ['Env' = [bind(x, const(10))], 'Cond' = var(flag), 'Then' = add(var(x), const(1)), 'Else' = mul(var(y), const(2)), 'Cond_residual' = var(flag), 'Then_residual' = const(11), 'Else_residual' = mul(var(y), const(2))],
            [
              step(
                pe([bind(x, const(10))], var(flag), var(flag)),
                rule("partial-evaluator.pl", clause(11)),
                ['Env' = [bind(x, const(10))], 'Name' = flag],
                [
                  step(
                    unknown_var([bind(x, const(10))], flag),
                    rule("partial-evaluator.pl", clause(7)),
                    ['Env' = [bind(x, const(10))], 'Name' = flag],
                    [
                      step('\\+'(known_var([bind(x, const(10))], flag, __anon3)), builtin('\\+', 1), [], [])
                    ]
                  )
                ]
              ),
              step('\\+'(=(var(flag), bool(true))), builtin('\\+', 1), [], []),
              step('\\+'(=(var(flag), bool(false))), builtin('\\+', 1), [], []),
              step(
                pe([bind(x, const(10))], add(var(x), const(1)), const(11)),
                rule("partial-evaluator.pl", clause(12)),
                ['Env' = [bind(x, const(10))], 'Left' = var(x), 'Right' = const(1), 'Sum' = 11, 'A' = 10, 'B' = 1],
                [
                  step(
                    pe([bind(x, const(10))], var(x), const(10)),
                    rule("partial-evaluator.pl", clause(10)),
                    ['Env' = [bind(x, const(10))], 'Name' = x, 'Value' = const(10)],
                    [
                      step(
                        known_var([bind(x, const(10))], x, const(10)),
                        rule("partial-evaluator.pl", clause(6)),
                        ['Env' = [bind(x, const(10))], 'Name' = x, 'Value' = const(10)],
                        [
                          step(lookup(x, [bind(x, const(10))], const(10)), fact("partial-evaluator.pl", clause(4)), ['Name' = x, 'Value' = const(10), '__anon0' = []], [])
                        ]
                      )
                    ]
                  ),
                  step(pe([bind(x, const(10))], const(1), const(1)), fact("partial-evaluator.pl", clause(8)), ['__anon4' = [bind(x, const(10))], 'N' = 1], []),
                  step(is(11, '+'(10, 1)), builtin(is, 2), [], [])
                ]
              ),
              step(
                pe([bind(x, const(10))], mul(var(y), const(2)), mul(var(y), const(2))),
                rule("partial-evaluator.pl", clause(15)),
                ['Env' = [bind(x, const(10))], 'Left' = var(y), 'Right' = const(2), 'Left_residual' = var(y), 'Right_residual' = const(2)],
                [
                  step(
                    pe([bind(x, const(10))], var(y), var(y)),
                    rule("partial-evaluator.pl", clause(11)),
                    ['Env' = [bind(x, const(10))], 'Name' = y],
                    [
                      step(
                        unknown_var([bind(x, const(10))], y),
                        rule("partial-evaluator.pl", clause(7)),
                        ['Env' = [bind(x, const(10))], 'Name' = y],
                        [
                          step('\\+'(known_var([bind(x, const(10))], y, __anon3)), builtin('\\+', 1), [], [])
                        ]
                      )
                    ]
                  ),
                  step(pe([bind(x, const(10))], const(2), const(2)), fact("partial-evaluator.pl", clause(8)), ['__anon4' = [bind(x, const(10))], 'N' = 2], []),
                  step('\\+'((=(var(y), const(_A)), =(const(2), const(_B)))), builtin('\\+', 1), [], [])
                ]
              )
            ]
          )
        ]
      )
    ]
  )
).

partialEvalAnswer(note, "static inputs are folded while dynamic variables remain as residual code").
why(
  partialEvalAnswer(note, "static inputs are folded while dynamic variables remain as residual code"),
  step(
    partialEvalAnswer(note, "static inputs are folded while dynamic variables remain as residual code"),
    rule("partial-evaluator.pl", clause(21)),
    ['__anon6' = add(mul(const(10), var(y)), const(13))],
    [
      step(
        residual_program(poly_y, add(mul(const(10), var(y)), const(13))),
        rule("partial-evaluator.pl", clause(19)),
        ['Name' = poly_y, 'Residual' = add(mul(const(10), var(y)), const(13)), 'Expr' = add(mul(var(x), var(y)), add(var(x), const(3))), 'Env' = [bind(x, const(10))]],
        [
          step(program(poly_y, add(mul(var(x), var(y)), add(var(x), const(3))), [bind(x, const(10))]), fact("partial-evaluator.pl", clause(1)), [], []),
          step(
            pe([bind(x, const(10))], add(mul(var(x), var(y)), add(var(x), const(3))), add(mul(const(10), var(y)), const(13))),
            rule("partial-evaluator.pl", clause(14)),
            ['Env' = [bind(x, const(10))], 'Left' = mul(var(x), var(y)), 'Right' = add(var(x), const(3)), 'Left_residual' = mul(const(10), var(y)), 'Right_residual' = const(13)],
            [
              step(
                pe([bind(x, const(10))], mul(var(x), var(y)), mul(const(10), var(y))),
                rule("partial-evaluator.pl", clause(15)),
                ['Env' = [bind(x, const(10))], 'Left' = var(x), 'Right' = var(y), 'Left_residual' = const(10), 'Right_residual' = var(y)],
                [
                  step(
                    pe([bind(x, const(10))], var(x), const(10)),
                    rule("partial-evaluator.pl", clause(10)),
                    ['Env' = [bind(x, const(10))], 'Name' = x, 'Value' = const(10)],
                    [
                      step(
                        known_var([bind(x, const(10))], x, const(10)),
                        rule("partial-evaluator.pl", clause(6)),
                        ['Env' = [bind(x, const(10))], 'Name' = x, 'Value' = const(10)],
                        [
                          step(lookup(x, [bind(x, const(10))], const(10)), fact("partial-evaluator.pl", clause(4)), ['Name' = x, 'Value' = const(10), '__anon0' = []], [])
                        ]
                      )
                    ]
                  ),
                  step(
                    pe([bind(x, const(10))], var(y), var(y)),
                    rule("partial-evaluator.pl", clause(11)),
                    ['Env' = [bind(x, const(10))], 'Name' = y],
                    [
                      step(
                        unknown_var([bind(x, const(10))], y),
                        rule("partial-evaluator.pl", clause(7)),
                        ['Env' = [bind(x, const(10))], 'Name' = y],
                        [
                          step('\\+'(known_var([bind(x, const(10))], y, __anon3)), builtin('\\+', 1), [], [])
                        ]
                      )
                    ]
                  ),
                  step('\\+'((=(const(10), const(_A)), =(var(y), const(_B)))), builtin('\\+', 1), [], [])
                ]
              ),
              step(
                pe([bind(x, const(10))], add(var(x), const(3)), const(13)),
                rule("partial-evaluator.pl", clause(12)),
                ['Env' = [bind(x, const(10))], 'Left' = var(x), 'Right' = const(3), 'Sum' = 13, 'A' = 10, 'B' = 3],
                [
                  step(
                    pe([bind(x, const(10))], var(x), const(10)),
                    rule("partial-evaluator.pl", clause(10)),
                    ['Env' = [bind(x, const(10))], 'Name' = x, 'Value' = const(10)],
                    [
                      step(
                        known_var([bind(x, const(10))], x, const(10)),
                        rule("partial-evaluator.pl", clause(6)),
                        ['Env' = [bind(x, const(10))], 'Name' = x, 'Value' = const(10)],
                        [
                          step(lookup(x, [bind(x, const(10))], const(10)), fact("partial-evaluator.pl", clause(4)), ['Name' = x, 'Value' = const(10), '__anon0' = []], [])
                        ]
                      )
                    ]
                  ),
                  step(pe([bind(x, const(10))], const(3), const(3)), fact("partial-evaluator.pl", clause(8)), ['__anon4' = [bind(x, const(10))], 'N' = 3], []),
                  step(is(13, '+'(10, 3)), builtin(is, 2), [], [])
                ]
              ),
              step('\\+'((=(mul(const(10), var(y)), const(_A)), =(const(13), const(_B)))), builtin('\\+', 1), [], [])
            ]
          )
        ]
      )
    ]
  )
).

