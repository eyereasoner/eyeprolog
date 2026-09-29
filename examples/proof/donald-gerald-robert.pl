pandigital_cryptarithm_answer(naive_search_space, permutations(10, 3628800)).
pandigital_cryptarithm_answer(assignments, solution(5, 2, 6, 4, 8, 1, 9, 7, 3, 0)).
pandigital_cryptarithm_answer(equation, equation(526485, 197485, 723970)).
pandigital_cryptarithm_answer(digit_usage, [5, 2, 6, 4, 8, 1, 9, 7, 3, 0]).
pandigital_cryptarithm_answer(solution_count, 1).

clause(1, all_digits([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]), true).
clause(2,
       pandigital_cryptarithm(solution(var('D'), var('O'), var('N'), var('A'), var('L'), var('G'), var('E'), var('R'), var('B'), var('T'))),
       (all_digits(var('Digits')),
        select(var('D'), var('Digits'), var('D0')),
        var('D') \= 0,
        var('UnitsSum') is var('D') + var('D'),
        var('T') is var('UnitsSum') mod 10,
        var('C1') is var('UnitsSum') // 10,
        select(var('T'), var('D0'), var('D1')),
        select(var('L'), var('D1'), var('D2')),
        var('TensSum') is var('L') + var('L') + var('C1'),
        var('R') is var('TensSum') mod 10,
        var('C2') is var('TensSum') // 10,
        var('R') \= 0,
        select(var('R'), var('D2'), var('D3')),
        select(var('A'), var('D3'), var('D4')),
        var('HundredsSum') is var('A') + var('A') + var('C2'),
        var('E') is var('HundredsSum') mod 10,
        var('C3') is var('HundredsSum') // 10,
        select(var('E'), var('D4'), var('D5')),
        select(var('N'), var('D5'), var('D6')),
        var('ThousandsSum') is var('N') + var('R') + var('C3'),
        var('B') is var('ThousandsSum') mod 10,
        var('C4') is var('ThousandsSum') // 10,
        select(var('B'), var('D6'), var('D7')),
        var('CarrySum') is var('E') + var('C4'),
        0 is var('CarrySum') mod 10,
        var('C5') is var('CarrySum') // 10,
        var('G') is var('R') - var('D') - var('C5'),
        var('G') > 0,
        select(var('G'), var('D7'), var('D8')),
        select(var('O'), var('D8'), []),
        var('O') \= 0)).
clause(3,
       number6(var('A'), var('B'), var('C'), var('D'), var('E'), var('F'), var('Value')),
       (var('A5') is var('A') * 100000,
        var('B4') is var('B') * 10000,
        var('C3') is var('C') * 1000,
        var('D2') is var('D') * 100,
        var('E1') is var('E') * 10,
        var('AB') is var('A5') + var('B4'),
        var('ABC') is var('AB') + var('C3'),
        var('ABCD') is var('ABC') + var('D2'),
        var('ABCDE') is var('ABCD') + var('E1'),
        var('Value') is var('ABCDE') + var('F'))).
clause(4,
       pandigital_cryptarithm_answer(naive_search_space, permutations(10, 3628800)),
       (all_digits(var('Digits')), length(var('Digits'), 10))).
clause(5,
       pandigital_cryptarithm_answer(assignments, solution(var('D'), var('O'), var('N'), var('A'), var('L'), var('G'), var('E'), var('R'), var('B'), var('T'))),
       pandigital_cryptarithm(solution(var('D'), var('O'), var('N'), var('A'), var('L'), var('G'), var('E'), var('R'), var('B'), var('T')))).
clause(6,
       pandigital_cryptarithm_answer(equation, equation(var('Donald'), var('Gerald'), var('Robert'))),
       (pandigital_cryptarithm(solution(var('D'), var('O'), var('N'), var('A'), var('L'), var('G'), var('E'), var('R'), var('B'), var('T'))),
        number6(var('D'), var('O'), var('N'), var('A'), var('L'), var('D'), var('Donald')),
        number6(var('G'), var('E'), var('R'), var('A'), var('L'), var('D'), var('Gerald')),
        number6(var('R'), var('O'), var('B'), var('E'), var('R'), var('T'), var('Robert')))).
clause(7,
       pandigital_cryptarithm_answer(digit_usage, [var('D'), var('O'), var('N'), var('A'), var('L'), var('G'), var('E'), var('R'), var('B'), var('T')]),
       pandigital_cryptarithm(solution(var('D'), var('O'), var('N'), var('A'), var('L'), var('G'), var('E'), var('R'), var('B'), var('T')))).
clause(8,
       pandigital_cryptarithm_answer(solution_count, var('Count')),
       countall(pandigital_cryptarithm(anonymous(1)), var('Count'))).

step(pandigital_cryptarithm_answer(naive_search_space, permutations(10, 3628800)),
     rule(4),
     ['Digits' = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]],
     [all_digits([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]), length([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10)]).
step(all_digits([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]), fact(1), [], []).
step(length([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10), builtin, [], []).
step(pandigital_cryptarithm_answer(assignments, solution(5, 2, 6, 4, 8, 1, 9, 7, 3, 0)),
     rule(5),
     ['D' = 5, 'O' = 2, 'N' = 6, 'A' = 4, 'L' = 8, 'G' = 1, 'E' = 9, 'R' = 7, 'B' = 3, 'T' = 0],
     [pandigital_cryptarithm(solution(5, 2, 6, 4, 8, 1, 9, 7, 3, 0))]).
step(pandigital_cryptarithm(solution(5, 2, 6, 4, 8, 1, 9, 7, 3, 0)),
     rule(2),
     ['D' = 5,
      'O' = 2,
      'N' = 6,
      'A' = 4,
      'L' = 8,
      'G' = 1,
      'E' = 9,
      'R' = 7,
      'B' = 3,
      'T' = 0,
      'Digits' = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
      'D0' = [0, 1, 2, 3, 4, 6, 7, 8, 9],
      'UnitsSum' = 10,
      'C1' = 1,
      'D1' = [1, 2, 3, 4, 6, 7, 8, 9],
      'D2' = [1, 2, 3, 4, 6, 7, 9],
      'TensSum' = 17,
      'C2' = 1,
      'D3' = [1, 2, 3, 4, 6, 9],
      'D4' = [1, 2, 3, 6, 9],
      'HundredsSum' = 9,
      'C3' = 0,
      'D5' = [1, 2, 3, 6],
      'D6' = [1, 2, 3],
      'ThousandsSum' = 13,
      'C4' = 1,
      'D7' = [1, 2],
      'CarrySum' = 10,
      'C5' = 1,
      'D8' = [2]],
     [all_digits([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]),
      select(5, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], [0, 1, 2, 3, 4, 6, 7, 8, 9]),
      5 \= 0,
      10 is 5 + 5,
      0 is 10 mod 10,
      1 is 10 // 10,
      select(0, [0, 1, 2, 3, 4, 6, 7, 8, 9], [1, 2, 3, 4, 6, 7, 8, 9]),
      select(8, [1, 2, 3, 4, 6, 7, 8, 9], [1, 2, 3, 4, 6, 7, 9]),
      17 is 8 + 8 + 1,
      7 is 17 mod 10,
      1 is 17 // 10,
      7 \= 0,
      select(7, [1, 2, 3, 4, 6, 7, 9], [1, 2, 3, 4, 6, 9]),
      select(4, [1, 2, 3, 4, 6, 9], [1, 2, 3, 6, 9]),
      9 is 4 + 4 + 1,
      9 is 9 mod 10,
      0 is 9 // 10,
      select(9, [1, 2, 3, 6, 9], [1, 2, 3, 6]),
      select(6, [1, 2, 3, 6], [1, 2, 3]),
      13 is 6 + 7 + 0,
      3 is 13 mod 10,
      1 is 13 // 10,
      select(3, [1, 2, 3], [1, 2]),
      10 is 9 + 1,
      0 is 10 mod 10,
      1 is 10 // 10,
      1 is 7 - 5 - 1,
      1 > 0,
      select(1, [1, 2], [2]),
      select(2, [2], []),
      2 \= 0]).
step(select(5, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], [0, 1, 2, 3, 4, 6, 7, 8, 9]), builtin, [], []).
step(5 \= 0, builtin, [], []).
step(10 is 5 + 5, builtin, [], []).
step(0 is 10 mod 10, builtin, [], []).
step(1 is 10 // 10, builtin, [], []).
step(select(0, [0, 1, 2, 3, 4, 6, 7, 8, 9], [1, 2, 3, 4, 6, 7, 8, 9]), builtin, [], []).
step(select(8, [1, 2, 3, 4, 6, 7, 8, 9], [1, 2, 3, 4, 6, 7, 9]), builtin, [], []).
step(17 is 8 + 8 + 1, builtin, [], []).
step(7 is 17 mod 10, builtin, [], []).
step(1 is 17 // 10, builtin, [], []).
step(7 \= 0, builtin, [], []).
step(select(7, [1, 2, 3, 4, 6, 7, 9], [1, 2, 3, 4, 6, 9]), builtin, [], []).
step(select(4, [1, 2, 3, 4, 6, 9], [1, 2, 3, 6, 9]), builtin, [], []).
step(9 is 4 + 4 + 1, builtin, [], []).
step(9 is 9 mod 10, builtin, [], []).
step(0 is 9 // 10, builtin, [], []).
step(select(9, [1, 2, 3, 6, 9], [1, 2, 3, 6]), builtin, [], []).
step(select(6, [1, 2, 3, 6], [1, 2, 3]), builtin, [], []).
step(13 is 6 + 7 + 0, builtin, [], []).
step(3 is 13 mod 10, builtin, [], []).
step(1 is 13 // 10, builtin, [], []).
step(select(3, [1, 2, 3], [1, 2]), builtin, [], []).
step(10 is 9 + 1, builtin, [], []).
step(1 is 7 - 5 - 1, builtin, [], []).
step(1 > 0, builtin, [], []).
step(select(1, [1, 2], [2]), builtin, [], []).
step(select(2, [2], []), builtin, [], []).
step(2 \= 0, builtin, [], []).
step(pandigital_cryptarithm_answer(equation, equation(526485, 197485, 723970)),
     rule(6),
     ['Donald' = 526485,
      'Gerald' = 197485,
      'Robert' = 723970,
      'D' = 5,
      'O' = 2,
      'N' = 6,
      'A' = 4,
      'L' = 8,
      'G' = 1,
      'E' = 9,
      'R' = 7,
      'B' = 3,
      'T' = 0],
     [pandigital_cryptarithm(solution(5, 2, 6, 4, 8, 1, 9, 7, 3, 0)),
      number6(5, 2, 6, 4, 8, 5, 526485),
      number6(1, 9, 7, 4, 8, 5, 197485),
      number6(7, 2, 3, 9, 7, 0, 723970)]).
step(number6(5, 2, 6, 4, 8, 5, 526485),
     rule(3),
     ['A' = 5,
      'B' = 2,
      'C' = 6,
      'D' = 4,
      'E' = 8,
      'F' = 5,
      'Value' = 526485,
      'A5' = 500000,
      'B4' = 20000,
      'C3' = 6000,
      'D2' = 400,
      'E1' = 80,
      'AB' = 520000,
      'ABC' = 526000,
      'ABCD' = 526400,
      'ABCDE' = 526480],
     [500000 is 5 * 100000,
      20000 is 2 * 10000,
      6000 is 6 * 1000,
      400 is 4 * 100,
      80 is 8 * 10,
      520000 is 500000 + 20000,
      526000 is 520000 + 6000,
      526400 is 526000 + 400,
      526480 is 526400 + 80,
      526485 is 526480 + 5]).
step(500000 is 5 * 100000, builtin, [], []).
step(20000 is 2 * 10000, builtin, [], []).
step(6000 is 6 * 1000, builtin, [], []).
step(400 is 4 * 100, builtin, [], []).
step(80 is 8 * 10, builtin, [], []).
step(520000 is 500000 + 20000, builtin, [], []).
step(526000 is 520000 + 6000, builtin, [], []).
step(526400 is 526000 + 400, builtin, [], []).
step(526480 is 526400 + 80, builtin, [], []).
step(526485 is 526480 + 5, builtin, [], []).
step(number6(1, 9, 7, 4, 8, 5, 197485),
     rule(3),
     ['A' = 1,
      'B' = 9,
      'C' = 7,
      'D' = 4,
      'E' = 8,
      'F' = 5,
      'Value' = 197485,
      'A5' = 100000,
      'B4' = 90000,
      'C3' = 7000,
      'D2' = 400,
      'E1' = 80,
      'AB' = 190000,
      'ABC' = 197000,
      'ABCD' = 197400,
      'ABCDE' = 197480],
     [100000 is 1 * 100000,
      90000 is 9 * 10000,
      7000 is 7 * 1000,
      400 is 4 * 100,
      80 is 8 * 10,
      190000 is 100000 + 90000,
      197000 is 190000 + 7000,
      197400 is 197000 + 400,
      197480 is 197400 + 80,
      197485 is 197480 + 5]).
step(100000 is 1 * 100000, builtin, [], []).
step(90000 is 9 * 10000, builtin, [], []).
step(7000 is 7 * 1000, builtin, [], []).
step(190000 is 100000 + 90000, builtin, [], []).
step(197000 is 190000 + 7000, builtin, [], []).
step(197400 is 197000 + 400, builtin, [], []).
step(197480 is 197400 + 80, builtin, [], []).
step(197485 is 197480 + 5, builtin, [], []).
step(number6(7, 2, 3, 9, 7, 0, 723970),
     rule(3),
     ['A' = 7,
      'B' = 2,
      'C' = 3,
      'D' = 9,
      'E' = 7,
      'F' = 0,
      'Value' = 723970,
      'A5' = 700000,
      'B4' = 20000,
      'C3' = 3000,
      'D2' = 900,
      'E1' = 70,
      'AB' = 720000,
      'ABC' = 723000,
      'ABCD' = 723900,
      'ABCDE' = 723970],
     [700000 is 7 * 100000,
      20000 is 2 * 10000,
      3000 is 3 * 1000,
      900 is 9 * 100,
      70 is 7 * 10,
      720000 is 700000 + 20000,
      723000 is 720000 + 3000,
      723900 is 723000 + 900,
      723970 is 723900 + 70,
      723970 is 723970 + 0]).
step(700000 is 7 * 100000, builtin, [], []).
step(3000 is 3 * 1000, builtin, [], []).
step(900 is 9 * 100, builtin, [], []).
step(70 is 7 * 10, builtin, [], []).
step(720000 is 700000 + 20000, builtin, [], []).
step(723000 is 720000 + 3000, builtin, [], []).
step(723900 is 723000 + 900, builtin, [], []).
step(723970 is 723900 + 70, builtin, [], []).
step(723970 is 723970 + 0, builtin, [], []).
step(pandigital_cryptarithm_answer(digit_usage, [5, 2, 6, 4, 8, 1, 9, 7, 3, 0]),
     rule(7),
     ['D' = 5, 'O' = 2, 'N' = 6, 'A' = 4, 'L' = 8, 'G' = 1, 'E' = 9, 'R' = 7, 'B' = 3, 'T' = 0],
     [pandigital_cryptarithm(solution(5, 2, 6, 4, 8, 1, 9, 7, 3, 0))]).
step(pandigital_cryptarithm_answer(solution_count, 1),
     rule(8),
     ['Count' = 1],
     [countall(pandigital_cryptarithm(__anon0), 1)]).
step(countall(pandigital_cryptarithm(__anon0), 1), builtin, [], []).
