condition('C1', resolution, ok, 73).
condition('C2', well_founded, ok, 92).
condition('C3', justification, ok, 92).
condition('C4', coverage, ok, 143).
condition('C5', re_decision, ok, 17).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 101).
obligation(absent, theory_scoped, \+ high_quality(study_c, marker_reduction, iri('https://example.org/evidence/direction/contradicts'), A)).
obligation(absent, theory_scoped, \+ high_quality_counterevidence(marker_reduction, A)).
steps(92).
verified(73).
recomputed(17).
composed(0).
trusted(2).
claims(9).
verdict(checked_with_obligations).
