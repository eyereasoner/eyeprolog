% Prolog result format 4
query(1, fallacy(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 4).
answer(1, ['X0' = arg_affirming_consequent, 'X1' = affirming_consequent]).
answer(1, ['X0' = arg_denying_antecedent, 'X1' = denying_antecedent]).
answer(1, ['X0' = arg_hasty_generalization, 'X1' = hasty_generalization]).
answer(1, ['X0' = arg_false_dilemma, 'X1' = false_dilemma]).
query(2, type(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 4).
answer(2, ['X0' = arg_affirming_consequent, 'X1' = illegitimate_reasoning]).
answer(2, ['X0' = arg_denying_antecedent, 'X1' = illegitimate_reasoning]).
answer(2, ['X0' = arg_hasty_generalization, 'X1' = illegitimate_reasoning]).
answer(2, ['X0' = arg_false_dilemma, 'X1' = illegitimate_reasoning]).
query(3, conclusion(_0, _1), ['X0' = _0, 'X1' = _1]).
result(3, complete, 4).
answer(3, ['X0' = arg_affirming_consequent, 'X1' = rain]).
answer(3, ['X0' = arg_denying_antecedent, 'X1' = neg(door_opens)]).
answer(3, ['X0' = arg_hasty_generalization, 'X1' = all(crows, black)]).
answer(3, ['X0' = arg_false_dilemma, 'X1' = approve_now]).
query(4, reason(_0, _1), ['X0' = _0, 'X1' = _1]).
result(4, complete, 4).
answer(4,
       ['X0' = arg_affirming_consequent,
        'X1' = "observing the consequent does not prove the antecedent"]).
answer(4,
       ['X0' = arg_denying_antecedent,
        'X1' = "denying the antecedent does not disprove the consequent"]).
answer(4,
       ['X0' = arg_hasty_generalization,
        'X1' = "sample size is below the threshold for a universal conclusion"]).
answer(4, ['X0' = arg_false_dilemma, 'X1' = "a relevant alternative is omitted"]).
query(5, sampleSize(_0, _1), ['X0' = _0, 'X1' = _1]).
result(5, complete, 1).
answer(5, ['X0' = arg_hasty_generalization, 'X1' = 3]).
query(6, requiredSampleSize(_0, _1), ['X0' = _0, 'X1' = _1]).
result(6, complete, 1).
answer(6, ['X0' = arg_hasty_generalization, 'X1' = 30]).
query(7, omittedAlternative(_0, _1), ['X0' = _0, 'X1' = _1]).
result(7, complete, 1).
answer(7, ['X0' = arg_false_dilemma, 'X1' = revise_proposal]).
