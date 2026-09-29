fallacy(arg_affirming_consequent, affirming_consequent).
fallacy(arg_denying_antecedent, denying_antecedent).
fallacy(arg_hasty_generalization, hasty_generalization).
fallacy(arg_false_dilemma, false_dilemma).
type(arg_affirming_consequent, illegitimate_reasoning).
type(arg_denying_antecedent, illegitimate_reasoning).
type(arg_hasty_generalization, illegitimate_reasoning).
type(arg_false_dilemma, illegitimate_reasoning).
conclusion(arg_affirming_consequent, rain).
conclusion(arg_denying_antecedent, neg(door_opens)).
conclusion(arg_hasty_generalization, all(crows, black)).
conclusion(arg_false_dilemma, approve_now).
reason(arg_affirming_consequent, "observing the consequent does not prove the antecedent").
reason(arg_denying_antecedent, "denying the antecedent does not disprove the consequent").
reason(arg_hasty_generalization, "sample size is below the threshold for a universal conclusion").
reason(arg_false_dilemma, "a relevant alternative is omitted").
sampleSize(arg_hasty_generalization, 3).
requiredSampleSize(arg_hasty_generalization, 30).
omittedAlternative(arg_false_dilemma, revise_proposal).

clause(6, argument(arg_affirming_consequent), true).
clause(7, implication(arg_affirming_consequent, rain, street_wet), true).
clause(8, observed(arg_affirming_consequent, street_wet), true).
clause(9, concludes(arg_affirming_consequent, rain), true).
clause(10, argument(arg_denying_antecedent), true).
clause(11, implication(arg_denying_antecedent, key_present, door_opens), true).
clause(12, observed(arg_denying_antecedent, neg(key_present)), true).
clause(13, concludes(arg_denying_antecedent, neg(door_opens)), true).
clause(14, argument(arg_hasty_generalization), true).
clause(15, sample_size(arg_hasty_generalization, 3), true).
clause(16, required_sample_size(arg_hasty_generalization, 30), true).
clause(17, concludes(arg_hasty_generalization, all(crows, black)), true).
clause(18, argument(arg_false_dilemma), true).
clause(19, presented_alternatives(arg_false_dilemma, [approve_now, reject_forever]), true).
clause(20, omitted_alternative(arg_false_dilemma, revise_proposal), true).
clause(21, concludes(arg_false_dilemma, approve_now), true).
clause(26,
       fallacy(var('A'), affirming_consequent),
       (argument(var('A')),
        implication(var('A'), var('Antecedent'), var('Consequent')),
        observed(var('A'), var('Consequent')),
        concludes(var('A'), var('Antecedent')))).
clause(27,
       fallacy(var('A'), denying_antecedent),
       (argument(var('A')),
        implication(var('A'), var('Antecedent'), var('Consequent')),
        observed(var('A'), neg(var('Antecedent'))),
        concludes(var('A'), neg(var('Consequent'))))).
clause(28,
       fallacy(var('A'), hasty_generalization),
       (argument(var('A')),
        sample_size(var('A'), var('N')),
        required_sample_size(var('A'), var('Min')),
        var('N') < var('Min'),
        concludes(var('A'), all(anonymous(1), anonymous(2))))).
clause(29,
       fallacy(var('A'), false_dilemma),
       (argument(var('A')),
        presented_alternatives(var('A'), anonymous(1)),
        omitted_alternative(var('A'), anonymous(2)),
        concludes(var('A'), anonymous(3)))).
clause(30,
       reason_fact(arg_affirming_consequent, "observing the consequent does not prove the antecedent"),
       true).
clause(31,
       reason_fact(arg_denying_antecedent, "denying the antecedent does not disprove the consequent"),
       true).
clause(32,
       reason_fact(arg_hasty_generalization, "sample size is below the threshold for a universal conclusion"),
       true).
clause(33, reason_fact(arg_false_dilemma, "a relevant alternative is omitted"), true).
clause(34, type(var('A'), illegitimate_reasoning), fallacy(var('A'), anonymous(1))).
clause(35,
       conclusion(var('A'), var('C')),
       (fallacy(var('A'), anonymous(1)), concludes(var('A'), var('C')))).
clause(36,
       reason(var('A'), var('R')),
       (fallacy(var('A'), anonymous(1)), reason_fact(var('A'), var('R')))).
clause(37,
       sampleSize(var('A'), var('N')),
       (fallacy(var('A'), hasty_generalization), sample_size(var('A'), var('N')))).
clause(38,
       requiredSampleSize(var('A'), var('Min')),
       (fallacy(var('A'), hasty_generalization), required_sample_size(var('A'), var('Min')))).
clause(39,
       omittedAlternative(var('A'), var('Alt')),
       (fallacy(var('A'), false_dilemma), omitted_alternative(var('A'), var('Alt')))).

step(fallacy(arg_affirming_consequent, affirming_consequent),
     rule(26),
     ['A' = arg_affirming_consequent, 'Antecedent' = rain, 'Consequent' = street_wet],
     [argument(arg_affirming_consequent),
      implication(arg_affirming_consequent, rain, street_wet),
      observed(arg_affirming_consequent, street_wet),
      concludes(arg_affirming_consequent, rain)]).
step(argument(arg_affirming_consequent), fact(6), [], []).
step(implication(arg_affirming_consequent, rain, street_wet), fact(7), [], []).
step(observed(arg_affirming_consequent, street_wet), fact(8), [], []).
step(concludes(arg_affirming_consequent, rain), fact(9), [], []).
step(fallacy(arg_denying_antecedent, denying_antecedent),
     rule(27),
     ['A' = arg_denying_antecedent, 'Antecedent' = key_present, 'Consequent' = door_opens],
     [argument(arg_denying_antecedent),
      implication(arg_denying_antecedent, key_present, door_opens),
      observed(arg_denying_antecedent, neg(key_present)),
      concludes(arg_denying_antecedent, neg(door_opens))]).
step(argument(arg_denying_antecedent), fact(10), [], []).
step(implication(arg_denying_antecedent, key_present, door_opens), fact(11), [], []).
step(observed(arg_denying_antecedent, neg(key_present)), fact(12), [], []).
step(concludes(arg_denying_antecedent, neg(door_opens)), fact(13), [], []).
step(fallacy(arg_hasty_generalization, hasty_generalization),
     rule(28),
     ['A' = arg_hasty_generalization, 'N' = 3, 'Min' = 30],
     [argument(arg_hasty_generalization),
      sample_size(arg_hasty_generalization, 3),
      required_sample_size(arg_hasty_generalization, 30),
      3 < 30,
      concludes(arg_hasty_generalization, all(crows, black))]).
step(argument(arg_hasty_generalization), fact(14), [], []).
step(sample_size(arg_hasty_generalization, 3), fact(15), [], []).
step(required_sample_size(arg_hasty_generalization, 30), fact(16), [], []).
step(3 < 30, builtin, [], []).
step(concludes(arg_hasty_generalization, all(crows, black)), fact(17), [], []).
step(fallacy(arg_false_dilemma, false_dilemma),
     rule(29),
     ['A' = arg_false_dilemma],
     [argument(arg_false_dilemma),
      presented_alternatives(arg_false_dilemma, [approve_now, reject_forever]),
      omitted_alternative(arg_false_dilemma, revise_proposal),
      concludes(arg_false_dilemma, approve_now)]).
step(argument(arg_false_dilemma), fact(18), [], []).
step(presented_alternatives(arg_false_dilemma, [approve_now, reject_forever]), fact(19), [], []).
step(omitted_alternative(arg_false_dilemma, revise_proposal), fact(20), [], []).
step(concludes(arg_false_dilemma, approve_now), fact(21), [], []).
step(type(arg_affirming_consequent, illegitimate_reasoning),
     rule(34),
     ['A' = arg_affirming_consequent],
     [fallacy(arg_affirming_consequent, affirming_consequent)]).
step(type(arg_denying_antecedent, illegitimate_reasoning),
     rule(34),
     ['A' = arg_denying_antecedent],
     [fallacy(arg_denying_antecedent, denying_antecedent)]).
step(type(arg_hasty_generalization, illegitimate_reasoning),
     rule(34),
     ['A' = arg_hasty_generalization],
     [fallacy(arg_hasty_generalization, hasty_generalization)]).
step(type(arg_false_dilemma, illegitimate_reasoning),
     rule(34),
     ['A' = arg_false_dilemma],
     [fallacy(arg_false_dilemma, false_dilemma)]).
step(conclusion(arg_affirming_consequent, rain),
     rule(35),
     ['A' = arg_affirming_consequent, 'C' = rain],
     [fallacy(arg_affirming_consequent, affirming_consequent),
      concludes(arg_affirming_consequent, rain)]).
step(conclusion(arg_denying_antecedent, neg(door_opens)),
     rule(35),
     ['A' = arg_denying_antecedent, 'C' = neg(door_opens)],
     [fallacy(arg_denying_antecedent, denying_antecedent),
      concludes(arg_denying_antecedent, neg(door_opens))]).
step(conclusion(arg_hasty_generalization, all(crows, black)),
     rule(35),
     ['A' = arg_hasty_generalization, 'C' = all(crows, black)],
     [fallacy(arg_hasty_generalization, hasty_generalization),
      concludes(arg_hasty_generalization, all(crows, black))]).
step(conclusion(arg_false_dilemma, approve_now),
     rule(35),
     ['A' = arg_false_dilemma, 'C' = approve_now],
     [fallacy(arg_false_dilemma, false_dilemma), concludes(arg_false_dilemma, approve_now)]).
step(reason(arg_affirming_consequent, "observing the consequent does not prove the antecedent"),
     rule(36),
     ['A' = arg_affirming_consequent,
      'R' = "observing the consequent does not prove the antecedent"],
     [fallacy(arg_affirming_consequent, affirming_consequent),
      reason_fact(arg_affirming_consequent, "observing the consequent does not prove the antecedent")]).
step(reason_fact(arg_affirming_consequent, "observing the consequent does not prove the antecedent"),
     fact(30),
     [],
     []).
step(reason(arg_denying_antecedent, "denying the antecedent does not disprove the consequent"),
     rule(36),
     ['A' = arg_denying_antecedent,
      'R' = "denying the antecedent does not disprove the consequent"],
     [fallacy(arg_denying_antecedent, denying_antecedent),
      reason_fact(arg_denying_antecedent, "denying the antecedent does not disprove the consequent")]).
step(reason_fact(arg_denying_antecedent, "denying the antecedent does not disprove the consequent"),
     fact(31),
     [],
     []).
step(reason(arg_hasty_generalization, "sample size is below the threshold for a universal conclusion"),
     rule(36),
     ['A' = arg_hasty_generalization,
      'R' = "sample size is below the threshold for a universal conclusion"],
     [fallacy(arg_hasty_generalization, hasty_generalization),
      reason_fact(arg_hasty_generalization, "sample size is below the threshold for a universal conclusion")]).
step(reason_fact(arg_hasty_generalization, "sample size is below the threshold for a universal conclusion"),
     fact(32),
     [],
     []).
step(reason(arg_false_dilemma, "a relevant alternative is omitted"),
     rule(36),
     ['A' = arg_false_dilemma, 'R' = "a relevant alternative is omitted"],
     [fallacy(arg_false_dilemma, false_dilemma),
      reason_fact(arg_false_dilemma, "a relevant alternative is omitted")]).
step(reason_fact(arg_false_dilemma, "a relevant alternative is omitted"), fact(33), [], []).
step(sampleSize(arg_hasty_generalization, 3),
     rule(37),
     ['A' = arg_hasty_generalization, 'N' = 3],
     [fallacy(arg_hasty_generalization, hasty_generalization),
      sample_size(arg_hasty_generalization, 3)]).
step(requiredSampleSize(arg_hasty_generalization, 30),
     rule(38),
     ['A' = arg_hasty_generalization, 'Min' = 30],
     [fallacy(arg_hasty_generalization, hasty_generalization),
      required_sample_size(arg_hasty_generalization, 30)]).
step(omittedAlternative(arg_false_dilemma, revise_proposal),
     rule(39),
     ['A' = arg_false_dilemma, 'Alt' = revise_proposal],
     [fallacy(arg_false_dilemma, false_dilemma),
      omitted_alternative(arg_false_dilemma, revise_proposal)]).
