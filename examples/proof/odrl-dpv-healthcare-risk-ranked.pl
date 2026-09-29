result_rdf(iri('https://example.org/consent-risk'), iri('https://example.org/rank'), literal('1', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/rank'), literal('2', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/retention-risk'), iri('https://example.org/rank'), literal('3', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/consent-risk'), iri('https://example.org/score'), literal('100', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/score'), literal('100', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/retention-risk'), iri('https://example.org/score'), literal('70', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph).
result_rdf(iri('https://example.org/consent-risk'), iri('https://example.org/level'), iri('https://example.org/high'), default_graph).
result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/level'), iri('https://example.org/high'), default_graph).
result_rdf(iri('https://example.org/retention-risk'), iri('https://example.org/level'), iri('https://example.org/moderate'), default_graph).
result_rdf(iri('https://example.org/consent-risk'), iri('https://example.org/clause'), literal(h1, datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph).
result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/clause'), literal(h2, datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph).
result_rdf(iri('https://example.org/retention-risk'), iri('https://example.org/clause'), literal(h4, datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph).
result_rdf(iri('https://example.org/consent-risk'), iri('https://example.org/mitigation'), iri('https://example.org/require-explicit-consent'), default_graph).
result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/mitigation'), iri('https://example.org/require-deidentification'), default_graph).
result_rdf(iri('https://example.org/retention-risk'), iri('https://example.org/mitigation'), iri('https://example.org/limit-retention-to-1095-days'), default_graph).

clause(36,
       healthcare_risk_report(var('Ranked')),
       (findall(key(var('InverseScore'), var('Clause')) - dpv_risk(var('Risk'), var('Score'), var('Level'), var('Clause'), var('Mitigation')), (risk_report(var('Risk'), var('Score'), var('Level'), var('Clause'), var('Mitigation')), var('InverseScore') is 1000 - var('Score')), var('Unsorted')),
        sort(var('Unsorted'), var('Sorted')),
        ranked_values(var('Sorted'), 1, var('Ranked')))).
clause(46, ranked_values([], anonymous(1), []), true).
clause(47,
       ranked_values([anonymous(1) - var('Risk') | var('Rest')], var('Rank'), [rank(var('Rank'), var('Risk')) | var('Ranked')]),
       (var('NextRank') is var('Rank') + 1,
        ranked_values(var('Rest'), var('NextRank'), var('Ranked')))).
clause(48, risk_resource(consent_risk, ex('consent-risk')), true).
clause(49, risk_resource(sharing_risk, ex('sharing-risk')), true).
clause(50, risk_resource(retention_risk, ex('retention-risk')), true).
clause(51, mitigation_resource(require_explicit_consent, ex('require-explicit-consent')), true).
clause(52, mitigation_resource(require_deidentification, ex('require-deidentification')), true).
clause(53,
       mitigation_resource(limit_retention_to_1095_days, ex('limit-retention-to-1095-days')),
       true).
clause(57,
       iri_term(ex(var('Name')), var('Iri')),
       namespace_iri('https://example.org/', var('Name'), var('Iri'))).
clause(59,
       namespace_iri(var('Prefix'), var('Name'), var('Iri')),
       atom_concat(var('Prefix'), var('Name'), var('Iri'))).
clause(60,
       result_rdf(iri(var('RiskIri')), iri('https://example.org/rank'), literal(var('RankText'), datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
       (healthcare_ranked_item(var('Rank'), var('Risk'), anonymous(1), anonymous(2), anonymous(3), anonymous(4)),
        risk_resource(var('Risk'), var('RiskTerm')),
        iri_term(var('RiskTerm'), var('RiskIri')),
        number_atom(var('Rank'), var('RankText')))).
clause(61,
       result_rdf(iri(var('RiskIri')), iri('https://example.org/score'), literal(var('ScoreText'), datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
       (healthcare_ranked_item(anonymous(1), var('Risk'), var('Score'), anonymous(2), anonymous(3), anonymous(4)),
        risk_resource(var('Risk'), var('RiskTerm')),
        iri_term(var('RiskTerm'), var('RiskIri')),
        number_atom(var('Score'), var('ScoreText')))).
clause(62,
       result_rdf(iri(var('RiskIri')), iri('https://example.org/level'), iri(var('LevelIri')), default_graph),
       (healthcare_ranked_item(anonymous(1), var('Risk'), anonymous(2), var('Level'), anonymous(3), anonymous(4)),
        risk_resource(var('Risk'), var('RiskTerm')),
        iri_term(var('RiskTerm'), var('RiskIri')),
        atom_concat('https://example.org/', var('Level'), var('LevelIri')))).
clause(63,
       result_rdf(iri(var('RiskIri')), iri('https://example.org/clause'), literal(var('Clause'), datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph),
       (healthcare_ranked_item(anonymous(1), var('Risk'), anonymous(2), anonymous(3), var('Clause'), anonymous(4)),
        risk_resource(var('Risk'), var('RiskTerm')),
        iri_term(var('RiskTerm'), var('RiskIri')))).
clause(64,
       result_rdf(iri(var('RiskIri')), iri('https://example.org/mitigation'), iri(var('MitigationIri')), default_graph),
       (healthcare_ranked_item(anonymous(1), var('Risk'), anonymous(2), anonymous(3), anonymous(4), var('Mitigation')),
        risk_resource(var('Risk'), var('RiskTerm')),
        iri_term(var('RiskTerm'), var('RiskIri')),
        mitigation_resource(var('Mitigation'), var('MitigationTerm')),
        iri_term(var('MitigationTerm'), var('MitigationIri')))).
clause(65,
       healthcare_ranked_item(var('Rank'), var('Risk'), var('Score'), var('Level'), var('Clause'), var('Mitigation')),
       (healthcare_risk_report(var('Ranked')),
        list_member(rank(var('Rank'), dpv_risk(var('Risk'), var('Score'), var('Level'), var('Clause'), var('Mitigation'))), var('Ranked')))).
clause(66, list_member(var('X'), [var('X') | anonymous(1)]), true).
clause(67, list_member(var('X'), [anonymous(1) | var('Xs')]), list_member(var('X'), var('Xs'))).
clause(68,
       number_atom(var('Number'), var('Atom')),
       (number_chars(var('Number'), var('Chars')), atom_chars(var('Atom'), var('Chars')))).

step(result_rdf(iri('https://example.org/consent-risk'), iri('https://example.org/rank'), literal('1', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
     rule(60),
     ['RiskIri' = 'https://example.org/consent-risk',
      'RankText' = '1',
      'Rank' = 1,
      'Risk' = consent_risk,
      'RiskTerm' = ex('consent-risk')],
     [healthcare_ranked_item(1, consent_risk, 100, high, h1, require_explicit_consent),
      risk_resource(consent_risk, ex('consent-risk')),
      iri_term(ex('consent-risk'), 'https://example.org/consent-risk'),
      number_atom(1, '1')]).
step(healthcare_ranked_item(1, consent_risk, 100, high, h1, require_explicit_consent),
     rule(65),
     ['Rank' = 1,
      'Risk' = consent_risk,
      'Score' = 100,
      'Level' = high,
      'Clause' = h1,
      'Mitigation' = require_explicit_consent,
      'Ranked' = [rank(1, dpv_risk(consent_risk, 100, high, h1, require_explicit_consent)), rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))]],
     [healthcare_risk_report([rank(1, dpv_risk(consent_risk, 100, high, h1, require_explicit_consent)), rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))]),
      list_member(rank(1, dpv_risk(consent_risk, 100, high, h1, require_explicit_consent)), [rank(1, dpv_risk(consent_risk, 100, high, h1, require_explicit_consent)), rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))])]).
step(healthcare_risk_report([rank(1, dpv_risk(consent_risk, 100, high, h1, require_explicit_consent)), rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))]),
     rule(36),
     ['Ranked' = [rank(1, dpv_risk(consent_risk, 100, high, h1, require_explicit_consent)), rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))],
      'Unsorted' = [key(900, h1) - dpv_risk(consent_risk, 100, high, h1, require_explicit_consent), key(900, h2) - dpv_risk(sharing_risk, 100, high, h2, require_deidentification), key(930, h4) - dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)],
      'Sorted' = [key(900, h1) - dpv_risk(consent_risk, 100, high, h1, require_explicit_consent), key(900, h2) - dpv_risk(sharing_risk, 100, high, h2, require_deidentification), key(930, h4) - dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)]],
     [findall(key(InverseScore, Clause) - dpv_risk(Risk, Score, Level, Clause, Mitigation), (risk_report(Risk, Score, Level, Clause, Mitigation), InverseScore is 1000 - Score), [key(900, h1) - dpv_risk(consent_risk, 100, high, h1, require_explicit_consent), key(900, h2) - dpv_risk(sharing_risk, 100, high, h2, require_deidentification), key(930, h4) - dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)]),
      sort([key(900, h1) - dpv_risk(consent_risk, 100, high, h1, require_explicit_consent), key(900, h2) - dpv_risk(sharing_risk, 100, high, h2, require_deidentification), key(930, h4) - dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)], [key(900, h1) - dpv_risk(consent_risk, 100, high, h1, require_explicit_consent), key(900, h2) - dpv_risk(sharing_risk, 100, high, h2, require_deidentification), key(930, h4) - dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)]),
      ranked_values([key(900, h1) - dpv_risk(consent_risk, 100, high, h1, require_explicit_consent), key(900, h2) - dpv_risk(sharing_risk, 100, high, h2, require_deidentification), key(930, h4) - dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)], 1, [rank(1, dpv_risk(consent_risk, 100, high, h1, require_explicit_consent)), rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))])]).
step(findall(key(InverseScore, Clause) - dpv_risk(Risk, Score, Level, Clause, Mitigation), (risk_report(Risk, Score, Level, Clause, Mitigation), InverseScore is 1000 - Score), [key(900, h1) - dpv_risk(consent_risk, 100, high, h1, require_explicit_consent), key(900, h2) - dpv_risk(sharing_risk, 100, high, h2, require_deidentification), key(930, h4) - dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)]),
     collected,
     [],
     []).
step(sort([key(900, h1) - dpv_risk(consent_risk, 100, high, h1, require_explicit_consent), key(900, h2) - dpv_risk(sharing_risk, 100, high, h2, require_deidentification), key(930, h4) - dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)], [key(900, h1) - dpv_risk(consent_risk, 100, high, h1, require_explicit_consent), key(900, h2) - dpv_risk(sharing_risk, 100, high, h2, require_deidentification), key(930, h4) - dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)]),
     builtin,
     [],
     []).
step(ranked_values([key(900, h1) - dpv_risk(consent_risk, 100, high, h1, require_explicit_consent), key(900, h2) - dpv_risk(sharing_risk, 100, high, h2, require_deidentification), key(930, h4) - dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)], 1, [rank(1, dpv_risk(consent_risk, 100, high, h1, require_explicit_consent)), rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))]),
     rule(47),
     ['Risk' = dpv_risk(consent_risk, 100, high, h1, require_explicit_consent),
      'Rest' = [key(900, h2) - dpv_risk(sharing_risk, 100, high, h2, require_deidentification), key(930, h4) - dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)],
      'Rank' = 1,
      'Ranked' = [rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))],
      'NextRank' = 2],
     [2 is 1 + 1,
      ranked_values([key(900, h2) - dpv_risk(sharing_risk, 100, high, h2, require_deidentification), key(930, h4) - dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)], 2, [rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))])]).
step(2 is 1 + 1, builtin, [], []).
step(ranked_values([key(900, h2) - dpv_risk(sharing_risk, 100, high, h2, require_deidentification), key(930, h4) - dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)], 2, [rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))]),
     rule(47),
     ['Risk' = dpv_risk(sharing_risk, 100, high, h2, require_deidentification),
      'Rest' = [key(930, h4) - dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)],
      'Rank' = 2,
      'Ranked' = [rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))],
      'NextRank' = 3],
     [3 is 2 + 1,
      ranked_values([key(930, h4) - dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)], 3, [rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))])]).
step(3 is 2 + 1, builtin, [], []).
step(ranked_values([key(930, h4) - dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)], 3, [rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))]),
     rule(47),
     ['Risk' = dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days),
      'Rest' = [],
      'Rank' = 3,
      'Ranked' = [],
      'NextRank' = 4],
     [4 is 3 + 1, ranked_values([], 4, [])]).
step(4 is 3 + 1, builtin, [], []).
step(ranked_values([], 4, []), fact(46), [], []).
step(list_member(rank(1, dpv_risk(consent_risk, 100, high, h1, require_explicit_consent)), [rank(1, dpv_risk(consent_risk, 100, high, h1, require_explicit_consent)), rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))]),
     fact(66),
     ['X' = rank(1, dpv_risk(consent_risk, 100, high, h1, require_explicit_consent))],
     []).
step(risk_resource(consent_risk, ex('consent-risk')), fact(48), [], []).
step(iri_term(ex('consent-risk'), 'https://example.org/consent-risk'),
     rule(57),
     ['Name' = 'consent-risk', 'Iri' = 'https://example.org/consent-risk'],
     [namespace_iri('https://example.org/', 'consent-risk', 'https://example.org/consent-risk')]).
step(namespace_iri('https://example.org/', 'consent-risk', 'https://example.org/consent-risk'),
     rule(59),
     ['Prefix' = 'https://example.org/',
      'Name' = 'consent-risk',
      'Iri' = 'https://example.org/consent-risk'],
     [atom_concat('https://example.org/', 'consent-risk', 'https://example.org/consent-risk')]).
step(atom_concat('https://example.org/', 'consent-risk', 'https://example.org/consent-risk'),
     builtin,
     [],
     []).
step(number_atom(1, '1'),
     rule(68),
     ['Number' = 1, 'Atom' = '1', 'Chars' = "1"],
     [number_chars(1, "1"), atom_chars('1', "1")]).
step(number_chars(1, "1"), builtin, [], []).
step(atom_chars('1', "1"), builtin, [], []).
step(result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/rank'), literal('2', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
     rule(60),
     ['RiskIri' = 'https://example.org/sharing-risk',
      'RankText' = '2',
      'Rank' = 2,
      'Risk' = sharing_risk,
      'RiskTerm' = ex('sharing-risk')],
     [healthcare_ranked_item(2, sharing_risk, 100, high, h2, require_deidentification),
      risk_resource(sharing_risk, ex('sharing-risk')),
      iri_term(ex('sharing-risk'), 'https://example.org/sharing-risk'),
      number_atom(2, '2')]).
step(healthcare_ranked_item(2, sharing_risk, 100, high, h2, require_deidentification),
     rule(65),
     ['Rank' = 2,
      'Risk' = sharing_risk,
      'Score' = 100,
      'Level' = high,
      'Clause' = h2,
      'Mitigation' = require_deidentification,
      'Ranked' = [rank(1, dpv_risk(consent_risk, 100, high, h1, require_explicit_consent)), rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))]],
     [healthcare_risk_report([rank(1, dpv_risk(consent_risk, 100, high, h1, require_explicit_consent)), rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))]),
      list_member(rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), [rank(1, dpv_risk(consent_risk, 100, high, h1, require_explicit_consent)), rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))])]).
step(list_member(rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), [rank(1, dpv_risk(consent_risk, 100, high, h1, require_explicit_consent)), rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))]),
     rule(67),
     ['X' = rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)),
      'Xs' = [rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))]],
     [list_member(rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), [rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))])]).
step(list_member(rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), [rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))]),
     fact(66),
     ['X' = rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification))],
     []).
step(risk_resource(sharing_risk, ex('sharing-risk')), fact(49), [], []).
step(iri_term(ex('sharing-risk'), 'https://example.org/sharing-risk'),
     rule(57),
     ['Name' = 'sharing-risk', 'Iri' = 'https://example.org/sharing-risk'],
     [namespace_iri('https://example.org/', 'sharing-risk', 'https://example.org/sharing-risk')]).
step(namespace_iri('https://example.org/', 'sharing-risk', 'https://example.org/sharing-risk'),
     rule(59),
     ['Prefix' = 'https://example.org/',
      'Name' = 'sharing-risk',
      'Iri' = 'https://example.org/sharing-risk'],
     [atom_concat('https://example.org/', 'sharing-risk', 'https://example.org/sharing-risk')]).
step(atom_concat('https://example.org/', 'sharing-risk', 'https://example.org/sharing-risk'),
     builtin,
     [],
     []).
step(number_atom(2, '2'),
     rule(68),
     ['Number' = 2, 'Atom' = '2', 'Chars' = "2"],
     [number_chars(2, "2"), atom_chars('2', "2")]).
step(number_chars(2, "2"), builtin, [], []).
step(atom_chars('2', "2"), builtin, [], []).
step(result_rdf(iri('https://example.org/retention-risk'), iri('https://example.org/rank'), literal('3', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
     rule(60),
     ['RiskIri' = 'https://example.org/retention-risk',
      'RankText' = '3',
      'Rank' = 3,
      'Risk' = retention_risk,
      'RiskTerm' = ex('retention-risk')],
     [healthcare_ranked_item(3, retention_risk, 70, moderate, h4, limit_retention_to_1095_days),
      risk_resource(retention_risk, ex('retention-risk')),
      iri_term(ex('retention-risk'), 'https://example.org/retention-risk'),
      number_atom(3, '3')]).
step(healthcare_ranked_item(3, retention_risk, 70, moderate, h4, limit_retention_to_1095_days),
     rule(65),
     ['Rank' = 3,
      'Risk' = retention_risk,
      'Score' = 70,
      'Level' = moderate,
      'Clause' = h4,
      'Mitigation' = limit_retention_to_1095_days,
      'Ranked' = [rank(1, dpv_risk(consent_risk, 100, high, h1, require_explicit_consent)), rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))]],
     [healthcare_risk_report([rank(1, dpv_risk(consent_risk, 100, high, h1, require_explicit_consent)), rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))]),
      list_member(rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)), [rank(1, dpv_risk(consent_risk, 100, high, h1, require_explicit_consent)), rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))])]).
step(list_member(rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)), [rank(1, dpv_risk(consent_risk, 100, high, h1, require_explicit_consent)), rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))]),
     rule(67),
     ['X' = rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)),
      'Xs' = [rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))]],
     [list_member(rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)), [rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))])]).
step(list_member(rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)), [rank(2, dpv_risk(sharing_risk, 100, high, h2, require_deidentification)), rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))]),
     rule(67),
     ['X' = rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)),
      'Xs' = [rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))]],
     [list_member(rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)), [rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))])]).
step(list_member(rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)), [rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))]),
     fact(66),
     ['X' = rank(3, dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days))],
     []).
step(risk_resource(retention_risk, ex('retention-risk')), fact(50), [], []).
step(iri_term(ex('retention-risk'), 'https://example.org/retention-risk'),
     rule(57),
     ['Name' = 'retention-risk', 'Iri' = 'https://example.org/retention-risk'],
     [namespace_iri('https://example.org/', 'retention-risk', 'https://example.org/retention-risk')]).
step(namespace_iri('https://example.org/', 'retention-risk', 'https://example.org/retention-risk'),
     rule(59),
     ['Prefix' = 'https://example.org/',
      'Name' = 'retention-risk',
      'Iri' = 'https://example.org/retention-risk'],
     [atom_concat('https://example.org/', 'retention-risk', 'https://example.org/retention-risk')]).
step(atom_concat('https://example.org/', 'retention-risk', 'https://example.org/retention-risk'),
     builtin,
     [],
     []).
step(number_atom(3, '3'),
     rule(68),
     ['Number' = 3, 'Atom' = '3', 'Chars' = "3"],
     [number_chars(3, "3"), atom_chars('3', "3")]).
step(number_chars(3, "3"), builtin, [], []).
step(atom_chars('3', "3"), builtin, [], []).
step(result_rdf(iri('https://example.org/consent-risk'), iri('https://example.org/score'), literal('100', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
     rule(61),
     ['RiskIri' = 'https://example.org/consent-risk',
      'ScoreText' = '100',
      'Risk' = consent_risk,
      'Score' = 100,
      'RiskTerm' = ex('consent-risk')],
     [healthcare_ranked_item(1, consent_risk, 100, high, h1, require_explicit_consent),
      risk_resource(consent_risk, ex('consent-risk')),
      iri_term(ex('consent-risk'), 'https://example.org/consent-risk'),
      number_atom(100, '100')]).
step(number_atom(100, '100'),
     rule(68),
     ['Number' = 100, 'Atom' = '100', 'Chars' = "100"],
     [number_chars(100, "100"), atom_chars('100', "100")]).
step(number_chars(100, "100"), builtin, [], []).
step(atom_chars('100', "100"), builtin, [], []).
step(result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/score'), literal('100', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
     rule(61),
     ['RiskIri' = 'https://example.org/sharing-risk',
      'ScoreText' = '100',
      'Risk' = sharing_risk,
      'Score' = 100,
      'RiskTerm' = ex('sharing-risk')],
     [healthcare_ranked_item(2, sharing_risk, 100, high, h2, require_deidentification),
      risk_resource(sharing_risk, ex('sharing-risk')),
      iri_term(ex('sharing-risk'), 'https://example.org/sharing-risk'),
      number_atom(100, '100')]).
step(result_rdf(iri('https://example.org/retention-risk'), iri('https://example.org/score'), literal('70', datatype('http://www.w3.org/2001/XMLSchema#integer')), default_graph),
     rule(61),
     ['RiskIri' = 'https://example.org/retention-risk',
      'ScoreText' = '70',
      'Risk' = retention_risk,
      'Score' = 70,
      'RiskTerm' = ex('retention-risk')],
     [healthcare_ranked_item(3, retention_risk, 70, moderate, h4, limit_retention_to_1095_days),
      risk_resource(retention_risk, ex('retention-risk')),
      iri_term(ex('retention-risk'), 'https://example.org/retention-risk'),
      number_atom(70, '70')]).
step(number_atom(70, '70'),
     rule(68),
     ['Number' = 70, 'Atom' = '70', 'Chars' = "70"],
     [number_chars(70, "70"), atom_chars('70', "70")]).
step(number_chars(70, "70"), builtin, [], []).
step(atom_chars('70', "70"), builtin, [], []).
step(result_rdf(iri('https://example.org/consent-risk'), iri('https://example.org/level'), iri('https://example.org/high'), default_graph),
     rule(62),
     ['RiskIri' = 'https://example.org/consent-risk',
      'LevelIri' = 'https://example.org/high',
      'Risk' = consent_risk,
      'Level' = high,
      'RiskTerm' = ex('consent-risk')],
     [healthcare_ranked_item(1, consent_risk, 100, high, h1, require_explicit_consent),
      risk_resource(consent_risk, ex('consent-risk')),
      iri_term(ex('consent-risk'), 'https://example.org/consent-risk'),
      atom_concat('https://example.org/', high, 'https://example.org/high')]).
step(atom_concat('https://example.org/', high, 'https://example.org/high'), builtin, [], []).
step(result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/level'), iri('https://example.org/high'), default_graph),
     rule(62),
     ['RiskIri' = 'https://example.org/sharing-risk',
      'LevelIri' = 'https://example.org/high',
      'Risk' = sharing_risk,
      'Level' = high,
      'RiskTerm' = ex('sharing-risk')],
     [healthcare_ranked_item(2, sharing_risk, 100, high, h2, require_deidentification),
      risk_resource(sharing_risk, ex('sharing-risk')),
      iri_term(ex('sharing-risk'), 'https://example.org/sharing-risk'),
      atom_concat('https://example.org/', high, 'https://example.org/high')]).
step(result_rdf(iri('https://example.org/retention-risk'), iri('https://example.org/level'), iri('https://example.org/moderate'), default_graph),
     rule(62),
     ['RiskIri' = 'https://example.org/retention-risk',
      'LevelIri' = 'https://example.org/moderate',
      'Risk' = retention_risk,
      'Level' = moderate,
      'RiskTerm' = ex('retention-risk')],
     [healthcare_ranked_item(3, retention_risk, 70, moderate, h4, limit_retention_to_1095_days),
      risk_resource(retention_risk, ex('retention-risk')),
      iri_term(ex('retention-risk'), 'https://example.org/retention-risk'),
      atom_concat('https://example.org/', moderate, 'https://example.org/moderate')]).
step(atom_concat('https://example.org/', moderate, 'https://example.org/moderate'),
     builtin,
     [],
     []).
step(result_rdf(iri('https://example.org/consent-risk'), iri('https://example.org/clause'), literal(h1, datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph),
     rule(63),
     ['RiskIri' = 'https://example.org/consent-risk',
      'Clause' = h1,
      'Risk' = consent_risk,
      'RiskTerm' = ex('consent-risk')],
     [healthcare_ranked_item(1, consent_risk, 100, high, h1, require_explicit_consent),
      risk_resource(consent_risk, ex('consent-risk')),
      iri_term(ex('consent-risk'), 'https://example.org/consent-risk')]).
step(result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/clause'), literal(h2, datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph),
     rule(63),
     ['RiskIri' = 'https://example.org/sharing-risk',
      'Clause' = h2,
      'Risk' = sharing_risk,
      'RiskTerm' = ex('sharing-risk')],
     [healthcare_ranked_item(2, sharing_risk, 100, high, h2, require_deidentification),
      risk_resource(sharing_risk, ex('sharing-risk')),
      iri_term(ex('sharing-risk'), 'https://example.org/sharing-risk')]).
step(result_rdf(iri('https://example.org/retention-risk'), iri('https://example.org/clause'), literal(h4, datatype('http://www.w3.org/2001/XMLSchema#string')), default_graph),
     rule(63),
     ['RiskIri' = 'https://example.org/retention-risk',
      'Clause' = h4,
      'Risk' = retention_risk,
      'RiskTerm' = ex('retention-risk')],
     [healthcare_ranked_item(3, retention_risk, 70, moderate, h4, limit_retention_to_1095_days),
      risk_resource(retention_risk, ex('retention-risk')),
      iri_term(ex('retention-risk'), 'https://example.org/retention-risk')]).
step(result_rdf(iri('https://example.org/consent-risk'), iri('https://example.org/mitigation'), iri('https://example.org/require-explicit-consent'), default_graph),
     rule(64),
     ['RiskIri' = 'https://example.org/consent-risk',
      'MitigationIri' = 'https://example.org/require-explicit-consent',
      'Risk' = consent_risk,
      'Mitigation' = require_explicit_consent,
      'RiskTerm' = ex('consent-risk'),
      'MitigationTerm' = ex('require-explicit-consent')],
     [healthcare_ranked_item(1, consent_risk, 100, high, h1, require_explicit_consent),
      risk_resource(consent_risk, ex('consent-risk')),
      iri_term(ex('consent-risk'), 'https://example.org/consent-risk'),
      mitigation_resource(require_explicit_consent, ex('require-explicit-consent')),
      iri_term(ex('require-explicit-consent'), 'https://example.org/require-explicit-consent')]).
step(mitigation_resource(require_explicit_consent, ex('require-explicit-consent')),
     fact(51),
     [],
     []).
step(iri_term(ex('require-explicit-consent'), 'https://example.org/require-explicit-consent'),
     rule(57),
     ['Name' = 'require-explicit-consent',
      'Iri' = 'https://example.org/require-explicit-consent'],
     [namespace_iri('https://example.org/', 'require-explicit-consent', 'https://example.org/require-explicit-consent')]).
step(namespace_iri('https://example.org/', 'require-explicit-consent', 'https://example.org/require-explicit-consent'),
     rule(59),
     ['Prefix' = 'https://example.org/',
      'Name' = 'require-explicit-consent',
      'Iri' = 'https://example.org/require-explicit-consent'],
     [atom_concat('https://example.org/', 'require-explicit-consent', 'https://example.org/require-explicit-consent')]).
step(atom_concat('https://example.org/', 'require-explicit-consent', 'https://example.org/require-explicit-consent'),
     builtin,
     [],
     []).
step(result_rdf(iri('https://example.org/sharing-risk'), iri('https://example.org/mitigation'), iri('https://example.org/require-deidentification'), default_graph),
     rule(64),
     ['RiskIri' = 'https://example.org/sharing-risk',
      'MitigationIri' = 'https://example.org/require-deidentification',
      'Risk' = sharing_risk,
      'Mitigation' = require_deidentification,
      'RiskTerm' = ex('sharing-risk'),
      'MitigationTerm' = ex('require-deidentification')],
     [healthcare_ranked_item(2, sharing_risk, 100, high, h2, require_deidentification),
      risk_resource(sharing_risk, ex('sharing-risk')),
      iri_term(ex('sharing-risk'), 'https://example.org/sharing-risk'),
      mitigation_resource(require_deidentification, ex('require-deidentification')),
      iri_term(ex('require-deidentification'), 'https://example.org/require-deidentification')]).
step(mitigation_resource(require_deidentification, ex('require-deidentification')),
     fact(52),
     [],
     []).
step(iri_term(ex('require-deidentification'), 'https://example.org/require-deidentification'),
     rule(57),
     ['Name' = 'require-deidentification',
      'Iri' = 'https://example.org/require-deidentification'],
     [namespace_iri('https://example.org/', 'require-deidentification', 'https://example.org/require-deidentification')]).
step(namespace_iri('https://example.org/', 'require-deidentification', 'https://example.org/require-deidentification'),
     rule(59),
     ['Prefix' = 'https://example.org/',
      'Name' = 'require-deidentification',
      'Iri' = 'https://example.org/require-deidentification'],
     [atom_concat('https://example.org/', 'require-deidentification', 'https://example.org/require-deidentification')]).
step(atom_concat('https://example.org/', 'require-deidentification', 'https://example.org/require-deidentification'),
     builtin,
     [],
     []).
step(result_rdf(iri('https://example.org/retention-risk'), iri('https://example.org/mitigation'), iri('https://example.org/limit-retention-to-1095-days'), default_graph),
     rule(64),
     ['RiskIri' = 'https://example.org/retention-risk',
      'MitigationIri' = 'https://example.org/limit-retention-to-1095-days',
      'Risk' = retention_risk,
      'Mitigation' = limit_retention_to_1095_days,
      'RiskTerm' = ex('retention-risk'),
      'MitigationTerm' = ex('limit-retention-to-1095-days')],
     [healthcare_ranked_item(3, retention_risk, 70, moderate, h4, limit_retention_to_1095_days),
      risk_resource(retention_risk, ex('retention-risk')),
      iri_term(ex('retention-risk'), 'https://example.org/retention-risk'),
      mitigation_resource(limit_retention_to_1095_days, ex('limit-retention-to-1095-days')),
      iri_term(ex('limit-retention-to-1095-days'), 'https://example.org/limit-retention-to-1095-days')]).
step(mitigation_resource(limit_retention_to_1095_days, ex('limit-retention-to-1095-days')),
     fact(53),
     [],
     []).
step(iri_term(ex('limit-retention-to-1095-days'), 'https://example.org/limit-retention-to-1095-days'),
     rule(57),
     ['Name' = 'limit-retention-to-1095-days',
      'Iri' = 'https://example.org/limit-retention-to-1095-days'],
     [namespace_iri('https://example.org/', 'limit-retention-to-1095-days', 'https://example.org/limit-retention-to-1095-days')]).
step(namespace_iri('https://example.org/', 'limit-retention-to-1095-days', 'https://example.org/limit-retention-to-1095-days'),
     rule(59),
     ['Prefix' = 'https://example.org/',
      'Name' = 'limit-retention-to-1095-days',
      'Iri' = 'https://example.org/limit-retention-to-1095-days'],
     [atom_concat('https://example.org/', 'limit-retention-to-1095-days', 'https://example.org/limit-retention-to-1095-days')]).
step(atom_concat('https://example.org/', 'limit-retention-to-1095-days', 'https://example.org/limit-retention-to-1095-days'),
     builtin,
     [],
     []).
