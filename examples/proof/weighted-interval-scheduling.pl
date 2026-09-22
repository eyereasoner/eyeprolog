% Prolog result format 4
query(1, weighted_interval_answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 5).
answer(1, ['X0' = best_value, 'X1' = 13]).
why(1, ['X0' = best_value, 'X1' = 13], [weighted_interval_answer(best_value, 13)]).
answer(1, ['X0' = chosen_interval, 'X1' = interval(1, 1, 4, 5)]).
why(1,
    ['X0' = chosen_interval, 'X1' = interval(1, 1, 4, 5)],
    [weighted_interval_answer(chosen_interval, interval(1, 1, 4, 5))]).
answer(1, ['X0' = chosen_interval, 'X1' = interval(4, 4, 7, 4)]).
why(1,
    ['X0' = chosen_interval, 'X1' = interval(4, 4, 7, 4)],
    [weighted_interval_answer(chosen_interval, interval(4, 4, 7, 4))]).
answer(1, ['X0' = chosen_interval, 'X1' = interval(8, 8, 11, 4)]).
why(1,
    ['X0' = chosen_interval, 'X1' = interval(8, 8, 11, 4)],
    [weighted_interval_answer(chosen_interval, interval(8, 8, 11, 4))]).
answer(1, ['X0' = candidate_count, 'X1' = 8]).
why(1, ['X0' = candidate_count, 'X1' = 8], [weighted_interval_answer(candidate_count, 8)]).

clause(2, last_interval(8), true).
clause(4, interval(1, 1, 4, 5), true).
clause(5, interval(2, 3, 5, 1), true).
clause(6, interval(3, 0, 6, 8), true).
clause(7, interval(4, 4, 7, 4), true).
clause(8, interval(5, 3, 9, 6), true).
clause(9, interval(6, 5, 9, 3), true).
clause(10, interval(7, 6, 10, 2), true).
clause(11, interval(8, 8, 11, 4), true).
clause(12,
       next_compatible(var('I'), var('J')),
       (interval(var('I'), anonymous(1), var('Finish'), anonymous(2)),
        aggregate_min(var('K'), var('K'), (interval(var('K'), var('Startk'), anonymous(3), anonymous(4)), var('K') > var('I'), var('Startk') >= var('Finish')), var('J'), var('J')))).
clause(13,
       next_compatible(var('I'), 9),
       (interval(var('I'), anonymous(1), var('Finish'), anonymous(2)),
        \+ (interval(var('K'), var('Startk'), anonymous(3), anonymous(4)), var('K') > var('I'), var('Startk') >= var('Finish')))).
clause(14, best_from(9, 0), true).
clause(15,
       best_from(var('I'), var('Best')),
       (last_interval(var('Last')),
        var('I') =< var('Last'),
        var('Next') is var('I') + 1,
        best_from(var('Next'), var('Skip')),
        next_compatible(var('I'), var('Compatible')),
        best_from(var('Compatible'), var('Tail')),
        interval(var('I'), anonymous(1), anonymous(2), var('Value')),
        var('Take') is var('Value') + var('Tail'),
        (var('Take') >= var('Skip') -> var('Best') = var('Take') ; var('Best') = var('Skip')))).
clause(16,
       chosen_from(var('I'), var('I')),
       (best_from(var('I'), var('Best')),
        var('Next') is var('I') + 1,
        best_from(var('Next'), var('Skip')),
        next_compatible(var('I'), var('Compatible')),
        best_from(var('Compatible'), var('Tail')),
        interval(var('I'), anonymous(1), anonymous(2), var('Value')),
        var('Take') is var('Value') + var('Tail'),
        var('Best') = var('Take'),
        var('Take') >= var('Skip'))).
clause(17,
       chosen_from(var('I'), var('Chosen')),
       (best_from(var('I'), var('Best')),
        var('Next') is var('I') + 1,
        best_from(var('Next'), var('Skip')),
        next_compatible(var('I'), var('Compatible')),
        best_from(var('Compatible'), var('Tail')),
        interval(var('I'), anonymous(1), anonymous(2), var('Value')),
        var('Take') is var('Value') + var('Tail'),
        var('Best') = var('Take'),
        var('Take') >= var('Skip'),
        chosen_from(var('Compatible'), var('Chosen')))).
clause(19, weighted_interval_answer(best_value, var('Best')), best_from(1, var('Best'))).
clause(20,
       weighted_interval_answer(chosen_interval, interval(var('I'), var('Start'), var('Finish'), var('Value'))),
       (chosen_from(1, var('I')), interval(var('I'), var('Start'), var('Finish'), var('Value')))).
clause(21,
       weighted_interval_answer(candidate_count, var('Count')),
       countall(interval(anonymous(1), anonymous(2), anonymous(3), anonymous(4)), var('Count'))).

step(weighted_interval_answer(best_value, 13), rule(19), ['Best' = 13], [best_from(1, 13)]).
step(best_from(1, 13),
     rule(15),
     ['I' = 1,
      'Best' = 13,
      'Last' = 8,
      'Next' = 2,
      'Skip' = 12,
      'Compatible' = 4,
      'Tail' = 8,
      'Value' = 5,
      'Take' = 13],
     [last_interval(8),
      1 =< 8,
      2 is 1 + 1,
      best_from(2, 12),
      next_compatible(1, 4),
      best_from(4, 8),
      interval(1, 1, 4, 5),
      13 is 5 + 8,
      (13 >= 12 -> 13 = 13 ; 13 = 12)]).
step(last_interval(8), fact(2), [], []).
step(1 =< 8, builtin, [], []).
step(2 is 1 + 1, builtin, [], []).
step(best_from(2, 12),
     rule(15),
     ['I' = 2,
      'Best' = 12,
      'Last' = 8,
      'Next' = 3,
      'Skip' = 12,
      'Compatible' = 6,
      'Tail' = 4,
      'Value' = 1,
      'Take' = 5],
     [last_interval(8),
      2 =< 8,
      3 is 2 + 1,
      best_from(3, 12),
      next_compatible(2, 6),
      best_from(6, 4),
      interval(2, 3, 5, 1),
      5 is 1 + 4,
      (5 >= 12 -> 12 = 5 ; 12 = 12)]).
step(2 =< 8, builtin, [], []).
step(3 is 2 + 1, builtin, [], []).
step(best_from(3, 12),
     rule(15),
     ['I' = 3,
      'Best' = 12,
      'Last' = 8,
      'Next' = 4,
      'Skip' = 8,
      'Compatible' = 7,
      'Tail' = 4,
      'Value' = 8,
      'Take' = 12],
     [last_interval(8),
      3 =< 8,
      4 is 3 + 1,
      best_from(4, 8),
      next_compatible(3, 7),
      best_from(7, 4),
      interval(3, 0, 6, 8),
      12 is 8 + 4,
      (12 >= 8 -> 12 = 12 ; 12 = 8)]).
step(3 =< 8, builtin, [], []).
step(4 is 3 + 1, builtin, [], []).
step(best_from(4, 8),
     rule(15),
     ['I' = 4,
      'Best' = 8,
      'Last' = 8,
      'Next' = 5,
      'Skip' = 6,
      'Compatible' = 8,
      'Tail' = 4,
      'Value' = 4,
      'Take' = 8],
     [last_interval(8),
      4 =< 8,
      5 is 4 + 1,
      best_from(5, 6),
      next_compatible(4, 8),
      best_from(8, 4),
      interval(4, 4, 7, 4),
      8 is 4 + 4,
      (8 >= 6 -> 8 = 8 ; 8 = 6)]).
step(4 =< 8, builtin, [], []).
step(5 is 4 + 1, builtin, [], []).
step(best_from(5, 6),
     rule(15),
     ['I' = 5,
      'Best' = 6,
      'Last' = 8,
      'Next' = 6,
      'Skip' = 4,
      'Compatible' = 9,
      'Tail' = 0,
      'Value' = 6,
      'Take' = 6],
     [last_interval(8),
      5 =< 8,
      6 is 5 + 1,
      best_from(6, 4),
      next_compatible(5, 9),
      best_from(9, 0),
      interval(5, 3, 9, 6),
      6 is 6 + 0,
      (6 >= 4 -> 6 = 6 ; 6 = 4)]).
step(5 =< 8, builtin, [], []).
step(6 is 5 + 1, builtin, [], []).
step(best_from(6, 4),
     rule(15),
     ['I' = 6,
      'Best' = 4,
      'Last' = 8,
      'Next' = 7,
      'Skip' = 4,
      'Compatible' = 9,
      'Tail' = 0,
      'Value' = 3,
      'Take' = 3],
     [last_interval(8),
      6 =< 8,
      7 is 6 + 1,
      best_from(7, 4),
      next_compatible(6, 9),
      best_from(9, 0),
      interval(6, 5, 9, 3),
      3 is 3 + 0,
      (3 >= 4 -> 4 = 3 ; 4 = 4)]).
step(6 =< 8, builtin, [], []).
step(7 is 6 + 1, builtin, [], []).
step(best_from(7, 4),
     rule(15),
     ['I' = 7,
      'Best' = 4,
      'Last' = 8,
      'Next' = 8,
      'Skip' = 4,
      'Compatible' = 9,
      'Tail' = 0,
      'Value' = 2,
      'Take' = 2],
     [last_interval(8),
      7 =< 8,
      8 is 7 + 1,
      best_from(8, 4),
      next_compatible(7, 9),
      best_from(9, 0),
      interval(7, 6, 10, 2),
      2 is 2 + 0,
      (2 >= 4 -> 4 = 2 ; 4 = 4)]).
step(7 =< 8, builtin, [], []).
step(8 is 7 + 1, builtin, [], []).
step(best_from(8, 4),
     rule(15),
     ['I' = 8,
      'Best' = 4,
      'Last' = 8,
      'Next' = 9,
      'Skip' = 0,
      'Compatible' = 9,
      'Tail' = 0,
      'Value' = 4,
      'Take' = 4],
     [last_interval(8),
      8 =< 8,
      9 is 8 + 1,
      best_from(9, 0),
      next_compatible(8, 9),
      best_from(9, 0),
      interval(8, 8, 11, 4),
      4 is 4 + 0,
      (4 >= 0 -> 4 = 4 ; 4 = 0)]).
step(8 =< 8, builtin, [], []).
step(9 is 8 + 1, builtin, [], []).
step(best_from(9, 0), fact(14), [], []).
step(next_compatible(8, 9),
     rule(13),
     ['I' = 8, 'Finish' = 11],
     [interval(8, 8, 11, 4), \+ (interval(K, Startk, _finishk, _valuek), K > 8, Startk >= 11)]).
step(interval(8, 8, 11, 4), fact(11), [], []).
step(\+ (interval(K, Startk, _finishk, _valuek), K > 8, Startk >= 11), absent, [], []).
step(4 is 4 + 0, builtin, [], []).
step((4 >= 0 -> 4 = 4 ; 4 = 0), builtin, [], []).
step(next_compatible(7, 9),
     rule(13),
     ['I' = 7, 'Finish' = 10],
     [interval(7, 6, 10, 2), \+ (interval(K, Startk, _finishk, _valuek), K > 7, Startk >= 10)]).
step(interval(7, 6, 10, 2), fact(10), [], []).
step(\+ (interval(K, Startk, _finishk, _valuek), K > 7, Startk >= 10), absent, [], []).
step(2 is 2 + 0, builtin, [], []).
step((2 >= 4 -> 4 = 2 ; 4 = 4), builtin, [], []).
step(next_compatible(6, 9),
     rule(13),
     ['I' = 6, 'Finish' = 9],
     [interval(6, 5, 9, 3), \+ (interval(K, Startk, _finishk, _valuek), K > 6, Startk >= 9)]).
step(interval(6, 5, 9, 3), fact(9), [], []).
step(\+ (interval(K, Startk, _finishk, _valuek), K > 6, Startk >= 9), absent, [], []).
step(3 is 3 + 0, builtin, [], []).
step((3 >= 4 -> 4 = 3 ; 4 = 4), builtin, [], []).
step(next_compatible(5, 9),
     rule(13),
     ['I' = 5, 'Finish' = 9],
     [interval(5, 3, 9, 6), \+ (interval(K, Startk, _finishk, _valuek), K > 5, Startk >= 9)]).
step(interval(5, 3, 9, 6), fact(8), [], []).
step(\+ (interval(K, Startk, _finishk, _valuek), K > 5, Startk >= 9), absent, [], []).
step(6 is 6 + 0, builtin, [], []).
step((6 >= 4 -> 6 = 6 ; 6 = 4), builtin, [], []).
step(next_compatible(4, 8),
     rule(12),
     ['I' = 4, 'J' = 8, 'Finish' = 7],
     [interval(4, 4, 7, 4),
      aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), Value > 4, Startk >= 7), 8, 8)]).
step(interval(4, 4, 7, 4), fact(7), [], []).
step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), Value > 4, Startk >= 7), 8, 8),
     builtin,
     [],
     []).
step(8 is 4 + 4, builtin, [], []).
step((8 >= 6 -> 8 = 8 ; 8 = 6), builtin, [], []).
step(next_compatible(3, 7),
     rule(12),
     ['I' = 3, 'J' = 7, 'Finish' = 6],
     [interval(3, 0, 6, 8),
      aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), Value > 3, Startk >= 6), 7, 7)]).
step(interval(3, 0, 6, 8), fact(6), [], []).
step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), Value > 3, Startk >= 6), 7, 7),
     builtin,
     [],
     []).
step(12 is 8 + 4, builtin, [], []).
step((12 >= 8 -> 12 = 12 ; 12 = 8), builtin, [], []).
step(next_compatible(2, 6),
     rule(12),
     ['I' = 2, 'J' = 6, 'Finish' = 5],
     [interval(2, 3, 5, 1),
      aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), Value > 2, Startk >= 5), 6, 6)]).
step(interval(2, 3, 5, 1), fact(5), [], []).
step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), Value > 2, Startk >= 5), 6, 6),
     builtin,
     [],
     []).
step(5 is 1 + 4, builtin, [], []).
step((5 >= 12 -> 12 = 5 ; 12 = 12), builtin, [], []).
step(next_compatible(1, 4),
     rule(12),
     ['I' = 1, 'J' = 4, 'Finish' = 4],
     [interval(1, 1, 4, 5),
      aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), Value > 1, Startk >= 4), 4, 4)]).
step(interval(1, 1, 4, 5), fact(4), [], []).
step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), Value > 1, Startk >= 4), 4, 4),
     builtin,
     [],
     []).
step(13 is 5 + 8, builtin, [], []).
step((13 >= 12 -> 13 = 13 ; 13 = 12), builtin, [], []).
step(weighted_interval_answer(chosen_interval, interval(1, 1, 4, 5)),
     rule(20),
     ['I' = 1, 'Start' = 1, 'Finish' = 4, 'Value' = 5],
     [chosen_from(1, 1), interval(1, 1, 4, 5)]).
step(chosen_from(1, 1),
     rule(16),
     ['I' = 1,
      'Best' = 13,
      'Next' = 2,
      'Skip' = 12,
      'Compatible' = 4,
      'Tail' = 8,
      'Value' = 5,
      'Take' = 13],
     [best_from(1, 13),
      2 is 1 + 1,
      best_from(2, 12),
      next_compatible(1, 4),
      best_from(4, 8),
      interval(1, 1, 4, 5),
      13 is 5 + 8,
      13 = 13,
      13 >= 12]).
step(13 = 13, builtin, [], []).
step(13 >= 12, builtin, [], []).
step(weighted_interval_answer(chosen_interval, interval(4, 4, 7, 4)),
     rule(20),
     ['I' = 4, 'Start' = 4, 'Finish' = 7, 'Value' = 4],
     [chosen_from(1, 4), interval(4, 4, 7, 4)]).
step(chosen_from(1, 4),
     rule(17),
     ['I' = 1,
      'Chosen' = 4,
      'Best' = 13,
      'Next' = 2,
      'Skip' = 12,
      'Compatible' = 4,
      'Tail' = 8,
      'Value' = 5,
      'Take' = 13],
     [best_from(1, 13),
      2 is 1 + 1,
      best_from(2, 12),
      next_compatible(1, 4),
      best_from(4, 8),
      interval(1, 1, 4, 5),
      13 is 5 + 8,
      13 = 13,
      13 >= 12,
      chosen_from(4, 4)]).
step(chosen_from(4, 4),
     rule(16),
     ['I' = 4,
      'Best' = 8,
      'Next' = 5,
      'Skip' = 6,
      'Compatible' = 8,
      'Tail' = 4,
      'Value' = 4,
      'Take' = 8],
     [best_from(4, 8),
      5 is 4 + 1,
      best_from(5, 6),
      next_compatible(4, 8),
      best_from(8, 4),
      interval(4, 4, 7, 4),
      8 is 4 + 4,
      8 = 8,
      8 >= 6]).
step(8 = 8, builtin, [], []).
step(8 >= 6, builtin, [], []).
step(weighted_interval_answer(chosen_interval, interval(8, 8, 11, 4)),
     rule(20),
     ['I' = 8, 'Start' = 8, 'Finish' = 11, 'Value' = 4],
     [chosen_from(1, 8), interval(8, 8, 11, 4)]).
step(chosen_from(1, 8),
     rule(17),
     ['I' = 1,
      'Chosen' = 8,
      'Best' = 13,
      'Next' = 2,
      'Skip' = 12,
      'Compatible' = 4,
      'Tail' = 8,
      'Value' = 5,
      'Take' = 13],
     [best_from(1, 13),
      2 is 1 + 1,
      best_from(2, 12),
      next_compatible(1, 4),
      best_from(4, 8),
      interval(1, 1, 4, 5),
      13 is 5 + 8,
      13 = 13,
      13 >= 12,
      chosen_from(4, 8)]).
step(chosen_from(4, 8),
     rule(17),
     ['I' = 4,
      'Chosen' = 8,
      'Best' = 8,
      'Next' = 5,
      'Skip' = 6,
      'Compatible' = 8,
      'Tail' = 4,
      'Value' = 4,
      'Take' = 8],
     [best_from(4, 8),
      5 is 4 + 1,
      best_from(5, 6),
      next_compatible(4, 8),
      best_from(8, 4),
      interval(4, 4, 7, 4),
      8 is 4 + 4,
      8 = 8,
      8 >= 6,
      chosen_from(8, 8)]).
step(chosen_from(8, 8),
     rule(16),
     ['I' = 8,
      'Best' = 4,
      'Next' = 9,
      'Skip' = 0,
      'Compatible' = 9,
      'Tail' = 0,
      'Value' = 4,
      'Take' = 4],
     [best_from(8, 4),
      9 is 8 + 1,
      best_from(9, 0),
      next_compatible(8, 9),
      best_from(9, 0),
      interval(8, 8, 11, 4),
      4 is 4 + 0,
      4 = 4,
      4 >= 0]).
step(4 = 4, builtin, [], []).
step(4 >= 0, builtin, [], []).
step(weighted_interval_answer(candidate_count, 8),
     rule(21),
     ['Count' = 8],
     [countall(interval(_i, _start, _finish, _value), 8)]).
step(countall(interval(_i, _start, _finish, _value), 8), builtin, [], []).
