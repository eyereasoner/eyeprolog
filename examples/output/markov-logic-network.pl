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
