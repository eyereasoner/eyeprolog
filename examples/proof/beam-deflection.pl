type(beam1, cantilever_beam).
tipDeflection_m(beam1, 0.00390625).
tipDeflection_mm(beam1, 3.90625).
limit_mm(beam1, 5.0).
status(beam1, within_deflection_limit).

clause(1, beam(beam1, force_N, 1200.0), true).
clause(2, beam(beam1, length_m, 2.5), true).
clause(3, beam(beam1, elasticModulus_Pa, 200000000000.0), true).
clause(4, beam(beam1, secondMoment_m4, 0.000008), true).
clause(5, limit(beam1, maxDeflection_mm, 5.0), true).
clause(6,
       tip_deflection_m(var('Beam'), var('Deflection')),
       (beam(var('Beam'), force_N, var('Force')),
        beam(var('Beam'), length_m, var('Length')),
        beam(var('Beam'), elasticModulus_Pa, var('Elasticmodulus')),
        beam(var('Beam'), secondMoment_m4, var('Secondmoment')),
        var('Lengthcubed') is var('Length') ** 3.0,
        var('Numerator') is var('Force') * var('Lengthcubed'),
        var('Threee') is 3.0 * var('Elasticmodulus'),
        var('Denominator') is var('Threee') * var('Secondmoment'),
        var('Deflection') is var('Numerator') / var('Denominator'))).
clause(7,
       tip_deflection_mm(var('Beam'), var('Deflectionmm')),
       (tip_deflection_m(var('Beam'), var('Deflectionm')),
        var('Deflectionmm') is var('Deflectionm') * 1000.0)).
clause(8, type(var('Beam'), cantilever_beam), beam(var('Beam'), force_N, anonymous(1))).
clause(9,
       tipDeflection_m(var('Beam'), var('Deflectionm')),
       tip_deflection_m(var('Beam'), var('Deflectionm'))).
clause(10,
       tipDeflection_mm(var('Beam'), var('Deflectionmm')),
       tip_deflection_mm(var('Beam'), var('Deflectionmm'))).
clause(11,
       limit_mm(var('Beam'), var('Limit')),
       limit(var('Beam'), maxDeflection_mm, var('Limit'))).
clause(12,
       status(var('Beam'), within_deflection_limit),
       (tip_deflection_mm(var('Beam'), var('Deflectionmm')),
        limit(var('Beam'), maxDeflection_mm, var('Limit')),
        var('Deflectionmm') =< var('Limit'))).

step(type(beam1, cantilever_beam), rule(8), ['Beam' = beam1], [beam(beam1, force_N, 1200.0)]).
step(beam(beam1, force_N, 1200.0), fact(1), [], []).
step(tipDeflection_m(beam1, 0.00390625),
     rule(9),
     ['Beam' = beam1, 'Deflectionm' = 0.00390625],
     [tip_deflection_m(beam1, 0.00390625)]).
step(tip_deflection_m(beam1, 0.00390625),
     rule(6),
     ['Beam' = beam1,
      'Deflection' = 0.00390625,
      'Force' = 1200.0,
      'Length' = 2.5,
      'Elasticmodulus' = 200000000000.0,
      'Secondmoment' = 0.000008,
      'Lengthcubed' = 15.625,
      'Numerator' = 18750.0,
      'Threee' = 600000000000.0,
      'Denominator' = 4800000.0],
     [beam(beam1, force_N, 1200.0),
      beam(beam1, length_m, 2.5),
      beam(beam1, elasticModulus_Pa, 200000000000.0),
      beam(beam1, secondMoment_m4, 0.000008),
      15.625 is 2.5 ** 3.0,
      18750.0 is 1200.0 * 15.625,
      600000000000.0 is 3.0 * 200000000000.0,
      4800000.0 is 600000000000.0 * 0.000008,
      0.00390625 is 18750.0 / 4800000.0]).
step(beam(beam1, length_m, 2.5), fact(2), [], []).
step(beam(beam1, elasticModulus_Pa, 200000000000.0), fact(3), [], []).
step(beam(beam1, secondMoment_m4, 0.000008), fact(4), [], []).
step(15.625 is 2.5 ** 3.0, builtin, [], []).
step(18750.0 is 1200.0 * 15.625, builtin, [], []).
step(600000000000.0 is 3.0 * 200000000000.0, builtin, [], []).
step(4800000.0 is 600000000000.0 * 0.000008, builtin, [], []).
step(0.00390625 is 18750.0 / 4800000.0, builtin, [], []).
step(tipDeflection_mm(beam1, 3.90625),
     rule(10),
     ['Beam' = beam1, 'Deflectionmm' = 3.90625],
     [tip_deflection_mm(beam1, 3.90625)]).
step(tip_deflection_mm(beam1, 3.90625),
     rule(7),
     ['Beam' = beam1, 'Deflectionmm' = 3.90625, 'Deflectionm' = 0.00390625],
     [tip_deflection_m(beam1, 0.00390625), 3.90625 is 0.00390625 * 1000.0]).
step(3.90625 is 0.00390625 * 1000.0, builtin, [], []).
step(limit_mm(beam1, 5.0),
     rule(11),
     ['Beam' = beam1, 'Limit' = 5.0],
     [limit(beam1, maxDeflection_mm, 5.0)]).
step(limit(beam1, maxDeflection_mm, 5.0), fact(5), [], []).
step(status(beam1, within_deflection_limit),
     rule(12),
     ['Beam' = beam1, 'Deflectionmm' = 3.90625, 'Limit' = 5.0],
     [tip_deflection_mm(beam1, 3.90625), limit(beam1, maxDeflection_mm, 5.0), 3.90625 =< 5.0]).
step(3.90625 =< 5.0, builtin, [], []).
