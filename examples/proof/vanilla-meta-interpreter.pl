answer([ann, pat], [jim]).

clause(13,
       answer(var('Grandchildren'), var('GreatGrandchildren')),
       (findall(var('X'), solve(grandparent(tom, var('X'))), var('Grandchildren')),
        findall(var('X'), solve(great_grandparent(tom, var('X'))), var('GreatGrandchildren')))).

step(answer([ann, pat], [jim]),
     rule(13),
     ['Grandchildren' = [ann, pat], 'GreatGrandchildren' = [jim]],
     [findall(X, solve(grandparent(tom, X)), [ann, pat]),
      findall(X, solve(great_grandparent(tom, X)), [jim])]).
step(findall(X, solve(grandparent(tom, X)), [ann, pat]), collected, [], []).
step(findall(X, solve(great_grandparent(tom, X)), [jim]), collected, [], []).
