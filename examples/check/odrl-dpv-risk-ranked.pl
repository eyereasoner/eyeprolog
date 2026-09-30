condition('C1', resolution, ok, 72).
condition('C2', well_founded, ok, 104).
condition('C3', justification, ok, 104).
condition('C4', coverage, ok, 157).
condition('C5', re_decision, ok, 31).
obligation(collected, theory_scoped, findall(key(InverseScore, Clause) - dpv_risk(Risk, Score, Level, Clause, Mitigation), (risk_report(Risk, Score, Level, Clause, Mitigation), InverseScore is 1000 - Score), [key(900, c1) - dpv_risk(deletion_risk, 100, high, c1, require_notice_before_deletion), key(915, c2) - dpv_risk(terms_risk, 85, high, c2, require_14_days_notice), key(903, c3) - dpv_risk(sharing_risk, 97, high, c3, require_explicit_consent), key(930, c4) - dpv_risk(portability_risk, 70, moderate, c4, permit_data_export)])).
steps(104).
verified(72).
recomputed(31).
composed(0).
trusted(1).
claims(20).
verdict(checked_with_obligations).
