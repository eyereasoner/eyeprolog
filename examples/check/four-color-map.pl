condition('C1', resolution, ok, 9).
condition('C2', well_founded, ok, 15).
condition('C3', justification, ok, 15).
condition('C4', coverage, ok, 17).
condition('C5', re_decision, ok, 4).
obligation(collected, theory_scoped, findall(Country, valid_assignment(Country), [belgium, netherlands, luxemburg, france, germany, italy, denmark, ireland, greece, spain, portugal, austria, sweden, finland, cyprus, malta, poland, hungary, czech_republic, slovakia, slovenia, estonia, latvia, lithuania, bulgaria, romania, croatia])).
obligation(collected, theory_scoped, findall([A, B], border_colours_differ(A, B), [[belgium, france], [belgium, netherlands], [belgium, luxemburg], [belgium, germany], [netherlands, germany], [luxemburg, france], [luxemburg, germany], [france, spain], [france, germany], [france, italy], [germany, denmark], [germany, austria], [germany, poland], [germany, czech_republic], [italy, austria], [italy, slovenia], [greece, bulgaria], [spain, portugal], [austria, czech_republic], [austria, hungary], [austria, slovenia], [austria, slovakia], [sweden, finland], [poland, czech_republic], [poland, slovakia], [poland, lithuania], [hungary, slovakia], [hungary, romania], [hungary, croatia], [hungary, slovenia], [czech_republic, slovakia], [slovakia, austria], [slovenia, croatia], [estonia, latvia], [latvia, lithuania], [bulgaria, romania]])).
steps(15).
verified(9).
recomputed(4).
composed(0).
trusted(2).
claims(3).
verdict(checked_with_obligations).
