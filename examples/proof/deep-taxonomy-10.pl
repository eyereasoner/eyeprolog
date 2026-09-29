holds_result(test, true).
arc(check1, "C1 OK - the starting classification n0 is present.").
arc(check2, "C2 OK - the first expansion produced n1 together with side labels i1 and j1.").
arc(check3, "C3 OK - the chain reaches the midpoint n5 and still carries both side-label branches.").
arc(check4, "C4 OK - the final taxonomy step from n9 to n10 was completed.").
arc(check5, "C5 OK - once n10 is reached, the terminal class a2 is derived.").
arc(check6, "C6 OK - the success flag is raised only after the terminal class a2 is present.").
answer(report, "The test succeeds: starting from one individual classified as n0, the rules eventually classify it as n10 and then as a2.").
reason(report, "The adjacent rules mirror the Eyeling N3 deep-taxonomy-10 chain: each rule advances one taxonomy level and adds the matching side labels.").
checkPassed(report, check1).
checkPassed(report, check2).
checkPassed(report, check3).
checkPassed(report, check4).
checkPassed(report, check5).
checkPassed(report, check6).
result(report, success).

clause(2, a(ind, n0), true).
clause(3, holds_result(test, true), once(a(ind, a2))).
clause(4, a(var('X'), a2), a(var('X'), n10)).
clause(5, a(var('X'), n1), a(var('X'), n0)).
clause(6, a(var('X'), i1), a(var('X'), n0)).
clause(7, a(var('X'), j1), a(var('X'), n0)).
clause(8, a(var('X'), n2), a(var('X'), n1)).
clause(11, a(var('X'), n3), a(var('X'), n2)).
clause(14, a(var('X'), n4), a(var('X'), n3)).
clause(17, a(var('X'), n5), a(var('X'), n4)).
clause(18, a(var('X'), i5), a(var('X'), n4)).
clause(19, a(var('X'), j5), a(var('X'), n4)).
clause(20, a(var('X'), n6), a(var('X'), n5)).
clause(23, a(var('X'), n7), a(var('X'), n6)).
clause(26, a(var('X'), n8), a(var('X'), n7)).
clause(29, a(var('X'), n9), a(var('X'), n8)).
clause(32, a(var('X'), n10), a(var('X'), n9)).
clause(35, arc(check1, "C1 OK - the starting classification n0 is present."), once(a(ind, n0))).
clause(36,
       arc(check2, "C2 OK - the first expansion produced n1 together with side labels i1 and j1."),
       (once(a(ind, n1)), once(a(ind, i1)), once(a(ind, j1)))).
clause(37,
       arc(check3, "C3 OK - the chain reaches the midpoint n5 and still carries both side-label branches."),
       (once(a(ind, n5)), once(a(ind, i5)), once(a(ind, j5)))).
clause(38,
       arc(check4, "C4 OK - the final taxonomy step from n9 to n10 was completed."),
       (once(a(ind, n9)), once(a(ind, n10)))).
clause(39,
       arc(check5, "C5 OK - once n10 is reached, the terminal class a2 is derived."),
       (once(a(ind, n10)), once(a(ind, a2)))).
clause(40,
       arc(check6, "C6 OK - the success flag is raised only after the terminal class a2 is present."),
       (once(a(ind, a2)), once(holds_result(test, true)))).
clause(41,
       answer(report, "The test succeeds: starting from one individual classified as n0, the rules eventually classify it as n10 and then as a2."),
       once(holds_result(test, true))).
clause(42,
       reason(report, "The adjacent rules mirror the Eyeling N3 deep-taxonomy-10 chain: each rule advances one taxonomy level and adds the matching side labels."),
       (once(a(ind, a2)), once(holds_result(test, true)))).
clause(43, checkPassed(report, var('Check')), arc(var('Check'), anonymous(1))).
clause(44,
       result(report, success),
       (once(holds_result(test, true)),
        once(arc(check1, anonymous(1))),
        once(arc(check2, anonymous(2))),
        once(arc(check3, anonymous(3))),
        once(arc(check4, anonymous(4))),
        once(arc(check5, anonymous(5))),
        once(arc(check6, anonymous(6))))).

step(holds_result(test, true), rule(3), [], [once(a(ind, a2))]).
step(once(a(ind, a2)), builtin, [], [a(ind, a2)]).
step(a(ind, a2), rule(4), ['X' = ind], [a(ind, n10)]).
step(a(ind, n10), rule(32), ['X' = ind], [a(ind, n9)]).
step(a(ind, n9), rule(29), ['X' = ind], [a(ind, n8)]).
step(a(ind, n8), rule(26), ['X' = ind], [a(ind, n7)]).
step(a(ind, n7), rule(23), ['X' = ind], [a(ind, n6)]).
step(a(ind, n6), rule(20), ['X' = ind], [a(ind, n5)]).
step(a(ind, n5), rule(17), ['X' = ind], [a(ind, n4)]).
step(a(ind, n4), rule(14), ['X' = ind], [a(ind, n3)]).
step(a(ind, n3), rule(11), ['X' = ind], [a(ind, n2)]).
step(a(ind, n2), rule(8), ['X' = ind], [a(ind, n1)]).
step(a(ind, n1), rule(5), ['X' = ind], [a(ind, n0)]).
step(a(ind, n0), fact(2), [], []).
step(arc(check1, "C1 OK - the starting classification n0 is present."),
     rule(35),
     [],
     [once(a(ind, n0))]).
step(once(a(ind, n0)), builtin, [], [a(ind, n0)]).
step(arc(check2, "C2 OK - the first expansion produced n1 together with side labels i1 and j1."),
     rule(36),
     [],
     [once(a(ind, n1)), once(a(ind, i1)), once(a(ind, j1))]).
step(once(a(ind, n1)), builtin, [], [a(ind, n1)]).
step(once(a(ind, i1)), builtin, [], [a(ind, i1)]).
step(a(ind, i1), rule(6), ['X' = ind], [a(ind, n0)]).
step(once(a(ind, j1)), builtin, [], [a(ind, j1)]).
step(a(ind, j1), rule(7), ['X' = ind], [a(ind, n0)]).
step(arc(check3, "C3 OK - the chain reaches the midpoint n5 and still carries both side-label branches."),
     rule(37),
     [],
     [once(a(ind, n5)), once(a(ind, i5)), once(a(ind, j5))]).
step(once(a(ind, n5)), builtin, [], [a(ind, n5)]).
step(once(a(ind, i5)), builtin, [], [a(ind, i5)]).
step(a(ind, i5), rule(18), ['X' = ind], [a(ind, n4)]).
step(once(a(ind, j5)), builtin, [], [a(ind, j5)]).
step(a(ind, j5), rule(19), ['X' = ind], [a(ind, n4)]).
step(arc(check4, "C4 OK - the final taxonomy step from n9 to n10 was completed."),
     rule(38),
     [],
     [once(a(ind, n9)), once(a(ind, n10))]).
step(once(a(ind, n9)), builtin, [], [a(ind, n9)]).
step(once(a(ind, n10)), builtin, [], [a(ind, n10)]).
step(arc(check5, "C5 OK - once n10 is reached, the terminal class a2 is derived."),
     rule(39),
     [],
     [once(a(ind, n10)), once(a(ind, a2))]).
step(arc(check6, "C6 OK - the success flag is raised only after the terminal class a2 is present."),
     rule(40),
     [],
     [once(a(ind, a2)), once(holds_result(test, true))]).
step(once(holds_result(test, true)), builtin, [], [holds_result(test, true)]).
step(answer(report, "The test succeeds: starting from one individual classified as n0, the rules eventually classify it as n10 and then as a2."),
     rule(41),
     [],
     [once(holds_result(test, true))]).
step(reason(report, "The adjacent rules mirror the Eyeling N3 deep-taxonomy-10 chain: each rule advances one taxonomy level and adds the matching side labels."),
     rule(42),
     [],
     [once(a(ind, a2)), once(holds_result(test, true))]).
step(checkPassed(report, check1),
     rule(43),
     ['Check' = check1],
     [arc(check1, "C1 OK - the starting classification n0 is present.")]).
step(checkPassed(report, check2),
     rule(43),
     ['Check' = check2],
     [arc(check2, "C2 OK - the first expansion produced n1 together with side labels i1 and j1.")]).
step(checkPassed(report, check3),
     rule(43),
     ['Check' = check3],
     [arc(check3, "C3 OK - the chain reaches the midpoint n5 and still carries both side-label branches.")]).
step(checkPassed(report, check4),
     rule(43),
     ['Check' = check4],
     [arc(check4, "C4 OK - the final taxonomy step from n9 to n10 was completed.")]).
step(checkPassed(report, check5),
     rule(43),
     ['Check' = check5],
     [arc(check5, "C5 OK - once n10 is reached, the terminal class a2 is derived.")]).
step(checkPassed(report, check6),
     rule(43),
     ['Check' = check6],
     [arc(check6, "C6 OK - the success flag is raised only after the terminal class a2 is present.")]).
step(result(report, success),
     rule(44),
     [],
     [once(holds_result(test, true)),
      once(arc(check1, "C1 OK - the starting classification n0 is present.")),
      once(arc(check2, "C2 OK - the first expansion produced n1 together with side labels i1 and j1.")),
      once(arc(check3, "C3 OK - the chain reaches the midpoint n5 and still carries both side-label branches.")),
      once(arc(check4, "C4 OK - the final taxonomy step from n9 to n10 was completed.")),
      once(arc(check5, "C5 OK - once n10 is reached, the terminal class a2 is derived.")),
      once(arc(check6, "C6 OK - the success flag is raised only after the terminal class a2 is present."))]).
step(once(arc(check1, "C1 OK - the starting classification n0 is present.")),
     builtin,
     [],
     [arc(check1, "C1 OK - the starting classification n0 is present.")]).
step(once(arc(check2, "C2 OK - the first expansion produced n1 together with side labels i1 and j1.")),
     builtin,
     [],
     [arc(check2, "C2 OK - the first expansion produced n1 together with side labels i1 and j1.")]).
step(once(arc(check3, "C3 OK - the chain reaches the midpoint n5 and still carries both side-label branches.")),
     builtin,
     [],
     [arc(check3, "C3 OK - the chain reaches the midpoint n5 and still carries both side-label branches.")]).
step(once(arc(check4, "C4 OK - the final taxonomy step from n9 to n10 was completed.")),
     builtin,
     [],
     [arc(check4, "C4 OK - the final taxonomy step from n9 to n10 was completed.")]).
step(once(arc(check5, "C5 OK - once n10 is reached, the terminal class a2 is derived.")),
     builtin,
     [],
     [arc(check5, "C5 OK - once n10 is reached, the terminal class a2 is derived.")]).
step(once(arc(check6, "C6 OK - the success flag is raised only after the terminal class a2 is present.")),
     builtin,
     [],
     [arc(check6, "C6 OK - the success flag is raised only after the terminal class a2 is present.")]).
