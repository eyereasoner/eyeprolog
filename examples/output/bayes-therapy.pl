% Prolog result format 4
query(1, diseases(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 0).
query(2, therapies(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 0).
query(3, evidence(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 0).
query(4, scores(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4,
       ['X0' = case,
        'X1' = [0.009282000000000002, 0.008208, 0.00012824999999999997, 0.00156408]]).
query(5, evidenceTotal(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5, ['X0' = case, 'X1' = 0.019182330000000004]).
query(6, posteriors(_0, _1), ['X0' = _0, 'X1' = _1]).
result(6, complete, 1).
answer(6,
       ['X0' = case,
        'X1' = [0.48388282341092037, 0.42789379600913957, 0.006685840562642804, 0.08153754001729716]]).
query(7, posterior(_0, _1), ['X0' = _0, 'X1' = _1]).
result(7, complete, 4).
answer(7, ['X0' = covid19, 'X1' = 0.48388282341092037]).
answer(7, ['X0' = influenza, 'X1' = 0.42789379600913957]).
answer(7, ['X0' = allergicRhinitis, 'X1' = 0.006685840562642804]).
answer(7, ['X0' = bacterialPneumonia, 'X1' = 0.08153754001729716]).
query(8, expectedSuccess(_0, _1), ['X0' = _0, 'X1' = _1]).
result(8, complete, 5).
answer(8, ['X0' = paxlovid, 'X1' = 0.388517401170765]).
answer(8, ['X0' = oseltamivir, 'X1' = 0.28514101258814745]).
answer(8, ['X0' = antihistamine, 'X1' = 0.10026891936485297]).
answer(8, ['X0' = antibiotic, 'X1' = 0.1109525797960936]).
answer(8, ['X0' = supportiveCare, 'X1' = 0.2915119539701381]).
query(9, expectedAdverse(_0, _1), ['X0' = _0, 'X1' = _1]).
result(9, complete, 5).
answer(9, ['X0' = paxlovid, 'X1' = 0.10]).
answer(9, ['X0' = oseltamivir, 'X1' = 0.08]).
answer(9, ['X0' = antihistamine, 'X1' = 0.03]).
answer(9, ['X0' = antibiotic, 'X1' = 0.07]).
answer(9, ['X0' = supportiveCare, 'X1' = 0.01]).
query(10, utility(_0, _1), ['X0' = _0, 'X1' = _1]).
result(10, complete, 5).
answer(10, ['X0' = paxlovid, 'X1' = 3.5851740117076503]).
answer(10, ['X0' = oseltamivir, 'X1' = 2.6114101258814744]).
answer(10, ['X0' = antihistamine, 'X1' = 0.9126891936485296]).
answer(10, ['X0' = antibiotic, 'X1' = 0.8995257979609361]).
answer(10, ['X0' = supportiveCare, 'X1' = 2.8851195397013814]).
query(11, recommendedTherapy(_0, _1), ['X0' = _0, 'X1' = _1]).
result(11, complete, 1).
answer(11, ['X0' = case, 'X1' = paxlovid]).
