chart_parser_answer(parsed, command).
why(
  chart_parser_answer(parsed, command),
  step(
    chart_parser_answer(parsed, command),
    rule("chart-parser.pl", clause(32)),
    ['Sentence' = command, 'Length' = 5],
    [
      step(sentence(command, 5), fact("chart-parser.pl", clause(2)), [], []),
      step(
        span(command, s, 0, 5),
        rule("chart-parser.pl", clause(31)),
        ['Sentence' = command, 'Category' = s, 'Start' = 0, 'End' = 5, 'Left' = np, 'Right' = vp, 'Middle' = 2],
        [
          step(rule(s, np, vp), fact("chart-parser.pl", clause(24)), [], []),
          step(
            span(command, np, 0, 2),
            rule("chart-parser.pl", clause(31)),
            ['Sentence' = command, 'Category' = np, 'Start' = 0, 'End' = 2, 'Left' = det, 'Right' = noun, 'Middle' = 1],
            [
              step(rule(np, det, noun), fact("chart-parser.pl", clause(25)), [], []),
              step(
                span(command, det, 0, 1),
                rule("chart-parser.pl", clause(30)),
                ['Sentence' = command, 'Category' = det, 'Start' = 0, 'End' = 1, 'Token' = the],
                [
                  step(word(command, 0, the), fact("chart-parser.pl", clause(4)), [], []),
                  step(terminal(det, the), fact("chart-parser.pl", clause(17)), [], []),
                  step(is(1, '+'(0, 1)), builtin(is, 2), [], [])
                ]
              ),
              step(
                span(command, noun, 1, 2),
                rule("chart-parser.pl", clause(30)),
                ['Sentence' = command, 'Category' = noun, 'Start' = 1, 'End' = 2, 'Token' = robot],
                [
                  step(word(command, 1, robot), fact("chart-parser.pl", clause(5)), [], []),
                  step(terminal(noun, robot), fact("chart-parser.pl", clause(18)), [], []),
                  step(is(2, '+'(1, 1)), builtin(is, 2), [], [])
                ]
              )
            ]
          ),
          step(
            span(command, vp, 2, 5),
            rule("chart-parser.pl", clause(31)),
            ['Sentence' = command, 'Category' = vp, 'Start' = 2, 'End' = 5, 'Left' = verb, 'Right' = np, 'Middle' = 3],
            [
              step(rule(vp, verb, np), fact("chart-parser.pl", clause(27)), [], []),
              step(
                span(command, verb, 2, 3),
                rule("chart-parser.pl", clause(30)),
                ['Sentence' = command, 'Category' = verb, 'Start' = 2, 'End' = 3, 'Token' = moves],
                [
                  step(word(command, 2, moves), fact("chart-parser.pl", clause(6)), [], []),
                  step(terminal(verb, moves), fact("chart-parser.pl", clause(21)), [], []),
                  step(is(3, '+'(2, 1)), builtin(is, 2), [], [])
                ]
              ),
              step(
                span(command, np, 3, 5),
                rule("chart-parser.pl", clause(31)),
                ['Sentence' = command, 'Category' = np, 'Start' = 3, 'End' = 5, 'Left' = det, 'Right' = noun, 'Middle' = 4],
                [
                  step(rule(np, det, noun), fact("chart-parser.pl", clause(25)), [], []),
                  step(
                    span(command, det, 3, 4),
                    rule("chart-parser.pl", clause(30)),
                    ['Sentence' = command, 'Category' = det, 'Start' = 3, 'End' = 4, 'Token' = the],
                    [
                      step(word(command, 3, the), fact("chart-parser.pl", clause(7)), [], []),
                      step(terminal(det, the), fact("chart-parser.pl", clause(17)), [], []),
                      step(is(4, '+'(3, 1)), builtin(is, 2), [], [])
                    ]
                  ),
                  step(
                    span(command, noun, 4, 5),
                    rule("chart-parser.pl", clause(30)),
                    ['Sentence' = command, 'Category' = noun, 'Start' = 4, 'End' = 5, 'Token' = box],
                    [
                      step(word(command, 4, box), fact("chart-parser.pl", clause(8)), [], []),
                      step(terminal(noun, box), fact("chart-parser.pl", clause(19)), [], []),
                      step(is(5, '+'(4, 1)), builtin(is, 2), [], [])
                    ]
                  )
                ]
              )
            ]
          )
        ]
      )
    ]
  )
).

chart_parser_answer(parsed, ambiguous_pp).
why(
  chart_parser_answer(parsed, ambiguous_pp),
  step(
    chart_parser_answer(parsed, ambiguous_pp),
    rule("chart-parser.pl", clause(32)),
    ['Sentence' = ambiguous_pp, 'Length' = 8],
    [
      step(sentence(ambiguous_pp, 8), fact("chart-parser.pl", clause(3)), [], []),
      step(
        span(ambiguous_pp, s, 0, 8),
        rule("chart-parser.pl", clause(31)),
        ['Sentence' = ambiguous_pp, 'Category' = s, 'Start' = 0, 'End' = 8, 'Left' = np, 'Right' = vp, 'Middle' = 2],
        [
          step(rule(s, np, vp), fact("chart-parser.pl", clause(24)), [], []),
          step(
            span(ambiguous_pp, np, 0, 2),
            rule("chart-parser.pl", clause(31)),
            ['Sentence' = ambiguous_pp, 'Category' = np, 'Start' = 0, 'End' = 2, 'Left' = det, 'Right' = noun, 'Middle' = 1],
            [
              step(rule(np, det, noun), fact("chart-parser.pl", clause(25)), [], []),
              step(
                span(ambiguous_pp, det, 0, 1),
                rule("chart-parser.pl", clause(30)),
                ['Sentence' = ambiguous_pp, 'Category' = det, 'Start' = 0, 'End' = 1, 'Token' = the],
                [
                  step(word(ambiguous_pp, 0, the), fact("chart-parser.pl", clause(9)), [], []),
                  step(terminal(det, the), fact("chart-parser.pl", clause(17)), [], []),
                  step(is(1, '+'(0, 1)), builtin(is, 2), [], [])
                ]
              ),
              step(
                span(ambiguous_pp, noun, 1, 2),
                rule("chart-parser.pl", clause(30)),
                ['Sentence' = ambiguous_pp, 'Category' = noun, 'Start' = 1, 'End' = 2, 'Token' = robot],
                [
                  step(word(ambiguous_pp, 1, robot), fact("chart-parser.pl", clause(10)), [], []),
                  step(terminal(noun, robot), fact("chart-parser.pl", clause(18)), [], []),
                  step(is(2, '+'(1, 1)), builtin(is, 2), [], [])
                ]
              )
            ]
          ),
          step(
            span(ambiguous_pp, vp, 2, 8),
            rule("chart-parser.pl", clause(31)),
            ['Sentence' = ambiguous_pp, 'Category' = vp, 'Start' = 2, 'End' = 8, 'Left' = verb, 'Right' = np, 'Middle' = 3],
            [
              step(rule(vp, verb, np), fact("chart-parser.pl", clause(27)), [], []),
              step(
                span(ambiguous_pp, verb, 2, 3),
                rule("chart-parser.pl", clause(30)),
                ['Sentence' = ambiguous_pp, 'Category' = verb, 'Start' = 2, 'End' = 3, 'Token' = sees],
                [
                  step(word(ambiguous_pp, 2, sees), fact("chart-parser.pl", clause(11)), [], []),
                  step(terminal(verb, sees), fact("chart-parser.pl", clause(22)), [], []),
                  step(is(3, '+'(2, 1)), builtin(is, 2), [], [])
                ]
              ),
              step(
                span(ambiguous_pp, np, 3, 8),
                rule("chart-parser.pl", clause(31)),
                ['Sentence' = ambiguous_pp, 'Category' = np, 'Start' = 3, 'End' = 8, 'Left' = np, 'Right' = pp, 'Middle' = 5],
                [
                  step(rule(np, np, pp), fact("chart-parser.pl", clause(26)), [], []),
                  step(
                    span(ambiguous_pp, np, 3, 5),
                    rule("chart-parser.pl", clause(31)),
                    ['Sentence' = ambiguous_pp, 'Category' = np, 'Start' = 3, 'End' = 5, 'Left' = det, 'Right' = noun, 'Middle' = 4],
                    [
                      step(rule(np, det, noun), fact("chart-parser.pl", clause(25)), [], []),
                      step(
                        span(ambiguous_pp, det, 3, 4),
                        rule("chart-parser.pl", clause(30)),
                        ['Sentence' = ambiguous_pp, 'Category' = det, 'Start' = 3, 'End' = 4, 'Token' = the],
                        [
                          step(word(ambiguous_pp, 3, the), fact("chart-parser.pl", clause(12)), [], []),
                          step(terminal(det, the), fact("chart-parser.pl", clause(17)), [], []),
                          step(is(4, '+'(3, 1)), builtin(is, 2), [], [])
                        ]
                      ),
                      step(
                        span(ambiguous_pp, noun, 4, 5),
                        rule("chart-parser.pl", clause(30)),
                        ['Sentence' = ambiguous_pp, 'Category' = noun, 'Start' = 4, 'End' = 5, 'Token' = box],
                        [
                          step(word(ambiguous_pp, 4, box), fact("chart-parser.pl", clause(13)), [], []),
                          step(terminal(noun, box), fact("chart-parser.pl", clause(19)), [], []),
                          step(is(5, '+'(4, 1)), builtin(is, 2), [], [])
                        ]
                      )
                    ]
                  ),
                  step(
                    span(ambiguous_pp, pp, 5, 8),
                    rule("chart-parser.pl", clause(31)),
                    ['Sentence' = ambiguous_pp, 'Category' = pp, 'Start' = 5, 'End' = 8, 'Left' = prep, 'Right' = np, 'Middle' = 6],
                    [
                      step(rule(pp, prep, np), fact("chart-parser.pl", clause(29)), [], []),
                      step(
                        span(ambiguous_pp, prep, 5, 6),
                        rule("chart-parser.pl", clause(30)),
                        ['Sentence' = ambiguous_pp, 'Category' = prep, 'Start' = 5, 'End' = 6, 'Token' = with],
                        [
                          step(word(ambiguous_pp, 5, with), fact("chart-parser.pl", clause(14)), [], []),
                          step(terminal(prep, with), fact("chart-parser.pl", clause(23)), [], []),
                          step(is(6, '+'(5, 1)), builtin(is, 2), [], [])
                        ]
                      ),
                      step(
                        span(ambiguous_pp, np, 6, 8),
                        rule("chart-parser.pl", clause(31)),
                        ['Sentence' = ambiguous_pp, 'Category' = np, 'Start' = 6, 'End' = 8, 'Left' = det, 'Right' = noun, 'Middle' = 7],
                        [
                          step(rule(np, det, noun), fact("chart-parser.pl", clause(25)), [], []),
                          step(
                            span(ambiguous_pp, det, 6, 7),
                            rule("chart-parser.pl", clause(30)),
                            ['Sentence' = ambiguous_pp, 'Category' = det, 'Start' = 6, 'End' = 7, 'Token' = the],
                            [
                              step(word(ambiguous_pp, 6, the), fact("chart-parser.pl", clause(15)), [], []),
                              step(terminal(det, the), fact("chart-parser.pl", clause(17)), [], []),
                              step(is(7, '+'(6, 1)), builtin(is, 2), [], [])
                            ]
                          ),
                          step(
                            span(ambiguous_pp, noun, 7, 8),
                            rule("chart-parser.pl", clause(30)),
                            ['Sentence' = ambiguous_pp, 'Category' = noun, 'Start' = 7, 'End' = 8, 'Token' = telescope],
                            [
                              step(word(ambiguous_pp, 7, telescope), fact("chart-parser.pl", clause(16)), [], []),
                              step(terminal(noun, telescope), fact("chart-parser.pl", clause(20)), [], []),
                              step(is(8, '+'(7, 1)), builtin(is, 2), [], [])
                            ]
                          )
                        ]
                      )
                    ]
                  )
                ]
              )
            ]
          )
        ]
      )
    ]
  )
).

chart_parser_answer(parse_count, count(command, 1)).
why(
  chart_parser_answer(parse_count, count(command, 1)),
  step(
    chart_parser_answer(parse_count, count(command, 1)),
    rule("chart-parser.pl", clause(33)),
    ['Sentence' = command, 'Count' = 1, 'Length' = 5],
    [
      step(sentence(command, 5), fact("chart-parser.pl", clause(2)), [], []),
      step(countall(span(command, s, 0, 5), 1), library(countall, 2), [], [])
    ]
  )
).

chart_parser_answer(parse_count, count(ambiguous_pp, 1)).
why(
  chart_parser_answer(parse_count, count(ambiguous_pp, 1)),
  step(
    chart_parser_answer(parse_count, count(ambiguous_pp, 1)),
    rule("chart-parser.pl", clause(33)),
    ['Sentence' = ambiguous_pp, 'Count' = 1, 'Length' = 8],
    [
      step(sentence(ambiguous_pp, 8), fact("chart-parser.pl", clause(3)), [], []),
      step(countall(span(ambiguous_pp, s, 0, 8), 1), library(countall, 2), [], [])
    ]
  )
).

chart_parser_answer(noun_phrase_count, count(command, 2)).
why(
  chart_parser_answer(noun_phrase_count, count(command, 2)),
  step(
    chart_parser_answer(noun_phrase_count, count(command, 2)),
    rule("chart-parser.pl", clause(34)),
    ['Sentence' = command, 'Count' = 2, 'Length' = 5],
    [
      step(sentence(command, 5), fact("chart-parser.pl", clause(2)), [], []),
      step(countall(span(command, np, _start, _end), 2), library(countall, 2), [], []),
      step(>(5, 0), builtin(>, 2), [], [])
    ]
  )
).

chart_parser_answer(noun_phrase_count, count(ambiguous_pp, 4)).
why(
  chart_parser_answer(noun_phrase_count, count(ambiguous_pp, 4)),
  step(
    chart_parser_answer(noun_phrase_count, count(ambiguous_pp, 4)),
    rule("chart-parser.pl", clause(34)),
    ['Sentence' = ambiguous_pp, 'Count' = 4, 'Length' = 8],
    [
      step(sentence(ambiguous_pp, 8), fact("chart-parser.pl", clause(3)), [], []),
      step(countall(span(ambiguous_pp, np, _start, _end), 4), library(countall, 2), [], []),
      step(>(8, 0), builtin(>, 2), [], [])
    ]
  )
).

