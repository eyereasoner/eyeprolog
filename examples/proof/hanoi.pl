% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1,
       ['X0' = 3,
        'X1' = [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]]]).
why(1,
    ['X0' = 3,
     'X1' = [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]]],
    [answer(3, [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]])]).

clause(1, hanoi(0, anonymous(1), anonymous(2), anonymous(3), []), true).
clause(2,
       hanoi(var('N'), var('From'), var('To'), var('Via'), var('Moves')),
       (var('N') > 0,
        var('N1') is var('N') - 1,
        hanoi(var('N1'), var('From'), var('Via'), var('To'), var('Before')),
        hanoi(var('N1'), var('Via'), var('To'), var('From'), var('After')),
        append(var('Before'), [[var('From'), var('To')] | var('After')], var('Moves')))).
clause(3, answer(3, var('Moves')), hanoi(3, left, right, center, var('Moves'))).

step(answer(3, [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]]),
     rule(3),
     ['Moves' = [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]]],
     [hanoi(3, left, right, center, [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]])]).
step(hanoi(3, left, right, center, [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]]),
     rule(2),
     ['N' = 3,
      'From' = left,
      'To' = right,
      'Via' = center,
      'Moves' = [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]],
      'N1' = 2,
      'Before' = [[left, right], [left, center], [right, center]],
      'After' = [[center, left], [center, right], [left, right]]],
     [3 > 0,
      2 is 3 - 1,
      hanoi(2, left, center, right, [[left, right], [left, center], [right, center]]),
      hanoi(2, center, right, left, [[center, left], [center, right], [left, right]]),
      append([[left, right], [left, center], [right, center]], [[left, right], [center, left], [center, right], [left, right]], [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]])]).
step(3 > 0, builtin, [], []).
step(2 is 3 - 1, builtin, [], []).
step(hanoi(2, left, center, right, [[left, right], [left, center], [right, center]]),
     rule(2),
     ['N' = 2,
      'From' = left,
      'To' = center,
      'Via' = right,
      'Moves' = [[left, right], [left, center], [right, center]],
      'N1' = 1,
      'Before' = [[left, right]],
      'After' = [[right, center]]],
     [2 > 0,
      1 is 2 - 1,
      hanoi(1, left, right, center, [[left, right]]),
      hanoi(1, right, center, left, [[right, center]]),
      append([[left, right]], [[left, center], [right, center]], [[left, right], [left, center], [right, center]])]).
step(2 > 0, builtin, [], []).
step(1 is 2 - 1, builtin, [], []).
step(hanoi(1, left, right, center, [[left, right]]),
     rule(2),
     ['N' = 1,
      'From' = left,
      'To' = right,
      'Via' = center,
      'Moves' = [[left, right]],
      'N1' = 0,
      'Before' = [],
      'After' = []],
     [1 > 0,
      0 is 1 - 1,
      hanoi(0, left, center, right, []),
      hanoi(0, center, right, left, []),
      append([], [[left, right]], [[left, right]])]).
step(1 > 0, builtin, [], []).
step(0 is 1 - 1, builtin, [], []).
step(hanoi(0, left, center, right, []), fact(1), [], []).
step(hanoi(0, center, right, left, []), fact(1), [], []).
step(append([], [[left, right]], [[left, right]]), builtin, [], []).
step(hanoi(1, right, center, left, [[right, center]]),
     rule(2),
     ['N' = 1,
      'From' = right,
      'To' = center,
      'Via' = left,
      'Moves' = [[right, center]],
      'N1' = 0,
      'Before' = [],
      'After' = []],
     [1 > 0,
      0 is 1 - 1,
      hanoi(0, right, left, center, []),
      hanoi(0, left, center, right, []),
      append([], [[right, center]], [[right, center]])]).
step(hanoi(0, right, left, center, []), fact(1), [], []).
step(append([], [[right, center]], [[right, center]]), builtin, [], []).
step(append([[left, right]], [[left, center], [right, center]], [[left, right], [left, center], [right, center]]),
     builtin,
     [],
     []).
step(hanoi(2, center, right, left, [[center, left], [center, right], [left, right]]),
     rule(2),
     ['N' = 2,
      'From' = center,
      'To' = right,
      'Via' = left,
      'Moves' = [[center, left], [center, right], [left, right]],
      'N1' = 1,
      'Before' = [[center, left]],
      'After' = [[left, right]]],
     [2 > 0,
      1 is 2 - 1,
      hanoi(1, center, left, right, [[center, left]]),
      hanoi(1, left, right, center, [[left, right]]),
      append([[center, left]], [[center, right], [left, right]], [[center, left], [center, right], [left, right]])]).
step(hanoi(1, center, left, right, [[center, left]]),
     rule(2),
     ['N' = 1,
      'From' = center,
      'To' = left,
      'Via' = right,
      'Moves' = [[center, left]],
      'N1' = 0,
      'Before' = [],
      'After' = []],
     [1 > 0,
      0 is 1 - 1,
      hanoi(0, center, right, left, []),
      hanoi(0, right, left, center, []),
      append([], [[center, left]], [[center, left]])]).
step(append([], [[center, left]], [[center, left]]), builtin, [], []).
step(append([[center, left]], [[center, right], [left, right]], [[center, left], [center, right], [left, right]]),
     builtin,
     [],
     []).
step(append([[left, right], [left, center], [right, center]], [[left, right], [center, left], [center, right], [left, right]], [[left, right], [left, center], [right, center], [left, right], [center, left], [center, right], [left, right]]),
     builtin,
     [],
     []).
