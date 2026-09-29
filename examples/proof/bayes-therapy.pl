scores(case, [0.009282000000000002, 0.008208, 0.00012824999999999997, 0.00156408]).
evidenceTotal(case, 0.019182330000000004).
posteriors(case, [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716]).
posterior(covid19, 0.48388282341092037).
posterior(influenza, 0.42789379600913957).
posterior(allergicRhinitis, 0.006685840562642804).
posterior(bacterialPneumonia, 0.08153754001729716).
expectedSuccess(paxlovid, 0.388517401170765).
expectedSuccess(oseltamivir, 0.28514101258814745).
expectedSuccess(antihistamine, 0.10026891936485297).
expectedSuccess(antibiotic, 0.1109525797960936).
expectedSuccess(supportiveCare, 0.2915119539701381).
expectedAdverse(paxlovid, 0.1).
expectedAdverse(oseltamivir, 0.08).
expectedAdverse(antihistamine, 0.03).
expectedAdverse(antibiotic, 0.07).
expectedAdverse(supportiveCare, 0.01).
utility(paxlovid, 3.5851740117076503).
utility(oseltamivir, 2.6114101258814744).
utility(antihistamine, 0.9126891936485296).
utility(antibiotic, 0.8995257979609361).
utility(supportiveCare, 2.8851195397013814).
recommendedTherapy(case, paxlovid).

clause(8, diseases(case, [covid19, influenza, allergicRhinitis, bacterialPneumonia]), true).
clause(9,
       therapies(case, [paxlovid, oseltamivir, supportiveCare, antibiotic, antihistamine]),
       true).
clause(10,
       evidence(case, [ev(fever, true), ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)]),
       true).
clause(11, prior(covid19, 0.05), true).
clause(12, prior(influenza, 0.03), true).
clause(13, prior(allergicRhinitis, 0.1), true).
clause(14, prior(bacterialPneumonia, 0.01), true).
clause(15, p_given(covid19, fever, 0.7), true).
clause(16, p_given(covid19, dryCough, 0.65), true).
clause(17, p_given(covid19, lossOfSmell, 0.4), true).
clause(18, p_given(covid19, sneezing, 0.15), true).
clause(19, p_given(covid19, shortBreath, 0.2), true).
clause(20, p_given(influenza, fever, 0.8), true).
clause(21, p_given(influenza, dryCough, 0.5), true).
clause(22, p_given(influenza, lossOfSmell, 0.05), true).
clause(23, p_given(influenza, sneezing, 0.2), true).
clause(24, p_given(influenza, shortBreath, 0.1), true).
clause(25, p_given(allergicRhinitis, fever, 0.05), true).
clause(26, p_given(allergicRhinitis, dryCough, 0.15), true).
clause(27, p_given(allergicRhinitis, lossOfSmell, 0.1), true).
clause(28, p_given(allergicRhinitis, sneezing, 0.8), true).
clause(29, p_given(allergicRhinitis, shortBreath, 0.05), true).
clause(30, p_given(bacterialPneumonia, fever, 0.7), true).
clause(31, p_given(bacterialPneumonia, dryCough, 0.6), true).
clause(32, p_given(bacterialPneumonia, lossOfSmell, 0.02), true).
clause(33, p_given(bacterialPneumonia, sneezing, 0.05), true).
clause(34, p_given(bacterialPneumonia, shortBreath, 0.6), true).
clause(35, therapy(paxlovid), true).
clause(36, therapy(oseltamivir), true).
clause(37, therapy(antihistamine), true).
clause(38, therapy(antibiotic), true).
clause(39, therapy(supportiveCare), true).
clause(40, success_by_disease(paxlovid, [0.75, 0.05, 0.02, 0.05]), true).
clause(41, success_by_disease(oseltamivir, [0.05, 0.6, 0.02, 0.05]), true).
clause(42, success_by_disease(antihistamine, [0.1, 0.1, 0.75, 0.05]), true).
clause(43, success_by_disease(antibiotic, [0.05, 0.05, 0.02, 0.8]), true).
clause(44, success_by_disease(supportiveCare, [0.3, 0.3, 0.25, 0.2]), true).
clause(45, adverse(paxlovid, 0.1), true).
clause(46, adverse(oseltamivir, 0.08), true).
clause(47, adverse(antihistamine, 0.03), true).
clause(48, adverse(antibiotic, 0.07), true).
clause(49, adverse(supportiveCare, 0.01), true).
clause(50, benefit_weight(10), true).
clause(51, harm_weight(3), true).
clause(52,
       factor(var('Disease'), ev(var('Symptom'), true), var('P')),
       p_given(var('Disease'), var('Symptom'), var('P'))).
clause(53,
       factor(var('Disease'), ev(var('Symptom'), false), var('Q')),
       (p_given(var('Disease'), var('Symptom'), var('P')), var('Q') is 1.0 - var('P'))).
clause(54, likelihood(anonymous(1), [], 1.0), true).
clause(55,
       likelihood(var('Disease'), [var('Evidence') | var('Rest')], var('Likelihood')),
       (factor(var('Disease'), var('Evidence'), var('Factor')),
        likelihood(var('Disease'), var('Rest'), var('Taillikelihood')),
        var('Likelihood') is var('Factor') * var('Taillikelihood'))).
clause(56,
       score(var('Disease'), var('Score')),
       (prior(var('Disease'), var('Prior')),
        evidence(case, var('Evidence')),
        likelihood(var('Disease'), var('Evidence'), var('Likelihood')),
        var('Score') is var('Prior') * var('Likelihood'))).
clause(57, scores_for([], []), true).
clause(58,
       scores_for([var('Disease') | var('Restdiseases')], [var('Score') | var('Restscores')]),
       (score(var('Disease'), var('Score')), scores_for(var('Restdiseases'), var('Restscores')))).
clause(59, score_sum([], 0.0), true).
clause(60,
       score_sum([var('Value') | var('Rest')], var('Sum')),
       (score_sum(var('Rest'), var('Tailsum')), var('Sum') is var('Value') + var('Tailsum'))).
clause(61, normalize_scores([], anonymous(1), []), true).
clause(62,
       normalize_scores([var('Score') | var('Restscores')], var('Total'), [var('Posterior') | var('Restposteriors')]),
       (var('Posterior') is var('Score') / var('Total'),
        normalize_scores(var('Restscores'), var('Total'), var('Restposteriors')))).
clause(63,
       disease_posterior([var('Disease') | anonymous(1)], [var('Posterior') | anonymous(2)], var('Disease'), var('Posterior')),
       true).
clause(64,
       disease_posterior([anonymous(1) | var('Restdiseases')], [anonymous(2) | var('Restposteriors')], var('Disease'), var('Posterior')),
       disease_posterior(var('Restdiseases'), var('Restposteriors'), var('Disease'), var('Posterior'))).
clause(65, dot_product([], [], 0.0), true).
clause(66,
       dot_product([var('Left') | var('Restleft')], [var('Right') | var('Restright')], var('Sum')),
       (var('Term') is var('Left') * var('Right'),
        dot_product(var('Restleft'), var('Restright'), var('Tailsum')),
        var('Sum') is var('Term') + var('Tailsum'))).
clause(67,
       expected_success(var('Therapy'), var('Expectedsuccess')),
       (posteriors(case, var('Posteriors')),
        success_by_disease(var('Therapy'), var('Successbydisease')),
        dot_product(var('Posteriors'), var('Successbydisease'), var('Expectedsuccess')))).
clause(68,
       therapy_utility(var('Therapy'), var('Utility')),
       (expected_success(var('Therapy'), var('Expectedsuccess')),
        adverse(var('Therapy'), var('Adverse')),
        benefit_weight(var('Benefitweight')),
        harm_weight(var('Harmweight')),
        var('Benefit') is var('Benefitweight') * var('Expectedsuccess'),
        var('Harmcost') is var('Harmweight') * var('Adverse'),
        var('Utility') is var('Benefit') - var('Harmcost'))).
clause(69,
       better_of(var('Therapy1'), var('Therapy2'), var('Therapy1')),
       (therapy_utility(var('Therapy1'), var('Utility1')),
        therapy_utility(var('Therapy2'), var('Utility2')),
        var('Utility1') >= var('Utility2'))).
clause(70,
       better_of(var('Therapy1'), var('Therapy2'), var('Therapy2')),
       (therapy_utility(var('Therapy1'), var('Utility1')),
        therapy_utility(var('Therapy2'), var('Utility2')),
        var('Utility1') < var('Utility2'))).
clause(71, best_therapy([var('Therapy')], var('Therapy')), true).
clause(72,
       best_therapy([var('Head'), var('Next') | var('Rest')], var('Best')),
       (best_therapy([var('Next') | var('Rest')], var('Bestrest')),
        better_of(var('Head'), var('Bestrest'), var('Best')))).
clause(73,
       scores(case, var('Scores')),
       (diseases(case, var('Diseases')), scores_for(var('Diseases'), var('Scores')))).
clause(74,
       evidenceTotal(case, var('Total')),
       (scores(case, var('Scores')), score_sum(var('Scores'), var('Total')))).
clause(75,
       posteriors(case, var('Posteriors')),
       (scores(case, var('Scores')),
        evidenceTotal(case, var('Total')),
        normalize_scores(var('Scores'), var('Total'), var('Posteriors')))).
clause(76,
       posterior(var('Disease'), var('Posterior')),
       (diseases(case, var('Diseases')),
        posteriors(case, var('Posteriors')),
        disease_posterior(var('Diseases'), var('Posteriors'), var('Disease'), var('Posterior')))).
clause(77,
       expectedSuccess(var('Therapy'), var('Expectedsuccess')),
       (therapy(var('Therapy')), expected_success(var('Therapy'), var('Expectedsuccess')))).
clause(78,
       expectedAdverse(var('Therapy'), var('Adverse')),
       (therapy(var('Therapy')), adverse(var('Therapy'), var('Adverse')))).
clause(79,
       utility(var('Therapy'), var('Utility')),
       (therapy(var('Therapy')), therapy_utility(var('Therapy'), var('Utility')))).
clause(80,
       recommendedTherapy(case, var('Best')),
       (therapies(case, var('Therapies')), best_therapy(var('Therapies'), var('Best')))).

step(scores(case, [0.009282000000000002, 0.008208, 0.00012824999999999997, 0.00156408]),
     rule(73),
     ['Scores' = [0.009282000000000002, 0.008208, 0.00012824999999999997, 0.00156408],
      'Diseases' = [covid19, influenza, allergicRhinitis, bacterialPneumonia]],
     [diseases(case, [covid19, influenza, allergicRhinitis, bacterialPneumonia]),
      scores_for([covid19, influenza, allergicRhinitis, bacterialPneumonia], [0.009282000000000002, 0.008208, 0.00012824999999999997, 0.00156408])]).
step(diseases(case, [covid19, influenza, allergicRhinitis, bacterialPneumonia]),
     fact(8),
     [],
     []).
step(scores_for([covid19, influenza, allergicRhinitis, bacterialPneumonia], [0.009282000000000002, 0.008208, 0.00012824999999999997, 0.00156408]),
     rule(58),
     ['Disease' = covid19,
      'Restdiseases' = [influenza, allergicRhinitis, bacterialPneumonia],
      'Score' = 0.009282000000000002,
      'Restscores' = [0.008208, 0.00012824999999999997, 0.00156408]],
     [score(covid19, 0.009282000000000002),
      scores_for([influenza, allergicRhinitis, bacterialPneumonia], [0.008208, 0.00012824999999999997, 0.00156408])]).
step(score(covid19, 0.009282000000000002),
     rule(56),
     ['Disease' = covid19,
      'Score' = 0.009282000000000002,
      'Prior' = 0.05,
      'Evidence' = [ev(fever, true), ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)],
      'Likelihood' = 0.18564000000000003],
     [prior(covid19, 0.05),
      evidence(case, [ev(fever, true), ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)]),
      likelihood(covid19, [ev(fever, true), ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)], 0.18564000000000003),
      0.009282000000000002 is 0.05 * 0.18564000000000003]).
step(prior(covid19, 0.05), fact(11), [], []).
step(evidence(case, [ev(fever, true), ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)]),
     fact(10),
     [],
     []).
step(likelihood(covid19, [ev(fever, true), ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)], 0.18564000000000003),
     rule(55),
     ['Disease' = covid19,
      'Evidence' = ev(fever, true),
      'Rest' = [ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)],
      'Likelihood' = 0.18564000000000003,
      'Factor' = 0.7,
      'Taillikelihood' = 0.26520000000000005],
     [factor(covid19, ev(fever, true), 0.7),
      likelihood(covid19, [ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)], 0.26520000000000005),
      0.18564000000000003 is 0.7 * 0.26520000000000005]).
step(factor(covid19, ev(fever, true), 0.7),
     rule(52),
     ['Disease' = covid19, 'Symptom' = fever, 'P' = 0.7],
     [p_given(covid19, fever, 0.7)]).
step(p_given(covid19, fever, 0.7), fact(15), [], []).
step(likelihood(covid19, [ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)], 0.26520000000000005),
     rule(55),
     ['Disease' = covid19,
      'Evidence' = ev(dryCough, true),
      'Rest' = [ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)],
      'Likelihood' = 0.26520000000000005,
      'Factor' = 0.65,
      'Taillikelihood' = 0.40800000000000003],
     [factor(covid19, ev(dryCough, true), 0.65),
      likelihood(covid19, [ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)], 0.40800000000000003),
      0.26520000000000005 is 0.65 * 0.40800000000000003]).
step(factor(covid19, ev(dryCough, true), 0.65),
     rule(52),
     ['Disease' = covid19, 'Symptom' = dryCough, 'P' = 0.65],
     [p_given(covid19, dryCough, 0.65)]).
step(p_given(covid19, dryCough, 0.65), fact(16), [], []).
step(likelihood(covid19, [ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)], 0.40800000000000003),
     rule(55),
     ['Disease' = covid19,
      'Evidence' = ev(lossOfSmell, false),
      'Rest' = [ev(sneezing, false), ev(shortBreath, false)],
      'Likelihood' = 0.40800000000000003,
      'Factor' = 0.6,
      'Taillikelihood' = 0.68],
     [factor(covid19, ev(lossOfSmell, false), 0.6),
      likelihood(covid19, [ev(sneezing, false), ev(shortBreath, false)], 0.68),
      0.40800000000000003 is 0.6 * 0.68]).
step(factor(covid19, ev(lossOfSmell, false), 0.6),
     rule(53),
     ['Disease' = covid19, 'Symptom' = lossOfSmell, 'Q' = 0.6, 'P' = 0.4],
     [p_given(covid19, lossOfSmell, 0.4), 0.6 is 1.0 - 0.4]).
step(p_given(covid19, lossOfSmell, 0.4), fact(17), [], []).
step(0.6 is 1.0 - 0.4, builtin, [], []).
step(likelihood(covid19, [ev(sneezing, false), ev(shortBreath, false)], 0.68),
     rule(55),
     ['Disease' = covid19,
      'Evidence' = ev(sneezing, false),
      'Rest' = [ev(shortBreath, false)],
      'Likelihood' = 0.68,
      'Factor' = 0.85,
      'Taillikelihood' = 0.8],
     [factor(covid19, ev(sneezing, false), 0.85),
      likelihood(covid19, [ev(shortBreath, false)], 0.8),
      0.68 is 0.85 * 0.8]).
step(factor(covid19, ev(sneezing, false), 0.85),
     rule(53),
     ['Disease' = covid19, 'Symptom' = sneezing, 'Q' = 0.85, 'P' = 0.15],
     [p_given(covid19, sneezing, 0.15), 0.85 is 1.0 - 0.15]).
step(p_given(covid19, sneezing, 0.15), fact(18), [], []).
step(0.85 is 1.0 - 0.15, builtin, [], []).
step(likelihood(covid19, [ev(shortBreath, false)], 0.8),
     rule(55),
     ['Disease' = covid19,
      'Evidence' = ev(shortBreath, false),
      'Rest' = [],
      'Likelihood' = 0.8,
      'Factor' = 0.8,
      'Taillikelihood' = 1.0],
     [factor(covid19, ev(shortBreath, false), 0.8),
      likelihood(covid19, [], 1.0),
      0.8 is 0.8 * 1.0]).
step(factor(covid19, ev(shortBreath, false), 0.8),
     rule(53),
     ['Disease' = covid19, 'Symptom' = shortBreath, 'Q' = 0.8, 'P' = 0.2],
     [p_given(covid19, shortBreath, 0.2), 0.8 is 1.0 - 0.2]).
step(p_given(covid19, shortBreath, 0.2), fact(19), [], []).
step(0.8 is 1.0 - 0.2, builtin, [], []).
step(likelihood(covid19, [], 1.0), fact(54), [], []).
step(0.8 is 0.8 * 1.0, builtin, [], []).
step(0.68 is 0.85 * 0.8, builtin, [], []).
step(0.40800000000000003 is 0.6 * 0.68, builtin, [], []).
step(0.26520000000000005 is 0.65 * 0.40800000000000003, builtin, [], []).
step(0.18564000000000003 is 0.7 * 0.26520000000000005, builtin, [], []).
step(0.009282000000000002 is 0.05 * 0.18564000000000003, builtin, [], []).
step(scores_for([influenza, allergicRhinitis, bacterialPneumonia], [0.008208, 0.00012824999999999997, 0.00156408]),
     rule(58),
     ['Disease' = influenza,
      'Restdiseases' = [allergicRhinitis, bacterialPneumonia],
      'Score' = 0.008208,
      'Restscores' = [0.00012824999999999997, 0.00156408]],
     [score(influenza, 0.008208),
      scores_for([allergicRhinitis, bacterialPneumonia], [0.00012824999999999997, 0.00156408])]).
step(score(influenza, 0.008208),
     rule(56),
     ['Disease' = influenza,
      'Score' = 0.008208,
      'Prior' = 0.03,
      'Evidence' = [ev(fever, true), ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)],
      'Likelihood' = 0.2736],
     [prior(influenza, 0.03),
      evidence(case, [ev(fever, true), ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)]),
      likelihood(influenza, [ev(fever, true), ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)], 0.2736),
      0.008208 is 0.03 * 0.2736]).
step(prior(influenza, 0.03), fact(12), [], []).
step(likelihood(influenza, [ev(fever, true), ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)], 0.2736),
     rule(55),
     ['Disease' = influenza,
      'Evidence' = ev(fever, true),
      'Rest' = [ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)],
      'Likelihood' = 0.2736,
      'Factor' = 0.8,
      'Taillikelihood' = 0.342],
     [factor(influenza, ev(fever, true), 0.8),
      likelihood(influenza, [ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)], 0.342),
      0.2736 is 0.8 * 0.342]).
step(factor(influenza, ev(fever, true), 0.8),
     rule(52),
     ['Disease' = influenza, 'Symptom' = fever, 'P' = 0.8],
     [p_given(influenza, fever, 0.8)]).
step(p_given(influenza, fever, 0.8), fact(20), [], []).
step(likelihood(influenza, [ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)], 0.342),
     rule(55),
     ['Disease' = influenza,
      'Evidence' = ev(dryCough, true),
      'Rest' = [ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)],
      'Likelihood' = 0.342,
      'Factor' = 0.5,
      'Taillikelihood' = 0.684],
     [factor(influenza, ev(dryCough, true), 0.5),
      likelihood(influenza, [ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)], 0.684),
      0.342 is 0.5 * 0.684]).
step(factor(influenza, ev(dryCough, true), 0.5),
     rule(52),
     ['Disease' = influenza, 'Symptom' = dryCough, 'P' = 0.5],
     [p_given(influenza, dryCough, 0.5)]).
step(p_given(influenza, dryCough, 0.5), fact(21), [], []).
step(likelihood(influenza, [ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)], 0.684),
     rule(55),
     ['Disease' = influenza,
      'Evidence' = ev(lossOfSmell, false),
      'Rest' = [ev(sneezing, false), ev(shortBreath, false)],
      'Likelihood' = 0.684,
      'Factor' = 0.95,
      'Taillikelihood' = 0.7200000000000001],
     [factor(influenza, ev(lossOfSmell, false), 0.95),
      likelihood(influenza, [ev(sneezing, false), ev(shortBreath, false)], 0.7200000000000001),
      0.684 is 0.95 * 0.7200000000000001]).
step(factor(influenza, ev(lossOfSmell, false), 0.95),
     rule(53),
     ['Disease' = influenza, 'Symptom' = lossOfSmell, 'Q' = 0.95, 'P' = 0.05],
     [p_given(influenza, lossOfSmell, 0.05), 0.95 is 1.0 - 0.05]).
step(p_given(influenza, lossOfSmell, 0.05), fact(22), [], []).
step(0.95 is 1.0 - 0.05, builtin, [], []).
step(likelihood(influenza, [ev(sneezing, false), ev(shortBreath, false)], 0.7200000000000001),
     rule(55),
     ['Disease' = influenza,
      'Evidence' = ev(sneezing, false),
      'Rest' = [ev(shortBreath, false)],
      'Likelihood' = 0.7200000000000001,
      'Factor' = 0.8,
      'Taillikelihood' = 0.9],
     [factor(influenza, ev(sneezing, false), 0.8),
      likelihood(influenza, [ev(shortBreath, false)], 0.9),
      0.7200000000000001 is 0.8 * 0.9]).
step(factor(influenza, ev(sneezing, false), 0.8),
     rule(53),
     ['Disease' = influenza, 'Symptom' = sneezing, 'Q' = 0.8, 'P' = 0.2],
     [p_given(influenza, sneezing, 0.2), 0.8 is 1.0 - 0.2]).
step(p_given(influenza, sneezing, 0.2), fact(23), [], []).
step(likelihood(influenza, [ev(shortBreath, false)], 0.9),
     rule(55),
     ['Disease' = influenza,
      'Evidence' = ev(shortBreath, false),
      'Rest' = [],
      'Likelihood' = 0.9,
      'Factor' = 0.9,
      'Taillikelihood' = 1.0],
     [factor(influenza, ev(shortBreath, false), 0.9),
      likelihood(influenza, [], 1.0),
      0.9 is 0.9 * 1.0]).
step(factor(influenza, ev(shortBreath, false), 0.9),
     rule(53),
     ['Disease' = influenza, 'Symptom' = shortBreath, 'Q' = 0.9, 'P' = 0.1],
     [p_given(influenza, shortBreath, 0.1), 0.9 is 1.0 - 0.1]).
step(p_given(influenza, shortBreath, 0.1), fact(24), [], []).
step(0.9 is 1.0 - 0.1, builtin, [], []).
step(likelihood(influenza, [], 1.0), fact(54), [], []).
step(0.9 is 0.9 * 1.0, builtin, [], []).
step(0.7200000000000001 is 0.8 * 0.9, builtin, [], []).
step(0.684 is 0.95 * 0.7200000000000001, builtin, [], []).
step(0.342 is 0.5 * 0.684, builtin, [], []).
step(0.2736 is 0.8 * 0.342, builtin, [], []).
step(0.008208 is 0.03 * 0.2736, builtin, [], []).
step(scores_for([allergicRhinitis, bacterialPneumonia], [0.00012824999999999997, 0.00156408]),
     rule(58),
     ['Disease' = allergicRhinitis,
      'Restdiseases' = [bacterialPneumonia],
      'Score' = 0.00012824999999999997,
      'Restscores' = [0.00156408]],
     [score(allergicRhinitis, 0.00012824999999999997),
      scores_for([bacterialPneumonia], [0.00156408])]).
step(score(allergicRhinitis, 0.00012824999999999997),
     rule(56),
     ['Disease' = allergicRhinitis,
      'Score' = 0.00012824999999999997,
      'Prior' = 0.1,
      'Evidence' = [ev(fever, true), ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)],
      'Likelihood' = 0.0012824999999999998],
     [prior(allergicRhinitis, 0.1),
      evidence(case, [ev(fever, true), ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)]),
      likelihood(allergicRhinitis, [ev(fever, true), ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)], 0.0012824999999999998),
      0.00012824999999999997 is 0.1 * 0.0012824999999999998]).
step(prior(allergicRhinitis, 0.1), fact(13), [], []).
step(likelihood(allergicRhinitis, [ev(fever, true), ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)], 0.0012824999999999998),
     rule(55),
     ['Disease' = allergicRhinitis,
      'Evidence' = ev(fever, true),
      'Rest' = [ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)],
      'Likelihood' = 0.0012824999999999998,
      'Factor' = 0.05,
      'Taillikelihood' = 0.025649999999999992],
     [factor(allergicRhinitis, ev(fever, true), 0.05),
      likelihood(allergicRhinitis, [ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)], 0.025649999999999992),
      0.0012824999999999998 is 0.05 * 0.025649999999999992]).
step(factor(allergicRhinitis, ev(fever, true), 0.05),
     rule(52),
     ['Disease' = allergicRhinitis, 'Symptom' = fever, 'P' = 0.05],
     [p_given(allergicRhinitis, fever, 0.05)]).
step(p_given(allergicRhinitis, fever, 0.05), fact(25), [], []).
step(likelihood(allergicRhinitis, [ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)], 0.025649999999999992),
     rule(55),
     ['Disease' = allergicRhinitis,
      'Evidence' = ev(dryCough, true),
      'Rest' = [ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)],
      'Likelihood' = 0.025649999999999992,
      'Factor' = 0.15,
      'Taillikelihood' = 0.17099999999999996],
     [factor(allergicRhinitis, ev(dryCough, true), 0.15),
      likelihood(allergicRhinitis, [ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)], 0.17099999999999996),
      0.025649999999999992 is 0.15 * 0.17099999999999996]).
step(factor(allergicRhinitis, ev(dryCough, true), 0.15),
     rule(52),
     ['Disease' = allergicRhinitis, 'Symptom' = dryCough, 'P' = 0.15],
     [p_given(allergicRhinitis, dryCough, 0.15)]).
step(p_given(allergicRhinitis, dryCough, 0.15), fact(26), [], []).
step(likelihood(allergicRhinitis, [ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)], 0.17099999999999996),
     rule(55),
     ['Disease' = allergicRhinitis,
      'Evidence' = ev(lossOfSmell, false),
      'Rest' = [ev(sneezing, false), ev(shortBreath, false)],
      'Likelihood' = 0.17099999999999996,
      'Factor' = 0.9,
      'Taillikelihood' = 0.18999999999999995],
     [factor(allergicRhinitis, ev(lossOfSmell, false), 0.9),
      likelihood(allergicRhinitis, [ev(sneezing, false), ev(shortBreath, false)], 0.18999999999999995),
      0.17099999999999996 is 0.9 * 0.18999999999999995]).
step(factor(allergicRhinitis, ev(lossOfSmell, false), 0.9),
     rule(53),
     ['Disease' = allergicRhinitis, 'Symptom' = lossOfSmell, 'Q' = 0.9, 'P' = 0.1],
     [p_given(allergicRhinitis, lossOfSmell, 0.1), 0.9 is 1.0 - 0.1]).
step(p_given(allergicRhinitis, lossOfSmell, 0.1), fact(27), [], []).
step(likelihood(allergicRhinitis, [ev(sneezing, false), ev(shortBreath, false)], 0.18999999999999995),
     rule(55),
     ['Disease' = allergicRhinitis,
      'Evidence' = ev(sneezing, false),
      'Rest' = [ev(shortBreath, false)],
      'Likelihood' = 0.18999999999999995,
      'Factor' = 0.19999999999999996,
      'Taillikelihood' = 0.95],
     [factor(allergicRhinitis, ev(sneezing, false), 0.19999999999999996),
      likelihood(allergicRhinitis, [ev(shortBreath, false)], 0.95),
      0.18999999999999995 is 0.19999999999999996 * 0.95]).
step(factor(allergicRhinitis, ev(sneezing, false), 0.19999999999999996),
     rule(53),
     ['Disease' = allergicRhinitis, 'Symptom' = sneezing, 'Q' = 0.19999999999999996, 'P' = 0.8],
     [p_given(allergicRhinitis, sneezing, 0.8), 0.19999999999999996 is 1.0 - 0.8]).
step(p_given(allergicRhinitis, sneezing, 0.8), fact(28), [], []).
step(0.19999999999999996 is 1.0 - 0.8, builtin, [], []).
step(likelihood(allergicRhinitis, [ev(shortBreath, false)], 0.95),
     rule(55),
     ['Disease' = allergicRhinitis,
      'Evidence' = ev(shortBreath, false),
      'Rest' = [],
      'Likelihood' = 0.95,
      'Factor' = 0.95,
      'Taillikelihood' = 1.0],
     [factor(allergicRhinitis, ev(shortBreath, false), 0.95),
      likelihood(allergicRhinitis, [], 1.0),
      0.95 is 0.95 * 1.0]).
step(factor(allergicRhinitis, ev(shortBreath, false), 0.95),
     rule(53),
     ['Disease' = allergicRhinitis, 'Symptom' = shortBreath, 'Q' = 0.95, 'P' = 0.05],
     [p_given(allergicRhinitis, shortBreath, 0.05), 0.95 is 1.0 - 0.05]).
step(p_given(allergicRhinitis, shortBreath, 0.05), fact(29), [], []).
step(likelihood(allergicRhinitis, [], 1.0), fact(54), [], []).
step(0.95 is 0.95 * 1.0, builtin, [], []).
step(0.18999999999999995 is 0.19999999999999996 * 0.95, builtin, [], []).
step(0.17099999999999996 is 0.9 * 0.18999999999999995, builtin, [], []).
step(0.025649999999999992 is 0.15 * 0.17099999999999996, builtin, [], []).
step(0.0012824999999999998 is 0.05 * 0.025649999999999992, builtin, [], []).
step(0.00012824999999999997 is 0.1 * 0.0012824999999999998, builtin, [], []).
step(scores_for([bacterialPneumonia], [0.00156408]),
     rule(58),
     ['Disease' = bacterialPneumonia,
      'Restdiseases' = [],
      'Score' = 0.00156408,
      'Restscores' = []],
     [score(bacterialPneumonia, 0.00156408), scores_for([], [])]).
step(score(bacterialPneumonia, 0.00156408),
     rule(56),
     ['Disease' = bacterialPneumonia,
      'Score' = 0.00156408,
      'Prior' = 0.01,
      'Evidence' = [ev(fever, true), ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)],
      'Likelihood' = 0.156408],
     [prior(bacterialPneumonia, 0.01),
      evidence(case, [ev(fever, true), ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)]),
      likelihood(bacterialPneumonia, [ev(fever, true), ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)], 0.156408),
      0.00156408 is 0.01 * 0.156408]).
step(prior(bacterialPneumonia, 0.01), fact(14), [], []).
step(likelihood(bacterialPneumonia, [ev(fever, true), ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)], 0.156408),
     rule(55),
     ['Disease' = bacterialPneumonia,
      'Evidence' = ev(fever, true),
      'Rest' = [ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)],
      'Likelihood' = 0.156408,
      'Factor' = 0.7,
      'Taillikelihood' = 0.22344],
     [factor(bacterialPneumonia, ev(fever, true), 0.7),
      likelihood(bacterialPneumonia, [ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)], 0.22344),
      0.156408 is 0.7 * 0.22344]).
step(factor(bacterialPneumonia, ev(fever, true), 0.7),
     rule(52),
     ['Disease' = bacterialPneumonia, 'Symptom' = fever, 'P' = 0.7],
     [p_given(bacterialPneumonia, fever, 0.7)]).
step(p_given(bacterialPneumonia, fever, 0.7), fact(30), [], []).
step(likelihood(bacterialPneumonia, [ev(dryCough, true), ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)], 0.22344),
     rule(55),
     ['Disease' = bacterialPneumonia,
      'Evidence' = ev(dryCough, true),
      'Rest' = [ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)],
      'Likelihood' = 0.22344,
      'Factor' = 0.6,
      'Taillikelihood' = 0.3724],
     [factor(bacterialPneumonia, ev(dryCough, true), 0.6),
      likelihood(bacterialPneumonia, [ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)], 0.3724),
      0.22344 is 0.6 * 0.3724]).
step(factor(bacterialPneumonia, ev(dryCough, true), 0.6),
     rule(52),
     ['Disease' = bacterialPneumonia, 'Symptom' = dryCough, 'P' = 0.6],
     [p_given(bacterialPneumonia, dryCough, 0.6)]).
step(p_given(bacterialPneumonia, dryCough, 0.6), fact(31), [], []).
step(likelihood(bacterialPneumonia, [ev(lossOfSmell, false), ev(sneezing, false), ev(shortBreath, false)], 0.3724),
     rule(55),
     ['Disease' = bacterialPneumonia,
      'Evidence' = ev(lossOfSmell, false),
      'Rest' = [ev(sneezing, false), ev(shortBreath, false)],
      'Likelihood' = 0.3724,
      'Factor' = 0.98,
      'Taillikelihood' = 0.38],
     [factor(bacterialPneumonia, ev(lossOfSmell, false), 0.98),
      likelihood(bacterialPneumonia, [ev(sneezing, false), ev(shortBreath, false)], 0.38),
      0.3724 is 0.98 * 0.38]).
step(factor(bacterialPneumonia, ev(lossOfSmell, false), 0.98),
     rule(53),
     ['Disease' = bacterialPneumonia, 'Symptom' = lossOfSmell, 'Q' = 0.98, 'P' = 0.02],
     [p_given(bacterialPneumonia, lossOfSmell, 0.02), 0.98 is 1.0 - 0.02]).
step(p_given(bacterialPneumonia, lossOfSmell, 0.02), fact(32), [], []).
step(0.98 is 1.0 - 0.02, builtin, [], []).
step(likelihood(bacterialPneumonia, [ev(sneezing, false), ev(shortBreath, false)], 0.38),
     rule(55),
     ['Disease' = bacterialPneumonia,
      'Evidence' = ev(sneezing, false),
      'Rest' = [ev(shortBreath, false)],
      'Likelihood' = 0.38,
      'Factor' = 0.95,
      'Taillikelihood' = 0.4],
     [factor(bacterialPneumonia, ev(sneezing, false), 0.95),
      likelihood(bacterialPneumonia, [ev(shortBreath, false)], 0.4),
      0.38 is 0.95 * 0.4]).
step(factor(bacterialPneumonia, ev(sneezing, false), 0.95),
     rule(53),
     ['Disease' = bacterialPneumonia, 'Symptom' = sneezing, 'Q' = 0.95, 'P' = 0.05],
     [p_given(bacterialPneumonia, sneezing, 0.05), 0.95 is 1.0 - 0.05]).
step(p_given(bacterialPneumonia, sneezing, 0.05), fact(33), [], []).
step(likelihood(bacterialPneumonia, [ev(shortBreath, false)], 0.4),
     rule(55),
     ['Disease' = bacterialPneumonia,
      'Evidence' = ev(shortBreath, false),
      'Rest' = [],
      'Likelihood' = 0.4,
      'Factor' = 0.4,
      'Taillikelihood' = 1.0],
     [factor(bacterialPneumonia, ev(shortBreath, false), 0.4),
      likelihood(bacterialPneumonia, [], 1.0),
      0.4 is 0.4 * 1.0]).
step(factor(bacterialPneumonia, ev(shortBreath, false), 0.4),
     rule(53),
     ['Disease' = bacterialPneumonia, 'Symptom' = shortBreath, 'Q' = 0.4, 'P' = 0.6],
     [p_given(bacterialPneumonia, shortBreath, 0.6), 0.4 is 1.0 - 0.6]).
step(p_given(bacterialPneumonia, shortBreath, 0.6), fact(34), [], []).
step(0.4 is 1.0 - 0.6, builtin, [], []).
step(likelihood(bacterialPneumonia, [], 1.0), fact(54), [], []).
step(0.4 is 0.4 * 1.0, builtin, [], []).
step(0.38 is 0.95 * 0.4, builtin, [], []).
step(0.3724 is 0.98 * 0.38, builtin, [], []).
step(0.22344 is 0.6 * 0.3724, builtin, [], []).
step(0.156408 is 0.7 * 0.22344, builtin, [], []).
step(0.00156408 is 0.01 * 0.156408, builtin, [], []).
step(scores_for([], []), fact(57), [], []).
step(evidenceTotal(case, 0.019182330000000004),
     rule(74),
     ['Total' = 0.019182330000000004,
      'Scores' = [0.009282000000000002, 0.008208, 0.00012824999999999997, 0.00156408]],
     [scores(case, [0.009282000000000002, 0.008208, 0.00012824999999999997, 0.00156408]),
      score_sum([0.009282000000000002, 0.008208, 0.00012824999999999997, 0.00156408], 0.019182330000000004)]).
step(score_sum([0.009282000000000002, 0.008208, 0.00012824999999999997, 0.00156408], 0.019182330000000004),
     rule(60),
     ['Value' = 0.009282000000000002,
      'Rest' = [0.008208, 0.00012824999999999997, 0.00156408],
      'Sum' = 0.019182330000000004,
      'Tailsum' = 0.00990033],
     [score_sum([0.008208, 0.00012824999999999997, 0.00156408], 0.00990033),
      0.019182330000000004 is 0.009282000000000002 + 0.00990033]).
step(score_sum([0.008208, 0.00012824999999999997, 0.00156408], 0.00990033),
     rule(60),
     ['Value' = 0.008208,
      'Rest' = [0.00012824999999999997, 0.00156408],
      'Sum' = 0.00990033,
      'Tailsum' = 0.00169233],
     [score_sum([0.00012824999999999997, 0.00156408], 0.00169233),
      0.00990033 is 0.008208 + 0.00169233]).
step(score_sum([0.00012824999999999997, 0.00156408], 0.00169233),
     rule(60),
     ['Value' = 0.00012824999999999997,
      'Rest' = [0.00156408],
      'Sum' = 0.00169233,
      'Tailsum' = 0.00156408],
     [score_sum([0.00156408], 0.00156408), 0.00169233 is 0.00012824999999999997 + 0.00156408]).
step(score_sum([0.00156408], 0.00156408),
     rule(60),
     ['Value' = 0.00156408, 'Rest' = [], 'Sum' = 0.00156408, 'Tailsum' = 0.0],
     [score_sum([], 0.0), 0.00156408 is 0.00156408 + 0.0]).
step(score_sum([], 0.0), fact(59), [], []).
step(0.00156408 is 0.00156408 + 0.0, builtin, [], []).
step(0.00169233 is 0.00012824999999999997 + 0.00156408, builtin, [], []).
step(0.00990033 is 0.008208 + 0.00169233, builtin, [], []).
step(0.019182330000000004 is 0.009282000000000002 + 0.00990033, builtin, [], []).
step(posteriors(case, [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716]),
     rule(75),
     ['Posteriors' = [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716],
      'Scores' = [0.009282000000000002, 0.008208, 0.00012824999999999997, 0.00156408],
      'Total' = 0.019182330000000004],
     [scores(case, [0.009282000000000002, 0.008208, 0.00012824999999999997, 0.00156408]),
      evidenceTotal(case, 0.019182330000000004),
      normalize_scores([0.009282000000000002, 0.008208, 0.00012824999999999997, 0.00156408], 0.019182330000000004, [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716])]).
step(normalize_scores([0.009282000000000002, 0.008208, 0.00012824999999999997, 0.00156408], 0.019182330000000004, [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716]),
     rule(62),
     ['Score' = 0.009282000000000002,
      'Restscores' = [0.008208, 0.00012824999999999997, 0.00156408],
      'Total' = 0.019182330000000004,
      'Posterior' = 0.48388282341092037,
      'Restposteriors' = [0.42789379600913957, 0.006685840562642804, 0.08153754001729716]],
     [0.48388282341092037 is 0.009282000000000002 / 0.019182330000000004,
      normalize_scores([0.008208, 0.00012824999999999997, 0.00156408], 0.019182330000000004, [0.42789379600913957, 0.006685840562642804, 0.08153754001729716])]).
step(0.48388282341092037 is 0.009282000000000002 / 0.019182330000000004, builtin, [], []).
step(normalize_scores([0.008208, 0.00012824999999999997, 0.00156408], 0.019182330000000004, [0.42789379600913957, 0.006685840562642804, 0.08153754001729716]),
     rule(62),
     ['Score' = 0.008208,
      'Restscores' = [0.00012824999999999997, 0.00156408],
      'Total' = 0.019182330000000004,
      'Posterior' = 0.42789379600913957,
      'Restposteriors' = [0.006685840562642804, 0.08153754001729716]],
     [0.42789379600913957 is 0.008208 / 0.019182330000000004,
      normalize_scores([0.00012824999999999997, 0.00156408], 0.019182330000000004, [0.006685840562642804, 0.08153754001729716])]).
step(0.42789379600913957 is 0.008208 / 0.019182330000000004, builtin, [], []).
step(normalize_scores([0.00012824999999999997, 0.00156408], 0.019182330000000004, [0.006685840562642804, 0.08153754001729716]),
     rule(62),
     ['Score' = 0.00012824999999999997,
      'Restscores' = [0.00156408],
      'Total' = 0.019182330000000004,
      'Posterior' = 0.006685840562642804,
      'Restposteriors' = [0.08153754001729716]],
     [0.006685840562642804 is 0.00012824999999999997 / 0.019182330000000004,
      normalize_scores([0.00156408], 0.019182330000000004, [0.08153754001729716])]).
step(0.006685840562642804 is 0.00012824999999999997 / 0.019182330000000004, builtin, [], []).
step(normalize_scores([0.00156408], 0.019182330000000004, [0.08153754001729716]),
     rule(62),
     ['Score' = 0.00156408,
      'Restscores' = [],
      'Total' = 0.019182330000000004,
      'Posterior' = 0.08153754001729716,
      'Restposteriors' = []],
     [0.08153754001729716 is 0.00156408 / 0.019182330000000004,
      normalize_scores([], 0.019182330000000004, [])]).
step(0.08153754001729716 is 0.00156408 / 0.019182330000000004, builtin, [], []).
step(normalize_scores([], 0.019182330000000004, []), fact(61), [], []).
step(posterior(covid19, 0.48388282341092037),
     rule(76),
     ['Disease' = covid19,
      'Posterior' = 0.48388282341092037,
      'Diseases' = [covid19, influenza, allergicRhinitis, bacterialPneumonia],
      'Posteriors' = [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716]],
     [diseases(case, [covid19, influenza, allergicRhinitis, bacterialPneumonia]),
      posteriors(case, [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716]),
      disease_posterior([covid19, influenza, allergicRhinitis, bacterialPneumonia], [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716], covid19, 0.48388282341092037)]).
step(disease_posterior([covid19, influenza, allergicRhinitis, bacterialPneumonia], [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716], covid19, 0.48388282341092037),
     fact(63),
     ['Disease' = covid19, 'Posterior' = 0.48388282341092037],
     []).
step(posterior(influenza, 0.42789379600913957),
     rule(76),
     ['Disease' = influenza,
      'Posterior' = 0.42789379600913957,
      'Diseases' = [covid19, influenza, allergicRhinitis, bacterialPneumonia],
      'Posteriors' = [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716]],
     [diseases(case, [covid19, influenza, allergicRhinitis, bacterialPneumonia]),
      posteriors(case, [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716]),
      disease_posterior([covid19, influenza, allergicRhinitis, bacterialPneumonia], [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716], influenza, 0.42789379600913957)]).
step(disease_posterior([covid19, influenza, allergicRhinitis, bacterialPneumonia], [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716], influenza, 0.42789379600913957),
     rule(64),
     ['Restdiseases' = [influenza, allergicRhinitis, bacterialPneumonia],
      'Restposteriors' = [0.42789379600913957, 0.006685840562642804, 0.08153754001729716],
      'Disease' = influenza,
      'Posterior' = 0.42789379600913957],
     [disease_posterior([influenza, allergicRhinitis, bacterialPneumonia], [0.42789379600913957, 0.006685840562642804, 0.08153754001729716], influenza, 0.42789379600913957)]).
step(disease_posterior([influenza, allergicRhinitis, bacterialPneumonia], [0.42789379600913957, 0.006685840562642804, 0.08153754001729716], influenza, 0.42789379600913957),
     fact(63),
     ['Disease' = influenza, 'Posterior' = 0.42789379600913957],
     []).
step(posterior(allergicRhinitis, 0.006685840562642804),
     rule(76),
     ['Disease' = allergicRhinitis,
      'Posterior' = 0.006685840562642804,
      'Diseases' = [covid19, influenza, allergicRhinitis, bacterialPneumonia],
      'Posteriors' = [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716]],
     [diseases(case, [covid19, influenza, allergicRhinitis, bacterialPneumonia]),
      posteriors(case, [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716]),
      disease_posterior([covid19, influenza, allergicRhinitis, bacterialPneumonia], [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716], allergicRhinitis, 0.006685840562642804)]).
step(disease_posterior([covid19, influenza, allergicRhinitis, bacterialPneumonia], [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716], allergicRhinitis, 0.006685840562642804),
     rule(64),
     ['Restdiseases' = [influenza, allergicRhinitis, bacterialPneumonia],
      'Restposteriors' = [0.42789379600913957, 0.006685840562642804, 0.08153754001729716],
      'Disease' = allergicRhinitis,
      'Posterior' = 0.006685840562642804],
     [disease_posterior([influenza, allergicRhinitis, bacterialPneumonia], [0.42789379600913957, 0.006685840562642804, 0.08153754001729716], allergicRhinitis, 0.006685840562642804)]).
step(disease_posterior([influenza, allergicRhinitis, bacterialPneumonia], [0.42789379600913957, 0.006685840562642804, 0.08153754001729716], allergicRhinitis, 0.006685840562642804),
     rule(64),
     ['Restdiseases' = [allergicRhinitis, bacterialPneumonia],
      'Restposteriors' = [0.006685840562642804, 0.08153754001729716],
      'Disease' = allergicRhinitis,
      'Posterior' = 0.006685840562642804],
     [disease_posterior([allergicRhinitis, bacterialPneumonia], [0.006685840562642804, 0.08153754001729716], allergicRhinitis, 0.006685840562642804)]).
step(disease_posterior([allergicRhinitis, bacterialPneumonia], [0.006685840562642804, 0.08153754001729716], allergicRhinitis, 0.006685840562642804),
     fact(63),
     ['Disease' = allergicRhinitis, 'Posterior' = 0.006685840562642804],
     []).
step(posterior(bacterialPneumonia, 0.08153754001729716),
     rule(76),
     ['Disease' = bacterialPneumonia,
      'Posterior' = 0.08153754001729716,
      'Diseases' = [covid19, influenza, allergicRhinitis, bacterialPneumonia],
      'Posteriors' = [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716]],
     [diseases(case, [covid19, influenza, allergicRhinitis, bacterialPneumonia]),
      posteriors(case, [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716]),
      disease_posterior([covid19, influenza, allergicRhinitis, bacterialPneumonia], [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716], bacterialPneumonia, 0.08153754001729716)]).
step(disease_posterior([covid19, influenza, allergicRhinitis, bacterialPneumonia], [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716], bacterialPneumonia, 0.08153754001729716),
     rule(64),
     ['Restdiseases' = [influenza, allergicRhinitis, bacterialPneumonia],
      'Restposteriors' = [0.42789379600913957, 0.006685840562642804, 0.08153754001729716],
      'Disease' = bacterialPneumonia,
      'Posterior' = 0.08153754001729716],
     [disease_posterior([influenza, allergicRhinitis, bacterialPneumonia], [0.42789379600913957, 0.006685840562642804, 0.08153754001729716], bacterialPneumonia, 0.08153754001729716)]).
step(disease_posterior([influenza, allergicRhinitis, bacterialPneumonia], [0.42789379600913957, 0.006685840562642804, 0.08153754001729716], bacterialPneumonia, 0.08153754001729716),
     rule(64),
     ['Restdiseases' = [allergicRhinitis, bacterialPneumonia],
      'Restposteriors' = [0.006685840562642804, 0.08153754001729716],
      'Disease' = bacterialPneumonia,
      'Posterior' = 0.08153754001729716],
     [disease_posterior([allergicRhinitis, bacterialPneumonia], [0.006685840562642804, 0.08153754001729716], bacterialPneumonia, 0.08153754001729716)]).
step(disease_posterior([allergicRhinitis, bacterialPneumonia], [0.006685840562642804, 0.08153754001729716], bacterialPneumonia, 0.08153754001729716),
     rule(64),
     ['Restdiseases' = [bacterialPneumonia],
      'Restposteriors' = [0.08153754001729716],
      'Disease' = bacterialPneumonia,
      'Posterior' = 0.08153754001729716],
     [disease_posterior([bacterialPneumonia], [0.08153754001729716], bacterialPneumonia, 0.08153754001729716)]).
step(disease_posterior([bacterialPneumonia], [0.08153754001729716], bacterialPneumonia, 0.08153754001729716),
     fact(63),
     ['Disease' = bacterialPneumonia, 'Posterior' = 0.08153754001729716],
     []).
step(expectedSuccess(paxlovid, 0.388517401170765),
     rule(77),
     ['Therapy' = paxlovid, 'Expectedsuccess' = 0.388517401170765],
     [therapy(paxlovid), expected_success(paxlovid, 0.388517401170765)]).
step(therapy(paxlovid), fact(35), [], []).
step(expected_success(paxlovid, 0.388517401170765),
     rule(67),
     ['Therapy' = paxlovid,
      'Expectedsuccess' = 0.388517401170765,
      'Posteriors' = [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716],
      'Successbydisease' = [0.75, 0.05, 0.02, 0.05]],
     [posteriors(case, [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716]),
      success_by_disease(paxlovid, [0.75, 0.05, 0.02, 0.05]),
      dot_product([0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716], [0.75, 0.05, 0.02, 0.05], 0.388517401170765)]).
step(success_by_disease(paxlovid, [0.75, 0.05, 0.02, 0.05]), fact(40), [], []).
step(dot_product([0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716], [0.75, 0.05, 0.02, 0.05], 0.388517401170765),
     rule(66),
     ['Left' = 0.48388282341092037,
      'Restleft' = [0.42789379600913957, 0.006685840562642804, 0.08153754001729716],
      'Right' = 0.75,
      'Restright' = [0.05, 0.02, 0.05],
      'Sum' = 0.388517401170765,
      'Term' = 0.3629121175581903,
      'Tailsum' = 0.025605283612574695],
     [0.3629121175581903 is 0.48388282341092037 * 0.75,
      dot_product([0.42789379600913957, 0.006685840562642804, 0.08153754001729716], [0.05, 0.02, 0.05], 0.025605283612574695),
      0.388517401170765 is 0.3629121175581903 + 0.025605283612574695]).
step(0.3629121175581903 is 0.48388282341092037 * 0.75, builtin, [], []).
step(dot_product([0.42789379600913957, 0.006685840562642804, 0.08153754001729716], [0.05, 0.02, 0.05], 0.025605283612574695),
     rule(66),
     ['Left' = 0.42789379600913957,
      'Restleft' = [0.006685840562642804, 0.08153754001729716],
      'Right' = 0.05,
      'Restright' = [0.02, 0.05],
      'Sum' = 0.025605283612574695,
      'Term' = 0.02139468980045698,
      'Tailsum' = 0.0042105938121177145],
     [0.02139468980045698 is 0.42789379600913957 * 0.05,
      dot_product([0.006685840562642804, 0.08153754001729716], [0.02, 0.05], 0.0042105938121177145),
      0.025605283612574695 is 0.02139468980045698 + 0.0042105938121177145]).
step(0.02139468980045698 is 0.42789379600913957 * 0.05, builtin, [], []).
step(dot_product([0.006685840562642804, 0.08153754001729716], [0.02, 0.05], 0.0042105938121177145),
     rule(66),
     ['Left' = 0.006685840562642804,
      'Restleft' = [0.08153754001729716],
      'Right' = 0.02,
      'Restright' = [0.05],
      'Sum' = 0.0042105938121177145,
      'Term' = 0.00013371681125285608,
      'Tailsum' = 0.004076877000864858],
     [0.00013371681125285608 is 0.006685840562642804 * 0.02,
      dot_product([0.08153754001729716], [0.05], 0.004076877000864858),
      0.0042105938121177145 is 0.00013371681125285608 + 0.004076877000864858]).
step(0.00013371681125285608 is 0.006685840562642804 * 0.02, builtin, [], []).
step(dot_product([0.08153754001729716], [0.05], 0.004076877000864858),
     rule(66),
     ['Left' = 0.08153754001729716,
      'Restleft' = [],
      'Right' = 0.05,
      'Restright' = [],
      'Sum' = 0.004076877000864858,
      'Term' = 0.004076877000864858,
      'Tailsum' = 0.0],
     [0.004076877000864858 is 0.08153754001729716 * 0.05,
      dot_product([], [], 0.0),
      0.004076877000864858 is 0.004076877000864858 + 0.0]).
step(0.004076877000864858 is 0.08153754001729716 * 0.05, builtin, [], []).
step(dot_product([], [], 0.0), fact(65), [], []).
step(0.004076877000864858 is 0.004076877000864858 + 0.0, builtin, [], []).
step(0.0042105938121177145 is 0.00013371681125285608 + 0.004076877000864858, builtin, [], []).
step(0.025605283612574695 is 0.02139468980045698 + 0.0042105938121177145, builtin, [], []).
step(0.388517401170765 is 0.3629121175581903 + 0.025605283612574695, builtin, [], []).
step(expectedSuccess(oseltamivir, 0.28514101258814745),
     rule(77),
     ['Therapy' = oseltamivir, 'Expectedsuccess' = 0.28514101258814745],
     [therapy(oseltamivir), expected_success(oseltamivir, 0.28514101258814745)]).
step(therapy(oseltamivir), fact(36), [], []).
step(expected_success(oseltamivir, 0.28514101258814745),
     rule(67),
     ['Therapy' = oseltamivir,
      'Expectedsuccess' = 0.28514101258814745,
      'Posteriors' = [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716],
      'Successbydisease' = [0.05, 0.6, 0.02, 0.05]],
     [posteriors(case, [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716]),
      success_by_disease(oseltamivir, [0.05, 0.6, 0.02, 0.05]),
      dot_product([0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716], [0.05, 0.6, 0.02, 0.05], 0.28514101258814745)]).
step(success_by_disease(oseltamivir, [0.05, 0.6, 0.02, 0.05]), fact(41), [], []).
step(dot_product([0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716], [0.05, 0.6, 0.02, 0.05], 0.28514101258814745),
     rule(66),
     ['Left' = 0.48388282341092037,
      'Restleft' = [0.42789379600913957, 0.006685840562642804, 0.08153754001729716],
      'Right' = 0.05,
      'Restright' = [0.6, 0.02, 0.05],
      'Sum' = 0.28514101258814745,
      'Term' = 0.02419414117054602,
      'Tailsum' = 0.2609468714176014],
     [0.02419414117054602 is 0.48388282341092037 * 0.05,
      dot_product([0.42789379600913957, 0.006685840562642804, 0.08153754001729716], [0.6, 0.02, 0.05], 0.2609468714176014),
      0.28514101258814745 is 0.02419414117054602 + 0.2609468714176014]).
step(0.02419414117054602 is 0.48388282341092037 * 0.05, builtin, [], []).
step(dot_product([0.42789379600913957, 0.006685840562642804, 0.08153754001729716], [0.6, 0.02, 0.05], 0.2609468714176014),
     rule(66),
     ['Left' = 0.42789379600913957,
      'Restleft' = [0.006685840562642804, 0.08153754001729716],
      'Right' = 0.6,
      'Restright' = [0.02, 0.05],
      'Sum' = 0.2609468714176014,
      'Term' = 0.25673627760548373,
      'Tailsum' = 0.0042105938121177145],
     [0.25673627760548373 is 0.42789379600913957 * 0.6,
      dot_product([0.006685840562642804, 0.08153754001729716], [0.02, 0.05], 0.0042105938121177145),
      0.2609468714176014 is 0.25673627760548373 + 0.0042105938121177145]).
step(0.25673627760548373 is 0.42789379600913957 * 0.6, builtin, [], []).
step(0.2609468714176014 is 0.25673627760548373 + 0.0042105938121177145, builtin, [], []).
step(0.28514101258814745 is 0.02419414117054602 + 0.2609468714176014, builtin, [], []).
step(expectedSuccess(antihistamine, 0.10026891936485297),
     rule(77),
     ['Therapy' = antihistamine, 'Expectedsuccess' = 0.10026891936485297],
     [therapy(antihistamine), expected_success(antihistamine, 0.10026891936485297)]).
step(therapy(antihistamine), fact(37), [], []).
step(expected_success(antihistamine, 0.10026891936485297),
     rule(67),
     ['Therapy' = antihistamine,
      'Expectedsuccess' = 0.10026891936485297,
      'Posteriors' = [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716],
      'Successbydisease' = [0.1, 0.1, 0.75, 0.05]],
     [posteriors(case, [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716]),
      success_by_disease(antihistamine, [0.1, 0.1, 0.75, 0.05]),
      dot_product([0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716], [0.1, 0.1, 0.75, 0.05], 0.10026891936485297)]).
step(success_by_disease(antihistamine, [0.1, 0.1, 0.75, 0.05]), fact(42), [], []).
step(dot_product([0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716], [0.1, 0.1, 0.75, 0.05], 0.10026891936485297),
     rule(66),
     ['Left' = 0.48388282341092037,
      'Restleft' = [0.42789379600913957, 0.006685840562642804, 0.08153754001729716],
      'Right' = 0.1,
      'Restright' = [0.1, 0.75, 0.05],
      'Sum' = 0.10026891936485297,
      'Term' = 0.04838828234109204,
      'Tailsum' = 0.05188063702376092],
     [0.04838828234109204 is 0.48388282341092037 * 0.1,
      dot_product([0.42789379600913957, 0.006685840562642804, 0.08153754001729716], [0.1, 0.75, 0.05], 0.05188063702376092),
      0.10026891936485297 is 0.04838828234109204 + 0.05188063702376092]).
step(0.04838828234109204 is 0.48388282341092037 * 0.1, builtin, [], []).
step(dot_product([0.42789379600913957, 0.006685840562642804, 0.08153754001729716], [0.1, 0.75, 0.05], 0.05188063702376092),
     rule(66),
     ['Left' = 0.42789379600913957,
      'Restleft' = [0.006685840562642804, 0.08153754001729716],
      'Right' = 0.1,
      'Restright' = [0.75, 0.05],
      'Sum' = 0.05188063702376092,
      'Term' = 0.04278937960091396,
      'Tailsum' = 0.00909125742284696],
     [0.04278937960091396 is 0.42789379600913957 * 0.1,
      dot_product([0.006685840562642804, 0.08153754001729716], [0.75, 0.05], 0.00909125742284696),
      0.05188063702376092 is 0.04278937960091396 + 0.00909125742284696]).
step(0.04278937960091396 is 0.42789379600913957 * 0.1, builtin, [], []).
step(dot_product([0.006685840562642804, 0.08153754001729716], [0.75, 0.05], 0.00909125742284696),
     rule(66),
     ['Left' = 0.006685840562642804,
      'Restleft' = [0.08153754001729716],
      'Right' = 0.75,
      'Restright' = [0.05],
      'Sum' = 0.00909125742284696,
      'Term' = 0.005014380421982103,
      'Tailsum' = 0.004076877000864858],
     [0.005014380421982103 is 0.006685840562642804 * 0.75,
      dot_product([0.08153754001729716], [0.05], 0.004076877000864858),
      0.00909125742284696 is 0.005014380421982103 + 0.004076877000864858]).
step(0.005014380421982103 is 0.006685840562642804 * 0.75, builtin, [], []).
step(0.00909125742284696 is 0.005014380421982103 + 0.004076877000864858, builtin, [], []).
step(0.05188063702376092 is 0.04278937960091396 + 0.00909125742284696, builtin, [], []).
step(0.10026891936485297 is 0.04838828234109204 + 0.05188063702376092, builtin, [], []).
step(expectedSuccess(antibiotic, 0.1109525797960936),
     rule(77),
     ['Therapy' = antibiotic, 'Expectedsuccess' = 0.1109525797960936],
     [therapy(antibiotic), expected_success(antibiotic, 0.1109525797960936)]).
step(therapy(antibiotic), fact(38), [], []).
step(expected_success(antibiotic, 0.1109525797960936),
     rule(67),
     ['Therapy' = antibiotic,
      'Expectedsuccess' = 0.1109525797960936,
      'Posteriors' = [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716],
      'Successbydisease' = [0.05, 0.05, 0.02, 0.8]],
     [posteriors(case, [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716]),
      success_by_disease(antibiotic, [0.05, 0.05, 0.02, 0.8]),
      dot_product([0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716], [0.05, 0.05, 0.02, 0.8], 0.1109525797960936)]).
step(success_by_disease(antibiotic, [0.05, 0.05, 0.02, 0.8]), fact(43), [], []).
step(dot_product([0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716], [0.05, 0.05, 0.02, 0.8], 0.1109525797960936),
     rule(66),
     ['Left' = 0.48388282341092037,
      'Restleft' = [0.42789379600913957, 0.006685840562642804, 0.08153754001729716],
      'Right' = 0.05,
      'Restright' = [0.05, 0.02, 0.8],
      'Sum' = 0.1109525797960936,
      'Term' = 0.02419414117054602,
      'Tailsum' = 0.08675843862554758],
     [0.02419414117054602 is 0.48388282341092037 * 0.05,
      dot_product([0.42789379600913957, 0.006685840562642804, 0.08153754001729716], [0.05, 0.02, 0.8], 0.08675843862554758),
      0.1109525797960936 is 0.02419414117054602 + 0.08675843862554758]).
step(dot_product([0.42789379600913957, 0.006685840562642804, 0.08153754001729716], [0.05, 0.02, 0.8], 0.08675843862554758),
     rule(66),
     ['Left' = 0.42789379600913957,
      'Restleft' = [0.006685840562642804, 0.08153754001729716],
      'Right' = 0.05,
      'Restright' = [0.02, 0.8],
      'Sum' = 0.08675843862554758,
      'Term' = 0.02139468980045698,
      'Tailsum' = 0.06536374882509059],
     [0.02139468980045698 is 0.42789379600913957 * 0.05,
      dot_product([0.006685840562642804, 0.08153754001729716], [0.02, 0.8], 0.06536374882509059),
      0.08675843862554758 is 0.02139468980045698 + 0.06536374882509059]).
step(dot_product([0.006685840562642804, 0.08153754001729716], [0.02, 0.8], 0.06536374882509059),
     rule(66),
     ['Left' = 0.006685840562642804,
      'Restleft' = [0.08153754001729716],
      'Right' = 0.02,
      'Restright' = [0.8],
      'Sum' = 0.06536374882509059,
      'Term' = 0.00013371681125285608,
      'Tailsum' = 0.06523003201383773],
     [0.00013371681125285608 is 0.006685840562642804 * 0.02,
      dot_product([0.08153754001729716], [0.8], 0.06523003201383773),
      0.06536374882509059 is 0.00013371681125285608 + 0.06523003201383773]).
step(dot_product([0.08153754001729716], [0.8], 0.06523003201383773),
     rule(66),
     ['Left' = 0.08153754001729716,
      'Restleft' = [],
      'Right' = 0.8,
      'Restright' = [],
      'Sum' = 0.06523003201383773,
      'Term' = 0.06523003201383773,
      'Tailsum' = 0.0],
     [0.06523003201383773 is 0.08153754001729716 * 0.8,
      dot_product([], [], 0.0),
      0.06523003201383773 is 0.06523003201383773 + 0.0]).
step(0.06523003201383773 is 0.08153754001729716 * 0.8, builtin, [], []).
step(0.06523003201383773 is 0.06523003201383773 + 0.0, builtin, [], []).
step(0.06536374882509059 is 0.00013371681125285608 + 0.06523003201383773, builtin, [], []).
step(0.08675843862554758 is 0.02139468980045698 + 0.06536374882509059, builtin, [], []).
step(0.1109525797960936 is 0.02419414117054602 + 0.08675843862554758, builtin, [], []).
step(expectedSuccess(supportiveCare, 0.2915119539701381),
     rule(77),
     ['Therapy' = supportiveCare, 'Expectedsuccess' = 0.2915119539701381],
     [therapy(supportiveCare), expected_success(supportiveCare, 0.2915119539701381)]).
step(therapy(supportiveCare), fact(39), [], []).
step(expected_success(supportiveCare, 0.2915119539701381),
     rule(67),
     ['Therapy' = supportiveCare,
      'Expectedsuccess' = 0.2915119539701381,
      'Posteriors' = [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716],
      'Successbydisease' = [0.3, 0.3, 0.25, 0.2]],
     [posteriors(case, [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716]),
      success_by_disease(supportiveCare, [0.3, 0.3, 0.25, 0.2]),
      dot_product([0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716], [0.3, 0.3, 0.25, 0.2], 0.2915119539701381)]).
step(success_by_disease(supportiveCare, [0.3, 0.3, 0.25, 0.2]), fact(44), [], []).
step(dot_product([0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716], [0.3, 0.3, 0.25, 0.2], 0.2915119539701381),
     rule(66),
     ['Left' = 0.48388282341092037,
      'Restleft' = [0.42789379600913957, 0.006685840562642804, 0.08153754001729716],
      'Right' = 0.3,
      'Restright' = [0.3, 0.25, 0.2],
      'Sum' = 0.2915119539701381,
      'Term' = 0.14516484702327612,
      'Tailsum' = 0.146347106946862],
     [0.14516484702327612 is 0.48388282341092037 * 0.3,
      dot_product([0.42789379600913957, 0.006685840562642804, 0.08153754001729716], [0.3, 0.25, 0.2], 0.146347106946862),
      0.2915119539701381 is 0.14516484702327612 + 0.146347106946862]).
step(0.14516484702327612 is 0.48388282341092037 * 0.3, builtin, [], []).
step(dot_product([0.42789379600913957, 0.006685840562642804, 0.08153754001729716], [0.3, 0.25, 0.2], 0.146347106946862),
     rule(66),
     ['Left' = 0.42789379600913957,
      'Restleft' = [0.006685840562642804, 0.08153754001729716],
      'Right' = 0.3,
      'Restright' = [0.25, 0.2],
      'Sum' = 0.146347106946862,
      'Term' = 0.12836813880274187,
      'Tailsum' = 0.017978968144120134],
     [0.12836813880274187 is 0.42789379600913957 * 0.3,
      dot_product([0.006685840562642804, 0.08153754001729716], [0.25, 0.2], 0.017978968144120134),
      0.146347106946862 is 0.12836813880274187 + 0.017978968144120134]).
step(0.12836813880274187 is 0.42789379600913957 * 0.3, builtin, [], []).
step(dot_product([0.006685840562642804, 0.08153754001729716], [0.25, 0.2], 0.017978968144120134),
     rule(66),
     ['Left' = 0.006685840562642804,
      'Restleft' = [0.08153754001729716],
      'Right' = 0.25,
      'Restright' = [0.2],
      'Sum' = 0.017978968144120134,
      'Term' = 0.001671460140660701,
      'Tailsum' = 0.016307508003459432],
     [0.001671460140660701 is 0.006685840562642804 * 0.25,
      dot_product([0.08153754001729716], [0.2], 0.016307508003459432),
      0.017978968144120134 is 0.001671460140660701 + 0.016307508003459432]).
step(0.001671460140660701 is 0.006685840562642804 * 0.25, builtin, [], []).
step(dot_product([0.08153754001729716], [0.2], 0.016307508003459432),
     rule(66),
     ['Left' = 0.08153754001729716,
      'Restleft' = [],
      'Right' = 0.2,
      'Restright' = [],
      'Sum' = 0.016307508003459432,
      'Term' = 0.016307508003459432,
      'Tailsum' = 0.0],
     [0.016307508003459432 is 0.08153754001729716 * 0.2,
      dot_product([], [], 0.0),
      0.016307508003459432 is 0.016307508003459432 + 0.0]).
step(0.016307508003459432 is 0.08153754001729716 * 0.2, builtin, [], []).
step(0.016307508003459432 is 0.016307508003459432 + 0.0, builtin, [], []).
step(0.017978968144120134 is 0.001671460140660701 + 0.016307508003459432, builtin, [], []).
step(0.146347106946862 is 0.12836813880274187 + 0.017978968144120134, builtin, [], []).
step(0.2915119539701381 is 0.14516484702327612 + 0.146347106946862, builtin, [], []).
step(expectedAdverse(paxlovid, 0.1),
     rule(78),
     ['Therapy' = paxlovid, 'Adverse' = 0.1],
     [therapy(paxlovid), adverse(paxlovid, 0.1)]).
step(adverse(paxlovid, 0.1), fact(45), [], []).
step(expectedAdverse(oseltamivir, 0.08),
     rule(78),
     ['Therapy' = oseltamivir, 'Adverse' = 0.08],
     [therapy(oseltamivir), adverse(oseltamivir, 0.08)]).
step(adverse(oseltamivir, 0.08), fact(46), [], []).
step(expectedAdverse(antihistamine, 0.03),
     rule(78),
     ['Therapy' = antihistamine, 'Adverse' = 0.03],
     [therapy(antihistamine), adverse(antihistamine, 0.03)]).
step(adverse(antihistamine, 0.03), fact(47), [], []).
step(expectedAdverse(antibiotic, 0.07),
     rule(78),
     ['Therapy' = antibiotic, 'Adverse' = 0.07],
     [therapy(antibiotic), adverse(antibiotic, 0.07)]).
step(adverse(antibiotic, 0.07), fact(48), [], []).
step(expectedAdverse(supportiveCare, 0.01),
     rule(78),
     ['Therapy' = supportiveCare, 'Adverse' = 0.01],
     [therapy(supportiveCare), adverse(supportiveCare, 0.01)]).
step(adverse(supportiveCare, 0.01), fact(49), [], []).
step(utility(paxlovid, 3.5851740117076503),
     rule(79),
     ['Therapy' = paxlovid, 'Utility' = 3.5851740117076503],
     [therapy(paxlovid), therapy_utility(paxlovid, 3.5851740117076503)]).
step(therapy_utility(paxlovid, 3.5851740117076503),
     rule(68),
     ['Therapy' = paxlovid,
      'Utility' = 3.5851740117076503,
      'Expectedsuccess' = 0.388517401170765,
      'Adverse' = 0.1,
      'Benefitweight' = 10,
      'Harmweight' = 3,
      'Benefit' = 3.88517401170765,
      'Harmcost' = 0.30000000000000004],
     [expected_success(paxlovid, 0.388517401170765),
      adverse(paxlovid, 0.1),
      benefit_weight(10),
      harm_weight(3),
      3.88517401170765 is 10 * 0.388517401170765,
      0.30000000000000004 is 3 * 0.1,
      3.5851740117076503 is 3.88517401170765 - 0.30000000000000004]).
step(benefit_weight(10), fact(50), [], []).
step(harm_weight(3), fact(51), [], []).
step(3.88517401170765 is 10 * 0.388517401170765, builtin, [], []).
step(0.30000000000000004 is 3 * 0.1, builtin, [], []).
step(3.5851740117076503 is 3.88517401170765 - 0.30000000000000004, builtin, [], []).
step(utility(oseltamivir, 2.6114101258814744),
     rule(79),
     ['Therapy' = oseltamivir, 'Utility' = 2.6114101258814744],
     [therapy(oseltamivir), therapy_utility(oseltamivir, 2.6114101258814744)]).
step(therapy_utility(oseltamivir, 2.6114101258814744),
     rule(68),
     ['Therapy' = oseltamivir,
      'Utility' = 2.6114101258814744,
      'Expectedsuccess' = 0.28514101258814745,
      'Adverse' = 0.08,
      'Benefitweight' = 10,
      'Harmweight' = 3,
      'Benefit' = 2.8514101258814746,
      'Harmcost' = 0.24],
     [expected_success(oseltamivir, 0.28514101258814745),
      adverse(oseltamivir, 0.08),
      benefit_weight(10),
      harm_weight(3),
      2.8514101258814746 is 10 * 0.28514101258814745,
      0.24 is 3 * 0.08,
      2.6114101258814744 is 2.8514101258814746 - 0.24]).
step(2.8514101258814746 is 10 * 0.28514101258814745, builtin, [], []).
step(0.24 is 3 * 0.08, builtin, [], []).
step(2.6114101258814744 is 2.8514101258814746 - 0.24, builtin, [], []).
step(utility(antihistamine, 0.9126891936485296),
     rule(79),
     ['Therapy' = antihistamine, 'Utility' = 0.9126891936485296],
     [therapy(antihistamine), therapy_utility(antihistamine, 0.9126891936485296)]).
step(therapy_utility(antihistamine, 0.9126891936485296),
     rule(68),
     ['Therapy' = antihistamine,
      'Utility' = 0.9126891936485296,
      'Expectedsuccess' = 0.10026891936485297,
      'Adverse' = 0.03,
      'Benefitweight' = 10,
      'Harmweight' = 3,
      'Benefit' = 1.0026891936485296,
      'Harmcost' = 0.09],
     [expected_success(antihistamine, 0.10026891936485297),
      adverse(antihistamine, 0.03),
      benefit_weight(10),
      harm_weight(3),
      1.0026891936485296 is 10 * 0.10026891936485297,
      0.09 is 3 * 0.03,
      0.9126891936485296 is 1.0026891936485296 - 0.09]).
step(1.0026891936485296 is 10 * 0.10026891936485297, builtin, [], []).
step(0.09 is 3 * 0.03, builtin, [], []).
step(0.9126891936485296 is 1.0026891936485296 - 0.09, builtin, [], []).
step(utility(antibiotic, 0.8995257979609361),
     rule(79),
     ['Therapy' = antibiotic, 'Utility' = 0.8995257979609361],
     [therapy(antibiotic), therapy_utility(antibiotic, 0.8995257979609361)]).
step(therapy_utility(antibiotic, 0.8995257979609361),
     rule(68),
     ['Therapy' = antibiotic,
      'Utility' = 0.8995257979609361,
      'Expectedsuccess' = 0.1109525797960936,
      'Adverse' = 0.07,
      'Benefitweight' = 10,
      'Harmweight' = 3,
      'Benefit' = 1.109525797960936,
      'Harmcost' = 0.21000000000000002],
     [expected_success(antibiotic, 0.1109525797960936),
      adverse(antibiotic, 0.07),
      benefit_weight(10),
      harm_weight(3),
      1.109525797960936 is 10 * 0.1109525797960936,
      0.21000000000000002 is 3 * 0.07,
      0.8995257979609361 is 1.109525797960936 - 0.21000000000000002]).
step(1.109525797960936 is 10 * 0.1109525797960936, builtin, [], []).
step(0.21000000000000002 is 3 * 0.07, builtin, [], []).
step(0.8995257979609361 is 1.109525797960936 - 0.21000000000000002, builtin, [], []).
step(utility(supportiveCare, 2.8851195397013814),
     rule(79),
     ['Therapy' = supportiveCare, 'Utility' = 2.8851195397013814],
     [therapy(supportiveCare), therapy_utility(supportiveCare, 2.8851195397013814)]).
step(therapy_utility(supportiveCare, 2.8851195397013814),
     rule(68),
     ['Therapy' = supportiveCare,
      'Utility' = 2.8851195397013814,
      'Expectedsuccess' = 0.2915119539701381,
      'Adverse' = 0.01,
      'Benefitweight' = 10,
      'Harmweight' = 3,
      'Benefit' = 2.915119539701381,
      'Harmcost' = 0.03],
     [expected_success(supportiveCare, 0.2915119539701381),
      adverse(supportiveCare, 0.01),
      benefit_weight(10),
      harm_weight(3),
      2.915119539701381 is 10 * 0.2915119539701381,
      0.03 is 3 * 0.01,
      2.8851195397013814 is 2.915119539701381 - 0.03]).
step(2.915119539701381 is 10 * 0.2915119539701381, builtin, [], []).
step(0.03 is 3 * 0.01, builtin, [], []).
step(2.8851195397013814 is 2.915119539701381 - 0.03, builtin, [], []).
step(recommendedTherapy(case, paxlovid),
     rule(80),
     ['Best' = paxlovid,
      'Therapies' = [paxlovid, oseltamivir, supportiveCare, antibiotic, antihistamine]],
     [therapies(case, [paxlovid, oseltamivir, supportiveCare, antibiotic, antihistamine]),
      best_therapy([paxlovid, oseltamivir, supportiveCare, antibiotic, antihistamine], paxlovid)]).
step(therapies(case, [paxlovid, oseltamivir, supportiveCare, antibiotic, antihistamine]),
     fact(9),
     [],
     []).
step(best_therapy([paxlovid, oseltamivir, supportiveCare, antibiotic, antihistamine], paxlovid),
     rule(72),
     ['Head' = paxlovid,
      'Next' = oseltamivir,
      'Rest' = [supportiveCare, antibiotic, antihistamine],
      'Best' = paxlovid,
      'Bestrest' = supportiveCare],
     [best_therapy([oseltamivir, supportiveCare, antibiotic, antihistamine], supportiveCare),
      better_of(paxlovid, supportiveCare, paxlovid)]).
step(best_therapy([oseltamivir, supportiveCare, antibiotic, antihistamine], supportiveCare),
     rule(72),
     ['Head' = oseltamivir,
      'Next' = supportiveCare,
      'Rest' = [antibiotic, antihistamine],
      'Best' = supportiveCare,
      'Bestrest' = supportiveCare],
     [best_therapy([supportiveCare, antibiotic, antihistamine], supportiveCare),
      better_of(oseltamivir, supportiveCare, supportiveCare)]).
step(best_therapy([supportiveCare, antibiotic, antihistamine], supportiveCare),
     rule(72),
     ['Head' = supportiveCare,
      'Next' = antibiotic,
      'Rest' = [antihistamine],
      'Best' = supportiveCare,
      'Bestrest' = antihistamine],
     [best_therapy([antibiotic, antihistamine], antihistamine),
      better_of(supportiveCare, antihistamine, supportiveCare)]).
step(best_therapy([antibiotic, antihistamine], antihistamine),
     rule(72),
     ['Head' = antibiotic,
      'Next' = antihistamine,
      'Rest' = [],
      'Best' = antihistamine,
      'Bestrest' = antihistamine],
     [best_therapy([antihistamine], antihistamine),
      better_of(antibiotic, antihistamine, antihistamine)]).
step(best_therapy([antihistamine], antihistamine), fact(71), ['Therapy' = antihistamine], []).
step(better_of(antibiotic, antihistamine, antihistamine),
     rule(70),
     ['Therapy1' = antibiotic,
      'Therapy2' = antihistamine,
      'Utility1' = 0.8995257979609361,
      'Utility2' = 0.9126891936485296],
     [therapy_utility(antibiotic, 0.8995257979609361),
      therapy_utility(antihistamine, 0.9126891936485296),
      0.8995257979609361 < 0.9126891936485296]).
step(0.8995257979609361 < 0.9126891936485296, builtin, [], []).
step(better_of(supportiveCare, antihistamine, supportiveCare),
     rule(69),
     ['Therapy1' = supportiveCare,
      'Therapy2' = antihistamine,
      'Utility1' = 2.8851195397013814,
      'Utility2' = 0.9126891936485296],
     [therapy_utility(supportiveCare, 2.8851195397013814),
      therapy_utility(antihistamine, 0.9126891936485296),
      2.8851195397013814 >= 0.9126891936485296]).
step(2.8851195397013814 >= 0.9126891936485296, builtin, [], []).
step(better_of(oseltamivir, supportiveCare, supportiveCare),
     rule(70),
     ['Therapy1' = oseltamivir,
      'Therapy2' = supportiveCare,
      'Utility1' = 2.6114101258814744,
      'Utility2' = 2.8851195397013814],
     [therapy_utility(oseltamivir, 2.6114101258814744),
      therapy_utility(supportiveCare, 2.8851195397013814),
      2.6114101258814744 < 2.8851195397013814]).
step(2.6114101258814744 < 2.8851195397013814, builtin, [], []).
step(better_of(paxlovid, supportiveCare, paxlovid),
     rule(69),
     ['Therapy1' = paxlovid,
      'Therapy2' = supportiveCare,
      'Utility1' = 3.5851740117076503,
      'Utility2' = 2.8851195397013814],
     [therapy_utility(paxlovid, 3.5851740117076503),
      therapy_utility(supportiveCare, 2.8851195397013814),
      3.5851740117076503 >= 2.8851195397013814]).
step(3.5851740117076503 >= 2.8851195397013814, builtin, [], []).
