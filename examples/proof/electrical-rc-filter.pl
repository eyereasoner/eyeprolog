% Prolog result format 4
query(1, type(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = filter1, 'X1' = first_order_low_pass]).
why(1, ['X0' = filter1, 'X1' = first_order_low_pass], [type(filter1, first_order_low_pass)]).
query(2, timeConstant_s(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = filter1, 'X1' = 0.01]).
why(2, ['X0' = filter1, 'X1' = 0.01], [timeConstant_s(filter1, 0.01)]).
query(3, cutoffFrequency_Hz(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = filter1, 'X1' = 15.915494309189533]).
why(3,
    ['X0' = filter1, 'X1' = 15.915494309189533],
    [cutoffFrequency_Hz(filter1, 15.915494309189533)]).

clause(1, component(filter1, resistor_ohm, 10000.0), true).
clause(2, component(filter1, capacitor_f, 0.000001), true).
clause(3, constant(pi, 3.141592653589793), true).
clause(4,
       time_constant(var('Filter'), var('Tau')),
       (component(var('Filter'), resistor_ohm, var('R')),
        component(var('Filter'), capacitor_f, var('C')),
        var('Tau') is var('R') * var('C'))).
clause(5,
       cutoff_frequency(var('Filter'), var('Frequency')),
       (time_constant(var('Filter'), var('Tau')),
        constant(pi, var('Pi')),
        var('Twopi') is 2.0 * var('Pi'),
        var('Denominator') is var('Twopi') * var('Tau'),
        var('Frequency') is 1.0 / var('Denominator'))).
clause(6,
       type(var('Filter'), first_order_low_pass),
       (component(var('Filter'), resistor_ohm, anonymous(1)),
        component(var('Filter'), capacitor_f, anonymous(2)))).
clause(7, timeConstant_s(var('Filter'), var('Tau')), time_constant(var('Filter'), var('Tau'))).
clause(8,
       cutoffFrequency_Hz(var('Filter'), var('Frequency')),
       cutoff_frequency(var('Filter'), var('Frequency'))).

step(type(filter1, first_order_low_pass),
     rule(6),
     ['Filter' = filter1],
     [component(filter1, resistor_ohm, 10000.0), component(filter1, capacitor_f, 0.000001)]).
step(component(filter1, resistor_ohm, 10000.0), fact(1), [], []).
step(component(filter1, capacitor_f, 0.000001), fact(2), [], []).
step(timeConstant_s(filter1, 0.01),
     rule(7),
     ['Filter' = filter1, 'Tau' = 0.01],
     [time_constant(filter1, 0.01)]).
step(time_constant(filter1, 0.01),
     rule(4),
     ['Filter' = filter1, 'Tau' = 0.01, 'R' = 10000.0, 'C' = 0.000001],
     [component(filter1, resistor_ohm, 10000.0),
      component(filter1, capacitor_f, 0.000001),
      0.01 is 10000.0 * 0.000001]).
step(0.01 is 10000.0 * 0.000001, builtin, [], []).
step(cutoffFrequency_Hz(filter1, 15.915494309189533),
     rule(8),
     ['Filter' = filter1, 'Frequency' = 15.915494309189533],
     [cutoff_frequency(filter1, 15.915494309189533)]).
step(cutoff_frequency(filter1, 15.915494309189533),
     rule(5),
     ['Filter' = filter1,
      'Frequency' = 15.915494309189533,
      'Tau' = 0.01,
      'Pi' = 3.141592653589793,
      'Twopi' = 6.283185307179586,
      'Denominator' = 0.06283185307179587],
     [time_constant(filter1, 0.01),
      constant(pi, 3.141592653589793),
      6.283185307179586 is 2.0 * 3.141592653589793,
      0.06283185307179587 is 6.283185307179586 * 0.01,
      15.915494309189533 is 1.0 / 0.06283185307179587]).
step(constant(pi, 3.141592653589793), fact(3), [], []).
step(6.283185307179586 is 2.0 * 3.141592653589793, builtin, [], []).
step(0.06283185307179587 is 6.283185307179586 * 0.01, builtin, [], []).
step(15.915494309189533 is 1.0 / 0.06283185307179587, builtin, [], []).
