peano_answer(two_plus_three, s(s(s(s(s(z)))))).
peano_answer(two_times_three, s(s(s(s(s(s(z))))))).
peano_answer(factorial_four, s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))))))).

clause(1, padd(var('A'), z, var('A')), true).
clause(2, padd(var('A'), s(var('B')), s(var('C'))), padd(var('A'), var('B'), var('C'))).
clause(3, pmul(anonymous(1), z, z), true).
clause(4,
       pmul(var('A'), s(var('B')), var('C')),
       (pmul(var('A'), var('B'), var('D')), padd(var('A'), var('D'), var('C')))).
clause(5, pfact(var('N'), var('Value')), pfac(var('N'), s(z), var('Value'))).
clause(6, pfac(z, var('Acc'), var('Acc')), true).
clause(7,
       pfac(s(var('N')), var('Acc'), var('Value')),
       (pmul(var('Acc'), s(var('N')), var('Next')), pfac(var('N'), var('Next'), var('Value')))).
clause(8, peano_answer(two_plus_three, var('N')), padd(s(s(z)), s(s(s(z))), var('N'))).
clause(9, peano_answer(two_times_three, var('N')), pmul(s(s(z)), s(s(s(z))), var('N'))).
clause(10, peano_answer(factorial_four, var('N')), pfact(s(s(s(s(z)))), var('N'))).

step(peano_answer(two_plus_three, s(s(s(s(s(z)))))),
     rule(8),
     ['N' = s(s(s(s(s(z)))))],
     [padd(s(s(z)), s(s(s(z))), s(s(s(s(s(z))))))]).
step(padd(s(s(z)), s(s(s(z))), s(s(s(s(s(z)))))),
     rule(2),
     ['A' = s(s(z)), 'B' = s(s(z)), 'C' = s(s(s(s(z))))],
     [padd(s(s(z)), s(s(z)), s(s(s(s(z)))))]).
step(padd(s(s(z)), s(s(z)), s(s(s(s(z))))),
     rule(2),
     ['A' = s(s(z)), 'B' = s(z), 'C' = s(s(s(z)))],
     [padd(s(s(z)), s(z), s(s(s(z))))]).
step(padd(s(s(z)), s(z), s(s(s(z)))),
     rule(2),
     ['A' = s(s(z)), 'B' = z, 'C' = s(s(z))],
     [padd(s(s(z)), z, s(s(z)))]).
step(padd(s(s(z)), z, s(s(z))), fact(1), ['A' = s(s(z))], []).
step(peano_answer(two_times_three, s(s(s(s(s(s(z))))))),
     rule(9),
     ['N' = s(s(s(s(s(s(z))))))],
     [pmul(s(s(z)), s(s(s(z))), s(s(s(s(s(s(z)))))))]).
step(pmul(s(s(z)), s(s(s(z))), s(s(s(s(s(s(z))))))),
     rule(4),
     ['A' = s(s(z)), 'B' = s(s(z)), 'C' = s(s(s(s(s(s(z)))))), 'D' = s(s(s(s(z))))],
     [pmul(s(s(z)), s(s(z)), s(s(s(s(z))))), padd(s(s(z)), s(s(s(s(z)))), s(s(s(s(s(s(z)))))))]).
step(pmul(s(s(z)), s(s(z)), s(s(s(s(z))))),
     rule(4),
     ['A' = s(s(z)), 'B' = s(z), 'C' = s(s(s(s(z)))), 'D' = s(s(z))],
     [pmul(s(s(z)), s(z), s(s(z))), padd(s(s(z)), s(s(z)), s(s(s(s(z)))))]).
step(pmul(s(s(z)), s(z), s(s(z))),
     rule(4),
     ['A' = s(s(z)), 'B' = z, 'C' = s(s(z)), 'D' = z],
     [pmul(s(s(z)), z, z), padd(s(s(z)), z, s(s(z)))]).
step(pmul(s(s(z)), z, z), fact(3), [], []).
step(padd(s(s(z)), s(s(s(s(z)))), s(s(s(s(s(s(z))))))),
     rule(2),
     ['A' = s(s(z)), 'B' = s(s(s(z))), 'C' = s(s(s(s(s(z)))))],
     [padd(s(s(z)), s(s(s(z))), s(s(s(s(s(z))))))]).
step(peano_answer(factorial_four, s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))))))),
     rule(10),
     ['N' = s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))))))],
     [pfact(s(s(s(s(z)))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))))]).
step(pfact(s(s(s(s(z)))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))))))),
     rule(5),
     ['N' = s(s(s(s(z)))),
      'Value' = s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))))))],
     [pfac(s(s(s(s(z)))), s(z), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))))]).
step(pfac(s(s(s(s(z)))), s(z), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))))))),
     rule(7),
     ['N' = s(s(s(z))),
      'Acc' = s(z),
      'Value' = s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))),
      'Next' = s(s(s(s(z))))],
     [pmul(s(z), s(s(s(s(z)))), s(s(s(s(z))))),
      pfac(s(s(s(z))), s(s(s(s(z)))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))))]).
step(pmul(s(z), s(s(s(s(z)))), s(s(s(s(z))))),
     rule(4),
     ['A' = s(z), 'B' = s(s(s(z))), 'C' = s(s(s(s(z)))), 'D' = s(s(s(z)))],
     [pmul(s(z), s(s(s(z))), s(s(s(z)))), padd(s(z), s(s(s(z))), s(s(s(s(z)))))]).
step(pmul(s(z), s(s(s(z))), s(s(s(z)))),
     rule(4),
     ['A' = s(z), 'B' = s(s(z)), 'C' = s(s(s(z))), 'D' = s(s(z))],
     [pmul(s(z), s(s(z)), s(s(z))), padd(s(z), s(s(z)), s(s(s(z))))]).
step(pmul(s(z), s(s(z)), s(s(z))),
     rule(4),
     ['A' = s(z), 'B' = s(z), 'C' = s(s(z)), 'D' = s(z)],
     [pmul(s(z), s(z), s(z)), padd(s(z), s(z), s(s(z)))]).
step(pmul(s(z), s(z), s(z)),
     rule(4),
     ['A' = s(z), 'B' = z, 'C' = s(z), 'D' = z],
     [pmul(s(z), z, z), padd(s(z), z, s(z))]).
step(pmul(s(z), z, z), fact(3), [], []).
step(padd(s(z), z, s(z)), fact(1), ['A' = s(z)], []).
step(padd(s(z), s(z), s(s(z))),
     rule(2),
     ['A' = s(z), 'B' = z, 'C' = s(z)],
     [padd(s(z), z, s(z))]).
step(padd(s(z), s(s(z)), s(s(s(z)))),
     rule(2),
     ['A' = s(z), 'B' = s(z), 'C' = s(s(z))],
     [padd(s(z), s(z), s(s(z)))]).
step(padd(s(z), s(s(s(z))), s(s(s(s(z))))),
     rule(2),
     ['A' = s(z), 'B' = s(s(z)), 'C' = s(s(s(z)))],
     [padd(s(z), s(s(z)), s(s(s(z))))]).
step(pfac(s(s(s(z))), s(s(s(s(z)))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))))))),
     rule(7),
     ['N' = s(s(z)),
      'Acc' = s(s(s(s(z)))),
      'Value' = s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))),
      'Next' = s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))],
     [pmul(s(s(s(s(z)))), s(s(s(z))), s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))),
      pfac(s(s(z)), s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))))]).
step(pmul(s(s(s(s(z)))), s(s(s(z))), s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))),
     rule(4),
     ['A' = s(s(s(s(z)))),
      'B' = s(s(z)),
      'C' = s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))),
      'D' = s(s(s(s(s(s(s(s(z))))))))],
     [pmul(s(s(s(s(z)))), s(s(z)), s(s(s(s(s(s(s(s(z))))))))),
      padd(s(s(s(s(z)))), s(s(s(s(s(s(s(s(z)))))))), s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))]).
step(pmul(s(s(s(s(z)))), s(s(z)), s(s(s(s(s(s(s(s(z))))))))),
     rule(4),
     ['A' = s(s(s(s(z)))), 'B' = s(z), 'C' = s(s(s(s(s(s(s(s(z)))))))), 'D' = s(s(s(s(z))))],
     [pmul(s(s(s(s(z)))), s(z), s(s(s(s(z))))),
      padd(s(s(s(s(z)))), s(s(s(s(z)))), s(s(s(s(s(s(s(s(z)))))))))]).
step(pmul(s(s(s(s(z)))), s(z), s(s(s(s(z))))),
     rule(4),
     ['A' = s(s(s(s(z)))), 'B' = z, 'C' = s(s(s(s(z)))), 'D' = z],
     [pmul(s(s(s(s(z)))), z, z), padd(s(s(s(s(z)))), z, s(s(s(s(z)))))]).
step(pmul(s(s(s(s(z)))), z, z), fact(3), [], []).
step(padd(s(s(s(s(z)))), z, s(s(s(s(z))))), fact(1), ['A' = s(s(s(s(z))))], []).
step(padd(s(s(s(s(z)))), s(s(s(s(z)))), s(s(s(s(s(s(s(s(z))))))))),
     rule(2),
     ['A' = s(s(s(s(z)))), 'B' = s(s(s(z))), 'C' = s(s(s(s(s(s(s(z)))))))],
     [padd(s(s(s(s(z)))), s(s(s(z))), s(s(s(s(s(s(s(z))))))))]).
step(padd(s(s(s(s(z)))), s(s(s(z))), s(s(s(s(s(s(s(z)))))))),
     rule(2),
     ['A' = s(s(s(s(z)))), 'B' = s(s(z)), 'C' = s(s(s(s(s(s(z))))))],
     [padd(s(s(s(s(z)))), s(s(z)), s(s(s(s(s(s(z)))))))]).
step(padd(s(s(s(s(z)))), s(s(z)), s(s(s(s(s(s(z))))))),
     rule(2),
     ['A' = s(s(s(s(z)))), 'B' = s(z), 'C' = s(s(s(s(s(z)))))],
     [padd(s(s(s(s(z)))), s(z), s(s(s(s(s(z))))))]).
step(padd(s(s(s(s(z)))), s(z), s(s(s(s(s(z)))))),
     rule(2),
     ['A' = s(s(s(s(z)))), 'B' = z, 'C' = s(s(s(s(z))))],
     [padd(s(s(s(s(z)))), z, s(s(s(s(z)))))]).
step(padd(s(s(s(s(z)))), s(s(s(s(s(s(s(s(z)))))))), s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))),
     rule(2),
     ['A' = s(s(s(s(z)))),
      'B' = s(s(s(s(s(s(s(z))))))),
      'C' = s(s(s(s(s(s(s(s(s(s(s(z)))))))))))],
     [padd(s(s(s(s(z)))), s(s(s(s(s(s(s(z))))))), s(s(s(s(s(s(s(s(s(s(s(z))))))))))))]).
step(padd(s(s(s(s(z)))), s(s(s(s(s(s(s(z))))))), s(s(s(s(s(s(s(s(s(s(s(z)))))))))))),
     rule(2),
     ['A' = s(s(s(s(z)))), 'B' = s(s(s(s(s(s(z)))))), 'C' = s(s(s(s(s(s(s(s(s(s(z))))))))))],
     [padd(s(s(s(s(z)))), s(s(s(s(s(s(z)))))), s(s(s(s(s(s(s(s(s(s(z)))))))))))]).
step(padd(s(s(s(s(z)))), s(s(s(s(s(s(z)))))), s(s(s(s(s(s(s(s(s(s(z))))))))))),
     rule(2),
     ['A' = s(s(s(s(z)))), 'B' = s(s(s(s(s(z))))), 'C' = s(s(s(s(s(s(s(s(s(z)))))))))],
     [padd(s(s(s(s(z)))), s(s(s(s(s(z))))), s(s(s(s(s(s(s(s(s(z))))))))))]).
step(padd(s(s(s(s(z)))), s(s(s(s(s(z))))), s(s(s(s(s(s(s(s(s(z)))))))))),
     rule(2),
     ['A' = s(s(s(s(z)))), 'B' = s(s(s(s(z)))), 'C' = s(s(s(s(s(s(s(s(z))))))))],
     [padd(s(s(s(s(z)))), s(s(s(s(z)))), s(s(s(s(s(s(s(s(z)))))))))]).
step(pfac(s(s(z)), s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))))))),
     rule(7),
     ['N' = s(z),
      'Acc' = s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))),
      'Value' = s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))),
      'Next' = s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))))))],
     [pmul(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(z)), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))))))),
      pfac(s(z), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))))]).
step(pmul(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(z)), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))))))),
     rule(4),
     ['A' = s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))),
      'B' = s(z),
      'C' = s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))),
      'D' = s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))],
     [pmul(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(z), s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))),
      padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))))]).
step(pmul(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(z), s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))),
     rule(4),
     ['A' = s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))),
      'B' = z,
      'C' = s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))),
      'D' = z],
     [pmul(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), z, z),
      padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), z, s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))]).
step(pmul(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), z, z), fact(3), [], []).
step(padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), z, s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))),
     fact(1),
     ['A' = s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))],
     []).
step(padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))))))),
     rule(2),
     ['A' = s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))),
      'B' = s(s(s(s(s(s(s(s(s(s(s(z))))))))))),
      'C' = s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))],
     [padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(s(s(s(s(s(s(s(s(s(z))))))))))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))))))]).
step(padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(s(s(s(s(s(s(s(s(s(z))))))))))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))),
     rule(2),
     ['A' = s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))),
      'B' = s(s(s(s(s(s(s(s(s(s(z)))))))))),
      'C' = s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))))],
     [padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(s(s(s(s(s(s(s(s(z)))))))))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))]).
step(padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(s(s(s(s(s(s(s(s(z)))))))))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))))),
     rule(2),
     ['A' = s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))),
      'B' = s(s(s(s(s(s(s(s(s(z))))))))),
      'C' = s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))],
     [padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(s(s(s(s(s(s(s(z))))))))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))))]).
step(padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(s(s(s(s(s(s(s(z))))))))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))),
     rule(2),
     ['A' = s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))),
      'B' = s(s(s(s(s(s(s(s(z)))))))),
      'C' = s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))],
     [padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(s(s(s(s(s(s(z)))))))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))]).
step(padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(s(s(s(s(s(s(z)))))))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))),
     rule(2),
     ['A' = s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))),
      'B' = s(s(s(s(s(s(s(z))))))),
      'C' = s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))],
     [padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(s(s(s(s(s(z))))))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))]).
step(padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(s(s(s(s(s(z))))))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))),
     rule(2),
     ['A' = s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))),
      'B' = s(s(s(s(s(s(z)))))),
      'C' = s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))],
     [padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(s(s(s(s(z)))))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))]).
step(padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(s(s(s(s(z)))))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))),
     rule(2),
     ['A' = s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))),
      'B' = s(s(s(s(s(z))))),
      'C' = s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))],
     [padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(s(s(s(z))))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))]).
step(padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(s(s(s(z))))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))),
     rule(2),
     ['A' = s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))),
      'B' = s(s(s(s(z)))),
      'C' = s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))],
     [padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(s(s(z)))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))]).
step(padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(s(s(z)))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))),
     rule(2),
     ['A' = s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))),
      'B' = s(s(s(z))),
      'C' = s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))],
     [padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(s(z))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))]).
step(padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(s(z))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))),
     rule(2),
     ['A' = s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))),
      'B' = s(s(z)),
      'C' = s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))],
     [padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(z)), s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))]).
step(padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(s(z)), s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))),
     rule(2),
     ['A' = s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))),
      'B' = s(z),
      'C' = s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))],
     [padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(z), s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))]).
step(padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), s(z), s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))),
     rule(2),
     ['A' = s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))),
      'B' = z,
      'C' = s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))],
     [padd(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))), z, s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))]).
step(pfac(s(z), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))))))),
     rule(7),
     ['N' = z,
      'Acc' = s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))),
      'Value' = s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))),
      'Next' = s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))))))],
     [pmul(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))), s(z), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))))))),
      pfac(z, s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))))]).
step(pmul(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))), s(z), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))))))),
     rule(4),
     ['A' = s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))),
      'B' = z,
      'C' = s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))),
      'D' = z],
     [pmul(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))), z, z),
      padd(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))), z, s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))))]).
step(pmul(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))), z, z),
     fact(3),
     [],
     []).
step(padd(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))), z, s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))))))),
     fact(1),
     ['A' = s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))))))],
     []).
step(pfac(z, s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z)))))))))))))))))))))))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))))))),
     fact(6),
     ['Acc' = s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(z))))))))))))))))))))))))],
     []).
