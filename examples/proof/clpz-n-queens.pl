queens8_witness([1, 5, 8, 6, 3, 7, 2, 4]).
queens(4, [2, 4, 1, 3]).
queens(4, [3, 1, 4, 2]).

clause(1,
       queens8_witness(var('Rows')),
       (var('Rows') = [1, 5, 8, 6, 3, 7, 2, 4], queens(8, var('Rows')))).
clause(2,
       queens(var('Size'), var('Rows')),
       (length(var('Rows'), var('Size')),
        var('Rows') ins 1..var('Size'),
        all_distinct(var('Rows')),
        safe_diagonals(var('Rows')),
        labeling([ff], var('Rows')))).
clause(3, safe_diagonals([]), true).
clause(4,
       safe_diagonals([var('Row') | var('Rows')]),
       (safe_from(var('Row'), var('Rows'), 1), safe_diagonals(var('Rows')))).
clause(5, safe_from(anonymous(1), [], anonymous(2)), true).
clause(6,
       safe_from(var('Row'), [var('Other') | var('Rows')], var('Distance')),
       ((integer(var('Row')) -> (integer(var('Other')), integer(var('Distance')) -> var('Row') =\= var('Other') + var('Distance') ; var('T#1') is var('Row'), clpz:clpz_neq(var('T#1'), var('Other') + var('Distance'))) ; integer(var('Other')), integer(var('Distance')) -> var('T#1') is var('Other') + var('Distance'), clpz:clpz_neq(var('Row'), var('T#1')) ; clpz:clpz_neq(var('Row'), var('Other') + var('Distance'))),
        (integer(var('Row')) -> (integer(var('Other')), integer(var('Distance')) -> var('Row') =\= var('Other') - var('Distance') ; var('T#2') is var('Row'), clpz:clpz_neq(var('T#2'), var('Other') - var('Distance'))) ; integer(var('Other')), integer(var('Distance')) -> var('T#2') is var('Other') - var('Distance'), clpz:clpz_neq(var('Row'), var('T#2')) ; clpz:clpz_neq(var('Row'), var('Other') - var('Distance'))),
        var('NextDistance') is var('Distance') + 1,
        safe_from(var('Row'), var('Rows'), var('NextDistance')))).

step(queens8_witness([1, 5, 8, 6, 3, 7, 2, 4]),
     rule(1),
     ['Rows' = [1, 5, 8, 6, 3, 7, 2, 4]],
     [[1, 5, 8, 6, 3, 7, 2, 4] = [1, 5, 8, 6, 3, 7, 2, 4], queens(8, [1, 5, 8, 6, 3, 7, 2, 4])]).
step([1, 5, 8, 6, 3, 7, 2, 4] = [1, 5, 8, 6, 3, 7, 2, 4], builtin, [], []).
step(queens(8, [1, 5, 8, 6, 3, 7, 2, 4]),
     rule(2),
     ['Size' = 8, 'Rows' = [1, 5, 8, 6, 3, 7, 2, 4]],
     [length([1, 5, 8, 6, 3, 7, 2, 4], 8),
      [1, 5, 8, 6, 3, 7, 2, 4] ins 1..8,
      all_distinct([1, 5, 8, 6, 3, 7, 2, 4]),
      safe_diagonals([1, 5, 8, 6, 3, 7, 2, 4]),
      labeling([ff], [1, 5, 8, 6, 3, 7, 2, 4])]).
step(length([1, 5, 8, 6, 3, 7, 2, 4], 8), builtin, [], []).
step([1, 5, 8, 6, 3, 7, 2, 4] ins 1..8, builtin, [], []).
step(all_distinct([1, 5, 8, 6, 3, 7, 2, 4]), builtin, [], []).
step(safe_diagonals([1, 5, 8, 6, 3, 7, 2, 4]),
     rule(4),
     ['Row' = 1, 'Rows' = [5, 8, 6, 3, 7, 2, 4]],
     [safe_from(1, [5, 8, 6, 3, 7, 2, 4], 1), safe_diagonals([5, 8, 6, 3, 7, 2, 4])]).
step(safe_from(1, [5, 8, 6, 3, 7, 2, 4], 1),
     rule(6),
     ['Row' = 1, 'Other' = 5, 'Rows' = [8, 6, 3, 7, 2, 4], 'Distance' = 1, 'NextDistance' = 2],
     [(integer(1) -> (integer(5), integer(1) -> 1 =\= 5 + 1 ; T_1 is 1, clpz:clpz_neq(T_1, 5 + 1)) ; integer(5), integer(1) -> T_1 is 5 + 1, clpz:clpz_neq(1, T_1) ; clpz:clpz_neq(1, 5 + 1)),
      (integer(1) -> (integer(5), integer(1) -> 1 =\= 5 - 1 ; T_2 is 1, clpz:clpz_neq(T_2, 5 - 1)) ; integer(5), integer(1) -> T_2 is 5 - 1, clpz:clpz_neq(1, T_2) ; clpz:clpz_neq(1, 5 - 1)),
      2 is 1 + 1,
      safe_from(1, [8, 6, 3, 7, 2, 4], 2)]).
step((integer(1) -> (integer(5), integer(1) -> 1 =\= 5 + 1 ; T_1 is 1, clpz:clpz_neq(T_1, 5 + 1)) ; integer(5), integer(1) -> T_1 is 5 + 1, clpz:clpz_neq(1, T_1) ; clpz:clpz_neq(1, 5 + 1)),
     builtin,
     [],
     []).
step((integer(1) -> (integer(5), integer(1) -> 1 =\= 5 - 1 ; T_2 is 1, clpz:clpz_neq(T_2, 5 - 1)) ; integer(5), integer(1) -> T_2 is 5 - 1, clpz:clpz_neq(1, T_2) ; clpz:clpz_neq(1, 5 - 1)),
     builtin,
     [],
     []).
step(2 is 1 + 1, builtin, [], []).
step(safe_from(1, [8, 6, 3, 7, 2, 4], 2),
     rule(6),
     ['Row' = 1, 'Other' = 8, 'Rows' = [6, 3, 7, 2, 4], 'Distance' = 2, 'NextDistance' = 3],
     [(integer(1) -> (integer(8), integer(2) -> 1 =\= 8 + 2 ; T_1 is 1, clpz:clpz_neq(T_1, 8 + 2)) ; integer(8), integer(2) -> T_1 is 8 + 2, clpz:clpz_neq(1, T_1) ; clpz:clpz_neq(1, 8 + 2)),
      (integer(1) -> (integer(8), integer(2) -> 1 =\= 8 - 2 ; T_2 is 1, clpz:clpz_neq(T_2, 8 - 2)) ; integer(8), integer(2) -> T_2 is 8 - 2, clpz:clpz_neq(1, T_2) ; clpz:clpz_neq(1, 8 - 2)),
      3 is 2 + 1,
      safe_from(1, [6, 3, 7, 2, 4], 3)]).
step((integer(1) -> (integer(8), integer(2) -> 1 =\= 8 + 2 ; T_1 is 1, clpz:clpz_neq(T_1, 8 + 2)) ; integer(8), integer(2) -> T_1 is 8 + 2, clpz:clpz_neq(1, T_1) ; clpz:clpz_neq(1, 8 + 2)),
     builtin,
     [],
     []).
step((integer(1) -> (integer(8), integer(2) -> 1 =\= 8 - 2 ; T_2 is 1, clpz:clpz_neq(T_2, 8 - 2)) ; integer(8), integer(2) -> T_2 is 8 - 2, clpz:clpz_neq(1, T_2) ; clpz:clpz_neq(1, 8 - 2)),
     builtin,
     [],
     []).
step(3 is 2 + 1, builtin, [], []).
step(safe_from(1, [6, 3, 7, 2, 4], 3),
     rule(6),
     ['Row' = 1, 'Other' = 6, 'Rows' = [3, 7, 2, 4], 'Distance' = 3, 'NextDistance' = 4],
     [(integer(1) -> (integer(6), integer(3) -> 1 =\= 6 + 3 ; T_1 is 1, clpz:clpz_neq(T_1, 6 + 3)) ; integer(6), integer(3) -> T_1 is 6 + 3, clpz:clpz_neq(1, T_1) ; clpz:clpz_neq(1, 6 + 3)),
      (integer(1) -> (integer(6), integer(3) -> 1 =\= 6 - 3 ; T_2 is 1, clpz:clpz_neq(T_2, 6 - 3)) ; integer(6), integer(3) -> T_2 is 6 - 3, clpz:clpz_neq(1, T_2) ; clpz:clpz_neq(1, 6 - 3)),
      4 is 3 + 1,
      safe_from(1, [3, 7, 2, 4], 4)]).
step((integer(1) -> (integer(6), integer(3) -> 1 =\= 6 + 3 ; T_1 is 1, clpz:clpz_neq(T_1, 6 + 3)) ; integer(6), integer(3) -> T_1 is 6 + 3, clpz:clpz_neq(1, T_1) ; clpz:clpz_neq(1, 6 + 3)),
     builtin,
     [],
     []).
step((integer(1) -> (integer(6), integer(3) -> 1 =\= 6 - 3 ; T_2 is 1, clpz:clpz_neq(T_2, 6 - 3)) ; integer(6), integer(3) -> T_2 is 6 - 3, clpz:clpz_neq(1, T_2) ; clpz:clpz_neq(1, 6 - 3)),
     builtin,
     [],
     []).
step(4 is 3 + 1, builtin, [], []).
step(safe_from(1, [3, 7, 2, 4], 4),
     rule(6),
     ['Row' = 1, 'Other' = 3, 'Rows' = [7, 2, 4], 'Distance' = 4, 'NextDistance' = 5],
     [(integer(1) -> (integer(3), integer(4) -> 1 =\= 3 + 4 ; T_1 is 1, clpz:clpz_neq(T_1, 3 + 4)) ; integer(3), integer(4) -> T_1 is 3 + 4, clpz:clpz_neq(1, T_1) ; clpz:clpz_neq(1, 3 + 4)),
      (integer(1) -> (integer(3), integer(4) -> 1 =\= 3 - 4 ; T_2 is 1, clpz:clpz_neq(T_2, 3 - 4)) ; integer(3), integer(4) -> T_2 is 3 - 4, clpz:clpz_neq(1, T_2) ; clpz:clpz_neq(1, 3 - 4)),
      5 is 4 + 1,
      safe_from(1, [7, 2, 4], 5)]).
step((integer(1) -> (integer(3), integer(4) -> 1 =\= 3 + 4 ; T_1 is 1, clpz:clpz_neq(T_1, 3 + 4)) ; integer(3), integer(4) -> T_1 is 3 + 4, clpz:clpz_neq(1, T_1) ; clpz:clpz_neq(1, 3 + 4)),
     builtin,
     [],
     []).
step((integer(1) -> (integer(3), integer(4) -> 1 =\= 3 - 4 ; T_2 is 1, clpz:clpz_neq(T_2, 3 - 4)) ; integer(3), integer(4) -> T_2 is 3 - 4, clpz:clpz_neq(1, T_2) ; clpz:clpz_neq(1, 3 - 4)),
     builtin,
     [],
     []).
step(5 is 4 + 1, builtin, [], []).
step(safe_from(1, [7, 2, 4], 5),
     rule(6),
     ['Row' = 1, 'Other' = 7, 'Rows' = [2, 4], 'Distance' = 5, 'NextDistance' = 6],
     [(integer(1) -> (integer(7), integer(5) -> 1 =\= 7 + 5 ; T_1 is 1, clpz:clpz_neq(T_1, 7 + 5)) ; integer(7), integer(5) -> T_1 is 7 + 5, clpz:clpz_neq(1, T_1) ; clpz:clpz_neq(1, 7 + 5)),
      (integer(1) -> (integer(7), integer(5) -> 1 =\= 7 - 5 ; T_2 is 1, clpz:clpz_neq(T_2, 7 - 5)) ; integer(7), integer(5) -> T_2 is 7 - 5, clpz:clpz_neq(1, T_2) ; clpz:clpz_neq(1, 7 - 5)),
      6 is 5 + 1,
      safe_from(1, [2, 4], 6)]).
step((integer(1) -> (integer(7), integer(5) -> 1 =\= 7 + 5 ; T_1 is 1, clpz:clpz_neq(T_1, 7 + 5)) ; integer(7), integer(5) -> T_1 is 7 + 5, clpz:clpz_neq(1, T_1) ; clpz:clpz_neq(1, 7 + 5)),
     builtin,
     [],
     []).
step((integer(1) -> (integer(7), integer(5) -> 1 =\= 7 - 5 ; T_2 is 1, clpz:clpz_neq(T_2, 7 - 5)) ; integer(7), integer(5) -> T_2 is 7 - 5, clpz:clpz_neq(1, T_2) ; clpz:clpz_neq(1, 7 - 5)),
     builtin,
     [],
     []).
step(6 is 5 + 1, builtin, [], []).
step(safe_from(1, [2, 4], 6),
     rule(6),
     ['Row' = 1, 'Other' = 2, 'Rows' = [4], 'Distance' = 6, 'NextDistance' = 7],
     [(integer(1) -> (integer(2), integer(6) -> 1 =\= 2 + 6 ; T_1 is 1, clpz:clpz_neq(T_1, 2 + 6)) ; integer(2), integer(6) -> T_1 is 2 + 6, clpz:clpz_neq(1, T_1) ; clpz:clpz_neq(1, 2 + 6)),
      (integer(1) -> (integer(2), integer(6) -> 1 =\= 2 - 6 ; T_2 is 1, clpz:clpz_neq(T_2, 2 - 6)) ; integer(2), integer(6) -> T_2 is 2 - 6, clpz:clpz_neq(1, T_2) ; clpz:clpz_neq(1, 2 - 6)),
      7 is 6 + 1,
      safe_from(1, [4], 7)]).
step((integer(1) -> (integer(2), integer(6) -> 1 =\= 2 + 6 ; T_1 is 1, clpz:clpz_neq(T_1, 2 + 6)) ; integer(2), integer(6) -> T_1 is 2 + 6, clpz:clpz_neq(1, T_1) ; clpz:clpz_neq(1, 2 + 6)),
     builtin,
     [],
     []).
step((integer(1) -> (integer(2), integer(6) -> 1 =\= 2 - 6 ; T_2 is 1, clpz:clpz_neq(T_2, 2 - 6)) ; integer(2), integer(6) -> T_2 is 2 - 6, clpz:clpz_neq(1, T_2) ; clpz:clpz_neq(1, 2 - 6)),
     builtin,
     [],
     []).
step(7 is 6 + 1, builtin, [], []).
step(safe_from(1, [4], 7),
     rule(6),
     ['Row' = 1, 'Other' = 4, 'Rows' = [], 'Distance' = 7, 'NextDistance' = 8],
     [(integer(1) -> (integer(4), integer(7) -> 1 =\= 4 + 7 ; T_1 is 1, clpz:clpz_neq(T_1, 4 + 7)) ; integer(4), integer(7) -> T_1 is 4 + 7, clpz:clpz_neq(1, T_1) ; clpz:clpz_neq(1, 4 + 7)),
      (integer(1) -> (integer(4), integer(7) -> 1 =\= 4 - 7 ; T_2 is 1, clpz:clpz_neq(T_2, 4 - 7)) ; integer(4), integer(7) -> T_2 is 4 - 7, clpz:clpz_neq(1, T_2) ; clpz:clpz_neq(1, 4 - 7)),
      8 is 7 + 1,
      safe_from(1, [], 8)]).
step((integer(1) -> (integer(4), integer(7) -> 1 =\= 4 + 7 ; T_1 is 1, clpz:clpz_neq(T_1, 4 + 7)) ; integer(4), integer(7) -> T_1 is 4 + 7, clpz:clpz_neq(1, T_1) ; clpz:clpz_neq(1, 4 + 7)),
     builtin,
     [],
     []).
step((integer(1) -> (integer(4), integer(7) -> 1 =\= 4 - 7 ; T_2 is 1, clpz:clpz_neq(T_2, 4 - 7)) ; integer(4), integer(7) -> T_2 is 4 - 7, clpz:clpz_neq(1, T_2) ; clpz:clpz_neq(1, 4 - 7)),
     builtin,
     [],
     []).
step(8 is 7 + 1, builtin, [], []).
step(safe_from(1, [], 8), fact(5), [], []).
step(safe_diagonals([5, 8, 6, 3, 7, 2, 4]),
     rule(4),
     ['Row' = 5, 'Rows' = [8, 6, 3, 7, 2, 4]],
     [safe_from(5, [8, 6, 3, 7, 2, 4], 1), safe_diagonals([8, 6, 3, 7, 2, 4])]).
step(safe_from(5, [8, 6, 3, 7, 2, 4], 1),
     rule(6),
     ['Row' = 5, 'Other' = 8, 'Rows' = [6, 3, 7, 2, 4], 'Distance' = 1, 'NextDistance' = 2],
     [(integer(5) -> (integer(8), integer(1) -> 5 =\= 8 + 1 ; T_1 is 5, clpz:clpz_neq(T_1, 8 + 1)) ; integer(8), integer(1) -> T_1 is 8 + 1, clpz:clpz_neq(5, T_1) ; clpz:clpz_neq(5, 8 + 1)),
      (integer(5) -> (integer(8), integer(1) -> 5 =\= 8 - 1 ; T_2 is 5, clpz:clpz_neq(T_2, 8 - 1)) ; integer(8), integer(1) -> T_2 is 8 - 1, clpz:clpz_neq(5, T_2) ; clpz:clpz_neq(5, 8 - 1)),
      2 is 1 + 1,
      safe_from(5, [6, 3, 7, 2, 4], 2)]).
step((integer(5) -> (integer(8), integer(1) -> 5 =\= 8 + 1 ; T_1 is 5, clpz:clpz_neq(T_1, 8 + 1)) ; integer(8), integer(1) -> T_1 is 8 + 1, clpz:clpz_neq(5, T_1) ; clpz:clpz_neq(5, 8 + 1)),
     builtin,
     [],
     []).
step((integer(5) -> (integer(8), integer(1) -> 5 =\= 8 - 1 ; T_2 is 5, clpz:clpz_neq(T_2, 8 - 1)) ; integer(8), integer(1) -> T_2 is 8 - 1, clpz:clpz_neq(5, T_2) ; clpz:clpz_neq(5, 8 - 1)),
     builtin,
     [],
     []).
step(safe_from(5, [6, 3, 7, 2, 4], 2),
     rule(6),
     ['Row' = 5, 'Other' = 6, 'Rows' = [3, 7, 2, 4], 'Distance' = 2, 'NextDistance' = 3],
     [(integer(5) -> (integer(6), integer(2) -> 5 =\= 6 + 2 ; T_1 is 5, clpz:clpz_neq(T_1, 6 + 2)) ; integer(6), integer(2) -> T_1 is 6 + 2, clpz:clpz_neq(5, T_1) ; clpz:clpz_neq(5, 6 + 2)),
      (integer(5) -> (integer(6), integer(2) -> 5 =\= 6 - 2 ; T_2 is 5, clpz:clpz_neq(T_2, 6 - 2)) ; integer(6), integer(2) -> T_2 is 6 - 2, clpz:clpz_neq(5, T_2) ; clpz:clpz_neq(5, 6 - 2)),
      3 is 2 + 1,
      safe_from(5, [3, 7, 2, 4], 3)]).
step((integer(5) -> (integer(6), integer(2) -> 5 =\= 6 + 2 ; T_1 is 5, clpz:clpz_neq(T_1, 6 + 2)) ; integer(6), integer(2) -> T_1 is 6 + 2, clpz:clpz_neq(5, T_1) ; clpz:clpz_neq(5, 6 + 2)),
     builtin,
     [],
     []).
step((integer(5) -> (integer(6), integer(2) -> 5 =\= 6 - 2 ; T_2 is 5, clpz:clpz_neq(T_2, 6 - 2)) ; integer(6), integer(2) -> T_2 is 6 - 2, clpz:clpz_neq(5, T_2) ; clpz:clpz_neq(5, 6 - 2)),
     builtin,
     [],
     []).
step(safe_from(5, [3, 7, 2, 4], 3),
     rule(6),
     ['Row' = 5, 'Other' = 3, 'Rows' = [7, 2, 4], 'Distance' = 3, 'NextDistance' = 4],
     [(integer(5) -> (integer(3), integer(3) -> 5 =\= 3 + 3 ; T_1 is 5, clpz:clpz_neq(T_1, 3 + 3)) ; integer(3), integer(3) -> T_1 is 3 + 3, clpz:clpz_neq(5, T_1) ; clpz:clpz_neq(5, 3 + 3)),
      (integer(5) -> (integer(3), integer(3) -> 5 =\= 3 - 3 ; T_2 is 5, clpz:clpz_neq(T_2, 3 - 3)) ; integer(3), integer(3) -> T_2 is 3 - 3, clpz:clpz_neq(5, T_2) ; clpz:clpz_neq(5, 3 - 3)),
      4 is 3 + 1,
      safe_from(5, [7, 2, 4], 4)]).
step((integer(5) -> (integer(3), integer(3) -> 5 =\= 3 + 3 ; T_1 is 5, clpz:clpz_neq(T_1, 3 + 3)) ; integer(3), integer(3) -> T_1 is 3 + 3, clpz:clpz_neq(5, T_1) ; clpz:clpz_neq(5, 3 + 3)),
     builtin,
     [],
     []).
step((integer(5) -> (integer(3), integer(3) -> 5 =\= 3 - 3 ; T_2 is 5, clpz:clpz_neq(T_2, 3 - 3)) ; integer(3), integer(3) -> T_2 is 3 - 3, clpz:clpz_neq(5, T_2) ; clpz:clpz_neq(5, 3 - 3)),
     builtin,
     [],
     []).
step(safe_from(5, [7, 2, 4], 4),
     rule(6),
     ['Row' = 5, 'Other' = 7, 'Rows' = [2, 4], 'Distance' = 4, 'NextDistance' = 5],
     [(integer(5) -> (integer(7), integer(4) -> 5 =\= 7 + 4 ; T_1 is 5, clpz:clpz_neq(T_1, 7 + 4)) ; integer(7), integer(4) -> T_1 is 7 + 4, clpz:clpz_neq(5, T_1) ; clpz:clpz_neq(5, 7 + 4)),
      (integer(5) -> (integer(7), integer(4) -> 5 =\= 7 - 4 ; T_2 is 5, clpz:clpz_neq(T_2, 7 - 4)) ; integer(7), integer(4) -> T_2 is 7 - 4, clpz:clpz_neq(5, T_2) ; clpz:clpz_neq(5, 7 - 4)),
      5 is 4 + 1,
      safe_from(5, [2, 4], 5)]).
step((integer(5) -> (integer(7), integer(4) -> 5 =\= 7 + 4 ; T_1 is 5, clpz:clpz_neq(T_1, 7 + 4)) ; integer(7), integer(4) -> T_1 is 7 + 4, clpz:clpz_neq(5, T_1) ; clpz:clpz_neq(5, 7 + 4)),
     builtin,
     [],
     []).
step((integer(5) -> (integer(7), integer(4) -> 5 =\= 7 - 4 ; T_2 is 5, clpz:clpz_neq(T_2, 7 - 4)) ; integer(7), integer(4) -> T_2 is 7 - 4, clpz:clpz_neq(5, T_2) ; clpz:clpz_neq(5, 7 - 4)),
     builtin,
     [],
     []).
step(safe_from(5, [2, 4], 5),
     rule(6),
     ['Row' = 5, 'Other' = 2, 'Rows' = [4], 'Distance' = 5, 'NextDistance' = 6],
     [(integer(5) -> (integer(2), integer(5) -> 5 =\= 2 + 5 ; T_1 is 5, clpz:clpz_neq(T_1, 2 + 5)) ; integer(2), integer(5) -> T_1 is 2 + 5, clpz:clpz_neq(5, T_1) ; clpz:clpz_neq(5, 2 + 5)),
      (integer(5) -> (integer(2), integer(5) -> 5 =\= 2 - 5 ; T_2 is 5, clpz:clpz_neq(T_2, 2 - 5)) ; integer(2), integer(5) -> T_2 is 2 - 5, clpz:clpz_neq(5, T_2) ; clpz:clpz_neq(5, 2 - 5)),
      6 is 5 + 1,
      safe_from(5, [4], 6)]).
step((integer(5) -> (integer(2), integer(5) -> 5 =\= 2 + 5 ; T_1 is 5, clpz:clpz_neq(T_1, 2 + 5)) ; integer(2), integer(5) -> T_1 is 2 + 5, clpz:clpz_neq(5, T_1) ; clpz:clpz_neq(5, 2 + 5)),
     builtin,
     [],
     []).
step((integer(5) -> (integer(2), integer(5) -> 5 =\= 2 - 5 ; T_2 is 5, clpz:clpz_neq(T_2, 2 - 5)) ; integer(2), integer(5) -> T_2 is 2 - 5, clpz:clpz_neq(5, T_2) ; clpz:clpz_neq(5, 2 - 5)),
     builtin,
     [],
     []).
step(safe_from(5, [4], 6),
     rule(6),
     ['Row' = 5, 'Other' = 4, 'Rows' = [], 'Distance' = 6, 'NextDistance' = 7],
     [(integer(5) -> (integer(4), integer(6) -> 5 =\= 4 + 6 ; T_1 is 5, clpz:clpz_neq(T_1, 4 + 6)) ; integer(4), integer(6) -> T_1 is 4 + 6, clpz:clpz_neq(5, T_1) ; clpz:clpz_neq(5, 4 + 6)),
      (integer(5) -> (integer(4), integer(6) -> 5 =\= 4 - 6 ; T_2 is 5, clpz:clpz_neq(T_2, 4 - 6)) ; integer(4), integer(6) -> T_2 is 4 - 6, clpz:clpz_neq(5, T_2) ; clpz:clpz_neq(5, 4 - 6)),
      7 is 6 + 1,
      safe_from(5, [], 7)]).
step((integer(5) -> (integer(4), integer(6) -> 5 =\= 4 + 6 ; T_1 is 5, clpz:clpz_neq(T_1, 4 + 6)) ; integer(4), integer(6) -> T_1 is 4 + 6, clpz:clpz_neq(5, T_1) ; clpz:clpz_neq(5, 4 + 6)),
     builtin,
     [],
     []).
step((integer(5) -> (integer(4), integer(6) -> 5 =\= 4 - 6 ; T_2 is 5, clpz:clpz_neq(T_2, 4 - 6)) ; integer(4), integer(6) -> T_2 is 4 - 6, clpz:clpz_neq(5, T_2) ; clpz:clpz_neq(5, 4 - 6)),
     builtin,
     [],
     []).
step(safe_from(5, [], 7), fact(5), [], []).
step(safe_diagonals([8, 6, 3, 7, 2, 4]),
     rule(4),
     ['Row' = 8, 'Rows' = [6, 3, 7, 2, 4]],
     [safe_from(8, [6, 3, 7, 2, 4], 1), safe_diagonals([6, 3, 7, 2, 4])]).
step(safe_from(8, [6, 3, 7, 2, 4], 1),
     rule(6),
     ['Row' = 8, 'Other' = 6, 'Rows' = [3, 7, 2, 4], 'Distance' = 1, 'NextDistance' = 2],
     [(integer(8) -> (integer(6), integer(1) -> 8 =\= 6 + 1 ; T_1 is 8, clpz:clpz_neq(T_1, 6 + 1)) ; integer(6), integer(1) -> T_1 is 6 + 1, clpz:clpz_neq(8, T_1) ; clpz:clpz_neq(8, 6 + 1)),
      (integer(8) -> (integer(6), integer(1) -> 8 =\= 6 - 1 ; T_2 is 8, clpz:clpz_neq(T_2, 6 - 1)) ; integer(6), integer(1) -> T_2 is 6 - 1, clpz:clpz_neq(8, T_2) ; clpz:clpz_neq(8, 6 - 1)),
      2 is 1 + 1,
      safe_from(8, [3, 7, 2, 4], 2)]).
step((integer(8) -> (integer(6), integer(1) -> 8 =\= 6 + 1 ; T_1 is 8, clpz:clpz_neq(T_1, 6 + 1)) ; integer(6), integer(1) -> T_1 is 6 + 1, clpz:clpz_neq(8, T_1) ; clpz:clpz_neq(8, 6 + 1)),
     builtin,
     [],
     []).
step((integer(8) -> (integer(6), integer(1) -> 8 =\= 6 - 1 ; T_2 is 8, clpz:clpz_neq(T_2, 6 - 1)) ; integer(6), integer(1) -> T_2 is 6 - 1, clpz:clpz_neq(8, T_2) ; clpz:clpz_neq(8, 6 - 1)),
     builtin,
     [],
     []).
step(safe_from(8, [3, 7, 2, 4], 2),
     rule(6),
     ['Row' = 8, 'Other' = 3, 'Rows' = [7, 2, 4], 'Distance' = 2, 'NextDistance' = 3],
     [(integer(8) -> (integer(3), integer(2) -> 8 =\= 3 + 2 ; T_1 is 8, clpz:clpz_neq(T_1, 3 + 2)) ; integer(3), integer(2) -> T_1 is 3 + 2, clpz:clpz_neq(8, T_1) ; clpz:clpz_neq(8, 3 + 2)),
      (integer(8) -> (integer(3), integer(2) -> 8 =\= 3 - 2 ; T_2 is 8, clpz:clpz_neq(T_2, 3 - 2)) ; integer(3), integer(2) -> T_2 is 3 - 2, clpz:clpz_neq(8, T_2) ; clpz:clpz_neq(8, 3 - 2)),
      3 is 2 + 1,
      safe_from(8, [7, 2, 4], 3)]).
step((integer(8) -> (integer(3), integer(2) -> 8 =\= 3 + 2 ; T_1 is 8, clpz:clpz_neq(T_1, 3 + 2)) ; integer(3), integer(2) -> T_1 is 3 + 2, clpz:clpz_neq(8, T_1) ; clpz:clpz_neq(8, 3 + 2)),
     builtin,
     [],
     []).
step((integer(8) -> (integer(3), integer(2) -> 8 =\= 3 - 2 ; T_2 is 8, clpz:clpz_neq(T_2, 3 - 2)) ; integer(3), integer(2) -> T_2 is 3 - 2, clpz:clpz_neq(8, T_2) ; clpz:clpz_neq(8, 3 - 2)),
     builtin,
     [],
     []).
step(safe_from(8, [7, 2, 4], 3),
     rule(6),
     ['Row' = 8, 'Other' = 7, 'Rows' = [2, 4], 'Distance' = 3, 'NextDistance' = 4],
     [(integer(8) -> (integer(7), integer(3) -> 8 =\= 7 + 3 ; T_1 is 8, clpz:clpz_neq(T_1, 7 + 3)) ; integer(7), integer(3) -> T_1 is 7 + 3, clpz:clpz_neq(8, T_1) ; clpz:clpz_neq(8, 7 + 3)),
      (integer(8) -> (integer(7), integer(3) -> 8 =\= 7 - 3 ; T_2 is 8, clpz:clpz_neq(T_2, 7 - 3)) ; integer(7), integer(3) -> T_2 is 7 - 3, clpz:clpz_neq(8, T_2) ; clpz:clpz_neq(8, 7 - 3)),
      4 is 3 + 1,
      safe_from(8, [2, 4], 4)]).
step((integer(8) -> (integer(7), integer(3) -> 8 =\= 7 + 3 ; T_1 is 8, clpz:clpz_neq(T_1, 7 + 3)) ; integer(7), integer(3) -> T_1 is 7 + 3, clpz:clpz_neq(8, T_1) ; clpz:clpz_neq(8, 7 + 3)),
     builtin,
     [],
     []).
step((integer(8) -> (integer(7), integer(3) -> 8 =\= 7 - 3 ; T_2 is 8, clpz:clpz_neq(T_2, 7 - 3)) ; integer(7), integer(3) -> T_2 is 7 - 3, clpz:clpz_neq(8, T_2) ; clpz:clpz_neq(8, 7 - 3)),
     builtin,
     [],
     []).
step(safe_from(8, [2, 4], 4),
     rule(6),
     ['Row' = 8, 'Other' = 2, 'Rows' = [4], 'Distance' = 4, 'NextDistance' = 5],
     [(integer(8) -> (integer(2), integer(4) -> 8 =\= 2 + 4 ; T_1 is 8, clpz:clpz_neq(T_1, 2 + 4)) ; integer(2), integer(4) -> T_1 is 2 + 4, clpz:clpz_neq(8, T_1) ; clpz:clpz_neq(8, 2 + 4)),
      (integer(8) -> (integer(2), integer(4) -> 8 =\= 2 - 4 ; T_2 is 8, clpz:clpz_neq(T_2, 2 - 4)) ; integer(2), integer(4) -> T_2 is 2 - 4, clpz:clpz_neq(8, T_2) ; clpz:clpz_neq(8, 2 - 4)),
      5 is 4 + 1,
      safe_from(8, [4], 5)]).
step((integer(8) -> (integer(2), integer(4) -> 8 =\= 2 + 4 ; T_1 is 8, clpz:clpz_neq(T_1, 2 + 4)) ; integer(2), integer(4) -> T_1 is 2 + 4, clpz:clpz_neq(8, T_1) ; clpz:clpz_neq(8, 2 + 4)),
     builtin,
     [],
     []).
step((integer(8) -> (integer(2), integer(4) -> 8 =\= 2 - 4 ; T_2 is 8, clpz:clpz_neq(T_2, 2 - 4)) ; integer(2), integer(4) -> T_2 is 2 - 4, clpz:clpz_neq(8, T_2) ; clpz:clpz_neq(8, 2 - 4)),
     builtin,
     [],
     []).
step(safe_from(8, [4], 5),
     rule(6),
     ['Row' = 8, 'Other' = 4, 'Rows' = [], 'Distance' = 5, 'NextDistance' = 6],
     [(integer(8) -> (integer(4), integer(5) -> 8 =\= 4 + 5 ; T_1 is 8, clpz:clpz_neq(T_1, 4 + 5)) ; integer(4), integer(5) -> T_1 is 4 + 5, clpz:clpz_neq(8, T_1) ; clpz:clpz_neq(8, 4 + 5)),
      (integer(8) -> (integer(4), integer(5) -> 8 =\= 4 - 5 ; T_2 is 8, clpz:clpz_neq(T_2, 4 - 5)) ; integer(4), integer(5) -> T_2 is 4 - 5, clpz:clpz_neq(8, T_2) ; clpz:clpz_neq(8, 4 - 5)),
      6 is 5 + 1,
      safe_from(8, [], 6)]).
step((integer(8) -> (integer(4), integer(5) -> 8 =\= 4 + 5 ; T_1 is 8, clpz:clpz_neq(T_1, 4 + 5)) ; integer(4), integer(5) -> T_1 is 4 + 5, clpz:clpz_neq(8, T_1) ; clpz:clpz_neq(8, 4 + 5)),
     builtin,
     [],
     []).
step((integer(8) -> (integer(4), integer(5) -> 8 =\= 4 - 5 ; T_2 is 8, clpz:clpz_neq(T_2, 4 - 5)) ; integer(4), integer(5) -> T_2 is 4 - 5, clpz:clpz_neq(8, T_2) ; clpz:clpz_neq(8, 4 - 5)),
     builtin,
     [],
     []).
step(safe_from(8, [], 6), fact(5), [], []).
step(safe_diagonals([6, 3, 7, 2, 4]),
     rule(4),
     ['Row' = 6, 'Rows' = [3, 7, 2, 4]],
     [safe_from(6, [3, 7, 2, 4], 1), safe_diagonals([3, 7, 2, 4])]).
step(safe_from(6, [3, 7, 2, 4], 1),
     rule(6),
     ['Row' = 6, 'Other' = 3, 'Rows' = [7, 2, 4], 'Distance' = 1, 'NextDistance' = 2],
     [(integer(6) -> (integer(3), integer(1) -> 6 =\= 3 + 1 ; T_1 is 6, clpz:clpz_neq(T_1, 3 + 1)) ; integer(3), integer(1) -> T_1 is 3 + 1, clpz:clpz_neq(6, T_1) ; clpz:clpz_neq(6, 3 + 1)),
      (integer(6) -> (integer(3), integer(1) -> 6 =\= 3 - 1 ; T_2 is 6, clpz:clpz_neq(T_2, 3 - 1)) ; integer(3), integer(1) -> T_2 is 3 - 1, clpz:clpz_neq(6, T_2) ; clpz:clpz_neq(6, 3 - 1)),
      2 is 1 + 1,
      safe_from(6, [7, 2, 4], 2)]).
step((integer(6) -> (integer(3), integer(1) -> 6 =\= 3 + 1 ; T_1 is 6, clpz:clpz_neq(T_1, 3 + 1)) ; integer(3), integer(1) -> T_1 is 3 + 1, clpz:clpz_neq(6, T_1) ; clpz:clpz_neq(6, 3 + 1)),
     builtin,
     [],
     []).
step((integer(6) -> (integer(3), integer(1) -> 6 =\= 3 - 1 ; T_2 is 6, clpz:clpz_neq(T_2, 3 - 1)) ; integer(3), integer(1) -> T_2 is 3 - 1, clpz:clpz_neq(6, T_2) ; clpz:clpz_neq(6, 3 - 1)),
     builtin,
     [],
     []).
step(safe_from(6, [7, 2, 4], 2),
     rule(6),
     ['Row' = 6, 'Other' = 7, 'Rows' = [2, 4], 'Distance' = 2, 'NextDistance' = 3],
     [(integer(6) -> (integer(7), integer(2) -> 6 =\= 7 + 2 ; T_1 is 6, clpz:clpz_neq(T_1, 7 + 2)) ; integer(7), integer(2) -> T_1 is 7 + 2, clpz:clpz_neq(6, T_1) ; clpz:clpz_neq(6, 7 + 2)),
      (integer(6) -> (integer(7), integer(2) -> 6 =\= 7 - 2 ; T_2 is 6, clpz:clpz_neq(T_2, 7 - 2)) ; integer(7), integer(2) -> T_2 is 7 - 2, clpz:clpz_neq(6, T_2) ; clpz:clpz_neq(6, 7 - 2)),
      3 is 2 + 1,
      safe_from(6, [2, 4], 3)]).
step((integer(6) -> (integer(7), integer(2) -> 6 =\= 7 + 2 ; T_1 is 6, clpz:clpz_neq(T_1, 7 + 2)) ; integer(7), integer(2) -> T_1 is 7 + 2, clpz:clpz_neq(6, T_1) ; clpz:clpz_neq(6, 7 + 2)),
     builtin,
     [],
     []).
step((integer(6) -> (integer(7), integer(2) -> 6 =\= 7 - 2 ; T_2 is 6, clpz:clpz_neq(T_2, 7 - 2)) ; integer(7), integer(2) -> T_2 is 7 - 2, clpz:clpz_neq(6, T_2) ; clpz:clpz_neq(6, 7 - 2)),
     builtin,
     [],
     []).
step(safe_from(6, [2, 4], 3),
     rule(6),
     ['Row' = 6, 'Other' = 2, 'Rows' = [4], 'Distance' = 3, 'NextDistance' = 4],
     [(integer(6) -> (integer(2), integer(3) -> 6 =\= 2 + 3 ; T_1 is 6, clpz:clpz_neq(T_1, 2 + 3)) ; integer(2), integer(3) -> T_1 is 2 + 3, clpz:clpz_neq(6, T_1) ; clpz:clpz_neq(6, 2 + 3)),
      (integer(6) -> (integer(2), integer(3) -> 6 =\= 2 - 3 ; T_2 is 6, clpz:clpz_neq(T_2, 2 - 3)) ; integer(2), integer(3) -> T_2 is 2 - 3, clpz:clpz_neq(6, T_2) ; clpz:clpz_neq(6, 2 - 3)),
      4 is 3 + 1,
      safe_from(6, [4], 4)]).
step((integer(6) -> (integer(2), integer(3) -> 6 =\= 2 + 3 ; T_1 is 6, clpz:clpz_neq(T_1, 2 + 3)) ; integer(2), integer(3) -> T_1 is 2 + 3, clpz:clpz_neq(6, T_1) ; clpz:clpz_neq(6, 2 + 3)),
     builtin,
     [],
     []).
step((integer(6) -> (integer(2), integer(3) -> 6 =\= 2 - 3 ; T_2 is 6, clpz:clpz_neq(T_2, 2 - 3)) ; integer(2), integer(3) -> T_2 is 2 - 3, clpz:clpz_neq(6, T_2) ; clpz:clpz_neq(6, 2 - 3)),
     builtin,
     [],
     []).
step(safe_from(6, [4], 4),
     rule(6),
     ['Row' = 6, 'Other' = 4, 'Rows' = [], 'Distance' = 4, 'NextDistance' = 5],
     [(integer(6) -> (integer(4), integer(4) -> 6 =\= 4 + 4 ; T_1 is 6, clpz:clpz_neq(T_1, 4 + 4)) ; integer(4), integer(4) -> T_1 is 4 + 4, clpz:clpz_neq(6, T_1) ; clpz:clpz_neq(6, 4 + 4)),
      (integer(6) -> (integer(4), integer(4) -> 6 =\= 4 - 4 ; T_2 is 6, clpz:clpz_neq(T_2, 4 - 4)) ; integer(4), integer(4) -> T_2 is 4 - 4, clpz:clpz_neq(6, T_2) ; clpz:clpz_neq(6, 4 - 4)),
      5 is 4 + 1,
      safe_from(6, [], 5)]).
step((integer(6) -> (integer(4), integer(4) -> 6 =\= 4 + 4 ; T_1 is 6, clpz:clpz_neq(T_1, 4 + 4)) ; integer(4), integer(4) -> T_1 is 4 + 4, clpz:clpz_neq(6, T_1) ; clpz:clpz_neq(6, 4 + 4)),
     builtin,
     [],
     []).
step((integer(6) -> (integer(4), integer(4) -> 6 =\= 4 - 4 ; T_2 is 6, clpz:clpz_neq(T_2, 4 - 4)) ; integer(4), integer(4) -> T_2 is 4 - 4, clpz:clpz_neq(6, T_2) ; clpz:clpz_neq(6, 4 - 4)),
     builtin,
     [],
     []).
step(safe_from(6, [], 5), fact(5), [], []).
step(safe_diagonals([3, 7, 2, 4]),
     rule(4),
     ['Row' = 3, 'Rows' = [7, 2, 4]],
     [safe_from(3, [7, 2, 4], 1), safe_diagonals([7, 2, 4])]).
step(safe_from(3, [7, 2, 4], 1),
     rule(6),
     ['Row' = 3, 'Other' = 7, 'Rows' = [2, 4], 'Distance' = 1, 'NextDistance' = 2],
     [(integer(3) -> (integer(7), integer(1) -> 3 =\= 7 + 1 ; T_1 is 3, clpz:clpz_neq(T_1, 7 + 1)) ; integer(7), integer(1) -> T_1 is 7 + 1, clpz:clpz_neq(3, T_1) ; clpz:clpz_neq(3, 7 + 1)),
      (integer(3) -> (integer(7), integer(1) -> 3 =\= 7 - 1 ; T_2 is 3, clpz:clpz_neq(T_2, 7 - 1)) ; integer(7), integer(1) -> T_2 is 7 - 1, clpz:clpz_neq(3, T_2) ; clpz:clpz_neq(3, 7 - 1)),
      2 is 1 + 1,
      safe_from(3, [2, 4], 2)]).
step((integer(3) -> (integer(7), integer(1) -> 3 =\= 7 + 1 ; T_1 is 3, clpz:clpz_neq(T_1, 7 + 1)) ; integer(7), integer(1) -> T_1 is 7 + 1, clpz:clpz_neq(3, T_1) ; clpz:clpz_neq(3, 7 + 1)),
     builtin,
     [],
     []).
step((integer(3) -> (integer(7), integer(1) -> 3 =\= 7 - 1 ; T_2 is 3, clpz:clpz_neq(T_2, 7 - 1)) ; integer(7), integer(1) -> T_2 is 7 - 1, clpz:clpz_neq(3, T_2) ; clpz:clpz_neq(3, 7 - 1)),
     builtin,
     [],
     []).
step(safe_from(3, [2, 4], 2),
     rule(6),
     ['Row' = 3, 'Other' = 2, 'Rows' = [4], 'Distance' = 2, 'NextDistance' = 3],
     [(integer(3) -> (integer(2), integer(2) -> 3 =\= 2 + 2 ; T_1 is 3, clpz:clpz_neq(T_1, 2 + 2)) ; integer(2), integer(2) -> T_1 is 2 + 2, clpz:clpz_neq(3, T_1) ; clpz:clpz_neq(3, 2 + 2)),
      (integer(3) -> (integer(2), integer(2) -> 3 =\= 2 - 2 ; T_2 is 3, clpz:clpz_neq(T_2, 2 - 2)) ; integer(2), integer(2) -> T_2 is 2 - 2, clpz:clpz_neq(3, T_2) ; clpz:clpz_neq(3, 2 - 2)),
      3 is 2 + 1,
      safe_from(3, [4], 3)]).
step((integer(3) -> (integer(2), integer(2) -> 3 =\= 2 + 2 ; T_1 is 3, clpz:clpz_neq(T_1, 2 + 2)) ; integer(2), integer(2) -> T_1 is 2 + 2, clpz:clpz_neq(3, T_1) ; clpz:clpz_neq(3, 2 + 2)),
     builtin,
     [],
     []).
step((integer(3) -> (integer(2), integer(2) -> 3 =\= 2 - 2 ; T_2 is 3, clpz:clpz_neq(T_2, 2 - 2)) ; integer(2), integer(2) -> T_2 is 2 - 2, clpz:clpz_neq(3, T_2) ; clpz:clpz_neq(3, 2 - 2)),
     builtin,
     [],
     []).
step(safe_from(3, [4], 3),
     rule(6),
     ['Row' = 3, 'Other' = 4, 'Rows' = [], 'Distance' = 3, 'NextDistance' = 4],
     [(integer(3) -> (integer(4), integer(3) -> 3 =\= 4 + 3 ; T_1 is 3, clpz:clpz_neq(T_1, 4 + 3)) ; integer(4), integer(3) -> T_1 is 4 + 3, clpz:clpz_neq(3, T_1) ; clpz:clpz_neq(3, 4 + 3)),
      (integer(3) -> (integer(4), integer(3) -> 3 =\= 4 - 3 ; T_2 is 3, clpz:clpz_neq(T_2, 4 - 3)) ; integer(4), integer(3) -> T_2 is 4 - 3, clpz:clpz_neq(3, T_2) ; clpz:clpz_neq(3, 4 - 3)),
      4 is 3 + 1,
      safe_from(3, [], 4)]).
step((integer(3) -> (integer(4), integer(3) -> 3 =\= 4 + 3 ; T_1 is 3, clpz:clpz_neq(T_1, 4 + 3)) ; integer(4), integer(3) -> T_1 is 4 + 3, clpz:clpz_neq(3, T_1) ; clpz:clpz_neq(3, 4 + 3)),
     builtin,
     [],
     []).
step((integer(3) -> (integer(4), integer(3) -> 3 =\= 4 - 3 ; T_2 is 3, clpz:clpz_neq(T_2, 4 - 3)) ; integer(4), integer(3) -> T_2 is 4 - 3, clpz:clpz_neq(3, T_2) ; clpz:clpz_neq(3, 4 - 3)),
     builtin,
     [],
     []).
step(safe_from(3, [], 4), fact(5), [], []).
step(safe_diagonals([7, 2, 4]),
     rule(4),
     ['Row' = 7, 'Rows' = [2, 4]],
     [safe_from(7, [2, 4], 1), safe_diagonals([2, 4])]).
step(safe_from(7, [2, 4], 1),
     rule(6),
     ['Row' = 7, 'Other' = 2, 'Rows' = [4], 'Distance' = 1, 'NextDistance' = 2],
     [(integer(7) -> (integer(2), integer(1) -> 7 =\= 2 + 1 ; T_1 is 7, clpz:clpz_neq(T_1, 2 + 1)) ; integer(2), integer(1) -> T_1 is 2 + 1, clpz:clpz_neq(7, T_1) ; clpz:clpz_neq(7, 2 + 1)),
      (integer(7) -> (integer(2), integer(1) -> 7 =\= 2 - 1 ; T_2 is 7, clpz:clpz_neq(T_2, 2 - 1)) ; integer(2), integer(1) -> T_2 is 2 - 1, clpz:clpz_neq(7, T_2) ; clpz:clpz_neq(7, 2 - 1)),
      2 is 1 + 1,
      safe_from(7, [4], 2)]).
step((integer(7) -> (integer(2), integer(1) -> 7 =\= 2 + 1 ; T_1 is 7, clpz:clpz_neq(T_1, 2 + 1)) ; integer(2), integer(1) -> T_1 is 2 + 1, clpz:clpz_neq(7, T_1) ; clpz:clpz_neq(7, 2 + 1)),
     builtin,
     [],
     []).
step((integer(7) -> (integer(2), integer(1) -> 7 =\= 2 - 1 ; T_2 is 7, clpz:clpz_neq(T_2, 2 - 1)) ; integer(2), integer(1) -> T_2 is 2 - 1, clpz:clpz_neq(7, T_2) ; clpz:clpz_neq(7, 2 - 1)),
     builtin,
     [],
     []).
step(safe_from(7, [4], 2),
     rule(6),
     ['Row' = 7, 'Other' = 4, 'Rows' = [], 'Distance' = 2, 'NextDistance' = 3],
     [(integer(7) -> (integer(4), integer(2) -> 7 =\= 4 + 2 ; T_1 is 7, clpz:clpz_neq(T_1, 4 + 2)) ; integer(4), integer(2) -> T_1 is 4 + 2, clpz:clpz_neq(7, T_1) ; clpz:clpz_neq(7, 4 + 2)),
      (integer(7) -> (integer(4), integer(2) -> 7 =\= 4 - 2 ; T_2 is 7, clpz:clpz_neq(T_2, 4 - 2)) ; integer(4), integer(2) -> T_2 is 4 - 2, clpz:clpz_neq(7, T_2) ; clpz:clpz_neq(7, 4 - 2)),
      3 is 2 + 1,
      safe_from(7, [], 3)]).
step((integer(7) -> (integer(4), integer(2) -> 7 =\= 4 + 2 ; T_1 is 7, clpz:clpz_neq(T_1, 4 + 2)) ; integer(4), integer(2) -> T_1 is 4 + 2, clpz:clpz_neq(7, T_1) ; clpz:clpz_neq(7, 4 + 2)),
     builtin,
     [],
     []).
step((integer(7) -> (integer(4), integer(2) -> 7 =\= 4 - 2 ; T_2 is 7, clpz:clpz_neq(T_2, 4 - 2)) ; integer(4), integer(2) -> T_2 is 4 - 2, clpz:clpz_neq(7, T_2) ; clpz:clpz_neq(7, 4 - 2)),
     builtin,
     [],
     []).
step(safe_from(7, [], 3), fact(5), [], []).
step(safe_diagonals([2, 4]),
     rule(4),
     ['Row' = 2, 'Rows' = [4]],
     [safe_from(2, [4], 1), safe_diagonals([4])]).
step(safe_from(2, [4], 1),
     rule(6),
     ['Row' = 2, 'Other' = 4, 'Rows' = [], 'Distance' = 1, 'NextDistance' = 2],
     [(integer(2) -> (integer(4), integer(1) -> 2 =\= 4 + 1 ; T_1 is 2, clpz:clpz_neq(T_1, 4 + 1)) ; integer(4), integer(1) -> T_1 is 4 + 1, clpz:clpz_neq(2, T_1) ; clpz:clpz_neq(2, 4 + 1)),
      (integer(2) -> (integer(4), integer(1) -> 2 =\= 4 - 1 ; T_2 is 2, clpz:clpz_neq(T_2, 4 - 1)) ; integer(4), integer(1) -> T_2 is 4 - 1, clpz:clpz_neq(2, T_2) ; clpz:clpz_neq(2, 4 - 1)),
      2 is 1 + 1,
      safe_from(2, [], 2)]).
step((integer(2) -> (integer(4), integer(1) -> 2 =\= 4 + 1 ; T_1 is 2, clpz:clpz_neq(T_1, 4 + 1)) ; integer(4), integer(1) -> T_1 is 4 + 1, clpz:clpz_neq(2, T_1) ; clpz:clpz_neq(2, 4 + 1)),
     builtin,
     [],
     []).
step((integer(2) -> (integer(4), integer(1) -> 2 =\= 4 - 1 ; T_2 is 2, clpz:clpz_neq(T_2, 4 - 1)) ; integer(4), integer(1) -> T_2 is 4 - 1, clpz:clpz_neq(2, T_2) ; clpz:clpz_neq(2, 4 - 1)),
     builtin,
     [],
     []).
step(safe_from(2, [], 2), fact(5), [], []).
step(safe_diagonals([4]),
     rule(4),
     ['Row' = 4, 'Rows' = []],
     [safe_from(4, [], 1), safe_diagonals([])]).
step(safe_from(4, [], 1), fact(5), [], []).
step(safe_diagonals([]), fact(3), [], []).
step(labeling([ff], [1, 5, 8, 6, 3, 7, 2, 4]), builtin, [], []).
step(queens(4, [2, 4, 1, 3]),
     rule(2),
     ['Size' = 4, 'Rows' = [2, 4, 1, 3]],
     [length([2, 4, 1, 3], 4),
      [2, 4, 1, 3] ins 1..4,
      all_distinct([2, 4, 1, 3]),
      safe_diagonals([2, 4, 1, 3]),
      labeling([ff], [2, 4, 1, 3])]).
step(length([2, 4, 1, 3], 4), builtin, [], []).
step([2, 4, 1, 3] ins 1..4, builtin, [], []).
step(all_distinct([2, 4, 1, 3]), builtin, [], []).
step(safe_diagonals([2, 4, 1, 3]),
     rule(4),
     ['Row' = 2, 'Rows' = [4, 1, 3]],
     [safe_from(2, [4, 1, 3], 1), safe_diagonals([4, 1, 3])]).
step(safe_from(2, [4, 1, 3], 1),
     rule(6),
     ['Row' = 2, 'Other' = 4, 'Rows' = [1, 3], 'Distance' = 1, 'NextDistance' = 2],
     [(integer(2) -> (integer(4), integer(1) -> 2 =\= 4 + 1 ; T_1 is 2, clpz:clpz_neq(T_1, 4 + 1)) ; integer(4), integer(1) -> T_1 is 4 + 1, clpz:clpz_neq(2, T_1) ; clpz:clpz_neq(2, 4 + 1)),
      (integer(2) -> (integer(4), integer(1) -> 2 =\= 4 - 1 ; T_2 is 2, clpz:clpz_neq(T_2, 4 - 1)) ; integer(4), integer(1) -> T_2 is 4 - 1, clpz:clpz_neq(2, T_2) ; clpz:clpz_neq(2, 4 - 1)),
      2 is 1 + 1,
      safe_from(2, [1, 3], 2)]).
step(safe_from(2, [1, 3], 2),
     rule(6),
     ['Row' = 2, 'Other' = 1, 'Rows' = [3], 'Distance' = 2, 'NextDistance' = 3],
     [(integer(2) -> (integer(1), integer(2) -> 2 =\= 1 + 2 ; T_1 is 2, clpz:clpz_neq(T_1, 1 + 2)) ; integer(1), integer(2) -> T_1 is 1 + 2, clpz:clpz_neq(2, T_1) ; clpz:clpz_neq(2, 1 + 2)),
      (integer(2) -> (integer(1), integer(2) -> 2 =\= 1 - 2 ; T_2 is 2, clpz:clpz_neq(T_2, 1 - 2)) ; integer(1), integer(2) -> T_2 is 1 - 2, clpz:clpz_neq(2, T_2) ; clpz:clpz_neq(2, 1 - 2)),
      3 is 2 + 1,
      safe_from(2, [3], 3)]).
step((integer(2) -> (integer(1), integer(2) -> 2 =\= 1 + 2 ; T_1 is 2, clpz:clpz_neq(T_1, 1 + 2)) ; integer(1), integer(2) -> T_1 is 1 + 2, clpz:clpz_neq(2, T_1) ; clpz:clpz_neq(2, 1 + 2)),
     builtin,
     [],
     []).
step((integer(2) -> (integer(1), integer(2) -> 2 =\= 1 - 2 ; T_2 is 2, clpz:clpz_neq(T_2, 1 - 2)) ; integer(1), integer(2) -> T_2 is 1 - 2, clpz:clpz_neq(2, T_2) ; clpz:clpz_neq(2, 1 - 2)),
     builtin,
     [],
     []).
step(safe_from(2, [3], 3),
     rule(6),
     ['Row' = 2, 'Other' = 3, 'Rows' = [], 'Distance' = 3, 'NextDistance' = 4],
     [(integer(2) -> (integer(3), integer(3) -> 2 =\= 3 + 3 ; T_1 is 2, clpz:clpz_neq(T_1, 3 + 3)) ; integer(3), integer(3) -> T_1 is 3 + 3, clpz:clpz_neq(2, T_1) ; clpz:clpz_neq(2, 3 + 3)),
      (integer(2) -> (integer(3), integer(3) -> 2 =\= 3 - 3 ; T_2 is 2, clpz:clpz_neq(T_2, 3 - 3)) ; integer(3), integer(3) -> T_2 is 3 - 3, clpz:clpz_neq(2, T_2) ; clpz:clpz_neq(2, 3 - 3)),
      4 is 3 + 1,
      safe_from(2, [], 4)]).
step((integer(2) -> (integer(3), integer(3) -> 2 =\= 3 + 3 ; T_1 is 2, clpz:clpz_neq(T_1, 3 + 3)) ; integer(3), integer(3) -> T_1 is 3 + 3, clpz:clpz_neq(2, T_1) ; clpz:clpz_neq(2, 3 + 3)),
     builtin,
     [],
     []).
step((integer(2) -> (integer(3), integer(3) -> 2 =\= 3 - 3 ; T_2 is 2, clpz:clpz_neq(T_2, 3 - 3)) ; integer(3), integer(3) -> T_2 is 3 - 3, clpz:clpz_neq(2, T_2) ; clpz:clpz_neq(2, 3 - 3)),
     builtin,
     [],
     []).
step(safe_from(2, [], 4), fact(5), [], []).
step(safe_diagonals([4, 1, 3]),
     rule(4),
     ['Row' = 4, 'Rows' = [1, 3]],
     [safe_from(4, [1, 3], 1), safe_diagonals([1, 3])]).
step(safe_from(4, [1, 3], 1),
     rule(6),
     ['Row' = 4, 'Other' = 1, 'Rows' = [3], 'Distance' = 1, 'NextDistance' = 2],
     [(integer(4) -> (integer(1), integer(1) -> 4 =\= 1 + 1 ; T_1 is 4, clpz:clpz_neq(T_1, 1 + 1)) ; integer(1), integer(1) -> T_1 is 1 + 1, clpz:clpz_neq(4, T_1) ; clpz:clpz_neq(4, 1 + 1)),
      (integer(4) -> (integer(1), integer(1) -> 4 =\= 1 - 1 ; T_2 is 4, clpz:clpz_neq(T_2, 1 - 1)) ; integer(1), integer(1) -> T_2 is 1 - 1, clpz:clpz_neq(4, T_2) ; clpz:clpz_neq(4, 1 - 1)),
      2 is 1 + 1,
      safe_from(4, [3], 2)]).
step((integer(4) -> (integer(1), integer(1) -> 4 =\= 1 + 1 ; T_1 is 4, clpz:clpz_neq(T_1, 1 + 1)) ; integer(1), integer(1) -> T_1 is 1 + 1, clpz:clpz_neq(4, T_1) ; clpz:clpz_neq(4, 1 + 1)),
     builtin,
     [],
     []).
step((integer(4) -> (integer(1), integer(1) -> 4 =\= 1 - 1 ; T_2 is 4, clpz:clpz_neq(T_2, 1 - 1)) ; integer(1), integer(1) -> T_2 is 1 - 1, clpz:clpz_neq(4, T_2) ; clpz:clpz_neq(4, 1 - 1)),
     builtin,
     [],
     []).
step(safe_from(4, [3], 2),
     rule(6),
     ['Row' = 4, 'Other' = 3, 'Rows' = [], 'Distance' = 2, 'NextDistance' = 3],
     [(integer(4) -> (integer(3), integer(2) -> 4 =\= 3 + 2 ; T_1 is 4, clpz:clpz_neq(T_1, 3 + 2)) ; integer(3), integer(2) -> T_1 is 3 + 2, clpz:clpz_neq(4, T_1) ; clpz:clpz_neq(4, 3 + 2)),
      (integer(4) -> (integer(3), integer(2) -> 4 =\= 3 - 2 ; T_2 is 4, clpz:clpz_neq(T_2, 3 - 2)) ; integer(3), integer(2) -> T_2 is 3 - 2, clpz:clpz_neq(4, T_2) ; clpz:clpz_neq(4, 3 - 2)),
      3 is 2 + 1,
      safe_from(4, [], 3)]).
step((integer(4) -> (integer(3), integer(2) -> 4 =\= 3 + 2 ; T_1 is 4, clpz:clpz_neq(T_1, 3 + 2)) ; integer(3), integer(2) -> T_1 is 3 + 2, clpz:clpz_neq(4, T_1) ; clpz:clpz_neq(4, 3 + 2)),
     builtin,
     [],
     []).
step((integer(4) -> (integer(3), integer(2) -> 4 =\= 3 - 2 ; T_2 is 4, clpz:clpz_neq(T_2, 3 - 2)) ; integer(3), integer(2) -> T_2 is 3 - 2, clpz:clpz_neq(4, T_2) ; clpz:clpz_neq(4, 3 - 2)),
     builtin,
     [],
     []).
step(safe_from(4, [], 3), fact(5), [], []).
step(safe_diagonals([1, 3]),
     rule(4),
     ['Row' = 1, 'Rows' = [3]],
     [safe_from(1, [3], 1), safe_diagonals([3])]).
step(safe_from(1, [3], 1),
     rule(6),
     ['Row' = 1, 'Other' = 3, 'Rows' = [], 'Distance' = 1, 'NextDistance' = 2],
     [(integer(1) -> (integer(3), integer(1) -> 1 =\= 3 + 1 ; T_1 is 1, clpz:clpz_neq(T_1, 3 + 1)) ; integer(3), integer(1) -> T_1 is 3 + 1, clpz:clpz_neq(1, T_1) ; clpz:clpz_neq(1, 3 + 1)),
      (integer(1) -> (integer(3), integer(1) -> 1 =\= 3 - 1 ; T_2 is 1, clpz:clpz_neq(T_2, 3 - 1)) ; integer(3), integer(1) -> T_2 is 3 - 1, clpz:clpz_neq(1, T_2) ; clpz:clpz_neq(1, 3 - 1)),
      2 is 1 + 1,
      safe_from(1, [], 2)]).
step((integer(1) -> (integer(3), integer(1) -> 1 =\= 3 + 1 ; T_1 is 1, clpz:clpz_neq(T_1, 3 + 1)) ; integer(3), integer(1) -> T_1 is 3 + 1, clpz:clpz_neq(1, T_1) ; clpz:clpz_neq(1, 3 + 1)),
     builtin,
     [],
     []).
step((integer(1) -> (integer(3), integer(1) -> 1 =\= 3 - 1 ; T_2 is 1, clpz:clpz_neq(T_2, 3 - 1)) ; integer(3), integer(1) -> T_2 is 3 - 1, clpz:clpz_neq(1, T_2) ; clpz:clpz_neq(1, 3 - 1)),
     builtin,
     [],
     []).
step(safe_from(1, [], 2), fact(5), [], []).
step(safe_diagonals([3]),
     rule(4),
     ['Row' = 3, 'Rows' = []],
     [safe_from(3, [], 1), safe_diagonals([])]).
step(safe_from(3, [], 1), fact(5), [], []).
step(labeling([ff], [2, 4, 1, 3]), builtin, [], []).
step(queens(4, [3, 1, 4, 2]),
     rule(2),
     ['Size' = 4, 'Rows' = [3, 1, 4, 2]],
     [length([3, 1, 4, 2], 4),
      [3, 1, 4, 2] ins 1..4,
      all_distinct([3, 1, 4, 2]),
      safe_diagonals([3, 1, 4, 2]),
      labeling([ff], [3, 1, 4, 2])]).
step(length([3, 1, 4, 2], 4), builtin, [], []).
step([3, 1, 4, 2] ins 1..4, builtin, [], []).
step(all_distinct([3, 1, 4, 2]), builtin, [], []).
step(safe_diagonals([3, 1, 4, 2]),
     rule(4),
     ['Row' = 3, 'Rows' = [1, 4, 2]],
     [safe_from(3, [1, 4, 2], 1), safe_diagonals([1, 4, 2])]).
step(safe_from(3, [1, 4, 2], 1),
     rule(6),
     ['Row' = 3, 'Other' = 1, 'Rows' = [4, 2], 'Distance' = 1, 'NextDistance' = 2],
     [(integer(3) -> (integer(1), integer(1) -> 3 =\= 1 + 1 ; T_1 is 3, clpz:clpz_neq(T_1, 1 + 1)) ; integer(1), integer(1) -> T_1 is 1 + 1, clpz:clpz_neq(3, T_1) ; clpz:clpz_neq(3, 1 + 1)),
      (integer(3) -> (integer(1), integer(1) -> 3 =\= 1 - 1 ; T_2 is 3, clpz:clpz_neq(T_2, 1 - 1)) ; integer(1), integer(1) -> T_2 is 1 - 1, clpz:clpz_neq(3, T_2) ; clpz:clpz_neq(3, 1 - 1)),
      2 is 1 + 1,
      safe_from(3, [4, 2], 2)]).
step((integer(3) -> (integer(1), integer(1) -> 3 =\= 1 + 1 ; T_1 is 3, clpz:clpz_neq(T_1, 1 + 1)) ; integer(1), integer(1) -> T_1 is 1 + 1, clpz:clpz_neq(3, T_1) ; clpz:clpz_neq(3, 1 + 1)),
     builtin,
     [],
     []).
step((integer(3) -> (integer(1), integer(1) -> 3 =\= 1 - 1 ; T_2 is 3, clpz:clpz_neq(T_2, 1 - 1)) ; integer(1), integer(1) -> T_2 is 1 - 1, clpz:clpz_neq(3, T_2) ; clpz:clpz_neq(3, 1 - 1)),
     builtin,
     [],
     []).
step(safe_from(3, [4, 2], 2),
     rule(6),
     ['Row' = 3, 'Other' = 4, 'Rows' = [2], 'Distance' = 2, 'NextDistance' = 3],
     [(integer(3) -> (integer(4), integer(2) -> 3 =\= 4 + 2 ; T_1 is 3, clpz:clpz_neq(T_1, 4 + 2)) ; integer(4), integer(2) -> T_1 is 4 + 2, clpz:clpz_neq(3, T_1) ; clpz:clpz_neq(3, 4 + 2)),
      (integer(3) -> (integer(4), integer(2) -> 3 =\= 4 - 2 ; T_2 is 3, clpz:clpz_neq(T_2, 4 - 2)) ; integer(4), integer(2) -> T_2 is 4 - 2, clpz:clpz_neq(3, T_2) ; clpz:clpz_neq(3, 4 - 2)),
      3 is 2 + 1,
      safe_from(3, [2], 3)]).
step((integer(3) -> (integer(4), integer(2) -> 3 =\= 4 + 2 ; T_1 is 3, clpz:clpz_neq(T_1, 4 + 2)) ; integer(4), integer(2) -> T_1 is 4 + 2, clpz:clpz_neq(3, T_1) ; clpz:clpz_neq(3, 4 + 2)),
     builtin,
     [],
     []).
step((integer(3) -> (integer(4), integer(2) -> 3 =\= 4 - 2 ; T_2 is 3, clpz:clpz_neq(T_2, 4 - 2)) ; integer(4), integer(2) -> T_2 is 4 - 2, clpz:clpz_neq(3, T_2) ; clpz:clpz_neq(3, 4 - 2)),
     builtin,
     [],
     []).
step(safe_from(3, [2], 3),
     rule(6),
     ['Row' = 3, 'Other' = 2, 'Rows' = [], 'Distance' = 3, 'NextDistance' = 4],
     [(integer(3) -> (integer(2), integer(3) -> 3 =\= 2 + 3 ; T_1 is 3, clpz:clpz_neq(T_1, 2 + 3)) ; integer(2), integer(3) -> T_1 is 2 + 3, clpz:clpz_neq(3, T_1) ; clpz:clpz_neq(3, 2 + 3)),
      (integer(3) -> (integer(2), integer(3) -> 3 =\= 2 - 3 ; T_2 is 3, clpz:clpz_neq(T_2, 2 - 3)) ; integer(2), integer(3) -> T_2 is 2 - 3, clpz:clpz_neq(3, T_2) ; clpz:clpz_neq(3, 2 - 3)),
      4 is 3 + 1,
      safe_from(3, [], 4)]).
step((integer(3) -> (integer(2), integer(3) -> 3 =\= 2 + 3 ; T_1 is 3, clpz:clpz_neq(T_1, 2 + 3)) ; integer(2), integer(3) -> T_1 is 2 + 3, clpz:clpz_neq(3, T_1) ; clpz:clpz_neq(3, 2 + 3)),
     builtin,
     [],
     []).
step((integer(3) -> (integer(2), integer(3) -> 3 =\= 2 - 3 ; T_2 is 3, clpz:clpz_neq(T_2, 2 - 3)) ; integer(2), integer(3) -> T_2 is 2 - 3, clpz:clpz_neq(3, T_2) ; clpz:clpz_neq(3, 2 - 3)),
     builtin,
     [],
     []).
step(safe_diagonals([1, 4, 2]),
     rule(4),
     ['Row' = 1, 'Rows' = [4, 2]],
     [safe_from(1, [4, 2], 1), safe_diagonals([4, 2])]).
step(safe_from(1, [4, 2], 1),
     rule(6),
     ['Row' = 1, 'Other' = 4, 'Rows' = [2], 'Distance' = 1, 'NextDistance' = 2],
     [(integer(1) -> (integer(4), integer(1) -> 1 =\= 4 + 1 ; T_1 is 1, clpz:clpz_neq(T_1, 4 + 1)) ; integer(4), integer(1) -> T_1 is 4 + 1, clpz:clpz_neq(1, T_1) ; clpz:clpz_neq(1, 4 + 1)),
      (integer(1) -> (integer(4), integer(1) -> 1 =\= 4 - 1 ; T_2 is 1, clpz:clpz_neq(T_2, 4 - 1)) ; integer(4), integer(1) -> T_2 is 4 - 1, clpz:clpz_neq(1, T_2) ; clpz:clpz_neq(1, 4 - 1)),
      2 is 1 + 1,
      safe_from(1, [2], 2)]).
step((integer(1) -> (integer(4), integer(1) -> 1 =\= 4 + 1 ; T_1 is 1, clpz:clpz_neq(T_1, 4 + 1)) ; integer(4), integer(1) -> T_1 is 4 + 1, clpz:clpz_neq(1, T_1) ; clpz:clpz_neq(1, 4 + 1)),
     builtin,
     [],
     []).
step((integer(1) -> (integer(4), integer(1) -> 1 =\= 4 - 1 ; T_2 is 1, clpz:clpz_neq(T_2, 4 - 1)) ; integer(4), integer(1) -> T_2 is 4 - 1, clpz:clpz_neq(1, T_2) ; clpz:clpz_neq(1, 4 - 1)),
     builtin,
     [],
     []).
step(safe_from(1, [2], 2),
     rule(6),
     ['Row' = 1, 'Other' = 2, 'Rows' = [], 'Distance' = 2, 'NextDistance' = 3],
     [(integer(1) -> (integer(2), integer(2) -> 1 =\= 2 + 2 ; T_1 is 1, clpz:clpz_neq(T_1, 2 + 2)) ; integer(2), integer(2) -> T_1 is 2 + 2, clpz:clpz_neq(1, T_1) ; clpz:clpz_neq(1, 2 + 2)),
      (integer(1) -> (integer(2), integer(2) -> 1 =\= 2 - 2 ; T_2 is 1, clpz:clpz_neq(T_2, 2 - 2)) ; integer(2), integer(2) -> T_2 is 2 - 2, clpz:clpz_neq(1, T_2) ; clpz:clpz_neq(1, 2 - 2)),
      3 is 2 + 1,
      safe_from(1, [], 3)]).
step((integer(1) -> (integer(2), integer(2) -> 1 =\= 2 + 2 ; T_1 is 1, clpz:clpz_neq(T_1, 2 + 2)) ; integer(2), integer(2) -> T_1 is 2 + 2, clpz:clpz_neq(1, T_1) ; clpz:clpz_neq(1, 2 + 2)),
     builtin,
     [],
     []).
step((integer(1) -> (integer(2), integer(2) -> 1 =\= 2 - 2 ; T_2 is 1, clpz:clpz_neq(T_2, 2 - 2)) ; integer(2), integer(2) -> T_2 is 2 - 2, clpz:clpz_neq(1, T_2) ; clpz:clpz_neq(1, 2 - 2)),
     builtin,
     [],
     []).
step(safe_from(1, [], 3), fact(5), [], []).
step(safe_diagonals([4, 2]),
     rule(4),
     ['Row' = 4, 'Rows' = [2]],
     [safe_from(4, [2], 1), safe_diagonals([2])]).
step(safe_from(4, [2], 1),
     rule(6),
     ['Row' = 4, 'Other' = 2, 'Rows' = [], 'Distance' = 1, 'NextDistance' = 2],
     [(integer(4) -> (integer(2), integer(1) -> 4 =\= 2 + 1 ; T_1 is 4, clpz:clpz_neq(T_1, 2 + 1)) ; integer(2), integer(1) -> T_1 is 2 + 1, clpz:clpz_neq(4, T_1) ; clpz:clpz_neq(4, 2 + 1)),
      (integer(4) -> (integer(2), integer(1) -> 4 =\= 2 - 1 ; T_2 is 4, clpz:clpz_neq(T_2, 2 - 1)) ; integer(2), integer(1) -> T_2 is 2 - 1, clpz:clpz_neq(4, T_2) ; clpz:clpz_neq(4, 2 - 1)),
      2 is 1 + 1,
      safe_from(4, [], 2)]).
step((integer(4) -> (integer(2), integer(1) -> 4 =\= 2 + 1 ; T_1 is 4, clpz:clpz_neq(T_1, 2 + 1)) ; integer(2), integer(1) -> T_1 is 2 + 1, clpz:clpz_neq(4, T_1) ; clpz:clpz_neq(4, 2 + 1)),
     builtin,
     [],
     []).
step((integer(4) -> (integer(2), integer(1) -> 4 =\= 2 - 1 ; T_2 is 4, clpz:clpz_neq(T_2, 2 - 1)) ; integer(2), integer(1) -> T_2 is 2 - 1, clpz:clpz_neq(4, T_2) ; clpz:clpz_neq(4, 2 - 1)),
     builtin,
     [],
     []).
step(safe_from(4, [], 2), fact(5), [], []).
step(safe_diagonals([2]),
     rule(4),
     ['Row' = 2, 'Rows' = []],
     [safe_from(2, [], 1), safe_diagonals([])]).
step(safe_from(2, [], 1), fact(5), [], []).
step(labeling([ff], [3, 1, 4, 2]), builtin, [], []).
