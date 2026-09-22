% Prolog result format 4
query(1, report(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 5).
answer(1, ['X0' = normalized_name, 'X1' = 'ada lovelace']).
why(1,
    ['X0' = normalized_name, 'X1' = 'ada lovelace'],
    [report(normalized_name, 'ada lovelace')]).
answer(1, ['X0' = unique_tags, 'X1' = [logic, math, programming]]).
why(1,
    ['X0' = unique_tags, 'X1' = [logic, math, programming]],
    [report(unique_tags, [logic, math, programming])]).
answer(1, ['X0' = tag_label, 'X1' = 'logic / math / programming']).
why(1,
    ['X0' = tag_label, 'X1' = 'logic / math / programming'],
    [report(tag_label, 'logic / math / programming')]).
answer(1, ['X0' = score_summary, 'X1' = summary(42, 21, 6.48074069840786)]).
why(1,
    ['X0' = score_summary, 'X1' = summary(42, 21, 6.48074069840786)],
    [report(score_summary, summary(42, 21, 6.48074069840786))]).
answer(1, ['X0' = window, 'X1' = [13, 21]]).
why(1, ['X0' = window, 'X1' = [13, 21]], [report(window, [13, 21])]).

clause(1, name_raw('  Ada Lovelace  '), true).
clause(2, tag_csv('logic,math,logic,programming'), true).
clause(3, scores([8, 13, 21]), true).
clause(4,
       report(normalized_name, var('Name')),
       (name_raw(var('Raw')),
        trim(var('Raw'), var('Trimmed')),
        lowercase(var('Trimmed'), var('Name')))).
clause(5,
       report(unique_tags, var('Tags')),
       (tag_csv(var('Csv')),
        split(var('Csv'), ',', var('Parts')),
        list_to_set(var('Parts'), var('Tags')))).
clause(6,
       report(tag_label, var('Label')),
       (tag_csv(var('Csv')),
        split(var('Csv'), ',', var('Parts')),
        list_to_set(var('Parts'), var('Tags')),
        join(var('Tags'), ' / ', var('Label')))).
clause(7,
       report(score_summary, summary(var('Total'), var('Peak'), var('Roottotal'))),
       (scores(var('Scores')),
        sum_list(var('Scores'), var('Total')),
        max_list(var('Scores'), var('Peak')),
        var('Roottotal') is sqrt(var('Total')))).
clause(8,
       report(window, var('Slice')),
       (scores(var('Scores')), slice(1, 2, var('Scores'), var('Slice')))).

step(report(normalized_name, 'ada lovelace'),
     rule(4),
     ['Name' = 'ada lovelace', 'Raw' = '  Ada Lovelace  ', 'Trimmed' = 'Ada Lovelace'],
     [name_raw('  Ada Lovelace  '),
      trim('  Ada Lovelace  ', 'Ada Lovelace'),
      lowercase('Ada Lovelace', 'ada lovelace')]).
step(name_raw('  Ada Lovelace  '), fact(1), [], []).
step(trim('  Ada Lovelace  ', 'Ada Lovelace'), builtin, [], []).
step(lowercase('Ada Lovelace', 'ada lovelace'), builtin, [], []).
step(report(unique_tags, [logic, math, programming]),
     rule(5),
     ['Tags' = [logic, math, programming],
      'Csv' = 'logic,math,logic,programming',
      'Parts' = [logic, math, logic, programming]],
     [tag_csv('logic,math,logic,programming'),
      split('logic,math,logic,programming', ',', [logic, math, logic, programming]),
      list_to_set([logic, math, logic, programming], [logic, math, programming])]).
step(tag_csv('logic,math,logic,programming'), fact(2), [], []).
step(split('logic,math,logic,programming', ',', [logic, math, logic, programming]),
     builtin,
     [],
     []).
step(list_to_set([logic, math, logic, programming], [logic, math, programming]),
     builtin,
     [],
     []).
step(report(tag_label, 'logic / math / programming'),
     rule(6),
     ['Label' = 'logic / math / programming',
      'Csv' = 'logic,math,logic,programming',
      'Parts' = [logic, math, logic, programming],
      'Tags' = [logic, math, programming]],
     [tag_csv('logic,math,logic,programming'),
      split('logic,math,logic,programming', ',', [logic, math, logic, programming]),
      list_to_set([logic, math, logic, programming], [logic, math, programming]),
      join([logic, math, programming], ' / ', 'logic / math / programming')]).
step(join([logic, math, programming], ' / ', 'logic / math / programming'), builtin, [], []).
step(report(score_summary, summary(42, 21, 6.48074069840786)),
     rule(7),
     ['Total' = 42, 'Peak' = 21, 'Roottotal' = 6.48074069840786, 'Scores' = [8, 13, 21]],
     [scores([8, 13, 21]),
      sum_list([8, 13, 21], 42),
      max_list([8, 13, 21], 21),
      6.48074069840786 is sqrt(42)]).
step(scores([8, 13, 21]), fact(3), [], []).
step(sum_list([8, 13, 21], 42), builtin, [], []).
step(max_list([8, 13, 21], 21), builtin, [], []).
step(6.48074069840786 is sqrt(42), builtin, [], []).
step(report(window, [13, 21]),
     rule(8),
     ['Slice' = [13, 21], 'Scores' = [8, 13, 21]],
     [scores([8, 13, 21]), slice(1, 2, [8, 13, 21], [13, 21])]).
step(slice(1, 2, [8, 13, 21], [13, 21]), builtin, [], []).
