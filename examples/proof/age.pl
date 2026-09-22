% Prolog result format 4
query(1, birthDay(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 0).
query(2, duration(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 0).
query(3, ageAbove(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = patH, 'X1' = 'P80Y']).
why(3, ['X0' = patH, 'X1' = 'P80Y'], [ageAbove(patH, 'P80Y')]).
query(4, holds_result(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = test, 'X1' = true]).
why(4, ['X0' = test, 'X1' = true], [holds_result(test, true)]).

clause(1, birthDay(patH, '1944-08-21'), true).
clause(2, duration(check, 'P80Y'), true).
clause(3, local_time('2026-05-30'), true).
clause(4,
       ageAbove(var('S'), var('A')),
       (birthDay(var('S'), var('B')),
        duration(check, var('A')),
        local_time(var('D')),
        difference(var('D'), var('B'), var('F')),
        var('F') @> var('A'))).
clause(5, holds_result(test, true), ageAbove(anonymous(1), 'P80Y')).

step(ageAbove(patH, 'P80Y'),
     rule(4),
     ['S' = patH, 'A' = 'P80Y', 'B' = '1944-08-21', 'D' = '2026-05-30', 'F' = 'P81Y9M9D'],
     [birthDay(patH, '1944-08-21'),
      duration(check, 'P80Y'),
      local_time('2026-05-30'),
      difference('2026-05-30', '1944-08-21', 'P81Y9M9D'),
      'P81Y9M9D' @> 'P80Y']).
step(birthDay(patH, '1944-08-21'), fact(1), [], []).
step(duration(check, 'P80Y'), fact(2), [], []).
step(local_time('2026-05-30'), fact(3), [], []).
step(difference('2026-05-30', '1944-08-21', 'P81Y9M9D'), builtin, [], []).
step('P81Y9M9D' @> 'P80Y', builtin, [], []).
step(holds_result(test, true), rule(5), [], [ageAbove(patH, 'P80Y')]).
