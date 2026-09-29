result_rdf(iri('https://example.org/deletion-risk'), iri('https://example.org/rank'), literal('1', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/rank'), literal('2', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/terms-risk'), iri('https://example.org/rank'), literal('3', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/portability-risk'), iri('https://example.org/rank'), literal('4', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/deletion-risk'), iri('https://example.org/score'), literal('100', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/score'), literal('97', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/terms-risk'), iri('https://example.org/score'), literal('85', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/portability-risk'), iri('https://example.org/score'), literal('70', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/deletion-risk'), iri('https://example.org/level'), iri('https://example.org/high'), default_graph).
result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/level'), iri('https://example.org/high'), default_graph).
result_rdf(iri('https://example.org/terms-risk'), iri('https://example.org/level'), iri('https://example.org/high'), default_graph).
result_rdf(iri('https://example.org/portability-risk'), iri('https://example.org/level'), iri('https://example.org/moderate'), default_graph).
result_rdf(iri('https://example.org/deletion-risk'), iri('https://example.org/clause'), literal(c1, datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph).
result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/clause'), literal(c3, datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph).
result_rdf(iri('https://example.org/terms-risk'), iri('https://example.org/clause'), literal(c2, datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph).
result_rdf(iri('https://example.org/portability-risk'), iri('https://example.org/clause'), literal(c4, datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph).
result_rdf(iri('https://example.org/deletion-risk'), iri('https://example.org/mitigation'), iri('https://example.org/require-notice-before-deletion'), default_graph).
result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/mitigation'), iri('https://example.org/require-explicit-consent'), default_graph).
result_rdf(iri('https://example.org/terms-risk'), iri('https://example.org/mitigation'), iri('https://example.org/require-14-days-notice'), default_graph).
result_rdf(iri('https://example.org/portability-risk'), iri('https://example.org/mitigation'), iri('https://example.org/permit-data-export'), default_graph).

clause(48,
       consumer_risk_report(var('Ranked')),
       (findall(key(var('InverseScore'), var('Clause')) - dpv_risk(var('Risk'), var('Score'), var('Level'), var('Clause'), var('Mitigation')), (risk_report(var('Risk'), var('Score'), var('Level'), var('Clause'), var('Mitigation')), var('InverseScore') is 1000 - var('Score')), var('Unsorted')),
        sort(var('Unsorted'), var('Sorted')),
        ranked_values(var('Sorted'), 1, var('Ranked')))).
clause(60, ranked_values([], anonymous(1), []), true).
clause(61,
       ranked_values([anonymous(1) - var('Risk') | var('Rest')], var('Rank'), [rank(var('Rank'), var('Risk')) | var('Ranked')]),
       (var('NextRank') is var('Rank') + 1,
        ranked_values(var('Rest'), var('NextRank'), var('Ranked')))).
clause(62, risk_resource(deletion_risk, ex('deletion-risk')), true).
clause(63, risk_resource(terms_risk, ex('terms-risk')), true).
clause(64, risk_resource(sharing_risk, ex('sharing-risk')), true).
clause(65, risk_resource(portability_risk, ex('portability-risk')), true).
clause(66,
       mitigation_resource(require_notice_before_deletion, ex('require-notice-before-deletion')),
       true).
clause(67, mitigation_resource(require_14_days_notice, ex('require-14-days-notice')), true).
clause(68, mitigation_resource(require_explicit_consent, ex('require-explicit-consent')), true).
clause(69, mitigation_resource(permit_data_export, ex('permit-data-export')), true).
clause(73,
       iri_term(ex(var('Name')), var('Iri')),
       namespace_iri('https://example.org/', var('Name'), var('Iri'))).
clause(75,
       namespace_iri(var('Prefix'), var('Name'), var('Iri')),
       atom_concat(var('Prefix'), var('Name'), var('Iri'))).
clause(76,
       result_rdf(iri(var('RiskIri')), iri('https://example.org/rank'), literal(var('RankText'), datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
       (consumer_ranked_item(var('Rank'), var('Risk'), anonymous(1), anonymous(2), anonymous(3), anonymous(4)),
        risk_resource(var('Risk'), var('RiskTerm')),
        iri_term(var('RiskTerm'), var('RiskIri')),
        number_atom(var('Rank'), var('RankText')))).
clause(77,
       result_rdf(iri(var('RiskIri')), iri('https://example.org/score'), literal(var('ScoreText'), datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
       (consumer_ranked_item(anonymous(1), var('Risk'), var('Score'), anonymous(2), anonymous(3), anonymous(4)),
        risk_resource(var('Risk'), var('RiskTerm')),
        iri_term(var('RiskTerm'), var('RiskIri')),
        number_atom(var('Score'), var('ScoreText')))).
clause(78,
       result_rdf(iri(var('RiskIri')), iri('https://example.org/level'), iri(var('LevelIri')), default_graph),
       (consumer_ranked_item(anonymous(1), var('Risk'), anonymous(2), var('Level'), anonymous(3), anonymous(4)),
        risk_resource(var('Risk'), var('RiskTerm')),
        iri_term(var('RiskTerm'), var('RiskIri')),
        atom_concat('https://example.org/', var('Level'), var('LevelIri')))).
clause(79,
       result_rdf(iri(var('RiskIri')), iri('https://example.org/clause'), literal(var('Clause'), datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph),
       (consumer_ranked_item(anonymous(1), var('Risk'), anonymous(2), anonymous(3), var('Clause'), anonymous(4)),
        risk_resource(var('Risk'), var('RiskTerm')),
        iri_term(var('RiskTerm'), var('RiskIri')))).
clause(80,
       result_rdf(iri(var('RiskIri')), iri('https://example.org/mitigation'), iri(var('MitigationIri')), default_graph),
       (consumer_ranked_item(anonymous(1), var('Risk'), anonymous(2), anonymous(3), anonymous(4), var('Mitigation')),
        risk_resource(var('Risk'), var('RiskTerm')),
        iri_term(var('RiskTerm'), var('RiskIri')),
        mitigation_resource(var('Mitigation'), var('MitigationTerm')),
        iri_term(var('MitigationTerm'), var('MitigationIri')))).
clause(81,
       consumer_ranked_item(var('Rank'), var('Risk'), var('Score'), var('Level'), var('Clause'), var('Mitigation')),
       (consumer_risk_report(var('Ranked')),
        list_member(rank(var('Rank'), dpv_risk(var('Risk'), var('Score'), var('Level'), var('Clause'), var('Mitigation'))), var('Ranked')))).
clause(82, list_member(var('X'), [var('X') | anonymous(1)]), true).
clause(83, list_member(var('X'), [anonymous(1) | var('Xs')]), list_member(var('X'), var('Xs'))).
clause(84,
       number_atom(var('Number'), var('Atom')),
       (number_chars(var('Number'), var('Chars')), atom_chars(var('Atom'), var('Chars')))).

step(result_rdf(iri('https://example.org/deletion-risk'), iri('https://example.org/rank'), literal('1', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
     rule(76),
     ['RiskIri' = 'https://example.org/deletion-risk',
      'RankText' = '1',
      'Rank' = 1,
      'Risk' = deletion_risk,
      'RiskTerm' = ex('deletion-risk')],
     [consumer_ranked_item(1, deletion_risk, 100, high, c1, require_notice_before_deletion),
      risk_resource(deletion_risk, ex('deletion-risk')),
      iri_term(ex('deletion-risk'), 'https://example.org/deletion-risk'),
      number_atom(1, '1')]).
step(consumer_ranked_item(1, deletion_risk, 100, high, c1, require_notice_before_deletion),
     rule(81),
     ['Rank' = 1,
      'Risk' = deletion_risk,
      'Score' = 100,
      'Level' = high,
      'Clause' = c1,
      'Mitigation' = require_notice_before_deletion,
      'Ranked' = [rank(1, dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion)), rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]],
     [consumer_risk_report([rank(1, dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion)), rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]),
      list_member(rank(1, dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion)), [rank(1, dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion)), rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))])]).
step(consumer_risk_report([rank(1, dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion)), rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]),
     rule(48),
     ['Ranked' = [rank(1, dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion)), rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))],
      'Unsorted' = [key(900, c1) - dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion), key(915, c2) - dpv_risk(terms_risk, 85, high, c2, require_14_days_notice), key(903, c3) - dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent), key(930, c4) - dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)],
      'Sorted' = [key(900, c1) - dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion), key(903, c3) - dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent), key(915, c2) - dpv_risk(terms_risk, 85, high, c2, require_14_days_notice), key(930, c4) - dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)]],
     [findall(key(InverseScore, Clause) - dpv_risk(Risk, Score, Level, Clause, Mitigation), (risk_report(Risk, Score, Level, Clause, Mitigation), InverseScore is 1000 - Score), [key(900, c1) - dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion), key(915, c2) - dpv_risk(terms_risk, 85, high, c2, require_14_days_notice), key(903, c3) - dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent), key(930, c4) - dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)]),
      sort([key(900, c1) - dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion), key(915, c2) - dpv_risk(terms_risk, 85, high, c2, require_14_days_notice), key(903, c3) - dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent), key(930, c4) - dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)], [key(900, c1) - dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion), key(903, c3) - dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent), key(915, c2) - dpv_risk(terms_risk, 85, high, c2, require_14_days_notice), key(930, c4) - dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)]),
      ranked_values([key(900, c1) - dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion), key(903, c3) - dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent), key(915, c2) - dpv_risk(terms_risk, 85, high, c2, require_14_days_notice), key(930, c4) - dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)], 1, [rank(1, dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion)), rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))])]).
step(findall(key(InverseScore, Clause) - dpv_risk(Risk, Score, Level, Clause, Mitigation), (risk_report(Risk, Score, Level, Clause, Mitigation), InverseScore is 1000 - Score), [key(900, c1) - dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion), key(915, c2) - dpv_risk(terms_risk, 85, high, c2, require_14_days_notice), key(903, c3) - dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent), key(930, c4) - dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)]),
     collected,
     [],
     []).
step(sort([key(900, c1) - dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion), key(915, c2) - dpv_risk(terms_risk, 85, high, c2, require_14_days_notice), key(903, c3) - dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent), key(930, c4) - dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)], [key(900, c1) - dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion), key(903, c3) - dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent), key(915, c2) - dpv_risk(terms_risk, 85, high, c2, require_14_days_notice), key(930, c4) - dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)]),
     builtin,
     [],
     []).
step(ranked_values([key(900, c1) - dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion), key(903, c3) - dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent), key(915, c2) - dpv_risk(terms_risk, 85, high, c2, require_14_days_notice), key(930, c4) - dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)], 1, [rank(1, dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion)), rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]),
     rule(61),
     ['Risk' = dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion),
      'Rest' = [key(903, c3) - dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent), key(915, c2) - dpv_risk(terms_risk, 85, high, c2, require_14_days_notice), key(930, c4) - dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)],
      'Rank' = 1,
      'Ranked' = [rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))],
      'NextRank' = 2],
     [2 is 1 + 1,
      ranked_values([key(903, c3) - dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent), key(915, c2) - dpv_risk(terms_risk, 85, high, c2, require_14_days_notice), key(930, c4) - dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)], 2, [rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))])]).
step(2 is 1 + 1, builtin, [], []).
step(ranked_values([key(903, c3) - dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent), key(915, c2) - dpv_risk(terms_risk, 85, high, c2, require_14_days_notice), key(930, c4) - dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)], 2, [rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]),
     rule(61),
     ['Risk' = dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent),
      'Rest' = [key(915, c2) - dpv_risk(terms_risk, 85, high, c2, require_14_days_notice), key(930, c4) - dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)],
      'Rank' = 2,
      'Ranked' = [rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))],
      'NextRank' = 3],
     [3 is 2 + 1,
      ranked_values([key(915, c2) - dpv_risk(terms_risk, 85, high, c2, require_14_days_notice), key(930, c4) - dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)], 3, [rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))])]).
step(3 is 2 + 1, builtin, [], []).
step(ranked_values([key(915, c2) - dpv_risk(terms_risk, 85, high, c2, require_14_days_notice), key(930, c4) - dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)], 3, [rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]),
     rule(61),
     ['Risk' = dpv_risk(terms_risk, 85, high, c2, require_14_days_notice),
      'Rest' = [key(930, c4) - dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)],
      'Rank' = 3,
      'Ranked' = [rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))],
      'NextRank' = 4],
     [4 is 3 + 1,
      ranked_values([key(930, c4) - dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)], 4, [rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))])]).
step(4 is 3 + 1, builtin, [], []).
step(ranked_values([key(930, c4) - dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)], 4, [rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]),
     rule(61),
     ['Risk' = dpv_risk(portability_risk, 70, moderate, c4, permit_data_export),
      'Rest' = [],
      'Rank' = 4,
      'Ranked' = [],
      'NextRank' = 5],
     [5 is 4 + 1, ranked_values([], 5, [])]).
step(5 is 4 + 1, builtin, [], []).
step(ranked_values([], 5, []), fact(60), [], []).
step(list_member(rank(1, dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion)), [rank(1, dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion)), rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]),
     fact(82),
     ['X' = rank(1, dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion))],
     []).
step(risk_resource(deletion_risk, ex('deletion-risk')), fact(62), [], []).
step(iri_term(ex('deletion-risk'), 'https://example.org/deletion-risk'),
     rule(73),
     ['Name' = 'deletion-risk', 'Iri' = 'https://example.org/deletion-risk'],
     [namespace_iri('https://example.org/', 'deletion-risk', 'https://example.org/deletion-risk')]).
step(namespace_iri('https://example.org/', 'deletion-risk', 'https://example.org/deletion-risk'),
     rule(75),
     ['Prefix' = 'https://example.org/',
      'Name' = 'deletion-risk',
      'Iri' = 'https://example.org/deletion-risk'],
     [atom_concat('https://example.org/', 'deletion-risk', 'https://example.org/deletion-risk')]).
step(atom_concat('https://example.org/', 'deletion-risk', 'https://example.org/deletion-risk'),
     builtin,
     [],
     []).
step(number_atom(1, '1'),
     rule(84),
     ['Number' = 1, 'Atom' = '1', 'Chars' = "1"],
     [number_chars(1, "1"), atom_chars('1', "1")]).
step(number_chars(1, "1"), builtin, [], []).
step(atom_chars('1', "1"), builtin, [], []).
step(result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/rank'), literal('2', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
     rule(76),
     ['RiskIri' = 'https://example.org/sharing-risk',
      'RankText' = '2',
      'Rank' = 2,
      'Risk' = sharing_risk,
      'RiskTerm' = ex('sharing-risk')],
     [consumer_ranked_item(2, sharing_risk, 97, high, c3, require_explicit_consent),
      risk_resource(sharing_risk, ex('sharing-risk')),
      iri_term(ex('sharing-risk'), 'https://example.org/sharing-risk'),
      number_atom(2, '2')]).
step(consumer_ranked_item(2, sharing_risk, 97, high, c3, require_explicit_consent),
     rule(81),
     ['Rank' = 2,
      'Risk' = sharing_risk,
      'Score' = 97,
      'Level' = high,
      'Clause' = c3,
      'Mitigation' = require_explicit_consent,
      'Ranked' = [rank(1, dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion)), rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]],
     [consumer_risk_report([rank(1, dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion)), rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]),
      list_member(rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), [rank(1, dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion)), rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))])]).
step(list_member(rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), [rank(1, dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion)), rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]),
     rule(83),
     ['X' = rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)),
      'Xs' = [rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]],
     [list_member(rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), [rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))])]).
step(list_member(rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), [rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]),
     fact(82),
     ['X' = rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent))],
     []).
step(risk_resource(sharing_risk, ex('sharing-risk')), fact(64), [], []).
step(iri_term(ex('sharing-risk'), 'https://example.org/sharing-risk'),
     rule(73),
     ['Name' = 'sharing-risk', 'Iri' = 'https://example.org/sharing-risk'],
     [namespace_iri('https://example.org/', 'sharing-risk', 'https://example.org/sharing-risk')]).
step(namespace_iri('https://example.org/', 'sharing-risk', 'https://example.org/sharing-risk'),
     rule(75),
     ['Prefix' = 'https://example.org/',
      'Name' = 'sharing-risk',
      'Iri' = 'https://example.org/sharing-risk'],
     [atom_concat('https://example.org/', 'sharing-risk', 'https://example.org/sharing-risk')]).
step(atom_concat('https://example.org/', 'sharing-risk', 'https://example.org/sharing-risk'),
     builtin,
     [],
     []).
step(number_atom(2, '2'),
     rule(84),
     ['Number' = 2, 'Atom' = '2', 'Chars' = "2"],
     [number_chars(2, "2"), atom_chars('2', "2")]).
step(number_chars(2, "2"), builtin, [], []).
step(atom_chars('2', "2"), builtin, [], []).
step(result_rdf(iri('https://example.org/terms-risk'), iri('https://example.org/rank'), literal('3', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
     rule(76),
     ['RiskIri' = 'https://example.org/terms-risk',
      'RankText' = '3',
      'Rank' = 3,
      'Risk' = terms_risk,
      'RiskTerm' = ex('terms-risk')],
     [consumer_ranked_item(3, terms_risk, 85, high, c2, require_14_days_notice),
      risk_resource(terms_risk, ex('terms-risk')),
      iri_term(ex('terms-risk'), 'https://example.org/terms-risk'),
      number_atom(3, '3')]).
step(consumer_ranked_item(3, terms_risk, 85, high, c2, require_14_days_notice),
     rule(81),
     ['Rank' = 3,
      'Risk' = terms_risk,
      'Score' = 85,
      'Level' = high,
      'Clause' = c2,
      'Mitigation' = require_14_days_notice,
      'Ranked' = [rank(1, dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion)), rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]],
     [consumer_risk_report([rank(1, dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion)), rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]),
      list_member(rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), [rank(1, dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion)), rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))])]).
step(list_member(rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), [rank(1, dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion)), rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]),
     rule(83),
     ['X' = rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)),
      'Xs' = [rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]],
     [list_member(rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), [rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))])]).
step(list_member(rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), [rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]),
     rule(83),
     ['X' = rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)),
      'Xs' = [rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]],
     [list_member(rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), [rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))])]).
step(list_member(rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), [rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]),
     fact(82),
     ['X' = rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice))],
     []).
step(risk_resource(terms_risk, ex('terms-risk')), fact(63), [], []).
step(iri_term(ex('terms-risk'), 'https://example.org/terms-risk'),
     rule(73),
     ['Name' = 'terms-risk', 'Iri' = 'https://example.org/terms-risk'],
     [namespace_iri('https://example.org/', 'terms-risk', 'https://example.org/terms-risk')]).
step(namespace_iri('https://example.org/', 'terms-risk', 'https://example.org/terms-risk'),
     rule(75),
     ['Prefix' = 'https://example.org/',
      'Name' = 'terms-risk',
      'Iri' = 'https://example.org/terms-risk'],
     [atom_concat('https://example.org/', 'terms-risk', 'https://example.org/terms-risk')]).
step(atom_concat('https://example.org/', 'terms-risk', 'https://example.org/terms-risk'),
     builtin,
     [],
     []).
step(number_atom(3, '3'),
     rule(84),
     ['Number' = 3, 'Atom' = '3', 'Chars' = "3"],
     [number_chars(3, "3"), atom_chars('3', "3")]).
step(number_chars(3, "3"), builtin, [], []).
step(atom_chars('3', "3"), builtin, [], []).
step(result_rdf(iri('https://example.org/portability-risk'), iri('https://example.org/rank'), literal('4', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
     rule(76),
     ['RiskIri' = 'https://example.org/portability-risk',
      'RankText' = '4',
      'Rank' = 4,
      'Risk' = portability_risk,
      'RiskTerm' = ex('portability-risk')],
     [consumer_ranked_item(4, portability_risk, 70, moderate, c4, permit_data_export),
      risk_resource(portability_risk, ex('portability-risk')),
      iri_term(ex('portability-risk'), 'https://example.org/portability-risk'),
      number_atom(4, '4')]).
step(consumer_ranked_item(4, portability_risk, 70, moderate, c4, permit_data_export),
     rule(81),
     ['Rank' = 4,
      'Risk' = portability_risk,
      'Score' = 70,
      'Level' = moderate,
      'Clause' = c4,
      'Mitigation' = permit_data_export,
      'Ranked' = [rank(1, dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion)), rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]],
     [consumer_risk_report([rank(1, dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion)), rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]),
      list_member(rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)), [rank(1, dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion)), rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))])]).
step(list_member(rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)), [rank(1, dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion)), rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]),
     rule(83),
     ['X' = rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)),
      'Xs' = [rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]],
     [list_member(rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)), [rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))])]).
step(list_member(rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)), [rank(2, dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent)), rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]),
     rule(83),
     ['X' = rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)),
      'Xs' = [rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]],
     [list_member(rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)), [rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))])]).
step(list_member(rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)), [rank(3, dpv_risk(terms_risk, 85, high, c2, require_14_days_notice)), rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]),
     rule(83),
     ['X' = rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)),
      'Xs' = [rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]],
     [list_member(rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)), [rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))])]).
step(list_member(rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)), [rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))]),
     fact(82),
     ['X' = rank(4, dpv_risk(portability_risk, 70, moderate, c4, permit_data_export))],
     []).
step(risk_resource(portability_risk, ex('portability-risk')), fact(65), [], []).
step(iri_term(ex('portability-risk'), 'https://example.org/portability-risk'),
     rule(73),
     ['Name' = 'portability-risk', 'Iri' = 'https://example.org/portability-risk'],
     [namespace_iri('https://example.org/', 'portability-risk', 'https://example.org/portability-risk')]).
step(namespace_iri('https://example.org/', 'portability-risk', 'https://example.org/portability-risk'),
     rule(75),
     ['Prefix' = 'https://example.org/',
      'Name' = 'portability-risk',
      'Iri' = 'https://example.org/portability-risk'],
     [atom_concat('https://example.org/', 'portability-risk', 'https://example.org/portability-risk')]).
step(atom_concat('https://example.org/', 'portability-risk', 'https://example.org/portability-risk'),
     builtin,
     [],
     []).
step(number_atom(4, '4'),
     rule(84),
     ['Number' = 4, 'Atom' = '4', 'Chars' = "4"],
     [number_chars(4, "4"), atom_chars('4', "4")]).
step(number_chars(4, "4"), builtin, [], []).
step(atom_chars('4', "4"), builtin, [], []).
step(result_rdf(iri('https://example.org/deletion-risk'), iri('https://example.org/score'), literal('100', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
     rule(77),
     ['RiskIri' = 'https://example.org/deletion-risk',
      'ScoreText' = '100',
      'Risk' = deletion_risk,
      'Score' = 100,
      'RiskTerm' = ex('deletion-risk')],
     [consumer_ranked_item(1, deletion_risk, 100, high, c1, require_notice_before_deletion),
      risk_resource(deletion_risk, ex('deletion-risk')),
      iri_term(ex('deletion-risk'), 'https://example.org/deletion-risk'),
      number_atom(100, '100')]).
step(number_atom(100, '100'),
     rule(84),
     ['Number' = 100, 'Atom' = '100', 'Chars' = "100"],
     [number_chars(100, "100"), atom_chars('100', "100")]).
step(number_chars(100, "100"), builtin, [], []).
step(atom_chars('100', "100"), builtin, [], []).
step(result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/score'), literal('97', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
     rule(77),
     ['RiskIri' = 'https://example.org/sharing-risk',
      'ScoreText' = '97',
      'Risk' = sharing_risk,
      'Score' = 97,
      'RiskTerm' = ex('sharing-risk')],
     [consumer_ranked_item(2, sharing_risk, 97, high, c3, require_explicit_consent),
      risk_resource(sharing_risk, ex('sharing-risk')),
      iri_term(ex('sharing-risk'), 'https://example.org/sharing-risk'),
      number_atom(97, '97')]).
step(number_atom(97, '97'),
     rule(84),
     ['Number' = 97, 'Atom' = '97', 'Chars' = "97"],
     [number_chars(97, "97"), atom_chars('97', "97")]).
step(number_chars(97, "97"), builtin, [], []).
step(atom_chars('97', "97"), builtin, [], []).
step(result_rdf(iri('https://example.org/terms-risk'), iri('https://example.org/score'), literal('85', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
     rule(77),
     ['RiskIri' = 'https://example.org/terms-risk',
      'ScoreText' = '85',
      'Risk' = terms_risk,
      'Score' = 85,
      'RiskTerm' = ex('terms-risk')],
     [consumer_ranked_item(3, terms_risk, 85, high, c2, require_14_days_notice),
      risk_resource(terms_risk, ex('terms-risk')),
      iri_term(ex('terms-risk'), 'https://example.org/terms-risk'),
      number_atom(85, '85')]).
step(number_atom(85, '85'),
     rule(84),
     ['Number' = 85, 'Atom' = '85', 'Chars' = "85"],
     [number_chars(85, "85"), atom_chars('85', "85")]).
step(number_chars(85, "85"), builtin, [], []).
step(atom_chars('85', "85"), builtin, [], []).
step(result_rdf(iri('https://example.org/portability-risk'), iri('https://example.org/score'), literal('70', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
     rule(77),
     ['RiskIri' = 'https://example.org/portability-risk',
      'ScoreText' = '70',
      'Risk' = portability_risk,
      'Score' = 70,
      'RiskTerm' = ex('portability-risk')],
     [consumer_ranked_item(4, portability_risk, 70, moderate, c4, permit_data_export),
      risk_resource(portability_risk, ex('portability-risk')),
      iri_term(ex('portability-risk'), 'https://example.org/portability-risk'),
      number_atom(70, '70')]).
step(number_atom(70, '70'),
     rule(84),
     ['Number' = 70, 'Atom' = '70', 'Chars' = "70"],
     [number_chars(70, "70"), atom_chars('70', "70")]).
step(number_chars(70, "70"), builtin, [], []).
step(atom_chars('70', "70"), builtin, [], []).
step(result_rdf(iri('https://example.org/deletion-risk'), iri('https://example.org/level'), iri('https://example.org/high'), default_graph),
     rule(78),
     ['RiskIri' = 'https://example.org/deletion-risk',
      'LevelIri' = 'https://example.org/high',
      'Risk' = deletion_risk,
      'Level' = high,
      'RiskTerm' = ex('deletion-risk')],
     [consumer_ranked_item(1, deletion_risk, 100, high, c1, require_notice_before_deletion),
      risk_resource(deletion_risk, ex('deletion-risk')),
      iri_term(ex('deletion-risk'), 'https://example.org/deletion-risk'),
      atom_concat('https://example.org/', high, 'https://example.org/high')]).
step(atom_concat('https://example.org/', high, 'https://example.org/high'), builtin, [], []).
step(result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/level'), iri('https://example.org/high'), default_graph),
     rule(78),
     ['RiskIri' = 'https://example.org/sharing-risk',
      'LevelIri' = 'https://example.org/high',
      'Risk' = sharing_risk,
      'Level' = high,
      'RiskTerm' = ex('sharing-risk')],
     [consumer_ranked_item(2, sharing_risk, 97, high, c3, require_explicit_consent),
      risk_resource(sharing_risk, ex('sharing-risk')),
      iri_term(ex('sharing-risk'), 'https://example.org/sharing-risk'),
      atom_concat('https://example.org/', high, 'https://example.org/high')]).
step(result_rdf(iri('https://example.org/terms-risk'), iri('https://example.org/level'), iri('https://example.org/high'), default_graph),
     rule(78),
     ['RiskIri' = 'https://example.org/terms-risk',
      'LevelIri' = 'https://example.org/high',
      'Risk' = terms_risk,
      'Level' = high,
      'RiskTerm' = ex('terms-risk')],
     [consumer_ranked_item(3, terms_risk, 85, high, c2, require_14_days_notice),
      risk_resource(terms_risk, ex('terms-risk')),
      iri_term(ex('terms-risk'), 'https://example.org/terms-risk'),
      atom_concat('https://example.org/', high, 'https://example.org/high')]).
step(result_rdf(iri('https://example.org/portability-risk'), iri('https://example.org/level'), iri('https://example.org/moderate'), default_graph),
     rule(78),
     ['RiskIri' = 'https://example.org/portability-risk',
      'LevelIri' = 'https://example.org/moderate',
      'Risk' = portability_risk,
      'Level' = moderate,
      'RiskTerm' = ex('portability-risk')],
     [consumer_ranked_item(4, portability_risk, 70, moderate, c4, permit_data_export),
      risk_resource(portability_risk, ex('portability-risk')),
      iri_term(ex('portability-risk'), 'https://example.org/portability-risk'),
      atom_concat('https://example.org/', moderate, 'https://example.org/moderate')]).
step(atom_concat('https://example.org/', moderate, 'https://example.org/moderate'),
     builtin,
     [],
     []).
step(result_rdf(iri('https://example.org/deletion-risk'), iri('https://example.org/clause'), literal(c1, datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph),
     rule(79),
     ['RiskIri' = 'https://example.org/deletion-risk',
      'Clause' = c1,
      'Risk' = deletion_risk,
      'RiskTerm' = ex('deletion-risk')],
     [consumer_ranked_item(1, deletion_risk, 100, high, c1, require_notice_before_deletion),
      risk_resource(deletion_risk, ex('deletion-risk')),
      iri_term(ex('deletion-risk'), 'https://example.org/deletion-risk')]).
step(result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/clause'), literal(c3, datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph),
     rule(79),
     ['RiskIri' = 'https://example.org/sharing-risk',
      'Clause' = c3,
      'Risk' = sharing_risk,
      'RiskTerm' = ex('sharing-risk')],
     [consumer_ranked_item(2, sharing_risk, 97, high, c3, require_explicit_consent),
      risk_resource(sharing_risk, ex('sharing-risk')),
      iri_term(ex('sharing-risk'), 'https://example.org/sharing-risk')]).
step(result_rdf(iri('https://example.org/terms-risk'), iri('https://example.org/clause'), literal(c2, datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph),
     rule(79),
     ['RiskIri' = 'https://example.org/terms-risk',
      'Clause' = c2,
      'Risk' = terms_risk,
      'RiskTerm' = ex('terms-risk')],
     [consumer_ranked_item(3, terms_risk, 85, high, c2, require_14_days_notice),
      risk_resource(terms_risk, ex('terms-risk')),
      iri_term(ex('terms-risk'), 'https://example.org/terms-risk')]).
step(result_rdf(iri('https://example.org/portability-risk'), iri('https://example.org/clause'), literal(c4, datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph),
     rule(79),
     ['RiskIri' = 'https://example.org/portability-risk',
      'Clause' = c4,
      'Risk' = portability_risk,
      'RiskTerm' = ex('portability-risk')],
     [consumer_ranked_item(4, portability_risk, 70, moderate, c4, permit_data_export),
      risk_resource(portability_risk, ex('portability-risk')),
      iri_term(ex('portability-risk'), 'https://example.org/portability-risk')]).
step(result_rdf(iri('https://example.org/deletion-risk'), iri('https://example.org/mitigation'), iri('https://example.org/require-notice-before-deletion'), default_graph),
     rule(80),
     ['RiskIri' = 'https://example.org/deletion-risk',
      'MitigationIri' = 'https://example.org/require-notice-before-deletion',
      'Risk' = deletion_risk,
      'Mitigation' = require_notice_before_deletion,
      'RiskTerm' = ex('deletion-risk'),
      'MitigationTerm' = ex('require-notice-before-deletion')],
     [consumer_ranked_item(1, deletion_risk, 100, high, c1, require_notice_before_deletion),
      risk_resource(deletion_risk, ex('deletion-risk')),
      iri_term(ex('deletion-risk'), 'https://example.org/deletion-risk'),
      mitigation_resource(require_notice_before_deletion, ex('require-notice-before-deletion')),
      iri_term(ex('require-notice-before-deletion'), 'https://example.org/require-notice-before-deletion')]).
step(mitigation_resource(require_notice_before_deletion, ex('require-notice-before-deletion')),
     fact(66),
     [],
     []).
step(iri_term(ex('require-notice-before-deletion'), 'https://example.org/require-notice-before-deletion'),
     rule(73),
     ['Name' = 'require-notice-before-deletion',
      'Iri' = 'https://example.org/require-notice-before-deletion'],
     [namespace_iri('https://example.org/', 'require-notice-before-deletion', 'https://example.org/require-notice-before-deletion')]).
step(namespace_iri('https://example.org/', 'require-notice-before-deletion', 'https://example.org/require-notice-before-deletion'),
     rule(75),
     ['Prefix' = 'https://example.org/',
      'Name' = 'require-notice-before-deletion',
      'Iri' = 'https://example.org/require-notice-before-deletion'],
     [atom_concat('https://example.org/', 'require-notice-before-deletion', 'https://example.org/require-notice-before-deletion')]).
step(atom_concat('https://example.org/', 'require-notice-before-deletion', 'https://example.org/require-notice-before-deletion'),
     builtin,
     [],
     []).
step(result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/mitigation'), iri('https://example.org/require-explicit-consent'), default_graph),
     rule(80),
     ['RiskIri' = 'https://example.org/sharing-risk',
      'MitigationIri' = 'https://example.org/require-explicit-consent',
      'Risk' = sharing_risk,
      'Mitigation' = require_explicit_consent,
      'RiskTerm' = ex('sharing-risk'),
      'MitigationTerm' = ex('require-explicit-consent')],
     [consumer_ranked_item(2, sharing_risk, 97, high, c3, require_explicit_consent),
      risk_resource(sharing_risk, ex('sharing-risk')),
      iri_term(ex('sharing-risk'), 'https://example.org/sharing-risk'),
      mitigation_resource(require_explicit_consent, ex('require-explicit-consent')),
      iri_term(ex('require-explicit-consent'), 'https://example.org/require-explicit-consent')]).
step(mitigation_resource(require_explicit_consent, ex('require-explicit-consent')),
     fact(68),
     [],
     []).
step(iri_term(ex('require-explicit-consent'), 'https://example.org/require-explicit-consent'),
     rule(73),
     ['Name' = 'require-explicit-consent',
      'Iri' = 'https://example.org/require-explicit-consent'],
     [namespace_iri('https://example.org/', 'require-explicit-consent', 'https://example.org/require-explicit-consent')]).
step(namespace_iri('https://example.org/', 'require-explicit-consent', 'https://example.org/require-explicit-consent'),
     rule(75),
     ['Prefix' = 'https://example.org/',
      'Name' = 'require-explicit-consent',
      'Iri' = 'https://example.org/require-explicit-consent'],
     [atom_concat('https://example.org/', 'require-explicit-consent', 'https://example.org/require-explicit-consent')]).
step(atom_concat('https://example.org/', 'require-explicit-consent', 'https://example.org/require-explicit-consent'),
     builtin,
     [],
     []).
step(result_rdf(iri('https://example.org/terms-risk'), iri('https://example.org/mitigation'), iri('https://example.org/require-14-days-notice'), default_graph),
     rule(80),
     ['RiskIri' = 'https://example.org/terms-risk',
      'MitigationIri' = 'https://example.org/require-14-days-notice',
      'Risk' = terms_risk,
      'Mitigation' = require_14_days_notice,
      'RiskTerm' = ex('terms-risk'),
      'MitigationTerm' = ex('require-14-days-notice')],
     [consumer_ranked_item(3, terms_risk, 85, high, c2, require_14_days_notice),
      risk_resource(terms_risk, ex('terms-risk')),
      iri_term(ex('terms-risk'), 'https://example.org/terms-risk'),
      mitigation_resource(require_14_days_notice, ex('require-14-days-notice')),
      iri_term(ex('require-14-days-notice'), 'https://example.org/require-14-days-notice')]).
step(mitigation_resource(require_14_days_notice, ex('require-14-days-notice')),
     fact(67),
     [],
     []).
step(iri_term(ex('require-14-days-notice'), 'https://example.org/require-14-days-notice'),
     rule(73),
     ['Name' = 'require-14-days-notice', 'Iri' = 'https://example.org/require-14-days-notice'],
     [namespace_iri('https://example.org/', 'require-14-days-notice', 'https://example.org/require-14-days-notice')]).
step(namespace_iri('https://example.org/', 'require-14-days-notice', 'https://example.org/require-14-days-notice'),
     rule(75),
     ['Prefix' = 'https://example.org/',
      'Name' = 'require-14-days-notice',
      'Iri' = 'https://example.org/require-14-days-notice'],
     [atom_concat('https://example.org/', 'require-14-days-notice', 'https://example.org/require-14-days-notice')]).
step(atom_concat('https://example.org/', 'require-14-days-notice', 'https://example.org/require-14-days-notice'),
     builtin,
     [],
     []).
step(result_rdf(iri('https://example.org/portability-risk'), iri('https://example.org/mitigation'), iri('https://example.org/permit-data-export'), default_graph),
     rule(80),
     ['RiskIri' = 'https://example.org/portability-risk',
      'MitigationIri' = 'https://example.org/permit-data-export',
      'Risk' = portability_risk,
      'Mitigation' = permit_data_export,
      'RiskTerm' = ex('portability-risk'),
      'MitigationTerm' = ex('permit-data-export')],
     [consumer_ranked_item(4, portability_risk, 70, moderate, c4, permit_data_export),
      risk_resource(portability_risk, ex('portability-risk')),
      iri_term(ex('portability-risk'), 'https://example.org/portability-risk'),
      mitigation_resource(permit_data_export, ex('permit-data-export')),
      iri_term(ex('permit-data-export'), 'https://example.org/permit-data-export')]).
step(mitigation_resource(permit_data_export, ex('permit-data-export')), fact(69), [], []).
step(iri_term(ex('permit-data-export'), 'https://example.org/permit-data-export'),
     rule(73),
     ['Name' = 'permit-data-export', 'Iri' = 'https://example.org/permit-data-export'],
     [namespace_iri('https://example.org/', 'permit-data-export', 'https://example.org/permit-data-export')]).
step(namespace_iri('https://example.org/', 'permit-data-export', 'https://example.org/permit-data-export'),
     rule(75),
     ['Prefix' = 'https://example.org/',
      'Name' = 'permit-data-export',
      'Iri' = 'https://example.org/permit-data-export'],
     [atom_concat('https://example.org/', 'permit-data-export', 'https://example.org/permit-data-export')]).
step(atom_concat('https://example.org/', 'permit-data-export', 'https://example.org/permit-data-export'),
     builtin,
     [],
     []).
