kbAnswer(sample_normal_form, append(a, append(b, c))).
kbAnswer(joined_critical_pair, left_identity_assoc).
kbAnswer(joined_critical_pair, right_identity_assoc).
kbAnswer(joined_critical_pair, nested_assoc).
kbAnswer(oriented_rule_count, 3).
kbAnswer(joined_critical_pair_count, 3).
kbAnswer(note, "a bounded completion check proves the selected critical pairs join").

clause(1, oriented_rule(left_identity, append(nil, var('X')), var('X')), true).
clause(3,
       oriented_rule(associate_right, append(append(var('X'), var('Y')), var('Z')), append(var('X'), append(var('Y'), var('Z')))),
       true).
clause(4,
       rewrite_once(var('In'), var('Out'), var('Rule')),
       oriented_rule(var('Rule'), var('In'), var('Out'))).
clause(6,
       rewrite_once(append(var('A'), var('B')), append(var('A'), var('New_b')), var('Rule')),
       rewrite_once(var('B'), var('New_b'), var('Rule'))).
clause(7,
       normal_form(var('Term'), var('Term')),
       \+ rewrite_once(var('Term'), anonymous(1), anonymous(2))).
clause(8,
       normal_form(var('Term'), var('Normal')),
       (rewrite_once(var('Term'), var('Next'), anonymous(1)),
        normal_form(var('Next'), var('Normal')))).
clause(9, critical_pair(left_identity_assoc, append(a, b), append(nil, append(a, b))), true).
clause(10, critical_pair(right_identity_assoc, append(a, b), append(a, append(nil, b))), true).
clause(11,
       critical_pair(nested_assoc, append(append(a, append(b, c)), d), append(append(a, b), append(c, d))),
       true).
clause(12,
       joined_pair(var('Name')),
       (critical_pair(var('Name'), var('Left'), var('Right')),
        normal_form(var('Left'), var('Normal')),
        normal_form(var('Right'), var('Normal')))).
clause(13, sample_term(append(append(nil, append(a, nil)), append(b, c))), true).
clause(14,
       kbAnswer(sample_normal_form, var('Normal')),
       (sample_term(var('Term')), normal_form(var('Term'), var('Normal')))).
clause(15, kbAnswer(joined_critical_pair, var('Name')), joined_pair(var('Name'))).
clause(16,
       kbAnswer(oriented_rule_count, var('Count')),
       countall(oriented_rule(anonymous(1), anonymous(2), anonymous(3)), var('Count'))).
clause(17,
       kbAnswer(joined_critical_pair_count, var('Count')),
       countall(joined_pair(anonymous(1)), var('Count'))).
clause(18,
       kbAnswer(note, "a bounded completion check proves the selected critical pairs join"),
       joined_pair(nested_assoc)).

step(kbAnswer(sample_normal_form, append(a, append(b, c))),
     rule(14),
     ['Normal' = append(a, append(b, c)),
      'Term' = append(append(nil, append(a, nil)), append(b, c))],
     [sample_term(append(append(nil, append(a, nil)), append(b, c))),
      normal_form(append(append(nil, append(a, nil)), append(b, c)), append(a, append(b, c)))]).
step(sample_term(append(append(nil, append(a, nil)), append(b, c))), fact(13), [], []).
step(normal_form(append(append(nil, append(a, nil)), append(b, c)), append(a, append(b, c))),
     rule(8),
     ['Term' = append(append(nil, append(a, nil)), append(b, c)),
      'Normal' = append(a, append(b, c)),
      'Next' = append(nil, append(append(a, nil), append(b, c)))],
     [rewrite_once(append(append(nil, append(a, nil)), append(b, c)), append(nil, append(append(a, nil), append(b, c))), associate_right),
      normal_form(append(nil, append(append(a, nil), append(b, c))), append(a, append(b, c)))]).
step(rewrite_once(append(append(nil, append(a, nil)), append(b, c)), append(nil, append(append(a, nil), append(b, c))), associate_right),
     rule(4),
     ['In' = append(append(nil, append(a, nil)), append(b, c)),
      'Out' = append(nil, append(append(a, nil), append(b, c))),
      'Rule' = associate_right],
     [oriented_rule(associate_right, append(append(nil, append(a, nil)), append(b, c)), append(nil, append(append(a, nil), append(b, c))))]).
step(oriented_rule(associate_right, append(append(nil, append(a, nil)), append(b, c)), append(nil, append(append(a, nil), append(b, c)))),
     fact(3),
     ['X' = nil, 'Y' = append(a, nil), 'Z' = append(b, c)],
     []).
step(normal_form(append(nil, append(append(a, nil), append(b, c))), append(a, append(b, c))),
     rule(8),
     ['Term' = append(nil, append(append(a, nil), append(b, c))),
      'Normal' = append(a, append(b, c)),
      'Next' = append(append(a, nil), append(b, c))],
     [rewrite_once(append(nil, append(append(a, nil), append(b, c))), append(append(a, nil), append(b, c)), left_identity),
      normal_form(append(append(a, nil), append(b, c)), append(a, append(b, c)))]).
step(rewrite_once(append(nil, append(append(a, nil), append(b, c))), append(append(a, nil), append(b, c)), left_identity),
     rule(4),
     ['In' = append(nil, append(append(a, nil), append(b, c))),
      'Out' = append(append(a, nil), append(b, c)),
      'Rule' = left_identity],
     [oriented_rule(left_identity, append(nil, append(append(a, nil), append(b, c))), append(append(a, nil), append(b, c)))]).
step(oriented_rule(left_identity, append(nil, append(append(a, nil), append(b, c))), append(append(a, nil), append(b, c))),
     fact(1),
     ['X' = append(append(a, nil), append(b, c))],
     []).
step(normal_form(append(append(a, nil), append(b, c)), append(a, append(b, c))),
     rule(8),
     ['Term' = append(append(a, nil), append(b, c)),
      'Normal' = append(a, append(b, c)),
      'Next' = append(a, append(nil, append(b, c)))],
     [rewrite_once(append(append(a, nil), append(b, c)), append(a, append(nil, append(b, c))), associate_right),
      normal_form(append(a, append(nil, append(b, c))), append(a, append(b, c)))]).
step(rewrite_once(append(append(a, nil), append(b, c)), append(a, append(nil, append(b, c))), associate_right),
     rule(4),
     ['In' = append(append(a, nil), append(b, c)),
      'Out' = append(a, append(nil, append(b, c))),
      'Rule' = associate_right],
     [oriented_rule(associate_right, append(append(a, nil), append(b, c)), append(a, append(nil, append(b, c))))]).
step(oriented_rule(associate_right, append(append(a, nil), append(b, c)), append(a, append(nil, append(b, c)))),
     fact(3),
     ['X' = a, 'Y' = nil, 'Z' = append(b, c)],
     []).
step(normal_form(append(a, append(nil, append(b, c))), append(a, append(b, c))),
     rule(8),
     ['Term' = append(a, append(nil, append(b, c))),
      'Normal' = append(a, append(b, c)),
      'Next' = append(a, append(b, c))],
     [rewrite_once(append(a, append(nil, append(b, c))), append(a, append(b, c)), left_identity),
      normal_form(append(a, append(b, c)), append(a, append(b, c)))]).
step(rewrite_once(append(a, append(nil, append(b, c))), append(a, append(b, c)), left_identity),
     rule(6),
     ['A' = a, 'B' = append(nil, append(b, c)), 'New_b' = append(b, c), 'Rule' = left_identity],
     [rewrite_once(append(nil, append(b, c)), append(b, c), left_identity)]).
step(rewrite_once(append(nil, append(b, c)), append(b, c), left_identity),
     rule(4),
     ['In' = append(nil, append(b, c)), 'Out' = append(b, c), 'Rule' = left_identity],
     [oriented_rule(left_identity, append(nil, append(b, c)), append(b, c))]).
step(oriented_rule(left_identity, append(nil, append(b, c)), append(b, c)),
     fact(1),
     ['X' = append(b, c)],
     []).
step(normal_form(append(a, append(b, c)), append(a, append(b, c))),
     rule(7),
     ['Term' = append(a, append(b, c))],
     [\+ rewrite_once(append(a, append(b, c)), __anon0, __anon1)]).
step(\+ rewrite_once(append(a, append(b, c)), __anon0, __anon1), absent, [], []).
step(kbAnswer(joined_critical_pair, left_identity_assoc),
     rule(15),
     ['Name' = left_identity_assoc],
     [joined_pair(left_identity_assoc)]).
step(joined_pair(left_identity_assoc),
     rule(12),
     ['Name' = left_identity_assoc,
      'Left' = append(a, b),
      'Right' = append(nil, append(a, b)),
      'Normal' = append(a, b)],
     [critical_pair(left_identity_assoc, append(a, b), append(nil, append(a, b))),
      normal_form(append(a, b), append(a, b)),
      normal_form(append(nil, append(a, b)), append(a, b))]).
step(critical_pair(left_identity_assoc, append(a, b), append(nil, append(a, b))),
     fact(9),
     [],
     []).
step(normal_form(append(a, b), append(a, b)),
     rule(7),
     ['Term' = append(a, b)],
     [\+ rewrite_once(append(a, b), __anon0, __anon1)]).
step(\+ rewrite_once(append(a, b), __anon0, __anon1), absent, [], []).
step(normal_form(append(nil, append(a, b)), append(a, b)),
     rule(8),
     ['Term' = append(nil, append(a, b)), 'Normal' = append(a, b), 'Next' = append(a, b)],
     [rewrite_once(append(nil, append(a, b)), append(a, b), left_identity),
      normal_form(append(a, b), append(a, b))]).
step(rewrite_once(append(nil, append(a, b)), append(a, b), left_identity),
     rule(4),
     ['In' = append(nil, append(a, b)), 'Out' = append(a, b), 'Rule' = left_identity],
     [oriented_rule(left_identity, append(nil, append(a, b)), append(a, b))]).
step(oriented_rule(left_identity, append(nil, append(a, b)), append(a, b)),
     fact(1),
     ['X' = append(a, b)],
     []).
step(kbAnswer(joined_critical_pair, right_identity_assoc),
     rule(15),
     ['Name' = right_identity_assoc],
     [joined_pair(right_identity_assoc)]).
step(joined_pair(right_identity_assoc),
     rule(12),
     ['Name' = right_identity_assoc,
      'Left' = append(a, b),
      'Right' = append(a, append(nil, b)),
      'Normal' = append(a, b)],
     [critical_pair(right_identity_assoc, append(a, b), append(a, append(nil, b))),
      normal_form(append(a, b), append(a, b)),
      normal_form(append(a, append(nil, b)), append(a, b))]).
step(critical_pair(right_identity_assoc, append(a, b), append(a, append(nil, b))),
     fact(10),
     [],
     []).
step(normal_form(append(a, append(nil, b)), append(a, b)),
     rule(8),
     ['Term' = append(a, append(nil, b)), 'Normal' = append(a, b), 'Next' = append(a, b)],
     [rewrite_once(append(a, append(nil, b)), append(a, b), left_identity),
      normal_form(append(a, b), append(a, b))]).
step(rewrite_once(append(a, append(nil, b)), append(a, b), left_identity),
     rule(6),
     ['A' = a, 'B' = append(nil, b), 'New_b' = b, 'Rule' = left_identity],
     [rewrite_once(append(nil, b), b, left_identity)]).
step(rewrite_once(append(nil, b), b, left_identity),
     rule(4),
     ['In' = append(nil, b), 'Out' = b, 'Rule' = left_identity],
     [oriented_rule(left_identity, append(nil, b), b)]).
step(oriented_rule(left_identity, append(nil, b), b), fact(1), ['X' = b], []).
step(kbAnswer(joined_critical_pair, nested_assoc),
     rule(15),
     ['Name' = nested_assoc],
     [joined_pair(nested_assoc)]).
step(joined_pair(nested_assoc),
     rule(12),
     ['Name' = nested_assoc,
      'Left' = append(append(a, append(b, c)), d),
      'Right' = append(append(a, b), append(c, d)),
      'Normal' = append(a, append(b, append(c, d)))],
     [critical_pair(nested_assoc, append(append(a, append(b, c)), d), append(append(a, b), append(c, d))),
      normal_form(append(append(a, append(b, c)), d), append(a, append(b, append(c, d)))),
      normal_form(append(append(a, b), append(c, d)), append(a, append(b, append(c, d))))]).
step(critical_pair(nested_assoc, append(append(a, append(b, c)), d), append(append(a, b), append(c, d))),
     fact(11),
     [],
     []).
step(normal_form(append(append(a, append(b, c)), d), append(a, append(b, append(c, d)))),
     rule(8),
     ['Term' = append(append(a, append(b, c)), d),
      'Normal' = append(a, append(b, append(c, d))),
      'Next' = append(a, append(append(b, c), d))],
     [rewrite_once(append(append(a, append(b, c)), d), append(a, append(append(b, c), d)), associate_right),
      normal_form(append(a, append(append(b, c), d)), append(a, append(b, append(c, d))))]).
step(rewrite_once(append(append(a, append(b, c)), d), append(a, append(append(b, c), d)), associate_right),
     rule(4),
     ['In' = append(append(a, append(b, c)), d),
      'Out' = append(a, append(append(b, c), d)),
      'Rule' = associate_right],
     [oriented_rule(associate_right, append(append(a, append(b, c)), d), append(a, append(append(b, c), d)))]).
step(oriented_rule(associate_right, append(append(a, append(b, c)), d), append(a, append(append(b, c), d))),
     fact(3),
     ['X' = a, 'Y' = append(b, c), 'Z' = d],
     []).
step(normal_form(append(a, append(append(b, c), d)), append(a, append(b, append(c, d)))),
     rule(8),
     ['Term' = append(a, append(append(b, c), d)),
      'Normal' = append(a, append(b, append(c, d))),
      'Next' = append(a, append(b, append(c, d)))],
     [rewrite_once(append(a, append(append(b, c), d)), append(a, append(b, append(c, d))), associate_right),
      normal_form(append(a, append(b, append(c, d))), append(a, append(b, append(c, d))))]).
step(rewrite_once(append(a, append(append(b, c), d)), append(a, append(b, append(c, d))), associate_right),
     rule(6),
     ['A' = a,
      'B' = append(append(b, c), d),
      'New_b' = append(b, append(c, d)),
      'Rule' = associate_right],
     [rewrite_once(append(append(b, c), d), append(b, append(c, d)), associate_right)]).
step(rewrite_once(append(append(b, c), d), append(b, append(c, d)), associate_right),
     rule(4),
     ['In' = append(append(b, c), d), 'Out' = append(b, append(c, d)), 'Rule' = associate_right],
     [oriented_rule(associate_right, append(append(b, c), d), append(b, append(c, d)))]).
step(oriented_rule(associate_right, append(append(b, c), d), append(b, append(c, d))),
     fact(3),
     ['X' = b, 'Y' = c, 'Z' = d],
     []).
step(normal_form(append(a, append(b, append(c, d))), append(a, append(b, append(c, d)))),
     rule(7),
     ['Term' = append(a, append(b, append(c, d)))],
     [\+ rewrite_once(append(a, append(b, append(c, d))), __anon0, __anon1)]).
step(\+ rewrite_once(append(a, append(b, append(c, d))), __anon0, __anon1), absent, [], []).
step(normal_form(append(append(a, b), append(c, d)), append(a, append(b, append(c, d)))),
     rule(8),
     ['Term' = append(append(a, b), append(c, d)),
      'Normal' = append(a, append(b, append(c, d))),
      'Next' = append(a, append(b, append(c, d)))],
     [rewrite_once(append(append(a, b), append(c, d)), append(a, append(b, append(c, d))), associate_right),
      normal_form(append(a, append(b, append(c, d))), append(a, append(b, append(c, d))))]).
step(rewrite_once(append(append(a, b), append(c, d)), append(a, append(b, append(c, d))), associate_right),
     rule(4),
     ['In' = append(append(a, b), append(c, d)),
      'Out' = append(a, append(b, append(c, d))),
      'Rule' = associate_right],
     [oriented_rule(associate_right, append(append(a, b), append(c, d)), append(a, append(b, append(c, d))))]).
step(oriented_rule(associate_right, append(append(a, b), append(c, d)), append(a, append(b, append(c, d)))),
     fact(3),
     ['X' = a, 'Y' = b, 'Z' = append(c, d)],
     []).
step(kbAnswer(oriented_rule_count, 3),
     rule(16),
     ['Count' = 3],
     [countall(oriented_rule(__anon3, __anon4, __anon5), 3)]).
step(countall(oriented_rule(__anon3, __anon4, __anon5), 3), builtin, [], []).
step(kbAnswer(joined_critical_pair_count, 3),
     rule(17),
     ['Count' = 3],
     [countall(joined_pair(__anon6), 3)]).
step(countall(joined_pair(__anon6), 3), builtin, [], []).
step(kbAnswer(note, "a bounded completion check proves the selected critical pairs join"),
     rule(18),
     [],
     [joined_pair(nested_assoc)]).
