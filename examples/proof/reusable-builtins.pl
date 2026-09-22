report(normalized_name, 'ada lovelace').
why(
  report(normalized_name, 'ada lovelace'),
  step(
    report(normalized_name, 'ada lovelace'),
    rule("reusable-builtins.pl", clause(4)),
    ['Name' = 'ada lovelace', 'Raw' = '  Ada Lovelace  ', 'Trimmed' = 'Ada Lovelace'],
    [
      step(name_raw('  Ada Lovelace  '), fact("reusable-builtins.pl", clause(1)), [], []),
      step(trim('  Ada Lovelace  ', 'Ada Lovelace'), library(trim, 2), [], []),
      step(lowercase('Ada Lovelace', 'ada lovelace'), library(lowercase, 2), [], [])
    ]
  )
).

report(unique_tags, [logic, math, programming]).
why(
  report(unique_tags, [logic, math, programming]),
  step(
    report(unique_tags, [logic, math, programming]),
    rule("reusable-builtins.pl", clause(5)),
    ['Tags' = [logic, math, programming], 'Csv' = 'logic,math,logic,programming', 'Parts' = [logic, math, logic, programming]],
    [
      step(tag_csv('logic,math,logic,programming'), fact("reusable-builtins.pl", clause(2)), [], []),
      step(split('logic,math,logic,programming', ',', [logic, math, logic, programming]), library(split, 3), [], []),
      step(list_to_set([logic, math, logic, programming], [logic, math, programming]), library(list_to_set, 2), [], [])
    ]
  )
).

report(tag_label, 'logic / math / programming').
why(
  report(tag_label, 'logic / math / programming'),
  step(
    report(tag_label, 'logic / math / programming'),
    rule("reusable-builtins.pl", clause(6)),
    ['Label' = 'logic / math / programming', 'Csv' = 'logic,math,logic,programming', 'Parts' = [logic, math, logic, programming], 'Tags' = [logic, math, programming]],
    [
      step(tag_csv('logic,math,logic,programming'), fact("reusable-builtins.pl", clause(2)), [], []),
      step(split('logic,math,logic,programming', ',', [logic, math, logic, programming]), library(split, 3), [], []),
      step(list_to_set([logic, math, logic, programming], [logic, math, programming]), library(list_to_set, 2), [], []),
      step(join([logic, math, programming], ' / ', 'logic / math / programming'), library(join, 3), [], [])
    ]
  )
).

report(score_summary, summary(42, 21, 6.48074069840786)).
why(
  report(score_summary, summary(42, 21, 6.48074069840786)),
  step(
    report(score_summary, summary(42, 21, 6.48074069840786)),
    rule("reusable-builtins.pl", clause(7)),
    ['Total' = 42, 'Peak' = 21, 'Roottotal' = 6.48074069840786, 'Scores' = [8, 13, 21]],
    [
      step(scores([8, 13, 21]), fact("reusable-builtins.pl", clause(3)), [], []),
      step(sum_list([8, 13, 21], 42), library(sum_list, 2), [], []),
      step(max_list([8, 13, 21], 21), library(max_list, 2), [], []),
      step(is(6.48074069840786, sqrt(42)), builtin(is, 2), [], [])
    ]
  )
).

report(window, [13, 21]).
why(
  report(window, [13, 21]),
  step(
    report(window, [13, 21]),
    rule("reusable-builtins.pl", clause(8)),
    ['Slice' = [13, 21], 'Scores' = [8, 13, 21]],
    [
      step(scores([8, 13, 21]), fact("reusable-builtins.pl", clause(3)), [], []),
      step(slice(1, 2, [8, 13, 21], [13, 21]), library(slice, 4), [], [])
    ]
  )
).

