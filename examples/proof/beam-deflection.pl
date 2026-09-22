type(beam1, cantilever_beam).
why(
  type(beam1, cantilever_beam),
  step(
    type(beam1, cantilever_beam),
    rule("beam-deflection.pl", clause(8)),
    ['Beam' = beam1, '_force' = 1200.0],
    [
      step(beam(beam1, force_N, 1200.0), fact("beam-deflection.pl", clause(1)), [], [])
    ]
  )
).

tipDeflection_m(beam1, 0.00390625).
why(
  tipDeflection_m(beam1, 0.00390625),
  step(
    tipDeflection_m(beam1, 0.00390625),
    rule("beam-deflection.pl", clause(9)),
    ['Beam' = beam1, 'Deflectionm' = 0.00390625],
    [
      step(
        tip_deflection_m(beam1, 0.00390625),
        rule("beam-deflection.pl", clause(6)),
        ['Beam' = beam1, 'Deflection' = 0.00390625, 'Force' = 1200.0, 'Length' = 2.5, 'Elasticmodulus' = 200000000000.0, 'Secondmoment' = 0.000008, 'Lengthcubed' = 15.625, 'Numerator' = 18750.0, 'Threee' = 600000000000.0, 'Denominator' = 4800000.0],
        [
          step(beam(beam1, force_N, 1200.0), fact("beam-deflection.pl", clause(1)), [], []),
          step(beam(beam1, length_m, 2.5), fact("beam-deflection.pl", clause(2)), [], []),
          step(beam(beam1, elasticModulus_Pa, 200000000000.0), fact("beam-deflection.pl", clause(3)), [], []),
          step(beam(beam1, secondMoment_m4, 0.000008), fact("beam-deflection.pl", clause(4)), [], []),
          step(is(15.625, **(2.5, 3.0)), builtin(is, 2), [], []),
          step(is(18750.0, *(1200.0, 15.625)), builtin(is, 2), [], []),
          step(is(600000000000.0, *(3.0, 200000000000.0)), builtin(is, 2), [], []),
          step(is(4800000.0, *(600000000000.0, 0.000008)), builtin(is, 2), [], []),
          step(is(0.00390625, /(18750.0, 4800000.0)), builtin(is, 2), [], [])
        ]
      )
    ]
  )
).

tipDeflection_mm(beam1, 3.90625).
why(
  tipDeflection_mm(beam1, 3.90625),
  step(
    tipDeflection_mm(beam1, 3.90625),
    rule("beam-deflection.pl", clause(10)),
    ['Beam' = beam1, 'Deflectionmm' = 3.90625],
    [
      step(
        tip_deflection_mm(beam1, 3.90625),
        rule("beam-deflection.pl", clause(7)),
        ['Beam' = beam1, 'Deflectionmm' = 3.90625, 'Deflectionm' = 0.00390625],
        [
          step(
            tip_deflection_m(beam1, 0.00390625),
            rule("beam-deflection.pl", clause(6)),
            ['Beam' = beam1, 'Deflection' = 0.00390625, 'Force' = 1200.0, 'Length' = 2.5, 'Elasticmodulus' = 200000000000.0, 'Secondmoment' = 0.000008, 'Lengthcubed' = 15.625, 'Numerator' = 18750.0, 'Threee' = 600000000000.0, 'Denominator' = 4800000.0],
            [
              step(beam(beam1, force_N, 1200.0), fact("beam-deflection.pl", clause(1)), [], []),
              step(beam(beam1, length_m, 2.5), fact("beam-deflection.pl", clause(2)), [], []),
              step(beam(beam1, elasticModulus_Pa, 200000000000.0), fact("beam-deflection.pl", clause(3)), [], []),
              step(beam(beam1, secondMoment_m4, 0.000008), fact("beam-deflection.pl", clause(4)), [], []),
              step(is(15.625, **(2.5, 3.0)), builtin(is, 2), [], []),
              step(is(18750.0, *(1200.0, 15.625)), builtin(is, 2), [], []),
              step(is(600000000000.0, *(3.0, 200000000000.0)), builtin(is, 2), [], []),
              step(is(4800000.0, *(600000000000.0, 0.000008)), builtin(is, 2), [], []),
              step(is(0.00390625, /(18750.0, 4800000.0)), builtin(is, 2), [], [])
            ]
          ),
          step(is(3.90625, *(0.00390625, 1000.0)), builtin(is, 2), [], [])
        ]
      )
    ]
  )
).

limit_mm(beam1, 5.0).
why(
  limit_mm(beam1, 5.0),
  step(
    limit_mm(beam1, 5.0),
    rule("beam-deflection.pl", clause(11)),
    ['Beam' = beam1, 'Limit' = 5.0],
    [
      step(limit(beam1, maxDeflection_mm, 5.0), fact("beam-deflection.pl", clause(5)), [], [])
    ]
  )
).

status(beam1, within_deflection_limit).
why(
  status(beam1, within_deflection_limit),
  step(
    status(beam1, within_deflection_limit),
    rule("beam-deflection.pl", clause(12)),
    ['Beam' = beam1, 'Deflectionmm' = 3.90625, 'Limit' = 5.0],
    [
      step(
        tip_deflection_mm(beam1, 3.90625),
        rule("beam-deflection.pl", clause(7)),
        ['Beam' = beam1, 'Deflectionmm' = 3.90625, 'Deflectionm' = 0.00390625],
        [
          step(
            tip_deflection_m(beam1, 0.00390625),
            rule("beam-deflection.pl", clause(6)),
            ['Beam' = beam1, 'Deflection' = 0.00390625, 'Force' = 1200.0, 'Length' = 2.5, 'Elasticmodulus' = 200000000000.0, 'Secondmoment' = 0.000008, 'Lengthcubed' = 15.625, 'Numerator' = 18750.0, 'Threee' = 600000000000.0, 'Denominator' = 4800000.0],
            [
              step(beam(beam1, force_N, 1200.0), fact("beam-deflection.pl", clause(1)), [], []),
              step(beam(beam1, length_m, 2.5), fact("beam-deflection.pl", clause(2)), [], []),
              step(beam(beam1, elasticModulus_Pa, 200000000000.0), fact("beam-deflection.pl", clause(3)), [], []),
              step(beam(beam1, secondMoment_m4, 0.000008), fact("beam-deflection.pl", clause(4)), [], []),
              step(is(15.625, **(2.5, 3.0)), builtin(is, 2), [], []),
              step(is(18750.0, *(1200.0, 15.625)), builtin(is, 2), [], []),
              step(is(600000000000.0, *(3.0, 200000000000.0)), builtin(is, 2), [], []),
              step(is(4800000.0, *(600000000000.0, 0.000008)), builtin(is, 2), [], []),
              step(is(0.00390625, /(18750.0, 4800000.0)), builtin(is, 2), [], [])
            ]
          ),
          step(is(3.90625, *(0.00390625, 1000.0)), builtin(is, 2), [], [])
        ]
      ),
      step(limit(beam1, maxDeflection_mm, 5.0), fact("beam-deflection.pl", clause(5)), [], []),
      step(=<(3.90625, 5.0), builtin(=<, 2), [], [])
    ]
  )
).

