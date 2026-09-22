% Prolog result format 4
query(1, supporting_study(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 3).
answer(1, ['X0' = marker_reduction, 'X1' = study_a]).
answer(1, ['X0' = marker_reduction, 'X1' = study_b]).
answer(1, ['X0' = survival_benefit, 'X1' = study_d]).
query(2, counterevidence(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(2, complete, 2).
answer(2, ['X0' = marker_reduction, 'X1' = study_c, 'X2' = low_quality]).
answer(2, ['X0' = survival_benefit, 'X1' = study_e, 'X2' = high_quality]).
query(3, evidence_state(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 2).
answer(3, ['X0' = marker_reduction, 'X1' = supported]).
answer(3, ['X0' = survival_benefit, 'X1' = contested]).
query(4, evidence_reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 2).
answer(4,
       ['X0' = marker_reduction,
        'X1' = "Two independent randomized studies with sample size >= 100 support the claim; the contradictory observational study is retained as lower-quality counterevidence."]).
answer(4,
       ['X0' = survival_benefit,
        'X1' = "High-quality randomized evidence exists on both sides, so the claim remains contested instead of being collapsed to a single truth value."]).
