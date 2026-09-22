% Prolog result format 4
query(1, modal_truth(_0, _1, _2), ['X0' = _0, 'X1' = _1, 'X2' = _2]).
result(1, complete, 3).
answer(1, ['X0' = all_accessible_worlds_clear, 'X1' = w0, 'X2' = box(atom(clear))]).
answer(1, ['X0' = repair_is_possible, 'X1' = w0, 'X2' = diamond(atom(repaired))]).
answer(1, ['X0' = nested_possibility, 'X1' = w1, 'X2' = diamond(and(atom(clear), atom(clear)))]).
query(2, modal_countermodel(_0, _1), ['X0' = _0, 'X1' = _1]).
result(2, complete, 1).
answer(2, ['X0' = repair_not_necessary, 'X1' = w0]).
