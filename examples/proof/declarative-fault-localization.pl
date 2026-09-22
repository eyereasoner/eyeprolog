% Prolog result format 4
query(1, answer(_0, _1, _2, _3), ['X0' = _0, 'X1' = _1, 'X2' = _2, 'X3' = _3]).
result(1, complete, 1).
answer(1, ['X0' = 1, 'X1' = 3, 'X2' = 3, 'X3' = 5]).
why(1, ['X0' = 1, 'X1' = 3, 'X2' = 3, 'X3' = 5], [answer(1, 3, 3, 5)]).

clause(1, buggy_list_max([var('X')], var('X')), true).
clause(2,
       buggy_list_max([var('X') | var('Xs')], var('Max')),
       (buggy_list_max(var('Xs'), var('Max0')),
        (var('X') > var('Max0') -> var('Max') = var('Max0') ; var('Max') = var('X')))).
clause(3, fixed_list_max([var('X')], var('X')), true).
clause(4,
       fixed_list_max([var('X') | var('Xs')], var('Max')),
       (fixed_list_max(var('Xs'), var('Max0')),
        (var('X') > var('Max0') -> var('Max') = var('X') ; var('Max') = var('Max0')))).
clause(5,
       answer(var('WholeListWrongAnswer'), var('TwoElementSublistAlreadyWrong'), var('BaseCaseIsCorrect'), var('FixedAnswer')),
       (buggy_list_max([1, 5, 3], var('WholeListWrongAnswer')),
        buggy_list_max([5, 3], var('TwoElementSublistAlreadyWrong')),
        buggy_list_max([3], var('BaseCaseIsCorrect')),
        fixed_list_max([1, 5, 3], var('FixedAnswer')))).

step(answer(1, 3, 3, 5),
     rule(5),
     ['WholeListWrongAnswer' = 1,
      'TwoElementSublistAlreadyWrong' = 3,
      'BaseCaseIsCorrect' = 3,
      'FixedAnswer' = 5],
     [buggy_list_max([1, 5, 3], 1),
      buggy_list_max([5, 3], 3),
      buggy_list_max([3], 3),
      fixed_list_max([1, 5, 3], 5)]).
step(buggy_list_max([1, 5, 3], 1),
     rule(2),
     ['X' = 1, 'Xs' = [5, 3], 'Max' = 1, 'Max0' = 3],
     [buggy_list_max([5, 3], 3), (1 > 3 -> 1 = 3 ; 1 = 1)]).
step(buggy_list_max([5, 3], 3),
     rule(2),
     ['X' = 5, 'Xs' = [3], 'Max' = 3, 'Max0' = 3],
     [buggy_list_max([3], 3), (5 > 3 -> 3 = 3 ; 3 = 5)]).
step(buggy_list_max([3], 3), fact(1), ['X' = 3], []).
step((5 > 3 -> 3 = 3 ; 3 = 5), builtin, [], []).
step((1 > 3 -> 1 = 3 ; 1 = 1), builtin, [], []).
step(fixed_list_max([1, 5, 3], 5),
     rule(4),
     ['X' = 1, 'Xs' = [5, 3], 'Max' = 5, 'Max0' = 5],
     [fixed_list_max([5, 3], 5), (1 > 5 -> 5 = 1 ; 5 = 5)]).
step(fixed_list_max([5, 3], 5),
     rule(4),
     ['X' = 5, 'Xs' = [3], 'Max' = 5, 'Max0' = 3],
     [fixed_list_max([3], 3), (5 > 3 -> 5 = 5 ; 5 = 3)]).
step(fixed_list_max([3], 3), fact(3), ['X' = 3], []).
step((5 > 3 -> 5 = 5 ; 5 = 3), builtin, [], []).
step((1 > 5 -> 5 = 1 ; 5 = 5), builtin, [], []).
