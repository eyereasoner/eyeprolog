% Prolog result format 4
query(1, type(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 1).
answer(1, ['X0' = inc42, 'X1' = confirmed_compromise]).
query(2, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = inc42, 'X1' = escalate_to_incident_response]).
query(3, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 1).
answer(3,
       ['X0' = inc42,
        'X1' = "privileged credential abuse, malware on a critical endpoint, C2 contact, and exploitable RCE are correlated"]).
