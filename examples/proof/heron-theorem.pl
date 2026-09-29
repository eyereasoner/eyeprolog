semiperimeter(field_plot, 21.0).
area(field_plot, 84.0).
heronProduct(field_plot, 7056.0).
status(field_plot, valid_survey_triangle).

clause(1, triangle(field_plot, 13, 14, 15), true).
clause(2,
       semiperimeter(var('Triangle'), var('S')),
       (triangle(var('Triangle'), var('A'), var('B'), var('C')),
        var('Ab') is var('A') + var('B'),
        var('Sum') is var('Ab') + var('C'),
        var('S') is var('Sum') / 2)).
clause(3,
       heron_product(var('Triangle'), var('Product')),
       (triangle(var('Triangle'), var('A'), var('B'), var('C')),
        semiperimeter(var('Triangle'), var('S')),
        var('Sa') is var('S') - var('A'),
        var('Sb') is var('S') - var('B'),
        var('Sc') is var('S') - var('C'),
        var('T1') is var('S') * var('Sa'),
        var('T2') is var('T1') * var('Sb'),
        var('Product') is var('T2') * var('Sc'))).
clause(4,
       area(var('Triangle'), var('Area')),
       (heron_product(var('Triangle'), var('Product')), var('Area') is var('Product') ** 0.5)).
clause(5, heronProduct(var('Triangle'), var('P')), heron_product(var('Triangle'), var('P'))).
clause(6,
       status(var('Triangle'), valid_survey_triangle),
       (area(var('Triangle'), var('A')), var('A') > 0)).

step(semiperimeter(field_plot, 21.0),
     rule(2),
     ['Triangle' = field_plot, 'S' = 21.0, 'A' = 13, 'B' = 14, 'C' = 15, 'Ab' = 27, 'Sum' = 42],
     [triangle(field_plot, 13, 14, 15), 27 is 13 + 14, 42 is 27 + 15, 21.0 is 42 / 2]).
step(triangle(field_plot, 13, 14, 15), fact(1), [], []).
step(27 is 13 + 14, builtin, [], []).
step(42 is 27 + 15, builtin, [], []).
step(21.0 is 42 / 2, builtin, [], []).
step(area(field_plot, 84.0),
     rule(4),
     ['Triangle' = field_plot, 'Area' = 84.0, 'Product' = 7056.0],
     [heron_product(field_plot, 7056.0), 84.0 is 7056.0 ** 0.5]).
step(heron_product(field_plot, 7056.0),
     rule(3),
     ['Triangle' = field_plot,
      'Product' = 7056.0,
      'A' = 13,
      'B' = 14,
      'C' = 15,
      'S' = 21.0,
      'Sa' = 8.0,
      'Sb' = 7.0,
      'Sc' = 6.0,
      'T1' = 168.0,
      'T2' = 1176.0],
     [triangle(field_plot, 13, 14, 15),
      semiperimeter(field_plot, 21.0),
      8.0 is 21.0 - 13,
      7.0 is 21.0 - 14,
      6.0 is 21.0 - 15,
      168.0 is 21.0 * 8.0,
      1176.0 is 168.0 * 7.0,
      7056.0 is 1176.0 * 6.0]).
step(8.0 is 21.0 - 13, builtin, [], []).
step(7.0 is 21.0 - 14, builtin, [], []).
step(6.0 is 21.0 - 15, builtin, [], []).
step(168.0 is 21.0 * 8.0, builtin, [], []).
step(1176.0 is 168.0 * 7.0, builtin, [], []).
step(7056.0 is 1176.0 * 6.0, builtin, [], []).
step(84.0 is 7056.0 ** 0.5, builtin, [], []).
step(heronProduct(field_plot, 7056.0),
     rule(5),
     ['Triangle' = field_plot, 'P' = 7056.0],
     [heron_product(field_plot, 7056.0)]).
step(status(field_plot, valid_survey_triangle),
     rule(6),
     ['Triangle' = field_plot, 'A' = 84.0],
     [area(field_plot, 84.0), 84.0 > 0]).
step(84.0 > 0, builtin, [], []).
