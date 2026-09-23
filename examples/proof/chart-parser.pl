chart_parser_answer(parsed, command).
chart_parser_answer(parsed, ambiguous_pp).
chart_parser_answer(parse_count, count(command, 1)).
chart_parser_answer(parse_count, count(ambiguous_pp, 1)).
chart_parser_answer(noun_phrase_count, count(command, 2)).
chart_parser_answer(noun_phrase_count, count(ambiguous_pp, 4)).

clause(2, sentence(command, 5), true).
clause(3, sentence(ambiguous_pp, 8), true).
clause(4, word(command, 0, the), true).
clause(5, word(command, 1, robot), true).
clause(6, word(command, 2, moves), true).
clause(7, word(command, 3, the), true).
clause(8, word(command, 4, box), true).
clause(9, word(ambiguous_pp, 0, the), true).
clause(10, word(ambiguous_pp, 1, robot), true).
clause(11, word(ambiguous_pp, 2, sees), true).
clause(12, word(ambiguous_pp, 3, the), true).
clause(13, word(ambiguous_pp, 4, box), true).
clause(14, word(ambiguous_pp, 5, with), true).
clause(15, word(ambiguous_pp, 6, the), true).
clause(16, word(ambiguous_pp, 7, telescope), true).
clause(17, terminal(det, the), true).
clause(18, terminal(noun, robot), true).
clause(19, terminal(noun, box), true).
clause(20, terminal(noun, telescope), true).
clause(21, terminal(verb, moves), true).
clause(22, terminal(verb, sees), true).
clause(23, terminal(prep, with), true).
clause(24, rule(s, np, vp), true).
clause(25, rule(np, det, noun), true).
clause(26, rule(np, np, pp), true).
clause(27, rule(vp, verb, np), true).
clause(29, rule(pp, prep, np), true).
clause(30,
       span(var('Sentence'), var('Category'), var('Start'), var('End')),
       (word(var('Sentence'), var('Start'), var('Token')),
        terminal(var('Category'), var('Token')),
        var('End') is var('Start') + 1)).
clause(31,
       span(var('Sentence'), var('Category'), var('Start'), var('End')),
       (rule(var('Category'), var('Left'), var('Right')),
        span(var('Sentence'), var('Left'), var('Start'), var('Middle')),
        span(var('Sentence'), var('Right'), var('Middle'), var('End')))).
clause(32,
       chart_parser_answer(parsed, var('Sentence')),
       (sentence(var('Sentence'), var('Length')), span(var('Sentence'), s, 0, var('Length')))).
clause(33,
       chart_parser_answer(parse_count, count(var('Sentence'), var('Count'))),
       (sentence(var('Sentence'), var('Length')),
        countall(span(var('Sentence'), s, 0, var('Length')), var('Count')))).
clause(34,
       chart_parser_answer(noun_phrase_count, count(var('Sentence'), var('Count'))),
       (sentence(var('Sentence'), var('Length')),
        countall(span(var('Sentence'), np, anonymous(1), anonymous(2)), var('Count')),
        var('Length') > 0)).

step(chart_parser_answer(parsed, command),
     rule(32),
     ['Sentence' = command, 'Length' = 5],
     [sentence(command, 5), span(command, s, 0, 5)]).
step(sentence(command, 5), fact(2), [], []).
step(span(command, s, 0, 5),
     rule(31),
     ['Sentence' = command,
      'Category' = s,
      'Start' = 0,
      'End' = 5,
      'Left' = np,
      'Right' = vp,
      'Middle' = 2],
     [rule(s, np, vp), span(command, np, 0, 2), span(command, vp, 2, 5)]).
step(rule(s, np, vp), fact(24), [], []).
step(span(command, np, 0, 2),
     rule(31),
     ['Sentence' = command,
      'Category' = np,
      'Start' = 0,
      'End' = 2,
      'Left' = det,
      'Right' = noun,
      'Middle' = 1],
     [rule(np, det, noun), span(command, det, 0, 1), span(command, noun, 1, 2)]).
step(rule(np, det, noun), fact(25), [], []).
step(span(command, det, 0, 1),
     rule(30),
     ['Sentence' = command, 'Category' = det, 'Start' = 0, 'End' = 1, 'Token' = the],
     [word(command, 0, the), terminal(det, the), 1 is 0 + 1]).
step(word(command, 0, the), fact(4), [], []).
step(terminal(det, the), fact(17), [], []).
step(1 is 0 + 1, builtin, [], []).
step(span(command, noun, 1, 2),
     rule(30),
     ['Sentence' = command, 'Category' = noun, 'Start' = 1, 'End' = 2, 'Token' = robot],
     [word(command, 1, robot), terminal(noun, robot), 2 is 1 + 1]).
step(word(command, 1, robot), fact(5), [], []).
step(terminal(noun, robot), fact(18), [], []).
step(2 is 1 + 1, builtin, [], []).
step(span(command, vp, 2, 5),
     rule(31),
     ['Sentence' = command,
      'Category' = vp,
      'Start' = 2,
      'End' = 5,
      'Left' = verb,
      'Right' = np,
      'Middle' = 3],
     [rule(vp, verb, np), span(command, verb, 2, 3), span(command, np, 3, 5)]).
step(rule(vp, verb, np), fact(27), [], []).
step(span(command, verb, 2, 3),
     rule(30),
     ['Sentence' = command, 'Category' = verb, 'Start' = 2, 'End' = 3, 'Token' = moves],
     [word(command, 2, moves), terminal(verb, moves), 3 is 2 + 1]).
step(word(command, 2, moves), fact(6), [], []).
step(terminal(verb, moves), fact(21), [], []).
step(3 is 2 + 1, builtin, [], []).
step(span(command, np, 3, 5),
     rule(31),
     ['Sentence' = command,
      'Category' = np,
      'Start' = 3,
      'End' = 5,
      'Left' = det,
      'Right' = noun,
      'Middle' = 4],
     [rule(np, det, noun), span(command, det, 3, 4), span(command, noun, 4, 5)]).
step(span(command, det, 3, 4),
     rule(30),
     ['Sentence' = command, 'Category' = det, 'Start' = 3, 'End' = 4, 'Token' = the],
     [word(command, 3, the), terminal(det, the), 4 is 3 + 1]).
step(word(command, 3, the), fact(7), [], []).
step(4 is 3 + 1, builtin, [], []).
step(span(command, noun, 4, 5),
     rule(30),
     ['Sentence' = command, 'Category' = noun, 'Start' = 4, 'End' = 5, 'Token' = box],
     [word(command, 4, box), terminal(noun, box), 5 is 4 + 1]).
step(word(command, 4, box), fact(8), [], []).
step(terminal(noun, box), fact(19), [], []).
step(5 is 4 + 1, builtin, [], []).
step(chart_parser_answer(parsed, ambiguous_pp),
     rule(32),
     ['Sentence' = ambiguous_pp, 'Length' = 8],
     [sentence(ambiguous_pp, 8), span(ambiguous_pp, s, 0, 8)]).
step(sentence(ambiguous_pp, 8), fact(3), [], []).
step(span(ambiguous_pp, s, 0, 8),
     rule(31),
     ['Sentence' = ambiguous_pp,
      'Category' = s,
      'Start' = 0,
      'End' = 8,
      'Left' = np,
      'Right' = vp,
      'Middle' = 2],
     [rule(s, np, vp), span(ambiguous_pp, np, 0, 2), span(ambiguous_pp, vp, 2, 8)]).
step(span(ambiguous_pp, np, 0, 2),
     rule(31),
     ['Sentence' = ambiguous_pp,
      'Category' = np,
      'Start' = 0,
      'End' = 2,
      'Left' = det,
      'Right' = noun,
      'Middle' = 1],
     [rule(np, det, noun), span(ambiguous_pp, det, 0, 1), span(ambiguous_pp, noun, 1, 2)]).
step(span(ambiguous_pp, det, 0, 1),
     rule(30),
     ['Sentence' = ambiguous_pp, 'Category' = det, 'Start' = 0, 'End' = 1, 'Token' = the],
     [word(ambiguous_pp, 0, the), terminal(det, the), 1 is 0 + 1]).
step(word(ambiguous_pp, 0, the), fact(9), [], []).
step(span(ambiguous_pp, noun, 1, 2),
     rule(30),
     ['Sentence' = ambiguous_pp, 'Category' = noun, 'Start' = 1, 'End' = 2, 'Token' = robot],
     [word(ambiguous_pp, 1, robot), terminal(noun, robot), 2 is 1 + 1]).
step(word(ambiguous_pp, 1, robot), fact(10), [], []).
step(span(ambiguous_pp, vp, 2, 8),
     rule(31),
     ['Sentence' = ambiguous_pp,
      'Category' = vp,
      'Start' = 2,
      'End' = 8,
      'Left' = verb,
      'Right' = np,
      'Middle' = 3],
     [rule(vp, verb, np), span(ambiguous_pp, verb, 2, 3), span(ambiguous_pp, np, 3, 8)]).
step(span(ambiguous_pp, verb, 2, 3),
     rule(30),
     ['Sentence' = ambiguous_pp, 'Category' = verb, 'Start' = 2, 'End' = 3, 'Token' = sees],
     [word(ambiguous_pp, 2, sees), terminal(verb, sees), 3 is 2 + 1]).
step(word(ambiguous_pp, 2, sees), fact(11), [], []).
step(terminal(verb, sees), fact(22), [], []).
step(span(ambiguous_pp, np, 3, 8),
     rule(31),
     ['Sentence' = ambiguous_pp,
      'Category' = np,
      'Start' = 3,
      'End' = 8,
      'Left' = np,
      'Right' = pp,
      'Middle' = 5],
     [rule(np, np, pp), span(ambiguous_pp, np, 3, 5), span(ambiguous_pp, pp, 5, 8)]).
step(rule(np, np, pp), fact(26), [], []).
step(span(ambiguous_pp, np, 3, 5),
     rule(31),
     ['Sentence' = ambiguous_pp,
      'Category' = np,
      'Start' = 3,
      'End' = 5,
      'Left' = det,
      'Right' = noun,
      'Middle' = 4],
     [rule(np, det, noun), span(ambiguous_pp, det, 3, 4), span(ambiguous_pp, noun, 4, 5)]).
step(span(ambiguous_pp, det, 3, 4),
     rule(30),
     ['Sentence' = ambiguous_pp, 'Category' = det, 'Start' = 3, 'End' = 4, 'Token' = the],
     [word(ambiguous_pp, 3, the), terminal(det, the), 4 is 3 + 1]).
step(word(ambiguous_pp, 3, the), fact(12), [], []).
step(span(ambiguous_pp, noun, 4, 5),
     rule(30),
     ['Sentence' = ambiguous_pp, 'Category' = noun, 'Start' = 4, 'End' = 5, 'Token' = box],
     [word(ambiguous_pp, 4, box), terminal(noun, box), 5 is 4 + 1]).
step(word(ambiguous_pp, 4, box), fact(13), [], []).
step(span(ambiguous_pp, pp, 5, 8),
     rule(31),
     ['Sentence' = ambiguous_pp,
      'Category' = pp,
      'Start' = 5,
      'End' = 8,
      'Left' = prep,
      'Right' = np,
      'Middle' = 6],
     [rule(pp, prep, np), span(ambiguous_pp, prep, 5, 6), span(ambiguous_pp, np, 6, 8)]).
step(rule(pp, prep, np), fact(29), [], []).
step(span(ambiguous_pp, prep, 5, 6),
     rule(30),
     ['Sentence' = ambiguous_pp, 'Category' = prep, 'Start' = 5, 'End' = 6, 'Token' = with],
     [word(ambiguous_pp, 5, with), terminal(prep, with), 6 is 5 + 1]).
step(word(ambiguous_pp, 5, with), fact(14), [], []).
step(terminal(prep, with), fact(23), [], []).
step(6 is 5 + 1, builtin, [], []).
step(span(ambiguous_pp, np, 6, 8),
     rule(31),
     ['Sentence' = ambiguous_pp,
      'Category' = np,
      'Start' = 6,
      'End' = 8,
      'Left' = det,
      'Right' = noun,
      'Middle' = 7],
     [rule(np, det, noun), span(ambiguous_pp, det, 6, 7), span(ambiguous_pp, noun, 7, 8)]).
step(span(ambiguous_pp, det, 6, 7),
     rule(30),
     ['Sentence' = ambiguous_pp, 'Category' = det, 'Start' = 6, 'End' = 7, 'Token' = the],
     [word(ambiguous_pp, 6, the), terminal(det, the), 7 is 6 + 1]).
step(word(ambiguous_pp, 6, the), fact(15), [], []).
step(7 is 6 + 1, builtin, [], []).
step(span(ambiguous_pp, noun, 7, 8),
     rule(30),
     ['Sentence' = ambiguous_pp, 'Category' = noun, 'Start' = 7, 'End' = 8, 'Token' = telescope],
     [word(ambiguous_pp, 7, telescope), terminal(noun, telescope), 8 is 7 + 1]).
step(word(ambiguous_pp, 7, telescope), fact(16), [], []).
step(terminal(noun, telescope), fact(20), [], []).
step(8 is 7 + 1, builtin, [], []).
step(chart_parser_answer(parse_count, count(command, 1)),
     rule(33),
     ['Sentence' = command, 'Count' = 1, 'Length' = 5],
     [sentence(command, 5), countall(span(command, s, 0, 5), 1)]).
step(countall(span(command, s, 0, 5), 1), builtin, [], []).
step(chart_parser_answer(parse_count, count(ambiguous_pp, 1)),
     rule(33),
     ['Sentence' = ambiguous_pp, 'Count' = 1, 'Length' = 8],
     [sentence(ambiguous_pp, 8), countall(span(ambiguous_pp, s, 0, 8), 1)]).
step(countall(span(ambiguous_pp, s, 0, 8), 1), builtin, [], []).
step(chart_parser_answer(noun_phrase_count, count(command, 2)),
     rule(34),
     ['Sentence' = command, 'Count' = 2, 'Length' = 5],
     [sentence(command, 5), countall(span(command, np, _start, _end), 2), 5 > 0]).
step(countall(span(command, np, _start, _end), 2), builtin, [], []).
step(5 > 0, builtin, [], []).
step(chart_parser_answer(noun_phrase_count, count(ambiguous_pp, 4)),
     rule(34),
     ['Sentence' = ambiguous_pp, 'Count' = 4, 'Length' = 8],
     [sentence(ambiguous_pp, 8), countall(span(ambiguous_pp, np, _start, _end), 4), 8 > 0]).
step(countall(span(ambiguous_pp, np, _start, _end), 4), builtin, [], []).
step(8 > 0, builtin, [], []).
