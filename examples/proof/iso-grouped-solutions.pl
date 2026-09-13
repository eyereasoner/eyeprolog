report(all_amounts, [7, 7, 5, 9]).
why(
  report(all_amounts, [7, 7, 5, 9]),
  proof(
    goal(report(all_amounts, [7, 7, 5, 9])),
    by(rule("iso-grouped-solutions.pl", clause(9))),
    bindings([binding("Amounts", [7, 7, 5, 9])]),
    uses([
      proof(
        goal(findall(Amount, sale(__anon0, __anon1, Amount), [7, 7, 5, 9])),
        by(builtin(findall, 3))
      )
    ])
  )
).

report(regional_total(north), 19).
why(
  report(regional_total(north), 19),
  proof(
    goal(report(regional_total(north), 19)),
    by(rule("iso-grouped-solutions.pl", clause(10))),
    bindings([binding("Region", north), binding("Total", 19)]),
    uses([
      proof(
        goal(regional_total(north, 19)),
        by(rule("iso-grouped-solutions.pl", clause(6))),
        bindings([binding("Region", north), binding("Total", 19), binding("Amounts", [7, 7, 5])]),
        uses([
          proof(
            goal(bagof(Amount, ^(Seller, sale(north, Seller, Amount)), [7, 7, 5])),
            by(builtin(bagof, 3))
          ),
          proof(
            goal(sum_amounts([7, 7, 5], 19)),
            by(rule("iso-grouped-solutions.pl", clause(8))),
            bindings([binding("Amount", 7), binding("Rest", [7, 5]), binding("Total", 19), binding("Partial", 12)]),
            uses([
              proof(
                goal(sum_amounts([7, 5], 12)),
                by(rule("iso-grouped-solutions.pl", clause(8))),
                bindings([binding("Amount", 7), binding("Rest", [5]), binding("Total", 12), binding("Partial", 5)]),
                uses([
                  proof(
                    goal(sum_amounts([5], 5)),
                    by(rule("iso-grouped-solutions.pl", clause(8))),
                    bindings([binding("Amount", 5), binding("Rest", []), binding("Total", 5), binding("Partial", 0)]),
                    uses([
                      proof(
                        goal(sum_amounts([], 0)),
                        by(fact("iso-grouped-solutions.pl", clause(7)))
                      ),
                      proof(
                        goal(is(5, '+'(5, 0))),
                        by(builtin(is, 2))
                      )
                    ])
                  ),
                  proof(
                    goal(is(12, '+'(7, 5))),
                    by(builtin(is, 2))
                  )
                ])
              ),
              proof(
                goal(is(19, '+'(7, 12))),
                by(builtin(is, 2))
              )
            ])
          )
        ])
      )
    ])
  )
).

report(regional_total(south), 9).
why(
  report(regional_total(south), 9),
  proof(
    goal(report(regional_total(south), 9)),
    by(rule("iso-grouped-solutions.pl", clause(10))),
    bindings([binding("Region", south), binding("Total", 9)]),
    uses([
      proof(
        goal(regional_total(south, 9)),
        by(rule("iso-grouped-solutions.pl", clause(6))),
        bindings([binding("Region", south), binding("Total", 9), binding("Amounts", [9])]),
        uses([
          proof(
            goal(bagof(Amount, ^(Seller, sale(south, Seller, Amount)), [9])),
            by(builtin(bagof, 3))
          ),
          proof(
            goal(sum_amounts([9], 9)),
            by(rule("iso-grouped-solutions.pl", clause(8))),
            bindings([binding("Amount", 9), binding("Rest", []), binding("Total", 9), binding("Partial", 0)]),
            uses([
              proof(
                goal(sum_amounts([], 0)),
                by(fact("iso-grouped-solutions.pl", clause(7)))
              ),
              proof(
                goal(is(9, '+'(9, 0))),
                by(builtin(is, 2))
              )
            ])
          )
        ])
      )
    ])
  )
).

report(regions, [north, south]).
why(
  report(regions, [north, south]),
  proof(
    goal(report(regions, [north, south])),
    by(rule("iso-grouped-solutions.pl", clause(11))),
    bindings([binding("Regions", [north, south])]),
    uses([
      proof(
        goal(setof(Region, ^(Seller, ^(Amount, sale(Region, Seller, Amount))), [north, south])),
        by(builtin(setof, 3))
      )
    ])
  )
).

report(source_clause, visible).
why(
  report(source_clause, visible),
  proof(
    goal(report(source_clause, visible)),
    by(rule("iso-grouped-solutions.pl", clause(12))),
    uses([
      proof(
        goal(clause(sale(north, ada, 7), true)),
        by(builtin(clause, 2))
      )
    ])
  )
).

