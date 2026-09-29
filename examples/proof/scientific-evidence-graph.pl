supporting_study(marker_reduction, study_a).
supporting_study(marker_reduction, study_b).
supporting_study(survival_benefit, study_d).
counterevidence(marker_reduction, study_c, low_quality).
counterevidence(survival_benefit, study_e, high_quality).
evidence_state(marker_reduction, supported).
evidence_state(survival_benefit, contested).
evidence_reason(marker_reduction, "Two independent randomized studies with sample size >= 100 support the claim; the contradictory observational study is retained as lower-quality counterevidence.").
evidence_reason(survival_benefit, "High-quality randomized evidence exists on both sides, so the claim remains contested instead of being collapsed to a single truth value.").

clause(1,
       rdf(iri('https://example.org/evidence/study/study-a'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/reduces'), iri('https://example.org/evidence/outcome/inflammation-marker')), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(2,
       rdf(iri('https://example.org/evidence/study/study-a'), iri('https://example.org/vocab/direction'), iri('https://example.org/evidence/direction/supports'), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(3,
       rdf(iri('https://example.org/evidence/study/study-a'), iri('https://example.org/vocab/design'), iri('https://example.org/evidence/design/randomized-trial'), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(4,
       rdf(iri('https://example.org/evidence/study/study-a'), iri('https://example.org/vocab/institution'), iri('https://example.org/evidence/institution/lab-a'), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(5,
       rdf(iri('https://example.org/evidence/study/study-a'), iri('https://example.org/vocab/sampleSize'), literal('240', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(6,
       rdf(iri('https://example.org/evidence/study/study-a'), iri('https://example.org/vocab/peerReviewed'), iri('https://example.org/evidence/value/yes'), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(7,
       rdf(iri('https://example.org/evidence/study/study-b'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/reduces'), iri('https://example.org/evidence/outcome/inflammation-marker')), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(8,
       rdf(iri('https://example.org/evidence/study/study-b'), iri('https://example.org/vocab/direction'), iri('https://example.org/evidence/direction/supports'), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(9,
       rdf(iri('https://example.org/evidence/study/study-b'), iri('https://example.org/vocab/design'), iri('https://example.org/evidence/design/randomized-trial'), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(10,
       rdf(iri('https://example.org/evidence/study/study-b'), iri('https://example.org/vocab/institution'), iri('https://example.org/evidence/institution/lab-b'), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(11,
       rdf(iri('https://example.org/evidence/study/study-b'), iri('https://example.org/vocab/sampleSize'), literal('310', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(12,
       rdf(iri('https://example.org/evidence/study/study-b'), iri('https://example.org/vocab/peerReviewed'), iri('https://example.org/evidence/value/yes'), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(13,
       rdf(iri('https://example.org/evidence/study/study-c'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/reduces'), iri('https://example.org/evidence/outcome/inflammation-marker')), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(14,
       rdf(iri('https://example.org/evidence/study/study-c'), iri('https://example.org/vocab/direction'), iri('https://example.org/evidence/direction/contradicts'), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(15,
       rdf(iri('https://example.org/evidence/study/study-c'), iri('https://example.org/vocab/design'), iri('https://example.org/evidence/design/observational'), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(16,
       rdf(iri('https://example.org/evidence/study/study-c'), iri('https://example.org/vocab/institution'), iri('https://example.org/evidence/institution/lab-c'), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(17,
       rdf(iri('https://example.org/evidence/study/study-c'), iri('https://example.org/vocab/sampleSize'), literal('40', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(18,
       rdf(iri('https://example.org/evidence/study/study-c'), iri('https://example.org/vocab/peerReviewed'), iri('https://example.org/evidence/value/yes'), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(19,
       rdf(iri('https://example.org/evidence/study/study-d'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/improves'), iri('https://example.org/evidence/outcome/survival')), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(20,
       rdf(iri('https://example.org/evidence/study/study-d'), iri('https://example.org/vocab/direction'), iri('https://example.org/evidence/direction/supports'), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(21,
       rdf(iri('https://example.org/evidence/study/study-d'), iri('https://example.org/vocab/design'), iri('https://example.org/evidence/design/randomized-trial'), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(22,
       rdf(iri('https://example.org/evidence/study/study-d'), iri('https://example.org/vocab/institution'), iri('https://example.org/evidence/institution/lab-a'), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(23,
       rdf(iri('https://example.org/evidence/study/study-d'), iri('https://example.org/vocab/sampleSize'), literal('180', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(24,
       rdf(iri('https://example.org/evidence/study/study-d'), iri('https://example.org/vocab/peerReviewed'), iri('https://example.org/evidence/value/yes'), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(25,
       rdf(iri('https://example.org/evidence/study/study-e'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/improves'), iri('https://example.org/evidence/outcome/survival')), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(26,
       rdf(iri('https://example.org/evidence/study/study-e'), iri('https://example.org/vocab/direction'), iri('https://example.org/evidence/direction/contradicts'), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(27,
       rdf(iri('https://example.org/evidence/study/study-e'), iri('https://example.org/vocab/design'), iri('https://example.org/evidence/design/randomized-trial'), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(28,
       rdf(iri('https://example.org/evidence/study/study-e'), iri('https://example.org/vocab/institution'), iri('https://example.org/evidence/institution/lab-b'), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(29,
       rdf(iri('https://example.org/evidence/study/study-e'), iri('https://example.org/vocab/sampleSize'), literal('210', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(30,
       rdf(iri('https://example.org/evidence/study/study-e'), iri('https://example.org/vocab/peerReviewed'), iri('https://example.org/evidence/value/yes'), iri('https://example.org/evidence/graph/evidence')),
       true).
clause(31, v(statement, iri('https://example.org/vocab/statement')), true).
clause(32, v(direction, iri('https://example.org/vocab/direction')), true).
clause(33, v(design, iri('https://example.org/vocab/design')), true).
clause(34, v(institution, iri('https://example.org/vocab/institution')), true).
clause(35, v(sample_size, iri('https://example.org/vocab/sampleSize')), true).
clause(36, v(peer_reviewed, iri('https://example.org/vocab/peerReviewed')), true).
clause(37, g(evidence, iri('https://example.org/evidence/graph/evidence')), true).
clause(38, yes(iri('https://example.org/evidence/value/yes')), true).
clause(39, supports(iri('https://example.org/evidence/direction/supports')), true).
clause(40, contradicts(iri('https://example.org/evidence/direction/contradicts')), true).
clause(41, randomized(iri('https://example.org/evidence/design/randomized-trial')), true).
clause(42,
       claim(marker_reduction, iri('https://example.org/evidence/claim/marker-reduction'), triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/reduces'), iri('https://example.org/evidence/outcome/inflammation-marker'))),
       true).
clause(43,
       claim(survival_benefit, iri('https://example.org/evidence/claim/survival-benefit'), triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/improves'), iri('https://example.org/evidence/outcome/survival'))),
       true).
clause(44, study(study_a, iri('https://example.org/evidence/study/study-a')), true).
clause(45, study(study_b, iri('https://example.org/evidence/study/study-b')), true).
clause(46, study(study_c, iri('https://example.org/evidence/study/study-c')), true).
clause(47, study(study_d, iri('https://example.org/evidence/study/study-d')), true).
clause(48, study(study_e, iri('https://example.org/evidence/study/study-e')), true).
clause(49,
       integer_literal(literal(var('Text'), datatype('http://www.w3.org/2001/XMLSchema#integer')), var('N')),
       (atom_chars(var('Text'), var('Cs')), number_chars(var('N'), var('Cs')))).
clause(50,
       study_statement(var('Study'), var('Claim'), var('Direction'), var('Institution'), var('Design'), var('N')),
       (study(var('Study'), var('S')),
        claim(var('Claim'), anonymous(1), var('C')),
        g(evidence, var('G')),
        v(statement, var('PS')),
        v(direction, var('PD')),
        v(institution, var('PI')),
        v(design, var('PDe')),
        v(sample_size, var('PN')),
        v(peer_reviewed, var('PP')),
        rdf(var('S'), var('PS'), var('C'), var('G')),
        rdf(var('S'), var('PD'), var('Direction'), var('G')),
        rdf(var('S'), var('PI'), var('Institution'), var('G')),
        rdf(var('S'), var('PDe'), var('Design'), var('G')),
        rdf(var('S'), var('PN'), var('L'), var('G')),
        integer_literal(var('L'), var('N')),
        yes(var('Y')),
        rdf(var('S'), var('PP'), var('Y'), var('G')))).
clause(51,
       high_quality(var('Study'), var('Claim'), var('Direction'), var('Institution')),
       (study_statement(var('Study'), var('Claim'), var('Direction'), var('Institution'), var('Design'), var('N')),
        randomized(var('R')),
        var('Design') = var('R'),
        var('N') >= 100)).
clause(52,
       independent_support_pair(var('Claim'), var('S1'), var('S2')),
       (supports(var('S')),
        high_quality(var('S1'), var('Claim'), var('S'), var('I1')),
        high_quality(var('S2'), var('Claim'), var('S'), var('I2')),
        var('S1') @< var('S2'),
        var('I1') \= var('I2'))).
clause(53,
       high_quality_counterevidence(var('Claim'), var('Study')),
       (contradicts(var('C')), high_quality(var('Study'), var('Claim'), var('C'), anonymous(1)))).
clause(54,
       supporting_study(var('Claim'), var('Study')),
       (supports(var('S')), high_quality(var('Study'), var('Claim'), var('S'), anonymous(1)))).
clause(55,
       counterevidence(var('Claim'), var('Study'), low_quality),
       (contradicts(var('C')),
        study_statement(var('Study'), var('Claim'), var('C'), anonymous(1), anonymous(2), anonymous(3)),
        \+ high_quality(var('Study'), var('Claim'), var('C'), anonymous(4)))).
clause(56,
       counterevidence(var('Claim'), var('Study'), high_quality),
       high_quality_counterevidence(var('Claim'), var('Study'))).
clause(57,
       evidence_state(var('Claim'), supported),
       (independent_support_pair(var('Claim'), anonymous(1), anonymous(2)),
        \+ high_quality_counterevidence(var('Claim'), anonymous(3)))).
clause(58,
       evidence_state(var('Claim'), contested),
       (supporting_study(var('Claim'), anonymous(1)),
        high_quality_counterevidence(var('Claim'), anonymous(2)))).
clause(59,
       evidence_reason(marker_reduction, "Two independent randomized studies with sample size >= 100 support the claim; the contradictory observational study is retained as lower-quality counterevidence."),
       evidence_state(marker_reduction, supported)).
clause(60,
       evidence_reason(survival_benefit, "High-quality randomized evidence exists on both sides, so the claim remains contested instead of being collapsed to a single truth value."),
       evidence_state(survival_benefit, contested)).

step(supporting_study(marker_reduction, study_a),
     rule(54),
     ['Claim' = marker_reduction,
      'Study' = study_a,
      'S' = iri('https://example.org/evidence/direction/supports')],
     [supports(iri('https://example.org/evidence/direction/supports')),
      high_quality(study_a, marker_reduction, iri('https://example.org/evidence/direction/supports'), iri('https://example.org/evidence/institution/lab-a'))]).
step(supports(iri('https://example.org/evidence/direction/supports')), fact(39), [], []).
step(high_quality(study_a, marker_reduction, iri('https://example.org/evidence/direction/supports'), iri('https://example.org/evidence/institution/lab-a')),
     rule(51),
     ['Study' = study_a,
      'Claim' = marker_reduction,
      'Direction' = iri('https://example.org/evidence/direction/supports'),
      'Institution' = iri('https://example.org/evidence/institution/lab-a'),
      'Design' = iri('https://example.org/evidence/design/randomized-trial'),
      'N' = 240,
      'R' = iri('https://example.org/evidence/design/randomized-trial')],
     [study_statement(study_a, marker_reduction, iri('https://example.org/evidence/direction/supports'), iri('https://example.org/evidence/institution/lab-a'), iri('https://example.org/evidence/design/randomized-trial'), 240),
      randomized(iri('https://example.org/evidence/design/randomized-trial')),
      iri('https://example.org/evidence/design/randomized-trial') = iri('https://example.org/evidence/design/randomized-trial'),
      240 >= 100]).
step(study_statement(study_a, marker_reduction, iri('https://example.org/evidence/direction/supports'), iri('https://example.org/evidence/institution/lab-a'), iri('https://example.org/evidence/design/randomized-trial'), 240),
     rule(50),
     ['Study' = study_a,
      'Claim' = marker_reduction,
      'Direction' = iri('https://example.org/evidence/direction/supports'),
      'Institution' = iri('https://example.org/evidence/institution/lab-a'),
      'Design' = iri('https://example.org/evidence/design/randomized-trial'),
      'N' = 240,
      'S' = iri('https://example.org/evidence/study/study-a'),
      'C' = triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/reduces'), iri('https://example.org/evidence/outcome/inflammation-marker')),
      'G' = iri('https://example.org/evidence/graph/evidence'),
      'PS' = iri('https://example.org/vocab/statement'),
      'PD' = iri('https://example.org/vocab/direction'),
      'PI' = iri('https://example.org/vocab/institution'),
      'PDe' = iri('https://example.org/vocab/design'),
      'PN' = iri('https://example.org/vocab/sampleSize'),
      'PP' = iri('https://example.org/vocab/peerReviewed'),
      'L' = literal('240', datatype('http://www.w3.org/2001/XMLSchema#integer')),
      'Y' = iri('https://example.org/evidence/value/yes')],
     [study(study_a, iri('https://example.org/evidence/study/study-a')),
      claim(marker_reduction, iri('https://example.org/evidence/claim/marker-reduction'), triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/reduces'), iri('https://example.org/evidence/outcome/inflammation-marker'))),
      g(evidence, iri('https://example.org/evidence/graph/evidence')),
      v(statement, iri('https://example.org/vocab/statement')),
      v(direction, iri('https://example.org/vocab/direction')),
      v(institution, iri('https://example.org/vocab/institution')),
      v(design, iri('https://example.org/vocab/design')),
      v(sample_size, iri('https://example.org/vocab/sampleSize')),
      v(peer_reviewed, iri('https://example.org/vocab/peerReviewed')),
      rdf(iri('https://example.org/evidence/study/study-a'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/reduces'), iri('https://example.org/evidence/outcome/inflammation-marker')), iri('https://example.org/evidence/graph/evidence')),
      rdf(iri('https://example.org/evidence/study/study-a'), iri('https://example.org/vocab/direction'), iri('https://example.org/evidence/direction/supports'), iri('https://example.org/evidence/graph/evidence')),
      rdf(iri('https://example.org/evidence/study/study-a'), iri('https://example.org/vocab/institution'), iri('https://example.org/evidence/institution/lab-a'), iri('https://example.org/evidence/graph/evidence')),
      rdf(iri('https://example.org/evidence/study/study-a'), iri('https://example.org/vocab/design'), iri('https://example.org/evidence/design/randomized-trial'), iri('https://example.org/evidence/graph/evidence')),
      rdf(iri('https://example.org/evidence/study/study-a'), iri('https://example.org/vocab/sampleSize'), literal('240', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/evidence/graph/evidence')),
      integer_literal(literal('240', datatype('http://www.w3.org/2001/XMLSchema#integer')), 240),
      yes(iri('https://example.org/evidence/value/yes')),
      rdf(iri('https://example.org/evidence/study/study-a'), iri('https://example.org/vocab/peerReviewed'), iri('https://example.org/evidence/value/yes'), iri('https://example.org/evidence/graph/evidence'))]).
step(study(study_a, iri('https://example.org/evidence/study/study-a')), fact(44), [], []).
step(claim(marker_reduction, iri('https://example.org/evidence/claim/marker-reduction'), triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/reduces'), iri('https://example.org/evidence/outcome/inflammation-marker'))),
     fact(42),
     [],
     []).
step(g(evidence, iri('https://example.org/evidence/graph/evidence')), fact(37), [], []).
step(v(statement, iri('https://example.org/vocab/statement')), fact(31), [], []).
step(v(direction, iri('https://example.org/vocab/direction')), fact(32), [], []).
step(v(institution, iri('https://example.org/vocab/institution')), fact(34), [], []).
step(v(design, iri('https://example.org/vocab/design')), fact(33), [], []).
step(v(sample_size, iri('https://example.org/vocab/sampleSize')), fact(35), [], []).
step(v(peer_reviewed, iri('https://example.org/vocab/peerReviewed')), fact(36), [], []).
step(rdf(iri('https://example.org/evidence/study/study-a'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/reduces'), iri('https://example.org/evidence/outcome/inflammation-marker')), iri('https://example.org/evidence/graph/evidence')),
     fact(1),
     [],
     []).
step(rdf(iri('https://example.org/evidence/study/study-a'), iri('https://example.org/vocab/direction'), iri('https://example.org/evidence/direction/supports'), iri('https://example.org/evidence/graph/evidence')),
     fact(2),
     [],
     []).
step(rdf(iri('https://example.org/evidence/study/study-a'), iri('https://example.org/vocab/institution'), iri('https://example.org/evidence/institution/lab-a'), iri('https://example.org/evidence/graph/evidence')),
     fact(4),
     [],
     []).
step(rdf(iri('https://example.org/evidence/study/study-a'), iri('https://example.org/vocab/design'), iri('https://example.org/evidence/design/randomized-trial'), iri('https://example.org/evidence/graph/evidence')),
     fact(3),
     [],
     []).
step(rdf(iri('https://example.org/evidence/study/study-a'), iri('https://example.org/vocab/sampleSize'), literal('240', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/evidence/graph/evidence')),
     fact(5),
     [],
     []).
step(integer_literal(literal('240', datatype('http://www.w3.org/2001/XMLSchema#integer')), 240),
     rule(49),
     ['Text' = '240', 'N' = 240, 'Cs' = "240"],
     [atom_chars('240', "240"), number_chars(240, "240")]).
step(atom_chars('240', "240"), builtin, [], []).
step(number_chars(240, "240"), builtin, [], []).
step(yes(iri('https://example.org/evidence/value/yes')), fact(38), [], []).
step(rdf(iri('https://example.org/evidence/study/study-a'), iri('https://example.org/vocab/peerReviewed'), iri('https://example.org/evidence/value/yes'), iri('https://example.org/evidence/graph/evidence')),
     fact(6),
     [],
     []).
step(randomized(iri('https://example.org/evidence/design/randomized-trial')), fact(41), [], []).
step(iri('https://example.org/evidence/design/randomized-trial') = iri('https://example.org/evidence/design/randomized-trial'),
     builtin,
     [],
     []).
step(240 >= 100, builtin, [], []).
step(supporting_study(marker_reduction, study_b),
     rule(54),
     ['Claim' = marker_reduction,
      'Study' = study_b,
      'S' = iri('https://example.org/evidence/direction/supports')],
     [supports(iri('https://example.org/evidence/direction/supports')),
      high_quality(study_b, marker_reduction, iri('https://example.org/evidence/direction/supports'), iri('https://example.org/evidence/institution/lab-b'))]).
step(high_quality(study_b, marker_reduction, iri('https://example.org/evidence/direction/supports'), iri('https://example.org/evidence/institution/lab-b')),
     rule(51),
     ['Study' = study_b,
      'Claim' = marker_reduction,
      'Direction' = iri('https://example.org/evidence/direction/supports'),
      'Institution' = iri('https://example.org/evidence/institution/lab-b'),
      'Design' = iri('https://example.org/evidence/design/randomized-trial'),
      'N' = 310,
      'R' = iri('https://example.org/evidence/design/randomized-trial')],
     [study_statement(study_b, marker_reduction, iri('https://example.org/evidence/direction/supports'), iri('https://example.org/evidence/institution/lab-b'), iri('https://example.org/evidence/design/randomized-trial'), 310),
      randomized(iri('https://example.org/evidence/design/randomized-trial')),
      iri('https://example.org/evidence/design/randomized-trial') = iri('https://example.org/evidence/design/randomized-trial'),
      310 >= 100]).
step(study_statement(study_b, marker_reduction, iri('https://example.org/evidence/direction/supports'), iri('https://example.org/evidence/institution/lab-b'), iri('https://example.org/evidence/design/randomized-trial'), 310),
     rule(50),
     ['Study' = study_b,
      'Claim' = marker_reduction,
      'Direction' = iri('https://example.org/evidence/direction/supports'),
      'Institution' = iri('https://example.org/evidence/institution/lab-b'),
      'Design' = iri('https://example.org/evidence/design/randomized-trial'),
      'N' = 310,
      'S' = iri('https://example.org/evidence/study/study-b'),
      'C' = triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/reduces'), iri('https://example.org/evidence/outcome/inflammation-marker')),
      'G' = iri('https://example.org/evidence/graph/evidence'),
      'PS' = iri('https://example.org/vocab/statement'),
      'PD' = iri('https://example.org/vocab/direction'),
      'PI' = iri('https://example.org/vocab/institution'),
      'PDe' = iri('https://example.org/vocab/design'),
      'PN' = iri('https://example.org/vocab/sampleSize'),
      'PP' = iri('https://example.org/vocab/peerReviewed'),
      'L' = literal('310', datatype('http://www.w3.org/2001/XMLSchema#integer')),
      'Y' = iri('https://example.org/evidence/value/yes')],
     [study(study_b, iri('https://example.org/evidence/study/study-b')),
      claim(marker_reduction, iri('https://example.org/evidence/claim/marker-reduction'), triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/reduces'), iri('https://example.org/evidence/outcome/inflammation-marker'))),
      g(evidence, iri('https://example.org/evidence/graph/evidence')),
      v(statement, iri('https://example.org/vocab/statement')),
      v(direction, iri('https://example.org/vocab/direction')),
      v(institution, iri('https://example.org/vocab/institution')),
      v(design, iri('https://example.org/vocab/design')),
      v(sample_size, iri('https://example.org/vocab/sampleSize')),
      v(peer_reviewed, iri('https://example.org/vocab/peerReviewed')),
      rdf(iri('https://example.org/evidence/study/study-b'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/reduces'), iri('https://example.org/evidence/outcome/inflammation-marker')), iri('https://example.org/evidence/graph/evidence')),
      rdf(iri('https://example.org/evidence/study/study-b'), iri('https://example.org/vocab/direction'), iri('https://example.org/evidence/direction/supports'), iri('https://example.org/evidence/graph/evidence')),
      rdf(iri('https://example.org/evidence/study/study-b'), iri('https://example.org/vocab/institution'), iri('https://example.org/evidence/institution/lab-b'), iri('https://example.org/evidence/graph/evidence')),
      rdf(iri('https://example.org/evidence/study/study-b'), iri('https://example.org/vocab/design'), iri('https://example.org/evidence/design/randomized-trial'), iri('https://example.org/evidence/graph/evidence')),
      rdf(iri('https://example.org/evidence/study/study-b'), iri('https://example.org/vocab/sampleSize'), literal('310', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/evidence/graph/evidence')),
      integer_literal(literal('310', datatype('http://www.w3.org/2001/XMLSchema#integer')), 310),
      yes(iri('https://example.org/evidence/value/yes')),
      rdf(iri('https://example.org/evidence/study/study-b'), iri('https://example.org/vocab/peerReviewed'), iri('https://example.org/evidence/value/yes'), iri('https://example.org/evidence/graph/evidence'))]).
step(study(study_b, iri('https://example.org/evidence/study/study-b')), fact(45), [], []).
step(rdf(iri('https://example.org/evidence/study/study-b'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/reduces'), iri('https://example.org/evidence/outcome/inflammation-marker')), iri('https://example.org/evidence/graph/evidence')),
     fact(7),
     [],
     []).
step(rdf(iri('https://example.org/evidence/study/study-b'), iri('https://example.org/vocab/direction'), iri('https://example.org/evidence/direction/supports'), iri('https://example.org/evidence/graph/evidence')),
     fact(8),
     [],
     []).
step(rdf(iri('https://example.org/evidence/study/study-b'), iri('https://example.org/vocab/institution'), iri('https://example.org/evidence/institution/lab-b'), iri('https://example.org/evidence/graph/evidence')),
     fact(10),
     [],
     []).
step(rdf(iri('https://example.org/evidence/study/study-b'), iri('https://example.org/vocab/design'), iri('https://example.org/evidence/design/randomized-trial'), iri('https://example.org/evidence/graph/evidence')),
     fact(9),
     [],
     []).
step(rdf(iri('https://example.org/evidence/study/study-b'), iri('https://example.org/vocab/sampleSize'), literal('310', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/evidence/graph/evidence')),
     fact(11),
     [],
     []).
step(integer_literal(literal('310', datatype('http://www.w3.org/2001/XMLSchema#integer')), 310),
     rule(49),
     ['Text' = '310', 'N' = 310, 'Cs' = "310"],
     [atom_chars('310', "310"), number_chars(310, "310")]).
step(atom_chars('310', "310"), builtin, [], []).
step(number_chars(310, "310"), builtin, [], []).
step(rdf(iri('https://example.org/evidence/study/study-b'), iri('https://example.org/vocab/peerReviewed'), iri('https://example.org/evidence/value/yes'), iri('https://example.org/evidence/graph/evidence')),
     fact(12),
     [],
     []).
step(310 >= 100, builtin, [], []).
step(supporting_study(survival_benefit, study_d),
     rule(54),
     ['Claim' = survival_benefit,
      'Study' = study_d,
      'S' = iri('https://example.org/evidence/direction/supports')],
     [supports(iri('https://example.org/evidence/direction/supports')),
      high_quality(study_d, survival_benefit, iri('https://example.org/evidence/direction/supports'), iri('https://example.org/evidence/institution/lab-a'))]).
step(high_quality(study_d, survival_benefit, iri('https://example.org/evidence/direction/supports'), iri('https://example.org/evidence/institution/lab-a')),
     rule(51),
     ['Study' = study_d,
      'Claim' = survival_benefit,
      'Direction' = iri('https://example.org/evidence/direction/supports'),
      'Institution' = iri('https://example.org/evidence/institution/lab-a'),
      'Design' = iri('https://example.org/evidence/design/randomized-trial'),
      'N' = 180,
      'R' = iri('https://example.org/evidence/design/randomized-trial')],
     [study_statement(study_d, survival_benefit, iri('https://example.org/evidence/direction/supports'), iri('https://example.org/evidence/institution/lab-a'), iri('https://example.org/evidence/design/randomized-trial'), 180),
      randomized(iri('https://example.org/evidence/design/randomized-trial')),
      iri('https://example.org/evidence/design/randomized-trial') = iri('https://example.org/evidence/design/randomized-trial'),
      180 >= 100]).
step(study_statement(study_d, survival_benefit, iri('https://example.org/evidence/direction/supports'), iri('https://example.org/evidence/institution/lab-a'), iri('https://example.org/evidence/design/randomized-trial'), 180),
     rule(50),
     ['Study' = study_d,
      'Claim' = survival_benefit,
      'Direction' = iri('https://example.org/evidence/direction/supports'),
      'Institution' = iri('https://example.org/evidence/institution/lab-a'),
      'Design' = iri('https://example.org/evidence/design/randomized-trial'),
      'N' = 180,
      'S' = iri('https://example.org/evidence/study/study-d'),
      'C' = triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/improves'), iri('https://example.org/evidence/outcome/survival')),
      'G' = iri('https://example.org/evidence/graph/evidence'),
      'PS' = iri('https://example.org/vocab/statement'),
      'PD' = iri('https://example.org/vocab/direction'),
      'PI' = iri('https://example.org/vocab/institution'),
      'PDe' = iri('https://example.org/vocab/design'),
      'PN' = iri('https://example.org/vocab/sampleSize'),
      'PP' = iri('https://example.org/vocab/peerReviewed'),
      'L' = literal('180', datatype('http://www.w3.org/2001/XMLSchema#integer')),
      'Y' = iri('https://example.org/evidence/value/yes')],
     [study(study_d, iri('https://example.org/evidence/study/study-d')),
      claim(survival_benefit, iri('https://example.org/evidence/claim/survival-benefit'), triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/improves'), iri('https://example.org/evidence/outcome/survival'))),
      g(evidence, iri('https://example.org/evidence/graph/evidence')),
      v(statement, iri('https://example.org/vocab/statement')),
      v(direction, iri('https://example.org/vocab/direction')),
      v(institution, iri('https://example.org/vocab/institution')),
      v(design, iri('https://example.org/vocab/design')),
      v(sample_size, iri('https://example.org/vocab/sampleSize')),
      v(peer_reviewed, iri('https://example.org/vocab/peerReviewed')),
      rdf(iri('https://example.org/evidence/study/study-d'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/improves'), iri('https://example.org/evidence/outcome/survival')), iri('https://example.org/evidence/graph/evidence')),
      rdf(iri('https://example.org/evidence/study/study-d'), iri('https://example.org/vocab/direction'), iri('https://example.org/evidence/direction/supports'), iri('https://example.org/evidence/graph/evidence')),
      rdf(iri('https://example.org/evidence/study/study-d'), iri('https://example.org/vocab/institution'), iri('https://example.org/evidence/institution/lab-a'), iri('https://example.org/evidence/graph/evidence')),
      rdf(iri('https://example.org/evidence/study/study-d'), iri('https://example.org/vocab/design'), iri('https://example.org/evidence/design/randomized-trial'), iri('https://example.org/evidence/graph/evidence')),
      rdf(iri('https://example.org/evidence/study/study-d'), iri('https://example.org/vocab/sampleSize'), literal('180', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/evidence/graph/evidence')),
      integer_literal(literal('180', datatype('http://www.w3.org/2001/XMLSchema#integer')), 180),
      yes(iri('https://example.org/evidence/value/yes')),
      rdf(iri('https://example.org/evidence/study/study-d'), iri('https://example.org/vocab/peerReviewed'), iri('https://example.org/evidence/value/yes'), iri('https://example.org/evidence/graph/evidence'))]).
step(study(study_d, iri('https://example.org/evidence/study/study-d')), fact(47), [], []).
step(claim(survival_benefit, iri('https://example.org/evidence/claim/survival-benefit'), triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/improves'), iri('https://example.org/evidence/outcome/survival'))),
     fact(43),
     [],
     []).
step(rdf(iri('https://example.org/evidence/study/study-d'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/improves'), iri('https://example.org/evidence/outcome/survival')), iri('https://example.org/evidence/graph/evidence')),
     fact(19),
     [],
     []).
step(rdf(iri('https://example.org/evidence/study/study-d'), iri('https://example.org/vocab/direction'), iri('https://example.org/evidence/direction/supports'), iri('https://example.org/evidence/graph/evidence')),
     fact(20),
     [],
     []).
step(rdf(iri('https://example.org/evidence/study/study-d'), iri('https://example.org/vocab/institution'), iri('https://example.org/evidence/institution/lab-a'), iri('https://example.org/evidence/graph/evidence')),
     fact(22),
     [],
     []).
step(rdf(iri('https://example.org/evidence/study/study-d'), iri('https://example.org/vocab/design'), iri('https://example.org/evidence/design/randomized-trial'), iri('https://example.org/evidence/graph/evidence')),
     fact(21),
     [],
     []).
step(rdf(iri('https://example.org/evidence/study/study-d'), iri('https://example.org/vocab/sampleSize'), literal('180', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/evidence/graph/evidence')),
     fact(23),
     [],
     []).
step(integer_literal(literal('180', datatype('http://www.w3.org/2001/XMLSchema#integer')), 180),
     rule(49),
     ['Text' = '180', 'N' = 180, 'Cs' = "180"],
     [atom_chars('180', "180"), number_chars(180, "180")]).
step(atom_chars('180', "180"), builtin, [], []).
step(number_chars(180, "180"), builtin, [], []).
step(rdf(iri('https://example.org/evidence/study/study-d'), iri('https://example.org/vocab/peerReviewed'), iri('https://example.org/evidence/value/yes'), iri('https://example.org/evidence/graph/evidence')),
     fact(24),
     [],
     []).
step(180 >= 100, builtin, [], []).
step(counterevidence(marker_reduction, study_c, low_quality),
     rule(55),
     ['Claim' = marker_reduction,
      'Study' = study_c,
      'C' = iri('https://example.org/evidence/direction/contradicts')],
     [contradicts(iri('https://example.org/evidence/direction/contradicts')),
      study_statement(study_c, marker_reduction, iri('https://example.org/evidence/direction/contradicts'), iri('https://example.org/evidence/institution/lab-c'), iri('https://example.org/evidence/design/observational'), 40),
      \+ high_quality(study_c, marker_reduction, iri('https://example.org/evidence/direction/contradicts'), __anon2)]).
step(contradicts(iri('https://example.org/evidence/direction/contradicts')), fact(40), [], []).
step(study_statement(study_c, marker_reduction, iri('https://example.org/evidence/direction/contradicts'), iri('https://example.org/evidence/institution/lab-c'), iri('https://example.org/evidence/design/observational'), 40),
     rule(50),
     ['Study' = study_c,
      'Claim' = marker_reduction,
      'Direction' = iri('https://example.org/evidence/direction/contradicts'),
      'Institution' = iri('https://example.org/evidence/institution/lab-c'),
      'Design' = iri('https://example.org/evidence/design/observational'),
      'N' = 40,
      'S' = iri('https://example.org/evidence/study/study-c'),
      'C' = triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/reduces'), iri('https://example.org/evidence/outcome/inflammation-marker')),
      'G' = iri('https://example.org/evidence/graph/evidence'),
      'PS' = iri('https://example.org/vocab/statement'),
      'PD' = iri('https://example.org/vocab/direction'),
      'PI' = iri('https://example.org/vocab/institution'),
      'PDe' = iri('https://example.org/vocab/design'),
      'PN' = iri('https://example.org/vocab/sampleSize'),
      'PP' = iri('https://example.org/vocab/peerReviewed'),
      'L' = literal('40', datatype('http://www.w3.org/2001/XMLSchema#integer')),
      'Y' = iri('https://example.org/evidence/value/yes')],
     [study(study_c, iri('https://example.org/evidence/study/study-c')),
      claim(marker_reduction, iri('https://example.org/evidence/claim/marker-reduction'), triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/reduces'), iri('https://example.org/evidence/outcome/inflammation-marker'))),
      g(evidence, iri('https://example.org/evidence/graph/evidence')),
      v(statement, iri('https://example.org/vocab/statement')),
      v(direction, iri('https://example.org/vocab/direction')),
      v(institution, iri('https://example.org/vocab/institution')),
      v(design, iri('https://example.org/vocab/design')),
      v(sample_size, iri('https://example.org/vocab/sampleSize')),
      v(peer_reviewed, iri('https://example.org/vocab/peerReviewed')),
      rdf(iri('https://example.org/evidence/study/study-c'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/reduces'), iri('https://example.org/evidence/outcome/inflammation-marker')), iri('https://example.org/evidence/graph/evidence')),
      rdf(iri('https://example.org/evidence/study/study-c'), iri('https://example.org/vocab/direction'), iri('https://example.org/evidence/direction/contradicts'), iri('https://example.org/evidence/graph/evidence')),
      rdf(iri('https://example.org/evidence/study/study-c'), iri('https://example.org/vocab/institution'), iri('https://example.org/evidence/institution/lab-c'), iri('https://example.org/evidence/graph/evidence')),
      rdf(iri('https://example.org/evidence/study/study-c'), iri('https://example.org/vocab/design'), iri('https://example.org/evidence/design/observational'), iri('https://example.org/evidence/graph/evidence')),
      rdf(iri('https://example.org/evidence/study/study-c'), iri('https://example.org/vocab/sampleSize'), literal('40', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/evidence/graph/evidence')),
      integer_literal(literal('40', datatype('http://www.w3.org/2001/XMLSchema#integer')), 40),
      yes(iri('https://example.org/evidence/value/yes')),
      rdf(iri('https://example.org/evidence/study/study-c'), iri('https://example.org/vocab/peerReviewed'), iri('https://example.org/evidence/value/yes'), iri('https://example.org/evidence/graph/evidence'))]).
step(study(study_c, iri('https://example.org/evidence/study/study-c')), fact(46), [], []).
step(rdf(iri('https://example.org/evidence/study/study-c'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/reduces'), iri('https://example.org/evidence/outcome/inflammation-marker')), iri('https://example.org/evidence/graph/evidence')),
     fact(13),
     [],
     []).
step(rdf(iri('https://example.org/evidence/study/study-c'), iri('https://example.org/vocab/direction'), iri('https://example.org/evidence/direction/contradicts'), iri('https://example.org/evidence/graph/evidence')),
     fact(14),
     [],
     []).
step(rdf(iri('https://example.org/evidence/study/study-c'), iri('https://example.org/vocab/institution'), iri('https://example.org/evidence/institution/lab-c'), iri('https://example.org/evidence/graph/evidence')),
     fact(16),
     [],
     []).
step(rdf(iri('https://example.org/evidence/study/study-c'), iri('https://example.org/vocab/design'), iri('https://example.org/evidence/design/observational'), iri('https://example.org/evidence/graph/evidence')),
     fact(15),
     [],
     []).
step(rdf(iri('https://example.org/evidence/study/study-c'), iri('https://example.org/vocab/sampleSize'), literal('40', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/evidence/graph/evidence')),
     fact(17),
     [],
     []).
step(integer_literal(literal('40', datatype('http://www.w3.org/2001/XMLSchema#integer')), 40),
     rule(49),
     ['Text' = '40', 'N' = 40, 'Cs' = "40"],
     [atom_chars('40', "40"), number_chars(40, "40")]).
step(atom_chars('40', "40"), builtin, [], []).
step(number_chars(40, "40"), builtin, [], []).
step(rdf(iri('https://example.org/evidence/study/study-c'), iri('https://example.org/vocab/peerReviewed'), iri('https://example.org/evidence/value/yes'), iri('https://example.org/evidence/graph/evidence')),
     fact(18),
     [],
     []).
step(\+ high_quality(study_c, marker_reduction, iri('https://example.org/evidence/direction/contradicts'), __anon2),
     absent,
     [],
     []).
step(counterevidence(survival_benefit, study_e, high_quality),
     rule(56),
     ['Claim' = survival_benefit, 'Study' = study_e],
     [high_quality_counterevidence(survival_benefit, study_e)]).
step(high_quality_counterevidence(survival_benefit, study_e),
     rule(53),
     ['Claim' = survival_benefit,
      'Study' = study_e,
      'C' = iri('https://example.org/evidence/direction/contradicts')],
     [contradicts(iri('https://example.org/evidence/direction/contradicts')),
      high_quality(study_e, survival_benefit, iri('https://example.org/evidence/direction/contradicts'), iri('https://example.org/evidence/institution/lab-b'))]).
step(high_quality(study_e, survival_benefit, iri('https://example.org/evidence/direction/contradicts'), iri('https://example.org/evidence/institution/lab-b')),
     rule(51),
     ['Study' = study_e,
      'Claim' = survival_benefit,
      'Direction' = iri('https://example.org/evidence/direction/contradicts'),
      'Institution' = iri('https://example.org/evidence/institution/lab-b'),
      'Design' = iri('https://example.org/evidence/design/randomized-trial'),
      'N' = 210,
      'R' = iri('https://example.org/evidence/design/randomized-trial')],
     [study_statement(study_e, survival_benefit, iri('https://example.org/evidence/direction/contradicts'), iri('https://example.org/evidence/institution/lab-b'), iri('https://example.org/evidence/design/randomized-trial'), 210),
      randomized(iri('https://example.org/evidence/design/randomized-trial')),
      iri('https://example.org/evidence/design/randomized-trial') = iri('https://example.org/evidence/design/randomized-trial'),
      210 >= 100]).
step(study_statement(study_e, survival_benefit, iri('https://example.org/evidence/direction/contradicts'), iri('https://example.org/evidence/institution/lab-b'), iri('https://example.org/evidence/design/randomized-trial'), 210),
     rule(50),
     ['Study' = study_e,
      'Claim' = survival_benefit,
      'Direction' = iri('https://example.org/evidence/direction/contradicts'),
      'Institution' = iri('https://example.org/evidence/institution/lab-b'),
      'Design' = iri('https://example.org/evidence/design/randomized-trial'),
      'N' = 210,
      'S' = iri('https://example.org/evidence/study/study-e'),
      'C' = triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/improves'), iri('https://example.org/evidence/outcome/survival')),
      'G' = iri('https://example.org/evidence/graph/evidence'),
      'PS' = iri('https://example.org/vocab/statement'),
      'PD' = iri('https://example.org/vocab/direction'),
      'PI' = iri('https://example.org/vocab/institution'),
      'PDe' = iri('https://example.org/vocab/design'),
      'PN' = iri('https://example.org/vocab/sampleSize'),
      'PP' = iri('https://example.org/vocab/peerReviewed'),
      'L' = literal('210', datatype('http://www.w3.org/2001/XMLSchema#integer')),
      'Y' = iri('https://example.org/evidence/value/yes')],
     [study(study_e, iri('https://example.org/evidence/study/study-e')),
      claim(survival_benefit, iri('https://example.org/evidence/claim/survival-benefit'), triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/improves'), iri('https://example.org/evidence/outcome/survival'))),
      g(evidence, iri('https://example.org/evidence/graph/evidence')),
      v(statement, iri('https://example.org/vocab/statement')),
      v(direction, iri('https://example.org/vocab/direction')),
      v(institution, iri('https://example.org/vocab/institution')),
      v(design, iri('https://example.org/vocab/design')),
      v(sample_size, iri('https://example.org/vocab/sampleSize')),
      v(peer_reviewed, iri('https://example.org/vocab/peerReviewed')),
      rdf(iri('https://example.org/evidence/study/study-e'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/improves'), iri('https://example.org/evidence/outcome/survival')), iri('https://example.org/evidence/graph/evidence')),
      rdf(iri('https://example.org/evidence/study/study-e'), iri('https://example.org/vocab/direction'), iri('https://example.org/evidence/direction/contradicts'), iri('https://example.org/evidence/graph/evidence')),
      rdf(iri('https://example.org/evidence/study/study-e'), iri('https://example.org/vocab/institution'), iri('https://example.org/evidence/institution/lab-b'), iri('https://example.org/evidence/graph/evidence')),
      rdf(iri('https://example.org/evidence/study/study-e'), iri('https://example.org/vocab/design'), iri('https://example.org/evidence/design/randomized-trial'), iri('https://example.org/evidence/graph/evidence')),
      rdf(iri('https://example.org/evidence/study/study-e'), iri('https://example.org/vocab/sampleSize'), literal('210', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/evidence/graph/evidence')),
      integer_literal(literal('210', datatype('http://www.w3.org/2001/XMLSchema#integer')), 210),
      yes(iri('https://example.org/evidence/value/yes')),
      rdf(iri('https://example.org/evidence/study/study-e'), iri('https://example.org/vocab/peerReviewed'), iri('https://example.org/evidence/value/yes'), iri('https://example.org/evidence/graph/evidence'))]).
step(study(study_e, iri('https://example.org/evidence/study/study-e')), fact(48), [], []).
step(rdf(iri('https://example.org/evidence/study/study-e'), iri('https://example.org/vocab/statement'), triple(iri('https://example.org/evidence/intervention/therapy-x'), iri('https://example.org/vocab/improves'), iri('https://example.org/evidence/outcome/survival')), iri('https://example.org/evidence/graph/evidence')),
     fact(25),
     [],
     []).
step(rdf(iri('https://example.org/evidence/study/study-e'), iri('https://example.org/vocab/direction'), iri('https://example.org/evidence/direction/contradicts'), iri('https://example.org/evidence/graph/evidence')),
     fact(26),
     [],
     []).
step(rdf(iri('https://example.org/evidence/study/study-e'), iri('https://example.org/vocab/institution'), iri('https://example.org/evidence/institution/lab-b'), iri('https://example.org/evidence/graph/evidence')),
     fact(28),
     [],
     []).
step(rdf(iri('https://example.org/evidence/study/study-e'), iri('https://example.org/vocab/design'), iri('https://example.org/evidence/design/randomized-trial'), iri('https://example.org/evidence/graph/evidence')),
     fact(27),
     [],
     []).
step(rdf(iri('https://example.org/evidence/study/study-e'), iri('https://example.org/vocab/sampleSize'), literal('210', datatype('http://www.w3.org/2001/XMLSchema#integer')), iri('https://example.org/evidence/graph/evidence')),
     fact(29),
     [],
     []).
step(integer_literal(literal('210', datatype('http://www.w3.org/2001/XMLSchema#integer')), 210),
     rule(49),
     ['Text' = '210', 'N' = 210, 'Cs' = "210"],
     [atom_chars('210', "210"), number_chars(210, "210")]).
step(atom_chars('210', "210"), builtin, [], []).
step(number_chars(210, "210"), builtin, [], []).
step(rdf(iri('https://example.org/evidence/study/study-e'), iri('https://example.org/vocab/peerReviewed'), iri('https://example.org/evidence/value/yes'), iri('https://example.org/evidence/graph/evidence')),
     fact(30),
     [],
     []).
step(210 >= 100, builtin, [], []).
step(evidence_state(marker_reduction, supported),
     rule(57),
     ['Claim' = marker_reduction],
     [independent_support_pair(marker_reduction, study_a, study_b),
      \+ high_quality_counterevidence(marker_reduction, _Counter)]).
step(independent_support_pair(marker_reduction, study_a, study_b),
     rule(52),
     ['Claim' = marker_reduction,
      'S1' = study_a,
      'S2' = study_b,
      'S' = iri('https://example.org/evidence/direction/supports'),
      'I1' = iri('https://example.org/evidence/institution/lab-a'),
      'I2' = iri('https://example.org/evidence/institution/lab-b')],
     [supports(iri('https://example.org/evidence/direction/supports')),
      high_quality(study_a, marker_reduction, iri('https://example.org/evidence/direction/supports'), iri('https://example.org/evidence/institution/lab-a')),
      high_quality(study_b, marker_reduction, iri('https://example.org/evidence/direction/supports'), iri('https://example.org/evidence/institution/lab-b')),
      study_a @< study_b,
      iri('https://example.org/evidence/institution/lab-a') \= iri('https://example.org/evidence/institution/lab-b')]).
step(study_a @< study_b, builtin, [], []).
step(iri('https://example.org/evidence/institution/lab-a') \= iri('https://example.org/evidence/institution/lab-b'),
     builtin,
     [],
     []).
step(\+ high_quality_counterevidence(marker_reduction, _Counter), absent, [], []).
step(evidence_state(survival_benefit, contested),
     rule(58),
     ['Claim' = survival_benefit],
     [supporting_study(survival_benefit, study_d),
      high_quality_counterevidence(survival_benefit, study_e)]).
step(evidence_reason(marker_reduction, "Two independent randomized studies with sample size >= 100 support the claim; the contradictory observational study is retained as lower-quality counterevidence."),
     rule(59),
     [],
     [evidence_state(marker_reduction, supported)]).
step(evidence_reason(survival_benefit, "High-quality randomized evidence exists on both sides, so the claim remains contested instead of being collapsed to a single truth value."),
     rule(60),
     [],
     [evidence_state(survival_benefit, contested)]).
