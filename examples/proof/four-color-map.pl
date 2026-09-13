color(map_eu, [[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]).
why(
  color(map_eu, [[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
  proof(
    goal(color(map_eu, [[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])),
    by(rule("four-color-map.pl", clause(106))),
    bindings([binding("Colours", [[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]),
    uses([
      proof(
        goal(map_valid(map_eu)),
        by(rule("four-color-map.pl", clause(104))),
        uses([
          proof(
            goal(all_countries_coloured(map_eu)),
            by(rule("four-color-map.pl", clause(102))),
            bindings([binding("Countries", [belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia]), binding("Uniquecountries", [austria, belgium, bulgaria, croatia, cyprus, czech_republic, denmark, estonia, finland, france, germany, greece, hungary, ireland, italy, latvia, lithuania, luxemburg, malta, netherlands, poland, portugal, romania, slovakia, slovenia, spain, sweden]), binding("Count", 27)]),
            uses([
              proof(
                goal(findall(Country, valid_assignment(Country), [belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia])),
                by(builtin(findall, 3))
              ),
              proof(
                goal(sort([belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [austria, belgium, bulgaria, croatia, cyprus, czech_republic, denmark, estonia, finland, france, germany, greece, hungary, ireland, italy, latvia, lithuania, luxemburg, malta, netherlands, poland, portugal, romania, slovakia, slovenia, spain, sweden])),
                by(builtin(sort, 2))
              ),
              proof(
                goal(length([austria, belgium, bulgaria, croatia, cyprus, czech_republic, denmark, estonia, finland, france, germany, greece, hungary, ireland, italy, latvia, lithuania, luxemburg, malta, netherlands, poland, portugal, romania, slovakia, slovenia, spain, sweden], 27)),
                by(library(length, 2))
              ),
              proof(
                goal(country_count(27)),
                by(fact("four-color-map.pl", clause(100)))
              )
            ])
          ),
          proof(
            goal(all_borders_checked(map_eu)),
            by(rule("four-color-map.pl", clause(103))),
            bindings([binding("Borders", [[belgium, france], [belgium, netherlands], [belgium, luxemburg], [belgium, germany], [netherlands, germany], [luxemburg, france], [luxemburg, germany], [france, spain], [france, germany], [france, italy], [germany, denmark], [germany, austria], [germany, poland], [germany, czech_republic], [italy, austria], [italy, slovenia], [greece, bulgaria], [spain, portugal], [austria, czech_republic], [austria, hungary], [austria, slovenia], [austria, slovakia], [sweden, finland], [poland, czech_republic], [poland, slovakia], [poland, lithuania], [hungary, slovakia], [hungary, romania], [hungary, croatia], [hungary, slovenia], [czech_republic, slovakia], [slovakia, austria], [slovenia, croatia], [estonia, latvia], [latvia, lithuania], [bulgaria, romania]]), binding("Uniqueborders", [[austria, czech_republic], [austria, hungary], [austria, slovakia], [austria, slovenia], [belgium, france], [belgium, germany], [belgium, luxemburg], [belgium, netherlands], [bulgaria, romania], [czech_republic, slovakia], [estonia, latvia], [france, germany], [france, italy], [france, spain], [germany, austria], [germany, czech_republic], [germany, denmark], [germany, poland], [greece, bulgaria], [hungary, croatia], [hungary, romania], [hungary, slovakia], [hungary, slovenia], [italy, austria], [italy, slovenia], [latvia, lithuania], [luxemburg, france], [luxemburg, germany], [netherlands, germany], [poland, czech_republic], [poland, lithuania], [poland, slovakia], [slovakia, austria], [slovenia, croatia], [spain, portugal], [sweden, finland]]), binding("Count", 36)]),
            uses([
              proof(
                goal(findall([A, B], border_colours_differ(A, B), [[belgium, france], [belgium, netherlands], [belgium, luxemburg], [belgium, germany], [netherlands, germany], [luxemburg, france], [luxemburg, germany], [france, spain], [france, germany], [france, italy], [germany, denmark], [germany, austria], [germany, poland], [germany, czech_republic], [italy, austria], [italy, slovenia], [greece, bulgaria], [spain, portugal], [austria, czech_republic], [austria, hungary], [austria, slovenia], [austria, slovakia], [sweden, finland], [poland, czech_republic], [poland, slovakia], [poland, lithuania], [hungary, slovakia], [hungary, romania], [hungary, croatia], [hungary, slovenia], [czech_republic, slovakia], [slovakia, austria], [slovenia, croatia], [estonia, latvia], [latvia, lithuania], [bulgaria, romania]])),
                by(builtin(findall, 3))
              ),
              proof(
                goal(sort([[belgium, france], [belgium, netherlands], [belgium, luxemburg], [belgium, germany], [netherlands, germany], [luxemburg, france], [luxemburg, germany], [france, spain], [france, germany], [france, italy], [germany, denmark], [germany, austria], [germany, poland], [germany, czech_republic], [italy, austria], [italy, slovenia], [greece, bulgaria], [spain, portugal], [austria, czech_republic], [austria, hungary], [austria, slovenia], [austria, slovakia], [sweden, finland], [poland, czech_republic], [poland, slovakia], [poland, lithuania], [hungary, slovakia], [hungary, romania], [hungary, croatia], [hungary, slovenia], [czech_republic, slovakia], [slovakia, austria], [slovenia, croatia], [estonia, latvia], [latvia, lithuania], [bulgaria, romania]], [[austria, czech_republic], [austria, hungary], [austria, slovakia], [austria, slovenia], [belgium, france], [belgium, germany], [belgium, luxemburg], [belgium, netherlands], [bulgaria, romania], [czech_republic, slovakia], [estonia, latvia], [france, germany], [france, italy], [france, spain], [germany, austria], [germany, czech_republic], [germany, denmark], [germany, poland], [greece, bulgaria], [hungary, croatia], [hungary, romania], [hungary, slovakia], [hungary, slovenia], [italy, austria], [italy, slovenia], [latvia, lithuania], [luxemburg, france], [luxemburg, germany], [netherlands, germany], [poland, czech_republic], [poland, lithuania], [poland, slovakia], [slovakia, austria], [slovenia, croatia], [spain, portugal], [sweden, finland]])),
                by(builtin(sort, 2))
              ),
              proof(
                goal(length([[austria, czech_republic], [austria, hungary], [austria, slovakia], [austria, slovenia], [belgium, france], [belgium, germany], [belgium, luxemburg], [belgium, netherlands], [bulgaria, romania], [czech_republic, slovakia], [estonia, latvia], [france, germany], [france, italy], [france, spain], [germany, austria], [germany, czech_republic], [germany, denmark], [germany, poland], [greece, bulgaria], [hungary, croatia], [hungary, romania], [hungary, slovakia], [hungary, slovenia], [italy, austria], [italy, slovenia], [latvia, lithuania], [luxemburg, france], [luxemburg, germany], [netherlands, germany], [poland, czech_republic], [poland, lithuania], [poland, slovakia], [slovakia, austria], [slovenia, croatia], [spain, portugal], [sweden, finland]], 36)),
                by(library(length, 2))
              ),
              proof(
                goal(border_count(36)),
                by(fact("four-color-map.pl", clause(101)))
              )
            ])
          )
        ])
      ),
      proof(
        goal(colouring([[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])),
        by(fact("four-color-map.pl", clause(105)))
      )
    ])
  )
).

status(map_eu, valid_four_colour_assignment).
why(
  status(map_eu, valid_four_colour_assignment),
  proof(
    goal(status(map_eu, valid_four_colour_assignment)),
    by(rule("four-color-map.pl", clause(107))),
    uses([
      proof(
        goal(map_valid(map_eu)),
        by(rule("four-color-map.pl", clause(104))),
        uses([
          proof(
            goal(all_countries_coloured(map_eu)),
            by(rule("four-color-map.pl", clause(102))),
            bindings([binding("Countries", [belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia]), binding("Uniquecountries", [austria, belgium, bulgaria, croatia, cyprus, czech_republic, denmark, estonia, finland, france, germany, greece, hungary, ireland, italy, latvia, lithuania, luxemburg, malta, netherlands, poland, portugal, romania, slovakia, slovenia, spain, sweden]), binding("Count", 27)]),
            uses([
              proof(
                goal(findall(Country, valid_assignment(Country), [belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia])),
                by(builtin(findall, 3))
              ),
              proof(
                goal(sort([belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [austria, belgium, bulgaria, croatia, cyprus, czech_republic, denmark, estonia, finland, france, germany, greece, hungary, ireland, italy, latvia, lithuania, luxemburg, malta, netherlands, poland, portugal, romania, slovakia, slovenia, spain, sweden])),
                by(builtin(sort, 2))
              ),
              proof(
                goal(length([austria, belgium, bulgaria, croatia, cyprus, czech_republic, denmark, estonia, finland, france, germany, greece, hungary, ireland, italy, latvia, lithuania, luxemburg, malta, netherlands, poland, portugal, romania, slovakia, slovenia, spain, sweden], 27)),
                by(library(length, 2))
              ),
              proof(
                goal(country_count(27)),
                by(fact("four-color-map.pl", clause(100)))
              )
            ])
          ),
          proof(
            goal(all_borders_checked(map_eu)),
            by(rule("four-color-map.pl", clause(103))),
            bindings([binding("Borders", [[belgium, france], [belgium, netherlands], [belgium, luxemburg], [belgium, germany], [netherlands, germany], [luxemburg, france], [luxemburg, germany], [france, spain], [france, germany], [france, italy], [germany, denmark], [germany, austria], [germany, poland], [germany, czech_republic], [italy, austria], [italy, slovenia], [greece, bulgaria], [spain, portugal], [austria, czech_republic], [austria, hungary], [austria, slovenia], [austria, slovakia], [sweden, finland], [poland, czech_republic], [poland, slovakia], [poland, lithuania], [hungary, slovakia], [hungary, romania], [hungary, croatia], [hungary, slovenia], [czech_republic, slovakia], [slovakia, austria], [slovenia, croatia], [estonia, latvia], [latvia, lithuania], [bulgaria, romania]]), binding("Uniqueborders", [[austria, czech_republic], [austria, hungary], [austria, slovakia], [austria, slovenia], [belgium, france], [belgium, germany], [belgium, luxemburg], [belgium, netherlands], [bulgaria, romania], [czech_republic, slovakia], [estonia, latvia], [france, germany], [france, italy], [france, spain], [germany, austria], [germany, czech_republic], [germany, denmark], [germany, poland], [greece, bulgaria], [hungary, croatia], [hungary, romania], [hungary, slovakia], [hungary, slovenia], [italy, austria], [italy, slovenia], [latvia, lithuania], [luxemburg, france], [luxemburg, germany], [netherlands, germany], [poland, czech_republic], [poland, lithuania], [poland, slovakia], [slovakia, austria], [slovenia, croatia], [spain, portugal], [sweden, finland]]), binding("Count", 36)]),
            uses([
              proof(
                goal(findall([A, B], border_colours_differ(A, B), [[belgium, france], [belgium, netherlands], [belgium, luxemburg], [belgium, germany], [netherlands, germany], [luxemburg, france], [luxemburg, germany], [france, spain], [france, germany], [france, italy], [germany, denmark], [germany, austria], [germany, poland], [germany, czech_republic], [italy, austria], [italy, slovenia], [greece, bulgaria], [spain, portugal], [austria, czech_republic], [austria, hungary], [austria, slovenia], [austria, slovakia], [sweden, finland], [poland, czech_republic], [poland, slovakia], [poland, lithuania], [hungary, slovakia], [hungary, romania], [hungary, croatia], [hungary, slovenia], [czech_republic, slovakia], [slovakia, austria], [slovenia, croatia], [estonia, latvia], [latvia, lithuania], [bulgaria, romania]])),
                by(builtin(findall, 3))
              ),
              proof(
                goal(sort([[belgium, france], [belgium, netherlands], [belgium, luxemburg], [belgium, germany], [netherlands, germany], [luxemburg, france], [luxemburg, germany], [france, spain], [france, germany], [france, italy], [germany, denmark], [germany, austria], [germany, poland], [germany, czech_republic], [italy, austria], [italy, slovenia], [greece, bulgaria], [spain, portugal], [austria, czech_republic], [austria, hungary], [austria, slovenia], [austria, slovakia], [sweden, finland], [poland, czech_republic], [poland, slovakia], [poland, lithuania], [hungary, slovakia], [hungary, romania], [hungary, croatia], [hungary, slovenia], [czech_republic, slovakia], [slovakia, austria], [slovenia, croatia], [estonia, latvia], [latvia, lithuania], [bulgaria, romania]], [[austria, czech_republic], [austria, hungary], [austria, slovakia], [austria, slovenia], [belgium, france], [belgium, germany], [belgium, luxemburg], [belgium, netherlands], [bulgaria, romania], [czech_republic, slovakia], [estonia, latvia], [france, germany], [france, italy], [france, spain], [germany, austria], [germany, czech_republic], [germany, denmark], [germany, poland], [greece, bulgaria], [hungary, croatia], [hungary, romania], [hungary, slovakia], [hungary, slovenia], [italy, austria], [italy, slovenia], [latvia, lithuania], [luxemburg, france], [luxemburg, germany], [netherlands, germany], [poland, czech_republic], [poland, lithuania], [poland, slovakia], [slovakia, austria], [slovenia, croatia], [spain, portugal], [sweden, finland]])),
                by(builtin(sort, 2))
              ),
              proof(
                goal(length([[austria, czech_republic], [austria, hungary], [austria, slovakia], [austria, slovenia], [belgium, france], [belgium, germany], [belgium, luxemburg], [belgium, netherlands], [bulgaria, romania], [czech_republic, slovakia], [estonia, latvia], [france, germany], [france, italy], [france, spain], [germany, austria], [germany, czech_republic], [germany, denmark], [germany, poland], [greece, bulgaria], [hungary, croatia], [hungary, romania], [hungary, slovakia], [hungary, slovenia], [italy, austria], [italy, slovenia], [latvia, lithuania], [luxemburg, france], [luxemburg, germany], [netherlands, germany], [poland, czech_republic], [poland, lithuania], [poland, slovakia], [slovakia, austria], [slovenia, croatia], [spain, portugal], [sweden, finland]], 36)),
                by(library(length, 2))
              ),
              proof(
                goal(border_count(36)),
                by(fact("four-color-map.pl", clause(101)))
              )
            ])
          )
        ])
      )
    ])
  )
).

reason(map_eu, "no neighbouring countries share a colour").
why(
  reason(map_eu, "no neighbouring countries share a colour"),
  proof(
    goal(reason(map_eu, "no neighbouring countries share a colour")),
    by(rule("four-color-map.pl", clause(108))),
    uses([
      proof(
        goal(map_valid(map_eu)),
        by(rule("four-color-map.pl", clause(104))),
        uses([
          proof(
            goal(all_countries_coloured(map_eu)),
            by(rule("four-color-map.pl", clause(102))),
            bindings([binding("Countries", [belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia]), binding("Uniquecountries", [austria, belgium, bulgaria, croatia, cyprus, czech_republic, denmark, estonia, finland, france, germany, greece, hungary, ireland, italy, latvia, lithuania, luxemburg, malta, netherlands, poland, portugal, romania, slovakia, slovenia, spain, sweden]), binding("Count", 27)]),
            uses([
              proof(
                goal(findall(Country, valid_assignment(Country), [belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia])),
                by(builtin(findall, 3))
              ),
              proof(
                goal(sort([belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [austria, belgium, bulgaria, croatia, cyprus, czech_republic, denmark, estonia, finland, france, germany, greece, hungary, ireland, italy, latvia, lithuania, luxemburg, malta, netherlands, poland, portugal, romania, slovakia, slovenia, spain, sweden])),
                by(builtin(sort, 2))
              ),
              proof(
                goal(length([austria, belgium, bulgaria, croatia, cyprus, czech_republic, denmark, estonia, finland, france, germany, greece, hungary, ireland, italy, latvia, lithuania, luxemburg, malta, netherlands, poland, portugal, romania, slovakia, slovenia, spain, sweden], 27)),
                by(library(length, 2))
              ),
              proof(
                goal(country_count(27)),
                by(fact("four-color-map.pl", clause(100)))
              )
            ])
          ),
          proof(
            goal(all_borders_checked(map_eu)),
            by(rule("four-color-map.pl", clause(103))),
            bindings([binding("Borders", [[belgium, france], [belgium, netherlands], [belgium, luxemburg], [belgium, germany], [netherlands, germany], [luxemburg, france], [luxemburg, germany], [france, spain], [france, germany], [france, italy], [germany, denmark], [germany, austria], [germany, poland], [germany, czech_republic], [italy, austria], [italy, slovenia], [greece, bulgaria], [spain, portugal], [austria, czech_republic], [austria, hungary], [austria, slovenia], [austria, slovakia], [sweden, finland], [poland, czech_republic], [poland, slovakia], [poland, lithuania], [hungary, slovakia], [hungary, romania], [hungary, croatia], [hungary, slovenia], [czech_republic, slovakia], [slovakia, austria], [slovenia, croatia], [estonia, latvia], [latvia, lithuania], [bulgaria, romania]]), binding("Uniqueborders", [[austria, czech_republic], [austria, hungary], [austria, slovakia], [austria, slovenia], [belgium, france], [belgium, germany], [belgium, luxemburg], [belgium, netherlands], [bulgaria, romania], [czech_republic, slovakia], [estonia, latvia], [france, germany], [france, italy], [france, spain], [germany, austria], [germany, czech_republic], [germany, denmark], [germany, poland], [greece, bulgaria], [hungary, croatia], [hungary, romania], [hungary, slovakia], [hungary, slovenia], [italy, austria], [italy, slovenia], [latvia, lithuania], [luxemburg, france], [luxemburg, germany], [netherlands, germany], [poland, czech_republic], [poland, lithuania], [poland, slovakia], [slovakia, austria], [slovenia, croatia], [spain, portugal], [sweden, finland]]), binding("Count", 36)]),
            uses([
              proof(
                goal(findall([A, B], border_colours_differ(A, B), [[belgium, france], [belgium, netherlands], [belgium, luxemburg], [belgium, germany], [netherlands, germany], [luxemburg, france], [luxemburg, germany], [france, spain], [france, germany], [france, italy], [germany, denmark], [germany, austria], [germany, poland], [germany, czech_republic], [italy, austria], [italy, slovenia], [greece, bulgaria], [spain, portugal], [austria, czech_republic], [austria, hungary], [austria, slovenia], [austria, slovakia], [sweden, finland], [poland, czech_republic], [poland, slovakia], [poland, lithuania], [hungary, slovakia], [hungary, romania], [hungary, croatia], [hungary, slovenia], [czech_republic, slovakia], [slovakia, austria], [slovenia, croatia], [estonia, latvia], [latvia, lithuania], [bulgaria, romania]])),
                by(builtin(findall, 3))
              ),
              proof(
                goal(sort([[belgium, france], [belgium, netherlands], [belgium, luxemburg], [belgium, germany], [netherlands, germany], [luxemburg, france], [luxemburg, germany], [france, spain], [france, germany], [france, italy], [germany, denmark], [germany, austria], [germany, poland], [germany, czech_republic], [italy, austria], [italy, slovenia], [greece, bulgaria], [spain, portugal], [austria, czech_republic], [austria, hungary], [austria, slovenia], [austria, slovakia], [sweden, finland], [poland, czech_republic], [poland, slovakia], [poland, lithuania], [hungary, slovakia], [hungary, romania], [hungary, croatia], [hungary, slovenia], [czech_republic, slovakia], [slovakia, austria], [slovenia, croatia], [estonia, latvia], [latvia, lithuania], [bulgaria, romania]], [[austria, czech_republic], [austria, hungary], [austria, slovakia], [austria, slovenia], [belgium, france], [belgium, germany], [belgium, luxemburg], [belgium, netherlands], [bulgaria, romania], [czech_republic, slovakia], [estonia, latvia], [france, germany], [france, italy], [france, spain], [germany, austria], [germany, czech_republic], [germany, denmark], [germany, poland], [greece, bulgaria], [hungary, croatia], [hungary, romania], [hungary, slovakia], [hungary, slovenia], [italy, austria], [italy, slovenia], [latvia, lithuania], [luxemburg, france], [luxemburg, germany], [netherlands, germany], [poland, czech_republic], [poland, lithuania], [poland, slovakia], [slovakia, austria], [slovenia, croatia], [spain, portugal], [sweden, finland]])),
                by(builtin(sort, 2))
              ),
              proof(
                goal(length([[austria, czech_republic], [austria, hungary], [austria, slovakia], [austria, slovenia], [belgium, france], [belgium, germany], [belgium, luxemburg], [belgium, netherlands], [bulgaria, romania], [czech_republic, slovakia], [estonia, latvia], [france, germany], [france, italy], [france, spain], [germany, austria], [germany, czech_republic], [germany, denmark], [germany, poland], [greece, bulgaria], [hungary, croatia], [hungary, romania], [hungary, slovakia], [hungary, slovenia], [italy, austria], [italy, slovenia], [latvia, lithuania], [luxemburg, france], [luxemburg, germany], [netherlands, germany], [poland, czech_republic], [poland, lithuania], [poland, slovakia], [slovakia, austria], [slovenia, croatia], [spain, portugal], [sweden, finland]], 36)),
                by(library(length, 2))
              ),
              proof(
                goal(border_count(36)),
                by(fact("four-color-map.pl", clause(101)))
              )
            ])
          )
        ])
      )
    ])
  )
).

