catalan_answer(catalan_12, 208012).
catalan_answer(triangulations_14_gon, 208012).
catalan_answer(parenthesizations_13_factors, 208012).
catalan_answer(first_ten_sum, 6918).

clause(3,
       catalan(var('N'), var('C')),
       (var('N') > 0,
        var('N1') is var('N') - 1,
        sumall(var('Product'), (between(0, var('N1'), var('I')), var('J') is var('N1') - var('I'), catalan(var('I'), var('A')), catalan(var('J'), var('B')), var('Product') is var('A') * var('B')), var('C')))).
clause(4,
       polygon_triangulations(var('Sides'), var('Count')),
       (var('Sides') >= 3, var('N') is var('Sides') - 2, catalan(var('N'), var('Count')))).
clause(5,
       parenthesizations(var('Factors'), var('Count')),
       (var('Factors') >= 1, var('N') is var('Factors') - 1, catalan(var('N'), var('Count')))).
clause(6, catalan_answer(catalan_12, var('C')), catalan(12, var('C'))).
clause(7,
       catalan_answer(triangulations_14_gon, var('Count')),
       polygon_triangulations(14, var('Count'))).
clause(8,
       catalan_answer(parenthesizations_13_factors, var('Count')),
       parenthesizations(13, var('Count'))).
clause(9,
       catalan_answer(first_ten_sum, var('Sum')),
       sumall(var('C'), (between(0, 9, var('N')), catalan(var('N'), var('C'))), var('Sum'))).

step(catalan_answer(catalan_12, 208012), rule(6), ['C' = 208012], [catalan(12, 208012)]).
step(catalan(12, 208012),
     rule(3),
     ['N' = 12, 'C' = 208012, 'N1' = 11],
     [12 > 0,
      11 is 12 - 1,
      sumall(Expression, (between(0, 11, I), J is 11 - I, catalan(I, A), catalan(J, B), Expression is A * B), 208012)]).
step(12 > 0, builtin, [], []).
step(11 is 12 - 1, builtin, [], []).
step(sumall(Expression, (between(0, 11, I), J is 11 - I, catalan(I, A), catalan(J, B), Expression is A * B), 208012),
     builtin,
     [],
     []).
step(catalan_answer(triangulations_14_gon, 208012),
     rule(7),
     ['Count' = 208012],
     [polygon_triangulations(14, 208012)]).
step(polygon_triangulations(14, 208012),
     rule(4),
     ['Sides' = 14, 'Count' = 208012, 'N' = 12],
     [14 >= 3, 12 is 14 - 2, catalan(12, 208012)]).
step(14 >= 3, builtin, [], []).
step(12 is 14 - 2, builtin, [], []).
step(catalan_answer(parenthesizations_13_factors, 208012),
     rule(8),
     ['Count' = 208012],
     [parenthesizations(13, 208012)]).
step(parenthesizations(13, 208012),
     rule(5),
     ['Factors' = 13, 'Count' = 208012, 'N' = 12],
     [13 >= 1, 12 is 13 - 1, catalan(12, 208012)]).
step(13 >= 1, builtin, [], []).
step(12 is 13 - 1, builtin, [], []).
step(catalan_answer(first_ten_sum, 6918),
     rule(9),
     ['Sum' = 6918],
     [sumall(Expression, (between(0, 9, N), catalan(N, Expression)), 6918)]).
step(sumall(Expression, (between(0, 9, N), catalan(N, Expression)), 6918), builtin, [], []).
