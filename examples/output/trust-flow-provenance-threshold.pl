% Prolog result format 4
query(1, confidence(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 2).
answer(1, ['X0' = message_a, 'X1' = 0.8937599999999999]).
answer(1, ['X0' = message_b, 'X1' = 0.41999999999999993]).
query(2, trust_flow_state(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 2).
answer(2, ['X0' = message_a, 'X1' = fpv_accepted]).
answer(2, ['X0' = message_b, 'X1' = fpv_quarantine]).
query(3, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = message_a, 'X1' = fpv_high_trust_flow]).
query(4, risk(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 1).
answer(4, ['X0' = message_b, 'X1' = risk_low_trust_data_source]).
