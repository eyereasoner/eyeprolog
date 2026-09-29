endToEndLatency_ms(edge_path, 47.0).
slaLimit_ms(edge_path, 50.0).
status(edge_path, sla_compliant).
reason(edge_path, "path latency including jitter is below the SLA limit").

clause(1, path(edge_path, [link_a, link_b, link_c]), true).
clause(2, link_latency(link_a, 12.0), true).
clause(3, link_latency(link_b, 18.0), true).
clause(4, link_latency(link_c, 9.0), true).
clause(5, jitter(edge_path, 8.0), true).
clause(6, sla(edge_path, maximum_latency_ms, 50.0), true).
clause(7, latency_sum([], 0.0), true).
clause(8,
       latency_sum([var('Link') | var('Links')], var('Total')),
       (link_latency(var('Link'), var('Linklatency')),
        latency_sum(var('Links'), var('Rest')),
        var('Total') is var('Linklatency') + var('Rest'))).
clause(9,
       end_to_end_latency(var('Path'), var('Latency')),
       (path(var('Path'), var('Links')),
        latency_sum(var('Links'), var('Linklatency')),
        jitter(var('Path'), var('Jitter')),
        var('Latency') is var('Linklatency') + var('Jitter'))).
clause(10,
       sla_compliant(var('Path')),
       (end_to_end_latency(var('Path'), var('Latency')),
        sla(var('Path'), maximum_latency_ms, var('Maximum')),
        var('Latency') < var('Maximum'))).
clause(11,
       endToEndLatency_ms(var('Path'), var('Latency')),
       end_to_end_latency(var('Path'), var('Latency'))).
clause(12,
       slaLimit_ms(var('Path'), var('Maximum')),
       sla(var('Path'), maximum_latency_ms, var('Maximum'))).
clause(13, status(var('Path'), sla_compliant), sla_compliant(var('Path'))).
clause(14,
       reason(var('Path'), "path latency including jitter is below the SLA limit"),
       sla_compliant(var('Path'))).

step(endToEndLatency_ms(edge_path, 47.0),
     rule(11),
     ['Path' = edge_path, 'Latency' = 47.0],
     [end_to_end_latency(edge_path, 47.0)]).
step(end_to_end_latency(edge_path, 47.0),
     rule(9),
     ['Path' = edge_path,
      'Latency' = 47.0,
      'Links' = [link_a, link_b, link_c],
      'Linklatency' = 39.0,
      'Jitter' = 8.0],
     [path(edge_path, [link_a, link_b, link_c]),
      latency_sum([link_a, link_b, link_c], 39.0),
      jitter(edge_path, 8.0),
      47.0 is 39.0 + 8.0]).
step(path(edge_path, [link_a, link_b, link_c]), fact(1), [], []).
step(latency_sum([link_a, link_b, link_c], 39.0),
     rule(8),
     ['Link' = link_a,
      'Links' = [link_b, link_c],
      'Total' = 39.0,
      'Linklatency' = 12.0,
      'Rest' = 27.0],
     [link_latency(link_a, 12.0), latency_sum([link_b, link_c], 27.0), 39.0 is 12.0 + 27.0]).
step(link_latency(link_a, 12.0), fact(2), [], []).
step(latency_sum([link_b, link_c], 27.0),
     rule(8),
     ['Link' = link_b, 'Links' = [link_c], 'Total' = 27.0, 'Linklatency' = 18.0, 'Rest' = 9.0],
     [link_latency(link_b, 18.0), latency_sum([link_c], 9.0), 27.0 is 18.0 + 9.0]).
step(link_latency(link_b, 18.0), fact(3), [], []).
step(latency_sum([link_c], 9.0),
     rule(8),
     ['Link' = link_c, 'Links' = [], 'Total' = 9.0, 'Linklatency' = 9.0, 'Rest' = 0.0],
     [link_latency(link_c, 9.0), latency_sum([], 0.0), 9.0 is 9.0 + 0.0]).
step(link_latency(link_c, 9.0), fact(4), [], []).
step(latency_sum([], 0.0), fact(7), [], []).
step(9.0 is 9.0 + 0.0, builtin, [], []).
step(27.0 is 18.0 + 9.0, builtin, [], []).
step(39.0 is 12.0 + 27.0, builtin, [], []).
step(jitter(edge_path, 8.0), fact(5), [], []).
step(47.0 is 39.0 + 8.0, builtin, [], []).
step(slaLimit_ms(edge_path, 50.0),
     rule(12),
     ['Path' = edge_path, 'Maximum' = 50.0],
     [sla(edge_path, maximum_latency_ms, 50.0)]).
step(sla(edge_path, maximum_latency_ms, 50.0), fact(6), [], []).
step(status(edge_path, sla_compliant),
     rule(13),
     ['Path' = edge_path],
     [sla_compliant(edge_path)]).
step(sla_compliant(edge_path),
     rule(10),
     ['Path' = edge_path, 'Latency' = 47.0, 'Maximum' = 50.0],
     [end_to_end_latency(edge_path, 47.0),
      sla(edge_path, maximum_latency_ms, 50.0),
      47.0 < 50.0]).
step(47.0 < 50.0, builtin, [], []).
step(reason(edge_path, "path latency including jitter is below the SLA limit"),
     rule(14),
     ['Path' = edge_path],
     [sla_compliant(edge_path)]).
