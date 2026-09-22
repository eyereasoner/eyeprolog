% Prolog result format 4
query(1, label(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = '<urn:example:a>', 'X1' = "Alice"]).
why(1, ['X0' = '<urn:example:a>', 'X1' = "Alice"], [label('<urn:example:a>', "Alice")]).

clause(1, name('<urn:example:a>', "Alice"), true).
clause(2, label(var('Iri'), var('Name')), name(var('Iri'), var('Name'))).

step(label('<urn:example:a>', "Alice"),
     rule(2),
     ['Iri' = '<urn:example:a>', 'Name' = "Alice"],
     [name('<urn:example:a>', "Alice")]).
step(name('<urn:example:a>', "Alice"), fact(1), [], []).
