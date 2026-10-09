condition('C1', resolution, ok, 199).
condition('C2', well_founded, ok, 227).
condition('C3', justification, ok, 227).
condition('C4', coverage, ok, 295).
condition('C5', re_decision, ok, 14).
condition('C6', boundary_consistency, ok, 1).
condition('C7', relevance, ok, 269).
obligation(builtin, theory_scoped, (\+ conflict_iri(iri('https://example.org/city/proposal/p1'), iri('https://example.org/city/route/7'), iri('https://example.org/vocab/status'), A) ; authoritative_override(iri('https://example.org/city/evidence/transit-api-20260827'), iri('https://example.org/vocab/status')))).
obligation(absent, theory_scoped, \+ proposal_state_iri(iri('https://example.org/city/proposal/p4'), auto_accepted)).
obligation(absent, theory_scoped, \+ human_review(iri('https://example.org/city/proposal/p4'), A, B, C)).
obligation(absent, theory_scoped, \+ known(before_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/emergencyDesignation'), iri('https://example.org/city/class/cooling-center'))).
obligation(absent, theory_scoped, \+ has_accepted_override(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/status'))).
obligation(absent, theory_scoped, \+ has_accepted_override(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/cooling'))).
obligation(absent, theory_scoped, \+ has_accepted_override(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/wheelchairAccess'))).
obligation(absent, theory_scoped, \+ has_accepted_override(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/capacity'))).
obligation(absent, theory_scoped, \+ has_accepted_override(after_review, iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/vocab/expectedDemand'))).
obligation(absent, theory_scoped, \+ known(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/power'), iri('https://example.org/city/state/unstable'))).
obligation(absent, theory_scoped, \+ has_accepted_override(after_review, iri('https://example.org/city/facility/riverside-school'), iri('https://example.org/vocab/neighbourhood'))).
obligation(absent, theory_scoped, \+ local_center(before_review, iri('https://example.org/city/neighbourhood/riverside'), A)).
obligation(absent, theory_scoped, \+ reachable_center(before_review, iri('https://example.org/city/neighbourhood/riverside'), A)).
obligation(absent, theory_scoped, \+ has_accepted_override(before_review, iri('https://example.org/city/neighbourhood/riverside'), iri('https://example.org/vocab/mobileUnitAvailable'))).
steps(227).
verified(199).
recomputed(14).
composed(0).
trusted(14).
claims(42).
verdict(checked_with_obligations).
