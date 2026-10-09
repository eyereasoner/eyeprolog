best_release_plan(plan(api(1), cache(0), audit(0), search(1)), 13).

clause(1,
       best_release_plan(plan(api(var('Api')), cache(var('Cache')), audit(var('Audit')), search(var('Search'))), var('Score')),
       (sat(card([0, 1, 2], [var('Api'), var('Cache'), var('Audit'), var('Search')]) * (var('Search') =< var('Api')) * (var('Cache') =< var('Audit'))),
        weighted_maximum([7, 4, 3, 6], [var('Api'), var('Cache'), var('Audit'), var('Search')], var('Score')))).

step(best_release_plan(plan(api(1), cache(0), audit(0), search(1)), 13),
     rule(1),
     ['Api' = 1, 'Cache' = 0, 'Audit' = 0, 'Search' = 1, 'Score' = 13],
     [sat(card([0, 1, 2], [1, 0, 0, 1]) * (1 =< 1) * (0 =< 0)),
      weighted_maximum([7, 4, 3, 6], [1, 0, 0, 1], 13)]).
step(sat(card([0, 1, 2], [1, 0, 0, 1]) * (1 =< 1) * (0 =< 0)), builtin, [], []).
step(weighted_maximum([7, 4, 3, 6], [1, 0, 0, 1], 13), builtin, [], []).
