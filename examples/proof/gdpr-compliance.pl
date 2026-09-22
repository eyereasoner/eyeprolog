% Prolog result format 4
query(1, status(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 2).
answer(1, ['X0' = case_alpha, 'X1' = gdpr_compliant]).
why(1, ['X0' = case_alpha, 'X1' = gdpr_compliant], [status(case_alpha, gdpr_compliant)]).
answer(1, ['X0' = case_beta, 'X1' = gdpr_noncompliant]).
why(1, ['X0' = case_beta, 'X1' = gdpr_noncompliant], [status(case_beta, gdpr_noncompliant)]).
query(2, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 4).
answer(2, ['X0' = case_beta, 'X1' = missing_legal_basis]).
why(2, ['X0' = case_beta, 'X1' = missing_legal_basis], [reason(case_beta, missing_legal_basis)]).
answer(2, ['X0' = case_beta, 'X1' = not_minimized]).
why(2, ['X0' = case_beta, 'X1' = not_minimized], [reason(case_beta, not_minimized)]).
answer(2, ['X0' = case_beta, 'X1' = missing_access_logging]).
why(2,
    ['X0' = case_beta, 'X1' = missing_access_logging],
    [reason(case_beta, missing_access_logging)]).
answer(2, ['X0' = case_beta, 'X1' = transfer_without_adequacy]).
why(2,
    ['X0' = case_beta, 'X1' = transfer_without_adequacy],
    [reason(case_beta, transfer_without_adequacy)]).

clause(1, processing(case_alpha), true).
clause(2, processing(case_beta), true).
clause(5, legal_basis(case_alpha, explicit_consent), true).
clause(6, minimized(case_alpha), true).
clause(7, not_minimized(case_beta), true).
clause(8, special_category(case_alpha, health_data), true).
clause(9, special_category(case_beta, health_data), true).
clause(10, safeguard(case_alpha, encryption), true).
clause(11, safeguard(case_alpha, access_logging), true).
clause(13, third_country_transfer(case_beta), true).
clause(15, has_required_basis(var('Case')), legal_basis(var('Case'), explicit_consent)).
clause(17,
       has_health_safeguards(var('Case')),
       (special_category(var('Case'), health_data),
        safeguard(var('Case'), encryption),
        safeguard(var('Case'), access_logging))).
clause(18, transfer_ok(var('Case')), \+ third_country_transfer(var('Case'))).
clause(20,
       compliant(var('Case')),
       (processing(var('Case')),
        has_required_basis(var('Case')),
        minimized(var('Case')),
        has_health_safeguards(var('Case')),
        transfer_ok(var('Case')))).
clause(21,
       noncompliance_reason(var('Case'), missing_legal_basis),
       (processing(var('Case')), \+ has_required_basis(var('Case')))).
clause(22, noncompliance_reason(var('Case'), not_minimized), not_minimized(var('Case'))).
clause(23,
       noncompliance_reason(var('Case'), missing_access_logging),
       (special_category(var('Case'), health_data), \+ safeguard(var('Case'), access_logging))).
clause(24,
       noncompliance_reason(var('Case'), transfer_without_adequacy),
       (third_country_transfer(var('Case')), \+ adequacy_decision(var('Case')))).
clause(25, status(var('Case'), gdpr_compliant), compliant(var('Case'))).
clause(26,
       status(var('Case'), gdpr_noncompliant),
       noncompliance_reason(var('Case'), anonymous(1))).
clause(27, reason(var('Case'), var('Reason')), noncompliance_reason(var('Case'), var('Reason'))).

step(status(case_alpha, gdpr_compliant),
     rule(25),
     ['Case' = case_alpha],
     [compliant(case_alpha)]).
step(compliant(case_alpha),
     rule(20),
     ['Case' = case_alpha],
     [processing(case_alpha),
      has_required_basis(case_alpha),
      minimized(case_alpha),
      has_health_safeguards(case_alpha),
      transfer_ok(case_alpha)]).
step(processing(case_alpha), fact(1), [], []).
step(has_required_basis(case_alpha),
     rule(15),
     ['Case' = case_alpha],
     [legal_basis(case_alpha, explicit_consent)]).
step(legal_basis(case_alpha, explicit_consent), fact(5), [], []).
step(minimized(case_alpha), fact(6), [], []).
step(has_health_safeguards(case_alpha),
     rule(17),
     ['Case' = case_alpha],
     [special_category(case_alpha, health_data),
      safeguard(case_alpha, encryption),
      safeguard(case_alpha, access_logging)]).
step(special_category(case_alpha, health_data), fact(8), [], []).
step(safeguard(case_alpha, encryption), fact(10), [], []).
step(safeguard(case_alpha, access_logging), fact(11), [], []).
step(transfer_ok(case_alpha),
     rule(18),
     ['Case' = case_alpha],
     [\+ third_country_transfer(case_alpha)]).
step(\+ third_country_transfer(case_alpha), absent, [], []).
step(status(case_beta, gdpr_noncompliant),
     rule(26),
     ['Case' = case_beta],
     [noncompliance_reason(case_beta, missing_legal_basis)]).
step(noncompliance_reason(case_beta, missing_legal_basis),
     rule(21),
     ['Case' = case_beta],
     [processing(case_beta), \+ has_required_basis(case_beta)]).
step(processing(case_beta), fact(2), [], []).
step(\+ has_required_basis(case_beta), absent, [], []).
step(reason(case_beta, missing_legal_basis),
     rule(27),
     ['Case' = case_beta, 'Reason' = missing_legal_basis],
     [noncompliance_reason(case_beta, missing_legal_basis)]).
step(reason(case_beta, not_minimized),
     rule(27),
     ['Case' = case_beta, 'Reason' = not_minimized],
     [noncompliance_reason(case_beta, not_minimized)]).
step(noncompliance_reason(case_beta, not_minimized),
     rule(22),
     ['Case' = case_beta],
     [not_minimized(case_beta)]).
step(not_minimized(case_beta), fact(7), [], []).
step(reason(case_beta, missing_access_logging),
     rule(27),
     ['Case' = case_beta, 'Reason' = missing_access_logging],
     [noncompliance_reason(case_beta, missing_access_logging)]).
step(noncompliance_reason(case_beta, missing_access_logging),
     rule(23),
     ['Case' = case_beta],
     [special_category(case_beta, health_data), \+ safeguard(case_beta, access_logging)]).
step(special_category(case_beta, health_data), fact(9), [], []).
step(\+ safeguard(case_beta, access_logging), absent, [], []).
step(reason(case_beta, transfer_without_adequacy),
     rule(27),
     ['Case' = case_beta, 'Reason' = transfer_without_adequacy],
     [noncompliance_reason(case_beta, transfer_without_adequacy)]).
step(noncompliance_reason(case_beta, transfer_without_adequacy),
     rule(24),
     ['Case' = case_beta],
     [third_country_transfer(case_beta), \+ adequacy_decision(case_beta)]).
step(third_country_transfer(case_beta), fact(13), [], []).
step(\+ adequacy_decision(case_beta), absent, [], []).
