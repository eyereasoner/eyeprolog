holds_result(socrates, human_witness(socrates)).
holds_result(plato, human_witness(plato)).

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
