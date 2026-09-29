matrix_result(ab, [[7, 2], [3, 1]]).
matrix_result(ba, [[1, 2], [3, 7]]).
matrix_result(commutative, false).

clause(1, matrix_a([[1, 2], [0, 1]]), true).
clause(2, matrix_b([[1, 0], [3, 1]]), true).
clause(3,
       dot2([var('X1'), var('X2')], [var('Y1'), var('Y2')], var('R')),
       (var('P1') is var('X1') * var('Y1'),
        var('P2') is var('X2') * var('Y2'),
        var('R') is var('P1') + var('P2'))).
clause(4,
       transpose2([[var('A'), var('B')], [var('C'), var('D')]], [[var('A'), var('C')], [var('B'), var('D')]]),
       true).
clause(5,
       row_times_matrix(var('Row'), var('Matrix'), [var('R1'), var('R2')]),
       (transpose2(var('Matrix'), [var('Col1'), var('Col2')]),
        dot2(var('Row'), var('Col1'), var('R1')),
        dot2(var('Row'), var('Col2'), var('R2')))).
clause(6,
       matrix_mul([var('Row1'), var('Row2')], var('Matrix'), [var('Out1'), var('Out2')]),
       (row_times_matrix(var('Row1'), var('Matrix'), var('Out1')),
        row_times_matrix(var('Row2'), var('Matrix'), var('Out2')))).
clause(7,
       matrix_result(ab, var('Ab')),
       (matrix_a(var('A')), matrix_b(var('B')), matrix_mul(var('A'), var('B'), var('Ab')))).
clause(8,
       matrix_result(ba, var('Ba')),
       (matrix_a(var('A')), matrix_b(var('B')), matrix_mul(var('B'), var('A'), var('Ba')))).
clause(9,
       matrix_result(commutative, false),
       (matrix_a(var('A')),
        matrix_b(var('B')),
        matrix_mul(var('A'), var('B'), var('Ab')),
        matrix_mul(var('B'), var('A'), var('Ba')),
        var('Ab') \= var('Ba'))).

step(matrix_result(ab, [[7, 2], [3, 1]]),
     rule(7),
     ['Ab' = [[7, 2], [3, 1]], 'A' = [[1, 2], [0, 1]], 'B' = [[1, 0], [3, 1]]],
     [matrix_a([[1, 2], [0, 1]]),
      matrix_b([[1, 0], [3, 1]]),
      matrix_mul([[1, 2], [0, 1]], [[1, 0], [3, 1]], [[7, 2], [3, 1]])]).
step(matrix_a([[1, 2], [0, 1]]), fact(1), [], []).
step(matrix_b([[1, 0], [3, 1]]), fact(2), [], []).
step(matrix_mul([[1, 2], [0, 1]], [[1, 0], [3, 1]], [[7, 2], [3, 1]]),
     rule(6),
     ['Row1' = [1, 2],
      'Row2' = [0, 1],
      'Matrix' = [[1, 0], [3, 1]],
      'Out1' = [7, 2],
      'Out2' = [3, 1]],
     [row_times_matrix([1, 2], [[1, 0], [3, 1]], [7, 2]),
      row_times_matrix([0, 1], [[1, 0], [3, 1]], [3, 1])]).
step(row_times_matrix([1, 2], [[1, 0], [3, 1]], [7, 2]),
     rule(5),
     ['Row' = [1, 2],
      'Matrix' = [[1, 0], [3, 1]],
      'R1' = 7,
      'R2' = 2,
      'Col1' = [1, 3],
      'Col2' = [0, 1]],
     [transpose2([[1, 0], [3, 1]], [[1, 3], [0, 1]]),
      dot2([1, 2], [1, 3], 7),
      dot2([1, 2], [0, 1], 2)]).
step(transpose2([[1, 0], [3, 1]], [[1, 3], [0, 1]]),
     fact(4),
     ['A' = 1, 'B' = 0, 'C' = 3, 'D' = 1],
     []).
step(dot2([1, 2], [1, 3], 7),
     rule(3),
     ['X1' = 1, 'X2' = 2, 'Y1' = 1, 'Y2' = 3, 'R' = 7, 'P1' = 1, 'P2' = 6],
     [1 is 1 * 1, 6 is 2 * 3, 7 is 1 + 6]).
step(1 is 1 * 1, builtin, [], []).
step(6 is 2 * 3, builtin, [], []).
step(7 is 1 + 6, builtin, [], []).
step(dot2([1, 2], [0, 1], 2),
     rule(3),
     ['X1' = 1, 'X2' = 2, 'Y1' = 0, 'Y2' = 1, 'R' = 2, 'P1' = 0, 'P2' = 2],
     [0 is 1 * 0, 2 is 2 * 1, 2 is 0 + 2]).
step(0 is 1 * 0, builtin, [], []).
step(2 is 2 * 1, builtin, [], []).
step(2 is 0 + 2, builtin, [], []).
step(row_times_matrix([0, 1], [[1, 0], [3, 1]], [3, 1]),
     rule(5),
     ['Row' = [0, 1],
      'Matrix' = [[1, 0], [3, 1]],
      'R1' = 3,
      'R2' = 1,
      'Col1' = [1, 3],
      'Col2' = [0, 1]],
     [transpose2([[1, 0], [3, 1]], [[1, 3], [0, 1]]),
      dot2([0, 1], [1, 3], 3),
      dot2([0, 1], [0, 1], 1)]).
step(dot2([0, 1], [1, 3], 3),
     rule(3),
     ['X1' = 0, 'X2' = 1, 'Y1' = 1, 'Y2' = 3, 'R' = 3, 'P1' = 0, 'P2' = 3],
     [0 is 0 * 1, 3 is 1 * 3, 3 is 0 + 3]).
step(0 is 0 * 1, builtin, [], []).
step(3 is 1 * 3, builtin, [], []).
step(3 is 0 + 3, builtin, [], []).
step(dot2([0, 1], [0, 1], 1),
     rule(3),
     ['X1' = 0, 'X2' = 1, 'Y1' = 0, 'Y2' = 1, 'R' = 1, 'P1' = 0, 'P2' = 1],
     [0 is 0 * 0, 1 is 1 * 1, 1 is 0 + 1]).
step(0 is 0 * 0, builtin, [], []).
step(1 is 0 + 1, builtin, [], []).
step(matrix_result(ba, [[1, 2], [3, 7]]),
     rule(8),
     ['Ba' = [[1, 2], [3, 7]], 'A' = [[1, 2], [0, 1]], 'B' = [[1, 0], [3, 1]]],
     [matrix_a([[1, 2], [0, 1]]),
      matrix_b([[1, 0], [3, 1]]),
      matrix_mul([[1, 0], [3, 1]], [[1, 2], [0, 1]], [[1, 2], [3, 7]])]).
step(matrix_mul([[1, 0], [3, 1]], [[1, 2], [0, 1]], [[1, 2], [3, 7]]),
     rule(6),
     ['Row1' = [1, 0],
      'Row2' = [3, 1],
      'Matrix' = [[1, 2], [0, 1]],
      'Out1' = [1, 2],
      'Out2' = [3, 7]],
     [row_times_matrix([1, 0], [[1, 2], [0, 1]], [1, 2]),
      row_times_matrix([3, 1], [[1, 2], [0, 1]], [3, 7])]).
step(row_times_matrix([1, 0], [[1, 2], [0, 1]], [1, 2]),
     rule(5),
     ['Row' = [1, 0],
      'Matrix' = [[1, 2], [0, 1]],
      'R1' = 1,
      'R2' = 2,
      'Col1' = [1, 0],
      'Col2' = [2, 1]],
     [transpose2([[1, 2], [0, 1]], [[1, 0], [2, 1]]),
      dot2([1, 0], [1, 0], 1),
      dot2([1, 0], [2, 1], 2)]).
step(transpose2([[1, 2], [0, 1]], [[1, 0], [2, 1]]),
     fact(4),
     ['A' = 1, 'B' = 2, 'C' = 0, 'D' = 1],
     []).
step(dot2([1, 0], [1, 0], 1),
     rule(3),
     ['X1' = 1, 'X2' = 0, 'Y1' = 1, 'Y2' = 0, 'R' = 1, 'P1' = 1, 'P2' = 0],
     [1 is 1 * 1, 0 is 0 * 0, 1 is 1 + 0]).
step(1 is 1 + 0, builtin, [], []).
step(dot2([1, 0], [2, 1], 2),
     rule(3),
     ['X1' = 1, 'X2' = 0, 'Y1' = 2, 'Y2' = 1, 'R' = 2, 'P1' = 2, 'P2' = 0],
     [2 is 1 * 2, 0 is 0 * 1, 2 is 2 + 0]).
step(2 is 1 * 2, builtin, [], []).
step(2 is 2 + 0, builtin, [], []).
step(row_times_matrix([3, 1], [[1, 2], [0, 1]], [3, 7]),
     rule(5),
     ['Row' = [3, 1],
      'Matrix' = [[1, 2], [0, 1]],
      'R1' = 3,
      'R2' = 7,
      'Col1' = [1, 0],
      'Col2' = [2, 1]],
     [transpose2([[1, 2], [0, 1]], [[1, 0], [2, 1]]),
      dot2([3, 1], [1, 0], 3),
      dot2([3, 1], [2, 1], 7)]).
step(dot2([3, 1], [1, 0], 3),
     rule(3),
     ['X1' = 3, 'X2' = 1, 'Y1' = 1, 'Y2' = 0, 'R' = 3, 'P1' = 3, 'P2' = 0],
     [3 is 3 * 1, 0 is 1 * 0, 3 is 3 + 0]).
step(3 is 3 * 1, builtin, [], []).
step(3 is 3 + 0, builtin, [], []).
step(dot2([3, 1], [2, 1], 7),
     rule(3),
     ['X1' = 3, 'X2' = 1, 'Y1' = 2, 'Y2' = 1, 'R' = 7, 'P1' = 6, 'P2' = 1],
     [6 is 3 * 2, 1 is 1 * 1, 7 is 6 + 1]).
step(6 is 3 * 2, builtin, [], []).
step(7 is 6 + 1, builtin, [], []).
step(matrix_result(commutative, false),
     rule(9),
     ['A' = [[1, 2], [0, 1]],
      'B' = [[1, 0], [3, 1]],
      'Ab' = [[7, 2], [3, 1]],
      'Ba' = [[1, 2], [3, 7]]],
     [matrix_a([[1, 2], [0, 1]]),
      matrix_b([[1, 0], [3, 1]]),
      matrix_mul([[1, 2], [0, 1]], [[1, 0], [3, 1]], [[7, 2], [3, 1]]),
      matrix_mul([[1, 0], [3, 1]], [[1, 2], [0, 1]], [[1, 2], [3, 7]]),
      [[7, 2], [3, 1]] \= [[1, 2], [3, 7]]]).
step([[7, 2], [3, 1]] \= [[1, 2], [3, 7]], builtin, [], []).
