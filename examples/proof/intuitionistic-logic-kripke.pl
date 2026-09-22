% Prolog result format 4
query(1, intuitionistic_truth(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(1, complete, 3).
answer(1, ['X0' = monotone_p_reaches_both, 'X1' = both, 'X2' = atom(p)]).
why(1,
    ['X0' = monotone_p_reaches_both, 'X1' = both, 'X2' = atom(p)],
    [intuitionistic_truth(monotone_p_reaches_both, both, atom(p))]).
answer(1,
       ['X0' = constructive_case_analysis,
        'X1' = root,
        'X2' = implies(atom(p), or(atom(p), atom(q)))]).
why(1,
    ['X0' = constructive_case_analysis,
     'X1' = root,
     'X2' = implies(atom(p), or(atom(p), atom(q)))],
    [intuitionistic_truth(constructive_case_analysis, root, implies(atom(p), or(atom(p), atom(q))))]).
answer(1,
       ['X0' = double_negated_branch_information,
        'X1' = root,
        'X2' = neg(neg(or(atom(p), atom(q))))]).
why(1,
    ['X0' = double_negated_branch_information,
     'X1' = root,
     'X2' = neg(neg(or(atom(p), atom(q))))],
    [intuitionistic_truth(double_negated_branch_information, root, neg(neg(or(atom(p), atom(q)))))]).
query(2, intuitionistic_countermodel(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(2, complete, 2).
answer(2, ['X0' = root_does_not_decide_branch, 'X1' = root, 'X2' = or(atom(p), atom(q))]).
why(2,
    ['X0' = root_does_not_decide_branch, 'X1' = root, 'X2' = or(atom(p), atom(q))],
    [intuitionistic_countermodel(root_does_not_decide_branch, root, or(atom(p), atom(q)))]).
answer(2, ['X0' = excluded_middle_not_forced, 'X1' = root, 'X2' = or(atom(p), neg(atom(p)))]).
why(2,
    ['X0' = excluded_middle_not_forced, 'X1' = root, 'X2' = or(atom(p), neg(atom(p)))],
    [intuitionistic_countermodel(excluded_middle_not_forced, root, or(atom(p), neg(atom(p))))]).

clause(1, world(root), true).
clause(4, world(both), true).
clause(7, step(left, both), true).
clause(9, base(left, p), true).
clause(11, leq(var('World'), var('World')), world(var('World'))).
clause(12,
       leq(var('From'), var('To')),
       (step(var('From'), var('Mid')), leq(var('Mid'), var('To')))).
clause(13,
       forces(var('World'), atom(var('Prop'))),
       (leq(var('Someworld'), var('World')), base(var('Someworld'), var('Prop')))).
clause(17,
       forces(var('World'), implies(var('Left'), var('Right'))),
       (world(var('World')), \+ bad_implication(var('World'), var('Left'), var('Right')))).
clause(18,
       forces(var('World'), neg(var('Formula'))),
       forces(var('World'), implies(var('Formula'), bottom))).
clause(20, intuitionistic_truth(monotone_p_reaches_both, both, atom(p)), forces(both, atom(p))).
clause(21,
       intuitionistic_truth(constructive_case_analysis, root, implies(atom(p), or(atom(p), atom(q)))),
       forces(root, implies(atom(p), or(atom(p), atom(q))))).
clause(22,
       intuitionistic_truth(double_negated_branch_information, root, neg(neg(or(atom(p), atom(q))))),
       forces(root, neg(neg(or(atom(p), atom(q)))))).
clause(23,
       intuitionistic_countermodel(root_does_not_decide_branch, root, or(atom(p), atom(q))),
       \+ forces(root, or(atom(p), atom(q)))).
clause(24,
       intuitionistic_countermodel(excluded_middle_not_forced, root, or(atom(p), neg(atom(p)))),
       \+ forces(root, or(atom(p), neg(atom(p))))).

step(intuitionistic_truth(monotone_p_reaches_both, both, atom(p)),
     rule(20),
     [],
     [forces(both, atom(p))]).
step(forces(both, atom(p)),
     rule(13),
     ['World' = both, 'Prop' = p, 'Someworld' = left],
     [leq(left, both), base(left, p)]).
step(leq(left, both),
     rule(12),
     ['From' = left, 'To' = both, 'Mid' = both],
     [step(left, both), leq(both, both)]).
step(step(left, both), fact(7), [], []).
step(leq(both, both), rule(11), ['World' = both], [world(both)]).
step(world(both), fact(4), [], []).
step(base(left, p), fact(9), [], []).
step(intuitionistic_truth(constructive_case_analysis, root, implies(atom(p), or(atom(p), atom(q)))),
     rule(21),
     [],
     [forces(root, implies(atom(p), or(atom(p), atom(q))))]).
step(forces(root, implies(atom(p), or(atom(p), atom(q)))),
     rule(17),
     ['World' = root, 'Left' = atom(p), 'Right' = or(atom(p), atom(q))],
     [world(root), \+ bad_implication(root, atom(p), or(atom(p), atom(q)))]).
step(world(root), fact(1), [], []).
step(\+ bad_implication(root, atom(p), or(atom(p), atom(q))), absent, [], []).
step(intuitionistic_truth(double_negated_branch_information, root, neg(neg(or(atom(p), atom(q))))),
     rule(22),
     [],
     [forces(root, neg(neg(or(atom(p), atom(q)))))]).
step(forces(root, neg(neg(or(atom(p), atom(q))))),
     rule(18),
     ['World' = root, 'Formula' = neg(or(atom(p), atom(q)))],
     [forces(root, implies(neg(or(atom(p), atom(q))), bottom))]).
step(forces(root, implies(neg(or(atom(p), atom(q))), bottom)),
     rule(17),
     ['World' = root, 'Left' = neg(or(atom(p), atom(q))), 'Right' = bottom],
     [world(root), \+ bad_implication(root, neg(or(atom(p), atom(q))), bottom)]).
step(\+ bad_implication(root, neg(or(atom(p), atom(q))), bottom), absent, [], []).
step(intuitionistic_countermodel(root_does_not_decide_branch, root, or(atom(p), atom(q))),
     rule(23),
     [],
     [\+ forces(root, or(atom(p), atom(q)))]).
step(\+ forces(root, or(atom(p), atom(q))), absent, [], []).
step(intuitionistic_countermodel(excluded_middle_not_forced, root, or(atom(p), neg(atom(p)))),
     rule(24),
     [],
     [\+ forces(root, or(atom(p), neg(atom(p))))]).
step(\+ forces(root, or(atom(p), neg(atom(p)))), absent, [], []).
