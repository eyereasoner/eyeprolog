sideCSquared(tri60, 67.0).
sideC(tri60, 8.18535277187245).
status(tri60, acute_triangle).

clause(1, triangle(tri60, 7, 9, 0.5), true).
clause(2,
       side_c_squared(var('Triangle'), var('C2')),
       (triangle(var('Triangle'), var('A'), var('B'), var('Cosc')),
        var('A2') is var('A') * var('A'),
        var('B2') is var('B') * var('B'),
        var('Sum') is var('A2') + var('B2'),
        var('Twoa') is 2 * var('A'),
        var('Twoab') is var('Twoa') * var('B'),
        var('Projection') is var('Twoab') * var('Cosc'),
        var('C2') is var('Sum') - var('Projection'))).
clause(3,
       side_c(var('Triangle'), var('C')),
       (side_c_squared(var('Triangle'), var('C2')), var('C') is var('C2') ** 0.5)).
clause(4, sideCSquared(var('Triangle'), var('C2')), side_c_squared(var('Triangle'), var('C2'))).
clause(5, sideC(var('Triangle'), var('C')), side_c(var('Triangle'), var('C'))).
clause(6,
       status(var('Triangle'), acute_triangle),
       (side_c_squared(var('Triangle'), var('C2')), var('C2') > 0)).

step(sideCSquared(tri60, 67.0),
     rule(4),
     ['Triangle' = tri60, 'C2' = 67.0],
     [side_c_squared(tri60, 67.0)]).
step(side_c_squared(tri60, 67.0),
     rule(2),
     ['Triangle' = tri60,
      'C2' = 67.0,
      'A' = 7,
      'B' = 9,
      'Cosc' = 0.5,
      'A2' = 49,
      'B2' = 81,
      'Sum' = 130,
      'Twoa' = 14,
      'Twoab' = 126,
      'Projection' = 63.0],
     [triangle(tri60, 7, 9, 0.5),
      49 is 7 * 7,
      81 is 9 * 9,
      130 is 49 + 81,
      14 is 2 * 7,
      126 is 14 * 9,
      63.0 is 126 * 0.5,
      67.0 is 130 - 63.0]).
step(triangle(tri60, 7, 9, 0.5), fact(1), [], []).
step(49 is 7 * 7, builtin, [], []).
step(81 is 9 * 9, builtin, [], []).
step(130 is 49 + 81, builtin, [], []).
step(14 is 2 * 7, builtin, [], []).
step(126 is 14 * 9, builtin, [], []).
step(63.0 is 126 * 0.5, builtin, [], []).
step(67.0 is 130 - 63.0, builtin, [], []).
step(sideC(tri60, 8.18535277187245),
     rule(5),
     ['Triangle' = tri60, 'C' = 8.18535277187245],
     [side_c(tri60, 8.18535277187245)]).
step(side_c(tri60, 8.18535277187245),
     rule(3),
     ['Triangle' = tri60, 'C' = 8.18535277187245, 'C2' = 67.0],
     [side_c_squared(tri60, 67.0), 8.18535277187245 is 67.0 ** 0.5]).
step(8.18535277187245 is 67.0 ** 0.5, builtin, [], []).
step(status(tri60, acute_triangle),
     rule(6),
     ['Triangle' = tri60, 'C2' = 67.0],
     [side_c_squared(tri60, 67.0), 67.0 > 0]).
step(67.0 > 0, builtin, [], []).
