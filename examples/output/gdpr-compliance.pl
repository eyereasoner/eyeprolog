% Prolog result format 4
query(1, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 2).
answer(1, ['X0' = case_alpha, 'X1' = gdpr_compliant]).
answer(1, ['X0' = case_beta, 'X1' = gdpr_noncompliant]).
query(2, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 4).
answer(2, ['X0' = case_beta, 'X1' = missing_legal_basis]).
answer(2, ['X0' = case_beta, 'X1' = not_minimized]).
answer(2, ['X0' = case_beta, 'X1' = missing_access_logging]).
answer(2, ['X0' = case_beta, 'X1' = transfer_without_adequacy]).
