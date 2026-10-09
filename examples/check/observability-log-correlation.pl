condition('C1', resolution, ok, 162).
condition('C2', well_founded, ok, 205).
condition('C3', justification, ok, 205).
condition('C4', coverage, ok, 257).
condition('C5', re_decision, ok, 42).
condition('C6', boundary_consistency, ok, 1).
condition('C7', relevance, ok, 233).
obligation(collected, theory_scoped, findall(raw(A, B), raw_log(A, B), [raw(l1, 'ts=2026-06-18T10:00:00Z level=warn event=login_failed user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-00f067aa0ba902b7-01'), raw(l2, 'ts=2026-06-18T10:00:03Z level=error event=payment_denied user=alice ip=203.0.113.9 traceparent=00-4bf92f3577b34da6a3ce929d0e0e4736-aaf067aa0ba90000-01'), raw(l3, 'ts=2026-06-18T10:01:12Z level=info event=login_success user=bob ip=198.51.100.4 traceparent=00-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-bbbbbbbbbbbbbbbb-01'), raw(noise, 'healthcheck ok')])).
steps(205).
verified(162).
recomputed(42).
composed(0).
trusted(1).
claims(28).
verdict(checked_with_obligations).
