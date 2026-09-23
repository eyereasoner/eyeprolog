answer(compound_name_arguments, box, "ab").

clause(1,
       answer(compound_name_arguments, var('Name'), var('Args')),
       box(a, b) =.. [var('Name') | var('Args')]).

step(answer(compound_name_arguments, box, "ab"),
     rule(1),
     ['Name' = box, 'Args' = "ab"],
     [box(a, b) =.. [box|"ab"]]).
step(box(a, b) =.. [box|"ab"], builtin, [], []).
