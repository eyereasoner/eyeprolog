report(shape, shape(event, 2)).
report(payload, reading(temperature, 21)).
report(parts, [event, sensor_7, reading(temperature, 21)]).
report(rebuilt, alert(sensor_7, high)).
report(variable_count, 3).
report(copied_shape, same_but_fresh).
report(order, <).

clause(1, sample(event(sensor_7, reading(temperature, 21))), true).
clause(2,
       report(shape, shape(var('Name'), var('Arity'))),
       (sample(var('Term')), functor(var('Term'), var('Name'), var('Arity')))).
clause(3,
       report(payload, var('Payload')),
       (sample(var('Term')), arg(2, var('Term'), var('Payload')))).
clause(4, report(parts, var('Parts')), (sample(var('Term')), var('Term') =.. var('Parts'))).
clause(5, report(rebuilt, var('Term')), var('Term') =.. [alert, sensor_7, high]).
clause(6,
       report(variable_count, var('Count')),
       (term_variables(rule(var('X'), pair(var('X'), anonymous(1)), anonymous(2)), var('Variables')),
        var('Variables') = [anonymous(3), anonymous(4), anonymous(5)],
        var('Count') = 3)).
clause(7,
       report(copied_shape, same_but_fresh),
       (copy_term(pair(var('X'), var('X')), pair(var('A'), var('B'))),
        var('A') == var('B'),
        var('X') \== var('A'))).
clause(8, report(order, var('Order')), compare(var('Order'), alpha, beta)).

step(report(shape, shape(event, 2)),
     rule(2),
     ['Name' = event, 'Arity' = 2, 'Term' = event(sensor_7, reading(temperature, 21))],
     [sample(event(sensor_7, reading(temperature, 21))),
      functor(event(sensor_7, reading(temperature, 21)), event, 2)]).
step(sample(event(sensor_7, reading(temperature, 21))), fact(1), [], []).
step(functor(event(sensor_7, reading(temperature, 21)), event, 2), builtin, [], []).
step(report(payload, reading(temperature, 21)),
     rule(3),
     ['Payload' = reading(temperature, 21), 'Term' = event(sensor_7, reading(temperature, 21))],
     [sample(event(sensor_7, reading(temperature, 21))),
      arg(2, event(sensor_7, reading(temperature, 21)), reading(temperature, 21))]).
step(arg(2, event(sensor_7, reading(temperature, 21)), reading(temperature, 21)),
     builtin,
     [],
     []).
step(report(parts, [event, sensor_7, reading(temperature, 21)]),
     rule(4),
     ['Parts' = [event, sensor_7, reading(temperature, 21)],
      'Term' = event(sensor_7, reading(temperature, 21))],
     [sample(event(sensor_7, reading(temperature, 21))),
      event(sensor_7, reading(temperature, 21)) =.. [event, sensor_7, reading(temperature, 21)]]).
step(event(sensor_7, reading(temperature, 21)) =.. [event, sensor_7, reading(temperature, 21)],
     builtin,
     [],
     []).
step(report(rebuilt, alert(sensor_7, high)),
     rule(5),
     ['Term' = alert(sensor_7, high)],
     [alert(sensor_7, high) =.. [alert, sensor_7, high]]).
step(alert(sensor_7, high) =.. [alert, sensor_7, high], builtin, [], []).
step(report(variable_count, 3),
     rule(6),
     ['Count' = 3, 'Variables' = [__anon0, __anon1, __anon2]],
     [term_variables(rule(__anon0, pair(__anon0, __anon1), __anon2), [__anon0, __anon1, __anon2]),
      [__anon0, __anon1, __anon2] = [__anon0, __anon1, __anon2],
      3 = 3]).
step(term_variables(rule(__anon0, pair(__anon0, __anon1), __anon2), [__anon0, __anon1, __anon2]),
     builtin,
     [],
     []).
step([__anon0, __anon1, __anon2] = [__anon0, __anon1, __anon2], builtin, [], []).
step(3 = 3, builtin, [], []).
step(report(copied_shape, same_but_fresh),
     rule(7),
     [],
     [copy_term(pair(X, X), pair(__copy1_0, __copy1_0)),
      __copy1_0 == __copy1_0,
      X \== __copy1_0]).
step(copy_term(pair(X, X), pair(__copy1_0, __copy1_0)), builtin, [], []).
step(__copy1_0 == __copy1_0, builtin, [], []).
step(X \== __copy1_0, builtin, [], []).
step(report(order, <), rule(8), ['Order' = (<)], [compare(<, alpha, beta)]).
step(compare(<, alpha, beta), builtin, [], []).
