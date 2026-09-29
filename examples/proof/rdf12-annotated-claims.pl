result_rdf(iri('https://example.org/bridge'), iri('https://example.org/decision'), iri('https://example.org/avoid_bridge'), default_graph).
result_rdf(iri('https://example.org/bridge'), iri('https://example.org/trustedSource'), iri('https://example.org/transportAuthority'), default_graph).
result_rdf(iri('https://example.org/bridge'), iri('https://example.org/score'), literal('9310', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/closed'), iri('https://example.org/rank'), literal('1', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/open'), iri('https://example.org/rank'), literal('2', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/closed'), iri('https://example.org/assertedBy'), iri('https://example.org/transportAuthority'), default_graph).
result_rdf(iri('https://example.org/open'), iri('https://example.org/assertedBy'), iri('https://example.org/anonymousPost'), default_graph).
result_rdf(iri('https://example.org/closed'), iri('https://example.org/score'), literal('9310', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/open'), iri('https://example.org/score'), literal('700', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).

clause(11,
       bridge_status_report(report(decision(var('Action')), evidence(trusted_source(var('Source')), score(var('Score'))), ranked_claims(var('Claims')))),
       (ranked_claims(var('Claims')),
        bridge_decision(var('Claims'), var('Action'), var('Source'), var('Score')))).
clause(12,
       ranked_claims(var('Claims')),
       (findall(key(var('NegativeScore'), var('Status')) - claim(var('Status'), var('Source'), score(var('Score'))), (annotated_status_claim(var('Status'), var('Source'), var('Score')), var('NegativeScore') is - var('Score')), var('Unsorted')),
        sort(var('Unsorted'), var('Sorted')),
        pair_values(var('Sorted'), var('Claims')))).
clause(14,
       bridge_decision([claim(var('Status'), var('Source'), score(var('Score'))) | anonymous(1)], var('Action'), var('Source'), var('Score')),
       (var('Score') >= 8000, status_action(var('Status'), var('Action')))).
clause(18, pair_values([], []), true).
clause(19,
       pair_values([anonymous(1) - var('Value') | var('Pairs')], [var('Value') | var('Values')]),
       pair_values(var('Pairs'), var('Values'))).
clause(20, status_action(closed, avoid_bridge), true).
clause(22, status_resource(closed, 'https://example.org/closed'), true).
clause(23, status_resource(open, 'https://example.org/open'), true).
clause(24, source_resource(transport_authority, 'https://example.org/transportAuthority'), true).
clause(25, source_resource(anonymous_post, 'https://example.org/anonymousPost'), true).
clause(26,
       result_rdf(iri('https://example.org/bridge'), iri('https://example.org/decision'), iri(var('DecisionIri')), default_graph),
       (bridge_status_report(report(decision(var('Action')), anonymous(1), anonymous(2))),
        atom_concat('https://example.org/', var('Action'), var('DecisionIri')))).
clause(27,
       result_rdf(iri('https://example.org/bridge'), iri('https://example.org/trustedSource'), iri(var('SourceIri')), default_graph),
       (bridge_status_report(report(anonymous(1), evidence(trusted_source(var('Source')), anonymous(2)), anonymous(3))),
        source_result_iri(var('Source'), var('SourceIri')))).
clause(28,
       result_rdf(iri('https://example.org/bridge'), iri('https://example.org/score'), literal(var('ScoreText'), datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
       (bridge_status_report(report(anonymous(1), evidence(anonymous(2), score(var('Score'))), anonymous(3))),
        number_atom(var('Score'), var('ScoreText')))).
clause(29,
       result_rdf(iri(var('StatusIri')), iri('https://example.org/rank'), literal(var('RankText'), datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
       (bridge_ranked_claim(var('Rank'), var('Status'), anonymous(1), anonymous(2)),
        status_resource(var('Status'), var('StatusIri')),
        number_atom(var('Rank'), var('RankText')))).
clause(30,
       result_rdf(iri(var('StatusIri')), iri('https://example.org/assertedBy'), iri(var('SourceIri')), default_graph),
       (bridge_ranked_claim(anonymous(1), var('Status'), var('Source'), anonymous(2)),
        status_resource(var('Status'), var('StatusIri')),
        source_resource(var('Source'), var('SourceIri')))).
clause(31,
       result_rdf(iri(var('StatusIri')), iri('https://example.org/score'), literal(var('ScoreText'), datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
       (bridge_ranked_claim(anonymous(1), var('Status'), anonymous(2), var('Score')),
        status_resource(var('Status'), var('StatusIri')),
        number_atom(var('Score'), var('ScoreText')))).
clause(32,
       bridge_ranked_claim(var('Rank'), var('Status'), var('Source'), var('Score')),
       (bridge_status_report(report(anonymous(1), anonymous(2), ranked_claims(var('Claims')))),
        ranked_claim(var('Claims'), 1, var('Rank'), var('Status'), var('Source'), var('Score')))).
clause(33,
       ranked_claim([claim(var('Status'), var('Source'), score(var('Score'))) | anonymous(1)], var('Rank'), var('Rank'), var('Status'), var('Source'), var('Score')),
       true).
clause(34,
       ranked_claim([anonymous(1) | var('Rest')], var('N'), var('Rank'), var('Status'), var('Source'), var('Score')),
       (var('Next') is var('N') + 1,
        ranked_claim(var('Rest'), var('Next'), var('Rank'), var('Status'), var('Source'), var('Score')))).
clause(36,
       source_result_iri(var('Source'), var('Iri')),
       source_resource(var('Source'), var('Iri'))).
clause(37,
       number_atom(var('Number'), var('Atom')),
       (number_chars(var('Number'), var('Chars')), atom_chars(var('Atom'), var('Chars')))).

step(result_rdf(iri('https://example.org/bridge'), iri('https://example.org/decision'), iri('https://example.org/avoid_bridge'), default_graph),
     rule(26),
     ['DecisionIri' = 'https://example.org/avoid_bridge', 'Action' = avoid_bridge],
     [bridge_status_report(report(decision(avoid_bridge), evidence(trusted_source(transport_authority), score(9310)), ranked_claims([claim(closed, transport_authority, score(9310)), claim(open, anonymous_post, score(700))]))),
      atom_concat('https://example.org/', avoid_bridge, 'https://example.org/avoid_bridge')]).
step(bridge_status_report(report(decision(avoid_bridge), evidence(trusted_source(transport_authority), score(9310)), ranked_claims([claim(closed, transport_authority, score(9310)), claim(open, anonymous_post, score(700))]))),
     rule(11),
     ['Action' = avoid_bridge,
      'Source' = transport_authority,
      'Score' = 9310,
      'Claims' = [claim(closed, transport_authority, score(9310)), claim(open, anonymous_post, score(700))]],
     [ranked_claims([claim(closed, transport_authority, score(9310)), claim(open, anonymous_post, score(700))]),
      bridge_decision([claim(closed, transport_authority, score(9310)), claim(open, anonymous_post, score(700))], avoid_bridge, transport_authority, 9310)]).
step(ranked_claims([claim(closed, transport_authority, score(9310)), claim(open, anonymous_post, score(700))]),
     rule(12),
     ['Claims' = [claim(closed, transport_authority, score(9310)), claim(open, anonymous_post, score(700))],
      'Unsorted' = [key(-9310, closed) - claim(closed, transport_authority, score(9310)), key(-700, open) - claim(open, anonymous_post, score(700))],
      'Sorted' = [key(-9310, closed) - claim(closed, transport_authority, score(9310)), key(-700, open) - claim(open, anonymous_post, score(700))]],
     [findall(key(NegativeScore, Status) - claim(Status, Source, score(Score)), (annotated_status_claim(Status, Source, Score), NegativeScore is - Score), [key(-9310, closed) - claim(closed, transport_authority, score(9310)), key(-700, open) - claim(open, anonymous_post, score(700))]),
      sort([key(-9310, closed) - claim(closed, transport_authority, score(9310)), key(-700, open) - claim(open, anonymous_post, score(700))], [key(-9310, closed) - claim(closed, transport_authority, score(9310)), key(-700, open) - claim(open, anonymous_post, score(700))]),
      pair_values([key(-9310, closed) - claim(closed, transport_authority, score(9310)), key(-700, open) - claim(open, anonymous_post, score(700))], [claim(closed, transport_authority, score(9310)), claim(open, anonymous_post, score(700))])]).
step(findall(key(NegativeScore, Status) - claim(Status, Source, score(Score)), (annotated_status_claim(Status, Source, Score), NegativeScore is - Score), [key(-9310, closed) - claim(closed, transport_authority, score(9310)), key(-700, open) - claim(open, anonymous_post, score(700))]),
     collected,
     [],
     []).
step(sort([key(-9310, closed) - claim(closed, transport_authority, score(9310)), key(-700, open) - claim(open, anonymous_post, score(700))], [key(-9310, closed) - claim(closed, transport_authority, score(9310)), key(-700, open) - claim(open, anonymous_post, score(700))]),
     builtin,
     [],
     []).
step(pair_values([key(-9310, closed) - claim(closed, transport_authority, score(9310)), key(-700, open) - claim(open, anonymous_post, score(700))], [claim(closed, transport_authority, score(9310)), claim(open, anonymous_post, score(700))]),
     rule(19),
     ['Value' = claim(closed, transport_authority, score(9310)),
      'Pairs' = [key(-700, open) - claim(open, anonymous_post, score(700))],
      'Values' = [claim(open, anonymous_post, score(700))]],
     [pair_values([key(-700, open) - claim(open, anonymous_post, score(700))], [claim(open, anonymous_post, score(700))])]).
step(pair_values([key(-700, open) - claim(open, anonymous_post, score(700))], [claim(open, anonymous_post, score(700))]),
     rule(19),
     ['Value' = claim(open, anonymous_post, score(700)), 'Pairs' = [], 'Values' = []],
     [pair_values([], [])]).
step(pair_values([], []), fact(18), [], []).
step(bridge_decision([claim(closed, transport_authority, score(9310)), claim(open, anonymous_post, score(700))], avoid_bridge, transport_authority, 9310),
     rule(14),
     ['Status' = closed,
      'Source' = transport_authority,
      'Score' = 9310,
      'Action' = avoid_bridge],
     [9310 >= 8000, status_action(closed, avoid_bridge)]).
step(9310 >= 8000, builtin, [], []).
step(status_action(closed, avoid_bridge), fact(20), [], []).
step(atom_concat('https://example.org/', avoid_bridge, 'https://example.org/avoid_bridge'),
     builtin,
     [],
     []).
step(result_rdf(iri('https://example.org/bridge'), iri('https://example.org/trustedSource'), iri('https://example.org/transportAuthority'), default_graph),
     rule(27),
     ['SourceIri' = 'https://example.org/transportAuthority', 'Source' = transport_authority],
     [bridge_status_report(report(decision(avoid_bridge), evidence(trusted_source(transport_authority), score(9310)), ranked_claims([claim(closed, transport_authority, score(9310)), claim(open, anonymous_post, score(700))]))),
      source_result_iri(transport_authority, 'https://example.org/transportAuthority')]).
step(source_result_iri(transport_authority, 'https://example.org/transportAuthority'),
     rule(36),
     ['Source' = transport_authority, 'Iri' = 'https://example.org/transportAuthority'],
     [source_resource(transport_authority, 'https://example.org/transportAuthority')]).
step(source_resource(transport_authority, 'https://example.org/transportAuthority'),
     fact(24),
     [],
     []).
step(result_rdf(iri('https://example.org/bridge'), iri('https://example.org/score'), literal('9310', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
     rule(28),
     ['ScoreText' = '9310', 'Score' = 9310],
     [bridge_status_report(report(decision(avoid_bridge), evidence(trusted_source(transport_authority), score(9310)), ranked_claims([claim(closed, transport_authority, score(9310)), claim(open, anonymous_post, score(700))]))),
      number_atom(9310, '9310')]).
step(number_atom(9310, '9310'),
     rule(37),
     ['Number' = 9310, 'Atom' = '9310', 'Chars' = "9310"],
     [number_chars(9310, "9310"), atom_chars('9310', "9310")]).
step(number_chars(9310, "9310"), builtin, [], []).
step(atom_chars('9310', "9310"), builtin, [], []).
step(result_rdf(iri('https://example.org/closed'), iri('https://example.org/rank'), literal('1', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
     rule(29),
     ['StatusIri' = 'https://example.org/closed',
      'RankText' = '1',
      'Rank' = 1,
      'Status' = closed],
     [bridge_ranked_claim(1, closed, transport_authority, 9310),
      status_resource(closed, 'https://example.org/closed'),
      number_atom(1, '1')]).
step(bridge_ranked_claim(1, closed, transport_authority, 9310),
     rule(32),
     ['Rank' = 1,
      'Status' = closed,
      'Source' = transport_authority,
      'Score' = 9310,
      'Claims' = [claim(closed, transport_authority, score(9310)), claim(open, anonymous_post, score(700))]],
     [bridge_status_report(report(decision(avoid_bridge), evidence(trusted_source(transport_authority), score(9310)), ranked_claims([claim(closed, transport_authority, score(9310)), claim(open, anonymous_post, score(700))]))),
      ranked_claim([claim(closed, transport_authority, score(9310)), claim(open, anonymous_post, score(700))], 1, 1, closed, transport_authority, 9310)]).
step(ranked_claim([claim(closed, transport_authority, score(9310)), claim(open, anonymous_post, score(700))], 1, 1, closed, transport_authority, 9310),
     fact(33),
     ['Status' = closed, 'Source' = transport_authority, 'Score' = 9310, 'Rank' = 1],
     []).
step(status_resource(closed, 'https://example.org/closed'), fact(22), [], []).
step(number_atom(1, '1'),
     rule(37),
     ['Number' = 1, 'Atom' = '1', 'Chars' = "1"],
     [number_chars(1, "1"), atom_chars('1', "1")]).
step(number_chars(1, "1"), builtin, [], []).
step(atom_chars('1', "1"), builtin, [], []).
step(result_rdf(iri('https://example.org/open'), iri('https://example.org/rank'), literal('2', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
     rule(29),
     ['StatusIri' = 'https://example.org/open', 'RankText' = '2', 'Rank' = 2, 'Status' = open],
     [bridge_ranked_claim(2, open, anonymous_post, 700),
      status_resource(open, 'https://example.org/open'),
      number_atom(2, '2')]).
step(bridge_ranked_claim(2, open, anonymous_post, 700),
     rule(32),
     ['Rank' = 2,
      'Status' = open,
      'Source' = anonymous_post,
      'Score' = 700,
      'Claims' = [claim(closed, transport_authority, score(9310)), claim(open, anonymous_post, score(700))]],
     [bridge_status_report(report(decision(avoid_bridge), evidence(trusted_source(transport_authority), score(9310)), ranked_claims([claim(closed, transport_authority, score(9310)), claim(open, anonymous_post, score(700))]))),
      ranked_claim([claim(closed, transport_authority, score(9310)), claim(open, anonymous_post, score(700))], 1, 2, open, anonymous_post, 700)]).
step(ranked_claim([claim(closed, transport_authority, score(9310)), claim(open, anonymous_post, score(700))], 1, 2, open, anonymous_post, 700),
     rule(34),
     ['Rest' = [claim(open, anonymous_post, score(700))],
      'N' = 1,
      'Rank' = 2,
      'Status' = open,
      'Source' = anonymous_post,
      'Score' = 700,
      'Next' = 2],
     [2 is 1 + 1,
      ranked_claim([claim(open, anonymous_post, score(700))], 2, 2, open, anonymous_post, 700)]).
step(2 is 1 + 1, builtin, [], []).
step(ranked_claim([claim(open, anonymous_post, score(700))], 2, 2, open, anonymous_post, 700),
     fact(33),
     ['Status' = open, 'Source' = anonymous_post, 'Score' = 700, 'Rank' = 2],
     []).
step(status_resource(open, 'https://example.org/open'), fact(23), [], []).
step(number_atom(2, '2'),
     rule(37),
     ['Number' = 2, 'Atom' = '2', 'Chars' = "2"],
     [number_chars(2, "2"), atom_chars('2', "2")]).
step(number_chars(2, "2"), builtin, [], []).
step(atom_chars('2', "2"), builtin, [], []).
step(result_rdf(iri('https://example.org/closed'), iri('https://example.org/assertedBy'), iri('https://example.org/transportAuthority'), default_graph),
     rule(30),
     ['StatusIri' = 'https://example.org/closed',
      'SourceIri' = 'https://example.org/transportAuthority',
      'Status' = closed,
      'Source' = transport_authority],
     [bridge_ranked_claim(1, closed, transport_authority, 9310),
      status_resource(closed, 'https://example.org/closed'),
      source_resource(transport_authority, 'https://example.org/transportAuthority')]).
step(result_rdf(iri('https://example.org/open'), iri('https://example.org/assertedBy'), iri('https://example.org/anonymousPost'), default_graph),
     rule(30),
     ['StatusIri' = 'https://example.org/open',
      'SourceIri' = 'https://example.org/anonymousPost',
      'Status' = open,
      'Source' = anonymous_post],
     [bridge_ranked_claim(2, open, anonymous_post, 700),
      status_resource(open, 'https://example.org/open'),
      source_resource(anonymous_post, 'https://example.org/anonymousPost')]).
step(source_resource(anonymous_post, 'https://example.org/anonymousPost'), fact(25), [], []).
step(result_rdf(iri('https://example.org/closed'), iri('https://example.org/score'), literal('9310', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
     rule(31),
     ['StatusIri' = 'https://example.org/closed',
      'ScoreText' = '9310',
      'Status' = closed,
      'Score' = 9310],
     [bridge_ranked_claim(1, closed, transport_authority, 9310),
      status_resource(closed, 'https://example.org/closed'),
      number_atom(9310, '9310')]).
step(result_rdf(iri('https://example.org/open'), iri('https://example.org/score'), literal('700', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
     rule(31),
     ['StatusIri' = 'https://example.org/open',
      'ScoreText' = '700',
      'Status' = open,
      'Score' = 700],
     [bridge_ranked_claim(2, open, anonymous_post, 700),
      status_resource(open, 'https://example.org/open'),
      number_atom(700, '700')]).
step(number_atom(700, '700'),
     rule(37),
     ['Number' = 700, 'Atom' = '700', 'Chars' = "700"],
     [number_chars(700, "700"), atom_chars('700', "700")]).
step(number_chars(700, "700"), builtin, [], []).
step(atom_chars('700', "700"), builtin, [], []).
