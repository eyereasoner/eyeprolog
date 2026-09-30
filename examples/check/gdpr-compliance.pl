condition('C1', resolution, ok, 24).
condition('C2', well_founded, ok, 28).
condition('C3', justification, ok, 28).
condition('C4', coverage, ok, 29).
condition('C5', re_decision, ok, 0).
obligation(absent, theory_scoped, \+ third_country_transfer(case_alpha)).
obligation(absent, theory_scoped, \+ has_required_basis(case_beta)).
obligation(absent, theory_scoped, \+ safeguard(case_beta, access_logging)).
obligation(absent, theory_scoped, \+ adequacy_decision(case_beta)).
steps(28).
verified(24).
recomputed(0).
composed(0).
trusted(4).
claims(6).
verdict(checked_with_obligations).
