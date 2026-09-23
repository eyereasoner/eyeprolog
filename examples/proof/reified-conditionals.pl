answer([2, 4, 6, 8], [1, 3, 5, 7], even, odd).

clause(3,
       answer(var('Evens'), var('Odds'), var('First'), var('Second')),
       (tfilter(even_t, [1, 2, 3, 4, 5, 6, 7, 8], var('Evens')),
        tpartition(even_t, [1, 2, 3, 4, 5, 6, 7, 8], anonymous(1), var('Odds')),
        if_(even_t(4), var('First') = even, var('First') = odd),
        if_(even_t(7), var('Second') = even, var('Second') = odd))).

step(answer([2, 4, 6, 8], [1, 3, 5, 7], even, odd),
     rule(3),
     ['Evens' = [2, 4, 6, 8], 'Odds' = [1, 3, 5, 7], 'First' = even, 'Second' = odd],
     [tfilter(even_t, [1, 2, 3, 4, 5, 6, 7, 8], [2, 4, 6, 8]),
      tpartition(even_t, [1, 2, 3, 4, 5, 6, 7, 8], [2, 4, 6, 8], [1, 3, 5, 7]),
      if_(even_t(4), even = even, even = odd),
      if_(even_t(7), odd = even, odd = odd)]).
step(tfilter(even_t, [1, 2, 3, 4, 5, 6, 7, 8], [2, 4, 6, 8]), builtin, [], []).
step(tpartition(even_t, [1, 2, 3, 4, 5, 6, 7, 8], [2, 4, 6, 8], [1, 3, 5, 7]), builtin, [], []).
step(if_(even_t(4), even = even, even = odd), builtin, [], []).
step(if_(even_t(7), odd = even, odd = odd), builtin, [], []).
