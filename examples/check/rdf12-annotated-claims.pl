condition('C1', resolution, ok, 30).
condition('C2', well_founded, ok, 43).
condition('C3', justification, ok, 43).
condition('C4', coverage, ok, 57).
condition('C5', re_decision, ok, 12).
condition('C6', boundary_consistency, ok, 0).
condition('C7', relevance, ok, 52).
obligation(collected, theory_scoped, findall(key(A, B) - claim(B, C, score(D)), (annotated_status_claim(B, C, D), A is - D), [key(-9310, closed) - claim(closed, transport_authority, score(9310)), key(-700, open) - claim(open, anonymous_post, score(700))])).
steps(43).
verified(30).
recomputed(12).
composed(0).
trusted(1).
claims(9).
verdict(checked_with_obligations).
