four_color_answer(european_union, [[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]).

clause(1, color(red), true).
clause(2, color(green), true).
clause(3, color(blue), true).
clause(4, color(yellow), true).
clause(5,
       place_order([belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia]),
       true).
clause(6, neighbours(belgium, [france, netherlands, luxemburg, germany]), true).
clause(7, neighbours(netherlands, [belgium, germany]), true).
clause(8, neighbours(luxemburg, [belgium, france, germany]), true).
clause(9, neighbours(france, [spain, belgium, luxemburg, germany, italy]), true).
clause(10,
       neighbours(germany, [netherlands, belgium, luxemburg, denmark, france, austria, poland, czech_republic]),
       true).
clause(11, neighbours(italy, [france, austria, slovenia]), true).
clause(12, neighbours(denmark, [germany]), true).
clause(13, neighbours(ireland, []), true).
clause(14, neighbours(greece, [bulgaria]), true).
clause(15, neighbours(spain, [france, portugal]), true).
clause(16, neighbours(portugal, [spain]), true).
clause(17,
       neighbours(austria, [czech_republic, germany, hungary, italy, slovenia, slovakia]),
       true).
clause(18, neighbours(sweden, [finland]), true).
clause(19, neighbours(finland, [sweden]), true).
clause(20, neighbours(cyprus, []), true).
clause(21, neighbours(malta, []), true).
clause(22, neighbours(poland, [germany, czech_republic, slovakia, lithuania]), true).
clause(23, neighbours(hungary, [austria, slovakia, romania, croatia, slovenia]), true).
clause(24, neighbours(czech_republic, [germany, poland, slovakia, austria]), true).
clause(25, neighbours(slovakia, [czech_republic, poland, hungary, austria]), true).
clause(26, neighbours(slovenia, [austria, italy, hungary, croatia]), true).
clause(27, neighbours(estonia, [latvia]), true).
clause(28, neighbours(latvia, [estonia, lithuania]), true).
clause(29, neighbours(lithuania, [latvia, poland]), true).
clause(30, neighbours(bulgaria, [romania, greece]), true).
clause(31, neighbours(romania, [hungary, bulgaria]), true).
clause(32, neighbours(croatia, [slovenia, hungary]), true).
clause(33,
       valid_color(var('Place'), var('Color'), var('Assigned')),
       (neighbours(var('Place'), var('Neighbors')),
        \+ (member([var('Neighbor'), var('Color')], var('Assigned')), member(var('Neighbor'), var('Neighbors'))))).
clause(34, place_pairs([], []), true).
clause(35,
       place_pairs([var('Place') | var('Rest')], [[var('Place'), anonymous(1)] | var('Pairs')]),
       place_pairs(var('Rest'), var('Pairs'))).
clause(36, color_places([]), true).
clause(37,
       color_places([[var('Place'), var('Color')] | var('Tail')]),
       (color_places(var('Tail')),
        color(var('Color')),
        valid_color(var('Place'), var('Color'), var('Tail')))).
clause(38,
       four_color_answer(european_union, var('Coloring')),
       (place_order(var('Places')),
        place_pairs(var('Places'), var('Coloring')),
        once(color_places(var('Coloring'))))).

step(four_color_answer(european_union, [[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(38),
     ['Coloring' = [[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]],
      'Places' = [belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia]],
     [place_order([belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia]),
      place_pairs([belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
      once(color_places([[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]))]).
step(place_order([belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia]),
     fact(5),
     [],
     []).
step(place_pairs([belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(35),
     ['Place' = belgium,
      'Rest' = [netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia],
      'Pairs' = [[netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [place_pairs([netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(place_pairs([netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(35),
     ['Place' = netherlands,
      'Rest' = [luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia],
      'Pairs' = [[luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [place_pairs([luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(place_pairs([luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(35),
     ['Place' = luxemburg,
      'Rest' = [france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia],
      'Pairs' = [[france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [place_pairs([france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(place_pairs([france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(35),
     ['Place' = france,
      'Rest' = [germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia],
      'Pairs' = [[germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [place_pairs([germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(place_pairs([germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(35),
     ['Place' = germany,
      'Rest' = [italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia],
      'Pairs' = [[italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [place_pairs([italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(place_pairs([italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(35),
     ['Place' = italy,
      'Rest' = [denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia],
      'Pairs' = [[denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [place_pairs([denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(place_pairs([denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(35),
     ['Place' = denmark,
      'Rest' = [ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia],
      'Pairs' = [[ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [place_pairs([ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(place_pairs([ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(35),
     ['Place' = ireland,
      'Rest' = [greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia],
      'Pairs' = [[greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [place_pairs([greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(place_pairs([greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(35),
     ['Place' = greece,
      'Rest' = [spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia],
      'Pairs' = [[spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [place_pairs([spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(place_pairs([spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(35),
     ['Place' = spain,
      'Rest' = [portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia],
      'Pairs' = [[portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [place_pairs([portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(place_pairs([portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(35),
     ['Place' = portugal,
      'Rest' = [austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia],
      'Pairs' = [[austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [place_pairs([austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(place_pairs([austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(35),
     ['Place' = austria,
      'Rest' = [sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia],
      'Pairs' = [[sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [place_pairs([sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(place_pairs([sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(35),
     ['Place' = sweden,
      'Rest' = [finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia],
      'Pairs' = [[finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [place_pairs([finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(place_pairs([finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(35),
     ['Place' = finland,
      'Rest' = [cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia],
      'Pairs' = [[cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [place_pairs([cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(place_pairs([cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(35),
     ['Place' = cyprus,
      'Rest' = [malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia],
      'Pairs' = [[malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [place_pairs([malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(place_pairs([malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(35),
     ['Place' = malta,
      'Rest' = [poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia],
      'Pairs' = [[poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [place_pairs([poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(place_pairs([poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(35),
     ['Place' = poland,
      'Rest' = [hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia],
      'Pairs' = [[hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [place_pairs([hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(place_pairs([hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(35),
     ['Place' = hungary,
      'Rest' = [czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia],
      'Pairs' = [[czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [place_pairs([czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(place_pairs([czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(35),
     ['Place' = czech_republic,
      'Rest' = [slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia],
      'Pairs' = [[slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [place_pairs([slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(place_pairs([slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(35),
     ['Place' = slovakia,
      'Rest' = [slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia],
      'Pairs' = [[slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [place_pairs([slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(place_pairs([slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia], [[slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(35),
     ['Place' = slovenia,
      'Rest' = [estonia, latvia, lithuania, bulgaria, romania, croatia],
      'Pairs' = [[estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [place_pairs([estonia, latvia, lithuania, bulgaria, romania, croatia], [[estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(place_pairs([estonia, latvia, lithuania, bulgaria, romania, croatia], [[estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(35),
     ['Place' = estonia,
      'Rest' = [latvia, lithuania, bulgaria, romania, croatia],
      'Pairs' = [[latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [place_pairs([latvia, lithuania, bulgaria, romania, croatia], [[latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(place_pairs([latvia, lithuania, bulgaria, romania, croatia], [[latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(35),
     ['Place' = latvia,
      'Rest' = [lithuania, bulgaria, romania, croatia],
      'Pairs' = [[lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [place_pairs([lithuania, bulgaria, romania, croatia], [[lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(place_pairs([lithuania, bulgaria, romania, croatia], [[lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(35),
     ['Place' = lithuania,
      'Rest' = [bulgaria, romania, croatia],
      'Pairs' = [[bulgaria, green], [romania, red], [croatia, red]]],
     [place_pairs([bulgaria, romania, croatia], [[bulgaria, green], [romania, red], [croatia, red]])]).
step(place_pairs([bulgaria, romania, croatia], [[bulgaria, green], [romania, red], [croatia, red]]),
     rule(35),
     ['Place' = bulgaria,
      'Rest' = [romania, croatia],
      'Pairs' = [[romania, red], [croatia, red]]],
     [place_pairs([romania, croatia], [[romania, red], [croatia, red]])]).
step(place_pairs([romania, croatia], [[romania, red], [croatia, red]]),
     rule(35),
     ['Place' = romania, 'Rest' = [croatia], 'Pairs' = [[croatia, red]]],
     [place_pairs([croatia], [[croatia, red]])]).
step(place_pairs([croatia], [[croatia, red]]),
     rule(35),
     ['Place' = croatia, 'Rest' = [], 'Pairs' = []],
     [place_pairs([], [])]).
step(place_pairs([], []), fact(34), [], []).
step(once(color_places([[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])),
     builtin,
     [],
     [color_places([[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(color_places([[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(37),
     ['Place' = belgium,
      'Color' = yellow,
      'Tail' = [[netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [color_places([[netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
      color(yellow),
      valid_color(belgium, yellow, [[netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(color_places([[netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(37),
     ['Place' = netherlands,
      'Color' = green,
      'Tail' = [[luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [color_places([[luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
      color(green),
      valid_color(netherlands, green, [[luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(color_places([[luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(37),
     ['Place' = luxemburg,
      'Color' = green,
      'Tail' = [[france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [color_places([[france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
      color(green),
      valid_color(luxemburg, green, [[france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(color_places([[france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(37),
     ['Place' = france,
      'Color' = blue,
      'Tail' = [[germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [color_places([[germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
      color(blue),
      valid_color(france, blue, [[germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(color_places([[germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(37),
     ['Place' = germany,
      'Color' = red,
      'Tail' = [[italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [color_places([[italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
      color(red),
      valid_color(germany, red, [[italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(color_places([[italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(37),
     ['Place' = italy,
      'Color' = red,
      'Tail' = [[denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [color_places([[denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
      color(red),
      valid_color(italy, red, [[denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(color_places([[denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(37),
     ['Place' = denmark,
      'Color' = green,
      'Tail' = [[ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [color_places([[ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
      color(green),
      valid_color(denmark, green, [[ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(color_places([[ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(37),
     ['Place' = ireland,
      'Color' = red,
      'Tail' = [[greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [color_places([[greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
      color(red),
      valid_color(ireland, red, [[greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(color_places([[greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(37),
     ['Place' = greece,
      'Color' = red,
      'Tail' = [[spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [color_places([[spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
      color(red),
      valid_color(greece, red, [[spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(color_places([[spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(37),
     ['Place' = spain,
      'Color' = green,
      'Tail' = [[portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [color_places([[portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
      color(green),
      valid_color(spain, green, [[portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(color_places([[portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(37),
     ['Place' = portugal,
      'Color' = red,
      'Tail' = [[austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [color_places([[austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
      color(red),
      valid_color(portugal, red, [[austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(color_places([[austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(37),
     ['Place' = austria,
      'Color' = yellow,
      'Tail' = [[sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [color_places([[sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
      color(yellow),
      valid_color(austria, yellow, [[sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(color_places([[sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(37),
     ['Place' = sweden,
      'Color' = green,
      'Tail' = [[finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [color_places([[finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
      color(green),
      valid_color(sweden, green, [[finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(color_places([[finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(37),
     ['Place' = finland,
      'Color' = red,
      'Tail' = [[cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [color_places([[cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
      color(red),
      valid_color(finland, red, [[cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(color_places([[cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(37),
     ['Place' = cyprus,
      'Color' = red,
      'Tail' = [[malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [color_places([[malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
      color(red),
      valid_color(cyprus, red, [[malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(color_places([[malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(37),
     ['Place' = malta,
      'Color' = red,
      'Tail' = [[poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [color_places([[poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
      color(red),
      valid_color(malta, red, [[poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(color_places([[poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(37),
     ['Place' = poland,
      'Color' = blue,
      'Tail' = [[hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [color_places([[hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
      color(blue),
      valid_color(poland, blue, [[hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(color_places([[hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(37),
     ['Place' = hungary,
      'Color' = blue,
      'Tail' = [[czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [color_places([[czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
      color(blue),
      valid_color(hungary, blue, [[czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(color_places([[czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(37),
     ['Place' = czech_republic,
      'Color' = green,
      'Tail' = [[slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [color_places([[slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
      color(green),
      valid_color(czech_republic, green, [[slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(color_places([[slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(37),
     ['Place' = slovakia,
      'Color' = red,
      'Tail' = [[slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [color_places([[slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
      color(red),
      valid_color(slovakia, red, [[slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(color_places([[slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(37),
     ['Place' = slovenia,
      'Color' = green,
      'Tail' = [[estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [color_places([[estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
      color(green),
      valid_color(slovenia, green, [[estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(color_places([[estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(37),
     ['Place' = estonia,
      'Color' = red,
      'Tail' = [[latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [color_places([[latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
      color(red),
      valid_color(estonia, red, [[latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(color_places([[latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(37),
     ['Place' = latvia,
      'Color' = green,
      'Tail' = [[lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]],
     [color_places([[lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
      color(green),
      valid_color(latvia, green, [[lithuania, red], [bulgaria, green], [romania, red], [croatia, red]])]).
step(color_places([[lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(37),
     ['Place' = lithuania,
      'Color' = red,
      'Tail' = [[bulgaria, green], [romania, red], [croatia, red]]],
     [color_places([[bulgaria, green], [romania, red], [croatia, red]]),
      color(red),
      valid_color(lithuania, red, [[bulgaria, green], [romania, red], [croatia, red]])]).
step(color_places([[bulgaria, green], [romania, red], [croatia, red]]),
     rule(37),
     ['Place' = bulgaria, 'Color' = green, 'Tail' = [[romania, red], [croatia, red]]],
     [color_places([[romania, red], [croatia, red]]),
      color(green),
      valid_color(bulgaria, green, [[romania, red], [croatia, red]])]).
step(color_places([[romania, red], [croatia, red]]),
     rule(37),
     ['Place' = romania, 'Color' = red, 'Tail' = [[croatia, red]]],
     [color_places([[croatia, red]]), color(red), valid_color(romania, red, [[croatia, red]])]).
step(color_places([[croatia, red]]),
     rule(37),
     ['Place' = croatia, 'Color' = red, 'Tail' = []],
     [color_places([]), color(red), valid_color(croatia, red, [])]).
step(color_places([]), fact(36), [], []).
step(color(red), fact(1), [], []).
step(valid_color(croatia, red, []),
     rule(33),
     ['Place' = croatia, 'Color' = red, 'Assigned' = [], 'Neighbors' = [slovenia, hungary]],
     [neighbours(croatia, [slovenia, hungary]),
      \+ (member([Neighbor, red], []), member(Neighbor, [slovenia, hungary]))]).
step(neighbours(croatia, [slovenia, hungary]), fact(32), [], []).
step(\+ (member([Neighbor, red], []), member(Neighbor, [slovenia, hungary])), absent, [], []).
step(valid_color(romania, red, [[croatia, red]]),
     rule(33),
     ['Place' = romania,
      'Color' = red,
      'Assigned' = [[croatia, red]],
      'Neighbors' = [hungary, bulgaria]],
     [neighbours(romania, [hungary, bulgaria]),
      \+ (member([Neighbor, red], [[croatia, red]]), member(Neighbor, [hungary, bulgaria]))]).
step(neighbours(romania, [hungary, bulgaria]), fact(31), [], []).
step(\+ (member([Neighbor, red], [[croatia, red]]), member(Neighbor, [hungary, bulgaria])),
     absent,
     [],
     []).
step(color(green), fact(2), [], []).
step(valid_color(bulgaria, green, [[romania, red], [croatia, red]]),
     rule(33),
     ['Place' = bulgaria,
      'Color' = green,
      'Assigned' = [[romania, red], [croatia, red]],
      'Neighbors' = [romania, greece]],
     [neighbours(bulgaria, [romania, greece]),
      \+ (member([Neighbor, green], [[romania, red], [croatia, red]]), member(Neighbor, [romania, greece]))]).
step(neighbours(bulgaria, [romania, greece]), fact(30), [], []).
step(\+ (member([Neighbor, green], [[romania, red], [croatia, red]]), member(Neighbor, [romania, greece])),
     absent,
     [],
     []).
step(valid_color(lithuania, red, [[bulgaria, green], [romania, red], [croatia, red]]),
     rule(33),
     ['Place' = lithuania,
      'Color' = red,
      'Assigned' = [[bulgaria, green], [romania, red], [croatia, red]],
      'Neighbors' = [latvia, poland]],
     [neighbours(lithuania, [latvia, poland]),
      \+ (member([Neighbor, red], [[bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [latvia, poland]))]).
step(neighbours(lithuania, [latvia, poland]), fact(29), [], []).
step(\+ (member([Neighbor, red], [[bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [latvia, poland])),
     absent,
     [],
     []).
step(valid_color(latvia, green, [[lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(33),
     ['Place' = latvia,
      'Color' = green,
      'Assigned' = [[lithuania, red], [bulgaria, green], [romania, red], [croatia, red]],
      'Neighbors' = [estonia, lithuania]],
     [neighbours(latvia, [estonia, lithuania]),
      \+ (member([Neighbor, green], [[lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [estonia, lithuania]))]).
step(neighbours(latvia, [estonia, lithuania]), fact(28), [], []).
step(\+ (member([Neighbor, green], [[lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [estonia, lithuania])),
     absent,
     [],
     []).
step(valid_color(estonia, red, [[latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(33),
     ['Place' = estonia,
      'Color' = red,
      'Assigned' = [[latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]],
      'Neighbors' = [latvia]],
     [neighbours(estonia, [latvia]),
      \+ (member([Neighbor, red], [[latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [latvia]))]).
step(neighbours(estonia, [latvia]), fact(27), [], []).
step(\+ (member([Neighbor, red], [[latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [latvia])),
     absent,
     [],
     []).
step(valid_color(slovenia, green, [[estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(33),
     ['Place' = slovenia,
      'Color' = green,
      'Assigned' = [[estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]],
      'Neighbors' = [austria, italy, hungary, croatia]],
     [neighbours(slovenia, [austria, italy, hungary, croatia]),
      \+ (member([Neighbor, green], [[estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [austria, italy, hungary, croatia]))]).
step(neighbours(slovenia, [austria, italy, hungary, croatia]), fact(26), [], []).
step(\+ (member([Neighbor, green], [[estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [austria, italy, hungary, croatia])),
     absent,
     [],
     []).
step(valid_color(slovakia, red, [[slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(33),
     ['Place' = slovakia,
      'Color' = red,
      'Assigned' = [[slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]],
      'Neighbors' = [czech_republic, poland, hungary, austria]],
     [neighbours(slovakia, [czech_republic, poland, hungary, austria]),
      \+ (member([Neighbor, red], [[slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [czech_republic, poland, hungary, austria]))]).
step(neighbours(slovakia, [czech_republic, poland, hungary, austria]), fact(25), [], []).
step(\+ (member([Neighbor, red], [[slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [czech_republic, poland, hungary, austria])),
     absent,
     [],
     []).
step(valid_color(czech_republic, green, [[slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(33),
     ['Place' = czech_republic,
      'Color' = green,
      'Assigned' = [[slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]],
      'Neighbors' = [germany, poland, slovakia, austria]],
     [neighbours(czech_republic, [germany, poland, slovakia, austria]),
      \+ (member([Neighbor, green], [[slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [germany, poland, slovakia, austria]))]).
step(neighbours(czech_republic, [germany, poland, slovakia, austria]), fact(24), [], []).
step(\+ (member([Neighbor, green], [[slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [germany, poland, slovakia, austria])),
     absent,
     [],
     []).
step(color(blue), fact(3), [], []).
step(valid_color(hungary, blue, [[czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(33),
     ['Place' = hungary,
      'Color' = blue,
      'Assigned' = [[czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]],
      'Neighbors' = [austria, slovakia, romania, croatia, slovenia]],
     [neighbours(hungary, [austria, slovakia, romania, croatia, slovenia]),
      \+ (member([Neighbor, blue], [[czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [austria, slovakia, romania, croatia, slovenia]))]).
step(neighbours(hungary, [austria, slovakia, romania, croatia, slovenia]), fact(23), [], []).
step(\+ (member([Neighbor, blue], [[czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [austria, slovakia, romania, croatia, slovenia])),
     absent,
     [],
     []).
step(valid_color(poland, blue, [[hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(33),
     ['Place' = poland,
      'Color' = blue,
      'Assigned' = [[hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]],
      'Neighbors' = [germany, czech_republic, slovakia, lithuania]],
     [neighbours(poland, [germany, czech_republic, slovakia, lithuania]),
      \+ (member([Neighbor, blue], [[hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [germany, czech_republic, slovakia, lithuania]))]).
step(neighbours(poland, [germany, czech_republic, slovakia, lithuania]), fact(22), [], []).
step(\+ (member([Neighbor, blue], [[hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [germany, czech_republic, slovakia, lithuania])),
     absent,
     [],
     []).
step(valid_color(malta, red, [[poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(33),
     ['Place' = malta,
      'Color' = red,
      'Assigned' = [[poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]],
      'Neighbors' = []],
     [neighbours(malta, []),
      \+ (member([Neighbor, red], [[poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, []))]).
step(neighbours(malta, []), fact(21), [], []).
step(\+ (member([Neighbor, red], [[poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [])),
     absent,
     [],
     []).
step(valid_color(cyprus, red, [[malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(33),
     ['Place' = cyprus,
      'Color' = red,
      'Assigned' = [[malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]],
      'Neighbors' = []],
     [neighbours(cyprus, []),
      \+ (member([Neighbor, red], [[malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, []))]).
step(neighbours(cyprus, []), fact(20), [], []).
step(\+ (member([Neighbor, red], [[malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [])),
     absent,
     [],
     []).
step(valid_color(finland, red, [[cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(33),
     ['Place' = finland,
      'Color' = red,
      'Assigned' = [[cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]],
      'Neighbors' = [sweden]],
     [neighbours(finland, [sweden]),
      \+ (member([Neighbor, red], [[cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [sweden]))]).
step(neighbours(finland, [sweden]), fact(19), [], []).
step(\+ (member([Neighbor, red], [[cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [sweden])),
     absent,
     [],
     []).
step(valid_color(sweden, green, [[finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(33),
     ['Place' = sweden,
      'Color' = green,
      'Assigned' = [[finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]],
      'Neighbors' = [finland]],
     [neighbours(sweden, [finland]),
      \+ (member([Neighbor, green], [[finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [finland]))]).
step(neighbours(sweden, [finland]), fact(18), [], []).
step(\+ (member([Neighbor, green], [[finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [finland])),
     absent,
     [],
     []).
step(color(yellow), fact(4), [], []).
step(valid_color(austria, yellow, [[sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(33),
     ['Place' = austria,
      'Color' = yellow,
      'Assigned' = [[sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]],
      'Neighbors' = [czech_republic, germany, hungary, italy, slovenia, slovakia]],
     [neighbours(austria, [czech_republic, germany, hungary, italy, slovenia, slovakia]),
      \+ (member([Neighbor, yellow], [[sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [czech_republic, germany, hungary, italy, slovenia, slovakia]))]).
step(neighbours(austria, [czech_republic, germany, hungary, italy, slovenia, slovakia]),
     fact(17),
     [],
     []).
step(\+ (member([Neighbor, yellow], [[sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [czech_republic, germany, hungary, italy, slovenia, slovakia])),
     absent,
     [],
     []).
step(valid_color(portugal, red, [[austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(33),
     ['Place' = portugal,
      'Color' = red,
      'Assigned' = [[austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]],
      'Neighbors' = [spain]],
     [neighbours(portugal, [spain]),
      \+ (member([Neighbor, red], [[austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [spain]))]).
step(neighbours(portugal, [spain]), fact(16), [], []).
step(\+ (member([Neighbor, red], [[austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [spain])),
     absent,
     [],
     []).
step(valid_color(spain, green, [[portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(33),
     ['Place' = spain,
      'Color' = green,
      'Assigned' = [[portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]],
      'Neighbors' = [france, portugal]],
     [neighbours(spain, [france, portugal]),
      \+ (member([Neighbor, green], [[portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [france, portugal]))]).
step(neighbours(spain, [france, portugal]), fact(15), [], []).
step(\+ (member([Neighbor, green], [[portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [france, portugal])),
     absent,
     [],
     []).
step(valid_color(greece, red, [[spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(33),
     ['Place' = greece,
      'Color' = red,
      'Assigned' = [[spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]],
      'Neighbors' = [bulgaria]],
     [neighbours(greece, [bulgaria]),
      \+ (member([Neighbor, red], [[spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [bulgaria]))]).
step(neighbours(greece, [bulgaria]), fact(14), [], []).
step(\+ (member([Neighbor, red], [[spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [bulgaria])),
     absent,
     [],
     []).
step(valid_color(ireland, red, [[greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(33),
     ['Place' = ireland,
      'Color' = red,
      'Assigned' = [[greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]],
      'Neighbors' = []],
     [neighbours(ireland, []),
      \+ (member([Neighbor, red], [[greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, []))]).
step(neighbours(ireland, []), fact(13), [], []).
step(\+ (member([Neighbor, red], [[greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [])),
     absent,
     [],
     []).
step(valid_color(denmark, green, [[ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(33),
     ['Place' = denmark,
      'Color' = green,
      'Assigned' = [[ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]],
      'Neighbors' = [germany]],
     [neighbours(denmark, [germany]),
      \+ (member([Neighbor, green], [[ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [germany]))]).
step(neighbours(denmark, [germany]), fact(12), [], []).
step(\+ (member([Neighbor, green], [[ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [germany])),
     absent,
     [],
     []).
step(valid_color(italy, red, [[denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(33),
     ['Place' = italy,
      'Color' = red,
      'Assigned' = [[denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]],
      'Neighbors' = [france, austria, slovenia]],
     [neighbours(italy, [france, austria, slovenia]),
      \+ (member([Neighbor, red], [[denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [france, austria, slovenia]))]).
step(neighbours(italy, [france, austria, slovenia]), fact(11), [], []).
step(\+ (member([Neighbor, red], [[denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [france, austria, slovenia])),
     absent,
     [],
     []).
step(valid_color(germany, red, [[italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(33),
     ['Place' = germany,
      'Color' = red,
      'Assigned' = [[italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]],
      'Neighbors' = [netherlands, belgium, luxemburg, denmark, france, austria, poland, czech_republic]],
     [neighbours(germany, [netherlands, belgium, luxemburg, denmark, france, austria, poland, czech_republic]),
      \+ (member([Neighbor, red], [[italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [netherlands, belgium, luxemburg, denmark, france, austria, poland, czech_republic]))]).
step(neighbours(germany, [netherlands, belgium, luxemburg, denmark, france, austria, poland, czech_republic]),
     fact(10),
     [],
     []).
step(\+ (member([Neighbor, red], [[italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [netherlands, belgium, luxemburg, denmark, france, austria, poland, czech_republic])),
     absent,
     [],
     []).
step(valid_color(france, blue, [[germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(33),
     ['Place' = france,
      'Color' = blue,
      'Assigned' = [[germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]],
      'Neighbors' = [spain, belgium, luxemburg, germany, italy]],
     [neighbours(france, [spain, belgium, luxemburg, germany, italy]),
      \+ (member([Neighbor, blue], [[germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [spain, belgium, luxemburg, germany, italy]))]).
step(neighbours(france, [spain, belgium, luxemburg, germany, italy]), fact(9), [], []).
step(\+ (member([Neighbor, blue], [[germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [spain, belgium, luxemburg, germany, italy])),
     absent,
     [],
     []).
step(valid_color(luxemburg, green, [[france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(33),
     ['Place' = luxemburg,
      'Color' = green,
      'Assigned' = [[france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]],
      'Neighbors' = [belgium, france, germany]],
     [neighbours(luxemburg, [belgium, france, germany]),
      \+ (member([Neighbor, green], [[france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [belgium, france, germany]))]).
step(neighbours(luxemburg, [belgium, france, germany]), fact(8), [], []).
step(\+ (member([Neighbor, green], [[france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [belgium, france, germany])),
     absent,
     [],
     []).
step(valid_color(netherlands, green, [[luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(33),
     ['Place' = netherlands,
      'Color' = green,
      'Assigned' = [[luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]],
      'Neighbors' = [belgium, germany]],
     [neighbours(netherlands, [belgium, germany]),
      \+ (member([Neighbor, green], [[luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [belgium, germany]))]).
step(neighbours(netherlands, [belgium, germany]), fact(7), [], []).
step(\+ (member([Neighbor, green], [[luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [belgium, germany])),
     absent,
     [],
     []).
step(valid_color(belgium, yellow, [[netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]),
     rule(33),
     ['Place' = belgium,
      'Color' = yellow,
      'Assigned' = [[netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]],
      'Neighbors' = [france, netherlands, luxemburg, germany]],
     [neighbours(belgium, [france, netherlands, luxemburg, germany]),
      \+ (member([Neighbor, yellow], [[netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [france, netherlands, luxemburg, germany]))]).
step(neighbours(belgium, [france, netherlands, luxemburg, germany]), fact(6), [], []).
step(\+ (member([Neighbor, yellow], [[netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]), member(Neighbor, [france, netherlands, luxemburg, germany])),
     absent,
     [],
     []).
