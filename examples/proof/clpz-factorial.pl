factorial(6, 720).

clause(1, factorial(0, 1), true).
clause(2,
       factorial(var('N'), var('F')),
       ((integer(var('N')) -> var('N') >= 0 + 1 ; var('Var#1') = 1, clpz:clpz_geq(var('N'), var('Var#1'))),
        (integer(var('Previous')) -> (integer(var('N')) -> var('Previous') =:= var('N') - 1 ; var('T#2') is var('Previous'), clpz:clpz_equal(var('T#2'), var('N') - 1)) ; integer(var('N')) -> (true, var(var('Previous')) -> var('Previous') is var('N') - 1 ; var('T#2') is var('N') - 1, clpz:clpz_equal(var('Previous'), var('T#2'))) ; clpz:clpz_equal(var('Previous'), var('N') - 1)),
        factorial(var('Previous'), var('PreviousFactorial')),
        (integer(var('F')) -> (integer(var('N')), integer(var('PreviousFactorial')) -> var('F') =:= var('N') * var('PreviousFactorial') ; var('T#3') is var('F'), clpz:clpz_equal(var('T#3'), var('N') * var('PreviousFactorial'))) ; integer(var('N')), integer(var('PreviousFactorial')) -> (true, var(var('F')) -> var('F') is var('N') * var('PreviousFactorial') ; var('T#3') is var('N') * var('PreviousFactorial'), clpz:clpz_equal(var('F'), var('T#3'))) ; clpz:clpz_equal(var('F'), var('N') * var('PreviousFactorial'))))).

step(factorial(6, 720),
     rule(2),
     ['N' = 6, 'F' = 720, 'Previous' = 5, 'PreviousFactorial' = 120],
     [(integer(6) -> 6 >= 0 + 1 ; Var_1 = 1, clpz:clpz_geq(6, Var_1)),
      (integer(5) -> (integer(6) -> 5 =:= 6 - 1 ; T_2 is 5, clpz:clpz_equal(T_2, 6 - 1)) ; integer(6) -> (true, var(5) -> 5 is 6 - 1 ; T_2 is 6 - 1, clpz:clpz_equal(5, T_2)) ; clpz:clpz_equal(5, 6 - 1)),
      factorial(5, 120),
      (integer(720) -> (integer(6), integer(120) -> 720 =:= 6 * 120 ; T_3 is 720, clpz:clpz_equal(T_3, 6 * 120)) ; integer(6), integer(120) -> (true, var(720) -> 720 is 6 * 120 ; T_3 is 6 * 120, clpz:clpz_equal(720, T_3)) ; clpz:clpz_equal(720, 6 * 120))]).
step((integer(6) -> 6 >= 0 + 1 ; Var_1 = 1, clpz:clpz_geq(6, Var_1)), builtin, [], []).
step((integer(5) -> (integer(6) -> 5 =:= 6 - 1 ; T_2 is 5, clpz:clpz_equal(T_2, 6 - 1)) ; integer(6) -> (true, var(5) -> 5 is 6 - 1 ; T_2 is 6 - 1, clpz:clpz_equal(5, T_2)) ; clpz:clpz_equal(5, 6 - 1)),
     builtin,
     [],
     []).
step(factorial(5, 120),
     rule(2),
     ['N' = 5, 'F' = 120, 'Previous' = 4, 'PreviousFactorial' = 24],
     [(integer(5) -> 5 >= 0 + 1 ; Var_1 = 1, clpz:clpz_geq(5, Var_1)),
      (integer(4) -> (integer(5) -> 4 =:= 5 - 1 ; T_2 is 4, clpz:clpz_equal(T_2, 5 - 1)) ; integer(5) -> (true, var(4) -> 4 is 5 - 1 ; T_2 is 5 - 1, clpz:clpz_equal(4, T_2)) ; clpz:clpz_equal(4, 5 - 1)),
      factorial(4, 24),
      (integer(120) -> (integer(5), integer(24) -> 120 =:= 5 * 24 ; T_3 is 120, clpz:clpz_equal(T_3, 5 * 24)) ; integer(5), integer(24) -> (true, var(120) -> 120 is 5 * 24 ; T_3 is 5 * 24, clpz:clpz_equal(120, T_3)) ; clpz:clpz_equal(120, 5 * 24))]).
step((integer(5) -> 5 >= 0 + 1 ; Var_1 = 1, clpz:clpz_geq(5, Var_1)), builtin, [], []).
step((integer(4) -> (integer(5) -> 4 =:= 5 - 1 ; T_2 is 4, clpz:clpz_equal(T_2, 5 - 1)) ; integer(5) -> (true, var(4) -> 4 is 5 - 1 ; T_2 is 5 - 1, clpz:clpz_equal(4, T_2)) ; clpz:clpz_equal(4, 5 - 1)),
     builtin,
     [],
     []).
step(factorial(4, 24),
     rule(2),
     ['N' = 4, 'F' = 24, 'Previous' = 3, 'PreviousFactorial' = 6],
     [(integer(4) -> 4 >= 0 + 1 ; Var_1 = 1, clpz:clpz_geq(4, Var_1)),
      (integer(3) -> (integer(4) -> 3 =:= 4 - 1 ; T_2 is 3, clpz:clpz_equal(T_2, 4 - 1)) ; integer(4) -> (true, var(3) -> 3 is 4 - 1 ; T_2 is 4 - 1, clpz:clpz_equal(3, T_2)) ; clpz:clpz_equal(3, 4 - 1)),
      factorial(3, 6),
      (integer(24) -> (integer(4), integer(6) -> 24 =:= 4 * 6 ; T_3 is 24, clpz:clpz_equal(T_3, 4 * 6)) ; integer(4), integer(6) -> (true, var(24) -> 24 is 4 * 6 ; T_3 is 4 * 6, clpz:clpz_equal(24, T_3)) ; clpz:clpz_equal(24, 4 * 6))]).
step((integer(4) -> 4 >= 0 + 1 ; Var_1 = 1, clpz:clpz_geq(4, Var_1)), builtin, [], []).
step((integer(3) -> (integer(4) -> 3 =:= 4 - 1 ; T_2 is 3, clpz:clpz_equal(T_2, 4 - 1)) ; integer(4) -> (true, var(3) -> 3 is 4 - 1 ; T_2 is 4 - 1, clpz:clpz_equal(3, T_2)) ; clpz:clpz_equal(3, 4 - 1)),
     builtin,
     [],
     []).
step(factorial(3, 6),
     rule(2),
     ['N' = 3, 'F' = 6, 'Previous' = 2, 'PreviousFactorial' = 2],
     [(integer(3) -> 3 >= 0 + 1 ; Var_1 = 1, clpz:clpz_geq(3, Var_1)),
      (integer(2) -> (integer(3) -> 2 =:= 3 - 1 ; T_2 is 2, clpz:clpz_equal(T_2, 3 - 1)) ; integer(3) -> (true, var(2) -> 2 is 3 - 1 ; T_2 is 3 - 1, clpz:clpz_equal(2, T_2)) ; clpz:clpz_equal(2, 3 - 1)),
      factorial(2, 2),
      (integer(6) -> (integer(3), integer(2) -> 6 =:= 3 * 2 ; T_3 is 6, clpz:clpz_equal(T_3, 3 * 2)) ; integer(3), integer(2) -> (true, var(6) -> 6 is 3 * 2 ; T_3 is 3 * 2, clpz:clpz_equal(6, T_3)) ; clpz:clpz_equal(6, 3 * 2))]).
step((integer(3) -> 3 >= 0 + 1 ; Var_1 = 1, clpz:clpz_geq(3, Var_1)), builtin, [], []).
step((integer(2) -> (integer(3) -> 2 =:= 3 - 1 ; T_2 is 2, clpz:clpz_equal(T_2, 3 - 1)) ; integer(3) -> (true, var(2) -> 2 is 3 - 1 ; T_2 is 3 - 1, clpz:clpz_equal(2, T_2)) ; clpz:clpz_equal(2, 3 - 1)),
     builtin,
     [],
     []).
step(factorial(2, 2),
     rule(2),
     ['N' = 2, 'F' = 2, 'Previous' = 1, 'PreviousFactorial' = 1],
     [(integer(2) -> 2 >= 0 + 1 ; Var_1 = 1, clpz:clpz_geq(2, Var_1)),
      (integer(1) -> (integer(2) -> 1 =:= 2 - 1 ; T_2 is 1, clpz:clpz_equal(T_2, 2 - 1)) ; integer(2) -> (true, var(1) -> 1 is 2 - 1 ; T_2 is 2 - 1, clpz:clpz_equal(1, T_2)) ; clpz:clpz_equal(1, 2 - 1)),
      factorial(1, 1),
      (integer(2) -> (integer(2), integer(1) -> 2 =:= 2 * 1 ; T_3 is 2, clpz:clpz_equal(T_3, 2 * 1)) ; integer(2), integer(1) -> (true, var(2) -> 2 is 2 * 1 ; T_3 is 2 * 1, clpz:clpz_equal(2, T_3)) ; clpz:clpz_equal(2, 2 * 1))]).
step((integer(2) -> 2 >= 0 + 1 ; Var_1 = 1, clpz:clpz_geq(2, Var_1)), builtin, [], []).
step((integer(1) -> (integer(2) -> 1 =:= 2 - 1 ; T_2 is 1, clpz:clpz_equal(T_2, 2 - 1)) ; integer(2) -> (true, var(1) -> 1 is 2 - 1 ; T_2 is 2 - 1, clpz:clpz_equal(1, T_2)) ; clpz:clpz_equal(1, 2 - 1)),
     builtin,
     [],
     []).
step(factorial(1, 1),
     rule(2),
     ['N' = 1, 'F' = 1, 'Previous' = 0, 'PreviousFactorial' = 1],
     [(integer(1) -> 1 >= 0 + 1 ; Var_1 = 1, clpz:clpz_geq(1, Var_1)),
      (integer(0) -> (integer(1) -> 0 =:= 1 - 1 ; T_2 is 0, clpz:clpz_equal(T_2, 1 - 1)) ; integer(1) -> (true, var(0) -> 0 is 1 - 1 ; T_2 is 1 - 1, clpz:clpz_equal(0, T_2)) ; clpz:clpz_equal(0, 1 - 1)),
      factorial(0, 1),
      (integer(1) -> (integer(1), integer(1) -> 1 =:= 1 * 1 ; T_3 is 1, clpz:clpz_equal(T_3, 1 * 1)) ; integer(1), integer(1) -> (true, var(1) -> 1 is 1 * 1 ; T_3 is 1 * 1, clpz:clpz_equal(1, T_3)) ; clpz:clpz_equal(1, 1 * 1))]).
step((integer(1) -> 1 >= 0 + 1 ; Var_1 = 1, clpz:clpz_geq(1, Var_1)), builtin, [], []).
step((integer(0) -> (integer(1) -> 0 =:= 1 - 1 ; T_2 is 0, clpz:clpz_equal(T_2, 1 - 1)) ; integer(1) -> (true, var(0) -> 0 is 1 - 1 ; T_2 is 1 - 1, clpz:clpz_equal(0, T_2)) ; clpz:clpz_equal(0, 1 - 1)),
     builtin,
     [],
     []).
step(factorial(0, 1), fact(1), [], []).
step((integer(1) -> (integer(1), integer(1) -> 1 =:= 1 * 1 ; T_3 is 1, clpz:clpz_equal(T_3, 1 * 1)) ; integer(1), integer(1) -> (true, var(1) -> 1 is 1 * 1 ; T_3 is 1 * 1, clpz:clpz_equal(1, T_3)) ; clpz:clpz_equal(1, 1 * 1)),
     builtin,
     [],
     []).
step((integer(2) -> (integer(2), integer(1) -> 2 =:= 2 * 1 ; T_3 is 2, clpz:clpz_equal(T_3, 2 * 1)) ; integer(2), integer(1) -> (true, var(2) -> 2 is 2 * 1 ; T_3 is 2 * 1, clpz:clpz_equal(2, T_3)) ; clpz:clpz_equal(2, 2 * 1)),
     builtin,
     [],
     []).
step((integer(6) -> (integer(3), integer(2) -> 6 =:= 3 * 2 ; T_3 is 6, clpz:clpz_equal(T_3, 3 * 2)) ; integer(3), integer(2) -> (true, var(6) -> 6 is 3 * 2 ; T_3 is 3 * 2, clpz:clpz_equal(6, T_3)) ; clpz:clpz_equal(6, 3 * 2)),
     builtin,
     [],
     []).
step((integer(24) -> (integer(4), integer(6) -> 24 =:= 4 * 6 ; T_3 is 24, clpz:clpz_equal(T_3, 4 * 6)) ; integer(4), integer(6) -> (true, var(24) -> 24 is 4 * 6 ; T_3 is 4 * 6, clpz:clpz_equal(24, T_3)) ; clpz:clpz_equal(24, 4 * 6)),
     builtin,
     [],
     []).
step((integer(120) -> (integer(5), integer(24) -> 120 =:= 5 * 24 ; T_3 is 120, clpz:clpz_equal(T_3, 5 * 24)) ; integer(5), integer(24) -> (true, var(120) -> 120 is 5 * 24 ; T_3 is 5 * 24, clpz:clpz_equal(120, T_3)) ; clpz:clpz_equal(120, 5 * 24)),
     builtin,
     [],
     []).
step((integer(720) -> (integer(6), integer(120) -> 720 =:= 6 * 120 ; T_3 is 720, clpz:clpz_equal(T_3, 6 * 120)) ; integer(6), integer(120) -> (true, var(720) -> 720 is 6 * 120 ; T_3 is 6 * 120, clpz:clpz_equal(720, T_3)) ; clpz:clpz_equal(720, 6 * 120)),
     builtin,
     [],
     []).
