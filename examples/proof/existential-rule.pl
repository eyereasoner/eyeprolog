% Prolog result format 4
query(1, holds_result(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 2).
answer(1, ['X0' = socrates, 'X1' = human_witness(socrates)]).
why(1,
    ['X0' = socrates, 'X1' = human_witness(socrates)],
    [holds_result(socrates, human_witness(socrates))]).
answer(1, ['X0' = plato, 'X1' = human_witness(plato)]).
why(1, ['X0' = plato, 'X1' = human_witness(plato)], [holds_result(plato, human_witness(plato))]).

clause(1, type(socrates, human), true).
clause(2, type(plato, human), true).
clause(3, holds_result(var('Person'), human_witness(var('Person'))), type(var('Person'), human)).

step(holds_result(socrates, human_witness(socrates)),
     rule(3),
     ['Person' = socrates],
     [type(socrates, human)]).
step(type(socrates, human), fact(1), [], []).
step(holds_result(plato, human_witness(plato)),
     rule(3),
     ['Person' = plato],
     [type(plato, human)]).
step(type(plato, human), fact(2), [], []).
