report(all_amounts, [7, 7, 5, 9]).
why(
  report(all_amounts, [7, 7, 5, 9]),
  step(
    report(all_amounts, [7, 7, 5, 9]),
    rule("iso-grouped-solutions.pl", clause(9)),
    ['Amounts' = [7, 7, 5, 9]],
    [
      step(findall(Amount, sale(__anon0, __anon1, Amount), [7, 7, 5, 9]), builtin(findall, 3), [], [])
    ]
  )
).

report(regional_total(north), 19).
why(
  report(regional_total(north), 19),
  step(
    report(regional_total(north), 19),
    rule("iso-grouped-solutions.pl", clause(10)),
    ['Region' = north, 'Total' = 19],
    [
      step(
        regional_total(north, 19),
        rule("iso-grouped-solutions.pl", clause(6)),
        ['Region' = north, 'Total' = 19, 'Amounts' = [7, 7, 5]],
        [
          step(bagof(Amount, ^(Seller, sale(north, Seller, Amount)), [7, 7, 5]), builtin(bagof, 3), [], []),
          step(
            sum_amounts([7, 7, 5], 19),
            rule("iso-grouped-solutions.pl", clause(8)),
            ['Amount' = 7, 'Rest' = [7, 5], 'Total' = 19, 'Partial' = 12],
            [
              step(
                sum_amounts([7, 5], 12),
                rule("iso-grouped-solutions.pl", clause(8)),
                ['Amount' = 7, 'Rest' = [5], 'Total' = 12, 'Partial' = 5],
                [
                  step(
                    sum_amounts([5], 5),
                    rule("iso-grouped-solutions.pl", clause(8)),
                    ['Amount' = 5, 'Rest' = [], 'Total' = 5, 'Partial' = 0],
                    [
                      step(sum_amounts([], 0), fact("iso-grouped-solutions.pl", clause(7)), [], []),
                      step(is(5, '+'(5, 0)), builtin(is, 2), [], [])
                    ]
                  ),
                  step(is(12, '+'(7, 5)), builtin(is, 2), [], [])
                ]
              ),
              step(is(19, '+'(7, 12)), builtin(is, 2), [], [])
            ]
          )
        ]
      )
    ]
  )
).

report(regional_total(south), 9).
why(
  report(regional_total(south), 9),
  step(
    report(regional_total(south), 9),
    rule("iso-grouped-solutions.pl", clause(10)),
    ['Region' = south, 'Total' = 9],
    [
      step(
        regional_total(south, 9),
        rule("iso-grouped-solutions.pl", clause(6)),
        ['Region' = south, 'Total' = 9, 'Amounts' = [9]],
        [
          step(bagof(Amount, ^(Seller, sale(south, Seller, Amount)), [9]), builtin(bagof, 3), [], []),
          step(
            sum_amounts([9], 9),
            rule("iso-grouped-solutions.pl", clause(8)),
            ['Amount' = 9, 'Rest' = [], 'Total' = 9, 'Partial' = 0],
            [
              step(sum_amounts([], 0), fact("iso-grouped-solutions.pl", clause(7)), [], []),
              step(is(9, '+'(9, 0)), builtin(is, 2), [], [])
            ]
          )
        ]
      )
    ]
  )
).

report(regions, [north, south]).
why(
  report(regions, [north, south]),
  step(
    report(regions, [north, south]),
    rule("iso-grouped-solutions.pl", clause(11)),
    ['Regions' = [north, south]],
    [
      step(setof(Region, ^(Seller, ^(Amount, sale(Region, Seller, Amount))), [north, south]), builtin(setof, 3), [], [])
    ]
  )
).

report(source_clause, visible).
why(
  report(source_clause, visible),
  step(
    report(source_clause, visible),
    rule("iso-grouped-solutions.pl", clause(12)),
    [],
    [
      step(clause(sale(north, ada, 7), true), builtin(clause, 2), [], [])
    ]
  )
).

