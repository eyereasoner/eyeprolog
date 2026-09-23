hitRate(api_cache, 0.86).
averageLatency_ms(api_cache, 15.5).
status(api_cache, cache_effective).
reason(api_cache, "hit rate is above target and average latency is below limit").

clause(1, cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0), true).
clause(2, threshold(api_cache, minimum_hit_rate, 0.8), true).
clause(3, threshold(api_cache, maximum_average_latency_ms, 20.0), true).
clause(4,
       total_requests(var('Cache'), var('Total')),
       (cache_sample(var('Cache'), var('Hits'), var('Misses'), anonymous(1), anonymous(2)),
        var('Total') is var('Hits') + var('Misses'))).
clause(5,
       hit_rate(var('Cache'), var('Rate')),
       (cache_sample(var('Cache'), var('Hits'), anonymous(1), anonymous(2), anonymous(3)),
        total_requests(var('Cache'), var('Total')),
        var('Rate') is var('Hits') / var('Total'))).
clause(6,
       average_latency(var('Cache'), var('Average')),
       (cache_sample(var('Cache'), var('Hits'), var('Misses'), var('Hitlatency'), var('Misslatency')),
        var('Hitcost') is var('Hits') * var('Hitlatency'),
        var('Misscost') is var('Misses') * var('Misslatency'),
        var('Totalcost') is var('Hitcost') + var('Misscost'),
        total_requests(var('Cache'), var('Total')),
        var('Average') is var('Totalcost') / var('Total'))).
clause(7,
       cache_effective(var('Cache')),
       (hit_rate(var('Cache'), var('Rate')),
        threshold(var('Cache'), minimum_hit_rate, var('Minimumrate')),
        var('Rate') > var('Minimumrate'),
        average_latency(var('Cache'), var('Average')),
        threshold(var('Cache'), maximum_average_latency_ms, var('Maximumlatency')),
        var('Average') < var('Maximumlatency'))).
clause(8, hitRate(var('Cache'), var('Rate')), hit_rate(var('Cache'), var('Rate'))).
clause(9,
       averageLatency_ms(var('Cache'), var('Average')),
       average_latency(var('Cache'), var('Average'))).
clause(10, status(var('Cache'), cache_effective), cache_effective(var('Cache'))).
clause(11,
       reason(var('Cache'), "hit rate is above target and average latency is below limit"),
       cache_effective(var('Cache'))).

step(hitRate(api_cache, 0.86),
     rule(8),
     ['Cache' = api_cache, 'Rate' = 0.86],
     [hit_rate(api_cache, 0.86)]).
step(hit_rate(api_cache, 0.86),
     rule(5),
     ['Cache' = api_cache, 'Rate' = 0.86, 'Hits' = 8600.0, 'Total' = 10000.0],
     [cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0),
      total_requests(api_cache, 10000.0),
      0.86 is 8600.0 / 10000.0]).
step(cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0), fact(1), [], []).
step(total_requests(api_cache, 10000.0),
     rule(4),
     ['Cache' = api_cache, 'Total' = 10000.0, 'Hits' = 8600.0, 'Misses' = 1400.0],
     [cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0), 10000.0 is 8600.0 + 1400.0]).
step(10000.0 is 8600.0 + 1400.0, builtin, [], []).
step(0.86 is 8600.0 / 10000.0, builtin, [], []).
step(averageLatency_ms(api_cache, 15.5),
     rule(9),
     ['Cache' = api_cache, 'Average' = 15.5],
     [average_latency(api_cache, 15.5)]).
step(average_latency(api_cache, 15.5),
     rule(6),
     ['Cache' = api_cache,
      'Average' = 15.5,
      'Hits' = 8600.0,
      'Misses' = 1400.0,
      'Hitlatency' = 5.0,
      'Misslatency' = 80.0,
      'Hitcost' = 43000.0,
      'Misscost' = 112000.0,
      'Totalcost' = 155000.0,
      'Total' = 10000.0],
     [cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0),
      43000.0 is 8600.0 * 5.0,
      112000.0 is 1400.0 * 80.0,
      155000.0 is 43000.0 + 112000.0,
      total_requests(api_cache, 10000.0),
      15.5 is 155000.0 / 10000.0]).
step(43000.0 is 8600.0 * 5.0, builtin, [], []).
step(112000.0 is 1400.0 * 80.0, builtin, [], []).
step(155000.0 is 43000.0 + 112000.0, builtin, [], []).
step(15.5 is 155000.0 / 10000.0, builtin, [], []).
step(status(api_cache, cache_effective),
     rule(10),
     ['Cache' = api_cache],
     [cache_effective(api_cache)]).
step(cache_effective(api_cache),
     rule(7),
     ['Cache' = api_cache,
      'Rate' = 0.86,
      'Minimumrate' = 0.8,
      'Average' = 15.5,
      'Maximumlatency' = 20.0],
     [hit_rate(api_cache, 0.86),
      threshold(api_cache, minimum_hit_rate, 0.8),
      0.86 > 0.8,
      average_latency(api_cache, 15.5),
      threshold(api_cache, maximum_average_latency_ms, 20.0),
      15.5 < 20.0]).
step(threshold(api_cache, minimum_hit_rate, 0.8), fact(2), [], []).
step(0.86 > 0.8, builtin, [], []).
step(threshold(api_cache, maximum_average_latency_ms, 20.0), fact(3), [], []).
step(15.5 < 20.0, builtin, [], []).
step(reason(api_cache, "hit rate is above target and average latency is below limit"),
     rule(11),
     ['Cache' = api_cache],
     [cache_effective(api_cache)]).
