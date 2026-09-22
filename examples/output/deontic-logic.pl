% Prolog result format 4
query(1, violation(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 2).
answer(1, ['X0' = alice, 'X1' = missed_obligation(obtain_consent)]).
answer(1, ['X0' = alice, 'X1' = prohibited_action(share_record)]).
query(2, compensation(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = alice, 'X1' = compensation(share_record, notify_dpo)]).
query(3, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3, ['X0' = alice, 'X1' = requires_review]).
