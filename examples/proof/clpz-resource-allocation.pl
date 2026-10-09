clpz_example(allocation, plan([2, 3, 1], durations([3, 2, 7]), 12)).
clpz_example(allocation, plan([3, 1, 2], durations([4, 4, 2]), 10)).
clpz_example(domain, domain(2, 7, 4, 2..4 \/ 7)).

clause(1,
       clpz_example(allocation, plan([var('A'), var('B'), var('C')], durations([var('DA'), var('DB'), var('DC')]), var('Total'))),
       ([var('A'), var('B'), var('C')] ins 1..3,
        all_distinct([var('A'), var('B'), var('C')]),
        scalar_product([1, 2, 3], [var('A'), var('B'), var('C')], #=, 11),
        element(var('A'), [5, 3, 4], var('DA')),
        element(var('B'), [4, 6, 2], var('DB')),
        element(var('C'), [7, 2, 5], var('DC')),
        chain(#>=, [var('DA'), var('DB')]),
        sum([var('DA'), var('DB'), var('DC')], #=, var('Total')),
        (integer(var('Fast')) -> between:between(0, 1, var('Fast')) ; clpz:clpz_in(var('Fast'), 0..1)),
        var('Fast') #<==> var('Total') #=< 12,
        (integer(var('Fast')) -> var('Fast') =:= 1 ; true, var(var('Fast')) -> var('Fast') = 1 ; var('Var#1') = 1, clpz:clpz_equal(var('Fast'), var('Var#1'))),
        labeling([ff, down], [var('A'), var('B'), var('C'), var('Fast')]))).
clause(2,
       clpz_example(domain, domain(var('Infimum'), var('Supremum'), var('Size'), var('Domain'))),
       (clpz:clpz_in(var('X'), 2..4 \/ 7),
        fd_var(var('X')),
        fd_inf(var('X'), var('Infimum')),
        fd_sup(var('X'), var('Supremum')),
        fd_size(var('X'), var('Size')),
        fd_dom(var('X'), var('Domain')))).

step(clpz_example(allocation, plan([2, 3, 1], durations([3, 2, 7]), 12)),
     rule(1),
     ['A' = 2, 'B' = 3, 'C' = 1, 'DA' = 3, 'DB' = 2, 'DC' = 7, 'Total' = 12, 'Fast' = 1],
     [[2, 3, 1] ins 1..3,
      all_distinct([2, 3, 1]),
      scalar_product([1, 2, 3], [2, 3, 1], #=, 11),
      element(2, [5, 3, 4], 3),
      element(3, [4, 6, 2], 2),
      element(1, [7, 2, 5], 7),
      chain(#>=, [3, 2]),
      sum([3, 2, 7], #=, 12),
      (integer(1) -> between:between(0, 1, 1) ; clpz:clpz_in(1, 0..1)),
      1 #<==> 12 #=< 12,
      (integer(1) -> 1 =:= 1 ; true, var(1) -> 1 = 1 ; Var_1 = 1, clpz:clpz_equal(1, Var_1)),
      labeling([ff, down], [2, 3, 1, 1])]).
step([2, 3, 1] ins 1..3, builtin, [], []).
step(all_distinct([2, 3, 1]), builtin, [], []).
step(scalar_product([1, 2, 3], [2, 3, 1], #=, 11), builtin, [], []).
step(element(2, [5, 3, 4], 3), builtin, [], []).
step(element(3, [4, 6, 2], 2), builtin, [], []).
step(element(1, [7, 2, 5], 7), builtin, [], []).
step(chain(#>=, [3, 2]), builtin, [], []).
step(sum([3, 2, 7], #=, 12), builtin, [], []).
step((integer(1) -> between:between(0, 1, 1) ; clpz:clpz_in(1, 0..1)), builtin, [], []).
step(1 #<==> 12 #=< 12, builtin, [], []).
step((integer(1) -> 1 =:= 1 ; true, var(1) -> 1 = 1 ; Var_1 = 1, clpz:clpz_equal(1, Var_1)),
     builtin,
     [],
     []).
step(labeling([ff, down], [2, 3, 1, 1]), builtin, [], []).
step(clpz_example(allocation, plan([3, 1, 2], durations([4, 4, 2]), 10)),
     rule(1),
     ['A' = 3, 'B' = 1, 'C' = 2, 'DA' = 4, 'DB' = 4, 'DC' = 2, 'Total' = 10, 'Fast' = 1],
     [[3, 1, 2] ins 1..3,
      all_distinct([3, 1, 2]),
      scalar_product([1, 2, 3], [3, 1, 2], #=, 11),
      element(3, [5, 3, 4], 4),
      element(1, [4, 6, 2], 4),
      element(2, [7, 2, 5], 2),
      chain(#>=, [4, 4]),
      sum([4, 4, 2], #=, 10),
      (integer(1) -> between:between(0, 1, 1) ; clpz:clpz_in(1, 0..1)),
      1 #<==> 10 #=< 12,
      (integer(1) -> 1 =:= 1 ; true, var(1) -> 1 = 1 ; Var_1 = 1, clpz:clpz_equal(1, Var_1)),
      labeling([ff, down], [3, 1, 2, 1])]).
step([3, 1, 2] ins 1..3, builtin, [], []).
step(all_distinct([3, 1, 2]), builtin, [], []).
step(scalar_product([1, 2, 3], [3, 1, 2], #=, 11), builtin, [], []).
step(element(3, [5, 3, 4], 4), builtin, [], []).
step(element(1, [4, 6, 2], 4), builtin, [], []).
step(element(2, [7, 2, 5], 2), builtin, [], []).
step(chain(#>=, [4, 4]), builtin, [], []).
step(sum([4, 4, 2], #=, 10), builtin, [], []).
step(1 #<==> 10 #=< 12, builtin, [], []).
step(labeling([ff, down], [3, 1, 2, 1]), builtin, [], []).
step(clpz_example(domain, domain(2, 7, 4, 2..4 \/ 7)),
     rule(2),
     ['Infimum' = 2, 'Supremum' = 7, 'Size' = 4, 'Domain' = 2..4 \/ 7],
     [clpz:clpz_in(X, 2..4 \/ 7),
      fd_var(X),
      fd_inf(X, 2),
      fd_sup(X, 7),
      fd_size(X, 4),
      fd_dom(X, 2..4 \/ 7)]).
step(clpz:clpz_in(X, 2..4 \/ 7), builtin, [], []).
step(fd_var(X), builtin, [], []).
step(fd_inf(X, 2), builtin, [], []).
step(fd_sup(X, 7), builtin, [], []).
step(fd_size(X, 4), builtin, [], []).
step(fd_dom(X, 2..4 \/ 7), builtin, [], []).
