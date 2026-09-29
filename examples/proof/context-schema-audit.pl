context_shape(msg_ok, heartbeat, 0).
context_shape(msg_ok, source, 1).
context_shape(msg_ok, temperature, 2).
context_shape(msg_ok, gps, 3).
context_shape(msg_ok, signature, 4).
context_shape(msg_bad, heartbeat, 0).
context_shape(msg_bad, source, 1).
context_shape(msg_bad, temperature, 2).
context_shape(msg_bad, gps, 2).
context_shape(msg_bad, tampered, 1).
schema_violation(msg_bad, gps, 2).
schema_violation(msg_bad, tampered, 1).

clause(1,
       message_context(msg_ok, (heartbeat, source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z"))),
       true).
clause(2,
       message_context(msg_bad, (heartbeat, source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18))),
       true).
clause(8,
       context_member((var('Left'), anonymous(1)), var('Member')),
       context_member(var('Left'), var('Member'))).
clause(9,
       context_member((anonymous(1), var('Right')), var('Member')),
       context_member(var('Right'), var('Member'))).
clause(10,
       context_member(var('Member'), var('Member')),
       var('Member') \= (anonymous(1), anonymous(2))).
clause(11,
       context_shape(var('Message'), var('Name'), var('Arity')),
       (message_context(var('Message'), var('Context')),
        context_member(var('Context'), var('Statement')),
        var('Statement') =.. [var('Name') | var('Args')],
        length(var('Args'), var('Arity')))).
clause(12,
       schema_violation(var('Message'), var('Name'), var('Arity')),
       (context_shape(var('Message'), var('Name'), var('Arity')),
        \+ allowed_shape(var('Name'), var('Arity')))).

step(context_shape(msg_ok, heartbeat, 0),
     rule(11),
     ['Message' = msg_ok,
      'Name' = heartbeat,
      'Arity' = 0,
      'Context' = (heartbeat, source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")),
      'Statement' = heartbeat,
      'Args' = []],
     [message_context(msg_ok, (heartbeat, source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z"))),
      context_member((heartbeat, source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), heartbeat),
      heartbeat =.. [heartbeat],
      length([], 0)]).
step(message_context(msg_ok, (heartbeat, source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z"))),
     fact(1),
     [],
     []).
step(context_member((heartbeat, source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), heartbeat),
     rule(8),
     ['Left' = heartbeat, 'Member' = heartbeat],
     [context_member(heartbeat, heartbeat)]).
step(context_member(heartbeat, heartbeat),
     rule(10),
     ['Member' = heartbeat],
     [heartbeat \= (_left, _right)]).
step(heartbeat \= (_left, _right), builtin, [], []).
step(heartbeat =.. [heartbeat], builtin, [], []).
step(length([], 0), builtin, [], []).
step(context_shape(msg_ok, source, 1),
     rule(11),
     ['Message' = msg_ok,
      'Name' = source,
      'Arity' = 1,
      'Context' = (heartbeat, source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")),
      'Statement' = source(sensor17),
      'Args' = [sensor17]],
     [message_context(msg_ok, (heartbeat, source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z"))),
      context_member((heartbeat, source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), source(sensor17)),
      source(sensor17) =.. [source, sensor17],
      length([sensor17], 1)]).
step(context_member((heartbeat, source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), source(sensor17)),
     rule(9),
     ['Right' = (source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")),
      'Member' = source(sensor17)],
     [context_member((source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), source(sensor17))]).
step(context_member((source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), source(sensor17)),
     rule(8),
     ['Left' = source(sensor17), 'Member' = source(sensor17)],
     [context_member(source(sensor17), source(sensor17))]).
step(context_member(source(sensor17), source(sensor17)),
     rule(10),
     ['Member' = source(sensor17)],
     [source(sensor17) \= (_left, _right)]).
step(source(sensor17) \= (_left, _right), builtin, [], []).
step(source(sensor17) =.. [source, sensor17], builtin, [], []).
step(length([sensor17], 1), builtin, [], []).
step(context_shape(msg_ok, temperature, 2),
     rule(11),
     ['Message' = msg_ok,
      'Name' = temperature,
      'Arity' = 2,
      'Context' = (heartbeat, source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")),
      'Statement' = temperature(sensor17, 38),
      'Args' = [sensor17, 38]],
     [message_context(msg_ok, (heartbeat, source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z"))),
      context_member((heartbeat, source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), temperature(sensor17, 38)),
      temperature(sensor17, 38) =.. [temperature, sensor17, 38],
      length([sensor17, 38], 2)]).
step(context_member((heartbeat, source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), temperature(sensor17, 38)),
     rule(9),
     ['Right' = (source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")),
      'Member' = temperature(sensor17, 38)],
     [context_member((source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), temperature(sensor17, 38))]).
step(context_member((source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), temperature(sensor17, 38)),
     rule(9),
     ['Right' = (temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")),
      'Member' = temperature(sensor17, 38)],
     [context_member((temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), temperature(sensor17, 38))]).
step(context_member((temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), temperature(sensor17, 38)),
     rule(8),
     ['Left' = temperature(sensor17, 38), 'Member' = temperature(sensor17, 38)],
     [context_member(temperature(sensor17, 38), temperature(sensor17, 38))]).
step(context_member(temperature(sensor17, 38), temperature(sensor17, 38)),
     rule(10),
     ['Member' = temperature(sensor17, 38)],
     [temperature(sensor17, 38) \= (_left, _right)]).
step(temperature(sensor17, 38) \= (_left, _right), builtin, [], []).
step(temperature(sensor17, 38) =.. [temperature, sensor17, 38], builtin, [], []).
step(length([sensor17, 38], 2), builtin, [], []).
step(context_shape(msg_ok, gps, 3),
     rule(11),
     ['Message' = msg_ok,
      'Name' = gps,
      'Arity' = 3,
      'Context' = (heartbeat, source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")),
      'Statement' = gps(sensor17, 51, 4),
      'Args' = [sensor17, 51, 4]],
     [message_context(msg_ok, (heartbeat, source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z"))),
      context_member((heartbeat, source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), gps(sensor17, 51, 4)),
      gps(sensor17, 51, 4) =.. [gps, sensor17, 51, 4],
      length([sensor17, 51, 4], 3)]).
step(context_member((heartbeat, source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), gps(sensor17, 51, 4)),
     rule(9),
     ['Right' = (source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")),
      'Member' = gps(sensor17, 51, 4)],
     [context_member((source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), gps(sensor17, 51, 4))]).
step(context_member((source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), gps(sensor17, 51, 4)),
     rule(9),
     ['Right' = (temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")),
      'Member' = gps(sensor17, 51, 4)],
     [context_member((temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), gps(sensor17, 51, 4))]).
step(context_member((temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), gps(sensor17, 51, 4)),
     rule(9),
     ['Right' = (gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")),
      'Member' = gps(sensor17, 51, 4)],
     [context_member((gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), gps(sensor17, 51, 4))]).
step(context_member((gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), gps(sensor17, 51, 4)),
     rule(8),
     ['Left' = gps(sensor17, 51, 4), 'Member' = gps(sensor17, 51, 4)],
     [context_member(gps(sensor17, 51, 4), gps(sensor17, 51, 4))]).
step(context_member(gps(sensor17, 51, 4), gps(sensor17, 51, 4)),
     rule(10),
     ['Member' = gps(sensor17, 51, 4)],
     [gps(sensor17, 51, 4) \= (_left, _right)]).
step(gps(sensor17, 51, 4) \= (_left, _right), builtin, [], []).
step(gps(sensor17, 51, 4) =.. [gps, sensor17, 51, 4], builtin, [], []).
step(length([sensor17, 51, 4], 3), builtin, [], []).
step(context_shape(msg_ok, signature, 4),
     rule(11),
     ['Message' = msg_ok,
      'Name' = signature,
      'Arity' = 4,
      'Context' = (heartbeat, source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")),
      'Statement' = signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z"),
      'Args' = [sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z"]],
     [message_context(msg_ok, (heartbeat, source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z"))),
      context_member((heartbeat, source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")),
      signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z") =.. [signature, sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z"],
      length([sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z"], 4)]).
step(context_member((heartbeat, source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")),
     rule(9),
     ['Right' = (source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")),
      'Member' = signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")],
     [context_member((source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z"))]).
step(context_member((source(sensor17), temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")),
     rule(9),
     ['Right' = (temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")),
      'Member' = signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")],
     [context_member((temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z"))]).
step(context_member((temperature(sensor17, 38), gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")),
     rule(9),
     ['Right' = (gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")),
      'Member' = signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")],
     [context_member((gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z"))]).
step(context_member((gps(sensor17, 51, 4), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")),
     rule(9),
     ['Right' = signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z"),
      'Member' = signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")],
     [context_member(signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z"), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z"))]).
step(context_member(signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z"), signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")),
     rule(10),
     ['Member' = signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z")],
     [signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z") \= (_left, _right)]).
step(signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z") \= (_left, _right),
     builtin,
     [],
     []).
step(signature(sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z") =.. [signature, sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z"],
     builtin,
     [],
     []).
step(length([sensor17, sha256, "9f86d081", "2026-06-18T09:30:00Z"], 4), builtin, [], []).
step(context_shape(msg_bad, heartbeat, 0),
     rule(11),
     ['Message' = msg_bad,
      'Name' = heartbeat,
      'Arity' = 0,
      'Context' = (heartbeat, source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)),
      'Statement' = heartbeat,
      'Args' = []],
     [message_context(msg_bad, (heartbeat, source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18))),
      context_member((heartbeat, source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)), heartbeat),
      heartbeat =.. [heartbeat],
      length([], 0)]).
step(message_context(msg_bad, (heartbeat, source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18))),
     fact(2),
     [],
     []).
step(context_member((heartbeat, source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)), heartbeat),
     rule(8),
     ['Left' = heartbeat, 'Member' = heartbeat],
     [context_member(heartbeat, heartbeat)]).
step(context_shape(msg_bad, source, 1),
     rule(11),
     ['Message' = msg_bad,
      'Name' = source,
      'Arity' = 1,
      'Context' = (heartbeat, source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)),
      'Statement' = source(sensor18),
      'Args' = [sensor18]],
     [message_context(msg_bad, (heartbeat, source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18))),
      context_member((heartbeat, source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)), source(sensor18)),
      source(sensor18) =.. [source, sensor18],
      length([sensor18], 1)]).
step(context_member((heartbeat, source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)), source(sensor18)),
     rule(9),
     ['Right' = (source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)),
      'Member' = source(sensor18)],
     [context_member((source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)), source(sensor18))]).
step(context_member((source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)), source(sensor18)),
     rule(8),
     ['Left' = source(sensor18), 'Member' = source(sensor18)],
     [context_member(source(sensor18), source(sensor18))]).
step(context_member(source(sensor18), source(sensor18)),
     rule(10),
     ['Member' = source(sensor18)],
     [source(sensor18) \= (_left, _right)]).
step(source(sensor18) \= (_left, _right), builtin, [], []).
step(source(sensor18) =.. [source, sensor18], builtin, [], []).
step(length([sensor18], 1), builtin, [], []).
step(context_shape(msg_bad, temperature, 2),
     rule(11),
     ['Message' = msg_bad,
      'Name' = temperature,
      'Arity' = 2,
      'Context' = (heartbeat, source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)),
      'Statement' = temperature(sensor18, 99),
      'Args' = [sensor18, 99]],
     [message_context(msg_bad, (heartbeat, source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18))),
      context_member((heartbeat, source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)), temperature(sensor18, 99)),
      temperature(sensor18, 99) =.. [temperature, sensor18, 99],
      length([sensor18, 99], 2)]).
step(context_member((heartbeat, source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)), temperature(sensor18, 99)),
     rule(9),
     ['Right' = (source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)),
      'Member' = temperature(sensor18, 99)],
     [context_member((source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)), temperature(sensor18, 99))]).
step(context_member((source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)), temperature(sensor18, 99)),
     rule(9),
     ['Right' = (temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)),
      'Member' = temperature(sensor18, 99)],
     [context_member((temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)), temperature(sensor18, 99))]).
step(context_member((temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)), temperature(sensor18, 99)),
     rule(8),
     ['Left' = temperature(sensor18, 99), 'Member' = temperature(sensor18, 99)],
     [context_member(temperature(sensor18, 99), temperature(sensor18, 99))]).
step(context_member(temperature(sensor18, 99), temperature(sensor18, 99)),
     rule(10),
     ['Member' = temperature(sensor18, 99)],
     [temperature(sensor18, 99) \= (_left, _right)]).
step(temperature(sensor18, 99) \= (_left, _right), builtin, [], []).
step(temperature(sensor18, 99) =.. [temperature, sensor18, 99], builtin, [], []).
step(length([sensor18, 99], 2), builtin, [], []).
step(context_shape(msg_bad, gps, 2),
     rule(11),
     ['Message' = msg_bad,
      'Name' = gps,
      'Arity' = 2,
      'Context' = (heartbeat, source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)),
      'Statement' = gps(sensor18, 51),
      'Args' = [sensor18, 51]],
     [message_context(msg_bad, (heartbeat, source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18))),
      context_member((heartbeat, source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)), gps(sensor18, 51)),
      gps(sensor18, 51) =.. [gps, sensor18, 51],
      length([sensor18, 51], 2)]).
step(context_member((heartbeat, source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)), gps(sensor18, 51)),
     rule(9),
     ['Right' = (source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)),
      'Member' = gps(sensor18, 51)],
     [context_member((source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)), gps(sensor18, 51))]).
step(context_member((source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)), gps(sensor18, 51)),
     rule(9),
     ['Right' = (temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)),
      'Member' = gps(sensor18, 51)],
     [context_member((temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)), gps(sensor18, 51))]).
step(context_member((temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)), gps(sensor18, 51)),
     rule(9),
     ['Right' = (gps(sensor18, 51), tampered(sensor18)), 'Member' = gps(sensor18, 51)],
     [context_member((gps(sensor18, 51), tampered(sensor18)), gps(sensor18, 51))]).
step(context_member((gps(sensor18, 51), tampered(sensor18)), gps(sensor18, 51)),
     rule(8),
     ['Left' = gps(sensor18, 51), 'Member' = gps(sensor18, 51)],
     [context_member(gps(sensor18, 51), gps(sensor18, 51))]).
step(context_member(gps(sensor18, 51), gps(sensor18, 51)),
     rule(10),
     ['Member' = gps(sensor18, 51)],
     [gps(sensor18, 51) \= (_left, _right)]).
step(gps(sensor18, 51) \= (_left, _right), builtin, [], []).
step(gps(sensor18, 51) =.. [gps, sensor18, 51], builtin, [], []).
step(length([sensor18, 51], 2), builtin, [], []).
step(context_shape(msg_bad, tampered, 1),
     rule(11),
     ['Message' = msg_bad,
      'Name' = tampered,
      'Arity' = 1,
      'Context' = (heartbeat, source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)),
      'Statement' = tampered(sensor18),
      'Args' = [sensor18]],
     [message_context(msg_bad, (heartbeat, source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18))),
      context_member((heartbeat, source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)), tampered(sensor18)),
      tampered(sensor18) =.. [tampered, sensor18],
      length([sensor18], 1)]).
step(context_member((heartbeat, source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)), tampered(sensor18)),
     rule(9),
     ['Right' = (source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)),
      'Member' = tampered(sensor18)],
     [context_member((source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)), tampered(sensor18))]).
step(context_member((source(sensor18), temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)), tampered(sensor18)),
     rule(9),
     ['Right' = (temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)),
      'Member' = tampered(sensor18)],
     [context_member((temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)), tampered(sensor18))]).
step(context_member((temperature(sensor18, 99), gps(sensor18, 51), tampered(sensor18)), tampered(sensor18)),
     rule(9),
     ['Right' = (gps(sensor18, 51), tampered(sensor18)), 'Member' = tampered(sensor18)],
     [context_member((gps(sensor18, 51), tampered(sensor18)), tampered(sensor18))]).
step(context_member((gps(sensor18, 51), tampered(sensor18)), tampered(sensor18)),
     rule(9),
     ['Right' = tampered(sensor18), 'Member' = tampered(sensor18)],
     [context_member(tampered(sensor18), tampered(sensor18))]).
step(context_member(tampered(sensor18), tampered(sensor18)),
     rule(10),
     ['Member' = tampered(sensor18)],
     [tampered(sensor18) \= (_left, _right)]).
step(tampered(sensor18) \= (_left, _right), builtin, [], []).
step(tampered(sensor18) =.. [tampered, sensor18], builtin, [], []).
step(schema_violation(msg_bad, gps, 2),
     rule(12),
     ['Message' = msg_bad, 'Name' = gps, 'Arity' = 2],
     [context_shape(msg_bad, gps, 2), \+ allowed_shape(gps, 2)]).
step(\+ allowed_shape(gps, 2), absent, [], []).
step(schema_violation(msg_bad, tampered, 1),
     rule(12),
     ['Message' = msg_bad, 'Name' = tampered, 'Arity' = 1],
     [context_shape(msg_bad, tampered, 1), \+ allowed_shape(tampered, 1)]).
step(\+ allowed_shape(tampered, 1), absent, [], []).
