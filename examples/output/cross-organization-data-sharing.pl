% Prolog result format 4
query(1, sharing_decision(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 3).
answer(1, ['X0' = marketing, 'X1' = deny]).
answer(1, ['X0' = research_us, 'X1' = review]).
answer(1, ['X0' = research_eu, 'X1' = permit]).
query(2, obligation(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 2).
answer(2, ['X0' = research_eu, 'X1' = delete_after_days(120)]).
answer(2, ['X0' = research_eu, 'X1' = retain_audit_log]).
query(3, decision_reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 3).
answer(3,
       ['X0' = research_eu,
        'X1' = "ODRL permission matches; recipient is certified, data is pseudonymized, retention is within 180 days, and the transfer stays in-region."]).
answer(3,
       ['X0' = marketing,
        'X1' = "The requested marketing distribution matches an explicit ODRL prohibition."]).
answer(3,
       ['X0' = research_us,
        'X1' = "The research purpose is permitted, but the out-of-region transfer lacks the required contractual safeguard and must be reviewed."]).
