condition('C1', resolution, ok, 3).
condition('C2', well_founded, ok, 6).
condition('C3', justification, ok, 6).
condition('C4', coverage, ok, 7).
condition('C5', re_decision, ok, 2).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 8).
obligation(collected, theory_scoped, findall(A, valid_group(A), [[identity, reflection_a, reflection_b, reflection_c, rotation_120, rotation_240], [identity, reflection_a], [identity, reflection_b], [identity, reflection_c], [identity, rotation_120, rotation_240], [identity]])).
steps(6).
verified(3).
recomputed(2).
composed(0).
trusted(1).
claims(2).
verdict(checked_with_obligations).
