% Prolog result format 4
query(1, totient_answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = phi_36, 'X1' = 12]).
why(1, ['X0' = phi_36, 'X1' = 12], [totient_answer(phi_36, 12)]).
answer(1, ['X0' = phi_97, 'X1' = 96]).
why(1, ['X0' = phi_97, 'X1' = 96], [totient_answer(phi_97, 96)]).
answer(1, ['X0' = coprime_count_84, 'X1' = 24]).
why(1, ['X0' = coprime_count_84, 'X1' = 24], [totient_answer(coprime_count_84, 24)]).
answer(1, ['X0' = summatory_phi_30, 'X1' = 278]).
why(1, ['X0' = summatory_phi_30, 'X1' = 278], [totient_answer(summatory_phi_30, 278)]).

clause(5,
       totient(var('N'), var('Count')),
       (var('N') > 0, countall(coprime_upto(var('N'), anonymous(1)), var('Count')))).
clause(6,
       summatory_totient(var('Limit'), var('Sum')),
       sumall(var('Phi'), (between(1, var('Limit'), var('N')), totient(var('N'), var('Phi'))), var('Sum'))).
clause(7, totient_answer(phi_36, var('Phi')), totient(36, var('Phi'))).
clause(8, totient_answer(phi_97, var('Phi')), totient(97, var('Phi'))).
clause(9, totient_answer(coprime_count_84, var('Count')), totient(84, var('Count'))).
clause(10, totient_answer(summatory_phi_30, var('Sum')), summatory_totient(30, var('Sum'))).

step(totient_answer(phi_36, 12), rule(7), ['Phi' = 12], [totient(36, 12)]).
step(totient(36, 12),
     rule(5),
     ['N' = 36, 'Count' = 12],
     [36 > 0, countall(coprime_upto(36, _k), 12)]).
step(36 > 0, builtin, [], []).
step(countall(coprime_upto(36, _k), 12), builtin, [], []).
step(totient_answer(phi_97, 96), rule(8), ['Phi' = 96], [totient(97, 96)]).
step(totient(97, 96),
     rule(5),
     ['N' = 97, 'Count' = 96],
     [97 > 0, countall(coprime_upto(97, _k), 96)]).
step(97 > 0, builtin, [], []).
step(countall(coprime_upto(97, _k), 96), builtin, [], []).
step(totient_answer(coprime_count_84, 24), rule(9), ['Count' = 24], [totient(84, 24)]).
step(totient(84, 24),
     rule(5),
     ['N' = 84, 'Count' = 24],
     [84 > 0, countall(coprime_upto(84, _k), 24)]).
step(84 > 0, builtin, [], []).
step(countall(coprime_upto(84, _k), 24), builtin, [], []).
step(totient_answer(summatory_phi_30, 278),
     rule(10),
     ['Sum' = 278],
     [summatory_totient(30, 278)]).
step(summatory_totient(30, 278),
     rule(6),
     ['Limit' = 30, 'Sum' = 278],
     [sumall(Expression, (between(1, 30, N), totient(N, Expression)), 278)]).
step(sumall(Expression, (between(1, 30, N), totient(N, Expression)), 278), builtin, [], []).
