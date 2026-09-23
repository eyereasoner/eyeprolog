report(all_amounts, [7, 7, 5, 9]).
report(regional_total(north), 19).
report(regional_total(south), 9).
report(regions, [north, south]).
report(source_clause, visible).

clause(6,
       regional_total(var('Region'), var('Total')),
       (bagof(var('Amount'), var('Seller') ^ sale(var('Region'), var('Seller'), var('Amount')), var('Amounts')),
        sum_amounts(var('Amounts'), var('Total')))).
clause(7, sum_amounts([], 0), true).
clause(8,
       sum_amounts([var('Amount') | var('Rest')], var('Total')),
       (sum_amounts(var('Rest'), var('Partial')),
        var('Total') is var('Amount') + var('Partial'))).
clause(9,
       report(all_amounts, var('Amounts')),
       findall(var('Amount'), sale(anonymous(1), anonymous(2), var('Amount')), var('Amounts'))).
clause(10,
       report(regional_total(var('Region')), var('Total')),
       regional_total(var('Region'), var('Total'))).
clause(11,
       report(regions, var('Regions')),
       setof(var('Region'), var('Seller') ^ var('Amount') ^ sale(var('Region'), var('Seller'), var('Amount')), var('Regions'))).
clause(12, report(source_clause, visible), clause(sale(north, ada, 7), true)).

step(report(all_amounts, [7, 7, 5, 9]),
     rule(9),
     ['Amounts' = [7, 7, 5, 9]],
     [findall(Amount, sale(__anon0, __anon1, Amount), [7, 7, 5, 9])]).
step(findall(Amount, sale(__anon0, __anon1, Amount), [7, 7, 5, 9]), collected, [], []).
step(report(regional_total(north), 19),
     rule(10),
     ['Region' = north, 'Total' = 19],
     [regional_total(north, 19)]).
step(regional_total(north, 19),
     rule(6),
     ['Region' = north, 'Total' = 19, 'Amounts' = [7, 7, 5]],
     [bagof(Amount, Seller ^ sale(north, Seller, Amount), [7, 7, 5]),
      sum_amounts([7, 7, 5], 19)]).
step(bagof(Amount, Seller ^ sale(north, Seller, Amount), [7, 7, 5]), builtin, [], []).
step(sum_amounts([7, 7, 5], 19),
     rule(8),
     ['Amount' = 7, 'Rest' = [7, 5], 'Total' = 19, 'Partial' = 12],
     [sum_amounts([7, 5], 12), 19 is 7 + 12]).
step(sum_amounts([7, 5], 12),
     rule(8),
     ['Amount' = 7, 'Rest' = [5], 'Total' = 12, 'Partial' = 5],
     [sum_amounts([5], 5), 12 is 7 + 5]).
step(sum_amounts([5], 5),
     rule(8),
     ['Amount' = 5, 'Rest' = [], 'Total' = 5, 'Partial' = 0],
     [sum_amounts([], 0), 5 is 5 + 0]).
step(sum_amounts([], 0), fact(7), [], []).
step(5 is 5 + 0, builtin, [], []).
step(12 is 7 + 5, builtin, [], []).
step(19 is 7 + 12, builtin, [], []).
step(report(regional_total(south), 9),
     rule(10),
     ['Region' = south, 'Total' = 9],
     [regional_total(south, 9)]).
step(regional_total(south, 9),
     rule(6),
     ['Region' = south, 'Total' = 9, 'Amounts' = [9]],
     [bagof(Amount, Seller ^ sale(south, Seller, Amount), [9]), sum_amounts([9], 9)]).
step(bagof(Amount, Seller ^ sale(south, Seller, Amount), [9]), builtin, [], []).
step(sum_amounts([9], 9),
     rule(8),
     ['Amount' = 9, 'Rest' = [], 'Total' = 9, 'Partial' = 0],
     [sum_amounts([], 0), 9 is 9 + 0]).
step(9 is 9 + 0, builtin, [], []).
step(report(regions, [north, south]),
     rule(11),
     ['Regions' = [north, south]],
     [setof(Region, Seller ^ Amount ^ sale(Region, Seller, Amount), [north, south])]).
step(setof(Region, Seller ^ Amount ^ sale(Region, Seller, Amount), [north, south]),
     builtin,
     [],
     []).
step(report(source_clause, visible), rule(12), [], [clause(sale(north, ada, 7), true)]).
step(clause(sale(north, ada, 7), true), builtin, [], []).
