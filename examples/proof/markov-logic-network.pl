mlnWeight(friend_smoking, log_weight_tenths(20)).
mlnWeight(smoking_causes_cancer, log_weight_tenths(13)).
mlnWeight(cancer_is_rare, log_weight_tenths(6)).
mlnWorld(w_bob_not_smokes_not_cancer, world(smokes(bob, no), cancer(bob, no))).
mlnWorld(w_bob_not_smokes_cancer, world(smokes(bob, no), cancer(bob, yes))).
mlnWorld(w_bob_smokes_not_cancer, world(smokes(bob, yes), cancer(bob, no))).
mlnWorld(w_bob_smokes_cancer, world(smokes(bob, yes), cancer(bob, yes))).
mlnSatisfied(w_bob_smokes_not_cancer, friend_smoking).
mlnSatisfied(w_bob_smokes_cancer, friend_smoking).
mlnSatisfied(w_bob_not_smokes_not_cancer, smoking_causes_cancer).
mlnSatisfied(w_bob_not_smokes_cancer, smoking_causes_cancer).
mlnSatisfied(w_bob_smokes_cancer, smoking_causes_cancer).
mlnSatisfied(w_bob_not_smokes_not_cancer, cancer_is_rare).
mlnSatisfied(w_bob_smokes_not_cancer, cancer_is_rare).
mlnViolated(w_bob_not_smokes_not_cancer, friend_smoking).
mlnViolated(w_bob_not_smokes_cancer, friend_smoking).
mlnViolated(w_bob_not_smokes_cancer, cancer_is_rare).
mlnViolated(w_bob_smokes_not_cancer, smoking_causes_cancer).
mlnViolated(w_bob_smokes_cancer, cancer_is_rare).
mlnContribution(w_bob_smokes_not_cancer, friend_smoking, log_weight_tenths(20)).
mlnContribution(w_bob_smokes_cancer, friend_smoking, log_weight_tenths(20)).
mlnContribution(w_bob_not_smokes_not_cancer, smoking_causes_cancer, log_weight_tenths(13)).
mlnContribution(w_bob_not_smokes_cancer, smoking_causes_cancer, log_weight_tenths(13)).
mlnContribution(w_bob_smokes_cancer, smoking_causes_cancer, log_weight_tenths(13)).
mlnContribution(w_bob_not_smokes_not_cancer, cancer_is_rare, log_weight_tenths(6)).
mlnContribution(w_bob_smokes_not_cancer, cancer_is_rare, log_weight_tenths(6)).
mlnWorldScore(w_bob_not_smokes_not_cancer, log_weight_tenths(19)).
mlnWorldScore(w_bob_not_smokes_cancer, log_weight_tenths(13)).
mlnWorldScore(w_bob_smokes_not_cancer, log_weight_tenths(26)).
mlnWorldScore(w_bob_smokes_cancer, log_weight_tenths(33)).
mlnMapWorld(w_bob_smokes_cancer, log_weight_tenths(33)).
mlnConclusion(case, "MAP world predicts that Bob smokes and has cancer").

clause(3, friend(alice, bob), true).
clause(4, observed_smokes(alice), true).
clause(5, candidate_world(w_bob_not_smokes_not_cancer, no, no), true).
clause(6, candidate_world(w_bob_not_smokes_cancer, no, yes), true).
clause(7, candidate_world(w_bob_smokes_not_cancer, yes, no), true).
clause(8, candidate_world(w_bob_smokes_cancer, yes, yes), true).
clause(9, formula_weight_tenths(friend_smoking, 20), true).
clause(10, formula_weight_tenths(smoking_causes_cancer, 13), true).
clause(11, formula_weight_tenths(cancer_is_rare, 6), true).
clause(12,
       smokes_in_world(var('World'), alice),
       (candidate_world(var('World'), anonymous(1), anonymous(2)), observed_smokes(alice))).
clause(13, smokes_in_world(var('World'), bob), candidate_world(var('World'), yes, anonymous(1))).
clause(14, cancer_in_world(var('World'), bob), candidate_world(var('World'), anonymous(1), yes)).
clause(15,
       formula_satisfied(var('World'), friend_smoking),
       (friend(alice, bob),
        smokes_in_world(var('World'), alice),
        smokes_in_world(var('World'), bob))).
clause(16,
       formula_satisfied(var('World'), smoking_causes_cancer),
       candidate_world(var('World'), no, anonymous(1))).
clause(17,
       formula_satisfied(var('World'), smoking_causes_cancer),
       (smokes_in_world(var('World'), bob), cancer_in_world(var('World'), bob))).
clause(18,
       formula_satisfied(var('World'), cancer_is_rare),
       candidate_world(var('World'), anonymous(1), no)).
clause(19,
       formula_violated(var('World'), var('Formula')),
       (candidate_world(var('World'), anonymous(1), anonymous(2)),
        formula_weight_tenths(var('Formula'), anonymous(3)),
        \+ formula_satisfied(var('World'), var('Formula')))).
clause(20,
       contribution_tenths(var('World'), var('Formula'), var('Weight')),
       (formula_satisfied(var('World'), var('Formula')),
        formula_weight_tenths(var('Formula'), var('Weight')))).
clause(21,
       world_score_tenths(var('World'), var('Score')),
       (candidate_world(var('World'), anonymous(1), anonymous(2)),
        sumall(var('Weight'), contribution_tenths(var('World'), anonymous(3), var('Weight')), var('Score')))).
clause(22,
       map_world(var('World'), var('Score')),
       aggregate_max(var('Candidate_score'), var('Candidate_world'), world_score_tenths(var('Candidate_world'), var('Candidate_score')), var('Score'), var('World'))).
clause(23,
       mlnWeight(var('Formula'), log_weight_tenths(var('Weight'))),
       formula_weight_tenths(var('Formula'), var('Weight'))).
clause(24,
       mlnWorld(var('World'), world(smokes(bob, var('Smokes')), cancer(bob, var('Cancer')))),
       candidate_world(var('World'), var('Smokes'), var('Cancer'))).
clause(25,
       mlnSatisfied(var('World'), var('Formula')),
       formula_satisfied(var('World'), var('Formula'))).
clause(26,
       mlnViolated(var('World'), var('Formula')),
       formula_violated(var('World'), var('Formula'))).
clause(27,
       mlnContribution(var('World'), var('Formula'), log_weight_tenths(var('Weight'))),
       contribution_tenths(var('World'), var('Formula'), var('Weight'))).
clause(28,
       mlnWorldScore(var('World'), log_weight_tenths(var('Score'))),
       world_score_tenths(var('World'), var('Score'))).
clause(29,
       mlnMapWorld(var('World'), log_weight_tenths(var('Score'))),
       map_world(var('World'), var('Score'))).
clause(30,
       mlnConclusion(case, "MAP world predicts that Bob smokes and has cancer"),
       map_world(w_bob_smokes_cancer, anonymous(1))).

step(mlnWeight(friend_smoking, log_weight_tenths(20)),
     rule(23),
     ['Formula' = friend_smoking, 'Weight' = 20],
     [formula_weight_tenths(friend_smoking, 20)]).
step(formula_weight_tenths(friend_smoking, 20), fact(9), [], []).
step(mlnWeight(smoking_causes_cancer, log_weight_tenths(13)),
     rule(23),
     ['Formula' = smoking_causes_cancer, 'Weight' = 13],
     [formula_weight_tenths(smoking_causes_cancer, 13)]).
step(formula_weight_tenths(smoking_causes_cancer, 13), fact(10), [], []).
step(mlnWeight(cancer_is_rare, log_weight_tenths(6)),
     rule(23),
     ['Formula' = cancer_is_rare, 'Weight' = 6],
     [formula_weight_tenths(cancer_is_rare, 6)]).
step(formula_weight_tenths(cancer_is_rare, 6), fact(11), [], []).
step(mlnWorld(w_bob_not_smokes_not_cancer, world(smokes(bob, no), cancer(bob, no))),
     rule(24),
     ['World' = w_bob_not_smokes_not_cancer, 'Smokes' = no, 'Cancer' = no],
     [candidate_world(w_bob_not_smokes_not_cancer, no, no)]).
step(candidate_world(w_bob_not_smokes_not_cancer, no, no), fact(5), [], []).
step(mlnWorld(w_bob_not_smokes_cancer, world(smokes(bob, no), cancer(bob, yes))),
     rule(24),
     ['World' = w_bob_not_smokes_cancer, 'Smokes' = no, 'Cancer' = yes],
     [candidate_world(w_bob_not_smokes_cancer, no, yes)]).
step(candidate_world(w_bob_not_smokes_cancer, no, yes), fact(6), [], []).
step(mlnWorld(w_bob_smokes_not_cancer, world(smokes(bob, yes), cancer(bob, no))),
     rule(24),
     ['World' = w_bob_smokes_not_cancer, 'Smokes' = yes, 'Cancer' = no],
     [candidate_world(w_bob_smokes_not_cancer, yes, no)]).
step(candidate_world(w_bob_smokes_not_cancer, yes, no), fact(7), [], []).
step(mlnWorld(w_bob_smokes_cancer, world(smokes(bob, yes), cancer(bob, yes))),
     rule(24),
     ['World' = w_bob_smokes_cancer, 'Smokes' = yes, 'Cancer' = yes],
     [candidate_world(w_bob_smokes_cancer, yes, yes)]).
step(candidate_world(w_bob_smokes_cancer, yes, yes), fact(8), [], []).
step(mlnSatisfied(w_bob_smokes_not_cancer, friend_smoking),
     rule(25),
     ['World' = w_bob_smokes_not_cancer, 'Formula' = friend_smoking],
     [formula_satisfied(w_bob_smokes_not_cancer, friend_smoking)]).
step(formula_satisfied(w_bob_smokes_not_cancer, friend_smoking),
     rule(15),
     ['World' = w_bob_smokes_not_cancer],
     [friend(alice, bob),
      smokes_in_world(w_bob_smokes_not_cancer, alice),
      smokes_in_world(w_bob_smokes_not_cancer, bob)]).
step(friend(alice, bob), fact(3), [], []).
step(smokes_in_world(w_bob_smokes_not_cancer, alice),
     rule(12),
     ['World' = w_bob_smokes_not_cancer],
     [candidate_world(w_bob_smokes_not_cancer, yes, no), observed_smokes(alice)]).
step(observed_smokes(alice), fact(4), [], []).
step(smokes_in_world(w_bob_smokes_not_cancer, bob),
     rule(13),
     ['World' = w_bob_smokes_not_cancer],
     [candidate_world(w_bob_smokes_not_cancer, yes, no)]).
step(mlnSatisfied(w_bob_smokes_cancer, friend_smoking),
     rule(25),
     ['World' = w_bob_smokes_cancer, 'Formula' = friend_smoking],
     [formula_satisfied(w_bob_smokes_cancer, friend_smoking)]).
step(formula_satisfied(w_bob_smokes_cancer, friend_smoking),
     rule(15),
     ['World' = w_bob_smokes_cancer],
     [friend(alice, bob),
      smokes_in_world(w_bob_smokes_cancer, alice),
      smokes_in_world(w_bob_smokes_cancer, bob)]).
step(smokes_in_world(w_bob_smokes_cancer, alice),
     rule(12),
     ['World' = w_bob_smokes_cancer],
     [candidate_world(w_bob_smokes_cancer, yes, yes), observed_smokes(alice)]).
step(smokes_in_world(w_bob_smokes_cancer, bob),
     rule(13),
     ['World' = w_bob_smokes_cancer],
     [candidate_world(w_bob_smokes_cancer, yes, yes)]).
step(mlnSatisfied(w_bob_not_smokes_not_cancer, smoking_causes_cancer),
     rule(25),
     ['World' = w_bob_not_smokes_not_cancer, 'Formula' = smoking_causes_cancer],
     [formula_satisfied(w_bob_not_smokes_not_cancer, smoking_causes_cancer)]).
step(formula_satisfied(w_bob_not_smokes_not_cancer, smoking_causes_cancer),
     rule(16),
     ['World' = w_bob_not_smokes_not_cancer],
     [candidate_world(w_bob_not_smokes_not_cancer, no, no)]).
step(mlnSatisfied(w_bob_not_smokes_cancer, smoking_causes_cancer),
     rule(25),
     ['World' = w_bob_not_smokes_cancer, 'Formula' = smoking_causes_cancer],
     [formula_satisfied(w_bob_not_smokes_cancer, smoking_causes_cancer)]).
step(formula_satisfied(w_bob_not_smokes_cancer, smoking_causes_cancer),
     rule(16),
     ['World' = w_bob_not_smokes_cancer],
     [candidate_world(w_bob_not_smokes_cancer, no, yes)]).
step(mlnSatisfied(w_bob_smokes_cancer, smoking_causes_cancer),
     rule(25),
     ['World' = w_bob_smokes_cancer, 'Formula' = smoking_causes_cancer],
     [formula_satisfied(w_bob_smokes_cancer, smoking_causes_cancer)]).
step(formula_satisfied(w_bob_smokes_cancer, smoking_causes_cancer),
     rule(17),
     ['World' = w_bob_smokes_cancer],
     [smokes_in_world(w_bob_smokes_cancer, bob), cancer_in_world(w_bob_smokes_cancer, bob)]).
step(cancer_in_world(w_bob_smokes_cancer, bob),
     rule(14),
     ['World' = w_bob_smokes_cancer],
     [candidate_world(w_bob_smokes_cancer, yes, yes)]).
step(mlnSatisfied(w_bob_not_smokes_not_cancer, cancer_is_rare),
     rule(25),
     ['World' = w_bob_not_smokes_not_cancer, 'Formula' = cancer_is_rare],
     [formula_satisfied(w_bob_not_smokes_not_cancer, cancer_is_rare)]).
step(formula_satisfied(w_bob_not_smokes_not_cancer, cancer_is_rare),
     rule(18),
     ['World' = w_bob_not_smokes_not_cancer],
     [candidate_world(w_bob_not_smokes_not_cancer, no, no)]).
step(mlnSatisfied(w_bob_smokes_not_cancer, cancer_is_rare),
     rule(25),
     ['World' = w_bob_smokes_not_cancer, 'Formula' = cancer_is_rare],
     [formula_satisfied(w_bob_smokes_not_cancer, cancer_is_rare)]).
step(formula_satisfied(w_bob_smokes_not_cancer, cancer_is_rare),
     rule(18),
     ['World' = w_bob_smokes_not_cancer],
     [candidate_world(w_bob_smokes_not_cancer, yes, no)]).
step(mlnViolated(w_bob_not_smokes_not_cancer, friend_smoking),
     rule(26),
     ['World' = w_bob_not_smokes_not_cancer, 'Formula' = friend_smoking],
     [formula_violated(w_bob_not_smokes_not_cancer, friend_smoking)]).
step(formula_violated(w_bob_not_smokes_not_cancer, friend_smoking),
     rule(19),
     ['World' = w_bob_not_smokes_not_cancer, 'Formula' = friend_smoking],
     [candidate_world(w_bob_not_smokes_not_cancer, no, no),
      formula_weight_tenths(friend_smoking, 20),
      \+ formula_satisfied(w_bob_not_smokes_not_cancer, friend_smoking)]).
step(\+ formula_satisfied(w_bob_not_smokes_not_cancer, friend_smoking), absent, [], []).
step(mlnViolated(w_bob_not_smokes_cancer, friend_smoking),
     rule(26),
     ['World' = w_bob_not_smokes_cancer, 'Formula' = friend_smoking],
     [formula_violated(w_bob_not_smokes_cancer, friend_smoking)]).
step(formula_violated(w_bob_not_smokes_cancer, friend_smoking),
     rule(19),
     ['World' = w_bob_not_smokes_cancer, 'Formula' = friend_smoking],
     [candidate_world(w_bob_not_smokes_cancer, no, yes),
      formula_weight_tenths(friend_smoking, 20),
      \+ formula_satisfied(w_bob_not_smokes_cancer, friend_smoking)]).
step(\+ formula_satisfied(w_bob_not_smokes_cancer, friend_smoking), absent, [], []).
step(mlnViolated(w_bob_not_smokes_cancer, cancer_is_rare),
     rule(26),
     ['World' = w_bob_not_smokes_cancer, 'Formula' = cancer_is_rare],
     [formula_violated(w_bob_not_smokes_cancer, cancer_is_rare)]).
step(formula_violated(w_bob_not_smokes_cancer, cancer_is_rare),
     rule(19),
     ['World' = w_bob_not_smokes_cancer, 'Formula' = cancer_is_rare],
     [candidate_world(w_bob_not_smokes_cancer, no, yes),
      formula_weight_tenths(cancer_is_rare, 6),
      \+ formula_satisfied(w_bob_not_smokes_cancer, cancer_is_rare)]).
step(\+ formula_satisfied(w_bob_not_smokes_cancer, cancer_is_rare), absent, [], []).
step(mlnViolated(w_bob_smokes_not_cancer, smoking_causes_cancer),
     rule(26),
     ['World' = w_bob_smokes_not_cancer, 'Formula' = smoking_causes_cancer],
     [formula_violated(w_bob_smokes_not_cancer, smoking_causes_cancer)]).
step(formula_violated(w_bob_smokes_not_cancer, smoking_causes_cancer),
     rule(19),
     ['World' = w_bob_smokes_not_cancer, 'Formula' = smoking_causes_cancer],
     [candidate_world(w_bob_smokes_not_cancer, yes, no),
      formula_weight_tenths(smoking_causes_cancer, 13),
      \+ formula_satisfied(w_bob_smokes_not_cancer, smoking_causes_cancer)]).
step(\+ formula_satisfied(w_bob_smokes_not_cancer, smoking_causes_cancer), absent, [], []).
step(mlnViolated(w_bob_smokes_cancer, cancer_is_rare),
     rule(26),
     ['World' = w_bob_smokes_cancer, 'Formula' = cancer_is_rare],
     [formula_violated(w_bob_smokes_cancer, cancer_is_rare)]).
step(formula_violated(w_bob_smokes_cancer, cancer_is_rare),
     rule(19),
     ['World' = w_bob_smokes_cancer, 'Formula' = cancer_is_rare],
     [candidate_world(w_bob_smokes_cancer, yes, yes),
      formula_weight_tenths(cancer_is_rare, 6),
      \+ formula_satisfied(w_bob_smokes_cancer, cancer_is_rare)]).
step(\+ formula_satisfied(w_bob_smokes_cancer, cancer_is_rare), absent, [], []).
step(mlnContribution(w_bob_smokes_not_cancer, friend_smoking, log_weight_tenths(20)),
     rule(27),
     ['World' = w_bob_smokes_not_cancer, 'Formula' = friend_smoking, 'Weight' = 20],
     [contribution_tenths(w_bob_smokes_not_cancer, friend_smoking, 20)]).
step(contribution_tenths(w_bob_smokes_not_cancer, friend_smoking, 20),
     rule(20),
     ['World' = w_bob_smokes_not_cancer, 'Formula' = friend_smoking, 'Weight' = 20],
     [formula_satisfied(w_bob_smokes_not_cancer, friend_smoking),
      formula_weight_tenths(friend_smoking, 20)]).
step(mlnContribution(w_bob_smokes_cancer, friend_smoking, log_weight_tenths(20)),
     rule(27),
     ['World' = w_bob_smokes_cancer, 'Formula' = friend_smoking, 'Weight' = 20],
     [contribution_tenths(w_bob_smokes_cancer, friend_smoking, 20)]).
step(contribution_tenths(w_bob_smokes_cancer, friend_smoking, 20),
     rule(20),
     ['World' = w_bob_smokes_cancer, 'Formula' = friend_smoking, 'Weight' = 20],
     [formula_satisfied(w_bob_smokes_cancer, friend_smoking),
      formula_weight_tenths(friend_smoking, 20)]).
step(mlnContribution(w_bob_not_smokes_not_cancer, smoking_causes_cancer, log_weight_tenths(13)),
     rule(27),
     ['World' = w_bob_not_smokes_not_cancer, 'Formula' = smoking_causes_cancer, 'Weight' = 13],
     [contribution_tenths(w_bob_not_smokes_not_cancer, smoking_causes_cancer, 13)]).
step(contribution_tenths(w_bob_not_smokes_not_cancer, smoking_causes_cancer, 13),
     rule(20),
     ['World' = w_bob_not_smokes_not_cancer, 'Formula' = smoking_causes_cancer, 'Weight' = 13],
     [formula_satisfied(w_bob_not_smokes_not_cancer, smoking_causes_cancer),
      formula_weight_tenths(smoking_causes_cancer, 13)]).
step(mlnContribution(w_bob_not_smokes_cancer, smoking_causes_cancer, log_weight_tenths(13)),
     rule(27),
     ['World' = w_bob_not_smokes_cancer, 'Formula' = smoking_causes_cancer, 'Weight' = 13],
     [contribution_tenths(w_bob_not_smokes_cancer, smoking_causes_cancer, 13)]).
step(contribution_tenths(w_bob_not_smokes_cancer, smoking_causes_cancer, 13),
     rule(20),
     ['World' = w_bob_not_smokes_cancer, 'Formula' = smoking_causes_cancer, 'Weight' = 13],
     [formula_satisfied(w_bob_not_smokes_cancer, smoking_causes_cancer),
      formula_weight_tenths(smoking_causes_cancer, 13)]).
step(mlnContribution(w_bob_smokes_cancer, smoking_causes_cancer, log_weight_tenths(13)),
     rule(27),
     ['World' = w_bob_smokes_cancer, 'Formula' = smoking_causes_cancer, 'Weight' = 13],
     [contribution_tenths(w_bob_smokes_cancer, smoking_causes_cancer, 13)]).
step(contribution_tenths(w_bob_smokes_cancer, smoking_causes_cancer, 13),
     rule(20),
     ['World' = w_bob_smokes_cancer, 'Formula' = smoking_causes_cancer, 'Weight' = 13],
     [formula_satisfied(w_bob_smokes_cancer, smoking_causes_cancer),
      formula_weight_tenths(smoking_causes_cancer, 13)]).
step(mlnContribution(w_bob_not_smokes_not_cancer, cancer_is_rare, log_weight_tenths(6)),
     rule(27),
     ['World' = w_bob_not_smokes_not_cancer, 'Formula' = cancer_is_rare, 'Weight' = 6],
     [contribution_tenths(w_bob_not_smokes_not_cancer, cancer_is_rare, 6)]).
step(contribution_tenths(w_bob_not_smokes_not_cancer, cancer_is_rare, 6),
     rule(20),
     ['World' = w_bob_not_smokes_not_cancer, 'Formula' = cancer_is_rare, 'Weight' = 6],
     [formula_satisfied(w_bob_not_smokes_not_cancer, cancer_is_rare),
      formula_weight_tenths(cancer_is_rare, 6)]).
step(mlnContribution(w_bob_smokes_not_cancer, cancer_is_rare, log_weight_tenths(6)),
     rule(27),
     ['World' = w_bob_smokes_not_cancer, 'Formula' = cancer_is_rare, 'Weight' = 6],
     [contribution_tenths(w_bob_smokes_not_cancer, cancer_is_rare, 6)]).
step(contribution_tenths(w_bob_smokes_not_cancer, cancer_is_rare, 6),
     rule(20),
     ['World' = w_bob_smokes_not_cancer, 'Formula' = cancer_is_rare, 'Weight' = 6],
     [formula_satisfied(w_bob_smokes_not_cancer, cancer_is_rare),
      formula_weight_tenths(cancer_is_rare, 6)]).
step(mlnWorldScore(w_bob_not_smokes_not_cancer, log_weight_tenths(19)),
     rule(28),
     ['World' = w_bob_not_smokes_not_cancer, 'Score' = 19],
     [world_score_tenths(w_bob_not_smokes_not_cancer, 19)]).
step(world_score_tenths(w_bob_not_smokes_not_cancer, 19),
     rule(21),
     ['World' = w_bob_not_smokes_not_cancer, 'Score' = 19],
     [candidate_world(w_bob_not_smokes_not_cancer, no, no),
      sumall(Expression, contribution_tenths(w_bob_not_smokes_not_cancer, _Formula, Expression), 19)]).
step(sumall(Expression, contribution_tenths(w_bob_not_smokes_not_cancer, _Formula, Expression), 19),
     builtin,
     [],
     []).
step(mlnWorldScore(w_bob_not_smokes_cancer, log_weight_tenths(13)),
     rule(28),
     ['World' = w_bob_not_smokes_cancer, 'Score' = 13],
     [world_score_tenths(w_bob_not_smokes_cancer, 13)]).
step(world_score_tenths(w_bob_not_smokes_cancer, 13),
     rule(21),
     ['World' = w_bob_not_smokes_cancer, 'Score' = 13],
     [candidate_world(w_bob_not_smokes_cancer, no, yes),
      sumall(Expression, contribution_tenths(w_bob_not_smokes_cancer, _Formula, Expression), 13)]).
step(sumall(Expression, contribution_tenths(w_bob_not_smokes_cancer, _Formula, Expression), 13),
     builtin,
     [],
     []).
step(mlnWorldScore(w_bob_smokes_not_cancer, log_weight_tenths(26)),
     rule(28),
     ['World' = w_bob_smokes_not_cancer, 'Score' = 26],
     [world_score_tenths(w_bob_smokes_not_cancer, 26)]).
step(world_score_tenths(w_bob_smokes_not_cancer, 26),
     rule(21),
     ['World' = w_bob_smokes_not_cancer, 'Score' = 26],
     [candidate_world(w_bob_smokes_not_cancer, yes, no),
      sumall(Expression, contribution_tenths(w_bob_smokes_not_cancer, _Formula, Expression), 26)]).
step(sumall(Expression, contribution_tenths(w_bob_smokes_not_cancer, _Formula, Expression), 26),
     builtin,
     [],
     []).
step(mlnWorldScore(w_bob_smokes_cancer, log_weight_tenths(33)),
     rule(28),
     ['World' = w_bob_smokes_cancer, 'Score' = 33],
     [world_score_tenths(w_bob_smokes_cancer, 33)]).
step(world_score_tenths(w_bob_smokes_cancer, 33),
     rule(21),
     ['World' = w_bob_smokes_cancer, 'Score' = 33],
     [candidate_world(w_bob_smokes_cancer, yes, yes),
      sumall(Expression, contribution_tenths(w_bob_smokes_cancer, _Formula, Expression), 33)]).
step(sumall(Expression, contribution_tenths(w_bob_smokes_cancer, _Formula, Expression), 33),
     builtin,
     [],
     []).
step(mlnMapWorld(w_bob_smokes_cancer, log_weight_tenths(33)),
     rule(29),
     ['World' = w_bob_smokes_cancer, 'Score' = 33],
     [map_world(w_bob_smokes_cancer, 33)]).
step(map_world(w_bob_smokes_cancer, 33),
     rule(22),
     ['World' = w_bob_smokes_cancer, 'Score' = 33],
     [aggregate_max(Key, Value, world_score_tenths(Value, Key), 33, w_bob_smokes_cancer)]).
step(aggregate_max(Key, Value, world_score_tenths(Value, Key), 33, w_bob_smokes_cancer),
     builtin,
     [],
     []).
step(mlnConclusion(case, "MAP world predicts that Bob smokes and has cancer"),
     rule(30),
     [],
     [map_world(w_bob_smokes_cancer, 33)]).
