intuitionistic_truth(monotone_p_reaches_both, both, atom(p)).
intuitionistic_truth(constructive_case_analysis, root, implies(atom(p), or(atom(p), atom(q)))).
intuitionistic_truth(double_negated_branch_information, root, neg(neg(or(atom(p), atom(q))))).
intuitionistic_countermodel(root_does_not_decide_branch, root, or(atom(p), atom(q))).
intuitionistic_countermodel(excluded_middle_not_forced, root, or(atom(p), neg(atom(p)))).
