condition('C1', resolution, ok, 30).
condition('C2', well_founded, ok, 43).
condition('C3', justification, ok, 43).
condition('C4', coverage, ok, 57).
condition('C5', re_decision, ok, 12).
obligation(collected, theory_scoped, findall(key(NegativeScore, Status) - claim(Status, Source, score(Score)), (annotated_status_claim(Status, Source, Score), NegativeScore is - Score), [key(-9310, closed) - claim(closed, transport_authority, score(9310)), key(-700, open) - claim(open, anonymous_post, score(700))])).
steps(43).
verified(30).
recomputed(12).
composed(0).
trusted(1).
claims(9).
verdict(checked_with_obligations).
