report(first_term, event(sensor_7, online)).
report(variable_metadata, checked).
report(reached_end, yes).

clause(2, fixture_path('/tmp/eyeprolog-iso-term-io-example.pl'), true).
clause(4,
       report(first_term, var('Term')),
       (fixture_path(var('Path')),
        open(var('Path'), read, var('Stream'), []),
        read(var('Stream'), var('Term')),
        close(var('Stream')))).
clause(5,
       report(variable_metadata, checked),
       (fixture_path(var('Path')),
        open(var('Path'), read, var('Stream'), []),
        read(var('Stream'), anonymous(1)),
        read_term(var('Stream'), rule(var('A'), var('A'), var('B')), [variables([var('A'), var('B')]), variable_names([var('NameA') = var('A'), var('NameB') = var('B')]), singletons([var('NameB') = var('B')])]),
        atom(var('NameA')),
        atom(var('NameB')),
        var('NameA') \== var('NameB'),
        close(var('Stream')))).
clause(6,
       report(reached_end, yes),
       (fixture_path(var('Path')),
        open(var('Path'), read, var('Stream'), [eof_action(eof_code)]),
        read(var('Stream'), anonymous(1)),
        read(var('Stream'), anonymous(2)),
        read(var('Stream'), end_of_file),
        at_end_of_stream(var('Stream')),
        close(var('Stream')))).

step(report(first_term, event(sensor_7, online)),
     rule(4),
     ['Term' = event(sensor_7, online),
      'Path' = '/tmp/eyeprolog-iso-term-io-example.pl',
      'Stream' = '$stream'(1)],
     [fixture_path('/tmp/eyeprolog-iso-term-io-example.pl'),
      open('/tmp/eyeprolog-iso-term-io-example.pl', read, '$stream'(1), []),
      read('$stream'(1), event(sensor_7, online)),
      close('$stream'(1))]).
step(fixture_path('/tmp/eyeprolog-iso-term-io-example.pl'), fact(2), [], []).
step(open('/tmp/eyeprolog-iso-term-io-example.pl', read, '$stream'(1), []), builtin, [], []).
step(read('$stream'(1), event(sensor_7, online)), builtin, [], []).
step(close('$stream'(1)), builtin, [], []).
step(report(variable_metadata, checked),
     rule(5),
     ['Path' = '/tmp/eyeprolog-iso-term-io-example.pl',
      'Stream' = '$stream'(2),
      'NameA' = '_A',
      'NameB' = '_B'],
     [fixture_path('/tmp/eyeprolog-iso-term-io-example.pl'),
      open('/tmp/eyeprolog-iso-term-io-example.pl', read, '$stream'(2), []),
      read('$stream'(2), event(sensor_7, online)),
      read_term('$stream'(2), rule(_read_3_0, _read_3_0, _read_3_1), [variables([_read_3_0, _read_3_1]), variable_names(['_A' = _read_3_0, '_B' = _read_3_1]), singletons(['_B' = _read_3_1])]),
      atom('_A'),
      atom('_B'),
      '_A' \== '_B',
      close('$stream'(2))]).
step(open('/tmp/eyeprolog-iso-term-io-example.pl', read, '$stream'(2), []), builtin, [], []).
step(read('$stream'(2), event(sensor_7, online)), builtin, [], []).
step(read_term('$stream'(2), rule(_read_3_0, _read_3_0, _read_3_1), [variables([_read_3_0, _read_3_1]), variable_names(['_A' = _read_3_0, '_B' = _read_3_1]), singletons(['_B' = _read_3_1])]),
     builtin,
     [],
     []).
step(atom('_A'), builtin, [], []).
step(atom('_B'), builtin, [], []).
step('_A' \== '_B', builtin, [], []).
step(close('$stream'(2)), builtin, [], []).
step(report(reached_end, yes),
     rule(6),
     ['Path' = '/tmp/eyeprolog-iso-term-io-example.pl', 'Stream' = '$stream'(4)],
     [fixture_path('/tmp/eyeprolog-iso-term-io-example.pl'),
      open('/tmp/eyeprolog-iso-term-io-example.pl', read, '$stream'(4), [eof_action(eof_code)]),
      read('$stream'(4), event(sensor_7, online)),
      read('$stream'(4), rule(_read_5_0, _read_5_0, _read_5_1)),
      read('$stream'(4), end_of_file),
      at_end_of_stream('$stream'(4)),
      close('$stream'(4))]).
step(open('/tmp/eyeprolog-iso-term-io-example.pl', read, '$stream'(4), [eof_action(eof_code)]),
     builtin,
     [],
     []).
step(read('$stream'(4), event(sensor_7, online)), builtin, [], []).
step(read('$stream'(4), rule(_read_5_0, _read_5_0, _read_5_1)), builtin, [], []).
step(read('$stream'(4), end_of_file), builtin, [], []).
step(at_end_of_stream('$stream'(4)), builtin, [], []).
step(close('$stream'(4)), builtin, [], []).
