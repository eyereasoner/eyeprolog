condition('C1', resolution, ok, 70).
condition('C2', well_founded, ok, 80).
condition('C3', justification, ok, 80).
condition('C4', coverage, ok, 121).
condition('C5', re_decision, ok, 0).
obligation(absent, theory_scoped, \+ formula_satisfied(w_bob_not_smokes_not_cancer, friend_smoking)).
obligation(absent, theory_scoped, \+ formula_satisfied(w_bob_not_smokes_cancer, friend_smoking)).
obligation(absent, theory_scoped, \+ formula_satisfied(w_bob_not_smokes_cancer, cancer_is_rare)).
obligation(absent, theory_scoped, \+ formula_satisfied(w_bob_smokes_not_cancer, smoking_causes_cancer)).
obligation(absent, theory_scoped, \+ formula_satisfied(w_bob_smokes_cancer, cancer_is_rare)).
obligation(builtin, theory_scoped, sumall(Expression, contribution_tenths(w_bob_not_smokes_not_cancer, _Formula, Expression), 19)).
obligation(builtin, theory_scoped, sumall(Expression, contribution_tenths(w_bob_not_smokes_cancer, _Formula, Expression), 13)).
obligation(builtin, theory_scoped, sumall(Expression, contribution_tenths(w_bob_smokes_not_cancer, _Formula, Expression), 26)).
obligation(builtin, theory_scoped, sumall(Expression, contribution_tenths(w_bob_smokes_cancer, _Formula, Expression), 33)).
obligation(builtin, theory_scoped, aggregate_max(Key, Value, world_score_tenths(Value, Key), 33, w_bob_smokes_cancer)).
steps(80).
verified(70).
recomputed(0).
composed(0).
trusted(10).
claims(32).
verdict(checked_with_obligations).
