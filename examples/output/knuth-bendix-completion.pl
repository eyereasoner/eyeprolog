% Prolog result format 4
query(1, kbAnswer(_0, _1), ['X0' = _0, 'X1' = _1]).
result(1, complete, 7).
answer(1, ['X0' = sample_normal_form, 'X1' = append(a, append(b, c))]).
answer(1, ['X0' = joined_critical_pair, 'X1' = left_identity_assoc]).
answer(1, ['X0' = joined_critical_pair, 'X1' = right_identity_assoc]).
answer(1, ['X0' = joined_critical_pair, 'X1' = nested_assoc]).
answer(1, ['X0' = oriented_rule_count, 'X1' = 3]).
answer(1, ['X0' = joined_critical_pair_count, 'X1' = 3]).
answer(1,
       ['X0' = note,
        'X1' = "a bounded completion check proves the selected critical pairs join"]).
