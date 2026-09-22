type(p001, trial_candidate).
why(
  type(p001, trial_candidate),
  step(
    type(p001, trial_candidate),
    rule("clinical-trial-screening.pl", clause(31)),
    ['Patient' = p001],
    [
      step(
        screen_eligible(p001),
        rule("clinical-trial-screening.pl", clause(27)),
        ['Patient' = p001],
        [
          step(
            inclusion_adult(p001),
            rule("clinical-trial-screening.pl", clause(22)),
            ['Patient' = p001, 'Age' = 54],
            [
              step(patient(p001), fact("clinical-trial-screening.pl", clause(1)), [], []),
              step(age(p001, 54), fact("clinical-trial-screening.pl", clause(5)), [], []),
              step(>=(54, 18), builtin(>=, 2), [], [])
            ]
          ),
          step(
            inclusion_diagnosis(p001),
            rule("clinical-trial-screening.pl", clause(23)),
            ['Patient' = p001],
            [
              step(diagnosis(p001, type2_diabetes), fact("clinical-trial-screening.pl", clause(9)), [], [])
            ]
          ),
          step(
            inclusion_hba1c(p001),
            rule("clinical-trial-screening.pl", clause(24)),
            ['Patient' = p001, 'Hba1c' = 8.4],
            [
              step(lab(p001, hba1c_pct, 8.4), fact("clinical-trial-screening.pl", clause(13)), [], []),
              step(>=(8.4, 7.0), builtin(>=, 2), [], []),
              step(=<(8.4, 10.5), builtin(=<, 2), [], [])
            ]
          ),
          step('\\+'(exclusion_renal(p001)), builtin('\\+', 1), [], []),
          step('\\+'(exclusion_pregnancy(p001)), builtin('\\+', 1), [], [])
        ]
      )
    ]
  )
).

status(p001, eligible).
why(
  status(p001, eligible),
  step(
    status(p001, eligible),
    rule("clinical-trial-screening.pl", clause(32)),
    ['Patient' = p001],
    [
      step(
        screen_eligible(p001),
        rule("clinical-trial-screening.pl", clause(27)),
        ['Patient' = p001],
        [
          step(
            inclusion_adult(p001),
            rule("clinical-trial-screening.pl", clause(22)),
            ['Patient' = p001, 'Age' = 54],
            [
              step(patient(p001), fact("clinical-trial-screening.pl", clause(1)), [], []),
              step(age(p001, 54), fact("clinical-trial-screening.pl", clause(5)), [], []),
              step(>=(54, 18), builtin(>=, 2), [], [])
            ]
          ),
          step(
            inclusion_diagnosis(p001),
            rule("clinical-trial-screening.pl", clause(23)),
            ['Patient' = p001],
            [
              step(diagnosis(p001, type2_diabetes), fact("clinical-trial-screening.pl", clause(9)), [], [])
            ]
          ),
          step(
            inclusion_hba1c(p001),
            rule("clinical-trial-screening.pl", clause(24)),
            ['Patient' = p001, 'Hba1c' = 8.4],
            [
              step(lab(p001, hba1c_pct, 8.4), fact("clinical-trial-screening.pl", clause(13)), [], []),
              step(>=(8.4, 7.0), builtin(>=, 2), [], []),
              step(=<(8.4, 10.5), builtin(=<, 2), [], [])
            ]
          ),
          step('\\+'(exclusion_renal(p001)), builtin('\\+', 1), [], []),
          step('\\+'(exclusion_pregnancy(p001)), builtin('\\+', 1), [], [])
        ]
      )
    ]
  )
).

status(p002, screen_fail).
why(
  status(p002, screen_fail),
  step(
    status(p002, screen_fail),
    rule("clinical-trial-screening.pl", clause(34)),
    ['Patient' = p002],
    [
      step(
        screen_fail(p002),
        rule("clinical-trial-screening.pl", clause(28)),
        ['Patient' = p002],
        [
          step(
            exclusion_renal(p002),
            rule("clinical-trial-screening.pl", clause(25)),
            ['Patient' = p002, 'Egfr' = 38.0],
            [
              step(lab(p002, egfr_ml_min, 38.0), fact("clinical-trial-screening.pl", clause(18)), [], []),
              step(<(38.0, 45.0), builtin(<, 2), [], [])
            ]
          )
        ]
      )
    ]
  )
).

status(p003, screen_fail).
why(
  status(p003, screen_fail),
  step(
    status(p003, screen_fail),
    rule("clinical-trial-screening.pl", clause(34)),
    ['Patient' = p003],
    [
      step(
        screen_fail(p003),
        rule("clinical-trial-screening.pl", clause(29)),
        ['Patient' = p003],
        [
          step(
            exclusion_pregnancy(p003),
            rule("clinical-trial-screening.pl", clause(26)),
            ['Patient' = p003],
            [
              step(condition(p003, pregnant), fact("clinical-trial-screening.pl", clause(21)), [], [])
            ]
          )
        ]
      )
    ]
  )
).

status(p004, screen_fail).
why(
  status(p004, screen_fail),
  step(
    status(p004, screen_fail),
    rule("clinical-trial-screening.pl", clause(34)),
    ['Patient' = p004],
    [
      step(
        screen_fail(p004),
        rule("clinical-trial-screening.pl", clause(30)),
        ['Patient' = p004],
        [
          step(patient(p004), fact("clinical-trial-screening.pl", clause(4)), [], []),
          step('\\+'(inclusion_hba1c(p004)), builtin('\\+', 1), [], [])
        ]
      )
    ]
  )
).

reason(p001, "meets inclusion criteria and no listed exclusion").
why(
  reason(p001, "meets inclusion criteria and no listed exclusion"),
  step(
    reason(p001, "meets inclusion criteria and no listed exclusion"),
    rule("clinical-trial-screening.pl", clause(33)),
    ['Patient' = p001],
    [
      step(
        screen_eligible(p001),
        rule("clinical-trial-screening.pl", clause(27)),
        ['Patient' = p001],
        [
          step(
            inclusion_adult(p001),
            rule("clinical-trial-screening.pl", clause(22)),
            ['Patient' = p001, 'Age' = 54],
            [
              step(patient(p001), fact("clinical-trial-screening.pl", clause(1)), [], []),
              step(age(p001, 54), fact("clinical-trial-screening.pl", clause(5)), [], []),
              step(>=(54, 18), builtin(>=, 2), [], [])
            ]
          ),
          step(
            inclusion_diagnosis(p001),
            rule("clinical-trial-screening.pl", clause(23)),
            ['Patient' = p001],
            [
              step(diagnosis(p001, type2_diabetes), fact("clinical-trial-screening.pl", clause(9)), [], [])
            ]
          ),
          step(
            inclusion_hba1c(p001),
            rule("clinical-trial-screening.pl", clause(24)),
            ['Patient' = p001, 'Hba1c' = 8.4],
            [
              step(lab(p001, hba1c_pct, 8.4), fact("clinical-trial-screening.pl", clause(13)), [], []),
              step(>=(8.4, 7.0), builtin(>=, 2), [], []),
              step(=<(8.4, 10.5), builtin(=<, 2), [], [])
            ]
          ),
          step('\\+'(exclusion_renal(p001)), builtin('\\+', 1), [], []),
          step('\\+'(exclusion_pregnancy(p001)), builtin('\\+', 1), [], [])
        ]
      )
    ]
  )
).

reason(p002, "eGFR below renal safety threshold").
why(
  reason(p002, "eGFR below renal safety threshold"),
  step(
    reason(p002, "eGFR below renal safety threshold"),
    rule("clinical-trial-screening.pl", clause(35)),
    ['Patient' = p002],
    [
      step(
        exclusion_renal(p002),
        rule("clinical-trial-screening.pl", clause(25)),
        ['Patient' = p002, 'Egfr' = 38.0],
        [
          step(lab(p002, egfr_ml_min, 38.0), fact("clinical-trial-screening.pl", clause(18)), [], []),
          step(<(38.0, 45.0), builtin(<, 2), [], [])
        ]
      )
    ]
  )
).

reason(p003, "pregnancy exclusion applies").
why(
  reason(p003, "pregnancy exclusion applies"),
  step(
    reason(p003, "pregnancy exclusion applies"),
    rule("clinical-trial-screening.pl", clause(36)),
    ['Patient' = p003],
    [
      step(
        exclusion_pregnancy(p003),
        rule("clinical-trial-screening.pl", clause(26)),
        ['Patient' = p003],
        [
          step(condition(p003, pregnant), fact("clinical-trial-screening.pl", clause(21)), [], [])
        ]
      )
    ]
  )
).

reason(p004, "HbA1c is outside protocol range").
why(
  reason(p004, "HbA1c is outside protocol range"),
  step(
    reason(p004, "HbA1c is outside protocol range"),
    rule("clinical-trial-screening.pl", clause(37)),
    ['Patient' = p004],
    [
      step(patient(p004), fact("clinical-trial-screening.pl", clause(4)), [], []),
      step('\\+'(inclusion_hba1c(p004)), builtin('\\+', 1), [], [])
    ]
  )
).

