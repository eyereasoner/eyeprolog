color(map_eu, [[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]).
status(map_eu, valid_four_colour_assignment).
reason(map_eu, "no neighbouring countries share a colour").

clause(100, country_count(27), true).
clause(101, border_count(36), true).
clause(102,
       all_countries_coloured(map_eu),
       (findall(var('Country'), valid_assignment(var('Country')), var('Countries')),
        sort(var('Countries'), var('Uniquecountries')),
        length(var('Uniquecountries'), var('Count')),
        country_count(var('Count')))).
clause(103,
       all_borders_checked(map_eu),
       (findall([var('A'), var('B')], border_colours_differ(var('A'), var('B')), var('Borders')),
        sort(var('Borders'), var('Uniqueborders')),
        length(var('Uniqueborders'), var('Count')),
        border_count(var('Count')))).
clause(104, map_valid(map_eu), (all_countries_coloured(map_eu), all_borders_checked(map_eu))).
clause(105,
       colouring([[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
       true).
clause(106, color(map_eu, var('Colours')), (map_valid(map_eu), colouring(var('Colours')))).
clause(107, status(map_eu, valid_four_colour_assignment), map_valid(map_eu)).
clause(108, reason(map_eu, "no neighbouring countries share a colour"), map_valid(map_eu)).

step(color(map_eu, [[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(106),
     ['Colours' = [[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [map_valid(map_eu),
      colouring([[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(map_valid(map_eu),
     rule(104),
     [],
     [all_countries_coloured(map_eu), all_borders_checked(map_eu)]).
step(all_countries_coloured(map_eu),
     rule(102),
     ['Countries' = [belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia],
      'Uniquecountries' = [austria, belgium, bulgaria, croatia, cyprus, czech_republic, denmark, estonia, finland, france, germany, greece, hungary, ireland, italy, latvia, lithuania, luxemburg, malta, netherlands, poland, portugal, romania, slovakia, slovenia, spain, sweden],
      'Count' = 27],
     [findall(Country, valid_assignment(Country), [belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia]),
      sort([belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [austria, belgium, bulgaria, croatia, cyprus, czech_republic, denmark, estonia, finland, france, germany, greece, hungary, ireland, italy, latvia, lithuania, luxemburg, malta, netherlands, poland, portugal, romania, slovakia, slovenia, spain, sweden]),
      length([austria, belgium, bulgaria, croatia, cyprus, czech_republic, denmark, estonia, finland, france, germany, greece, hungary, ireland, italy, latvia, lithuania, luxemburg, malta, netherlands, poland, portugal, romania, slovakia, slovenia, spain, sweden], 27),
      country_count(27)]).
step(findall(Country, valid_assignment(Country), [belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia]),
     collected,
     [],
     []).
step(sort([belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [austria, belgium, bulgaria, croatia, cyprus, czech_republic, denmark, estonia, finland, france, germany, greece, hungary, ireland, italy, latvia, lithuania, luxemburg, malta, netherlands, poland, portugal, romania, slovakia, slovenia, spain, sweden]),
     builtin,
     [],
     []).
step(length([austria, belgium, bulgaria, croatia, cyprus, czech_republic, denmark, estonia, finland, france, germany, greece, hungary, ireland, italy, latvia, lithuania, luxemburg, malta, netherlands, poland, portugal, romania, slovakia, slovenia, spain, sweden], 27),
     builtin,
     [],
     []).
step(country_count(27), fact(100), [], []).
step(all_borders_checked(map_eu),
     rule(103),
     ['Borders' = [[belgium, france], [belgium, netherlands], [belgium, luxemburg], [belgium, germany], [netherlands, germany], [luxemburg, france], [luxemburg, germany], [france, spain], [france, germany], [france, italy], [germany, denmark], [germany, austria], [germany, poland], [germany, czech_republic], [italy, austria], [italy, slovenia], [greece, bulgaria], [spain, portugal], [austria, czech_republic], [austria, hungary], [austria, slovenia], [austria, slovakia], [sweden, finland], [poland, czech_republic], [poland, slovakia], [poland, lithuania], [hungary, slovakia], [hungary, romania], [hungary, croatia], [hungary, slovenia], [czech_republic, slovakia], [slovakia, austria], [slovenia, croatia], [estonia, latvia], [latvia, lithuania], [bulgaria, romania]],
      'Uniqueborders' = [[austria, czech_republic], [austria, hungary], [austria, slovakia], [austria, slovenia], [belgium, france], [belgium, germany], [belgium, luxemburg], [belgium, netherlands], [bulgaria, romania], [czech_republic, slovakia], [estonia, latvia], [france, germany], [france, italy], [france, spain], [germany, austria], [germany, czech_republic], [germany, denmark], [germany, poland], [greece, bulgaria], [hungary, croatia], [hungary, romania], [hungary, slovakia], [hungary, slovenia], [italy, austria], [italy, slovenia], [latvia, lithuania], [luxemburg, france], [luxemburg, germany], [netherlands, germany], [poland, czech_republic], [poland, lithuania], [poland, slovakia], [slovakia, austria], [slovenia, croatia], [spain, portugal], [sweden, finland]],
      'Count' = 36],
     [findall([A, B], border_colours_differ(A, B), [[belgium, france], [belgium, netherlands], [belgium, luxemburg], [belgium, germany], [netherlands, germany], [luxemburg, france], [luxemburg, germany], [france, spain], [france, germany], [france, italy], [germany, denmark], [germany, austria], [germany, poland], [germany, czech_republic], [italy, austria], [italy, slovenia], [greece, bulgaria], [spain, portugal], [austria, czech_republic], [austria, hungary], [austria, slovenia], [austria, slovakia], [sweden, finland], [poland, czech_republic], [poland, slovakia], [poland, lithuania], [hungary, slovakia], [hungary, romania], [hungary, croatia], [hungary, slovenia], [czech_republic, slovakia], [slovakia, austria], [slovenia, croatia], [estonia, latvia], [latvia, lithuania], [bulgaria, romania]]),
      sort([[belgium, france], [belgium, netherlands], [belgium, luxemburg], [belgium, germany], [netherlands, germany], [luxemburg, france], [luxemburg, germany], [france, spain], [france, germany], [france, italy], [germany, denmark], [germany, austria], [germany, poland], [germany, czech_republic], [italy, austria], [italy, slovenia], [greece, bulgaria], [spain, portugal], [austria, czech_republic], [austria, hungary], [austria, slovenia], [austria, slovakia], [sweden, finland], [poland, czech_republic], [poland, slovakia], [poland, lithuania], [hungary, slovakia], [hungary, romania], [hungary, croatia], [hungary, slovenia], [czech_republic, slovakia], [slovakia, austria], [slovenia, croatia], [estonia, latvia], [latvia, lithuania], [bulgaria, romania]], [[austria, czech_republic], [austria, hungary], [austria, slovakia], [austria, slovenia], [belgium, france], [belgium, germany], [belgium, luxemburg], [belgium, netherlands], [bulgaria, romania], [czech_republic, slovakia], [estonia, latvia], [france, germany], [france, italy], [france, spain], [germany, austria], [germany, czech_republic], [germany, denmark], [germany, poland], [greece, bulgaria], [hungary, croatia], [hungary, romania], [hungary, slovakia], [hungary, slovenia], [italy, austria], [italy, slovenia], [latvia, lithuania], [luxemburg, france], [luxemburg, germany], [netherlands, germany], [poland, czech_republic], [poland, lithuania], [poland, slovakia], [slovakia, austria], [slovenia, croatia], [spain, portugal], [sweden, finland]]),
      length([[austria, czech_republic], [austria, hungary], [austria, slovakia], [austria, slovenia], [belgium, france], [belgium, germany], [belgium, luxemburg], [belgium, netherlands], [bulgaria, romania], [czech_republic, slovakia], [estonia, latvia], [france, germany], [france, italy], [france, spain], [germany, austria], [germany, czech_republic], [germany, denmark], [germany, poland], [greece, bulgaria], [hungary, croatia], [hungary, romania], [hungary, slovakia], [hungary, slovenia], [italy, austria], [italy, slovenia], [latvia, lithuania], [luxemburg, france], [luxemburg, germany], [netherlands, germany], [poland, czech_republic], [poland, lithuania], [poland, slovakia], [slovakia, austria], [slovenia, croatia], [spain, portugal], [sweden, finland]], 36),
      border_count(36)]).
step(findall([A, B], border_colours_differ(A, B), [[belgium, france], [belgium, netherlands], [belgium, luxemburg], [belgium, germany], [netherlands, germany], [luxemburg, france], [luxemburg, germany], [france, spain], [france, germany], [france, italy], [germany, denmark], [germany, austria], [germany, poland], [germany, czech_republic], [italy, austria], [italy, slovenia], [greece, bulgaria], [spain, portugal], [austria, czech_republic], [austria, hungary], [austria, slovenia], [austria, slovakia], [sweden, finland], [poland, czech_republic], [poland, slovakia], [poland, lithuania], [hungary, slovakia], [hungary, romania], [hungary, croatia], [hungary, slovenia], [czech_republic, slovakia], [slovakia, austria], [slovenia, croatia], [estonia, latvia], [latvia, lithuania], [bulgaria, romania]]),
     collected,
     [],
     []).
step(sort([[belgium, france], [belgium, netherlands], [belgium, luxemburg], [belgium, germany], [netherlands, germany], [luxemburg, france], [luxemburg, germany], [france, spain], [france, germany], [france, italy], [germany, denmark], [germany, austria], [germany, poland], [germany, czech_republic], [italy, austria], [italy, slovenia], [greece, bulgaria], [spain, portugal], [austria, czech_republic], [austria, hungary], [austria, slovenia], [austria, slovakia], [sweden, finland], [poland, czech_republic], [poland, slovakia], [poland, lithuania], [hungary, slovakia], [hungary, romania], [hungary, croatia], [hungary, slovenia], [czech_republic, slovakia], [slovakia, austria], [slovenia, croatia], [estonia, latvia], [latvia, lithuania], [bulgaria, romania]], [[austria, czech_republic], [austria, hungary], [austria, slovakia], [austria, slovenia], [belgium, france], [belgium, germany], [belgium, luxemburg], [belgium, netherlands], [bulgaria, romania], [czech_republic, slovakia], [estonia, latvia], [france, germany], [france, italy], [france, spain], [germany, austria], [germany, czech_republic], [germany, denmark], [germany, poland], [greece, bulgaria], [hungary, croatia], [hungary, romania], [hungary, slovakia], [hungary, slovenia], [italy, austria], [italy, slovenia], [latvia, lithuania], [luxemburg, france], [luxemburg, germany], [netherlands, germany], [poland, czech_republic], [poland, lithuania], [poland, slovakia], [slovakia, austria], [slovenia, croatia], [spain, portugal], [sweden, finland]]),
     builtin,
     [],
     []).
step(length([[austria, czech_republic], [austria, hungary], [austria, slovakia], [austria, slovenia], [belgium, france], [belgium, germany], [belgium, luxemburg], [belgium, netherlands], [bulgaria, romania], [czech_republic, slovakia], [estonia, latvia], [france, germany], [france, italy], [france, spain], [germany, austria], [germany, czech_republic], [germany, denmark], [germany, poland], [greece, bulgaria], [hungary, croatia], [hungary, romania], [hungary, slovakia], [hungary, slovenia], [italy, austria], [italy, slovenia], [latvia, lithuania], [luxemburg, france], [luxemburg, germany], [netherlands, germany], [poland, czech_republic], [poland, lithuania], [poland, slovakia], [slovakia, austria], [slovenia, croatia], [spain, portugal], [sweden, finland]], 36),
     builtin,
     [],
     []).
step(border_count(36), fact(101), [], []).
step(colouring([[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     fact(105),
     [],
     []).
step(status(map_eu, valid_four_colour_assignment), rule(107), [], [map_valid(map_eu)]).
step(reason(map_eu, "no neighbouring countries share a colour"),
     rule(108),
     [],
     [map_valid(map_eu)]).
