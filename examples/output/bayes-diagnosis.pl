% Prolog result format 4
query(1, scores(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 0).
query(2, evidenceTotal(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = case, 'X1' = 0.0016436300000000003]).
query(3, result(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 4).
answer(3, ['X0' = case, 'X1' = result(covid19)]).
answer(3, ['X0' = case, 'X1' = result(influenza)]).
answer(3, ['X0' = case, 'X1' = result(allergicRhinitis)]).
answer(3, ['X0' = case, 'X1' = result(bacterialPneumonia)]).
query(4, disease(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 4).
answer(4, ['X0' = result(covid19), 'X1' = covid19]).
answer(4, ['X0' = result(influenza), 'X1' = influenza]).
answer(4, ['X0' = result(allergicRhinitis), 'X1' = allergicRhinitis]).
answer(4, ['X0' = result(bacterialPneumonia), 'X1' = bacterialPneumonia]).
query(5, unnormalized(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 4).
answer(5, ['X0' = result(covid19), 'X1' = 0.0015470000000000002]).
answer(5, ['X0' = result(influenza), 'X1' = 0.000048000000000000015]).
answer(5, ['X0' = result(allergicRhinitis), 'X1' = 7.499999999999999e-7]).
answer(5, ['X0' = result(bacterialPneumonia), 'X1' = 0.000047879999999999996]).
query(6, posterior(_0, _1), ['X0' = _0, 'X1' = _1]).
result(6, complete, 4).
answer(6, ['X0' = result(covid19), 'X1' = 0.9412093962753174]).
answer(6, ['X0' = result(influenza), 'X1' = 0.029203652890249024]).
answer(6, ['X0' = result(allergicRhinitis), 'X1' = 0.00045630707641014084]).
answer(6, ['X0' = result(bacterialPneumonia), 'X1' = 0.029130643758023392]).
