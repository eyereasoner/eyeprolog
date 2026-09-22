color(map_eu, [[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]).
why(
  color(map_eu, [[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
  step(
    color(map_eu, [[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
    rule("four-color-map.pl", clause(106)),
    ['Colours' = [[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
    [
      step(
        map_valid(map_eu),
        rule("four-color-map.pl", clause(104)),
        [],
        [
          step(
            all_countries_coloured(map_eu),
            rule("four-color-map.pl", clause(102)),
            ['Countries' = [belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], 'Uniquecountries' = [austria, belgium, bulgaria, croatia, cyprus, czech_republic, denmark, estonia, finland, france, germany, greece, hungary, ireland, italy, latvia, lithuania, luxemburg, malta, netherlands, poland, portugal, romania, slovakia, slovenia, spain, sweden], 'Count' = 27],
            [
              step(findall(Country, valid_assignment(Country), [belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia]), builtin(findall, 3), [], []),
              step(sort([belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [austria, belgium, bulgaria, croatia, cyprus, czech_republic, denmark, estonia, finland, france, germany, greece, hungary, ireland, italy, latvia, lithuania, luxemburg, malta, netherlands, poland, portugal, romania, slovakia, slovenia, spain, sweden]), builtin(sort, 2), [], []),
              step(length([austria, belgium, bulgaria, croatia, cyprus, czech_republic, denmark, estonia, finland, france, germany, greece, hungary, ireland, italy, latvia, lithuania, luxemburg, malta, netherlands, poland, portugal, romania, slovakia, slovenia, spain, sweden], 27), library(length, 2), [], []),
              step(country_count(27), fact("four-color-map.pl", clause(100)), [], [])
            ]
          ),
          step(
            all_borders_checked(map_eu),
            rule("four-color-map.pl", clause(103)),
            ['Borders' = [[belgium, france], [belgium, netherlands], [belgium, luxemburg], [belgium, germany], [netherlands, germany], [luxemburg, france], [luxemburg, germany], [france, spain], [france, germany], [france, italy], [germany, denmark], [germany, austria], [germany, poland], [germany, czech_republic], [italy, austria], [italy, slovenia], [greece, bulgaria], [spain, portugal], [austria, czech_republic], [austria, hungary], [austria, slovenia], [austria, slovakia], [sweden, finland], [poland, czech_republic], [poland, slovakia], [poland, lithuania], [hungary, slovakia], [hungary, romania], [hungary, croatia], [hungary, slovenia], [czech_republic, slovakia], [slovakia, austria], [slovenia, croatia], [estonia, latvia], [latvia, lithuania], [bulgaria, romania]], 'Uniqueborders' = [[austria, czech_republic], [austria, hungary], [austria, slovakia], [austria, slovenia], [belgium, france], [belgium, germany], [belgium, luxemburg], [belgium, netherlands], [bulgaria, romania], [czech_republic, slovakia], [estonia, latvia], [france, germany], [france, italy], [france, spain], [germany, austria], [germany, czech_republic], [germany, denmark], [germany, poland], [greece, bulgaria], [hungary, croatia], [hungary, romania], [hungary, slovakia], [hungary, slovenia], [italy, austria], [italy, slovenia], [latvia, lithuania], [luxemburg, france], [luxemburg, germany], [netherlands, germany], [poland, czech_republic], [poland, lithuania], [poland, slovakia], [slovakia, austria], [slovenia, croatia], [spain, portugal], [sweden, finland]], 'Count' = 36],
            [
              step(findall([A, B], border_colours_differ(A, B), [[belgium, france], [belgium, netherlands], [belgium, luxemburg], [belgium, germany], [netherlands, germany], [luxemburg, france], [luxemburg, germany], [france, spain], [france, germany], [france, italy], [germany, denmark], [germany, austria], [germany, poland], [germany, czech_republic], [italy, austria], [italy, slovenia], [greece, bulgaria], [spain, portugal], [austria, czech_republic], [austria, hungary], [austria, slovenia], [austria, slovakia], [sweden, finland], [poland, czech_republic], [poland, slovakia], [poland, lithuania], [hungary, slovakia], [hungary, romania], [hungary, croatia], [hungary, slovenia], [czech_republic, slovakia], [slovakia, austria], [slovenia, croatia], [estonia, latvia], [latvia, lithuania], [bulgaria, romania]]), builtin(findall, 3), [], []),
              step(sort([[belgium, france], [belgium, netherlands], [belgium, luxemburg], [belgium, germany], [netherlands, germany], [luxemburg, france], [luxemburg, germany], [france, spain], [france, germany], [france, italy], [germany, denmark], [germany, austria], [germany, poland], [germany, czech_republic], [italy, austria], [italy, slovenia], [greece, bulgaria], [spain, portugal], [austria, czech_republic], [austria, hungary], [austria, slovenia], [austria, slovakia], [sweden, finland], [poland, czech_republic], [poland, slovakia], [poland, lithuania], [hungary, slovakia], [hungary, romania], [hungary, croatia], [hungary, slovenia], [czech_republic, slovakia], [slovakia, austria], [slovenia, croatia], [estonia, latvia], [latvia, lithuania], [bulgaria, romania]], [[austria, czech_republic], [austria, hungary], [austria, slovakia], [austria, slovenia], [belgium, france], [belgium, germany], [belgium, luxemburg], [belgium, netherlands], [bulgaria, romania], [czech_republic, slovakia], [estonia, latvia], [france, germany], [france, italy], [france, spain], [germany, austria], [germany, czech_republic], [germany, denmark], [germany, poland], [greece, bulgaria], [hungary, croatia], [hungary, romania], [hungary, slovakia], [hungary, slovenia], [italy, austria], [italy, slovenia], [latvia, lithuania], [luxemburg, france], [luxemburg, germany], [netherlands, germany], [poland, czech_republic], [poland, lithuania], [poland, slovakia], [slovakia, austria], [slovenia, croatia], [spain, portugal], [sweden, finland]]), builtin(sort, 2), [], []),
              step(length([[austria, czech_republic], [austria, hungary], [austria, slovakia], [austria, slovenia], [belgium, france], [belgium, germany], [belgium, luxemburg], [belgium, netherlands], [bulgaria, romania], [czech_republic, slovakia], [estonia, latvia], [france, germany], [france, italy], [france, spain], [germany, austria], [germany, czech_republic], [germany, denmark], [germany, poland], [greece, bulgaria], [hungary, croatia], [hungary, romania], [hungary, slovakia], [hungary, slovenia], [italy, austria], [italy, slovenia], [latvia, lithuania], [luxemburg, france], [luxemburg, germany], [netherlands, germany], [poland, czech_republic], [poland, lithuania], [poland, slovakia], [slovakia, austria], [slovenia, croatia], [spain, portugal], [sweden, finland]], 36), library(length, 2), [], []),
              step(border_count(36), fact("four-color-map.pl", clause(101)), [], [])
            ]
          )
        ]
      ),
      step(colouring([[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), fact("four-color-map.pl", clause(105)), [], [])
    ]
  )
).

status(map_eu, valid_four_colour_assignment).
why(
  status(map_eu, valid_four_colour_assignment),
  step(
    status(map_eu, valid_four_colour_assignment),
    rule("four-color-map.pl", clause(107)),
    [],
    [
      step(
        map_valid(map_eu),
        rule("four-color-map.pl", clause(104)),
        [],
        [
          step(
            all_countries_coloured(map_eu),
            rule("four-color-map.pl", clause(102)),
            ['Countries' = [belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], 'Uniquecountries' = [austria, belgium, bulgaria, croatia, cyprus, czech_republic, denmark, estonia, finland, france, germany, greece, hungary, ireland, italy, latvia, lithuania, luxemburg, malta, netherlands, poland, portugal, romania, slovakia, slovenia, spain, sweden], 'Count' = 27],
            [
              step(findall(Country, valid_assignment(Country), [belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia]), builtin(findall, 3), [], []),
              step(sort([belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [austria, belgium, bulgaria, croatia, cyprus, czech_republic, denmark, estonia, finland, france, germany, greece, hungary, ireland, italy, latvia, lithuania, luxemburg, malta, netherlands, poland, portugal, romania, slovakia, slovenia, spain, sweden]), builtin(sort, 2), [], []),
              step(length([austria, belgium, bulgaria, croatia, cyprus, czech_republic, denmark, estonia, finland, france, germany, greece, hungary, ireland, italy, latvia, lithuania, luxemburg, malta, netherlands, poland, portugal, romania, slovakia, slovenia, spain, sweden], 27), library(length, 2), [], []),
              step(country_count(27), fact("four-color-map.pl", clause(100)), [], [])
            ]
          ),
          step(
            all_borders_checked(map_eu),
            rule("four-color-map.pl", clause(103)),
            ['Borders' = [[belgium, france], [belgium, netherlands], [belgium, luxemburg], [belgium, germany], [netherlands, germany], [luxemburg, france], [luxemburg, germany], [france, spain], [france, germany], [france, italy], [germany, denmark], [germany, austria], [germany, poland], [germany, czech_republic], [italy, austria], [italy, slovenia], [greece, bulgaria], [spain, portugal], [austria, czech_republic], [austria, hungary], [austria, slovenia], [austria, slovakia], [sweden, finland], [poland, czech_republic], [poland, slovakia], [poland, lithuania], [hungary, slovakia], [hungary, romania], [hungary, croatia], [hungary, slovenia], [czech_republic, slovakia], [slovakia, austria], [slovenia, croatia], [estonia, latvia], [latvia, lithuania], [bulgaria, romania]], 'Uniqueborders' = [[austria, czech_republic], [austria, hungary], [austria, slovakia], [austria, slovenia], [belgium, france], [belgium, germany], [belgium, luxemburg], [belgium, netherlands], [bulgaria, romania], [czech_republic, slovakia], [estonia, latvia], [france, germany], [france, italy], [france, spain], [germany, austria], [germany, czech_republic], [germany, denmark], [germany, poland], [greece, bulgaria], [hungary, croatia], [hungary, romania], [hungary, slovakia], [hungary, slovenia], [italy, austria], [italy, slovenia], [latvia, lithuania], [luxemburg, france], [luxemburg, germany], [netherlands, germany], [poland, czech_republic], [poland, lithuania], [poland, slovakia], [slovakia, austria], [slovenia, croatia], [spain, portugal], [sweden, finland]], 'Count' = 36],
            [
              step(findall([A, B], border_colours_differ(A, B), [[belgium, france], [belgium, netherlands], [belgium, luxemburg], [belgium, germany], [netherlands, germany], [luxemburg, france], [luxemburg, germany], [france, spain], [france, germany], [france, italy], [germany, denmark], [germany, austria], [germany, poland], [germany, czech_republic], [italy, austria], [italy, slovenia], [greece, bulgaria], [spain, portugal], [austria, czech_republic], [austria, hungary], [austria, slovenia], [austria, slovakia], [sweden, finland], [poland, czech_republic], [poland, slovakia], [poland, lithuania], [hungary, slovakia], [hungary, romania], [hungary, croatia], [hungary, slovenia], [czech_republic, slovakia], [slovakia, austria], [slovenia, croatia], [estonia, latvia], [latvia, lithuania], [bulgaria, romania]]), builtin(findall, 3), [], []),
              step(sort([[belgium, france], [belgium, netherlands], [belgium, luxemburg], [belgium, germany], [netherlands, germany], [luxemburg, france], [luxemburg, germany], [france, spain], [france, germany], [france, italy], [germany, denmark], [germany, austria], [germany, poland], [germany, czech_republic], [italy, austria], [italy, slovenia], [greece, bulgaria], [spain, portugal], [austria, czech_republic], [austria, hungary], [austria, slovenia], [austria, slovakia], [sweden, finland], [poland, czech_republic], [poland, slovakia], [poland, lithuania], [hungary, slovakia], [hungary, romania], [hungary, croatia], [hungary, slovenia], [czech_republic, slovakia], [slovakia, austria], [slovenia, croatia], [estonia, latvia], [latvia, lithuania], [bulgaria, romania]], [[austria, czech_republic], [austria, hungary], [austria, slovakia], [austria, slovenia], [belgium, france], [belgium, germany], [belgium, luxemburg], [belgium, netherlands], [bulgaria, romania], [czech_republic, slovakia], [estonia, latvia], [france, germany], [france, italy], [france, spain], [germany, austria], [germany, czech_republic], [germany, denmark], [germany, poland], [greece, bulgaria], [hungary, croatia], [hungary, romania], [hungary, slovakia], [hungary, slovenia], [italy, austria], [italy, slovenia], [latvia, lithuania], [luxemburg, france], [luxemburg, germany], [netherlands, germany], [poland, czech_republic], [poland, lithuania], [poland, slovakia], [slovakia, austria], [slovenia, croatia], [spain, portugal], [sweden, finland]]), builtin(sort, 2), [], []),
              step(length([[austria, czech_republic], [austria, hungary], [austria, slovakia], [austria, slovenia], [belgium, france], [belgium, germany], [belgium, luxemburg], [belgium, netherlands], [bulgaria, romania], [czech_republic, slovakia], [estonia, latvia], [france, germany], [france, italy], [france, spain], [germany, austria], [germany, czech_republic], [germany, denmark], [germany, poland], [greece, bulgaria], [hungary, croatia], [hungary, romania], [hungary, slovakia], [hungary, slovenia], [italy, austria], [italy, slovenia], [latvia, lithuania], [luxemburg, france], [luxemburg, germany], [netherlands, germany], [poland, czech_republic], [poland, lithuania], [poland, slovakia], [slovakia, austria], [slovenia, croatia], [spain, portugal], [sweden, finland]], 36), library(length, 2), [], []),
              step(border_count(36), fact("four-color-map.pl", clause(101)), [], [])
            ]
          )
        ]
      )
    ]
  )
).

reason(map_eu, "no neighbouring countries share a colour").
why(
  reason(map_eu, "no neighbouring countries share a colour"),
  step(
    reason(map_eu, "no neighbouring countries share a colour"),
    rule("four-color-map.pl", clause(108)),
    [],
    [
      step(
        map_valid(map_eu),
        rule("four-color-map.pl", clause(104)),
        [],
        [
          step(
            all_countries_coloured(map_eu),
            rule("four-color-map.pl", clause(102)),
            ['Countries' = [belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], 'Uniquecountries' = [austria, belgium, bulgaria, croatia, cyprus, czech_republic, denmark, estonia, finland, france, germany, greece, hungary, ireland, italy, latvia, lithuania, luxemburg, malta, netherlands, poland, portugal, romania, slovakia, slovenia, spain, sweden], 'Count' = 27],
            [
              step(findall(Country, valid_assignment(Country), [belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia]), builtin(findall, 3), [], []),
              step(sort([belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [austria, belgium, bulgaria, croatia, cyprus, czech_republic, denmark, estonia, finland, france, germany, greece, hungary, ireland, italy, latvia, lithuania, luxemburg, malta, netherlands, poland, portugal, romania, slovakia, slovenia, spain, sweden]), builtin(sort, 2), [], []),
              step(length([austria, belgium, bulgaria, croatia, cyprus, czech_republic, denmark, estonia, finland, france, germany, greece, hungary, ireland, italy, latvia, lithuania, luxemburg, malta, netherlands, poland, portugal, romania, slovakia, slovenia, spain, sweden], 27), library(length, 2), [], []),
              step(country_count(27), fact("four-color-map.pl", clause(100)), [], [])
            ]
          ),
          step(
            all_borders_checked(map_eu),
            rule("four-color-map.pl", clause(103)),
            ['Borders' = [[belgium, france], [belgium, netherlands], [belgium, luxemburg], [belgium, germany], [netherlands, germany], [luxemburg, france], [luxemburg, germany], [france, spain], [france, germany], [france, italy], [germany, denmark], [germany, austria], [germany, poland], [germany, czech_republic], [italy, austria], [italy, slovenia], [greece, bulgaria], [spain, portugal], [austria, czech_republic], [austria, hungary], [austria, slovenia], [austria, slovakia], [sweden, finland], [poland, czech_republic], [poland, slovakia], [poland, lithuania], [hungary, slovakia], [hungary, romania], [hungary, croatia], [hungary, slovenia], [czech_republic, slovakia], [slovakia, austria], [slovenia, croatia], [estonia, latvia], [latvia, lithuania], [bulgaria, romania]], 'Uniqueborders' = [[austria, czech_republic], [austria, hungary], [austria, slovakia], [austria, slovenia], [belgium, france], [belgium, germany], [belgium, luxemburg], [belgium, netherlands], [bulgaria, romania], [czech_republic, slovakia], [estonia, latvia], [france, germany], [france, italy], [france, spain], [germany, austria], [germany, czech_republic], [germany, denmark], [germany, poland], [greece, bulgaria], [hungary, croatia], [hungary, romania], [hungary, slovakia], [hungary, slovenia], [italy, austria], [italy, slovenia], [latvia, lithuania], [luxemburg, france], [luxemburg, germany], [netherlands, germany], [poland, czech_republic], [poland, lithuania], [poland, slovakia], [slovakia, austria], [slovenia, croatia], [spain, portugal], [sweden, finland]], 'Count' = 36],
            [
              step(findall([A, B], border_colours_differ(A, B), [[belgium, france], [belgium, netherlands], [belgium, luxemburg], [belgium, germany], [netherlands, germany], [luxemburg, france], [luxemburg, germany], [france, spain], [france, germany], [france, italy], [germany, denmark], [germany, austria], [germany, poland], [germany, czech_republic], [italy, austria], [italy, slovenia], [greece, bulgaria], [spain, portugal], [austria, czech_republic], [austria, hungary], [austria, slovenia], [austria, slovakia], [sweden, finland], [poland, czech_republic], [poland, slovakia], [poland, lithuania], [hungary, slovakia], [hungary, romania], [hungary, croatia], [hungary, slovenia], [czech_republic, slovakia], [slovakia, austria], [slovenia, croatia], [estonia, latvia], [latvia, lithuania], [bulgaria, romania]]), builtin(findall, 3), [], []),
              step(sort([[belgium, france], [belgium, netherlands], [belgium, luxemburg], [belgium, germany], [netherlands, germany], [luxemburg, france], [luxemburg, germany], [france, spain], [france, germany], [france, italy], [germany, denmark], [germany, austria], [germany, poland], [germany, czech_republic], [italy, austria], [italy, slovenia], [greece, bulgaria], [spain, portugal], [austria, czech_republic], [austria, hungary], [austria, slovenia], [austria, slovakia], [sweden, finland], [poland, czech_republic], [poland, slovakia], [poland, lithuania], [hungary, slovakia], [hungary, romania], [hungary, croatia], [hungary, slovenia], [czech_republic, slovakia], [slovakia, austria], [slovenia, croatia], [estonia, latvia], [latvia, lithuania], [bulgaria, romania]], [[austria, czech_republic], [austria, hungary], [austria, slovakia], [austria, slovenia], [belgium, france], [belgium, germany], [belgium, luxemburg], [belgium, netherlands], [bulgaria, romania], [czech_republic, slovakia], [estonia, latvia], [france, germany], [france, italy], [france, spain], [germany, austria], [germany, czech_republic], [germany, denmark], [germany, poland], [greece, bulgaria], [hungary, croatia], [hungary, romania], [hungary, slovakia], [hungary, slovenia], [italy, austria], [italy, slovenia], [latvia, lithuania], [luxemburg, france], [luxemburg, germany], [netherlands, germany], [poland, czech_republic], [poland, lithuania], [poland, slovakia], [slovakia, austria], [slovenia, croatia], [spain, portugal], [sweden, finland]]), builtin(sort, 2), [], []),
              step(length([[austria, czech_republic], [austria, hungary], [austria, slovakia], [austria, slovenia], [belgium, france], [belgium, germany], [belgium, luxemburg], [belgium, netherlands], [bulgaria, romania], [czech_republic, slovakia], [estonia, latvia], [france, germany], [france, italy], [france, spain], [germany, austria], [germany, czech_republic], [germany, denmark], [germany, poland], [greece, bulgaria], [hungary, croatia], [hungary, romania], [hungary, slovakia], [hungary, slovenia], [italy, austria], [italy, slovenia], [latvia, lithuania], [luxemburg, france], [luxemburg, germany], [netherlands, germany], [poland, czech_republic], [poland, lithuania], [poland, slovakia], [slovakia, austria], [slovenia, croatia], [spain, portugal], [sweden, finland]], 36), library(length, 2), [], []),
              step(border_count(36), fact("four-color-map.pl", clause(101)), [], [])
            ]
          )
        ]
      )
    ]
  )
).

