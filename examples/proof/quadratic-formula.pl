discriminant(eq1, 1.0).
discriminant(eq2, 64.0).
root(eq1, 3.0).
root(eq2, 3.0).
root(eq1, 2.0).
root(eq2, -1.0).

clause(1, equation(eq1, 1.0, -5.0, 6.0), true).
clause(2, equation(eq2, 2.0, -4.0, -6.0), true).
clause(3,
       discriminant(var('Case'), var('D')),
       (equation(var('Case'), var('A'), var('B'), var('C')),
        var('B2') is var('B') ** 2.0,
        var('Foura') is 4.0 * var('A'),
        var('Fourac') is var('Foura') * var('C'),
        var('D') is var('B2') - var('Fourac'))).
clause(4,
       sqrt_discriminant(var('Case'), var('S')),
       (discriminant(var('Case'), var('D')), var('D') >= 0.0, var('S') is var('D') ** 0.5)).
clause(5,
       negative_b(var('Case'), var('Nb')),
       (equation(var('Case'), anonymous(1), var('B'), anonymous(2)), var('Nb') is - var('B'))).
clause(6,
       denominator(var('Case'), var('Den')),
       (equation(var('Case'), var('A'), anonymous(1), anonymous(2)),
        var('Den') is 2.0 * var('A'))).
clause(7,
       root_plus(var('Case'), var('Root')),
       (negative_b(var('Case'), var('Nb')),
        sqrt_discriminant(var('Case'), var('S')),
        denominator(var('Case'), var('Den')),
        var('Numerator') is var('Nb') + var('S'),
        var('Root') is var('Numerator') / var('Den'))).
clause(8,
       root_minus(var('Case'), var('Root')),
       (negative_b(var('Case'), var('Nb')),
        sqrt_discriminant(var('Case'), var('S')),
        denominator(var('Case'), var('Den')),
        var('Numerator') is var('Nb') - var('S'),
        var('Root') is var('Numerator') / var('Den'))).
clause(9, root(var('Case'), var('Root')), root_plus(var('Case'), var('Root'))).
clause(10, root(var('Case'), var('Root')), root_minus(var('Case'), var('Root'))).

step(discriminant(eq1, 1.0),
     rule(3),
     ['Case' = eq1,
      'D' = 1.0,
      'A' = 1.0,
      'B' = -5.0,
      'C' = 6.0,
      'B2' = 25.0,
      'Foura' = 4.0,
      'Fourac' = 24.0],
     [equation(eq1, 1.0, -5.0, 6.0),
      25.0 is -5.0 ** 2.0,
      4.0 is 4.0 * 1.0,
      24.0 is 4.0 * 6.0,
      1.0 is 25.0 - 24.0]).
step(equation(eq1, 1.0, -5.0, 6.0), fact(1), [], []).
step(25.0 is -5.0 ** 2.0, builtin, [], []).
step(4.0 is 4.0 * 1.0, builtin, [], []).
step(24.0 is 4.0 * 6.0, builtin, [], []).
step(1.0 is 25.0 - 24.0, builtin, [], []).
step(discriminant(eq2, 64.0),
     rule(3),
     ['Case' = eq2,
      'D' = 64.0,
      'A' = 2.0,
      'B' = -4.0,
      'C' = -6.0,
      'B2' = 16.0,
      'Foura' = 8.0,
      'Fourac' = -48.0],
     [equation(eq2, 2.0, -4.0, -6.0),
      16.0 is -4.0 ** 2.0,
      8.0 is 4.0 * 2.0,
      -48.0 is 8.0 * -6.0,
      64.0 is 16.0 - -48.0]).
step(equation(eq2, 2.0, -4.0, -6.0), fact(2), [], []).
step(16.0 is -4.0 ** 2.0, builtin, [], []).
step(8.0 is 4.0 * 2.0, builtin, [], []).
step(-48.0 is 8.0 * -6.0, builtin, [], []).
step(64.0 is 16.0 - -48.0, builtin, [], []).
step(root(eq1, 3.0), rule(9), ['Case' = eq1, 'Root' = 3.0], [root_plus(eq1, 3.0)]).
step(root_plus(eq1, 3.0),
     rule(7),
     ['Case' = eq1, 'Root' = 3.0, 'Nb' = 5.0, 'S' = 1.0, 'Den' = 2.0, 'Numerator' = 6.0],
     [negative_b(eq1, 5.0),
      sqrt_discriminant(eq1, 1.0),
      denominator(eq1, 2.0),
      6.0 is 5.0 + 1.0,
      3.0 is 6.0 / 2.0]).
step(negative_b(eq1, 5.0),
     rule(5),
     ['Case' = eq1, 'Nb' = 5.0, 'B' = -5.0],
     [equation(eq1, 1.0, -5.0, 6.0), 5.0 is - -5.0]).
step(5.0 is - -5.0, builtin, [], []).
step(sqrt_discriminant(eq1, 1.0),
     rule(4),
     ['Case' = eq1, 'S' = 1.0, 'D' = 1.0],
     [discriminant(eq1, 1.0), 1.0 >= 0.0, 1.0 is 1.0 ** 0.5]).
step(1.0 >= 0.0, builtin, [], []).
step(1.0 is 1.0 ** 0.5, builtin, [], []).
step(denominator(eq1, 2.0),
     rule(6),
     ['Case' = eq1, 'Den' = 2.0, 'A' = 1.0],
     [equation(eq1, 1.0, -5.0, 6.0), 2.0 is 2.0 * 1.0]).
step(2.0 is 2.0 * 1.0, builtin, [], []).
step(6.0 is 5.0 + 1.0, builtin, [], []).
step(3.0 is 6.0 / 2.0, builtin, [], []).
step(root(eq2, 3.0), rule(9), ['Case' = eq2, 'Root' = 3.0], [root_plus(eq2, 3.0)]).
step(root_plus(eq2, 3.0),
     rule(7),
     ['Case' = eq2, 'Root' = 3.0, 'Nb' = 4.0, 'S' = 8.0, 'Den' = 4.0, 'Numerator' = 12.0],
     [negative_b(eq2, 4.0),
      sqrt_discriminant(eq2, 8.0),
      denominator(eq2, 4.0),
      12.0 is 4.0 + 8.0,
      3.0 is 12.0 / 4.0]).
step(negative_b(eq2, 4.0),
     rule(5),
     ['Case' = eq2, 'Nb' = 4.0, 'B' = -4.0],
     [equation(eq2, 2.0, -4.0, -6.0), 4.0 is - -4.0]).
step(4.0 is - -4.0, builtin, [], []).
step(sqrt_discriminant(eq2, 8.0),
     rule(4),
     ['Case' = eq2, 'S' = 8.0, 'D' = 64.0],
     [discriminant(eq2, 64.0), 64.0 >= 0.0, 8.0 is 64.0 ** 0.5]).
step(64.0 >= 0.0, builtin, [], []).
step(8.0 is 64.0 ** 0.5, builtin, [], []).
step(denominator(eq2, 4.0),
     rule(6),
     ['Case' = eq2, 'Den' = 4.0, 'A' = 2.0],
     [equation(eq2, 2.0, -4.0, -6.0), 4.0 is 2.0 * 2.0]).
step(4.0 is 2.0 * 2.0, builtin, [], []).
step(12.0 is 4.0 + 8.0, builtin, [], []).
step(3.0 is 12.0 / 4.0, builtin, [], []).
step(root(eq1, 2.0), rule(10), ['Case' = eq1, 'Root' = 2.0], [root_minus(eq1, 2.0)]).
step(root_minus(eq1, 2.0),
     rule(8),
     ['Case' = eq1, 'Root' = 2.0, 'Nb' = 5.0, 'S' = 1.0, 'Den' = 2.0, 'Numerator' = 4.0],
     [negative_b(eq1, 5.0),
      sqrt_discriminant(eq1, 1.0),
      denominator(eq1, 2.0),
      4.0 is 5.0 - 1.0,
      2.0 is 4.0 / 2.0]).
step(4.0 is 5.0 - 1.0, builtin, [], []).
step(2.0 is 4.0 / 2.0, builtin, [], []).
step(root(eq2, -1.0), rule(10), ['Case' = eq2, 'Root' = -1.0], [root_minus(eq2, -1.0)]).
step(root_minus(eq2, -1.0),
     rule(8),
     ['Case' = eq2, 'Root' = -1.0, 'Nb' = 4.0, 'S' = 8.0, 'Den' = 4.0, 'Numerator' = -4.0],
     [negative_b(eq2, 4.0),
      sqrt_discriminant(eq2, 8.0),
      denominator(eq2, 4.0),
      -4.0 is 4.0 - 8.0,
      -1.0 is -4.0 / 4.0]).
step(-4.0 is 4.0 - 8.0, builtin, [], []).
step(-1.0 is -4.0 / 4.0, builtin, [], []).
