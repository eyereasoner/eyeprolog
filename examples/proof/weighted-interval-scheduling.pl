weighted_interval_answer(best_value, 13).
why(
  weighted_interval_answer(best_value, 13),
  step(
    weighted_interval_answer(best_value, 13),
    rule("weighted-interval-scheduling.pl", clause(19)),
    ['Best' = 13],
    [
      step(
        best_from(1, 13),
        rule("weighted-interval-scheduling.pl", clause(15)),
        ['I' = 1, 'Best' = 13, 'Last' = 8, 'Next' = 2, 'Skip' = 12, 'Compatible' = 4, 'Tail' = 8, '_start' = 1, '_finish' = 4, 'Value' = 5, 'Take' = 13],
        [
          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
          step(=<(1, 8), builtin(=<, 2), [], []),
          step(is(2, '+'(1, 1)), builtin(is, 2), [], []),
          step(
            best_from(2, 12),
            rule("weighted-interval-scheduling.pl", clause(15)),
            ['I' = 2, 'Best' = 12, 'Last' = 8, 'Next' = 3, 'Skip' = 12, 'Compatible' = 6, 'Tail' = 4, '_start' = 3, '_finish' = 5, 'Value' = 1, 'Take' = 5],
            [
              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
              step(=<(2, 8), builtin(=<, 2), [], []),
              step(is(3, '+'(2, 1)), builtin(is, 2), [], []),
              step(
                best_from(3, 12),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 3, 'Best' = 12, 'Last' = 8, 'Next' = 4, 'Skip' = 8, 'Compatible' = 7, 'Tail' = 4, '_start' = 0, '_finish' = 6, 'Value' = 8, 'Take' = 12],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(3, 8), builtin(=<, 2), [], []),
                  step(is(4, '+'(3, 1)), builtin(is, 2), [], []),
                  step(
                    best_from(4, 8),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 4, 'Best' = 8, 'Last' = 8, 'Next' = 5, 'Skip' = 6, 'Compatible' = 8, 'Tail' = 4, '_start' = 4, '_finish' = 7, 'Value' = 4, 'Take' = 8],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(4, 8), builtin(=<, 2), [], []),
                      step(is(5, '+'(4, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(5, 6),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 5, 'Best' = 6, 'Last' = 8, 'Next' = 6, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 3, '_finish' = 9, 'Value' = 6, 'Take' = 6],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(5, 8), builtin(=<, 2), [], []),
                          step(is(6, '+'(5, 1)), builtin(is, 2), [], []),
                          step(
                            best_from(6, 4),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 6, 'Best' = 4, 'Last' = 8, 'Next' = 7, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 5, '_finish' = 9, 'Value' = 3, 'Take' = 3],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(6, 8), builtin(=<, 2), [], []),
                              step(is(7, '+'(6, 1)), builtin(is, 2), [], []),
                              step(
                                best_from(7, 4),
                                rule("weighted-interval-scheduling.pl", clause(15)),
                                ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                                [
                                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                                  step(=<(7, 8), builtin(=<, 2), [], []),
                                  step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                                  step(
                                    best_from(8, 4),
                                    rule("weighted-interval-scheduling.pl", clause(15)),
                                    ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                                    [
                                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                                      step(=<(8, 8), builtin(=<, 2), [], []),
                                      step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                      step(
                                        next_compatible(8, 9),
                                        rule("weighted-interval-scheduling.pl", clause(13)),
                                        ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                        [
                                          step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                        ]
                                      ),
                                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                      step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                      step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                                      step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                                    ]
                                  ),
                                  step(
                                    next_compatible(7, 9),
                                    rule("weighted-interval-scheduling.pl", clause(13)),
                                    ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                                    [
                                      step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                                    ]
                                  ),
                                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                  step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                                  step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                                  step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                                ]
                              ),
                              step(
                                next_compatible(6, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 6, '_start' = 5, 'Finish' = 9, '_value' = 3],
                                [
                                  step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 6), >=(Startk, 9))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                              step(is(3, '+'(3, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(3, 4), =(4, 3)), =(4, 4)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(
                            next_compatible(5, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 5, '_start' = 3, 'Finish' = 9, '_value' = 6],
                            [
                              step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 5), >=(Startk, 9))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                          step(is(6, '+'(6, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(6, 4), =(6, 6)), =(6, 4)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(4, 8),
                        rule("weighted-interval-scheduling.pl", clause(12)),
                        ['I' = 4, 'J' = 8, '_start' = 4, 'Finish' = 7, '_value' = 4],
                        [
                          step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                          step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 4), >=(Startk, 7)), 8, 8), library(aggregate_min, 5), [], [])
                        ]
                      ),
                      step(
                        best_from(8, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(8, 8), builtin(=<, 2), [], []),
                          step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(
                            next_compatible(8, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                            [
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                          step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                      step(is(8, '+'(4, 4)), builtin(is, 2), [], []),
                      step(';'(->(>=(8, 6), =(8, 8)), =(8, 6)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(
                    next_compatible(3, 7),
                    rule("weighted-interval-scheduling.pl", clause(12)),
                    ['I' = 3, 'J' = 7, '_start' = 0, 'Finish' = 6, '_value' = 8],
                    [
                      step(interval(3, 0, 6, 8), fact("weighted-interval-scheduling.pl", clause(6)), [], []),
                      step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 3), >=(Startk, 6)), 7, 7), library(aggregate_min, 5), [], [])
                    ]
                  ),
                  step(
                    best_from(7, 4),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(7, 8), builtin(=<, 2), [], []),
                      step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(8, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(8, 8), builtin(=<, 2), [], []),
                          step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(
                            next_compatible(8, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                            [
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                          step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(7, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                        [
                          step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                      step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(interval(3, 0, 6, 8), fact("weighted-interval-scheduling.pl", clause(6)), [], []),
                  step(is(12, '+'(8, 4)), builtin(is, 2), [], []),
                  step(';'(->(>=(12, 8), =(12, 12)), =(12, 8)), builtin(';', 2), [], [])
                ]
              ),
              step(
                next_compatible(2, 6),
                rule("weighted-interval-scheduling.pl", clause(12)),
                ['I' = 2, 'J' = 6, '_start' = 3, 'Finish' = 5, '_value' = 1],
                [
                  step(interval(2, 3, 5, 1), fact("weighted-interval-scheduling.pl", clause(5)), [], []),
                  step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 2), >=(Startk, 5)), 6, 6), library(aggregate_min, 5), [], [])
                ]
              ),
              step(
                best_from(6, 4),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 6, 'Best' = 4, 'Last' = 8, 'Next' = 7, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 5, '_finish' = 9, 'Value' = 3, 'Take' = 3],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(6, 8), builtin(=<, 2), [], []),
                  step(is(7, '+'(6, 1)), builtin(is, 2), [], []),
                  step(
                    best_from(7, 4),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(7, 8), builtin(=<, 2), [], []),
                      step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(8, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(8, 8), builtin(=<, 2), [], []),
                          step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(
                            next_compatible(8, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                            [
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                          step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(7, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                        [
                          step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                      step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(
                    next_compatible(6, 9),
                    rule("weighted-interval-scheduling.pl", clause(13)),
                    ['I' = 6, '_start' = 5, 'Finish' = 9, '_value' = 3],
                    [
                      step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 6), >=(Startk, 9))), builtin('\\+', 1), [], [])
                    ]
                  ),
                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                  step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                  step(is(3, '+'(3, 0)), builtin(is, 2), [], []),
                  step(';'(->(>=(3, 4), =(4, 3)), =(4, 4)), builtin(';', 2), [], [])
                ]
              ),
              step(interval(2, 3, 5, 1), fact("weighted-interval-scheduling.pl", clause(5)), [], []),
              step(is(5, '+'(1, 4)), builtin(is, 2), [], []),
              step(';'(->(>=(5, 12), =(12, 5)), =(12, 12)), builtin(';', 2), [], [])
            ]
          ),
          step(
            next_compatible(1, 4),
            rule("weighted-interval-scheduling.pl", clause(12)),
            ['I' = 1, 'J' = 4, '_start' = 1, 'Finish' = 4, '_value' = 5],
            [
              step(interval(1, 1, 4, 5), fact("weighted-interval-scheduling.pl", clause(4)), [], []),
              step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 1), >=(Startk, 4)), 4, 4), library(aggregate_min, 5), [], [])
            ]
          ),
          step(
            best_from(4, 8),
            rule("weighted-interval-scheduling.pl", clause(15)),
            ['I' = 4, 'Best' = 8, 'Last' = 8, 'Next' = 5, 'Skip' = 6, 'Compatible' = 8, 'Tail' = 4, '_start' = 4, '_finish' = 7, 'Value' = 4, 'Take' = 8],
            [
              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
              step(=<(4, 8), builtin(=<, 2), [], []),
              step(is(5, '+'(4, 1)), builtin(is, 2), [], []),
              step(
                best_from(5, 6),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 5, 'Best' = 6, 'Last' = 8, 'Next' = 6, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 3, '_finish' = 9, 'Value' = 6, 'Take' = 6],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(5, 8), builtin(=<, 2), [], []),
                  step(is(6, '+'(5, 1)), builtin(is, 2), [], []),
                  step(
                    best_from(6, 4),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 6, 'Best' = 4, 'Last' = 8, 'Next' = 7, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 5, '_finish' = 9, 'Value' = 3, 'Take' = 3],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(6, 8), builtin(=<, 2), [], []),
                      step(is(7, '+'(6, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(7, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(7, 8), builtin(=<, 2), [], []),
                          step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                          step(
                            best_from(8, 4),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(8, 8), builtin(=<, 2), [], []),
                              step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(
                                next_compatible(8, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                [
                                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(
                            next_compatible(7, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                            [
                              step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                          step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(6, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 6, '_start' = 5, 'Finish' = 9, '_value' = 3],
                        [
                          step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 6), >=(Startk, 9))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                      step(is(3, '+'(3, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(3, 4), =(4, 3)), =(4, 4)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(
                    next_compatible(5, 9),
                    rule("weighted-interval-scheduling.pl", clause(13)),
                    ['I' = 5, '_start' = 3, 'Finish' = 9, '_value' = 6],
                    [
                      step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 5), >=(Startk, 9))), builtin('\\+', 1), [], [])
                    ]
                  ),
                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                  step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                  step(is(6, '+'(6, 0)), builtin(is, 2), [], []),
                  step(';'(->(>=(6, 4), =(6, 6)), =(6, 4)), builtin(';', 2), [], [])
                ]
              ),
              step(
                next_compatible(4, 8),
                rule("weighted-interval-scheduling.pl", clause(12)),
                ['I' = 4, 'J' = 8, '_start' = 4, 'Finish' = 7, '_value' = 4],
                [
                  step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                  step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 4), >=(Startk, 7)), 8, 8), library(aggregate_min, 5), [], [])
                ]
              ),
              step(
                best_from(8, 4),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(8, 8), builtin(=<, 2), [], []),
                  step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                  step(
                    next_compatible(8, 9),
                    rule("weighted-interval-scheduling.pl", clause(13)),
                    ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                    [
                      step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                    ]
                  ),
                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                  step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                  step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                ]
              ),
              step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
              step(is(8, '+'(4, 4)), builtin(is, 2), [], []),
              step(';'(->(>=(8, 6), =(8, 8)), =(8, 6)), builtin(';', 2), [], [])
            ]
          ),
          step(interval(1, 1, 4, 5), fact("weighted-interval-scheduling.pl", clause(4)), [], []),
          step(is(13, '+'(5, 8)), builtin(is, 2), [], []),
          step(';'(->(>=(13, 12), =(13, 13)), =(13, 12)), builtin(';', 2), [], [])
        ]
      )
    ]
  )
).

weighted_interval_answer(chosen_interval, interval(1, 1, 4, 5)).
why(
  weighted_interval_answer(chosen_interval, interval(1, 1, 4, 5)),
  step(
    weighted_interval_answer(chosen_interval, interval(1, 1, 4, 5)),
    rule("weighted-interval-scheduling.pl", clause(20)),
    ['I' = 1, 'Start' = 1, 'Finish' = 4, 'Value' = 5],
    [
      step(
        chosen_from(1, 1),
        rule("weighted-interval-scheduling.pl", clause(16)),
        ['I' = 1, 'Best' = 13, 'Next' = 2, 'Skip' = 12, 'Compatible' = 4, 'Tail' = 8, '_start' = 1, '_finish' = 4, 'Value' = 5, 'Take' = 13],
        [
          step(
            best_from(1, 13),
            rule("weighted-interval-scheduling.pl", clause(15)),
            ['I' = 1, 'Best' = 13, 'Last' = 8, 'Next' = 2, 'Skip' = 12, 'Compatible' = 4, 'Tail' = 8, '_start' = 1, '_finish' = 4, 'Value' = 5, 'Take' = 13],
            [
              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
              step(=<(1, 8), builtin(=<, 2), [], []),
              step(is(2, '+'(1, 1)), builtin(is, 2), [], []),
              step(
                best_from(2, 12),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 2, 'Best' = 12, 'Last' = 8, 'Next' = 3, 'Skip' = 12, 'Compatible' = 6, 'Tail' = 4, '_start' = 3, '_finish' = 5, 'Value' = 1, 'Take' = 5],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(2, 8), builtin(=<, 2), [], []),
                  step(is(3, '+'(2, 1)), builtin(is, 2), [], []),
                  step(
                    best_from(3, 12),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 3, 'Best' = 12, 'Last' = 8, 'Next' = 4, 'Skip' = 8, 'Compatible' = 7, 'Tail' = 4, '_start' = 0, '_finish' = 6, 'Value' = 8, 'Take' = 12],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(3, 8), builtin(=<, 2), [], []),
                      step(is(4, '+'(3, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(4, 8),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 4, 'Best' = 8, 'Last' = 8, 'Next' = 5, 'Skip' = 6, 'Compatible' = 8, 'Tail' = 4, '_start' = 4, '_finish' = 7, 'Value' = 4, 'Take' = 8],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(4, 8), builtin(=<, 2), [], []),
                          step(is(5, '+'(4, 1)), builtin(is, 2), [], []),
                          step(
                            best_from(5, 6),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 5, 'Best' = 6, 'Last' = 8, 'Next' = 6, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 3, '_finish' = 9, 'Value' = 6, 'Take' = 6],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(5, 8), builtin(=<, 2), [], []),
                              step(is(6, '+'(5, 1)), builtin(is, 2), [], []),
                              step(
                                best_from(6, 4),
                                rule("weighted-interval-scheduling.pl", clause(15)),
                                ['I' = 6, 'Best' = 4, 'Last' = 8, 'Next' = 7, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 5, '_finish' = 9, 'Value' = 3, 'Take' = 3],
                                [
                                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                                  step(=<(6, 8), builtin(=<, 2), [], []),
                                  step(is(7, '+'(6, 1)), builtin(is, 2), [], []),
                                  step(
                                    best_from(7, 4),
                                    rule("weighted-interval-scheduling.pl", clause(15)),
                                    ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                                    [
                                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                                      step(=<(7, 8), builtin(=<, 2), [], []),
                                      step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                                      step(
                                        best_from(8, 4),
                                        rule("weighted-interval-scheduling.pl", clause(15)),
                                        ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                                        [
                                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                                          step(=<(8, 8), builtin(=<, 2), [], []),
                                          step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                          step(
                                            next_compatible(8, 9),
                                            rule("weighted-interval-scheduling.pl", clause(13)),
                                            ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                            [
                                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                            ]
                                          ),
                                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                          step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                          step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                                          step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                                        ]
                                      ),
                                      step(
                                        next_compatible(7, 9),
                                        rule("weighted-interval-scheduling.pl", clause(13)),
                                        ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                                        [
                                          step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                                        ]
                                      ),
                                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                      step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                                      step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                                      step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                                    ]
                                  ),
                                  step(
                                    next_compatible(6, 9),
                                    rule("weighted-interval-scheduling.pl", clause(13)),
                                    ['I' = 6, '_start' = 5, 'Finish' = 9, '_value' = 3],
                                    [
                                      step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 6), >=(Startk, 9))), builtin('\\+', 1), [], [])
                                    ]
                                  ),
                                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                  step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                                  step(is(3, '+'(3, 0)), builtin(is, 2), [], []),
                                  step(';'(->(>=(3, 4), =(4, 3)), =(4, 4)), builtin(';', 2), [], [])
                                ]
                              ),
                              step(
                                next_compatible(5, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 5, '_start' = 3, 'Finish' = 9, '_value' = 6],
                                [
                                  step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 5), >=(Startk, 9))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                              step(is(6, '+'(6, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(6, 4), =(6, 6)), =(6, 4)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(
                            next_compatible(4, 8),
                            rule("weighted-interval-scheduling.pl", clause(12)),
                            ['I' = 4, 'J' = 8, '_start' = 4, 'Finish' = 7, '_value' = 4],
                            [
                              step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                              step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 4), >=(Startk, 7)), 8, 8), library(aggregate_min, 5), [], [])
                            ]
                          ),
                          step(
                            best_from(8, 4),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(8, 8), builtin(=<, 2), [], []),
                              step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(
                                next_compatible(8, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                [
                                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                          step(is(8, '+'(4, 4)), builtin(is, 2), [], []),
                          step(';'(->(>=(8, 6), =(8, 8)), =(8, 6)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(3, 7),
                        rule("weighted-interval-scheduling.pl", clause(12)),
                        ['I' = 3, 'J' = 7, '_start' = 0, 'Finish' = 6, '_value' = 8],
                        [
                          step(interval(3, 0, 6, 8), fact("weighted-interval-scheduling.pl", clause(6)), [], []),
                          step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 3), >=(Startk, 6)), 7, 7), library(aggregate_min, 5), [], [])
                        ]
                      ),
                      step(
                        best_from(7, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(7, 8), builtin(=<, 2), [], []),
                          step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                          step(
                            best_from(8, 4),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(8, 8), builtin(=<, 2), [], []),
                              step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(
                                next_compatible(8, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                [
                                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(
                            next_compatible(7, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                            [
                              step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                          step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(interval(3, 0, 6, 8), fact("weighted-interval-scheduling.pl", clause(6)), [], []),
                      step(is(12, '+'(8, 4)), builtin(is, 2), [], []),
                      step(';'(->(>=(12, 8), =(12, 12)), =(12, 8)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(
                    next_compatible(2, 6),
                    rule("weighted-interval-scheduling.pl", clause(12)),
                    ['I' = 2, 'J' = 6, '_start' = 3, 'Finish' = 5, '_value' = 1],
                    [
                      step(interval(2, 3, 5, 1), fact("weighted-interval-scheduling.pl", clause(5)), [], []),
                      step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 2), >=(Startk, 5)), 6, 6), library(aggregate_min, 5), [], [])
                    ]
                  ),
                  step(
                    best_from(6, 4),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 6, 'Best' = 4, 'Last' = 8, 'Next' = 7, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 5, '_finish' = 9, 'Value' = 3, 'Take' = 3],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(6, 8), builtin(=<, 2), [], []),
                      step(is(7, '+'(6, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(7, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(7, 8), builtin(=<, 2), [], []),
                          step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                          step(
                            best_from(8, 4),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(8, 8), builtin(=<, 2), [], []),
                              step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(
                                next_compatible(8, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                [
                                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(
                            next_compatible(7, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                            [
                              step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                          step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(6, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 6, '_start' = 5, 'Finish' = 9, '_value' = 3],
                        [
                          step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 6), >=(Startk, 9))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                      step(is(3, '+'(3, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(3, 4), =(4, 3)), =(4, 4)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(interval(2, 3, 5, 1), fact("weighted-interval-scheduling.pl", clause(5)), [], []),
                  step(is(5, '+'(1, 4)), builtin(is, 2), [], []),
                  step(';'(->(>=(5, 12), =(12, 5)), =(12, 12)), builtin(';', 2), [], [])
                ]
              ),
              step(
                next_compatible(1, 4),
                rule("weighted-interval-scheduling.pl", clause(12)),
                ['I' = 1, 'J' = 4, '_start' = 1, 'Finish' = 4, '_value' = 5],
                [
                  step(interval(1, 1, 4, 5), fact("weighted-interval-scheduling.pl", clause(4)), [], []),
                  step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 1), >=(Startk, 4)), 4, 4), library(aggregate_min, 5), [], [])
                ]
              ),
              step(
                best_from(4, 8),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 4, 'Best' = 8, 'Last' = 8, 'Next' = 5, 'Skip' = 6, 'Compatible' = 8, 'Tail' = 4, '_start' = 4, '_finish' = 7, 'Value' = 4, 'Take' = 8],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(4, 8), builtin(=<, 2), [], []),
                  step(is(5, '+'(4, 1)), builtin(is, 2), [], []),
                  step(
                    best_from(5, 6),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 5, 'Best' = 6, 'Last' = 8, 'Next' = 6, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 3, '_finish' = 9, 'Value' = 6, 'Take' = 6],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(5, 8), builtin(=<, 2), [], []),
                      step(is(6, '+'(5, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(6, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 6, 'Best' = 4, 'Last' = 8, 'Next' = 7, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 5, '_finish' = 9, 'Value' = 3, 'Take' = 3],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(6, 8), builtin(=<, 2), [], []),
                          step(is(7, '+'(6, 1)), builtin(is, 2), [], []),
                          step(
                            best_from(7, 4),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(7, 8), builtin(=<, 2), [], []),
                              step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                              step(
                                best_from(8, 4),
                                rule("weighted-interval-scheduling.pl", clause(15)),
                                ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                                [
                                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                                  step(=<(8, 8), builtin(=<, 2), [], []),
                                  step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                  step(
                                    next_compatible(8, 9),
                                    rule("weighted-interval-scheduling.pl", clause(13)),
                                    ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                    [
                                      step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                    ]
                                  ),
                                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                  step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                                  step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                                ]
                              ),
                              step(
                                next_compatible(7, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                                [
                                  step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                              step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(
                            next_compatible(6, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 6, '_start' = 5, 'Finish' = 9, '_value' = 3],
                            [
                              step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 6), >=(Startk, 9))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                          step(is(3, '+'(3, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(3, 4), =(4, 3)), =(4, 4)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(5, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 5, '_start' = 3, 'Finish' = 9, '_value' = 6],
                        [
                          step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 5), >=(Startk, 9))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                      step(is(6, '+'(6, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(6, 4), =(6, 6)), =(6, 4)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(
                    next_compatible(4, 8),
                    rule("weighted-interval-scheduling.pl", clause(12)),
                    ['I' = 4, 'J' = 8, '_start' = 4, 'Finish' = 7, '_value' = 4],
                    [
                      step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                      step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 4), >=(Startk, 7)), 8, 8), library(aggregate_min, 5), [], [])
                    ]
                  ),
                  step(
                    best_from(8, 4),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(8, 8), builtin(=<, 2), [], []),
                      step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(
                        next_compatible(8, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                        [
                          step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                      step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                  step(is(8, '+'(4, 4)), builtin(is, 2), [], []),
                  step(';'(->(>=(8, 6), =(8, 8)), =(8, 6)), builtin(';', 2), [], [])
                ]
              ),
              step(interval(1, 1, 4, 5), fact("weighted-interval-scheduling.pl", clause(4)), [], []),
              step(is(13, '+'(5, 8)), builtin(is, 2), [], []),
              step(';'(->(>=(13, 12), =(13, 13)), =(13, 12)), builtin(';', 2), [], [])
            ]
          ),
          step(is(2, '+'(1, 1)), builtin(is, 2), [], []),
          step(
            best_from(2, 12),
            rule("weighted-interval-scheduling.pl", clause(15)),
            ['I' = 2, 'Best' = 12, 'Last' = 8, 'Next' = 3, 'Skip' = 12, 'Compatible' = 6, 'Tail' = 4, '_start' = 3, '_finish' = 5, 'Value' = 1, 'Take' = 5],
            [
              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
              step(=<(2, 8), builtin(=<, 2), [], []),
              step(is(3, '+'(2, 1)), builtin(is, 2), [], []),
              step(
                best_from(3, 12),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 3, 'Best' = 12, 'Last' = 8, 'Next' = 4, 'Skip' = 8, 'Compatible' = 7, 'Tail' = 4, '_start' = 0, '_finish' = 6, 'Value' = 8, 'Take' = 12],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(3, 8), builtin(=<, 2), [], []),
                  step(is(4, '+'(3, 1)), builtin(is, 2), [], []),
                  step(
                    best_from(4, 8),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 4, 'Best' = 8, 'Last' = 8, 'Next' = 5, 'Skip' = 6, 'Compatible' = 8, 'Tail' = 4, '_start' = 4, '_finish' = 7, 'Value' = 4, 'Take' = 8],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(4, 8), builtin(=<, 2), [], []),
                      step(is(5, '+'(4, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(5, 6),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 5, 'Best' = 6, 'Last' = 8, 'Next' = 6, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 3, '_finish' = 9, 'Value' = 6, 'Take' = 6],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(5, 8), builtin(=<, 2), [], []),
                          step(is(6, '+'(5, 1)), builtin(is, 2), [], []),
                          step(
                            best_from(6, 4),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 6, 'Best' = 4, 'Last' = 8, 'Next' = 7, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 5, '_finish' = 9, 'Value' = 3, 'Take' = 3],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(6, 8), builtin(=<, 2), [], []),
                              step(is(7, '+'(6, 1)), builtin(is, 2), [], []),
                              step(
                                best_from(7, 4),
                                rule("weighted-interval-scheduling.pl", clause(15)),
                                ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                                [
                                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                                  step(=<(7, 8), builtin(=<, 2), [], []),
                                  step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                                  step(
                                    best_from(8, 4),
                                    rule("weighted-interval-scheduling.pl", clause(15)),
                                    ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                                    [
                                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                                      step(=<(8, 8), builtin(=<, 2), [], []),
                                      step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                      step(
                                        next_compatible(8, 9),
                                        rule("weighted-interval-scheduling.pl", clause(13)),
                                        ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                        [
                                          step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                        ]
                                      ),
                                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                      step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                      step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                                      step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                                    ]
                                  ),
                                  step(
                                    next_compatible(7, 9),
                                    rule("weighted-interval-scheduling.pl", clause(13)),
                                    ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                                    [
                                      step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                                    ]
                                  ),
                                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                  step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                                  step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                                  step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                                ]
                              ),
                              step(
                                next_compatible(6, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 6, '_start' = 5, 'Finish' = 9, '_value' = 3],
                                [
                                  step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 6), >=(Startk, 9))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                              step(is(3, '+'(3, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(3, 4), =(4, 3)), =(4, 4)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(
                            next_compatible(5, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 5, '_start' = 3, 'Finish' = 9, '_value' = 6],
                            [
                              step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 5), >=(Startk, 9))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                          step(is(6, '+'(6, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(6, 4), =(6, 6)), =(6, 4)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(4, 8),
                        rule("weighted-interval-scheduling.pl", clause(12)),
                        ['I' = 4, 'J' = 8, '_start' = 4, 'Finish' = 7, '_value' = 4],
                        [
                          step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                          step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 4), >=(Startk, 7)), 8, 8), library(aggregate_min, 5), [], [])
                        ]
                      ),
                      step(
                        best_from(8, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(8, 8), builtin(=<, 2), [], []),
                          step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(
                            next_compatible(8, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                            [
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                          step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                      step(is(8, '+'(4, 4)), builtin(is, 2), [], []),
                      step(';'(->(>=(8, 6), =(8, 8)), =(8, 6)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(
                    next_compatible(3, 7),
                    rule("weighted-interval-scheduling.pl", clause(12)),
                    ['I' = 3, 'J' = 7, '_start' = 0, 'Finish' = 6, '_value' = 8],
                    [
                      step(interval(3, 0, 6, 8), fact("weighted-interval-scheduling.pl", clause(6)), [], []),
                      step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 3), >=(Startk, 6)), 7, 7), library(aggregate_min, 5), [], [])
                    ]
                  ),
                  step(
                    best_from(7, 4),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(7, 8), builtin(=<, 2), [], []),
                      step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(8, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(8, 8), builtin(=<, 2), [], []),
                          step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(
                            next_compatible(8, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                            [
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                          step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(7, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                        [
                          step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                      step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(interval(3, 0, 6, 8), fact("weighted-interval-scheduling.pl", clause(6)), [], []),
                  step(is(12, '+'(8, 4)), builtin(is, 2), [], []),
                  step(';'(->(>=(12, 8), =(12, 12)), =(12, 8)), builtin(';', 2), [], [])
                ]
              ),
              step(
                next_compatible(2, 6),
                rule("weighted-interval-scheduling.pl", clause(12)),
                ['I' = 2, 'J' = 6, '_start' = 3, 'Finish' = 5, '_value' = 1],
                [
                  step(interval(2, 3, 5, 1), fact("weighted-interval-scheduling.pl", clause(5)), [], []),
                  step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 2), >=(Startk, 5)), 6, 6), library(aggregate_min, 5), [], [])
                ]
              ),
              step(
                best_from(6, 4),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 6, 'Best' = 4, 'Last' = 8, 'Next' = 7, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 5, '_finish' = 9, 'Value' = 3, 'Take' = 3],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(6, 8), builtin(=<, 2), [], []),
                  step(is(7, '+'(6, 1)), builtin(is, 2), [], []),
                  step(
                    best_from(7, 4),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(7, 8), builtin(=<, 2), [], []),
                      step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(8, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(8, 8), builtin(=<, 2), [], []),
                          step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(
                            next_compatible(8, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                            [
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                          step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(7, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                        [
                          step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                      step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(
                    next_compatible(6, 9),
                    rule("weighted-interval-scheduling.pl", clause(13)),
                    ['I' = 6, '_start' = 5, 'Finish' = 9, '_value' = 3],
                    [
                      step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 6), >=(Startk, 9))), builtin('\\+', 1), [], [])
                    ]
                  ),
                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                  step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                  step(is(3, '+'(3, 0)), builtin(is, 2), [], []),
                  step(';'(->(>=(3, 4), =(4, 3)), =(4, 4)), builtin(';', 2), [], [])
                ]
              ),
              step(interval(2, 3, 5, 1), fact("weighted-interval-scheduling.pl", clause(5)), [], []),
              step(is(5, '+'(1, 4)), builtin(is, 2), [], []),
              step(';'(->(>=(5, 12), =(12, 5)), =(12, 12)), builtin(';', 2), [], [])
            ]
          ),
          step(
            next_compatible(1, 4),
            rule("weighted-interval-scheduling.pl", clause(12)),
            ['I' = 1, 'J' = 4, '_start' = 1, 'Finish' = 4, '_value' = 5],
            [
              step(interval(1, 1, 4, 5), fact("weighted-interval-scheduling.pl", clause(4)), [], []),
              step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 1), >=(Startk, 4)), 4, 4), library(aggregate_min, 5), [], [])
            ]
          ),
          step(
            best_from(4, 8),
            rule("weighted-interval-scheduling.pl", clause(15)),
            ['I' = 4, 'Best' = 8, 'Last' = 8, 'Next' = 5, 'Skip' = 6, 'Compatible' = 8, 'Tail' = 4, '_start' = 4, '_finish' = 7, 'Value' = 4, 'Take' = 8],
            [
              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
              step(=<(4, 8), builtin(=<, 2), [], []),
              step(is(5, '+'(4, 1)), builtin(is, 2), [], []),
              step(
                best_from(5, 6),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 5, 'Best' = 6, 'Last' = 8, 'Next' = 6, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 3, '_finish' = 9, 'Value' = 6, 'Take' = 6],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(5, 8), builtin(=<, 2), [], []),
                  step(is(6, '+'(5, 1)), builtin(is, 2), [], []),
                  step(
                    best_from(6, 4),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 6, 'Best' = 4, 'Last' = 8, 'Next' = 7, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 5, '_finish' = 9, 'Value' = 3, 'Take' = 3],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(6, 8), builtin(=<, 2), [], []),
                      step(is(7, '+'(6, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(7, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(7, 8), builtin(=<, 2), [], []),
                          step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                          step(
                            best_from(8, 4),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(8, 8), builtin(=<, 2), [], []),
                              step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(
                                next_compatible(8, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                [
                                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(
                            next_compatible(7, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                            [
                              step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                          step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(6, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 6, '_start' = 5, 'Finish' = 9, '_value' = 3],
                        [
                          step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 6), >=(Startk, 9))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                      step(is(3, '+'(3, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(3, 4), =(4, 3)), =(4, 4)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(
                    next_compatible(5, 9),
                    rule("weighted-interval-scheduling.pl", clause(13)),
                    ['I' = 5, '_start' = 3, 'Finish' = 9, '_value' = 6],
                    [
                      step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 5), >=(Startk, 9))), builtin('\\+', 1), [], [])
                    ]
                  ),
                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                  step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                  step(is(6, '+'(6, 0)), builtin(is, 2), [], []),
                  step(';'(->(>=(6, 4), =(6, 6)), =(6, 4)), builtin(';', 2), [], [])
                ]
              ),
              step(
                next_compatible(4, 8),
                rule("weighted-interval-scheduling.pl", clause(12)),
                ['I' = 4, 'J' = 8, '_start' = 4, 'Finish' = 7, '_value' = 4],
                [
                  step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                  step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 4), >=(Startk, 7)), 8, 8), library(aggregate_min, 5), [], [])
                ]
              ),
              step(
                best_from(8, 4),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(8, 8), builtin(=<, 2), [], []),
                  step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                  step(
                    next_compatible(8, 9),
                    rule("weighted-interval-scheduling.pl", clause(13)),
                    ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                    [
                      step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                    ]
                  ),
                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                  step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                  step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                ]
              ),
              step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
              step(is(8, '+'(4, 4)), builtin(is, 2), [], []),
              step(';'(->(>=(8, 6), =(8, 8)), =(8, 6)), builtin(';', 2), [], [])
            ]
          ),
          step(interval(1, 1, 4, 5), fact("weighted-interval-scheduling.pl", clause(4)), [], []),
          step(is(13, '+'(5, 8)), builtin(is, 2), [], []),
          step(=(13, 13), builtin(=, 2), [], []),
          step(>=(13, 12), builtin(>=, 2), [], [])
        ]
      ),
      step(interval(1, 1, 4, 5), fact("weighted-interval-scheduling.pl", clause(4)), [], [])
    ]
  )
).

weighted_interval_answer(chosen_interval, interval(4, 4, 7, 4)).
why(
  weighted_interval_answer(chosen_interval, interval(4, 4, 7, 4)),
  step(
    weighted_interval_answer(chosen_interval, interval(4, 4, 7, 4)),
    rule("weighted-interval-scheduling.pl", clause(20)),
    ['I' = 4, 'Start' = 4, 'Finish' = 7, 'Value' = 4],
    [
      step(
        chosen_from(1, 4),
        rule("weighted-interval-scheduling.pl", clause(17)),
        ['I' = 1, 'Chosen' = 4, 'Best' = 13, 'Next' = 2, 'Skip' = 12, 'Compatible' = 4, 'Tail' = 8, '_start' = 1, '_finish' = 4, 'Value' = 5, 'Take' = 13],
        [
          step(
            best_from(1, 13),
            rule("weighted-interval-scheduling.pl", clause(15)),
            ['I' = 1, 'Best' = 13, 'Last' = 8, 'Next' = 2, 'Skip' = 12, 'Compatible' = 4, 'Tail' = 8, '_start' = 1, '_finish' = 4, 'Value' = 5, 'Take' = 13],
            [
              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
              step(=<(1, 8), builtin(=<, 2), [], []),
              step(is(2, '+'(1, 1)), builtin(is, 2), [], []),
              step(
                best_from(2, 12),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 2, 'Best' = 12, 'Last' = 8, 'Next' = 3, 'Skip' = 12, 'Compatible' = 6, 'Tail' = 4, '_start' = 3, '_finish' = 5, 'Value' = 1, 'Take' = 5],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(2, 8), builtin(=<, 2), [], []),
                  step(is(3, '+'(2, 1)), builtin(is, 2), [], []),
                  step(
                    best_from(3, 12),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 3, 'Best' = 12, 'Last' = 8, 'Next' = 4, 'Skip' = 8, 'Compatible' = 7, 'Tail' = 4, '_start' = 0, '_finish' = 6, 'Value' = 8, 'Take' = 12],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(3, 8), builtin(=<, 2), [], []),
                      step(is(4, '+'(3, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(4, 8),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 4, 'Best' = 8, 'Last' = 8, 'Next' = 5, 'Skip' = 6, 'Compatible' = 8, 'Tail' = 4, '_start' = 4, '_finish' = 7, 'Value' = 4, 'Take' = 8],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(4, 8), builtin(=<, 2), [], []),
                          step(is(5, '+'(4, 1)), builtin(is, 2), [], []),
                          step(
                            best_from(5, 6),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 5, 'Best' = 6, 'Last' = 8, 'Next' = 6, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 3, '_finish' = 9, 'Value' = 6, 'Take' = 6],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(5, 8), builtin(=<, 2), [], []),
                              step(is(6, '+'(5, 1)), builtin(is, 2), [], []),
                              step(
                                best_from(6, 4),
                                rule("weighted-interval-scheduling.pl", clause(15)),
                                ['I' = 6, 'Best' = 4, 'Last' = 8, 'Next' = 7, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 5, '_finish' = 9, 'Value' = 3, 'Take' = 3],
                                [
                                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                                  step(=<(6, 8), builtin(=<, 2), [], []),
                                  step(is(7, '+'(6, 1)), builtin(is, 2), [], []),
                                  step(
                                    best_from(7, 4),
                                    rule("weighted-interval-scheduling.pl", clause(15)),
                                    ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                                    [
                                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                                      step(=<(7, 8), builtin(=<, 2), [], []),
                                      step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                                      step(
                                        best_from(8, 4),
                                        rule("weighted-interval-scheduling.pl", clause(15)),
                                        ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                                        [
                                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                                          step(=<(8, 8), builtin(=<, 2), [], []),
                                          step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                          step(
                                            next_compatible(8, 9),
                                            rule("weighted-interval-scheduling.pl", clause(13)),
                                            ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                            [
                                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                            ]
                                          ),
                                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                          step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                          step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                                          step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                                        ]
                                      ),
                                      step(
                                        next_compatible(7, 9),
                                        rule("weighted-interval-scheduling.pl", clause(13)),
                                        ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                                        [
                                          step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                                        ]
                                      ),
                                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                      step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                                      step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                                      step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                                    ]
                                  ),
                                  step(
                                    next_compatible(6, 9),
                                    rule("weighted-interval-scheduling.pl", clause(13)),
                                    ['I' = 6, '_start' = 5, 'Finish' = 9, '_value' = 3],
                                    [
                                      step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 6), >=(Startk, 9))), builtin('\\+', 1), [], [])
                                    ]
                                  ),
                                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                  step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                                  step(is(3, '+'(3, 0)), builtin(is, 2), [], []),
                                  step(';'(->(>=(3, 4), =(4, 3)), =(4, 4)), builtin(';', 2), [], [])
                                ]
                              ),
                              step(
                                next_compatible(5, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 5, '_start' = 3, 'Finish' = 9, '_value' = 6],
                                [
                                  step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 5), >=(Startk, 9))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                              step(is(6, '+'(6, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(6, 4), =(6, 6)), =(6, 4)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(
                            next_compatible(4, 8),
                            rule("weighted-interval-scheduling.pl", clause(12)),
                            ['I' = 4, 'J' = 8, '_start' = 4, 'Finish' = 7, '_value' = 4],
                            [
                              step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                              step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 4), >=(Startk, 7)), 8, 8), library(aggregate_min, 5), [], [])
                            ]
                          ),
                          step(
                            best_from(8, 4),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(8, 8), builtin(=<, 2), [], []),
                              step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(
                                next_compatible(8, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                [
                                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                          step(is(8, '+'(4, 4)), builtin(is, 2), [], []),
                          step(';'(->(>=(8, 6), =(8, 8)), =(8, 6)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(3, 7),
                        rule("weighted-interval-scheduling.pl", clause(12)),
                        ['I' = 3, 'J' = 7, '_start' = 0, 'Finish' = 6, '_value' = 8],
                        [
                          step(interval(3, 0, 6, 8), fact("weighted-interval-scheduling.pl", clause(6)), [], []),
                          step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 3), >=(Startk, 6)), 7, 7), library(aggregate_min, 5), [], [])
                        ]
                      ),
                      step(
                        best_from(7, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(7, 8), builtin(=<, 2), [], []),
                          step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                          step(
                            best_from(8, 4),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(8, 8), builtin(=<, 2), [], []),
                              step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(
                                next_compatible(8, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                [
                                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(
                            next_compatible(7, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                            [
                              step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                          step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(interval(3, 0, 6, 8), fact("weighted-interval-scheduling.pl", clause(6)), [], []),
                      step(is(12, '+'(8, 4)), builtin(is, 2), [], []),
                      step(';'(->(>=(12, 8), =(12, 12)), =(12, 8)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(
                    next_compatible(2, 6),
                    rule("weighted-interval-scheduling.pl", clause(12)),
                    ['I' = 2, 'J' = 6, '_start' = 3, 'Finish' = 5, '_value' = 1],
                    [
                      step(interval(2, 3, 5, 1), fact("weighted-interval-scheduling.pl", clause(5)), [], []),
                      step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 2), >=(Startk, 5)), 6, 6), library(aggregate_min, 5), [], [])
                    ]
                  ),
                  step(
                    best_from(6, 4),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 6, 'Best' = 4, 'Last' = 8, 'Next' = 7, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 5, '_finish' = 9, 'Value' = 3, 'Take' = 3],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(6, 8), builtin(=<, 2), [], []),
                      step(is(7, '+'(6, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(7, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(7, 8), builtin(=<, 2), [], []),
                          step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                          step(
                            best_from(8, 4),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(8, 8), builtin(=<, 2), [], []),
                              step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(
                                next_compatible(8, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                [
                                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(
                            next_compatible(7, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                            [
                              step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                          step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(6, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 6, '_start' = 5, 'Finish' = 9, '_value' = 3],
                        [
                          step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 6), >=(Startk, 9))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                      step(is(3, '+'(3, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(3, 4), =(4, 3)), =(4, 4)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(interval(2, 3, 5, 1), fact("weighted-interval-scheduling.pl", clause(5)), [], []),
                  step(is(5, '+'(1, 4)), builtin(is, 2), [], []),
                  step(';'(->(>=(5, 12), =(12, 5)), =(12, 12)), builtin(';', 2), [], [])
                ]
              ),
              step(
                next_compatible(1, 4),
                rule("weighted-interval-scheduling.pl", clause(12)),
                ['I' = 1, 'J' = 4, '_start' = 1, 'Finish' = 4, '_value' = 5],
                [
                  step(interval(1, 1, 4, 5), fact("weighted-interval-scheduling.pl", clause(4)), [], []),
                  step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 1), >=(Startk, 4)), 4, 4), library(aggregate_min, 5), [], [])
                ]
              ),
              step(
                best_from(4, 8),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 4, 'Best' = 8, 'Last' = 8, 'Next' = 5, 'Skip' = 6, 'Compatible' = 8, 'Tail' = 4, '_start' = 4, '_finish' = 7, 'Value' = 4, 'Take' = 8],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(4, 8), builtin(=<, 2), [], []),
                  step(is(5, '+'(4, 1)), builtin(is, 2), [], []),
                  step(
                    best_from(5, 6),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 5, 'Best' = 6, 'Last' = 8, 'Next' = 6, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 3, '_finish' = 9, 'Value' = 6, 'Take' = 6],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(5, 8), builtin(=<, 2), [], []),
                      step(is(6, '+'(5, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(6, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 6, 'Best' = 4, 'Last' = 8, 'Next' = 7, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 5, '_finish' = 9, 'Value' = 3, 'Take' = 3],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(6, 8), builtin(=<, 2), [], []),
                          step(is(7, '+'(6, 1)), builtin(is, 2), [], []),
                          step(
                            best_from(7, 4),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(7, 8), builtin(=<, 2), [], []),
                              step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                              step(
                                best_from(8, 4),
                                rule("weighted-interval-scheduling.pl", clause(15)),
                                ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                                [
                                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                                  step(=<(8, 8), builtin(=<, 2), [], []),
                                  step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                  step(
                                    next_compatible(8, 9),
                                    rule("weighted-interval-scheduling.pl", clause(13)),
                                    ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                    [
                                      step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                    ]
                                  ),
                                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                  step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                                  step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                                ]
                              ),
                              step(
                                next_compatible(7, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                                [
                                  step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                              step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(
                            next_compatible(6, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 6, '_start' = 5, 'Finish' = 9, '_value' = 3],
                            [
                              step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 6), >=(Startk, 9))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                          step(is(3, '+'(3, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(3, 4), =(4, 3)), =(4, 4)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(5, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 5, '_start' = 3, 'Finish' = 9, '_value' = 6],
                        [
                          step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 5), >=(Startk, 9))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                      step(is(6, '+'(6, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(6, 4), =(6, 6)), =(6, 4)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(
                    next_compatible(4, 8),
                    rule("weighted-interval-scheduling.pl", clause(12)),
                    ['I' = 4, 'J' = 8, '_start' = 4, 'Finish' = 7, '_value' = 4],
                    [
                      step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                      step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 4), >=(Startk, 7)), 8, 8), library(aggregate_min, 5), [], [])
                    ]
                  ),
                  step(
                    best_from(8, 4),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(8, 8), builtin(=<, 2), [], []),
                      step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(
                        next_compatible(8, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                        [
                          step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                      step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                  step(is(8, '+'(4, 4)), builtin(is, 2), [], []),
                  step(';'(->(>=(8, 6), =(8, 8)), =(8, 6)), builtin(';', 2), [], [])
                ]
              ),
              step(interval(1, 1, 4, 5), fact("weighted-interval-scheduling.pl", clause(4)), [], []),
              step(is(13, '+'(5, 8)), builtin(is, 2), [], []),
              step(';'(->(>=(13, 12), =(13, 13)), =(13, 12)), builtin(';', 2), [], [])
            ]
          ),
          step(is(2, '+'(1, 1)), builtin(is, 2), [], []),
          step(
            best_from(2, 12),
            rule("weighted-interval-scheduling.pl", clause(15)),
            ['I' = 2, 'Best' = 12, 'Last' = 8, 'Next' = 3, 'Skip' = 12, 'Compatible' = 6, 'Tail' = 4, '_start' = 3, '_finish' = 5, 'Value' = 1, 'Take' = 5],
            [
              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
              step(=<(2, 8), builtin(=<, 2), [], []),
              step(is(3, '+'(2, 1)), builtin(is, 2), [], []),
              step(
                best_from(3, 12),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 3, 'Best' = 12, 'Last' = 8, 'Next' = 4, 'Skip' = 8, 'Compatible' = 7, 'Tail' = 4, '_start' = 0, '_finish' = 6, 'Value' = 8, 'Take' = 12],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(3, 8), builtin(=<, 2), [], []),
                  step(is(4, '+'(3, 1)), builtin(is, 2), [], []),
                  step(
                    best_from(4, 8),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 4, 'Best' = 8, 'Last' = 8, 'Next' = 5, 'Skip' = 6, 'Compatible' = 8, 'Tail' = 4, '_start' = 4, '_finish' = 7, 'Value' = 4, 'Take' = 8],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(4, 8), builtin(=<, 2), [], []),
                      step(is(5, '+'(4, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(5, 6),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 5, 'Best' = 6, 'Last' = 8, 'Next' = 6, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 3, '_finish' = 9, 'Value' = 6, 'Take' = 6],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(5, 8), builtin(=<, 2), [], []),
                          step(is(6, '+'(5, 1)), builtin(is, 2), [], []),
                          step(
                            best_from(6, 4),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 6, 'Best' = 4, 'Last' = 8, 'Next' = 7, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 5, '_finish' = 9, 'Value' = 3, 'Take' = 3],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(6, 8), builtin(=<, 2), [], []),
                              step(is(7, '+'(6, 1)), builtin(is, 2), [], []),
                              step(
                                best_from(7, 4),
                                rule("weighted-interval-scheduling.pl", clause(15)),
                                ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                                [
                                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                                  step(=<(7, 8), builtin(=<, 2), [], []),
                                  step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                                  step(
                                    best_from(8, 4),
                                    rule("weighted-interval-scheduling.pl", clause(15)),
                                    ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                                    [
                                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                                      step(=<(8, 8), builtin(=<, 2), [], []),
                                      step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                      step(
                                        next_compatible(8, 9),
                                        rule("weighted-interval-scheduling.pl", clause(13)),
                                        ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                        [
                                          step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                        ]
                                      ),
                                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                      step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                      step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                                      step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                                    ]
                                  ),
                                  step(
                                    next_compatible(7, 9),
                                    rule("weighted-interval-scheduling.pl", clause(13)),
                                    ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                                    [
                                      step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                                    ]
                                  ),
                                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                  step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                                  step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                                  step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                                ]
                              ),
                              step(
                                next_compatible(6, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 6, '_start' = 5, 'Finish' = 9, '_value' = 3],
                                [
                                  step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 6), >=(Startk, 9))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                              step(is(3, '+'(3, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(3, 4), =(4, 3)), =(4, 4)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(
                            next_compatible(5, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 5, '_start' = 3, 'Finish' = 9, '_value' = 6],
                            [
                              step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 5), >=(Startk, 9))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                          step(is(6, '+'(6, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(6, 4), =(6, 6)), =(6, 4)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(4, 8),
                        rule("weighted-interval-scheduling.pl", clause(12)),
                        ['I' = 4, 'J' = 8, '_start' = 4, 'Finish' = 7, '_value' = 4],
                        [
                          step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                          step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 4), >=(Startk, 7)), 8, 8), library(aggregate_min, 5), [], [])
                        ]
                      ),
                      step(
                        best_from(8, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(8, 8), builtin(=<, 2), [], []),
                          step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(
                            next_compatible(8, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                            [
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                          step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                      step(is(8, '+'(4, 4)), builtin(is, 2), [], []),
                      step(';'(->(>=(8, 6), =(8, 8)), =(8, 6)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(
                    next_compatible(3, 7),
                    rule("weighted-interval-scheduling.pl", clause(12)),
                    ['I' = 3, 'J' = 7, '_start' = 0, 'Finish' = 6, '_value' = 8],
                    [
                      step(interval(3, 0, 6, 8), fact("weighted-interval-scheduling.pl", clause(6)), [], []),
                      step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 3), >=(Startk, 6)), 7, 7), library(aggregate_min, 5), [], [])
                    ]
                  ),
                  step(
                    best_from(7, 4),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(7, 8), builtin(=<, 2), [], []),
                      step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(8, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(8, 8), builtin(=<, 2), [], []),
                          step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(
                            next_compatible(8, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                            [
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                          step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(7, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                        [
                          step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                      step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(interval(3, 0, 6, 8), fact("weighted-interval-scheduling.pl", clause(6)), [], []),
                  step(is(12, '+'(8, 4)), builtin(is, 2), [], []),
                  step(';'(->(>=(12, 8), =(12, 12)), =(12, 8)), builtin(';', 2), [], [])
                ]
              ),
              step(
                next_compatible(2, 6),
                rule("weighted-interval-scheduling.pl", clause(12)),
                ['I' = 2, 'J' = 6, '_start' = 3, 'Finish' = 5, '_value' = 1],
                [
                  step(interval(2, 3, 5, 1), fact("weighted-interval-scheduling.pl", clause(5)), [], []),
                  step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 2), >=(Startk, 5)), 6, 6), library(aggregate_min, 5), [], [])
                ]
              ),
              step(
                best_from(6, 4),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 6, 'Best' = 4, 'Last' = 8, 'Next' = 7, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 5, '_finish' = 9, 'Value' = 3, 'Take' = 3],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(6, 8), builtin(=<, 2), [], []),
                  step(is(7, '+'(6, 1)), builtin(is, 2), [], []),
                  step(
                    best_from(7, 4),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(7, 8), builtin(=<, 2), [], []),
                      step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(8, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(8, 8), builtin(=<, 2), [], []),
                          step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(
                            next_compatible(8, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                            [
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                          step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(7, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                        [
                          step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                      step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(
                    next_compatible(6, 9),
                    rule("weighted-interval-scheduling.pl", clause(13)),
                    ['I' = 6, '_start' = 5, 'Finish' = 9, '_value' = 3],
                    [
                      step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 6), >=(Startk, 9))), builtin('\\+', 1), [], [])
                    ]
                  ),
                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                  step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                  step(is(3, '+'(3, 0)), builtin(is, 2), [], []),
                  step(';'(->(>=(3, 4), =(4, 3)), =(4, 4)), builtin(';', 2), [], [])
                ]
              ),
              step(interval(2, 3, 5, 1), fact("weighted-interval-scheduling.pl", clause(5)), [], []),
              step(is(5, '+'(1, 4)), builtin(is, 2), [], []),
              step(';'(->(>=(5, 12), =(12, 5)), =(12, 12)), builtin(';', 2), [], [])
            ]
          ),
          step(
            next_compatible(1, 4),
            rule("weighted-interval-scheduling.pl", clause(12)),
            ['I' = 1, 'J' = 4, '_start' = 1, 'Finish' = 4, '_value' = 5],
            [
              step(interval(1, 1, 4, 5), fact("weighted-interval-scheduling.pl", clause(4)), [], []),
              step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 1), >=(Startk, 4)), 4, 4), library(aggregate_min, 5), [], [])
            ]
          ),
          step(
            best_from(4, 8),
            rule("weighted-interval-scheduling.pl", clause(15)),
            ['I' = 4, 'Best' = 8, 'Last' = 8, 'Next' = 5, 'Skip' = 6, 'Compatible' = 8, 'Tail' = 4, '_start' = 4, '_finish' = 7, 'Value' = 4, 'Take' = 8],
            [
              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
              step(=<(4, 8), builtin(=<, 2), [], []),
              step(is(5, '+'(4, 1)), builtin(is, 2), [], []),
              step(
                best_from(5, 6),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 5, 'Best' = 6, 'Last' = 8, 'Next' = 6, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 3, '_finish' = 9, 'Value' = 6, 'Take' = 6],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(5, 8), builtin(=<, 2), [], []),
                  step(is(6, '+'(5, 1)), builtin(is, 2), [], []),
                  step(
                    best_from(6, 4),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 6, 'Best' = 4, 'Last' = 8, 'Next' = 7, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 5, '_finish' = 9, 'Value' = 3, 'Take' = 3],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(6, 8), builtin(=<, 2), [], []),
                      step(is(7, '+'(6, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(7, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(7, 8), builtin(=<, 2), [], []),
                          step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                          step(
                            best_from(8, 4),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(8, 8), builtin(=<, 2), [], []),
                              step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(
                                next_compatible(8, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                [
                                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(
                            next_compatible(7, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                            [
                              step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                          step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(6, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 6, '_start' = 5, 'Finish' = 9, '_value' = 3],
                        [
                          step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 6), >=(Startk, 9))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                      step(is(3, '+'(3, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(3, 4), =(4, 3)), =(4, 4)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(
                    next_compatible(5, 9),
                    rule("weighted-interval-scheduling.pl", clause(13)),
                    ['I' = 5, '_start' = 3, 'Finish' = 9, '_value' = 6],
                    [
                      step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 5), >=(Startk, 9))), builtin('\\+', 1), [], [])
                    ]
                  ),
                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                  step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                  step(is(6, '+'(6, 0)), builtin(is, 2), [], []),
                  step(';'(->(>=(6, 4), =(6, 6)), =(6, 4)), builtin(';', 2), [], [])
                ]
              ),
              step(
                next_compatible(4, 8),
                rule("weighted-interval-scheduling.pl", clause(12)),
                ['I' = 4, 'J' = 8, '_start' = 4, 'Finish' = 7, '_value' = 4],
                [
                  step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                  step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 4), >=(Startk, 7)), 8, 8), library(aggregate_min, 5), [], [])
                ]
              ),
              step(
                best_from(8, 4),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(8, 8), builtin(=<, 2), [], []),
                  step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                  step(
                    next_compatible(8, 9),
                    rule("weighted-interval-scheduling.pl", clause(13)),
                    ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                    [
                      step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                    ]
                  ),
                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                  step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                  step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                ]
              ),
              step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
              step(is(8, '+'(4, 4)), builtin(is, 2), [], []),
              step(';'(->(>=(8, 6), =(8, 8)), =(8, 6)), builtin(';', 2), [], [])
            ]
          ),
          step(interval(1, 1, 4, 5), fact("weighted-interval-scheduling.pl", clause(4)), [], []),
          step(is(13, '+'(5, 8)), builtin(is, 2), [], []),
          step(=(13, 13), builtin(=, 2), [], []),
          step(>=(13, 12), builtin(>=, 2), [], []),
          step(
            chosen_from(4, 4),
            rule("weighted-interval-scheduling.pl", clause(16)),
            ['I' = 4, 'Best' = 8, 'Next' = 5, 'Skip' = 6, 'Compatible' = 8, 'Tail' = 4, '_start' = 4, '_finish' = 7, 'Value' = 4, 'Take' = 8],
            [
              step(
                best_from(4, 8),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 4, 'Best' = 8, 'Last' = 8, 'Next' = 5, 'Skip' = 6, 'Compatible' = 8, 'Tail' = 4, '_start' = 4, '_finish' = 7, 'Value' = 4, 'Take' = 8],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(4, 8), builtin(=<, 2), [], []),
                  step(is(5, '+'(4, 1)), builtin(is, 2), [], []),
                  step(
                    best_from(5, 6),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 5, 'Best' = 6, 'Last' = 8, 'Next' = 6, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 3, '_finish' = 9, 'Value' = 6, 'Take' = 6],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(5, 8), builtin(=<, 2), [], []),
                      step(is(6, '+'(5, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(6, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 6, 'Best' = 4, 'Last' = 8, 'Next' = 7, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 5, '_finish' = 9, 'Value' = 3, 'Take' = 3],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(6, 8), builtin(=<, 2), [], []),
                          step(is(7, '+'(6, 1)), builtin(is, 2), [], []),
                          step(
                            best_from(7, 4),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(7, 8), builtin(=<, 2), [], []),
                              step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                              step(
                                best_from(8, 4),
                                rule("weighted-interval-scheduling.pl", clause(15)),
                                ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                                [
                                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                                  step(=<(8, 8), builtin(=<, 2), [], []),
                                  step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                  step(
                                    next_compatible(8, 9),
                                    rule("weighted-interval-scheduling.pl", clause(13)),
                                    ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                    [
                                      step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                    ]
                                  ),
                                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                  step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                                  step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                                ]
                              ),
                              step(
                                next_compatible(7, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                                [
                                  step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                              step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(
                            next_compatible(6, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 6, '_start' = 5, 'Finish' = 9, '_value' = 3],
                            [
                              step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 6), >=(Startk, 9))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                          step(is(3, '+'(3, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(3, 4), =(4, 3)), =(4, 4)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(5, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 5, '_start' = 3, 'Finish' = 9, '_value' = 6],
                        [
                          step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 5), >=(Startk, 9))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                      step(is(6, '+'(6, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(6, 4), =(6, 6)), =(6, 4)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(
                    next_compatible(4, 8),
                    rule("weighted-interval-scheduling.pl", clause(12)),
                    ['I' = 4, 'J' = 8, '_start' = 4, 'Finish' = 7, '_value' = 4],
                    [
                      step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                      step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 4), >=(Startk, 7)), 8, 8), library(aggregate_min, 5), [], [])
                    ]
                  ),
                  step(
                    best_from(8, 4),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(8, 8), builtin(=<, 2), [], []),
                      step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(
                        next_compatible(8, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                        [
                          step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                      step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                  step(is(8, '+'(4, 4)), builtin(is, 2), [], []),
                  step(';'(->(>=(8, 6), =(8, 8)), =(8, 6)), builtin(';', 2), [], [])
                ]
              ),
              step(is(5, '+'(4, 1)), builtin(is, 2), [], []),
              step(
                best_from(5, 6),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 5, 'Best' = 6, 'Last' = 8, 'Next' = 6, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 3, '_finish' = 9, 'Value' = 6, 'Take' = 6],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(5, 8), builtin(=<, 2), [], []),
                  step(is(6, '+'(5, 1)), builtin(is, 2), [], []),
                  step(
                    best_from(6, 4),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 6, 'Best' = 4, 'Last' = 8, 'Next' = 7, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 5, '_finish' = 9, 'Value' = 3, 'Take' = 3],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(6, 8), builtin(=<, 2), [], []),
                      step(is(7, '+'(6, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(7, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(7, 8), builtin(=<, 2), [], []),
                          step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                          step(
                            best_from(8, 4),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(8, 8), builtin(=<, 2), [], []),
                              step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(
                                next_compatible(8, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                [
                                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(
                            next_compatible(7, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                            [
                              step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                          step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(6, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 6, '_start' = 5, 'Finish' = 9, '_value' = 3],
                        [
                          step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 6), >=(Startk, 9))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                      step(is(3, '+'(3, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(3, 4), =(4, 3)), =(4, 4)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(
                    next_compatible(5, 9),
                    rule("weighted-interval-scheduling.pl", clause(13)),
                    ['I' = 5, '_start' = 3, 'Finish' = 9, '_value' = 6],
                    [
                      step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 5), >=(Startk, 9))), builtin('\\+', 1), [], [])
                    ]
                  ),
                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                  step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                  step(is(6, '+'(6, 0)), builtin(is, 2), [], []),
                  step(';'(->(>=(6, 4), =(6, 6)), =(6, 4)), builtin(';', 2), [], [])
                ]
              ),
              step(
                next_compatible(4, 8),
                rule("weighted-interval-scheduling.pl", clause(12)),
                ['I' = 4, 'J' = 8, '_start' = 4, 'Finish' = 7, '_value' = 4],
                [
                  step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                  step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 4), >=(Startk, 7)), 8, 8), library(aggregate_min, 5), [], [])
                ]
              ),
              step(
                best_from(8, 4),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(8, 8), builtin(=<, 2), [], []),
                  step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                  step(
                    next_compatible(8, 9),
                    rule("weighted-interval-scheduling.pl", clause(13)),
                    ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                    [
                      step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                    ]
                  ),
                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                  step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                  step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                ]
              ),
              step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
              step(is(8, '+'(4, 4)), builtin(is, 2), [], []),
              step(=(8, 8), builtin(=, 2), [], []),
              step(>=(8, 6), builtin(>=, 2), [], [])
            ]
          )
        ]
      ),
      step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], [])
    ]
  )
).

weighted_interval_answer(chosen_interval, interval(8, 8, 11, 4)).
why(
  weighted_interval_answer(chosen_interval, interval(8, 8, 11, 4)),
  step(
    weighted_interval_answer(chosen_interval, interval(8, 8, 11, 4)),
    rule("weighted-interval-scheduling.pl", clause(20)),
    ['I' = 8, 'Start' = 8, 'Finish' = 11, 'Value' = 4],
    [
      step(
        chosen_from(1, 8),
        rule("weighted-interval-scheduling.pl", clause(17)),
        ['I' = 1, 'Chosen' = 8, 'Best' = 13, 'Next' = 2, 'Skip' = 12, 'Compatible' = 4, 'Tail' = 8, '_start' = 1, '_finish' = 4, 'Value' = 5, 'Take' = 13],
        [
          step(
            best_from(1, 13),
            rule("weighted-interval-scheduling.pl", clause(15)),
            ['I' = 1, 'Best' = 13, 'Last' = 8, 'Next' = 2, 'Skip' = 12, 'Compatible' = 4, 'Tail' = 8, '_start' = 1, '_finish' = 4, 'Value' = 5, 'Take' = 13],
            [
              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
              step(=<(1, 8), builtin(=<, 2), [], []),
              step(is(2, '+'(1, 1)), builtin(is, 2), [], []),
              step(
                best_from(2, 12),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 2, 'Best' = 12, 'Last' = 8, 'Next' = 3, 'Skip' = 12, 'Compatible' = 6, 'Tail' = 4, '_start' = 3, '_finish' = 5, 'Value' = 1, 'Take' = 5],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(2, 8), builtin(=<, 2), [], []),
                  step(is(3, '+'(2, 1)), builtin(is, 2), [], []),
                  step(
                    best_from(3, 12),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 3, 'Best' = 12, 'Last' = 8, 'Next' = 4, 'Skip' = 8, 'Compatible' = 7, 'Tail' = 4, '_start' = 0, '_finish' = 6, 'Value' = 8, 'Take' = 12],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(3, 8), builtin(=<, 2), [], []),
                      step(is(4, '+'(3, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(4, 8),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 4, 'Best' = 8, 'Last' = 8, 'Next' = 5, 'Skip' = 6, 'Compatible' = 8, 'Tail' = 4, '_start' = 4, '_finish' = 7, 'Value' = 4, 'Take' = 8],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(4, 8), builtin(=<, 2), [], []),
                          step(is(5, '+'(4, 1)), builtin(is, 2), [], []),
                          step(
                            best_from(5, 6),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 5, 'Best' = 6, 'Last' = 8, 'Next' = 6, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 3, '_finish' = 9, 'Value' = 6, 'Take' = 6],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(5, 8), builtin(=<, 2), [], []),
                              step(is(6, '+'(5, 1)), builtin(is, 2), [], []),
                              step(
                                best_from(6, 4),
                                rule("weighted-interval-scheduling.pl", clause(15)),
                                ['I' = 6, 'Best' = 4, 'Last' = 8, 'Next' = 7, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 5, '_finish' = 9, 'Value' = 3, 'Take' = 3],
                                [
                                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                                  step(=<(6, 8), builtin(=<, 2), [], []),
                                  step(is(7, '+'(6, 1)), builtin(is, 2), [], []),
                                  step(
                                    best_from(7, 4),
                                    rule("weighted-interval-scheduling.pl", clause(15)),
                                    ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                                    [
                                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                                      step(=<(7, 8), builtin(=<, 2), [], []),
                                      step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                                      step(
                                        best_from(8, 4),
                                        rule("weighted-interval-scheduling.pl", clause(15)),
                                        ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                                        [
                                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                                          step(=<(8, 8), builtin(=<, 2), [], []),
                                          step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                          step(
                                            next_compatible(8, 9),
                                            rule("weighted-interval-scheduling.pl", clause(13)),
                                            ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                            [
                                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                            ]
                                          ),
                                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                          step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                          step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                                          step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                                        ]
                                      ),
                                      step(
                                        next_compatible(7, 9),
                                        rule("weighted-interval-scheduling.pl", clause(13)),
                                        ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                                        [
                                          step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                                        ]
                                      ),
                                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                      step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                                      step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                                      step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                                    ]
                                  ),
                                  step(
                                    next_compatible(6, 9),
                                    rule("weighted-interval-scheduling.pl", clause(13)),
                                    ['I' = 6, '_start' = 5, 'Finish' = 9, '_value' = 3],
                                    [
                                      step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 6), >=(Startk, 9))), builtin('\\+', 1), [], [])
                                    ]
                                  ),
                                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                  step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                                  step(is(3, '+'(3, 0)), builtin(is, 2), [], []),
                                  step(';'(->(>=(3, 4), =(4, 3)), =(4, 4)), builtin(';', 2), [], [])
                                ]
                              ),
                              step(
                                next_compatible(5, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 5, '_start' = 3, 'Finish' = 9, '_value' = 6],
                                [
                                  step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 5), >=(Startk, 9))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                              step(is(6, '+'(6, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(6, 4), =(6, 6)), =(6, 4)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(
                            next_compatible(4, 8),
                            rule("weighted-interval-scheduling.pl", clause(12)),
                            ['I' = 4, 'J' = 8, '_start' = 4, 'Finish' = 7, '_value' = 4],
                            [
                              step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                              step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 4), >=(Startk, 7)), 8, 8), library(aggregate_min, 5), [], [])
                            ]
                          ),
                          step(
                            best_from(8, 4),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(8, 8), builtin(=<, 2), [], []),
                              step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(
                                next_compatible(8, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                [
                                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                          step(is(8, '+'(4, 4)), builtin(is, 2), [], []),
                          step(';'(->(>=(8, 6), =(8, 8)), =(8, 6)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(3, 7),
                        rule("weighted-interval-scheduling.pl", clause(12)),
                        ['I' = 3, 'J' = 7, '_start' = 0, 'Finish' = 6, '_value' = 8],
                        [
                          step(interval(3, 0, 6, 8), fact("weighted-interval-scheduling.pl", clause(6)), [], []),
                          step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 3), >=(Startk, 6)), 7, 7), library(aggregate_min, 5), [], [])
                        ]
                      ),
                      step(
                        best_from(7, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(7, 8), builtin(=<, 2), [], []),
                          step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                          step(
                            best_from(8, 4),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(8, 8), builtin(=<, 2), [], []),
                              step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(
                                next_compatible(8, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                [
                                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(
                            next_compatible(7, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                            [
                              step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                          step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(interval(3, 0, 6, 8), fact("weighted-interval-scheduling.pl", clause(6)), [], []),
                      step(is(12, '+'(8, 4)), builtin(is, 2), [], []),
                      step(';'(->(>=(12, 8), =(12, 12)), =(12, 8)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(
                    next_compatible(2, 6),
                    rule("weighted-interval-scheduling.pl", clause(12)),
                    ['I' = 2, 'J' = 6, '_start' = 3, 'Finish' = 5, '_value' = 1],
                    [
                      step(interval(2, 3, 5, 1), fact("weighted-interval-scheduling.pl", clause(5)), [], []),
                      step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 2), >=(Startk, 5)), 6, 6), library(aggregate_min, 5), [], [])
                    ]
                  ),
                  step(
                    best_from(6, 4),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 6, 'Best' = 4, 'Last' = 8, 'Next' = 7, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 5, '_finish' = 9, 'Value' = 3, 'Take' = 3],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(6, 8), builtin(=<, 2), [], []),
                      step(is(7, '+'(6, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(7, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(7, 8), builtin(=<, 2), [], []),
                          step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                          step(
                            best_from(8, 4),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(8, 8), builtin(=<, 2), [], []),
                              step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(
                                next_compatible(8, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                [
                                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(
                            next_compatible(7, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                            [
                              step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                          step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(6, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 6, '_start' = 5, 'Finish' = 9, '_value' = 3],
                        [
                          step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 6), >=(Startk, 9))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                      step(is(3, '+'(3, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(3, 4), =(4, 3)), =(4, 4)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(interval(2, 3, 5, 1), fact("weighted-interval-scheduling.pl", clause(5)), [], []),
                  step(is(5, '+'(1, 4)), builtin(is, 2), [], []),
                  step(';'(->(>=(5, 12), =(12, 5)), =(12, 12)), builtin(';', 2), [], [])
                ]
              ),
              step(
                next_compatible(1, 4),
                rule("weighted-interval-scheduling.pl", clause(12)),
                ['I' = 1, 'J' = 4, '_start' = 1, 'Finish' = 4, '_value' = 5],
                [
                  step(interval(1, 1, 4, 5), fact("weighted-interval-scheduling.pl", clause(4)), [], []),
                  step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 1), >=(Startk, 4)), 4, 4), library(aggregate_min, 5), [], [])
                ]
              ),
              step(
                best_from(4, 8),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 4, 'Best' = 8, 'Last' = 8, 'Next' = 5, 'Skip' = 6, 'Compatible' = 8, 'Tail' = 4, '_start' = 4, '_finish' = 7, 'Value' = 4, 'Take' = 8],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(4, 8), builtin(=<, 2), [], []),
                  step(is(5, '+'(4, 1)), builtin(is, 2), [], []),
                  step(
                    best_from(5, 6),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 5, 'Best' = 6, 'Last' = 8, 'Next' = 6, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 3, '_finish' = 9, 'Value' = 6, 'Take' = 6],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(5, 8), builtin(=<, 2), [], []),
                      step(is(6, '+'(5, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(6, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 6, 'Best' = 4, 'Last' = 8, 'Next' = 7, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 5, '_finish' = 9, 'Value' = 3, 'Take' = 3],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(6, 8), builtin(=<, 2), [], []),
                          step(is(7, '+'(6, 1)), builtin(is, 2), [], []),
                          step(
                            best_from(7, 4),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(7, 8), builtin(=<, 2), [], []),
                              step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                              step(
                                best_from(8, 4),
                                rule("weighted-interval-scheduling.pl", clause(15)),
                                ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                                [
                                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                                  step(=<(8, 8), builtin(=<, 2), [], []),
                                  step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                  step(
                                    next_compatible(8, 9),
                                    rule("weighted-interval-scheduling.pl", clause(13)),
                                    ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                    [
                                      step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                    ]
                                  ),
                                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                  step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                                  step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                                ]
                              ),
                              step(
                                next_compatible(7, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                                [
                                  step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                              step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(
                            next_compatible(6, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 6, '_start' = 5, 'Finish' = 9, '_value' = 3],
                            [
                              step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 6), >=(Startk, 9))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                          step(is(3, '+'(3, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(3, 4), =(4, 3)), =(4, 4)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(5, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 5, '_start' = 3, 'Finish' = 9, '_value' = 6],
                        [
                          step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 5), >=(Startk, 9))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                      step(is(6, '+'(6, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(6, 4), =(6, 6)), =(6, 4)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(
                    next_compatible(4, 8),
                    rule("weighted-interval-scheduling.pl", clause(12)),
                    ['I' = 4, 'J' = 8, '_start' = 4, 'Finish' = 7, '_value' = 4],
                    [
                      step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                      step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 4), >=(Startk, 7)), 8, 8), library(aggregate_min, 5), [], [])
                    ]
                  ),
                  step(
                    best_from(8, 4),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(8, 8), builtin(=<, 2), [], []),
                      step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(
                        next_compatible(8, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                        [
                          step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                      step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                  step(is(8, '+'(4, 4)), builtin(is, 2), [], []),
                  step(';'(->(>=(8, 6), =(8, 8)), =(8, 6)), builtin(';', 2), [], [])
                ]
              ),
              step(interval(1, 1, 4, 5), fact("weighted-interval-scheduling.pl", clause(4)), [], []),
              step(is(13, '+'(5, 8)), builtin(is, 2), [], []),
              step(';'(->(>=(13, 12), =(13, 13)), =(13, 12)), builtin(';', 2), [], [])
            ]
          ),
          step(is(2, '+'(1, 1)), builtin(is, 2), [], []),
          step(
            best_from(2, 12),
            rule("weighted-interval-scheduling.pl", clause(15)),
            ['I' = 2, 'Best' = 12, 'Last' = 8, 'Next' = 3, 'Skip' = 12, 'Compatible' = 6, 'Tail' = 4, '_start' = 3, '_finish' = 5, 'Value' = 1, 'Take' = 5],
            [
              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
              step(=<(2, 8), builtin(=<, 2), [], []),
              step(is(3, '+'(2, 1)), builtin(is, 2), [], []),
              step(
                best_from(3, 12),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 3, 'Best' = 12, 'Last' = 8, 'Next' = 4, 'Skip' = 8, 'Compatible' = 7, 'Tail' = 4, '_start' = 0, '_finish' = 6, 'Value' = 8, 'Take' = 12],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(3, 8), builtin(=<, 2), [], []),
                  step(is(4, '+'(3, 1)), builtin(is, 2), [], []),
                  step(
                    best_from(4, 8),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 4, 'Best' = 8, 'Last' = 8, 'Next' = 5, 'Skip' = 6, 'Compatible' = 8, 'Tail' = 4, '_start' = 4, '_finish' = 7, 'Value' = 4, 'Take' = 8],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(4, 8), builtin(=<, 2), [], []),
                      step(is(5, '+'(4, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(5, 6),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 5, 'Best' = 6, 'Last' = 8, 'Next' = 6, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 3, '_finish' = 9, 'Value' = 6, 'Take' = 6],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(5, 8), builtin(=<, 2), [], []),
                          step(is(6, '+'(5, 1)), builtin(is, 2), [], []),
                          step(
                            best_from(6, 4),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 6, 'Best' = 4, 'Last' = 8, 'Next' = 7, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 5, '_finish' = 9, 'Value' = 3, 'Take' = 3],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(6, 8), builtin(=<, 2), [], []),
                              step(is(7, '+'(6, 1)), builtin(is, 2), [], []),
                              step(
                                best_from(7, 4),
                                rule("weighted-interval-scheduling.pl", clause(15)),
                                ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                                [
                                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                                  step(=<(7, 8), builtin(=<, 2), [], []),
                                  step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                                  step(
                                    best_from(8, 4),
                                    rule("weighted-interval-scheduling.pl", clause(15)),
                                    ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                                    [
                                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                                      step(=<(8, 8), builtin(=<, 2), [], []),
                                      step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                      step(
                                        next_compatible(8, 9),
                                        rule("weighted-interval-scheduling.pl", clause(13)),
                                        ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                        [
                                          step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                        ]
                                      ),
                                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                      step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                      step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                                      step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                                    ]
                                  ),
                                  step(
                                    next_compatible(7, 9),
                                    rule("weighted-interval-scheduling.pl", clause(13)),
                                    ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                                    [
                                      step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                                    ]
                                  ),
                                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                  step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                                  step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                                  step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                                ]
                              ),
                              step(
                                next_compatible(6, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 6, '_start' = 5, 'Finish' = 9, '_value' = 3],
                                [
                                  step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 6), >=(Startk, 9))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                              step(is(3, '+'(3, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(3, 4), =(4, 3)), =(4, 4)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(
                            next_compatible(5, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 5, '_start' = 3, 'Finish' = 9, '_value' = 6],
                            [
                              step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 5), >=(Startk, 9))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                          step(is(6, '+'(6, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(6, 4), =(6, 6)), =(6, 4)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(4, 8),
                        rule("weighted-interval-scheduling.pl", clause(12)),
                        ['I' = 4, 'J' = 8, '_start' = 4, 'Finish' = 7, '_value' = 4],
                        [
                          step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                          step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 4), >=(Startk, 7)), 8, 8), library(aggregate_min, 5), [], [])
                        ]
                      ),
                      step(
                        best_from(8, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(8, 8), builtin(=<, 2), [], []),
                          step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(
                            next_compatible(8, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                            [
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                          step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                      step(is(8, '+'(4, 4)), builtin(is, 2), [], []),
                      step(';'(->(>=(8, 6), =(8, 8)), =(8, 6)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(
                    next_compatible(3, 7),
                    rule("weighted-interval-scheduling.pl", clause(12)),
                    ['I' = 3, 'J' = 7, '_start' = 0, 'Finish' = 6, '_value' = 8],
                    [
                      step(interval(3, 0, 6, 8), fact("weighted-interval-scheduling.pl", clause(6)), [], []),
                      step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 3), >=(Startk, 6)), 7, 7), library(aggregate_min, 5), [], [])
                    ]
                  ),
                  step(
                    best_from(7, 4),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(7, 8), builtin(=<, 2), [], []),
                      step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(8, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(8, 8), builtin(=<, 2), [], []),
                          step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(
                            next_compatible(8, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                            [
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                          step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(7, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                        [
                          step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                      step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(interval(3, 0, 6, 8), fact("weighted-interval-scheduling.pl", clause(6)), [], []),
                  step(is(12, '+'(8, 4)), builtin(is, 2), [], []),
                  step(';'(->(>=(12, 8), =(12, 12)), =(12, 8)), builtin(';', 2), [], [])
                ]
              ),
              step(
                next_compatible(2, 6),
                rule("weighted-interval-scheduling.pl", clause(12)),
                ['I' = 2, 'J' = 6, '_start' = 3, 'Finish' = 5, '_value' = 1],
                [
                  step(interval(2, 3, 5, 1), fact("weighted-interval-scheduling.pl", clause(5)), [], []),
                  step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 2), >=(Startk, 5)), 6, 6), library(aggregate_min, 5), [], [])
                ]
              ),
              step(
                best_from(6, 4),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 6, 'Best' = 4, 'Last' = 8, 'Next' = 7, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 5, '_finish' = 9, 'Value' = 3, 'Take' = 3],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(6, 8), builtin(=<, 2), [], []),
                  step(is(7, '+'(6, 1)), builtin(is, 2), [], []),
                  step(
                    best_from(7, 4),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(7, 8), builtin(=<, 2), [], []),
                      step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(8, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(8, 8), builtin(=<, 2), [], []),
                          step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(
                            next_compatible(8, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                            [
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                          step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(7, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                        [
                          step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                      step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(
                    next_compatible(6, 9),
                    rule("weighted-interval-scheduling.pl", clause(13)),
                    ['I' = 6, '_start' = 5, 'Finish' = 9, '_value' = 3],
                    [
                      step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 6), >=(Startk, 9))), builtin('\\+', 1), [], [])
                    ]
                  ),
                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                  step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                  step(is(3, '+'(3, 0)), builtin(is, 2), [], []),
                  step(';'(->(>=(3, 4), =(4, 3)), =(4, 4)), builtin(';', 2), [], [])
                ]
              ),
              step(interval(2, 3, 5, 1), fact("weighted-interval-scheduling.pl", clause(5)), [], []),
              step(is(5, '+'(1, 4)), builtin(is, 2), [], []),
              step(';'(->(>=(5, 12), =(12, 5)), =(12, 12)), builtin(';', 2), [], [])
            ]
          ),
          step(
            next_compatible(1, 4),
            rule("weighted-interval-scheduling.pl", clause(12)),
            ['I' = 1, 'J' = 4, '_start' = 1, 'Finish' = 4, '_value' = 5],
            [
              step(interval(1, 1, 4, 5), fact("weighted-interval-scheduling.pl", clause(4)), [], []),
              step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 1), >=(Startk, 4)), 4, 4), library(aggregate_min, 5), [], [])
            ]
          ),
          step(
            best_from(4, 8),
            rule("weighted-interval-scheduling.pl", clause(15)),
            ['I' = 4, 'Best' = 8, 'Last' = 8, 'Next' = 5, 'Skip' = 6, 'Compatible' = 8, 'Tail' = 4, '_start' = 4, '_finish' = 7, 'Value' = 4, 'Take' = 8],
            [
              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
              step(=<(4, 8), builtin(=<, 2), [], []),
              step(is(5, '+'(4, 1)), builtin(is, 2), [], []),
              step(
                best_from(5, 6),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 5, 'Best' = 6, 'Last' = 8, 'Next' = 6, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 3, '_finish' = 9, 'Value' = 6, 'Take' = 6],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(5, 8), builtin(=<, 2), [], []),
                  step(is(6, '+'(5, 1)), builtin(is, 2), [], []),
                  step(
                    best_from(6, 4),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 6, 'Best' = 4, 'Last' = 8, 'Next' = 7, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 5, '_finish' = 9, 'Value' = 3, 'Take' = 3],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(6, 8), builtin(=<, 2), [], []),
                      step(is(7, '+'(6, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(7, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(7, 8), builtin(=<, 2), [], []),
                          step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                          step(
                            best_from(8, 4),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(8, 8), builtin(=<, 2), [], []),
                              step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(
                                next_compatible(8, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                [
                                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(
                            next_compatible(7, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                            [
                              step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                          step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(6, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 6, '_start' = 5, 'Finish' = 9, '_value' = 3],
                        [
                          step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 6), >=(Startk, 9))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                      step(is(3, '+'(3, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(3, 4), =(4, 3)), =(4, 4)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(
                    next_compatible(5, 9),
                    rule("weighted-interval-scheduling.pl", clause(13)),
                    ['I' = 5, '_start' = 3, 'Finish' = 9, '_value' = 6],
                    [
                      step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 5), >=(Startk, 9))), builtin('\\+', 1), [], [])
                    ]
                  ),
                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                  step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                  step(is(6, '+'(6, 0)), builtin(is, 2), [], []),
                  step(';'(->(>=(6, 4), =(6, 6)), =(6, 4)), builtin(';', 2), [], [])
                ]
              ),
              step(
                next_compatible(4, 8),
                rule("weighted-interval-scheduling.pl", clause(12)),
                ['I' = 4, 'J' = 8, '_start' = 4, 'Finish' = 7, '_value' = 4],
                [
                  step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                  step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 4), >=(Startk, 7)), 8, 8), library(aggregate_min, 5), [], [])
                ]
              ),
              step(
                best_from(8, 4),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(8, 8), builtin(=<, 2), [], []),
                  step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                  step(
                    next_compatible(8, 9),
                    rule("weighted-interval-scheduling.pl", clause(13)),
                    ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                    [
                      step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                    ]
                  ),
                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                  step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                  step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                ]
              ),
              step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
              step(is(8, '+'(4, 4)), builtin(is, 2), [], []),
              step(';'(->(>=(8, 6), =(8, 8)), =(8, 6)), builtin(';', 2), [], [])
            ]
          ),
          step(interval(1, 1, 4, 5), fact("weighted-interval-scheduling.pl", clause(4)), [], []),
          step(is(13, '+'(5, 8)), builtin(is, 2), [], []),
          step(=(13, 13), builtin(=, 2), [], []),
          step(>=(13, 12), builtin(>=, 2), [], []),
          step(
            chosen_from(4, 8),
            rule("weighted-interval-scheduling.pl", clause(17)),
            ['I' = 4, 'Chosen' = 8, 'Best' = 8, 'Next' = 5, 'Skip' = 6, 'Compatible' = 8, 'Tail' = 4, '_start' = 4, '_finish' = 7, 'Value' = 4, 'Take' = 8],
            [
              step(
                best_from(4, 8),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 4, 'Best' = 8, 'Last' = 8, 'Next' = 5, 'Skip' = 6, 'Compatible' = 8, 'Tail' = 4, '_start' = 4, '_finish' = 7, 'Value' = 4, 'Take' = 8],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(4, 8), builtin(=<, 2), [], []),
                  step(is(5, '+'(4, 1)), builtin(is, 2), [], []),
                  step(
                    best_from(5, 6),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 5, 'Best' = 6, 'Last' = 8, 'Next' = 6, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 3, '_finish' = 9, 'Value' = 6, 'Take' = 6],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(5, 8), builtin(=<, 2), [], []),
                      step(is(6, '+'(5, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(6, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 6, 'Best' = 4, 'Last' = 8, 'Next' = 7, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 5, '_finish' = 9, 'Value' = 3, 'Take' = 3],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(6, 8), builtin(=<, 2), [], []),
                          step(is(7, '+'(6, 1)), builtin(is, 2), [], []),
                          step(
                            best_from(7, 4),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(7, 8), builtin(=<, 2), [], []),
                              step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                              step(
                                best_from(8, 4),
                                rule("weighted-interval-scheduling.pl", clause(15)),
                                ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                                [
                                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                                  step(=<(8, 8), builtin(=<, 2), [], []),
                                  step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                  step(
                                    next_compatible(8, 9),
                                    rule("weighted-interval-scheduling.pl", clause(13)),
                                    ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                    [
                                      step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                    ]
                                  ),
                                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                  step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                                  step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                                ]
                              ),
                              step(
                                next_compatible(7, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                                [
                                  step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                              step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(
                            next_compatible(6, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 6, '_start' = 5, 'Finish' = 9, '_value' = 3],
                            [
                              step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 6), >=(Startk, 9))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                          step(is(3, '+'(3, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(3, 4), =(4, 3)), =(4, 4)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(5, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 5, '_start' = 3, 'Finish' = 9, '_value' = 6],
                        [
                          step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 5), >=(Startk, 9))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                      step(is(6, '+'(6, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(6, 4), =(6, 6)), =(6, 4)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(
                    next_compatible(4, 8),
                    rule("weighted-interval-scheduling.pl", clause(12)),
                    ['I' = 4, 'J' = 8, '_start' = 4, 'Finish' = 7, '_value' = 4],
                    [
                      step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                      step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 4), >=(Startk, 7)), 8, 8), library(aggregate_min, 5), [], [])
                    ]
                  ),
                  step(
                    best_from(8, 4),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(8, 8), builtin(=<, 2), [], []),
                      step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(
                        next_compatible(8, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                        [
                          step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                      step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                  step(is(8, '+'(4, 4)), builtin(is, 2), [], []),
                  step(';'(->(>=(8, 6), =(8, 8)), =(8, 6)), builtin(';', 2), [], [])
                ]
              ),
              step(is(5, '+'(4, 1)), builtin(is, 2), [], []),
              step(
                best_from(5, 6),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 5, 'Best' = 6, 'Last' = 8, 'Next' = 6, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 3, '_finish' = 9, 'Value' = 6, 'Take' = 6],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(5, 8), builtin(=<, 2), [], []),
                  step(is(6, '+'(5, 1)), builtin(is, 2), [], []),
                  step(
                    best_from(6, 4),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 6, 'Best' = 4, 'Last' = 8, 'Next' = 7, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 5, '_finish' = 9, 'Value' = 3, 'Take' = 3],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(6, 8), builtin(=<, 2), [], []),
                      step(is(7, '+'(6, 1)), builtin(is, 2), [], []),
                      step(
                        best_from(7, 4),
                        rule("weighted-interval-scheduling.pl", clause(15)),
                        ['I' = 7, 'Best' = 4, 'Last' = 8, 'Next' = 8, 'Skip' = 4, 'Compatible' = 9, 'Tail' = 0, '_start' = 6, '_finish' = 10, 'Value' = 2, 'Take' = 2],
                        [
                          step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                          step(=<(7, 8), builtin(=<, 2), [], []),
                          step(is(8, '+'(7, 1)), builtin(is, 2), [], []),
                          step(
                            best_from(8, 4),
                            rule("weighted-interval-scheduling.pl", clause(15)),
                            ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                            [
                              step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                              step(=<(8, 8), builtin(=<, 2), [], []),
                              step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(
                                next_compatible(8, 9),
                                rule("weighted-interval-scheduling.pl", clause(13)),
                                ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                                [
                                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                                  step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                                ]
                              ),
                              step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                              step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                              step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                              step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                            ]
                          ),
                          step(
                            next_compatible(7, 9),
                            rule("weighted-interval-scheduling.pl", clause(13)),
                            ['I' = 7, '_start' = 6, 'Finish' = 10, '_value' = 2],
                            [
                              step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                              step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 7), >=(Startk, 10))), builtin('\\+', 1), [], [])
                            ]
                          ),
                          step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                          step(interval(7, 6, 10, 2), fact("weighted-interval-scheduling.pl", clause(10)), [], []),
                          step(is(2, '+'(2, 0)), builtin(is, 2), [], []),
                          step(';'(->(>=(2, 4), =(4, 2)), =(4, 4)), builtin(';', 2), [], [])
                        ]
                      ),
                      step(
                        next_compatible(6, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 6, '_start' = 5, 'Finish' = 9, '_value' = 3],
                        [
                          step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 6), >=(Startk, 9))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(6, 5, 9, 3), fact("weighted-interval-scheduling.pl", clause(9)), [], []),
                      step(is(3, '+'(3, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(3, 4), =(4, 3)), =(4, 4)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(
                    next_compatible(5, 9),
                    rule("weighted-interval-scheduling.pl", clause(13)),
                    ['I' = 5, '_start' = 3, 'Finish' = 9, '_value' = 6],
                    [
                      step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 5), >=(Startk, 9))), builtin('\\+', 1), [], [])
                    ]
                  ),
                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                  step(interval(5, 3, 9, 6), fact("weighted-interval-scheduling.pl", clause(8)), [], []),
                  step(is(6, '+'(6, 0)), builtin(is, 2), [], []),
                  step(';'(->(>=(6, 4), =(6, 6)), =(6, 4)), builtin(';', 2), [], [])
                ]
              ),
              step(
                next_compatible(4, 8),
                rule("weighted-interval-scheduling.pl", clause(12)),
                ['I' = 4, 'J' = 8, '_start' = 4, 'Finish' = 7, '_value' = 4],
                [
                  step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
                  step(aggregate_min(Value, Value, (interval(Value, Startk, _finishk, _valuek), >(Value, 4), >=(Startk, 7)), 8, 8), library(aggregate_min, 5), [], [])
                ]
              ),
              step(
                best_from(8, 4),
                rule("weighted-interval-scheduling.pl", clause(15)),
                ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                [
                  step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                  step(=<(8, 8), builtin(=<, 2), [], []),
                  step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                  step(
                    next_compatible(8, 9),
                    rule("weighted-interval-scheduling.pl", clause(13)),
                    ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                    [
                      step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                    ]
                  ),
                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                  step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                  step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                ]
              ),
              step(interval(4, 4, 7, 4), fact("weighted-interval-scheduling.pl", clause(7)), [], []),
              step(is(8, '+'(4, 4)), builtin(is, 2), [], []),
              step(=(8, 8), builtin(=, 2), [], []),
              step(>=(8, 6), builtin(>=, 2), [], []),
              step(
                chosen_from(8, 8),
                rule("weighted-interval-scheduling.pl", clause(16)),
                ['I' = 8, 'Best' = 4, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                [
                  step(
                    best_from(8, 4),
                    rule("weighted-interval-scheduling.pl", clause(15)),
                    ['I' = 8, 'Best' = 4, 'Last' = 8, 'Next' = 9, 'Skip' = 0, 'Compatible' = 9, 'Tail' = 0, '_start' = 8, '_finish' = 11, 'Value' = 4, 'Take' = 4],
                    [
                      step(last_interval(8), fact("weighted-interval-scheduling.pl", clause(2)), [], []),
                      step(=<(8, 8), builtin(=<, 2), [], []),
                      step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(
                        next_compatible(8, 9),
                        rule("weighted-interval-scheduling.pl", clause(13)),
                        ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                        [
                          step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                          step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                        ]
                      ),
                      step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                      step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                      step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                      step(';'(->(>=(4, 0), =(4, 4)), =(4, 0)), builtin(';', 2), [], [])
                    ]
                  ),
                  step(is(9, '+'(8, 1)), builtin(is, 2), [], []),
                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                  step(
                    next_compatible(8, 9),
                    rule("weighted-interval-scheduling.pl", clause(13)),
                    ['I' = 8, '_start' = 8, 'Finish' = 11, '_value' = 4],
                    [
                      step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                      step('\\+'((interval(K, Startk, _finishk, _valuek), >(K, 8), >=(Startk, 11))), builtin('\\+', 1), [], [])
                    ]
                  ),
                  step(best_from(9, 0), fact("weighted-interval-scheduling.pl", clause(14)), [], []),
                  step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], []),
                  step(is(4, '+'(4, 0)), builtin(is, 2), [], []),
                  step(=(4, 4), builtin(=, 2), [], []),
                  step(>=(4, 0), builtin(>=, 2), [], [])
                ]
              )
            ]
          )
        ]
      ),
      step(interval(8, 8, 11, 4), fact("weighted-interval-scheduling.pl", clause(11)), [], [])
    ]
  )
).

weighted_interval_answer(candidate_count, 8).
why(
  weighted_interval_answer(candidate_count, 8),
  step(
    weighted_interval_answer(candidate_count, 8),
    rule("weighted-interval-scheduling.pl", clause(21)),
    ['Count' = 8],
    [
      step(countall(interval(_i, _start, _finish, _value), 8), library(countall, 2), [], [])
    ]
  )
).

