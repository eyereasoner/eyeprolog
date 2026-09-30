condition('C1', resolution, ok, 4).
condition('C2', well_founded, ok, 20).
condition('C3', justification, ok, 20).
condition('C4', coverage, ok, 22).
condition('C5', re_decision, ok, 3).
obligation(builtin, stateful, open('/tmp/eyeprolog-iso-term-io-example.pl', read, '$stream'(1), [])).
obligation(builtin, stateful, read('$stream'(1), event(sensor_7, online))).
obligation(builtin, stateful, close('$stream'(1))).
obligation(builtin, stateful, open('/tmp/eyeprolog-iso-term-io-example.pl', read, '$stream'(2), [])).
obligation(builtin, stateful, read('$stream'(2), event(sensor_7, online))).
obligation(builtin, stateful, read_term('$stream'(2), rule(_read_3_0, _read_3_0, _read_3_1), [variables([_read_3_0, _read_3_1]), variable_names(['_A' = _read_3_0, '_B' = _read_3_1]), singletons(['_B' = _read_3_1])])).
obligation(builtin, stateful, close('$stream'(2))).
obligation(builtin, stateful, open('/tmp/eyeprolog-iso-term-io-example.pl', read, '$stream'(4), [eof_action(eof_code)])).
obligation(builtin, stateful, read('$stream'(4), event(sensor_7, online))).
obligation(builtin, stateful, read('$stream'(4), rule(_read_5_0, _read_5_0, _read_5_1))).
obligation(builtin, stateful, read('$stream'(4), end_of_file)).
obligation(builtin, stateful, at_end_of_stream('$stream'(4))).
obligation(builtin, stateful, close('$stream'(4))).
steps(20).
verified(4).
recomputed(3).
composed(0).
trusted(13).
claims(3).
verdict(checked_with_obligations).
