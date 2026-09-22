% Prolog result format 4
query(1,
      result_rdf(_0, _1, _2, _3),
      ['__anon0' = _0, '__anon1' = _1, '__anon2' = _2, '__anon3' = _3]).
result(1, complete, 1).
answer(1,
       ['__anon0' = iri('https://example.org/sensor1'),
        '__anon1' = iri('https://example.org/reportedBy'),
        '__anon2' = iri('https://example.org/station7'),
        '__anon3' = default_graph]).
why(1,
    ['__anon0' = iri('https://example.org/sensor1'),
     '__anon1' = iri('https://example.org/reportedBy'),
     '__anon2' = iri('https://example.org/station7'),
     '__anon3' = default_graph],
    [result_rdf(iri('https://example.org/sensor1'), iri('https://example.org/reportedBy'), iri('https://example.org/station7'), default_graph)]).

clause(1,
       rdf(iri('https://example.org/sensorGraph'), iri('https://example.org/reportedBy'), iri('https://example.org/station7'), default_graph),
       true).
clause(2,
       rdf(iri('https://example.org/sensor1'), iri('https://example.org/temperature'), literal('21.5', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/sensorGraph')),
       true).
clause(3,
       result_rdf(var('S'), iri('https://example.org/reportedBy'), var('Station'), default_graph),
       (rdf(iri('https://example.org/sensorGraph'), iri('https://example.org/reportedBy'), var('Station'), default_graph),
        rdf(var('S'), iri('https://example.org/temperature'), anonymous(1), iri('https://example.org/sensorGraph')))).

step(result_rdf(iri('https://example.org/sensor1'), iri('https://example.org/reportedBy'), iri('https://example.org/station7'), default_graph),
     rule(3),
     ['S' = iri('https://example.org/sensor1'), 'Station' = iri('https://example.org/station7')],
     [rdf(iri('https://example.org/sensorGraph'), iri('https://example.org/reportedBy'), iri('https://example.org/station7'), default_graph),
      rdf(iri('https://example.org/sensor1'), iri('https://example.org/temperature'), literal('21.5', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/sensorGraph'))]).
step(rdf(iri('https://example.org/sensorGraph'), iri('https://example.org/reportedBy'), iri('https://example.org/station7'), default_graph),
     fact(1),
     [],
     []).
step(rdf(iri('https://example.org/sensor1'), iri('https://example.org/temperature'), literal('21.5', datatype('http://www.w3.org/2001/XMLSchema#string')), iri('https://example.org/sensorGraph')),
     fact(2),
     [],
     []).
