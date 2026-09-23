report(div_mod, quotient_remainder(-3, 2)).
report(quotient_rem, quotient_remainder(-2, -1)).
report(bit_mask, 4).
report(bit_union, 11).
report(left_shift, 12).

clause(1,
       report(div_mod, quotient_remainder(var('Q'), var('R'))),
       (var('Q') is -7 div 3, var('R') is -7 mod 3)).
clause(2,
       report(quotient_rem, quotient_remainder(var('Q'), var('R'))),
       (var('Q') is -7 // 3, var('R') is -7 rem 3)).
clause(3, report(bit_mask, var('Masked')), var('Masked') is 13 /\ 6).
clause(4, report(bit_union, var('Union')), var('Union') is 8 \/ 3).
clause(5, report(left_shift, var('Shifted')), var('Shifted') is 3 << 2).

step(report(div_mod, quotient_remainder(-3, 2)),
     rule(1),
     ['Q' = -3, 'R' = 2],
     [-3 is -7 div 3, 2 is -7 mod 3]).
step(-3 is -7 div 3, builtin, [], []).
step(2 is -7 mod 3, builtin, [], []).
step(report(quotient_rem, quotient_remainder(-2, -1)),
     rule(2),
     ['Q' = -2, 'R' = -1],
     [-2 is -7 // 3, -1 is -7 rem 3]).
step(-2 is -7 // 3, builtin, [], []).
step(-1 is -7 rem 3, builtin, [], []).
step(report(bit_mask, 4), rule(3), ['Masked' = 4], [4 is 13 /\ 6]).
step(4 is 13 /\ 6, builtin, [], []).
step(report(bit_union, 11), rule(4), ['Union' = 11], [11 is 8 \/ 3]).
step(11 is 8 \/ 3, builtin, [], []).
step(report(left_shift, 12), rule(5), ['Shifted' = 12], [12 is 3 << 2]).
step(12 is 3 << 2, builtin, [], []).
