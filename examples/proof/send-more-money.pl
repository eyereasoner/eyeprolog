cryptarithm_answer(assignments, solution(9, 5, 6, 7, 1, 0, 8, 2)).
cryptarithm_answer(equation, equation(9567, 1085, 10652)).
cryptarithm_answer(solution_count, 1).

clause(1, all_digits([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]), true).
clause(2,
       send_more_money(solution(var('S'), var('E'), var('N'), var('D'), var('M'), var('O'), var('R'), var('Y'))),
       (all_digits(var('Digits')),
        var('M') = 1,
        var('O') = 0,
        select(var('M'), var('Digits'), var('D0')),
        select(var('O'), var('D0'), var('D1')),
        select(var('D'), var('D1'), var('D2')),
        select(var('E'), var('D2'), var('D3')),
        var('Onessum') is var('D') + var('E'),
        var('Y') is var('Onessum') mod 10,
        var('Carry1') is var('Onessum') // 10,
        select(var('Y'), var('D3'), var('D4')),
        select(var('N'), var('D4'), var('D5')),
        select(var('R'), var('D5'), var('D6')),
        var('Tenspartial') is var('N') + var('R'),
        var('Tenssum') is var('Tenspartial') + var('Carry1'),
        var('E') is var('Tenssum') mod 10,
        var('Carry2') is var('Tenssum') // 10,
        var('Hundredspartial') is var('E') + var('O'),
        var('Hundredssum') is var('Hundredspartial') + var('Carry2'),
        var('N') is var('Hundredssum') mod 10,
        var('Carry3') is var('Hundredssum') // 10,
        select(var('S'), var('D6'), anonymous(1)),
        var('S') \= 0,
        var('Thousandspartial') is var('S') + var('M'),
        var('Thousandssum') is var('Thousandspartial') + var('Carry3'),
        var('O') is var('Thousandssum') mod 10,
        var('M') is var('Thousandssum') // 10)).
clause(3,
       number4(var('A'), var('B'), var('C'), var('D'), var('Value')),
       (var('Apart') is var('A') * 1000,
        var('Bpart') is var('B') * 100,
        var('Cpart') is var('C') * 10,
        var('Ab') is var('Apart') + var('Bpart'),
        var('Abc') is var('Ab') + var('Cpart'),
        var('Value') is var('Abc') + var('D'))).
clause(4,
       number5(var('A'), var('B'), var('C'), var('D'), var('E'), var('Value')),
       (var('Apart') is var('A') * 10000,
        var('Bpart') is var('B') * 1000,
        var('Cpart') is var('C') * 100,
        var('Dpart') is var('D') * 10,
        var('Ab') is var('Apart') + var('Bpart'),
        var('Abc') is var('Ab') + var('Cpart'),
        var('Abcd') is var('Abc') + var('Dpart'),
        var('Value') is var('Abcd') + var('E'))).
clause(5,
       cryptarithm_answer(assignments, solution(var('S'), var('E'), var('N'), var('D'), var('M'), var('O'), var('R'), var('Y'))),
       send_more_money(solution(var('S'), var('E'), var('N'), var('D'), var('M'), var('O'), var('R'), var('Y')))).
clause(6,
       cryptarithm_answer(equation, equation(var('Send'), var('More'), var('Money'))),
       (send_more_money(solution(var('S'), var('E'), var('N'), var('D'), var('M'), var('O'), var('R'), var('Y'))),
        number4(var('S'), var('E'), var('N'), var('D'), var('Send')),
        number4(var('M'), var('O'), var('R'), var('E'), var('More')),
        number5(var('M'), var('O'), var('N'), var('E'), var('Y'), var('Money')))).
clause(7,
       cryptarithm_answer(solution_count, var('Count')),
       countall(send_more_money(anonymous(1)), var('Count'))).

step(cryptarithm_answer(assignments, solution(9, 5, 6, 7, 1, 0, 8, 2)),
     rule(5),
     ['S' = 9, 'E' = 5, 'N' = 6, 'D' = 7, 'M' = 1, 'O' = 0, 'R' = 8, 'Y' = 2],
     [send_more_money(solution(9, 5, 6, 7, 1, 0, 8, 2))]).
step(send_more_money(solution(9, 5, 6, 7, 1, 0, 8, 2)),
     rule(2),
     ['S' = 9,
      'E' = 5,
      'N' = 6,
      'D' = 7,
      'M' = 1,
      'O' = 0,
      'R' = 8,
      'Y' = 2,
      'Digits' = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
      'D0' = [0, 2, 3, 4, 5, 6, 7, 8, 9],
      'D1' = [2, 3, 4, 5, 6, 7, 8, 9],
      'D2' = [2, 3, 4, 5, 6, 8, 9],
      'D3' = [2, 3, 4, 6, 8, 9],
      'Onessum' = 12,
      'Carry1' = 1,
      'D4' = [3, 4, 6, 8, 9],
      'D5' = [3, 4, 8, 9],
      'D6' = [3, 4, 9],
      'Tenspartial' = 14,
      'Tenssum' = 15,
      'Carry2' = 1,
      'Hundredspartial' = 5,
      'Hundredssum' = 6,
      'Carry3' = 0,
      'Thousandspartial' = 10,
      'Thousandssum' = 10],
     [all_digits([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]),
      1 = 1,
      0 = 0,
      select(1, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], [0, 2, 3, 4, 5, 6, 7, 8, 9]),
      select(0, [0, 2, 3, 4, 5, 6, 7, 8, 9], [2, 3, 4, 5, 6, 7, 8, 9]),
      select(7, [2, 3, 4, 5, 6, 7, 8, 9], [2, 3, 4, 5, 6, 8, 9]),
      select(5, [2, 3, 4, 5, 6, 8, 9], [2, 3, 4, 6, 8, 9]),
      12 is 7 + 5,
      2 is 12 mod 10,
      1 is 12 // 10,
      select(2, [2, 3, 4, 6, 8, 9], [3, 4, 6, 8, 9]),
      select(6, [3, 4, 6, 8, 9], [3, 4, 8, 9]),
      select(8, [3, 4, 8, 9], [3, 4, 9]),
      14 is 6 + 8,
      15 is 14 + 1,
      5 is 15 mod 10,
      1 is 15 // 10,
      5 is 5 + 0,
      6 is 5 + 1,
      6 is 6 mod 10,
      0 is 6 // 10,
      select(9, [3, 4, 9], [3, 4]),
      9 \= 0,
      10 is 9 + 1,
      10 is 10 + 0,
      0 is 10 mod 10,
      1 is 10 // 10]).
step(all_digits([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]), fact(1), [], []).
step(1 = 1, builtin, [], []).
step(0 = 0, builtin, [], []).
step(select(1, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], [0, 2, 3, 4, 5, 6, 7, 8, 9]), builtin, [], []).
step(select(0, [0, 2, 3, 4, 5, 6, 7, 8, 9], [2, 3, 4, 5, 6, 7, 8, 9]), builtin, [], []).
step(select(7, [2, 3, 4, 5, 6, 7, 8, 9], [2, 3, 4, 5, 6, 8, 9]), builtin, [], []).
step(select(5, [2, 3, 4, 5, 6, 8, 9], [2, 3, 4, 6, 8, 9]), builtin, [], []).
step(12 is 7 + 5, builtin, [], []).
step(2 is 12 mod 10, builtin, [], []).
step(1 is 12 // 10, builtin, [], []).
step(select(2, [2, 3, 4, 6, 8, 9], [3, 4, 6, 8, 9]), builtin, [], []).
step(select(6, [3, 4, 6, 8, 9], [3, 4, 8, 9]), builtin, [], []).
step(select(8, [3, 4, 8, 9], [3, 4, 9]), builtin, [], []).
step(14 is 6 + 8, builtin, [], []).
step(15 is 14 + 1, builtin, [], []).
step(5 is 15 mod 10, builtin, [], []).
step(1 is 15 // 10, builtin, [], []).
step(5 is 5 + 0, builtin, [], []).
step(6 is 5 + 1, builtin, [], []).
step(6 is 6 mod 10, builtin, [], []).
step(0 is 6 // 10, builtin, [], []).
step(select(9, [3, 4, 9], [3, 4]), builtin, [], []).
step(9 \= 0, builtin, [], []).
step(10 is 9 + 1, builtin, [], []).
step(10 is 10 + 0, builtin, [], []).
step(0 is 10 mod 10, builtin, [], []).
step(1 is 10 // 10, builtin, [], []).
step(cryptarithm_answer(equation, equation(9567, 1085, 10652)),
     rule(6),
     ['Send' = 9567,
      'More' = 1085,
      'Money' = 10652,
      'S' = 9,
      'E' = 5,
      'N' = 6,
      'D' = 7,
      'M' = 1,
      'O' = 0,
      'R' = 8,
      'Y' = 2],
     [send_more_money(solution(9, 5, 6, 7, 1, 0, 8, 2)),
      number4(9, 5, 6, 7, 9567),
      number4(1, 0, 8, 5, 1085),
      number5(1, 0, 6, 5, 2, 10652)]).
step(number4(9, 5, 6, 7, 9567),
     rule(3),
     ['A' = 9,
      'B' = 5,
      'C' = 6,
      'D' = 7,
      'Value' = 9567,
      'Apart' = 9000,
      'Bpart' = 500,
      'Cpart' = 60,
      'Ab' = 9500,
      'Abc' = 9560],
     [9000 is 9 * 1000,
      500 is 5 * 100,
      60 is 6 * 10,
      9500 is 9000 + 500,
      9560 is 9500 + 60,
      9567 is 9560 + 7]).
step(9000 is 9 * 1000, builtin, [], []).
step(500 is 5 * 100, builtin, [], []).
step(60 is 6 * 10, builtin, [], []).
step(9500 is 9000 + 500, builtin, [], []).
step(9560 is 9500 + 60, builtin, [], []).
step(9567 is 9560 + 7, builtin, [], []).
step(number4(1, 0, 8, 5, 1085),
     rule(3),
     ['A' = 1,
      'B' = 0,
      'C' = 8,
      'D' = 5,
      'Value' = 1085,
      'Apart' = 1000,
      'Bpart' = 0,
      'Cpart' = 80,
      'Ab' = 1000,
      'Abc' = 1080],
     [1000 is 1 * 1000,
      0 is 0 * 100,
      80 is 8 * 10,
      1000 is 1000 + 0,
      1080 is 1000 + 80,
      1085 is 1080 + 5]).
step(1000 is 1 * 1000, builtin, [], []).
step(0 is 0 * 100, builtin, [], []).
step(80 is 8 * 10, builtin, [], []).
step(1000 is 1000 + 0, builtin, [], []).
step(1080 is 1000 + 80, builtin, [], []).
step(1085 is 1080 + 5, builtin, [], []).
step(number5(1, 0, 6, 5, 2, 10652),
     rule(4),
     ['A' = 1,
      'B' = 0,
      'C' = 6,
      'D' = 5,
      'E' = 2,
      'Value' = 10652,
      'Apart' = 10000,
      'Bpart' = 0,
      'Cpart' = 600,
      'Dpart' = 50,
      'Ab' = 10000,
      'Abc' = 10600,
      'Abcd' = 10650],
     [10000 is 1 * 10000,
      0 is 0 * 1000,
      600 is 6 * 100,
      50 is 5 * 10,
      10000 is 10000 + 0,
      10600 is 10000 + 600,
      10650 is 10600 + 50,
      10652 is 10650 + 2]).
step(10000 is 1 * 10000, builtin, [], []).
step(0 is 0 * 1000, builtin, [], []).
step(600 is 6 * 100, builtin, [], []).
step(50 is 5 * 10, builtin, [], []).
step(10000 is 10000 + 0, builtin, [], []).
step(10600 is 10000 + 600, builtin, [], []).
step(10650 is 10600 + 50, builtin, [], []).
step(10652 is 10650 + 2, builtin, [], []).
step(cryptarithm_answer(solution_count, 1),
     rule(7),
     ['Count' = 1],
     [countall(send_more_money(_solution), 1)]).
step(countall(send_more_money(_solution), 1), builtin, [], []).
