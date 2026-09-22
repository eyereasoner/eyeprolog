% Prolog result format 4
query(1, scores(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 0).
query(2, evidenceTotal(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = case, 'X1' = 0.0016436300000000003]).
why(2,
    ['X0' = case, 'X1' = 0.0016436300000000003],
    [evidenceTotal(case, 0.0016436300000000003)]).
query(3, result(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 4).
answer(3, ['X0' = case, 'X1' = result(covid19)]).
why(3, ['X0' = case, 'X1' = result(covid19)], [result(case, result(covid19))]).
answer(3, ['X0' = case, 'X1' = result(influenza)]).
why(3, ['X0' = case, 'X1' = result(influenza)], [result(case, result(influenza))]).
answer(3, ['X0' = case, 'X1' = result(allergicRhinitis)]).
why(3, ['X0' = case, 'X1' = result(allergicRhinitis)], [result(case, result(allergicRhinitis))]).
answer(3, ['X0' = case, 'X1' = result(bacterialPneumonia)]).
why(3,
    ['X0' = case, 'X1' = result(bacterialPneumonia)],
    [result(case, result(bacterialPneumonia))]).
query(4, disease(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 4).
answer(4, ['X0' = result(covid19), 'X1' = covid19]).
why(4, ['X0' = result(covid19), 'X1' = covid19], [disease(result(covid19), covid19)]).
answer(4, ['X0' = result(influenza), 'X1' = influenza]).
why(4, ['X0' = result(influenza), 'X1' = influenza], [disease(result(influenza), influenza)]).
answer(4, ['X0' = result(allergicRhinitis), 'X1' = allergicRhinitis]).
why(4,
    ['X0' = result(allergicRhinitis), 'X1' = allergicRhinitis],
    [disease(result(allergicRhinitis), allergicRhinitis)]).
answer(4, ['X0' = result(bacterialPneumonia), 'X1' = bacterialPneumonia]).
why(4,
    ['X0' = result(bacterialPneumonia), 'X1' = bacterialPneumonia],
    [disease(result(bacterialPneumonia), bacterialPneumonia)]).
query(5, unnormalized(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 4).
answer(5, ['X0' = result(covid19), 'X1' = 0.0015470000000000002]).
why(5,
    ['X0' = result(covid19), 'X1' = 0.0015470000000000002],
    [unnormalized(result(covid19), 0.0015470000000000002)]).
answer(5, ['X0' = result(influenza), 'X1' = 0.000048000000000000015]).
why(5,
    ['X0' = result(influenza), 'X1' = 0.000048000000000000015],
    [unnormalized(result(influenza), 0.000048000000000000015)]).
answer(5, ['X0' = result(allergicRhinitis), 'X1' = 7.499999999999999e-7]).
why(5,
    ['X0' = result(allergicRhinitis), 'X1' = 7.499999999999999e-7],
    [unnormalized(result(allergicRhinitis), 7.499999999999999e-7)]).
answer(5, ['X0' = result(bacterialPneumonia), 'X1' = 0.000047879999999999996]).
why(5,
    ['X0' = result(bacterialPneumonia), 'X1' = 0.000047879999999999996],
    [unnormalized(result(bacterialPneumonia), 0.000047879999999999996)]).
query(6, posterior(_0, _1), ['X0' = _0, 'X1' = _1]).
result(6, complete, 4).
answer(6, ['X0' = result(covid19), 'X1' = 0.9412093962753174]).
why(6,
    ['X0' = result(covid19), 'X1' = 0.9412093962753174],
    [posterior(result(covid19), 0.9412093962753174)]).
answer(6, ['X0' = result(influenza), 'X1' = 0.029203652890249024]).
why(6,
    ['X0' = result(influenza), 'X1' = 0.029203652890249024],
    [posterior(result(influenza), 0.029203652890249024)]).
answer(6, ['X0' = result(allergicRhinitis), 'X1' = 0.00045630707641014084]).
why(6,
    ['X0' = result(allergicRhinitis), 'X1' = 0.00045630707641014084],
    [posterior(result(allergicRhinitis), 0.00045630707641014084)]).
answer(6, ['X0' = result(bacterialPneumonia), 'X1' = 0.029130643758023392]).
why(6,
    ['X0' = result(bacterialPneumonia), 'X1' = 0.029130643758023392],
    [posterior(result(bacterialPneumonia), 0.029130643758023392)]).

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
