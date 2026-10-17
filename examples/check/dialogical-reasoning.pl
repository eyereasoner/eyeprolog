condition('C1', resolution, ok, 231).
condition('C2', well_founded, ok, 444).
condition('C3', justification, ok, 444).
condition('C4', coverage, ok, 599).
condition('C5', re_decision, ok, 207).
condition('C6', boundary_consistency, ok, 5).
condition('C7', relevance, ok, 492).
obligation(absent, theory_scoped, \+ common_ground(valid(c17), [])).
obligation(absent, theory_scoped, \+ opponent_proves(minor_party(c17), 1, A)).
obligation(absent, theory_scoped, \+ common_ground(ratified_at_majority(c17), [born(ann, 2009)])).
obligation(absent, theory_scoped, \+ common_ground(valid(c18), [])).
obligation(absent, theory_scoped, \+ common_ground(ratified_at_majority(c18), [born(dave, 2010)])).
obligation(absent, theory_scoped, \+ common_ground(ratified(c18, A, B), [born(dave, 2010)])).
steps(444).
verified(231).
recomputed(191).
composed(16).
trusted(6).
claims(48).
verdict(checked_with_obligations).
