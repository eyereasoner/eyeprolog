% Prolog result format 4
query(1, color(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1,
       ['X0' = map_eu,
        'X1' = [[belgium, yellow], [netherlands, green], [luxemburg, green], [france, blue], [germany, red], [italy, red], [denmark, green], [ireland, red], [greece, red], [spain, green], [portugal, red], [austria, yellow], [sweden, green], [finland, red], [cyprus, red], [malta, red], [poland, blue], [hungary, blue], [czech_republic, green], [slovakia, red], [slovenia, green], [estonia, red], [latvia, green], [lithuania, red], [bulgaria, green], [romania, red], [croatia, red]]]).
query(2, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = map_eu, 'X1' = valid_four_colour_assignment]).
query(3, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = map_eu, 'X1' = "no neighbouring countries share a colour"]).
