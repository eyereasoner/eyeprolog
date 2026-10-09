condition('C1', resolution, ok, 15005).
condition('C2', well_founded, ok, 35090).
condition('C3', justification, ok, 35090).
condition('C4', coverage, ok, 50013).
condition('C5', re_decision, ok, 20028).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 35091).
obligation(builtin, stateful, open('/tmp/eyeprolog-bulk-stream-write-example.txt', write, '$stream'(1), [type(text)])).
obligation(builtin, stateful, put_char('$stream'(1), i)).
obligation(builtin, stateful, put_char('$stream'(1), h)).
obligation(builtin, stateful, put_char('$stream'(1), g)).
obligation(builtin, stateful, put_char('$stream'(1), f)).
obligation(builtin, stateful, put_char('$stream'(1), e)).
obligation(builtin, stateful, put_char('$stream'(1), d)).
obligation(builtin, stateful, put_char('$stream'(1), c)).
obligation(builtin, stateful, put_char('$stream'(1), b)).
obligation(builtin, stateful, put_char('$stream'(1), a)).
obligation(builtin, stateful, put_char('$stream'(1), z)).
obligation(builtin, stateful, put_char('$stream'(1), y)).
obligation(builtin, stateful, put_char('$stream'(1), x)).
obligation(builtin, stateful, put_char('$stream'(1), w)).
obligation(builtin, stateful, put_char('$stream'(1), v)).
obligation(builtin, stateful, put_char('$stream'(1), u)).
obligation(builtin, stateful, put_char('$stream'(1), t)).
obligation(builtin, stateful, put_char('$stream'(1), s)).
obligation(builtin, stateful, put_char('$stream'(1), r)).
obligation(builtin, stateful, put_char('$stream'(1), q)).
obligation(builtin, stateful, put_char('$stream'(1), p)).
obligation(builtin, stateful, put_char('$stream'(1), o)).
obligation(builtin, stateful, put_char('$stream'(1), n)).
obligation(builtin, stateful, put_char('$stream'(1), m)).
obligation(builtin, stateful, put_char('$stream'(1), l)).
obligation(builtin, stateful, put_char('$stream'(1), k)).
obligation(builtin, stateful, put_char('$stream'(1), j)).
obligation(builtin, stateful, close('$stream'(1))).
obligation(builtin, stateful, open('/tmp/eyeprolog-bulk-stream-write-example.txt', read, '$stream'(2), [type(text)])).
obligation(builtin, stateful, get_char('$stream'(2), i)).
obligation(builtin, stateful, get_char('$stream'(2), h)).
obligation(builtin, stateful, get_char('$stream'(2), g)).
obligation(builtin, stateful, get_char('$stream'(2), f)).
obligation(builtin, stateful, get_char('$stream'(2), e)).
obligation(builtin, stateful, get_char('$stream'(2), d)).
obligation(builtin, stateful, get_char('$stream'(2), c)).
obligation(builtin, stateful, get_char('$stream'(2), b)).
obligation(builtin, stateful, get_char('$stream'(2), a)).
obligation(builtin, stateful, get_char('$stream'(2), z)).
obligation(builtin, stateful, get_char('$stream'(2), y)).
obligation(builtin, stateful, get_char('$stream'(2), x)).
obligation(builtin, stateful, get_char('$stream'(2), w)).
obligation(builtin, stateful, get_char('$stream'(2), v)).
obligation(builtin, stateful, get_char('$stream'(2), u)).
obligation(builtin, stateful, get_char('$stream'(2), t)).
obligation(builtin, stateful, get_char('$stream'(2), s)).
obligation(builtin, stateful, get_char('$stream'(2), r)).
obligation(builtin, stateful, get_char('$stream'(2), q)).
obligation(builtin, stateful, get_char('$stream'(2), p)).
obligation(builtin, stateful, get_char('$stream'(2), o)).
obligation(builtin, stateful, get_char('$stream'(2), n)).
obligation(builtin, stateful, get_char('$stream'(2), m)).
obligation(builtin, stateful, get_char('$stream'(2), l)).
obligation(builtin, stateful, get_char('$stream'(2), k)).
obligation(builtin, stateful, get_char('$stream'(2), j)).
obligation(builtin, stateful, get_char('$stream'(2), end_of_file)).
obligation(builtin, stateful, close('$stream'(2))).
steps(35090).
verified(15005).
recomputed(20028).
composed(0).
trusted(57).
claims(1).
verdict(checked_with_obligations).
