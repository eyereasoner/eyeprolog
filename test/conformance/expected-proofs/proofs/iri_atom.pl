label('<urn:example:a>', "Alice").

clause(1, name('<urn:example:a>', "Alice"), true).
clause(2, label(var('Iri'), var('Name')), name(var('Iri'), var('Name'))).

step(label('<urn:example:a>', "Alice"),
     rule(2),
     ['Iri' = '<urn:example:a>', 'Name' = "Alice"],
     [name('<urn:example:a>', "Alice")]).
step(name('<urn:example:a>', "Alice"), fact(1), [], []).
