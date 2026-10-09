condition('C1', resolution, ok, 52).
condition('C2', well_founded, ok, 75).
condition('C3', justification, ok, 75).
condition('C4', coverage, ok, 115).
condition('C5', re_decision, ok, 22).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 90).
obligation(collected, theory_scoped, findall(key(A, B) - dpv_risk(C, D, E, B, F), (risk_report(C, D, E, B, F), A is 1000 - D), [key(900, h1) - dpv_risk(consent_risk, 100, high, h1, require_explicit_consent), key(900, h2) - dpv_risk(sharing_risk, 100, high, h2, require_deidentification), key(930, h4) - dpv_risk(retention_risk, 70, moderate, h4, limit_retention_to_1095_days)])).
steps(75).
verified(52).
recomputed(22).
composed(0).
trusted(1).
claims(15).
verdict(checked_with_obligations).
