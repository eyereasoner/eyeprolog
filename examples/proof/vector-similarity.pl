dotProduct(pair1, 12.0).
normA(pair1, 3.7416573867739413).
normB(pair1, 8.774964387392123).
cosineSimilarity(pair1, 0.3654869423239036).

clause(1, vector(pair1, a, [1.0, 2.0, 3.0]), true).
clause(2, vector(pair1, b, [4.0, -5.0, 6.0]), true).
clause(3, dot([], [], 0.0), true).
clause(4,
       dot([var('A') | var('As')], [var('B') | var('Bs')], var('Dot')),
       (var('Product') is var('A') * var('B'),
        dot(var('As'), var('Bs'), var('Rest')),
        var('Dot') is var('Product') + var('Rest'))).
clause(5, sum_squares([], 0.0), true).
clause(6,
       sum_squares([var('X') | var('Xs')], var('Total')),
       (var('Squared') is var('X') ** 2.0,
        sum_squares(var('Xs'), var('Rest')),
        var('Total') is var('Squared') + var('Rest'))).
clause(7,
       norm(var('Vector'), var('Norm')),
       (sum_squares(var('Vector'), var('Sumsquares')), var('Norm') is var('Sumsquares') ** 0.5)).
clause(8,
       cosine_similarity(var('Case'), var('Similarity')),
       (vector(var('Case'), a, var('A')),
        vector(var('Case'), b, var('B')),
        dot(var('A'), var('B'), var('Dot')),
        norm(var('A'), var('Norma')),
        norm(var('B'), var('Normb')),
        var('Denominator') is var('Norma') * var('Normb'),
        var('Similarity') is var('Dot') / var('Denominator'))).
clause(9,
       dotProduct(var('Case'), var('Dot')),
       (vector(var('Case'), a, var('A')),
        vector(var('Case'), b, var('B')),
        dot(var('A'), var('B'), var('Dot')))).
clause(10,
       normA(var('Case'), var('Norma')),
       (vector(var('Case'), a, var('A')), norm(var('A'), var('Norma')))).
clause(11,
       normB(var('Case'), var('Normb')),
       (vector(var('Case'), b, var('B')), norm(var('B'), var('Normb')))).
clause(12,
       cosineSimilarity(var('Case'), var('Similarity')),
       cosine_similarity(var('Case'), var('Similarity'))).

step(dotProduct(pair1, 12.0),
     rule(9),
     ['Case' = pair1, 'Dot' = 12.0, 'A' = [1.0, 2.0, 3.0], 'B' = [4.0, -5.0, 6.0]],
     [vector(pair1, a, [1.0, 2.0, 3.0]),
      vector(pair1, b, [4.0, -5.0, 6.0]),
      dot([1.0, 2.0, 3.0], [4.0, -5.0, 6.0], 12.0)]).
step(vector(pair1, a, [1.0, 2.0, 3.0]), fact(1), [], []).
step(vector(pair1, b, [4.0, -5.0, 6.0]), fact(2), [], []).
step(dot([1.0, 2.0, 3.0], [4.0, -5.0, 6.0], 12.0),
     rule(4),
     ['A' = 1.0,
      'As' = [2.0, 3.0],
      'B' = 4.0,
      'Bs' = [-5.0, 6.0],
      'Dot' = 12.0,
      'Product' = 4.0,
      'Rest' = 8.0],
     [4.0 is 1.0 * 4.0, dot([2.0, 3.0], [-5.0, 6.0], 8.0), 12.0 is 4.0 + 8.0]).
step(4.0 is 1.0 * 4.0, builtin, [], []).
step(dot([2.0, 3.0], [-5.0, 6.0], 8.0),
     rule(4),
     ['A' = 2.0,
      'As' = [3.0],
      'B' = -5.0,
      'Bs' = [6.0],
      'Dot' = 8.0,
      'Product' = -10.0,
      'Rest' = 18.0],
     [-10.0 is 2.0 * -5.0, dot([3.0], [6.0], 18.0), 8.0 is -10.0 + 18.0]).
step(-10.0 is 2.0 * -5.0, builtin, [], []).
step(dot([3.0], [6.0], 18.0),
     rule(4),
     ['A' = 3.0, 'As' = [], 'B' = 6.0, 'Bs' = [], 'Dot' = 18.0, 'Product' = 18.0, 'Rest' = 0.0],
     [18.0 is 3.0 * 6.0, dot([], [], 0.0), 18.0 is 18.0 + 0.0]).
step(18.0 is 3.0 * 6.0, builtin, [], []).
step(dot([], [], 0.0), fact(3), [], []).
step(18.0 is 18.0 + 0.0, builtin, [], []).
step(8.0 is -10.0 + 18.0, builtin, [], []).
step(12.0 is 4.0 + 8.0, builtin, [], []).
step(normA(pair1, 3.7416573867739413),
     rule(10),
     ['Case' = pair1, 'Norma' = 3.7416573867739413, 'A' = [1.0, 2.0, 3.0]],
     [vector(pair1, a, [1.0, 2.0, 3.0]), norm([1.0, 2.0, 3.0], 3.7416573867739413)]).
step(norm([1.0, 2.0, 3.0], 3.7416573867739413),
     rule(7),
     ['Vector' = [1.0, 2.0, 3.0], 'Norm' = 3.7416573867739413, 'Sumsquares' = 14.0],
     [sum_squares([1.0, 2.0, 3.0], 14.0), 3.7416573867739413 is 14.0 ** 0.5]).
step(sum_squares([1.0, 2.0, 3.0], 14.0),
     rule(6),
     ['X' = 1.0, 'Xs' = [2.0, 3.0], 'Total' = 14.0, 'Squared' = 1.0, 'Rest' = 13.0],
     [1.0 is 1.0 ** 2.0, sum_squares([2.0, 3.0], 13.0), 14.0 is 1.0 + 13.0]).
step(1.0 is 1.0 ** 2.0, builtin, [], []).
step(sum_squares([2.0, 3.0], 13.0),
     rule(6),
     ['X' = 2.0, 'Xs' = [3.0], 'Total' = 13.0, 'Squared' = 4.0, 'Rest' = 9.0],
     [4.0 is 2.0 ** 2.0, sum_squares([3.0], 9.0), 13.0 is 4.0 + 9.0]).
step(4.0 is 2.0 ** 2.0, builtin, [], []).
step(sum_squares([3.0], 9.0),
     rule(6),
     ['X' = 3.0, 'Xs' = [], 'Total' = 9.0, 'Squared' = 9.0, 'Rest' = 0.0],
     [9.0 is 3.0 ** 2.0, sum_squares([], 0.0), 9.0 is 9.0 + 0.0]).
step(9.0 is 3.0 ** 2.0, builtin, [], []).
step(sum_squares([], 0.0), fact(5), [], []).
step(9.0 is 9.0 + 0.0, builtin, [], []).
step(13.0 is 4.0 + 9.0, builtin, [], []).
step(14.0 is 1.0 + 13.0, builtin, [], []).
step(3.7416573867739413 is 14.0 ** 0.5, builtin, [], []).
step(normB(pair1, 8.774964387392123),
     rule(11),
     ['Case' = pair1, 'Normb' = 8.774964387392123, 'B' = [4.0, -5.0, 6.0]],
     [vector(pair1, b, [4.0, -5.0, 6.0]), norm([4.0, -5.0, 6.0], 8.774964387392123)]).
step(norm([4.0, -5.0, 6.0], 8.774964387392123),
     rule(7),
     ['Vector' = [4.0, -5.0, 6.0], 'Norm' = 8.774964387392123, 'Sumsquares' = 77.0],
     [sum_squares([4.0, -5.0, 6.0], 77.0), 8.774964387392123 is 77.0 ** 0.5]).
step(sum_squares([4.0, -5.0, 6.0], 77.0),
     rule(6),
     ['X' = 4.0, 'Xs' = [-5.0, 6.0], 'Total' = 77.0, 'Squared' = 16.0, 'Rest' = 61.0],
     [16.0 is 4.0 ** 2.0, sum_squares([-5.0, 6.0], 61.0), 77.0 is 16.0 + 61.0]).
step(16.0 is 4.0 ** 2.0, builtin, [], []).
step(sum_squares([-5.0, 6.0], 61.0),
     rule(6),
     ['X' = -5.0, 'Xs' = [6.0], 'Total' = 61.0, 'Squared' = 25.0, 'Rest' = 36.0],
     [25.0 is -5.0 ** 2.0, sum_squares([6.0], 36.0), 61.0 is 25.0 + 36.0]).
step(25.0 is -5.0 ** 2.0, builtin, [], []).
step(sum_squares([6.0], 36.0),
     rule(6),
     ['X' = 6.0, 'Xs' = [], 'Total' = 36.0, 'Squared' = 36.0, 'Rest' = 0.0],
     [36.0 is 6.0 ** 2.0, sum_squares([], 0.0), 36.0 is 36.0 + 0.0]).
step(36.0 is 6.0 ** 2.0, builtin, [], []).
step(36.0 is 36.0 + 0.0, builtin, [], []).
step(61.0 is 25.0 + 36.0, builtin, [], []).
step(77.0 is 16.0 + 61.0, builtin, [], []).
step(8.774964387392123 is 77.0 ** 0.5, builtin, [], []).
step(cosineSimilarity(pair1, 0.3654869423239036),
     rule(12),
     ['Case' = pair1, 'Similarity' = 0.3654869423239036],
     [cosine_similarity(pair1, 0.3654869423239036)]).
step(cosine_similarity(pair1, 0.3654869423239036),
     rule(8),
     ['Case' = pair1,
      'Similarity' = 0.3654869423239036,
      'A' = [1.0, 2.0, 3.0],
      'B' = [4.0, -5.0, 6.0],
      'Dot' = 12.0,
      'Norma' = 3.7416573867739413,
      'Normb' = 8.774964387392123,
      'Denominator' = 32.83291031876401],
     [vector(pair1, a, [1.0, 2.0, 3.0]),
      vector(pair1, b, [4.0, -5.0, 6.0]),
      dot([1.0, 2.0, 3.0], [4.0, -5.0, 6.0], 12.0),
      norm([1.0, 2.0, 3.0], 3.7416573867739413),
      norm([4.0, -5.0, 6.0], 8.774964387392123),
      32.83291031876401 is 3.7416573867739413 * 8.774964387392123,
      0.3654869423239036 is 12.0 / 32.83291031876401]).
step(32.83291031876401 is 3.7416573867739413 * 8.774964387392123, builtin, [], []).
step(0.3654869423239036 is 12.0 / 32.83291031876401, builtin, [], []).
