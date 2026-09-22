hitRate(api_cache, 0.86).
why(
  hitRate(api_cache, 0.86),
  step(
    hitRate(api_cache, 0.86),
    rule("cache-performance.pl", clause(8)),
    ['Cache' = api_cache, 'Rate' = 0.86],
    [
      step(
        hit_rate(api_cache, 0.86),
        rule("cache-performance.pl", clause(5)),
        ['Cache' = api_cache, 'Rate' = 0.86, 'Hits' = 8600.0, '_misses' = 1400.0, '_hitlatency' = 5.0, '_misslatency' = 80.0, 'Total' = 10000.0],
        [
          step(cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0), fact("cache-performance.pl", clause(1)), [], []),
          step(
            total_requests(api_cache, 10000.0),
            rule("cache-performance.pl", clause(4)),
            ['Cache' = api_cache, 'Total' = 10000.0, 'Hits' = 8600.0, 'Misses' = 1400.0, '_hitlatency' = 5.0, '_misslatency' = 80.0],
            [
              step(cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0), fact("cache-performance.pl", clause(1)), [], []),
              step(is(10000.0, '+'(8600.0, 1400.0)), builtin(is, 2), [], [])
            ]
          ),
          step(is(0.86, /(8600.0, 10000.0)), builtin(is, 2), [], [])
        ]
      )
    ]
  )
).

averageLatency_ms(api_cache, 15.5).
why(
  averageLatency_ms(api_cache, 15.5),
  step(
    averageLatency_ms(api_cache, 15.5),
    rule("cache-performance.pl", clause(9)),
    ['Cache' = api_cache, 'Average' = 15.5],
    [
      step(
        average_latency(api_cache, 15.5),
        rule("cache-performance.pl", clause(6)),
        ['Cache' = api_cache, 'Average' = 15.5, 'Hits' = 8600.0, 'Misses' = 1400.0, 'Hitlatency' = 5.0, 'Misslatency' = 80.0, 'Hitcost' = 43000.0, 'Misscost' = 112000.0, 'Totalcost' = 155000.0, 'Total' = 10000.0],
        [
          step(cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0), fact("cache-performance.pl", clause(1)), [], []),
          step(is(43000.0, *(8600.0, 5.0)), builtin(is, 2), [], []),
          step(is(112000.0, *(1400.0, 80.0)), builtin(is, 2), [], []),
          step(is(155000.0, '+'(43000.0, 112000.0)), builtin(is, 2), [], []),
          step(
            total_requests(api_cache, 10000.0),
            rule("cache-performance.pl", clause(4)),
            ['Cache' = api_cache, 'Total' = 10000.0, 'Hits' = 8600.0, 'Misses' = 1400.0, '_hitlatency' = 5.0, '_misslatency' = 80.0],
            [
              step(cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0), fact("cache-performance.pl", clause(1)), [], []),
              step(is(10000.0, '+'(8600.0, 1400.0)), builtin(is, 2), [], [])
            ]
          ),
          step(is(15.5, /(155000.0, 10000.0)), builtin(is, 2), [], [])
        ]
      )
    ]
  )
).

status(api_cache, cache_effective).
why(
  status(api_cache, cache_effective),
  step(
    status(api_cache, cache_effective),
    rule("cache-performance.pl", clause(10)),
    ['Cache' = api_cache],
    [
      step(
        cache_effective(api_cache),
        rule("cache-performance.pl", clause(7)),
        ['Cache' = api_cache, 'Rate' = 0.86, 'Minimumrate' = 0.8, 'Average' = 15.5, 'Maximumlatency' = 20.0],
        [
          step(
            hit_rate(api_cache, 0.86),
            rule("cache-performance.pl", clause(5)),
            ['Cache' = api_cache, 'Rate' = 0.86, 'Hits' = 8600.0, '_misses' = 1400.0, '_hitlatency' = 5.0, '_misslatency' = 80.0, 'Total' = 10000.0],
            [
              step(cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0), fact("cache-performance.pl", clause(1)), [], []),
              step(
                total_requests(api_cache, 10000.0),
                rule("cache-performance.pl", clause(4)),
                ['Cache' = api_cache, 'Total' = 10000.0, 'Hits' = 8600.0, 'Misses' = 1400.0, '_hitlatency' = 5.0, '_misslatency' = 80.0],
                [
                  step(cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0), fact("cache-performance.pl", clause(1)), [], []),
                  step(is(10000.0, '+'(8600.0, 1400.0)), builtin(is, 2), [], [])
                ]
              ),
              step(is(0.86, /(8600.0, 10000.0)), builtin(is, 2), [], [])
            ]
          ),
          step(threshold(api_cache, minimum_hit_rate, 0.8), fact("cache-performance.pl", clause(2)), [], []),
          step(>(0.86, 0.8), builtin(>, 2), [], []),
          step(
            average_latency(api_cache, 15.5),
            rule("cache-performance.pl", clause(6)),
            ['Cache' = api_cache, 'Average' = 15.5, 'Hits' = 8600.0, 'Misses' = 1400.0, 'Hitlatency' = 5.0, 'Misslatency' = 80.0, 'Hitcost' = 43000.0, 'Misscost' = 112000.0, 'Totalcost' = 155000.0, 'Total' = 10000.0],
            [
              step(cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0), fact("cache-performance.pl", clause(1)), [], []),
              step(is(43000.0, *(8600.0, 5.0)), builtin(is, 2), [], []),
              step(is(112000.0, *(1400.0, 80.0)), builtin(is, 2), [], []),
              step(is(155000.0, '+'(43000.0, 112000.0)), builtin(is, 2), [], []),
              step(
                total_requests(api_cache, 10000.0),
                rule("cache-performance.pl", clause(4)),
                ['Cache' = api_cache, 'Total' = 10000.0, 'Hits' = 8600.0, 'Misses' = 1400.0, '_hitlatency' = 5.0, '_misslatency' = 80.0],
                [
                  step(cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0), fact("cache-performance.pl", clause(1)), [], []),
                  step(is(10000.0, '+'(8600.0, 1400.0)), builtin(is, 2), [], [])
                ]
              ),
              step(is(15.5, /(155000.0, 10000.0)), builtin(is, 2), [], [])
            ]
          ),
          step(threshold(api_cache, maximum_average_latency_ms, 20.0), fact("cache-performance.pl", clause(3)), [], []),
          step(<(15.5, 20.0), builtin(<, 2), [], [])
        ]
      )
    ]
  )
).

reason(api_cache, "hit rate is above target and average latency is below limit").
why(
  reason(api_cache, "hit rate is above target and average latency is below limit"),
  step(
    reason(api_cache, "hit rate is above target and average latency is below limit"),
    rule("cache-performance.pl", clause(11)),
    ['Cache' = api_cache],
    [
      step(
        cache_effective(api_cache),
        rule("cache-performance.pl", clause(7)),
        ['Cache' = api_cache, 'Rate' = 0.86, 'Minimumrate' = 0.8, 'Average' = 15.5, 'Maximumlatency' = 20.0],
        [
          step(
            hit_rate(api_cache, 0.86),
            rule("cache-performance.pl", clause(5)),
            ['Cache' = api_cache, 'Rate' = 0.86, 'Hits' = 8600.0, '_misses' = 1400.0, '_hitlatency' = 5.0, '_misslatency' = 80.0, 'Total' = 10000.0],
            [
              step(cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0), fact("cache-performance.pl", clause(1)), [], []),
              step(
                total_requests(api_cache, 10000.0),
                rule("cache-performance.pl", clause(4)),
                ['Cache' = api_cache, 'Total' = 10000.0, 'Hits' = 8600.0, 'Misses' = 1400.0, '_hitlatency' = 5.0, '_misslatency' = 80.0],
                [
                  step(cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0), fact("cache-performance.pl", clause(1)), [], []),
                  step(is(10000.0, '+'(8600.0, 1400.0)), builtin(is, 2), [], [])
                ]
              ),
              step(is(0.86, /(8600.0, 10000.0)), builtin(is, 2), [], [])
            ]
          ),
          step(threshold(api_cache, minimum_hit_rate, 0.8), fact("cache-performance.pl", clause(2)), [], []),
          step(>(0.86, 0.8), builtin(>, 2), [], []),
          step(
            average_latency(api_cache, 15.5),
            rule("cache-performance.pl", clause(6)),
            ['Cache' = api_cache, 'Average' = 15.5, 'Hits' = 8600.0, 'Misses' = 1400.0, 'Hitlatency' = 5.0, 'Misslatency' = 80.0, 'Hitcost' = 43000.0, 'Misscost' = 112000.0, 'Totalcost' = 155000.0, 'Total' = 10000.0],
            [
              step(cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0), fact("cache-performance.pl", clause(1)), [], []),
              step(is(43000.0, *(8600.0, 5.0)), builtin(is, 2), [], []),
              step(is(112000.0, *(1400.0, 80.0)), builtin(is, 2), [], []),
              step(is(155000.0, '+'(43000.0, 112000.0)), builtin(is, 2), [], []),
              step(
                total_requests(api_cache, 10000.0),
                rule("cache-performance.pl", clause(4)),
                ['Cache' = api_cache, 'Total' = 10000.0, 'Hits' = 8600.0, 'Misses' = 1400.0, '_hitlatency' = 5.0, '_misslatency' = 80.0],
                [
                  step(cache_sample(api_cache, 8600.0, 1400.0, 5.0, 80.0), fact("cache-performance.pl", clause(1)), [], []),
                  step(is(10000.0, '+'(8600.0, 1400.0)), builtin(is, 2), [], [])
                ]
              ),
              step(is(15.5, /(155000.0, 10000.0)), builtin(is, 2), [], [])
            ]
          ),
          step(threshold(api_cache, maximum_average_latency_ms, 20.0), fact("cache-performance.pl", clause(3)), [], []),
          step(<(15.5, 20.0), builtin(<, 2), [], [])
        ]
      )
    ]
  )
).

