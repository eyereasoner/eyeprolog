% Prolog result format 4
query(1, captured_field(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(1, complete, 24).
answer(1, ['X0' = l1, 'X1' = ts, 'X2' = '2026-06-18T10:00:00Z']).
answer(1, ['X0' = l1, 'X1' = level, 'X2' = warn]).
answer(1, ['X0' = l1, 'X1' = event, 'X2' = login_failed]).
answer(1, ['X0' = l1, 'X1' = user, 'X2' = alice]).
answer(1, ['X0' = l1, 'X1' = ip, 'X2' = '203.0.113.9']).
answer(1, ['X0' = l1, 'X1' = trace_id, 'X2' = '4bf92f3577b34da6a3ce929d0e0e4736']).
answer(1, ['X0' = l1, 'X1' = span_id, 'X2' = '00f067aa0ba902b7']).
answer(1, ['X0' = l1, 'X1' = flags, 'X2' = '01']).
answer(1, ['X0' = l2, 'X1' = ts, 'X2' = '2026-06-18T10:00:03Z']).
answer(1, ['X0' = l2, 'X1' = level, 'X2' = error]).
answer(1, ['X0' = l2, 'X1' = event, 'X2' = payment_denied]).
answer(1, ['X0' = l2, 'X1' = user, 'X2' = alice]).
answer(1, ['X0' = l2, 'X1' = ip, 'X2' = '203.0.113.9']).
answer(1, ['X0' = l2, 'X1' = trace_id, 'X2' = '4bf92f3577b34da6a3ce929d0e0e4736']).
answer(1, ['X0' = l2, 'X1' = span_id, 'X2' = aaf067aa0ba90000]).
answer(1, ['X0' = l2, 'X1' = flags, 'X2' = '01']).
answer(1, ['X0' = l3, 'X1' = ts, 'X2' = '2026-06-18T10:01:12Z']).
answer(1, ['X0' = l3, 'X1' = level, 'X2' = info]).
answer(1, ['X0' = l3, 'X1' = event, 'X2' = login_success]).
answer(1, ['X0' = l3, 'X1' = user, 'X2' = bob]).
answer(1, ['X0' = l3, 'X1' = ip, 'X2' = '198.51.100.4']).
answer(1, ['X0' = l3, 'X1' = trace_id, 'X2' = aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa]).
answer(1, ['X0' = l3, 'X1' = span_id, 'X2' = bbbbbbbbbbbbbbbb]).
answer(1, ['X0' = l3, 'X1' = flags, 'X2' = '01']).
query(2,
      parsed_event(_0, _1, _2, _3, _4),
      ['X0' = _0, 'X1' = _1, 'X2' = _2, 'X3' = _3, 'X4' = _4]).
result(2, complete, 3).
answer(2,
       ['X0' = l1,
        'X1' = login_failed,
        'X2' = alice,
        'X3' = '203.0.113.9',
        'X4' = '4bf92f3577b34da6a3ce929d0e0e4736']).
answer(2,
       ['X0' = l2,
        'X1' = payment_denied,
        'X2' = alice,
        'X3' = '203.0.113.9',
        'X4' = '4bf92f3577b34da6a3ce929d0e0e4736']).
answer(2,
       ['X0' = l3,
        'X1' = login_success,
        'X2' = bob,
        'X3' = '198.51.100.4',
        'X4' = aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa]).
query(3, trace_alert(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(3, complete, 1).
answer(3, ['X0' = alice, 'X1' = '4bf92f3577b34da6a3ce929d0e0e4736', 'X2' = '203.0.113.9']).
