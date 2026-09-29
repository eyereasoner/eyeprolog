period_s(pendulum1, 2.0).
periodError_s(pendulum1, 0.0).
status(pendulum1, within_period_tolerance).
reason(pendulum1, "small-angle period matches the two-second target").

clause(1, constant(pi, 3.141592653589793), true).
clause(2, experiment(pendulum1, length_m, 1.0), true).
clause(3, experiment(pendulum1, gravity_m_s2, 9.869604401089358), true).
clause(4, limit(pendulum1, target_period_s, 2.0), true).
clause(5, limit(pendulum1, tolerance_s, 0.01), true).
clause(6,
       period(var('Experiment'), var('Period')),
       (experiment(var('Experiment'), length_m, var('Length')),
        experiment(var('Experiment'), gravity_m_s2, var('Gravity')),
        var('Ratio') is var('Length') / var('Gravity'),
        var('Root') is var('Ratio') ** 0.5,
        constant(pi, var('Pi')),
        var('Twopi') is 2.0 * var('Pi'),
        var('Period') is var('Twopi') * var('Root'))).
clause(7,
       period_error(var('Experiment'), var('Error')),
       (period(var('Experiment'), var('Period')),
        limit(var('Experiment'), target_period_s, var('Target')),
        var('Rawerror') is var('Period') - var('Target'),
        var('Error') is abs(var('Rawerror')))).
clause(8,
       within_period_tolerance(var('Experiment')),
       (period_error(var('Experiment'), var('Error')),
        limit(var('Experiment'), tolerance_s, var('Tolerance')),
        var('Error') < var('Tolerance'))).
clause(9, period_s(var('Experiment'), var('Period')), period(var('Experiment'), var('Period'))).
clause(10,
       periodError_s(var('Experiment'), var('Error')),
       period_error(var('Experiment'), var('Error'))).
clause(11,
       status(var('Experiment'), within_period_tolerance),
       within_period_tolerance(var('Experiment'))).
clause(12,
       reason(var('Experiment'), "small-angle period matches the two-second target"),
       within_period_tolerance(var('Experiment'))).

step(period_s(pendulum1, 2.0),
     rule(9),
     ['Experiment' = pendulum1, 'Period' = 2.0],
     [period(pendulum1, 2.0)]).
step(period(pendulum1, 2.0),
     rule(6),
     ['Experiment' = pendulum1,
      'Period' = 2.0,
      'Length' = 1.0,
      'Gravity' = 9.869604401089358,
      'Ratio' = 0.10132118364233778,
      'Root' = 0.3183098861837907,
      'Pi' = 3.141592653589793,
      'Twopi' = 6.283185307179586],
     [experiment(pendulum1, length_m, 1.0),
      experiment(pendulum1, gravity_m_s2, 9.869604401089358),
      0.10132118364233778 is 1.0 / 9.869604401089358,
      0.3183098861837907 is 0.10132118364233778 ** 0.5,
      constant(pi, 3.141592653589793),
      6.283185307179586 is 2.0 * 3.141592653589793,
      2.0 is 6.283185307179586 * 0.3183098861837907]).
step(experiment(pendulum1, length_m, 1.0), fact(2), [], []).
step(experiment(pendulum1, gravity_m_s2, 9.869604401089358), fact(3), [], []).
step(0.10132118364233778 is 1.0 / 9.869604401089358, builtin, [], []).
step(0.3183098861837907 is 0.10132118364233778 ** 0.5, builtin, [], []).
step(constant(pi, 3.141592653589793), fact(1), [], []).
step(6.283185307179586 is 2.0 * 3.141592653589793, builtin, [], []).
step(2.0 is 6.283185307179586 * 0.3183098861837907, builtin, [], []).
step(periodError_s(pendulum1, 0.0),
     rule(10),
     ['Experiment' = pendulum1, 'Error' = 0.0],
     [period_error(pendulum1, 0.0)]).
step(period_error(pendulum1, 0.0),
     rule(7),
     ['Experiment' = pendulum1, 'Error' = 0.0, 'Period' = 2.0, 'Target' = 2.0, 'Rawerror' = 0.0],
     [period(pendulum1, 2.0),
      limit(pendulum1, target_period_s, 2.0),
      0.0 is 2.0 - 2.0,
      0.0 is abs(0.0)]).
step(limit(pendulum1, target_period_s, 2.0), fact(4), [], []).
step(0.0 is 2.0 - 2.0, builtin, [], []).
step(0.0 is abs(0.0), builtin, [], []).
step(status(pendulum1, within_period_tolerance),
     rule(11),
     ['Experiment' = pendulum1],
     [within_period_tolerance(pendulum1)]).
step(within_period_tolerance(pendulum1),
     rule(8),
     ['Experiment' = pendulum1, 'Error' = 0.0, 'Tolerance' = 0.01],
     [period_error(pendulum1, 0.0), limit(pendulum1, tolerance_s, 0.01), 0.0 < 0.01]).
step(limit(pendulum1, tolerance_s, 0.01), fact(5), [], []).
step(0.0 < 0.01, builtin, [], []).
step(reason(pendulum1, "small-angle period matches the two-second target"),
     rule(12),
     ['Experiment' = pendulum1],
     [within_period_tolerance(pendulum1)]).
