% Prolog result format 4
query(1, type(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = p001, 'X1' = trial_candidate]).
why(1, ['X0' = p001, 'X1' = trial_candidate], [type(p001, trial_candidate)]).
query(2, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 4).
answer(2, ['X0' = p001, 'X1' = eligible]).
why(2, ['X0' = p001, 'X1' = eligible], [status(p001, eligible)]).
answer(2, ['X0' = p002, 'X1' = screen_fail]).
why(2, ['X0' = p002, 'X1' = screen_fail], [status(p002, screen_fail)]).
answer(2, ['X0' = p003, 'X1' = screen_fail]).
why(2, ['X0' = p003, 'X1' = screen_fail], [status(p003, screen_fail)]).
answer(2, ['X0' = p004, 'X1' = screen_fail]).
why(2, ['X0' = p004, 'X1' = screen_fail], [status(p004, screen_fail)]).
query(3, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 4).
answer(3, ['X0' = p001, 'X1' = "meets inclusion criteria and no listed exclusion"]).
why(3,
    ['X0' = p001, 'X1' = "meets inclusion criteria and no listed exclusion"],
    [reason(p001, "meets inclusion criteria and no listed exclusion")]).
answer(3, ['X0' = p002, 'X1' = "eGFR below renal safety threshold"]).
why(3,
    ['X0' = p002, 'X1' = "eGFR below renal safety threshold"],
    [reason(p002, "eGFR below renal safety threshold")]).
answer(3, ['X0' = p003, 'X1' = "pregnancy exclusion applies"]).
why(3,
    ['X0' = p003, 'X1' = "pregnancy exclusion applies"],
    [reason(p003, "pregnancy exclusion applies")]).
answer(3, ['X0' = p004, 'X1' = "HbA1c is outside protocol range"]).
why(3,
    ['X0' = p004, 'X1' = "HbA1c is outside protocol range"],
    [reason(p004, "HbA1c is outside protocol range")]).

clause(1, patient(p001), true).
clause(4, patient(p004), true).
clause(5, age(p001, 54), true).
clause(9, diagnosis(p001, type2_diabetes), true).
clause(13, lab(p001, hba1c_pct, 8.4), true).
clause(18, lab(p002, egfr_ml_min, 38.0), true).
clause(21, condition(p003, pregnant), true).
clause(22,
       inclusion_adult(var('Patient')),
       (patient(var('Patient')), age(var('Patient'), var('Age')), var('Age') >= 18)).
clause(23, inclusion_diagnosis(var('Patient')), diagnosis(var('Patient'), type2_diabetes)).
clause(24,
       inclusion_hba1c(var('Patient')),
       (lab(var('Patient'), hba1c_pct, var('Hba1c')), var('Hba1c') >= 7.0, var('Hba1c') =< 10.5)).
clause(25,
       exclusion_renal(var('Patient')),
       (lab(var('Patient'), egfr_ml_min, var('Egfr')), var('Egfr') < 45.0)).
clause(26, exclusion_pregnancy(var('Patient')), condition(var('Patient'), pregnant)).
clause(27,
       screen_eligible(var('Patient')),
       (inclusion_adult(var('Patient')),
        inclusion_diagnosis(var('Patient')),
        inclusion_hba1c(var('Patient')),
        \+ exclusion_renal(var('Patient')),
        \+ exclusion_pregnancy(var('Patient')))).
clause(28, screen_fail(var('Patient')), exclusion_renal(var('Patient'))).
clause(29, screen_fail(var('Patient')), exclusion_pregnancy(var('Patient'))).
clause(30,
       screen_fail(var('Patient')),
       (patient(var('Patient')), \+ inclusion_hba1c(var('Patient')))).
clause(31, type(var('Patient'), trial_candidate), screen_eligible(var('Patient'))).
clause(32, status(var('Patient'), eligible), screen_eligible(var('Patient'))).
clause(33,
       reason(var('Patient'), "meets inclusion criteria and no listed exclusion"),
       screen_eligible(var('Patient'))).
clause(34, status(var('Patient'), screen_fail), screen_fail(var('Patient'))).
clause(35,
       reason(var('Patient'), "eGFR below renal safety threshold"),
       exclusion_renal(var('Patient'))).
clause(36,
       reason(var('Patient'), "pregnancy exclusion applies"),
       exclusion_pregnancy(var('Patient'))).
clause(37,
       reason(var('Patient'), "HbA1c is outside protocol range"),
       (patient(var('Patient')), \+ inclusion_hba1c(var('Patient')))).

step(type(p001, trial_candidate), rule(31), ['Patient' = p001], [screen_eligible(p001)]).
step(screen_eligible(p001),
     rule(27),
     ['Patient' = p001],
     [inclusion_adult(p001),
      inclusion_diagnosis(p001),
      inclusion_hba1c(p001),
      \+ exclusion_renal(p001),
      \+ exclusion_pregnancy(p001)]).
step(inclusion_adult(p001),
     rule(22),
     ['Patient' = p001, 'Age' = 54],
     [patient(p001), age(p001, 54), 54 >= 18]).
step(patient(p001), fact(1), [], []).
step(age(p001, 54), fact(5), [], []).
step(54 >= 18, builtin, [], []).
step(inclusion_diagnosis(p001), rule(23), ['Patient' = p001], [diagnosis(p001, type2_diabetes)]).
step(diagnosis(p001, type2_diabetes), fact(9), [], []).
step(inclusion_hba1c(p001),
     rule(24),
     ['Patient' = p001, 'Hba1c' = 8.4],
     [lab(p001, hba1c_pct, 8.4), 8.4 >= 7.0, 8.4 =< 10.5]).
step(lab(p001, hba1c_pct, 8.4), fact(13), [], []).
step(8.4 >= 7.0, builtin, [], []).
step(8.4 =< 10.5, builtin, [], []).
step(\+ exclusion_renal(p001), absent, [], []).
step(\+ exclusion_pregnancy(p001), absent, [], []).
step(status(p001, eligible), rule(32), ['Patient' = p001], [screen_eligible(p001)]).
step(status(p002, screen_fail), rule(34), ['Patient' = p002], [screen_fail(p002)]).
step(screen_fail(p002), rule(28), ['Patient' = p002], [exclusion_renal(p002)]).
step(exclusion_renal(p002),
     rule(25),
     ['Patient' = p002, 'Egfr' = 38.0],
     [lab(p002, egfr_ml_min, 38.0), 38.0 < 45.0]).
step(lab(p002, egfr_ml_min, 38.0), fact(18), [], []).
step(38.0 < 45.0, builtin, [], []).
step(status(p003, screen_fail), rule(34), ['Patient' = p003], [screen_fail(p003)]).
step(screen_fail(p003), rule(29), ['Patient' = p003], [exclusion_pregnancy(p003)]).
step(exclusion_pregnancy(p003), rule(26), ['Patient' = p003], [condition(p003, pregnant)]).
step(condition(p003, pregnant), fact(21), [], []).
step(status(p004, screen_fail), rule(34), ['Patient' = p004], [screen_fail(p004)]).
step(screen_fail(p004), rule(30), ['Patient' = p004], [patient(p004), \+ inclusion_hba1c(p004)]).
step(patient(p004), fact(4), [], []).
step(\+ inclusion_hba1c(p004), absent, [], []).
step(reason(p001, "meets inclusion criteria and no listed exclusion"),
     rule(33),
     ['Patient' = p001],
     [screen_eligible(p001)]).
step(reason(p002, "eGFR below renal safety threshold"),
     rule(35),
     ['Patient' = p002],
     [exclusion_renal(p002)]).
step(reason(p003, "pregnancy exclusion applies"),
     rule(36),
     ['Patient' = p003],
     [exclusion_pregnancy(p003)]).
step(reason(p004, "HbA1c is outside protocol range"),
     rule(37),
     ['Patient' = p004],
     [patient(p004), \+ inclusion_hba1c(p004)]).
