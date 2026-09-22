% Prolog result format 4
query(1, intuitionistic_truth(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(1, complete, 3).
answer(1, ['X0' = monotone_p_reaches_both, 'X1' = both, 'X2' = atom(p)]).
answer(1,
       ['X0' = constructive_case_analysis,
        'X1' = root,
        'X2' = implies(atom(p), or(atom(p), atom(q)))]).
answer(1,
       ['X0' = double_negated_branch_information,
        'X1' = root,
        'X2' = neg(neg(or(atom(p), atom(q))))]).
query(2, intuitionistic_countermodel(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(2, complete, 2).
answer(2, ['X0' = root_does_not_decide_branch, 'X1' = root, 'X2' = or(atom(p), atom(q))]).
answer(2, ['X0' = excluded_middle_not_forced, 'X1' = root, 'X2' = or(atom(p), neg(atom(p)))]).
