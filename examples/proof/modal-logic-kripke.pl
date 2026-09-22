% Prolog result format 4
query(1, modal_truth(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(1, complete, 3).
answer(1, ['X0' = all_accessible_worlds_clear, 'X1' = w0, 'X2' = box(atom(clear))]).
why(1,
    ['X0' = all_accessible_worlds_clear, 'X1' = w0, 'X2' = box(atom(clear))],
    [modal_truth(all_accessible_worlds_clear, w0, box(atom(clear)))]).
answer(1, ['X0' = repair_is_possible, 'X1' = w0, 'X2' = diamond(atom(repaired))]).
why(1,
    ['X0' = repair_is_possible, 'X1' = w0, 'X2' = diamond(atom(repaired))],
    [modal_truth(repair_is_possible, w0, diamond(atom(repaired)))]).
answer(1, ['X0' = nested_possibility, 'X1' = w1, 'X2' = diamond(and(atom(clear), atom(clear)))]).
why(1,
    ['X0' = nested_possibility, 'X1' = w1, 'X2' = diamond(and(atom(clear), atom(clear)))],
    [modal_truth(nested_possibility, w1, diamond(and(atom(clear), atom(clear))))]).
query(2, modal_countermodel(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = repair_not_necessary, 'X1' = w0]).
why(2, ['X0' = repair_not_necessary, 'X1' = w0], [modal_countermodel(repair_not_necessary, w0)]).

clause(1, world(w0), true).
clause(6, accessible(w0, w2), true).
clause(7, accessible(w1, w1), true).
clause(11, true_at(w1, clear), true).
clause(14, true_at(w2, repaired), true).
clause(16, mforces(var('World'), atom(var('Prop'))), true_at(var('World'), var('Prop'))).
clause(17,
       mforces(var('World'), and(var('Left'), var('Right'))),
       (mforces(var('World'), var('Left')), mforces(var('World'), var('Right')))).
clause(18,
       mforces(var('World'), diamond(var('Formula'))),
       (accessible(var('World'), var('Next')), mforces(var('Next'), var('Formula')))).
clause(19,
       mforces(var('World'), box(var('Formula'))),
       (world(var('World')), \+ box_counterexample(var('World'), var('Formula')))).
clause(21,
       modal_truth(all_accessible_worlds_clear, w0, box(atom(clear))),
       mforces(w0, box(atom(clear)))).
clause(22,
       modal_truth(repair_is_possible, w0, diamond(atom(repaired))),
       mforces(w0, diamond(atom(repaired)))).
clause(23,
       modal_truth(nested_possibility, w1, diamond(and(atom(clear), atom(clear)))),
       mforces(w1, diamond(and(atom(clear), atom(clear))))).
clause(24, modal_countermodel(repair_not_necessary, w0), \+ mforces(w0, box(atom(repaired)))).

step(modal_truth(all_accessible_worlds_clear, w0, box(atom(clear))),
     rule(21),
     [],
     [mforces(w0, box(atom(clear)))]).
step(mforces(w0, box(atom(clear))),
     rule(19),
     ['World' = w0, 'Formula' = atom(clear)],
     [world(w0), \+ box_counterexample(w0, atom(clear))]).
step(world(w0), fact(1), [], []).
step(\+ box_counterexample(w0, atom(clear)), absent, [], []).
step(modal_truth(repair_is_possible, w0, diamond(atom(repaired))),
     rule(22),
     [],
     [mforces(w0, diamond(atom(repaired)))]).
step(mforces(w0, diamond(atom(repaired))),
     rule(18),
     ['World' = w0, 'Formula' = atom(repaired), 'Next' = w2],
     [accessible(w0, w2), mforces(w2, atom(repaired))]).
step(accessible(w0, w2), fact(6), [], []).
step(mforces(w2, atom(repaired)),
     rule(16),
     ['World' = w2, 'Prop' = repaired],
     [true_at(w2, repaired)]).
step(true_at(w2, repaired), fact(14), [], []).
step(modal_truth(nested_possibility, w1, diamond(and(atom(clear), atom(clear)))),
     rule(23),
     [],
     [mforces(w1, diamond(and(atom(clear), atom(clear))))]).
step(mforces(w1, diamond(and(atom(clear), atom(clear)))),
     rule(18),
     ['World' = w1, 'Formula' = and(atom(clear), atom(clear)), 'Next' = w1],
     [accessible(w1, w1), mforces(w1, and(atom(clear), atom(clear)))]).
step(accessible(w1, w1), fact(7), [], []).
step(mforces(w1, and(atom(clear), atom(clear))),
     rule(17),
     ['World' = w1, 'Left' = atom(clear), 'Right' = atom(clear)],
     [mforces(w1, atom(clear)), mforces(w1, atom(clear))]).
step(mforces(w1, atom(clear)), rule(16), ['World' = w1, 'Prop' = clear], [true_at(w1, clear)]).
step(true_at(w1, clear), fact(11), [], []).
step(modal_countermodel(repair_not_necessary, w0),
     rule(24),
     [],
     [\+ mforces(w0, box(atom(repaired)))]).
step(\+ mforces(w0, box(atom(repaired))), absent, [], []).
