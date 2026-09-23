answer(iri_join, '<urn:example:alice>').

clause(1, answer(iri_join, var('Who')), var('Who') = '<urn:example:alice>').

step(answer(iri_join, '<urn:example:alice>'),
     rule(1),
     ['Who' = '<urn:example:alice>'],
     ['<urn:example:alice>' = '<urn:example:alice>']).
step('<urn:example:alice>' = '<urn:example:alice>', builtin, [], []).
