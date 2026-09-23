evidenceTotal(case, 0.0016436300000000003).
result(case, result(covid19)).
result(case, result(influenza)).
result(case, result(allergicRhinitis)).
result(case, result(bacterialPneumonia)).
disease(result(covid19), covid19).
disease(result(influenza), influenza).
disease(result(allergicRhinitis), allergicRhinitis).
disease(result(bacterialPneumonia), bacterialPneumonia).
unnormalized(result(covid19), 0.0015470000000000002).
unnormalized(result(influenza), 0.000048000000000000015).
unnormalized(result(allergicRhinitis), 7.499999999999999e-7).
unnormalized(result(bacterialPneumonia), 0.000047879999999999996).
posterior(result(covid19), 0.9412093962753174).
posterior(result(influenza), 0.029203652890249024).
posterior(result(allergicRhinitis), 0.00045630707641014084).
posterior(result(bacterialPneumonia), 0.029130643758023392).

clause(1, disease(covid19), true).
clause(2, disease(influenza), true).
clause(3, disease(allergicRhinitis), true).
clause(4, disease(bacterialPneumonia), true).
clause(36, score_decimal(covid19, 0.0015470000000000002), true).
clause(37, score_decimal(influenza, 0.000048000000000000015), true).
clause(38, score_decimal(allergicRhinitis, 7.499999999999999e-7), true).
clause(39, score_decimal(bacterialPneumonia, 0.000047879999999999996), true).
clause(40, total_score_decimal(0.0016436300000000003), true).
clause(41, posterior_decimal(covid19, 0.9412093962753174), true).
clause(42, posterior_decimal(influenza, 0.029203652890249024), true).
clause(43, posterior_decimal(allergicRhinitis, 0.00045630707641014084), true).
clause(44, posterior_decimal(bacterialPneumonia, 0.029130643758023392), true).
clause(46, evidenceTotal(case, var('Total')), total_score_decimal(var('Total'))).
clause(47, result(case, result(var('Disease'))), disease(var('Disease'))).
clause(48, disease(result(var('Disease')), var('Disease')), disease(var('Disease'))).
clause(49,
       unnormalized(result(var('Disease')), var('Score')),
       score_decimal(var('Disease'), var('Score'))).
clause(50,
       posterior(result(var('Disease')), var('Posterior')),
       posterior_decimal(var('Disease'), var('Posterior'))).

step(evidenceTotal(case, 0.0016436300000000003),
     rule(46),
     ['Total' = 0.0016436300000000003],
     [total_score_decimal(0.0016436300000000003)]).
step(total_score_decimal(0.0016436300000000003), fact(40), [], []).
step(result(case, result(covid19)), rule(47), ['Disease' = covid19], [disease(covid19)]).
step(disease(covid19), fact(1), [], []).
step(result(case, result(influenza)), rule(47), ['Disease' = influenza], [disease(influenza)]).
step(disease(influenza), fact(2), [], []).
step(result(case, result(allergicRhinitis)),
     rule(47),
     ['Disease' = allergicRhinitis],
     [disease(allergicRhinitis)]).
step(disease(allergicRhinitis), fact(3), [], []).
step(result(case, result(bacterialPneumonia)),
     rule(47),
     ['Disease' = bacterialPneumonia],
     [disease(bacterialPneumonia)]).
step(disease(bacterialPneumonia), fact(4), [], []).
step(disease(result(covid19), covid19), rule(48), ['Disease' = covid19], [disease(covid19)]).
step(disease(result(influenza), influenza),
     rule(48),
     ['Disease' = influenza],
     [disease(influenza)]).
step(disease(result(allergicRhinitis), allergicRhinitis),
     rule(48),
     ['Disease' = allergicRhinitis],
     [disease(allergicRhinitis)]).
step(disease(result(bacterialPneumonia), bacterialPneumonia),
     rule(48),
     ['Disease' = bacterialPneumonia],
     [disease(bacterialPneumonia)]).
step(unnormalized(result(covid19), 0.0015470000000000002),
     rule(49),
     ['Disease' = covid19, 'Score' = 0.0015470000000000002],
     [score_decimal(covid19, 0.0015470000000000002)]).
step(score_decimal(covid19, 0.0015470000000000002), fact(36), [], []).
step(unnormalized(result(influenza), 0.000048000000000000015),
     rule(49),
     ['Disease' = influenza, 'Score' = 0.000048000000000000015],
     [score_decimal(influenza, 0.000048000000000000015)]).
step(score_decimal(influenza, 0.000048000000000000015), fact(37), [], []).
step(unnormalized(result(allergicRhinitis), 7.499999999999999e-7),
     rule(49),
     ['Disease' = allergicRhinitis, 'Score' = 7.499999999999999e-7],
     [score_decimal(allergicRhinitis, 7.499999999999999e-7)]).
step(score_decimal(allergicRhinitis, 7.499999999999999e-7), fact(38), [], []).
step(unnormalized(result(bacterialPneumonia), 0.000047879999999999996),
     rule(49),
     ['Disease' = bacterialPneumonia, 'Score' = 0.000047879999999999996],
     [score_decimal(bacterialPneumonia, 0.000047879999999999996)]).
step(score_decimal(bacterialPneumonia, 0.000047879999999999996), fact(39), [], []).
step(posterior(result(covid19), 0.9412093962753174),
     rule(50),
     ['Disease' = covid19, 'Posterior' = 0.9412093962753174],
     [posterior_decimal(covid19, 0.9412093962753174)]).
step(posterior_decimal(covid19, 0.9412093962753174), fact(41), [], []).
step(posterior(result(influenza), 0.029203652890249024),
     rule(50),
     ['Disease' = influenza, 'Posterior' = 0.029203652890249024],
     [posterior_decimal(influenza, 0.029203652890249024)]).
step(posterior_decimal(influenza, 0.029203652890249024), fact(42), [], []).
step(posterior(result(allergicRhinitis), 0.00045630707641014084),
     rule(50),
     ['Disease' = allergicRhinitis, 'Posterior' = 0.00045630707641014084],
     [posterior_decimal(allergicRhinitis, 0.00045630707641014084)]).
step(posterior_decimal(allergicRhinitis, 0.00045630707641014084), fact(43), [], []).
step(posterior(result(bacterialPneumonia), 0.029130643758023392),
     rule(50),
     ['Disease' = bacterialPneumonia, 'Posterior' = 0.029130643758023392],
     [posterior_decimal(bacterialPneumonia, 0.029130643758023392)]).
step(posterior_decimal(bacterialPneumonia, 0.029130643758023392), fact(44), [], []).
