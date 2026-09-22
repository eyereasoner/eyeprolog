type(filter1, first_order_low_pass).
why(
  type(filter1, first_order_low_pass),
  step(
    type(filter1, first_order_low_pass),
    rule("electrical-rc-filter.pl", clause(6)),
    ['Filter' = filter1, '_r' = 10000.0, '_c' = 0.000001],
    [
      step(component(filter1, resistor_ohm, 10000.0), fact("electrical-rc-filter.pl", clause(1)), [], []),
      step(component(filter1, capacitor_f, 0.000001), fact("electrical-rc-filter.pl", clause(2)), [], [])
    ]
  )
).

timeConstant_s(filter1, 0.01).
why(
  timeConstant_s(filter1, 0.01),
  step(
    timeConstant_s(filter1, 0.01),
    rule("electrical-rc-filter.pl", clause(7)),
    ['Filter' = filter1, 'Tau' = 0.01],
    [
      step(
        time_constant(filter1, 0.01),
        rule("electrical-rc-filter.pl", clause(4)),
        ['Filter' = filter1, 'Tau' = 0.01, 'R' = 10000.0, 'C' = 0.000001],
        [
          step(component(filter1, resistor_ohm, 10000.0), fact("electrical-rc-filter.pl", clause(1)), [], []),
          step(component(filter1, capacitor_f, 0.000001), fact("electrical-rc-filter.pl", clause(2)), [], []),
          step(is(0.01, *(10000.0, 0.000001)), builtin(is, 2), [], [])
        ]
      )
    ]
  )
).

cutoffFrequency_Hz(filter1, 15.915494309189533).
why(
  cutoffFrequency_Hz(filter1, 15.915494309189533),
  step(
    cutoffFrequency_Hz(filter1, 15.915494309189533),
    rule("electrical-rc-filter.pl", clause(8)),
    ['Filter' = filter1, 'Frequency' = 15.915494309189533],
    [
      step(
        cutoff_frequency(filter1, 15.915494309189533),
        rule("electrical-rc-filter.pl", clause(5)),
        ['Filter' = filter1, 'Frequency' = 15.915494309189533, 'Tau' = 0.01, 'Pi' = 3.141592653589793, 'Twopi' = 6.283185307179586, 'Denominator' = 0.06283185307179587],
        [
          step(
            time_constant(filter1, 0.01),
            rule("electrical-rc-filter.pl", clause(4)),
            ['Filter' = filter1, 'Tau' = 0.01, 'R' = 10000.0, 'C' = 0.000001],
            [
              step(component(filter1, resistor_ohm, 10000.0), fact("electrical-rc-filter.pl", clause(1)), [], []),
              step(component(filter1, capacitor_f, 0.000001), fact("electrical-rc-filter.pl", clause(2)), [], []),
              step(is(0.01, *(10000.0, 0.000001)), builtin(is, 2), [], [])
            ]
          ),
          step(constant(pi, 3.141592653589793), fact("electrical-rc-filter.pl", clause(3)), [], []),
          step(is(6.283185307179586, *(2.0, 3.141592653589793)), builtin(is, 2), [], []),
          step(is(0.06283185307179587, *(6.283185307179586, 0.01)), builtin(is, 2), [], []),
          step(is(15.915494309189533, /(1.0, 0.06283185307179587)), builtin(is, 2), [], [])
        ]
      )
    ]
  )
).

