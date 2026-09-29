captured_field(l1, ts, '2026-06-18T10:00:00Z').
captured_field(l1, level, warn).
captured_field(l1, event, login_failed).
captured_field(l1, user, alice).
captured_field(l1, ip, '203.0.113.9').
captured_field(l1, trace_id, '4bf92f3577b34da6a3ce929d0e0e4736').
captured_field(l1, span_id, '00f067aa0ba902b7').
captured_field(l1, flags, '01').
captured_field(l2, ts, '2026-06-18T10:00:03Z').
captured_field(l2, level, error).
captured_field(l2, event, payment_denied).
captured_field(l2, user, alice).
captured_field(l2, ip, '203.0.113.9').
captured_field(l2, trace_id, '4bf92f3577b34da6a3ce929d0e0e4736').
captured_field(l2, span_id, aaf067aa0ba90000).
captured_field(l2, flags, '01').
captured_field(l3, ts, '2026-06-18T10:01:12Z').
captured_field(l3, level, info).
captured_field(l3, event, login_success).
captured_field(l3, user, bob).
captured_field(l3, ip, '198.51.100.4').
captured_field(l3, trace_id, aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa).
captured_field(l3, span_id, bbbbbbbbbbbbbbbb).
captured_field(l3, flags, '01').
parsed_event(l1, login_failed, alice, '203.0.113.9', '4bf92f3577b34da6a3ce929d0e0e4736').
parsed_event(l2, payment_denied, alice, '203.0.113.9', '4bf92f3577b34da6a3ce929d0e0e4736').
parsed_event(l3, login_success, bob, '198.51.100.4', aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa).
trace_alert(alice, '4bf92f3577b34da6a3ce929d0e0e4736', '203.0.113.9').

clause(1,
       log_pattern('^ts=(?<ts>\\S+) level=(?<level>\\w+) event=(?<event>\\w+) user=(?<user>\\w+) ip=(?<ip>\\S+) traceparent=00-(?<trace_id>[0-9a-f]{32})-(?<span_id>[0-9a-f]{16})-(?<flags>[0-9a-f]{2})$'),
       true).
clause(6,
       parsed(var('Log'), var('Context')),
       (findall(raw(var('Log0'), var('Text')), raw_log(var('Log0'), var('Text')), var('Logs')),
        parsed_logs(var('Logs'), var('Log'), var('Context')))).
clause(7,
       parsed_logs([raw(var('Log'), var('Text')) | anonymous(1)], var('Log'), var('Context')),
       (log_pattern(var('Pattern')), matches(var('Text'), var('Pattern'), var('Context')))).
clause(8,
       parsed_logs([anonymous(1) | var('Logs')], var('Log'), var('Context')),
       parsed_logs(var('Logs'), var('Log'), var('Context'))).
clause(9,
       context_member((var('Left'), anonymous(1)), var('Member')),
       context_member(var('Left'), var('Member'))).
clause(10,
       context_member((anonymous(1), var('Right')), var('Member')),
       context_member(var('Right'), var('Member'))).
clause(11,
       context_member(var('Member'), var('Member')),
       var('Member') \= (anonymous(1), anonymous(2))).
clause(12,
       captured_field(var('Log'), var('Name'), var('Value')),
       (parsed(var('Log'), var('Context')),
        context_member(var('Context'), var('Field')),
        var('Field') =.. [var('Name'), var('Value')])).
clause(13,
       parsed_event(var('Log'), var('Event'), var('User'), var('Ip'), var('Traceid')),
       (parsed(var('Log'), var('Context')),
        context_member(var('Context'), event(var('Event'))),
        context_member(var('Context'), user(var('User'))),
        context_member(var('Context'), ip(var('Ip'))),
        context_member(var('Context'), trace_id(var('Traceid'))))).
clause(14,
       trace_alert(var('User'), var('Traceid'), var('Ip')),
       (parsed_event(var('Loginlog'), login_failed, var('User'), var('Ip'), var('Traceid')),
        parsed_event(var('Paymentlog'), payment_denied, var('User'), var('Ip'), var('Traceid')),
        var('Loginlog') \= var('Paymentlog'))).

step(captured_field(l1, ts, '2026-06-18T10:00:00Z'),
     rule(12),
     ['Log' = l1,
      'Name' = ts,
      'Value' = '2026-06-18T10:00:00Z',
      'Context' = (ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Field' = ts('2026-06-18T10:00:00Z')],
     [parsed(l1, (ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01'))),
      context_member((ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), ts('2026-06-18T10:00:00Z')),
      ts('2026-06-18T10:00:00Z') =.. [ts, '2026-06-18T10:00:00Z']]).
step(parsed(l1, (ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01'))),
     rule(6),
     ['Log' = l1,
      'Context' = (ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Logs' = [raw(l1, 'ts=2026-06-18T10:00:00Z level=warn event=login_failed user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01'), raw(l2, 'ts=2026-06-18T10:00:03Z level=error event=payment_denied user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-aaf067aa0ba90000-01'), raw(l3, 'ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01'), raw(noise, 'healthcheck ok')]],
     [findall(raw(Log0, Text), raw_log(Log0, Text), [raw(l1, 'ts=2026-06-18T10:00:00Z level=warn event=login_failed user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01'), raw(l2, 'ts=2026-06-18T10:00:03Z level=error event=payment_denied user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-aaf067aa0ba90000-01'), raw(l3, 'ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01'), raw(noise, 'healthcheck ok')]),
      parsed_logs([raw(l1, 'ts=2026-06-18T10:00:00Z level=warn event=login_failed user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01'), raw(l2, 'ts=2026-06-18T10:00:03Z level=error event=payment_denied user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-aaf067aa0ba90000-01'), raw(l3, 'ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01'), raw(noise, 'healthcheck ok')], l1, (ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')))]).
step(findall(raw(Log0, Text), raw_log(Log0, Text), [raw(l1, 'ts=2026-06-18T10:00:00Z level=warn event=login_failed user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01'), raw(l2, 'ts=2026-06-18T10:00:03Z level=error event=payment_denied user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-aaf067aa0ba90000-01'), raw(l3, 'ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01'), raw(noise, 'healthcheck ok')]),
     collected,
     [],
     []).
step(parsed_logs([raw(l1, 'ts=2026-06-18T10:00:00Z level=warn event=login_failed user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01'), raw(l2, 'ts=2026-06-18T10:00:03Z level=error event=payment_denied user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-aaf067aa0ba90000-01'), raw(l3, 'ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01'), raw(noise, 'healthcheck ok')], l1, (ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01'))),
     rule(7),
     ['Log' = l1,
      'Text' = 'ts=2026-06-18T10:00:00Z level=warn event=login_failed user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01',
      'Context' = (ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Pattern' = '^ts=(?<ts>\\S+) level=(?<level>\\w+) event=(?<event>\\w+) user=(?<user>\\w+) ip=(?<ip>\\S+) traceparent=00-(?<trace_id>[0-9a-f]{32})-(?<span_id>[0-9a-f]{16})-(?<flags>[0-9a-f]{2})$'],
     [log_pattern('^ts=(?<ts>\\S+) level=(?<level>\\w+) event=(?<event>\\w+) user=(?<user>\\w+) ip=(?<ip>\\S+) traceparent=00-(?<trace_id>[0-9a-f]{32})-(?<span_id>[0-9a-f]{16})-(?<flags>[0-9a-f]{2})$'),
      matches('ts=2026-06-18T10:00:00Z level=warn event=login_failed user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01', '^ts=(?<ts>\\S+) level=(?<level>\\w+) event=(?<event>\\w+) user=(?<user>\\w+) ip=(?<ip>\\S+) traceparent=00-(?<trace_id>[0-9a-f]{32})-(?<span_id>[0-9a-f]{16})-(?<flags>[0-9a-f]{2})$', (ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')))]).
step(log_pattern('^ts=(?<ts>\\S+) level=(?<level>\\w+) event=(?<event>\\w+) user=(?<user>\\w+) ip=(?<ip>\\S+) traceparent=00-(?<trace_id>[0-9a-f]{32})-(?<span_id>[0-9a-f]{16})-(?<flags>[0-9a-f]{2})$'),
     fact(1),
     [],
     []).
step(matches('ts=2026-06-18T10:00:00Z level=warn event=login_failed user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01', '^ts=(?<ts>\\S+) level=(?<level>\\w+) event=(?<event>\\w+) user=(?<user>\\w+) ip=(?<ip>\\S+) traceparent=00-(?<trace_id>[0-9a-f]{32})-(?<span_id>[0-9a-f]{16})-(?<flags>[0-9a-f]{2})$', (ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01'))),
     builtin,
     [],
     []).
step(context_member((ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), ts('2026-06-18T10:00:00Z')),
     rule(9),
     ['Left' = ts('2026-06-18T10:00:00Z'), 'Member' = ts('2026-06-18T10:00:00Z')],
     [context_member(ts('2026-06-18T10:00:00Z'), ts('2026-06-18T10:00:00Z'))]).
step(context_member(ts('2026-06-18T10:00:00Z'), ts('2026-06-18T10:00:00Z')),
     rule(11),
     ['Member' = ts('2026-06-18T10:00:00Z')],
     [ts('2026-06-18T10:00:00Z') \= (_left, _right)]).
step(ts('2026-06-18T10:00:00Z') \= (_left, _right), builtin, [], []).
step(ts('2026-06-18T10:00:00Z') =.. [ts, '2026-06-18T10:00:00Z'], builtin, [], []).
step(captured_field(l1, level, warn),
     rule(12),
     ['Log' = l1,
      'Name' = level,
      'Value' = warn,
      'Context' = (ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Field' = level(warn)],
     [parsed(l1, (ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01'))),
      context_member((ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), level(warn)),
      level(warn) =.. [level, warn]]).
step(context_member((ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), level(warn)),
     rule(10),
     ['Right' = (level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = level(warn)],
     [context_member((level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), level(warn))]).
step(context_member((level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), level(warn)),
     rule(9),
     ['Left' = level(warn), 'Member' = level(warn)],
     [context_member(level(warn), level(warn))]).
step(context_member(level(warn), level(warn)),
     rule(11),
     ['Member' = level(warn)],
     [level(warn) \= (_left, _right)]).
step(level(warn) \= (_left, _right), builtin, [], []).
step(level(warn) =.. [level, warn], builtin, [], []).
step(captured_field(l1, event, login_failed),
     rule(12),
     ['Log' = l1,
      'Name' = event,
      'Value' = login_failed,
      'Context' = (ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Field' = event(login_failed)],
     [parsed(l1, (ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01'))),
      context_member((ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), event(login_failed)),
      event(login_failed) =.. [event, login_failed]]).
step(context_member((ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), event(login_failed)),
     rule(10),
     ['Right' = (level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = event(login_failed)],
     [context_member((level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), event(login_failed))]).
step(context_member((level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), event(login_failed)),
     rule(10),
     ['Right' = (event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = event(login_failed)],
     [context_member((event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), event(login_failed))]).
step(context_member((event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), event(login_failed)),
     rule(9),
     ['Left' = event(login_failed), 'Member' = event(login_failed)],
     [context_member(event(login_failed), event(login_failed))]).
step(context_member(event(login_failed), event(login_failed)),
     rule(11),
     ['Member' = event(login_failed)],
     [event(login_failed) \= (_left, _right)]).
step(event(login_failed) \= (_left, _right), builtin, [], []).
step(event(login_failed) =.. [event, login_failed], builtin, [], []).
step(captured_field(l1, user, alice),
     rule(12),
     ['Log' = l1,
      'Name' = user,
      'Value' = alice,
      'Context' = (ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Field' = user(alice)],
     [parsed(l1, (ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01'))),
      context_member((ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), user(alice)),
      user(alice) =.. [user, alice]]).
step(context_member((ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), user(alice)),
     rule(10),
     ['Right' = (level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = user(alice)],
     [context_member((level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), user(alice))]).
step(context_member((level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), user(alice)),
     rule(10),
     ['Right' = (event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = user(alice)],
     [context_member((event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), user(alice))]).
step(context_member((event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), user(alice)),
     rule(10),
     ['Right' = (user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = user(alice)],
     [context_member((user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), user(alice))]).
step(context_member((user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), user(alice)),
     rule(9),
     ['Left' = user(alice), 'Member' = user(alice)],
     [context_member(user(alice), user(alice))]).
step(context_member(user(alice), user(alice)),
     rule(11),
     ['Member' = user(alice)],
     [user(alice) \= (_left, _right)]).
step(user(alice) \= (_left, _right), builtin, [], []).
step(user(alice) =.. [user, alice], builtin, [], []).
step(captured_field(l1, ip, '203.0.113.9'),
     rule(12),
     ['Log' = l1,
      'Name' = ip,
      'Value' = '203.0.113.9',
      'Context' = (ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Field' = ip('203.0.113.9')],
     [parsed(l1, (ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01'))),
      context_member((ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), ip('203.0.113.9')),
      ip('203.0.113.9') =.. [ip, '203.0.113.9']]).
step(context_member((ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), ip('203.0.113.9')),
     rule(10),
     ['Right' = (level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = ip('203.0.113.9')],
     [context_member((level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), ip('203.0.113.9'))]).
step(context_member((level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), ip('203.0.113.9')),
     rule(10),
     ['Right' = (event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = ip('203.0.113.9')],
     [context_member((event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), ip('203.0.113.9'))]).
step(context_member((event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), ip('203.0.113.9')),
     rule(10),
     ['Right' = (user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = ip('203.0.113.9')],
     [context_member((user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), ip('203.0.113.9'))]).
step(context_member((user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), ip('203.0.113.9')),
     rule(10),
     ['Right' = (ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = ip('203.0.113.9')],
     [context_member((ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), ip('203.0.113.9'))]).
step(context_member((ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), ip('203.0.113.9')),
     rule(9),
     ['Left' = ip('203.0.113.9'), 'Member' = ip('203.0.113.9')],
     [context_member(ip('203.0.113.9'), ip('203.0.113.9'))]).
step(context_member(ip('203.0.113.9'), ip('203.0.113.9')),
     rule(11),
     ['Member' = ip('203.0.113.9')],
     [ip('203.0.113.9') \= (_left, _right)]).
step(ip('203.0.113.9') \= (_left, _right), builtin, [], []).
step(ip('203.0.113.9') =.. [ip, '203.0.113.9'], builtin, [], []).
step(captured_field(l1, trace_id, '4bf92f3577b34da6a3ce929d0e0e4736'),
     rule(12),
     ['Log' = l1,
      'Name' = trace_id,
      'Value' = '4bf92f3577b34da6a3ce929d0e0e4736',
      'Context' = (ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Field' = trace_id('4bf92f3577b34da6a3ce929d0e0e4736')],
     [parsed(l1, (ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01'))),
      context_member((ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736')),
      trace_id('4bf92f3577b34da6a3ce929d0e0e4736') =.. [trace_id, '4bf92f3577b34da6a3ce929d0e0e4736']]).
step(context_member((ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736')),
     rule(10),
     ['Right' = (level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = trace_id('4bf92f3577b34da6a3ce929d0e0e4736')],
     [context_member((level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'))]).
step(context_member((level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736')),
     rule(10),
     ['Right' = (event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = trace_id('4bf92f3577b34da6a3ce929d0e0e4736')],
     [context_member((event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'))]).
step(context_member((event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736')),
     rule(10),
     ['Right' = (user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = trace_id('4bf92f3577b34da6a3ce929d0e0e4736')],
     [context_member((user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'))]).
step(context_member((user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736')),
     rule(10),
     ['Right' = (ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = trace_id('4bf92f3577b34da6a3ce929d0e0e4736')],
     [context_member((ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'))]).
step(context_member((ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736')),
     rule(10),
     ['Right' = (trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = trace_id('4bf92f3577b34da6a3ce929d0e0e4736')],
     [context_member((trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'))]).
step(context_member((trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736')),
     rule(9),
     ['Left' = trace_id('4bf92f3577b34da6a3ce929d0e0e4736'),
      'Member' = trace_id('4bf92f3577b34da6a3ce929d0e0e4736')],
     [context_member(trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'))]).
step(context_member(trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736')),
     rule(11),
     ['Member' = trace_id('4bf92f3577b34da6a3ce929d0e0e4736')],
     [trace_id('4bf92f3577b34da6a3ce929d0e0e4736') \= (_left, _right)]).
step(trace_id('4bf92f3577b34da6a3ce929d0e0e4736') \= (_left, _right), builtin, [], []).
step(trace_id('4bf92f3577b34da6a3ce929d0e0e4736') =.. [trace_id, '4bf92f3577b34da6a3ce929d0e0e4736'],
     builtin,
     [],
     []).
step(captured_field(l1, span_id, '00f067aa0ba902b7'),
     rule(12),
     ['Log' = l1,
      'Name' = span_id,
      'Value' = '00f067aa0ba902b7',
      'Context' = (ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Field' = span_id('00f067aa0ba902b7')],
     [parsed(l1, (ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01'))),
      context_member((ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), span_id('00f067aa0ba902b7')),
      span_id('00f067aa0ba902b7') =.. [span_id, '00f067aa0ba902b7']]).
step(context_member((ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), span_id('00f067aa0ba902b7')),
     rule(10),
     ['Right' = (level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = span_id('00f067aa0ba902b7')],
     [context_member((level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), span_id('00f067aa0ba902b7'))]).
step(context_member((level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), span_id('00f067aa0ba902b7')),
     rule(10),
     ['Right' = (event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = span_id('00f067aa0ba902b7')],
     [context_member((event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), span_id('00f067aa0ba902b7'))]).
step(context_member((event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), span_id('00f067aa0ba902b7')),
     rule(10),
     ['Right' = (user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = span_id('00f067aa0ba902b7')],
     [context_member((user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), span_id('00f067aa0ba902b7'))]).
step(context_member((user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), span_id('00f067aa0ba902b7')),
     rule(10),
     ['Right' = (ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = span_id('00f067aa0ba902b7')],
     [context_member((ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), span_id('00f067aa0ba902b7'))]).
step(context_member((ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), span_id('00f067aa0ba902b7')),
     rule(10),
     ['Right' = (trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = span_id('00f067aa0ba902b7')],
     [context_member((trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), span_id('00f067aa0ba902b7'))]).
step(context_member((trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), span_id('00f067aa0ba902b7')),
     rule(10),
     ['Right' = (span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = span_id('00f067aa0ba902b7')],
     [context_member((span_id('00f067aa0ba902b7'), flags('01')), span_id('00f067aa0ba902b7'))]).
step(context_member((span_id('00f067aa0ba902b7'), flags('01')), span_id('00f067aa0ba902b7')),
     rule(9),
     ['Left' = span_id('00f067aa0ba902b7'), 'Member' = span_id('00f067aa0ba902b7')],
     [context_member(span_id('00f067aa0ba902b7'), span_id('00f067aa0ba902b7'))]).
step(context_member(span_id('00f067aa0ba902b7'), span_id('00f067aa0ba902b7')),
     rule(11),
     ['Member' = span_id('00f067aa0ba902b7')],
     [span_id('00f067aa0ba902b7') \= (_left, _right)]).
step(span_id('00f067aa0ba902b7') \= (_left, _right), builtin, [], []).
step(span_id('00f067aa0ba902b7') =.. [span_id, '00f067aa0ba902b7'], builtin, [], []).
step(captured_field(l1, flags, '01'),
     rule(12),
     ['Log' = l1,
      'Name' = flags,
      'Value' = '01',
      'Context' = (ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Field' = flags('01')],
     [parsed(l1, (ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01'))),
      context_member((ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), flags('01')),
      flags('01') =.. [flags, '01']]).
step(context_member((ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), flags('01')),
     rule(10),
     ['Right' = (level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = flags('01')],
     [context_member((level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), flags('01'))]).
step(context_member((level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), flags('01')),
     rule(10),
     ['Right' = (event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = flags('01')],
     [context_member((event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), flags('01'))]).
step(context_member((event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), flags('01')),
     rule(10),
     ['Right' = (user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = flags('01')],
     [context_member((user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), flags('01'))]).
step(context_member((user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), flags('01')),
     rule(10),
     ['Right' = (ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = flags('01')],
     [context_member((ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), flags('01'))]).
step(context_member((ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), flags('01')),
     rule(10),
     ['Right' = (trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')),
      'Member' = flags('01')],
     [context_member((trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), flags('01'))]).
step(context_member((trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), flags('01')),
     rule(10),
     ['Right' = (span_id('00f067aa0ba902b7'), flags('01')), 'Member' = flags('01')],
     [context_member((span_id('00f067aa0ba902b7'), flags('01')), flags('01'))]).
step(context_member((span_id('00f067aa0ba902b7'), flags('01')), flags('01')),
     rule(10),
     ['Right' = flags('01'), 'Member' = flags('01')],
     [context_member(flags('01'), flags('01'))]).
step(context_member(flags('01'), flags('01')),
     rule(11),
     ['Member' = flags('01')],
     [flags('01') \= (_left, _right)]).
step(flags('01') \= (_left, _right), builtin, [], []).
step(flags('01') =.. [flags, '01'], builtin, [], []).
step(captured_field(l2, ts, '2026-06-18T10:00:03Z'),
     rule(12),
     ['Log' = l2,
      'Name' = ts,
      'Value' = '2026-06-18T10:00:03Z',
      'Context' = (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Field' = ts('2026-06-18T10:00:03Z')],
     [parsed(l2, (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01'))),
      context_member((ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), ts('2026-06-18T10:00:03Z')),
      ts('2026-06-18T10:00:03Z') =.. [ts, '2026-06-18T10:00:03Z']]).
step(parsed(l2, (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01'))),
     rule(6),
     ['Log' = l2,
      'Context' = (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Logs' = [raw(l1, 'ts=2026-06-18T10:00:00Z level=warn event=login_failed user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01'), raw(l2, 'ts=2026-06-18T10:00:03Z level=error event=payment_denied user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-aaf067aa0ba90000-01'), raw(l3, 'ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01'), raw(noise, 'healthcheck ok')]],
     [findall(raw(Log0, Text), raw_log(Log0, Text), [raw(l1, 'ts=2026-06-18T10:00:00Z level=warn event=login_failed user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01'), raw(l2, 'ts=2026-06-18T10:00:03Z level=error event=payment_denied user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-aaf067aa0ba90000-01'), raw(l3, 'ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01'), raw(noise, 'healthcheck ok')]),
      parsed_logs([raw(l1, 'ts=2026-06-18T10:00:00Z level=warn event=login_failed user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01'), raw(l2, 'ts=2026-06-18T10:00:03Z level=error event=payment_denied user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-aaf067aa0ba90000-01'), raw(l3, 'ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01'), raw(noise, 'healthcheck ok')], l2, (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')))]).
step(parsed_logs([raw(l1, 'ts=2026-06-18T10:00:00Z level=warn event=login_failed user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01'), raw(l2, 'ts=2026-06-18T10:00:03Z level=error event=payment_denied user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-aaf067aa0ba90000-01'), raw(l3, 'ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01'), raw(noise, 'healthcheck ok')], l2, (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01'))),
     rule(8),
     ['Logs' = [raw(l2, 'ts=2026-06-18T10:00:03Z level=error event=payment_denied user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-aaf067aa0ba90000-01'), raw(l3, 'ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01'), raw(noise, 'healthcheck ok')],
      'Log' = l2,
      'Context' = (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01'))],
     [parsed_logs([raw(l2, 'ts=2026-06-18T10:00:03Z level=error event=payment_denied user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-aaf067aa0ba90000-01'), raw(l3, 'ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01'), raw(noise, 'healthcheck ok')], l2, (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')))]).
step(parsed_logs([raw(l2, 'ts=2026-06-18T10:00:03Z level=error event=payment_denied user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-aaf067aa0ba90000-01'), raw(l3, 'ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01'), raw(noise, 'healthcheck ok')], l2, (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01'))),
     rule(7),
     ['Log' = l2,
      'Text' = 'ts=2026-06-18T10:00:03Z level=error event=payment_denied user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-aaf067aa0ba90000-01',
      'Context' = (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Pattern' = '^ts=(?<ts>\\S+) level=(?<level>\\w+) event=(?<event>\\w+) user=(?<user>\\w+) ip=(?<ip>\\S+) traceparent=00-(?<trace_id>[0-9a-f]{32})-(?<span_id>[0-9a-f]{16})-(?<flags>[0-9a-f]{2})$'],
     [log_pattern('^ts=(?<ts>\\S+) level=(?<level>\\w+) event=(?<event>\\w+) user=(?<user>\\w+) ip=(?<ip>\\S+) traceparent=00-(?<trace_id>[0-9a-f]{32})-(?<span_id>[0-9a-f]{16})-(?<flags>[0-9a-f]{2})$'),
      matches('ts=2026-06-18T10:00:03Z level=error event=payment_denied user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-aaf067aa0ba90000-01', '^ts=(?<ts>\\S+) level=(?<level>\\w+) event=(?<event>\\w+) user=(?<user>\\w+) ip=(?<ip>\\S+) traceparent=00-(?<trace_id>[0-9a-f]{32})-(?<span_id>[0-9a-f]{16})-(?<flags>[0-9a-f]{2})$', (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')))]).
step(matches('ts=2026-06-18T10:00:03Z level=error event=payment_denied user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-aaf067aa0ba90000-01', '^ts=(?<ts>\\S+) level=(?<level>\\w+) event=(?<event>\\w+) user=(?<user>\\w+) ip=(?<ip>\\S+) traceparent=00-(?<trace_id>[0-9a-f]{32})-(?<span_id>[0-9a-f]{16})-(?<flags>[0-9a-f]{2})$', (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01'))),
     builtin,
     [],
     []).
step(context_member((ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), ts('2026-06-18T10:00:03Z')),
     rule(9),
     ['Left' = ts('2026-06-18T10:00:03Z'), 'Member' = ts('2026-06-18T10:00:03Z')],
     [context_member(ts('2026-06-18T10:00:03Z'), ts('2026-06-18T10:00:03Z'))]).
step(context_member(ts('2026-06-18T10:00:03Z'), ts('2026-06-18T10:00:03Z')),
     rule(11),
     ['Member' = ts('2026-06-18T10:00:03Z')],
     [ts('2026-06-18T10:00:03Z') \= (_left, _right)]).
step(ts('2026-06-18T10:00:03Z') \= (_left, _right), builtin, [], []).
step(ts('2026-06-18T10:00:03Z') =.. [ts, '2026-06-18T10:00:03Z'], builtin, [], []).
step(captured_field(l2, level, error),
     rule(12),
     ['Log' = l2,
      'Name' = level,
      'Value' = error,
      'Context' = (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Field' = level(error)],
     [parsed(l2, (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01'))),
      context_member((ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), level(error)),
      level(error) =.. [level, error]]).
step(context_member((ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), level(error)),
     rule(10),
     ['Right' = (level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Member' = level(error)],
     [context_member((level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), level(error))]).
step(context_member((level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), level(error)),
     rule(9),
     ['Left' = level(error), 'Member' = level(error)],
     [context_member(level(error), level(error))]).
step(context_member(level(error), level(error)),
     rule(11),
     ['Member' = level(error)],
     [level(error) \= (_left, _right)]).
step(level(error) \= (_left, _right), builtin, [], []).
step(level(error) =.. [level, error], builtin, [], []).
step(captured_field(l2, event, payment_denied),
     rule(12),
     ['Log' = l2,
      'Name' = event,
      'Value' = payment_denied,
      'Context' = (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Field' = event(payment_denied)],
     [parsed(l2, (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01'))),
      context_member((ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), event(payment_denied)),
      event(payment_denied) =.. [event, payment_denied]]).
step(context_member((ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), event(payment_denied)),
     rule(10),
     ['Right' = (level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Member' = event(payment_denied)],
     [context_member((level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), event(payment_denied))]).
step(context_member((level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), event(payment_denied)),
     rule(10),
     ['Right' = (event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Member' = event(payment_denied)],
     [context_member((event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), event(payment_denied))]).
step(context_member((event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), event(payment_denied)),
     rule(9),
     ['Left' = event(payment_denied), 'Member' = event(payment_denied)],
     [context_member(event(payment_denied), event(payment_denied))]).
step(context_member(event(payment_denied), event(payment_denied)),
     rule(11),
     ['Member' = event(payment_denied)],
     [event(payment_denied) \= (_left, _right)]).
step(event(payment_denied) \= (_left, _right), builtin, [], []).
step(event(payment_denied) =.. [event, payment_denied], builtin, [], []).
step(captured_field(l2, user, alice),
     rule(12),
     ['Log' = l2,
      'Name' = user,
      'Value' = alice,
      'Context' = (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Field' = user(alice)],
     [parsed(l2, (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01'))),
      context_member((ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), user(alice)),
      user(alice) =.. [user, alice]]).
step(context_member((ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), user(alice)),
     rule(10),
     ['Right' = (level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Member' = user(alice)],
     [context_member((level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), user(alice))]).
step(context_member((level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), user(alice)),
     rule(10),
     ['Right' = (event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Member' = user(alice)],
     [context_member((event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), user(alice))]).
step(context_member((event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), user(alice)),
     rule(10),
     ['Right' = (user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Member' = user(alice)],
     [context_member((user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), user(alice))]).
step(context_member((user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), user(alice)),
     rule(9),
     ['Left' = user(alice), 'Member' = user(alice)],
     [context_member(user(alice), user(alice))]).
step(captured_field(l2, ip, '203.0.113.9'),
     rule(12),
     ['Log' = l2,
      'Name' = ip,
      'Value' = '203.0.113.9',
      'Context' = (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Field' = ip('203.0.113.9')],
     [parsed(l2, (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01'))),
      context_member((ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), ip('203.0.113.9')),
      ip('203.0.113.9') =.. [ip, '203.0.113.9']]).
step(context_member((ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), ip('203.0.113.9')),
     rule(10),
     ['Right' = (level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Member' = ip('203.0.113.9')],
     [context_member((level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), ip('203.0.113.9'))]).
step(context_member((level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), ip('203.0.113.9')),
     rule(10),
     ['Right' = (event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Member' = ip('203.0.113.9')],
     [context_member((event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), ip('203.0.113.9'))]).
step(context_member((event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), ip('203.0.113.9')),
     rule(10),
     ['Right' = (user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Member' = ip('203.0.113.9')],
     [context_member((user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), ip('203.0.113.9'))]).
step(context_member((user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), ip('203.0.113.9')),
     rule(10),
     ['Right' = (ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Member' = ip('203.0.113.9')],
     [context_member((ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), ip('203.0.113.9'))]).
step(context_member((ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), ip('203.0.113.9')),
     rule(9),
     ['Left' = ip('203.0.113.9'), 'Member' = ip('203.0.113.9')],
     [context_member(ip('203.0.113.9'), ip('203.0.113.9'))]).
step(captured_field(l2, trace_id, '4bf92f3577b34da6a3ce929d0e0e4736'),
     rule(12),
     ['Log' = l2,
      'Name' = trace_id,
      'Value' = '4bf92f3577b34da6a3ce929d0e0e4736',
      'Context' = (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Field' = trace_id('4bf92f3577b34da6a3ce929d0e0e4736')],
     [parsed(l2, (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01'))),
      context_member((ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736')),
      trace_id('4bf92f3577b34da6a3ce929d0e0e4736') =.. [trace_id, '4bf92f3577b34da6a3ce929d0e0e4736']]).
step(context_member((ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736')),
     rule(10),
     ['Right' = (level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Member' = trace_id('4bf92f3577b34da6a3ce929d0e0e4736')],
     [context_member((level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'))]).
step(context_member((level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736')),
     rule(10),
     ['Right' = (event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Member' = trace_id('4bf92f3577b34da6a3ce929d0e0e4736')],
     [context_member((event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'))]).
step(context_member((event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736')),
     rule(10),
     ['Right' = (user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Member' = trace_id('4bf92f3577b34da6a3ce929d0e0e4736')],
     [context_member((user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'))]).
step(context_member((user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736')),
     rule(10),
     ['Right' = (ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Member' = trace_id('4bf92f3577b34da6a3ce929d0e0e4736')],
     [context_member((ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'))]).
step(context_member((ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736')),
     rule(10),
     ['Right' = (trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Member' = trace_id('4bf92f3577b34da6a3ce929d0e0e4736')],
     [context_member((trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'))]).
step(context_member((trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736')),
     rule(9),
     ['Left' = trace_id('4bf92f3577b34da6a3ce929d0e0e4736'),
      'Member' = trace_id('4bf92f3577b34da6a3ce929d0e0e4736')],
     [context_member(trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'))]).
step(captured_field(l2, span_id, aaf067aa0ba90000),
     rule(12),
     ['Log' = l2,
      'Name' = span_id,
      'Value' = aaf067aa0ba90000,
      'Context' = (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Field' = span_id(aaf067aa0ba90000)],
     [parsed(l2, (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01'))),
      context_member((ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), span_id(aaf067aa0ba90000)),
      span_id(aaf067aa0ba90000) =.. [span_id, aaf067aa0ba90000]]).
step(context_member((ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), span_id(aaf067aa0ba90000)),
     rule(10),
     ['Right' = (level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Member' = span_id(aaf067aa0ba90000)],
     [context_member((level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), span_id(aaf067aa0ba90000))]).
step(context_member((level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), span_id(aaf067aa0ba90000)),
     rule(10),
     ['Right' = (event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Member' = span_id(aaf067aa0ba90000)],
     [context_member((event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), span_id(aaf067aa0ba90000))]).
step(context_member((event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), span_id(aaf067aa0ba90000)),
     rule(10),
     ['Right' = (user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Member' = span_id(aaf067aa0ba90000)],
     [context_member((user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), span_id(aaf067aa0ba90000))]).
step(context_member((user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), span_id(aaf067aa0ba90000)),
     rule(10),
     ['Right' = (ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Member' = span_id(aaf067aa0ba90000)],
     [context_member((ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), span_id(aaf067aa0ba90000))]).
step(context_member((ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), span_id(aaf067aa0ba90000)),
     rule(10),
     ['Right' = (trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Member' = span_id(aaf067aa0ba90000)],
     [context_member((trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), span_id(aaf067aa0ba90000))]).
step(context_member((trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), span_id(aaf067aa0ba90000)),
     rule(10),
     ['Right' = (span_id(aaf067aa0ba90000), flags('01')), 'Member' = span_id(aaf067aa0ba90000)],
     [context_member((span_id(aaf067aa0ba90000), flags('01')), span_id(aaf067aa0ba90000))]).
step(context_member((span_id(aaf067aa0ba90000), flags('01')), span_id(aaf067aa0ba90000)),
     rule(9),
     ['Left' = span_id(aaf067aa0ba90000), 'Member' = span_id(aaf067aa0ba90000)],
     [context_member(span_id(aaf067aa0ba90000), span_id(aaf067aa0ba90000))]).
step(context_member(span_id(aaf067aa0ba90000), span_id(aaf067aa0ba90000)),
     rule(11),
     ['Member' = span_id(aaf067aa0ba90000)],
     [span_id(aaf067aa0ba90000) \= (_left, _right)]).
step(span_id(aaf067aa0ba90000) \= (_left, _right), builtin, [], []).
step(span_id(aaf067aa0ba90000) =.. [span_id, aaf067aa0ba90000], builtin, [], []).
step(captured_field(l2, flags, '01'),
     rule(12),
     ['Log' = l2,
      'Name' = flags,
      'Value' = '01',
      'Context' = (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Field' = flags('01')],
     [parsed(l2, (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01'))),
      context_member((ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), flags('01')),
      flags('01') =.. [flags, '01']]).
step(context_member((ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), flags('01')),
     rule(10),
     ['Right' = (level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Member' = flags('01')],
     [context_member((level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), flags('01'))]).
step(context_member((level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), flags('01')),
     rule(10),
     ['Right' = (event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Member' = flags('01')],
     [context_member((event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), flags('01'))]).
step(context_member((event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), flags('01')),
     rule(10),
     ['Right' = (user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Member' = flags('01')],
     [context_member((user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), flags('01'))]).
step(context_member((user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), flags('01')),
     rule(10),
     ['Right' = (ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Member' = flags('01')],
     [context_member((ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), flags('01'))]).
step(context_member((ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), flags('01')),
     rule(10),
     ['Right' = (trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')),
      'Member' = flags('01')],
     [context_member((trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), flags('01'))]).
step(context_member((trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), flags('01')),
     rule(10),
     ['Right' = (span_id(aaf067aa0ba90000), flags('01')), 'Member' = flags('01')],
     [context_member((span_id(aaf067aa0ba90000), flags('01')), flags('01'))]).
step(context_member((span_id(aaf067aa0ba90000), flags('01')), flags('01')),
     rule(10),
     ['Right' = flags('01'), 'Member' = flags('01')],
     [context_member(flags('01'), flags('01'))]).
step(captured_field(l3, ts, '2026-06-18T10:01:12Z'),
     rule(12),
     ['Log' = l3,
      'Name' = ts,
      'Value' = '2026-06-18T10:01:12Z',
      'Context' = (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Field' = ts('2026-06-18T10:01:12Z')],
     [parsed(l3, (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01'))),
      context_member((ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), ts('2026-06-18T10:01:12Z')),
      ts('2026-06-18T10:01:12Z') =.. [ts, '2026-06-18T10:01:12Z']]).
step(parsed(l3, (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01'))),
     rule(6),
     ['Log' = l3,
      'Context' = (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Logs' = [raw(l1, 'ts=2026-06-18T10:00:00Z level=warn event=login_failed user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01'), raw(l2, 'ts=2026-06-18T10:00:03Z level=error event=payment_denied user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-aaf067aa0ba90000-01'), raw(l3, 'ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01'), raw(noise, 'healthcheck ok')]],
     [findall(raw(Log0, Text), raw_log(Log0, Text), [raw(l1, 'ts=2026-06-18T10:00:00Z level=warn event=login_failed user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01'), raw(l2, 'ts=2026-06-18T10:00:03Z level=error event=payment_denied user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-aaf067aa0ba90000-01'), raw(l3, 'ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01'), raw(noise, 'healthcheck ok')]),
      parsed_logs([raw(l1, 'ts=2026-06-18T10:00:00Z level=warn event=login_failed user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01'), raw(l2, 'ts=2026-06-18T10:00:03Z level=error event=payment_denied user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-aaf067aa0ba90000-01'), raw(l3, 'ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01'), raw(noise, 'healthcheck ok')], l3, (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')))]).
step(parsed_logs([raw(l1, 'ts=2026-06-18T10:00:00Z level=warn event=login_failed user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01'), raw(l2, 'ts=2026-06-18T10:00:03Z level=error event=payment_denied user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-aaf067aa0ba90000-01'), raw(l3, 'ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01'), raw(noise, 'healthcheck ok')], l3, (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01'))),
     rule(8),
     ['Logs' = [raw(l2, 'ts=2026-06-18T10:00:03Z level=error event=payment_denied user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-aaf067aa0ba90000-01'), raw(l3, 'ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01'), raw(noise, 'healthcheck ok')],
      'Log' = l3,
      'Context' = (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01'))],
     [parsed_logs([raw(l2, 'ts=2026-06-18T10:00:03Z level=error event=payment_denied user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-aaf067aa0ba90000-01'), raw(l3, 'ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01'), raw(noise, 'healthcheck ok')], l3, (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')))]).
step(parsed_logs([raw(l2, 'ts=2026-06-18T10:00:03Z level=error event=payment_denied user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-aaf067aa0ba90000-01'), raw(l3, 'ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01'), raw(noise, 'healthcheck ok')], l3, (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01'))),
     rule(8),
     ['Logs' = [raw(l3, 'ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01'), raw(noise, 'healthcheck ok')],
      'Log' = l3,
      'Context' = (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01'))],
     [parsed_logs([raw(l3, 'ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01'), raw(noise, 'healthcheck ok')], l3, (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')))]).
step(parsed_logs([raw(l3, 'ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01'), raw(noise, 'healthcheck ok')], l3, (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01'))),
     rule(7),
     ['Log' = l3,
      'Text' = 'ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01',
      'Context' = (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Pattern' = '^ts=(?<ts>\\S+) level=(?<level>\\w+) event=(?<event>\\w+) user=(?<user>\\w+) ip=(?<ip>\\S+) traceparent=00-(?<trace_id>[0-9a-f]{32})-(?<span_id>[0-9a-f]{16})-(?<flags>[0-9a-f]{2})$'],
     [log_pattern('^ts=(?<ts>\\S+) level=(?<level>\\w+) event=(?<event>\\w+) user=(?<user>\\w+) ip=(?<ip>\\S+) traceparent=00-(?<trace_id>[0-9a-f]{32})-(?<span_id>[0-9a-f]{16})-(?<flags>[0-9a-f]{2})$'),
      matches('ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01', '^ts=(?<ts>\\S+) level=(?<level>\\w+) event=(?<event>\\w+) user=(?<user>\\w+) ip=(?<ip>\\S+) traceparent=00-(?<trace_id>[0-9a-f]{32})-(?<span_id>[0-9a-f]{16})-(?<flags>[0-9a-f]{2})$', (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')))]).
step(matches('ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01', '^ts=(?<ts>\\S+) level=(?<level>\\w+) event=(?<event>\\w+) user=(?<user>\\w+) ip=(?<ip>\\S+) traceparent=00-(?<trace_id>[0-9a-f]{32})-(?<span_id>[0-9a-f]{16})-(?<flags>[0-9a-f]{2})$', (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01'))),
     builtin,
     [],
     []).
step(context_member((ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), ts('2026-06-18T10:01:12Z')),
     rule(9),
     ['Left' = ts('2026-06-18T10:01:12Z'), 'Member' = ts('2026-06-18T10:01:12Z')],
     [context_member(ts('2026-06-18T10:01:12Z'), ts('2026-06-18T10:01:12Z'))]).
step(context_member(ts('2026-06-18T10:01:12Z'), ts('2026-06-18T10:01:12Z')),
     rule(11),
     ['Member' = ts('2026-06-18T10:01:12Z')],
     [ts('2026-06-18T10:01:12Z') \= (_left, _right)]).
step(ts('2026-06-18T10:01:12Z') \= (_left, _right), builtin, [], []).
step(ts('2026-06-18T10:01:12Z') =.. [ts, '2026-06-18T10:01:12Z'], builtin, [], []).
step(captured_field(l3, level, info),
     rule(12),
     ['Log' = l3,
      'Name' = level,
      'Value' = info,
      'Context' = (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Field' = level(info)],
     [parsed(l3, (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01'))),
      context_member((ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), level(info)),
      level(info) =.. [level, info]]).
step(context_member((ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), level(info)),
     rule(10),
     ['Right' = (level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Member' = level(info)],
     [context_member((level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), level(info))]).
step(context_member((level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), level(info)),
     rule(9),
     ['Left' = level(info), 'Member' = level(info)],
     [context_member(level(info), level(info))]).
step(context_member(level(info), level(info)),
     rule(11),
     ['Member' = level(info)],
     [level(info) \= (_left, _right)]).
step(level(info) \= (_left, _right), builtin, [], []).
step(level(info) =.. [level, info], builtin, [], []).
step(captured_field(l3, event, login_success),
     rule(12),
     ['Log' = l3,
      'Name' = event,
      'Value' = login_success,
      'Context' = (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Field' = event(login_success)],
     [parsed(l3, (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01'))),
      context_member((ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), event(login_success)),
      event(login_success) =.. [event, login_success]]).
step(context_member((ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), event(login_success)),
     rule(10),
     ['Right' = (level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Member' = event(login_success)],
     [context_member((level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), event(login_success))]).
step(context_member((level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), event(login_success)),
     rule(10),
     ['Right' = (event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Member' = event(login_success)],
     [context_member((event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), event(login_success))]).
step(context_member((event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), event(login_success)),
     rule(9),
     ['Left' = event(login_success), 'Member' = event(login_success)],
     [context_member(event(login_success), event(login_success))]).
step(context_member(event(login_success), event(login_success)),
     rule(11),
     ['Member' = event(login_success)],
     [event(login_success) \= (_left, _right)]).
step(event(login_success) \= (_left, _right), builtin, [], []).
step(event(login_success) =.. [event, login_success], builtin, [], []).
step(captured_field(l3, user, bob),
     rule(12),
     ['Log' = l3,
      'Name' = user,
      'Value' = bob,
      'Context' = (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Field' = user(bob)],
     [parsed(l3, (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01'))),
      context_member((ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), user(bob)),
      user(bob) =.. [user, bob]]).
step(context_member((ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), user(bob)),
     rule(10),
     ['Right' = (level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Member' = user(bob)],
     [context_member((level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), user(bob))]).
step(context_member((level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), user(bob)),
     rule(10),
     ['Right' = (event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Member' = user(bob)],
     [context_member((event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), user(bob))]).
step(context_member((event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), user(bob)),
     rule(10),
     ['Right' = (user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Member' = user(bob)],
     [context_member((user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), user(bob))]).
step(context_member((user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), user(bob)),
     rule(9),
     ['Left' = user(bob), 'Member' = user(bob)],
     [context_member(user(bob), user(bob))]).
step(context_member(user(bob), user(bob)),
     rule(11),
     ['Member' = user(bob)],
     [user(bob) \= (_left, _right)]).
step(user(bob) \= (_left, _right), builtin, [], []).
step(user(bob) =.. [user, bob], builtin, [], []).
step(captured_field(l3, ip, '198.51.100.4'),
     rule(12),
     ['Log' = l3,
      'Name' = ip,
      'Value' = '198.51.100.4',
      'Context' = (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Field' = ip('198.51.100.4')],
     [parsed(l3, (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01'))),
      context_member((ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), ip('198.51.100.4')),
      ip('198.51.100.4') =.. [ip, '198.51.100.4']]).
step(context_member((ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), ip('198.51.100.4')),
     rule(10),
     ['Right' = (level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Member' = ip('198.51.100.4')],
     [context_member((level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), ip('198.51.100.4'))]).
step(context_member((level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), ip('198.51.100.4')),
     rule(10),
     ['Right' = (event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Member' = ip('198.51.100.4')],
     [context_member((event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), ip('198.51.100.4'))]).
step(context_member((event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), ip('198.51.100.4')),
     rule(10),
     ['Right' = (user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Member' = ip('198.51.100.4')],
     [context_member((user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), ip('198.51.100.4'))]).
step(context_member((user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), ip('198.51.100.4')),
     rule(10),
     ['Right' = (ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Member' = ip('198.51.100.4')],
     [context_member((ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), ip('198.51.100.4'))]).
step(context_member((ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), ip('198.51.100.4')),
     rule(9),
     ['Left' = ip('198.51.100.4'), 'Member' = ip('198.51.100.4')],
     [context_member(ip('198.51.100.4'), ip('198.51.100.4'))]).
step(context_member(ip('198.51.100.4'), ip('198.51.100.4')),
     rule(11),
     ['Member' = ip('198.51.100.4')],
     [ip('198.51.100.4') \= (_left, _right)]).
step(ip('198.51.100.4') \= (_left, _right), builtin, [], []).
step(ip('198.51.100.4') =.. [ip, '198.51.100.4'], builtin, [], []).
step(captured_field(l3, trace_id, aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa),
     rule(12),
     ['Log' = l3,
      'Name' = trace_id,
      'Value' = aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa,
      'Context' = (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Field' = trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa)],
     [parsed(l3, (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01'))),
      context_member((ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa)),
      trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa) =.. [trace_id, aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa]]).
step(context_member((ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa)),
     rule(10),
     ['Right' = (level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Member' = trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa)],
     [context_member((level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa))]).
step(context_member((level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa)),
     rule(10),
     ['Right' = (event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Member' = trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa)],
     [context_member((event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa))]).
step(context_member((event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa)),
     rule(10),
     ['Right' = (user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Member' = trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa)],
     [context_member((user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa))]).
step(context_member((user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa)),
     rule(10),
     ['Right' = (ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Member' = trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa)],
     [context_member((ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa))]).
step(context_member((ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa)),
     rule(10),
     ['Right' = (trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Member' = trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa)],
     [context_member((trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa))]).
step(context_member((trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa)),
     rule(9),
     ['Left' = trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa),
      'Member' = trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa)],
     [context_member(trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa))]).
step(context_member(trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa)),
     rule(11),
     ['Member' = trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa)],
     [trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa) \= (_left, _right)]).
step(trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa) \= (_left, _right), builtin, [], []).
step(trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa) =.. [trace_id, aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa],
     builtin,
     [],
     []).
step(captured_field(l3, span_id, bbbbbbbbbbbbbbbb),
     rule(12),
     ['Log' = l3,
      'Name' = span_id,
      'Value' = bbbbbbbbbbbbbbbb,
      'Context' = (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Field' = span_id(bbbbbbbbbbbbbbbb)],
     [parsed(l3, (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01'))),
      context_member((ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), span_id(bbbbbbbbbbbbbbbb)),
      span_id(bbbbbbbbbbbbbbbb) =.. [span_id, bbbbbbbbbbbbbbbb]]).
step(context_member((ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), span_id(bbbbbbbbbbbbbbbb)),
     rule(10),
     ['Right' = (level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Member' = span_id(bbbbbbbbbbbbbbbb)],
     [context_member((level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), span_id(bbbbbbbbbbbbbbbb))]).
step(context_member((level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), span_id(bbbbbbbbbbbbbbbb)),
     rule(10),
     ['Right' = (event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Member' = span_id(bbbbbbbbbbbbbbbb)],
     [context_member((event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), span_id(bbbbbbbbbbbbbbbb))]).
step(context_member((event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), span_id(bbbbbbbbbbbbbbbb)),
     rule(10),
     ['Right' = (user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Member' = span_id(bbbbbbbbbbbbbbbb)],
     [context_member((user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), span_id(bbbbbbbbbbbbbbbb))]).
step(context_member((user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), span_id(bbbbbbbbbbbbbbbb)),
     rule(10),
     ['Right' = (ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Member' = span_id(bbbbbbbbbbbbbbbb)],
     [context_member((ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), span_id(bbbbbbbbbbbbbbbb))]).
step(context_member((ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), span_id(bbbbbbbbbbbbbbbb)),
     rule(10),
     ['Right' = (trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Member' = span_id(bbbbbbbbbbbbbbbb)],
     [context_member((trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), span_id(bbbbbbbbbbbbbbbb))]).
step(context_member((trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), span_id(bbbbbbbbbbbbbbbb)),
     rule(10),
     ['Right' = (span_id(bbbbbbbbbbbbbbbb), flags('01')), 'Member' = span_id(bbbbbbbbbbbbbbbb)],
     [context_member((span_id(bbbbbbbbbbbbbbbb), flags('01')), span_id(bbbbbbbbbbbbbbbb))]).
step(context_member((span_id(bbbbbbbbbbbbbbbb), flags('01')), span_id(bbbbbbbbbbbbbbbb)),
     rule(9),
     ['Left' = span_id(bbbbbbbbbbbbbbbb), 'Member' = span_id(bbbbbbbbbbbbbbbb)],
     [context_member(span_id(bbbbbbbbbbbbbbbb), span_id(bbbbbbbbbbbbbbbb))]).
step(context_member(span_id(bbbbbbbbbbbbbbbb), span_id(bbbbbbbbbbbbbbbb)),
     rule(11),
     ['Member' = span_id(bbbbbbbbbbbbbbbb)],
     [span_id(bbbbbbbbbbbbbbbb) \= (_left, _right)]).
step(span_id(bbbbbbbbbbbbbbbb) \= (_left, _right), builtin, [], []).
step(span_id(bbbbbbbbbbbbbbbb) =.. [span_id, bbbbbbbbbbbbbbbb], builtin, [], []).
step(captured_field(l3, flags, '01'),
     rule(12),
     ['Log' = l3,
      'Name' = flags,
      'Value' = '01',
      'Context' = (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Field' = flags('01')],
     [parsed(l3, (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01'))),
      context_member((ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), flags('01')),
      flags('01') =.. [flags, '01']]).
step(context_member((ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), flags('01')),
     rule(10),
     ['Right' = (level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Member' = flags('01')],
     [context_member((level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), flags('01'))]).
step(context_member((level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), flags('01')),
     rule(10),
     ['Right' = (event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Member' = flags('01')],
     [context_member((event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), flags('01'))]).
step(context_member((event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), flags('01')),
     rule(10),
     ['Right' = (user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Member' = flags('01')],
     [context_member((user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), flags('01'))]).
step(context_member((user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), flags('01')),
     rule(10),
     ['Right' = (ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Member' = flags('01')],
     [context_member((ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), flags('01'))]).
step(context_member((ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), flags('01')),
     rule(10),
     ['Right' = (trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')),
      'Member' = flags('01')],
     [context_member((trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), flags('01'))]).
step(context_member((trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), flags('01')),
     rule(10),
     ['Right' = (span_id(bbbbbbbbbbbbbbbb), flags('01')), 'Member' = flags('01')],
     [context_member((span_id(bbbbbbbbbbbbbbbb), flags('01')), flags('01'))]).
step(context_member((span_id(bbbbbbbbbbbbbbbb), flags('01')), flags('01')),
     rule(10),
     ['Right' = flags('01'), 'Member' = flags('01')],
     [context_member(flags('01'), flags('01'))]).
step(parsed_event(l1, login_failed, alice, '203.0.113.9', '4bf92f3577b34da6a3ce929d0e0e4736'),
     rule(13),
     ['Log' = l1,
      'Event' = login_failed,
      'User' = alice,
      'Ip' = '203.0.113.9',
      'Traceid' = '4bf92f3577b34da6a3ce929d0e0e4736',
      'Context' = (ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01'))],
     [parsed(l1, (ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01'))),
      context_member((ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), event(login_failed)),
      context_member((ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), user(alice)),
      context_member((ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), ip('203.0.113.9')),
      context_member((ts('2026-06-18T10:00:00Z'), level(warn), event(login_failed), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id('00f067aa0ba902b7'), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'))]).
step(parsed_event(l2, payment_denied, alice, '203.0.113.9', '4bf92f3577b34da6a3ce929d0e0e4736'),
     rule(13),
     ['Log' = l2,
      'Event' = payment_denied,
      'User' = alice,
      'Ip' = '203.0.113.9',
      'Traceid' = '4bf92f3577b34da6a3ce929d0e0e4736',
      'Context' = (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01'))],
     [parsed(l2, (ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01'))),
      context_member((ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), event(payment_denied)),
      context_member((ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), user(alice)),
      context_member((ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), ip('203.0.113.9')),
      context_member((ts('2026-06-18T10:00:03Z'), level(error), event(payment_denied), user(alice), ip('203.0.113.9'), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'), span_id(aaf067aa0ba90000), flags('01')), trace_id('4bf92f3577b34da6a3ce929d0e0e4736'))]).
step(parsed_event(l3, login_success, bob, '198.51.100.4', aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa),
     rule(13),
     ['Log' = l3,
      'Event' = login_success,
      'User' = bob,
      'Ip' = '198.51.100.4',
      'Traceid' = aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa,
      'Context' = (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01'))],
     [parsed(l3, (ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01'))),
      context_member((ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), event(login_success)),
      context_member((ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), user(bob)),
      context_member((ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), ip('198.51.100.4')),
      context_member((ts('2026-06-18T10:01:12Z'), level(info), event(login_success), user(bob), ip('198.51.100.4'), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa), span_id(bbbbbbbbbbbbbbbb), flags('01')), trace_id(aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa))]).
step(trace_alert(alice, '4bf92f3577b34da6a3ce929d0e0e4736', '203.0.113.9'),
     rule(14),
     ['User' = alice,
      'Traceid' = '4bf92f3577b34da6a3ce929d0e0e4736',
      'Ip' = '203.0.113.9',
      'Loginlog' = l1,
      'Paymentlog' = l2],
     [parsed_event(l1, login_failed, alice, '203.0.113.9', '4bf92f3577b34da6a3ce929d0e0e4736'),
      parsed_event(l2, payment_denied, alice, '203.0.113.9', '4bf92f3577b34da6a3ce929d0e0e4736'),
      l1 \= l2]).
step(l1 \= l2, builtin, [], []).
