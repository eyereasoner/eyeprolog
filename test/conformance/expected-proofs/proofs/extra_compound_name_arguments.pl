% Prolog result format 4
query(1, answer(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(1, complete, 1).
answer(1, ['X0' = compound_name_arguments, 'X1' = box, 'X2' = "ab"]).
why(1,
    ['X0' = compound_name_arguments, 'X1' = box, 'X2' = "ab"],
    [answer(compound_name_arguments, box, "ab")]).

clause(1,
       answer(compound_name_arguments, var('Name'), var('Args')),
       box(a, b) =.. [var('Name') | var('Args')]).

step(answer(compound_name_arguments, box, "ab"),
     rule(1),
     ['Name' = box, 'Args' = "ab"],
     [box(a, b) =.. [box|"ab"]]).
step(box(a, b) =.. [box|"ab"], builtin, [], []).
