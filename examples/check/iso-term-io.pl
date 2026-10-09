condition('C1', resolution, ok, 4).
condition('C2', well_founded, ok, 20).
condition('C3', justification, ok, 20).
condition('C4', coverage, ok, 22).
condition('C5', re_decision, ok, 3).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 23).
obligation(builtin, stateful, open('/tmp/eyeprolog-iso-term-io-example.pl', read, '$stream'(1), [])).
obligation(builtin, stateful, read('$stream'(1), event(sensor_7, online))).
obligation(builtin, stateful, close('$stream'(1))).
obligation(builtin, stateful, open('/tmp/eyeprolog-iso-term-io-example.pl', read, '$stream'(2), [])).
obligation(builtin, stateful, read('$stream'(2), event(sensor_7, online))).
obligation(builtin, stateful, read_term('$stream'(2), rule(A, A, B), [variables([A, B]), variable_names(['_A' = A, '_B' = B]), singletons(['_B' = B])])).
obligation(builtin, stateful, close('$stream'(2))).
obligation(builtin, stateful, open('/tmp/eyeprolog-iso-term-io-example.pl', read, '$stream'(4), [eof_action(eof_code)])).
obligation(builtin, stateful, read('$stream'(4), event(sensor_7, online))).
obligation(builtin, stateful, read('$stream'(4), rule(A, A, B))).
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
