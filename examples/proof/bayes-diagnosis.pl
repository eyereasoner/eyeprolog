evidenceTotal(case, 0.0016436300000000003).
why(
  evidenceTotal(case, 0.0016436300000000003),
  step(
    evidenceTotal(case, 0.0016436300000000003),
    rule("bayes-diagnosis.pl", clause(46)),
    ['Total' = 0.0016436300000000003],
    [
      step(total_score_decimal(0.0016436300000000003), fact("bayes-diagnosis.pl", clause(40)), [], [])
    ]
  )
).

result(case, result(covid19)).
why(
  result(case, result(covid19)),
  step(
    result(case, result(covid19)),
    rule("bayes-diagnosis.pl", clause(47)),
    ['Disease' = covid19],
    [
      step(disease(covid19), fact("bayes-diagnosis.pl", clause(1)), [], [])
    ]
  )
).

result(case, result(influenza)).
why(
  result(case, result(influenza)),
  step(
    result(case, result(influenza)),
    rule("bayes-diagnosis.pl", clause(47)),
    ['Disease' = influenza],
    [
      step(disease(influenza), fact("bayes-diagnosis.pl", clause(2)), [], [])
    ]
  )
).

result(case, result(allergicRhinitis)).
why(
  result(case, result(allergicRhinitis)),
  step(
    result(case, result(allergicRhinitis)),
    rule("bayes-diagnosis.pl", clause(47)),
    ['Disease' = allergicRhinitis],
    [
      step(disease(allergicRhinitis), fact("bayes-diagnosis.pl", clause(3)), [], [])
    ]
  )
).

result(case, result(bacterialPneumonia)).
why(
  result(case, result(bacterialPneumonia)),
  step(
    result(case, result(bacterialPneumonia)),
    rule("bayes-diagnosis.pl", clause(47)),
    ['Disease' = bacterialPneumonia],
    [
      step(disease(bacterialPneumonia), fact("bayes-diagnosis.pl", clause(4)), [], [])
    ]
  )
).

disease(result(covid19), covid19).
why(
  disease(result(covid19), covid19),
  step(
    disease(result(covid19), covid19),
    rule("bayes-diagnosis.pl", clause(48)),
    ['Disease' = covid19],
    [
      step(disease(covid19), fact("bayes-diagnosis.pl", clause(1)), [], [])
    ]
  )
).

disease(result(influenza), influenza).
why(
  disease(result(influenza), influenza),
  step(
    disease(result(influenza), influenza),
    rule("bayes-diagnosis.pl", clause(48)),
    ['Disease' = influenza],
    [
      step(disease(influenza), fact("bayes-diagnosis.pl", clause(2)), [], [])
    ]
  )
).

disease(result(allergicRhinitis), allergicRhinitis).
why(
  disease(result(allergicRhinitis), allergicRhinitis),
  step(
    disease(result(allergicRhinitis), allergicRhinitis),
    rule("bayes-diagnosis.pl", clause(48)),
    ['Disease' = allergicRhinitis],
    [
      step(disease(allergicRhinitis), fact("bayes-diagnosis.pl", clause(3)), [], [])
    ]
  )
).

disease(result(bacterialPneumonia), bacterialPneumonia).
why(
  disease(result(bacterialPneumonia), bacterialPneumonia),
  step(
    disease(result(bacterialPneumonia), bacterialPneumonia),
    rule("bayes-diagnosis.pl", clause(48)),
    ['Disease' = bacterialPneumonia],
    [
      step(disease(bacterialPneumonia), fact("bayes-diagnosis.pl", clause(4)), [], [])
    ]
  )
).

unnormalized(result(covid19), 0.0015470000000000002).
why(
  unnormalized(result(covid19), 0.0015470000000000002),
  step(
    unnormalized(result(covid19), 0.0015470000000000002),
    rule("bayes-diagnosis.pl", clause(49)),
    ['Disease' = covid19, 'Score' = 0.0015470000000000002],
    [
      step(score_decimal(covid19, 0.0015470000000000002), fact("bayes-diagnosis.pl", clause(36)), [], [])
    ]
  )
).

unnormalized(result(influenza), 0.000048000000000000015).
why(
  unnormalized(result(influenza), 0.000048000000000000015),
  step(
    unnormalized(result(influenza), 0.000048000000000000015),
    rule("bayes-diagnosis.pl", clause(49)),
    ['Disease' = influenza, 'Score' = 0.000048000000000000015],
    [
      step(score_decimal(influenza, 0.000048000000000000015), fact("bayes-diagnosis.pl", clause(37)), [], [])
    ]
  )
).

unnormalized(result(allergicRhinitis), 7.499999999999999e-7).
why(
  unnormalized(result(allergicRhinitis), 7.499999999999999e-7),
  step(
    unnormalized(result(allergicRhinitis), 7.499999999999999e-7),
    rule("bayes-diagnosis.pl", clause(49)),
    ['Disease' = allergicRhinitis, 'Score' = 7.499999999999999e-7],
    [
      step(score_decimal(allergicRhinitis, 7.499999999999999e-7), fact("bayes-diagnosis.pl", clause(38)), [], [])
    ]
  )
).

unnormalized(result(bacterialPneumonia), 0.000047879999999999996).
why(
  unnormalized(result(bacterialPneumonia), 0.000047879999999999996),
  step(
    unnormalized(result(bacterialPneumonia), 0.000047879999999999996),
    rule("bayes-diagnosis.pl", clause(49)),
    ['Disease' = bacterialPneumonia, 'Score' = 0.000047879999999999996],
    [
      step(score_decimal(bacterialPneumonia, 0.000047879999999999996), fact("bayes-diagnosis.pl", clause(39)), [], [])
    ]
  )
).

posterior(result(covid19), 0.9412093962753174).
why(
  posterior(result(covid19), 0.9412093962753174),
  step(
    posterior(result(covid19), 0.9412093962753174),
    rule("bayes-diagnosis.pl", clause(50)),
    ['Disease' = covid19, 'Posterior' = 0.9412093962753174],
    [
      step(posterior_decimal(covid19, 0.9412093962753174), fact("bayes-diagnosis.pl", clause(41)), [], [])
    ]
  )
).

posterior(result(influenza), 0.029203652890249024).
why(
  posterior(result(influenza), 0.029203652890249024),
  step(
    posterior(result(influenza), 0.029203652890249024),
    rule("bayes-diagnosis.pl", clause(50)),
    ['Disease' = influenza, 'Posterior' = 0.029203652890249024],
    [
      step(posterior_decimal(influenza, 0.029203652890249024), fact("bayes-diagnosis.pl", clause(42)), [], [])
    ]
  )
).

posterior(result(allergicRhinitis), 0.00045630707641014084).
why(
  posterior(result(allergicRhinitis), 0.00045630707641014084),
  step(
    posterior(result(allergicRhinitis), 0.00045630707641014084),
    rule("bayes-diagnosis.pl", clause(50)),
    ['Disease' = allergicRhinitis, 'Posterior' = 0.00045630707641014084],
    [
      step(posterior_decimal(allergicRhinitis, 0.00045630707641014084), fact("bayes-diagnosis.pl", clause(43)), [], [])
    ]
  )
).

posterior(result(bacterialPneumonia), 0.029130643758023392).
why(
  posterior(result(bacterialPneumonia), 0.029130643758023392),
  step(
    posterior(result(bacterialPneumonia), 0.029130643758023392),
    rule("bayes-diagnosis.pl", clause(50)),
    ['Disease' = bacterialPneumonia, 'Posterior' = 0.029130643758023392],
    [
      step(posterior_decimal(bacterialPneumonia, 0.029130643758023392), fact("bayes-diagnosis.pl", clause(44)), [], [])
    ]
  )
).

