% Prolog result format 4
query(1, answer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = iri_join, 'X1' = '<urn:example:alice>']).
why(1,
    ['X0' = iri_join, 'X1' = '<urn:example:alice>'],
    [answer(iri_join, '<urn:example:alice>')]).

clause(1, answer(iri_join, var('Who')), var('Who') = '<urn:example:alice>').

step(answer(iri_join, '<urn:example:alice>'),
     rule(1),
     ['Who' = '<urn:example:alice>'],
     ['<urn:example:alice>' = '<urn:example:alice>']).
step('<urn:example:alice>' = '<urn:example:alice>', builtin, [], []).
